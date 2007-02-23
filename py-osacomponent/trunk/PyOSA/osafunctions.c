/*
 *  selectors.c
 *  PyOSA
 *
 *  Created by Hamish Sanderson on 09/02/2007.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#include "osafunctions.h"


#define pyosa_errNotAnAEDesc errOSASystemError
#define pyosa_errNotAnInt errOSASystemError

#define osaInfoScriptFSRef 'fref'


static const char componentName[] = COMPONENT_NAME;

static ComponentFunctionDef componentFunctionDefs[];

static int shouldInitialize = 1;


/******************************************************************************/
// TO DO: add beginInterpreter/endInterpreter macros to handle... functions

#define beginInterpreter(scriptState) \
	PyThreadState* currentState = PyThreadState_Get(); \
	PyThreadState_Swap(scriptState->context);

#define endInterpreter() \
	PyThreadState_Swap(currentState);


#ifdef DEBUG_ON
#define printDesc(desc, msg) \
	Handle h; \
	AEPrintDescToHandle(desc, &h); \
	printf(msg ": AEDesc( %s )\n", *h);
#else
#define printDesc(desc, msg)
#endif

/******************************************************************************/
/* REQUIRED OSA FUNCTIONS */
/******************************************************************************/

/* Saving and Loading Script Data */

// (Note: OSALoadFile/OSAStoreFile invoke OSALoad/OSAStore, then call OSASetScriptInfo with 'fref' selector to set file path)

static ComponentResult handleOSAStore(CIStorageHandle ciStorage, 
									  OSAID scriptID, 
									  DescType desiredType, 
									  long modeFlags, 
									  AEDesc *resultingScriptData) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	if (desiredType != typeOSAGenericStorage) return errOSABadStorageType;
	state = getScriptState(ciStorage, scriptID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "store", "(l)",
																modeFlags);
	if (!result) return raisePythonError(ciStorage, scriptID);
	if (!AEDescX_ConvertDisown(result, resultingScriptData))
		err = pyosa_errNotAnAEDesc;
	if (!err)
		err = OSAAddStorageType(resultingScriptData->dataHandle, COMPONENT_OSTYPE);
	Py_DECREF(result);
	return err;
}


static ComponentResult handleOSALoad(CIStorageHandle ciStorage, 
									 AEDesc *scriptData, 
									 long modeFlags, 
									 OSAID *resultingScriptID) {
	OSErr err = noErr;
	DescType storageType;
	AEDesc desc;
	ScriptStateRef state;
	PyObject *result;
	
	if (scriptData->descriptorType != typeOSAGenericStorage) return errOSABadStorageType;
	err = OSAGetStorageType(scriptData->dataHandle, &storageType);
	if (err || storageType != COMPONENT_OSTYPE) return errOSABadStorageType;
	// note: OSARemoveStorageType modifies AEDescs in-place, so preserve the client-supplied AEDesc by working on a copy
	err = AEDuplicateDesc(scriptData, &desc); 
	if (err) return err;
	OSARemoveStorageType(desc.dataHandle);
	err = createScriptState(ciStorage, NULL, resultingScriptID, &state);
	if (err) return err;
	result = PyObject_CallMethod(state->scriptManager, "load", "O&l",
															   AEDescX_New, &desc,
															   modeFlags);
	if (!result) return raisePythonError(ciStorage, *resultingScriptID);
	Py_DECREF(result);
	return noErr;
}


/******************************************************************************/
/* Executing and Disposing of Scripts */


static ComponentResult handleOSAExecute(CIStorageHandle ciStorage,
										OSAID compiledScriptID,
										OSAID contextID,
										long modeFlags,
										OSAID *resultingScriptValueID) {
	ScriptStateRef state;
	PyObject *context, *result;
	
	state = getScriptState(ciStorage, compiledScriptID);
	if (!state) return errOSAInvalidID;
	context = getContextManager(ciStorage, contextID);
	if (!context) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "execute", "Ol",
																  context,
																  modeFlags);
	if (!result) return raisePythonError(ciStorage, compiledScriptID);
	createValue(ciStorage, result, state, resultingScriptValueID);
	return noErr;
}


static ComponentResult handleOSADisplay(CIStorageHandle ciStorage,
										OSAID scriptValueID,
										DescType desiredType,
										long modeFlags,
										AEDesc *resultingText) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	state = getScriptState(ciStorage, scriptValueID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "display", "O&l",
																  PyMac_BuildOSType, desiredType,
																  modeFlags);
	if (!result) return raisePythonError(ciStorage, scriptValueID);
	if (!AEDescX_ConvertDisown(result, resultingText))
		err = pyosa_errNotAnAEDesc;
	Py_DECREF(result);
	printDesc(resultingText, "OSADisplay result");
	return err;
}


static ComponentResult handleOSAScriptError(CIStorageHandle ciStorage, 
											OSType selector, 
											DescType desiredType, 
											AEDesc *resultingErrorDescription) {
	OSErr err = noErr;
	PyObject *result, *errorsModule, *errorValue;
	
	errorValue = (**ciStorage).errorValue;
	if (!errorValue) {
		fprintf(stderr, "PyOSA: OSAScriptError was called, but errorValue was NULL.\n");
		return errOSASystemError;
	}
	errorsModule = PyImport_ImportModule("pyosa_errors");
	result = PyObject_CallMethod(errorsModule, "packerror", "O&O&OO",
															PyMac_BuildOSType, selector,
															PyMac_BuildOSType, desiredType,
															errorValue,
															(**ciStorage).appscriptServices);
	if (!result) {
		PyErr_Print();
		return errOSASystemError;
	}
	if (!AEDescX_ConvertDisown(result, resultingErrorDescription))
		err = pyosa_errNotAnAEDesc;
	Py_DECREF(result);
	return noErr;
}


static ComponentResult handleOSADispose(CIStorageHandle ciStorage, 
										OSAID scriptID) {
	OSErr err = noErr;
	err = disposeScriptState(ciStorage, scriptID);
	printf("OSADispose scriptID=%i\n", scriptID);
	return err;
}


/******************************************************************************/
/* Setting and Getting Script Information */

static ComponentResult handleOSASetScriptInfo(CIStorageHandle ciStorage, 
											  OSAID scriptID, 
											  OSType selector, 
											  long value) {
	ScriptStateRef state;
	PyObject *result;
	
	state = getScriptState(ciStorage, scriptID);
	if (!state) return errOSAInvalidID;
	if (selector == osaInfoScriptFSRef)
		result = PyObject_CallMethod(state->scriptManager, "setscriptinfo", "O&l",
																			PyMac_BuildOSType, selector,
																			value);
	else
		result = PyObject_CallMethod(state->scriptManager, "setscriptfile", "(O&)",
																			PyMac_BuildFSRef, (FSRef *)value);
	if (!result) return raisePythonError(ciStorage, scriptID);
	Py_DECREF(result);
	return noErr;
}


static ComponentResult handleOSAGetScriptInfo(CIStorageHandle ciStorage, 
											  OSAID scriptID, 
											  OSType selector, 
											  long *resultingValue) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	state = getScriptState(ciStorage, scriptID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "getscriptinfo", "(O&)",
																		PyMac_BuildOSType, selector);
	if (!result) return raisePythonError(ciStorage, scriptID);
	if (PyInt_Check(result))
		*resultingValue = PyInt_AsLong(result);
	else
		err = pyosa_errNotAnInt;
	Py_DECREF(result);
	return err;
}


/******************************************************************************/
/* Manipulating the Active Function */

static ComponentResult handleOSASetActiveProc(CIStorageHandle ciStorage, 
											  OSAActiveUPP activeProc, 
											  long refCon) {
	CallbacksRef callbacks;
	
	if (!activeProc)
		activeProc = defaultActiveProc;
	callbacks = (CallbacksRef)PyCObject_AsVoidPtr((**ciStorage).callbacks);
	callbacks->activeProc = activeProc;
	callbacks->activeRefCon = refCon;
	return noErr;
}


static ComponentResult handleOSAGetActiveProc(CIStorageHandle ciStorage, 
											  OSAActiveUPP *activeProc, 
											  long *refCon) {
	CallbacksRef callbacks;
	
	callbacks = (CallbacksRef)PyCObject_AsVoidPtr((**ciStorage).callbacks);
	*activeProc = callbacks->activeProc;
	*refCon = callbacks->activeRefCon;
	return noErr;
}


/******************************************************************************/
/* OPTIONAL OSA FUNCTIONS */
/******************************************************************************/

/* Compiling Scripts */

static ComponentResult handleOSAScriptingComponentName(CIStorageHandle ciStorage, 
													   AEDesc *resultingScriptingComponentName) {
	return AECreateDesc(typeChar, 
						(void *)componentName, 
						strlen(componentName), 
						resultingScriptingComponentName);
}


static ComponentResult handleOSACompile(CIStorageHandle ciStorage, 
										const AEDesc *sourceData, 
										long modeFlags, 
										OSAID *previousAndResultingScriptID) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	if (*previousAndResultingScriptID) {
		state = getScriptState(ciStorage, *previousAndResultingScriptID);
		if (!state) return errOSAInvalidID;
	} else {
		err = createScriptState(ciStorage, NULL, previousAndResultingScriptID, &state);
		if (err) return err;
	}
	result = PyObject_CallMethod(state->scriptManager, "compile", "O&l",
																  AEDescX_NewBorrowed, sourceData,
																  modeFlags);
	if (!result) return raisePythonError(ciStorage, *previousAndResultingScriptID); // TO DO: also dispose script state?
	Py_DECREF(result);
	return noErr;
}


static ComponentResult handleOSACopyID(CIStorageHandle ciStorage, OSAID fromID, OSAID *toID) {
	return errOSABadSelector; // TO DO
}


/******************************************************************************/
/* Getting Source Data */

static ComponentResult handleOSAGetSource(CIStorageHandle ciStorage, 
										  OSAID scriptID, 
										  DescType desiredType, 
										  AEDesc *resultingSourceData) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	state = getScriptState(ciStorage, scriptID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "getsource", "(O&)",
																	PyMac_BuildOSType, desiredType);
	if (!result) return raisePythonError(ciStorage, scriptID);
	if (!AEDescX_ConvertDisown(result, resultingSourceData))
		err = pyosa_errNotAnAEDesc;
	Py_DECREF(result);
	printDesc(resultingSourceData, "OSAGetSource result");
	return err;
}


/******************************************************************************/
/* Coercing Script Values */

static ComponentResult handleOSACoerceFromDesc(CIStorageHandle ciStorage, 
											   AEDesc *scriptData, 
											   long modeFlags, 
											   OSAID *resultingScriptValueID) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	
	err = createScriptState(ciStorage, NULL, resultingScriptValueID, &state);
	if (err) return err;
	result = PyObject_CallMethod(state->scriptManager, "coercefromdesc", "O&l",
																		 AEDescX_NewBorrowed, scriptData,
																		 modeFlags);
	if (!result) return raisePythonError(ciStorage, *resultingScriptValueID); // TO DO: also dispose script state?
	Py_DECREF(result);
	return noErr;
}


static ComponentResult handleOSACoerceToDesc(CIStorageHandle ciStorage, 
											 OSAID scriptValueID, 
											 DescType desiredType, 
											 long modeFlags, 
											 AEDesc *resultingValue) {
	OSErr err = noErr;
	ScriptStateRef state;
	PyObject *result;
	
	state = getScriptState(ciStorage, scriptValueID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "coercetodesc", "O&l", 
																	   PyMac_BuildOSType, desiredType, 
																	   modeFlags);
	if (!result) return raisePythonError(ciStorage, scriptValueID);
	if (!AEDescX_ConvertDisown(result, resultingValue))
		err = pyosa_errNotAnAEDesc;
	Py_DECREF(result);
	printDesc(resultingValue, "OSACoerceToDesc result");
	return err;
}


/******************************************************************************/
/* Manipulating the Create and Send Functions */

static ComponentResult handleOSASetCreateProc(CIStorageHandle ciStorage, 
											  OSACreateAppleEventUPP createProc, 
											  long refCon) {
	CallbacksRef callbacks;
	
	if (!createProc) {
		createProc = defaultCreateProc;
		printf("OSASetCreateProc: using default proc\n");
	}
	printf("OSASetCreateProc: callbacksobj=%08x, createproc=%08x\n", (**ciStorage).callbacks, createProc);
	callbacks = (CallbacksRef)PyCObject_AsVoidPtr((**ciStorage).callbacks);
	callbacks->createProc = createProc;
	callbacks->createRefCon = refCon;
	return noErr;
}


static ComponentResult handleOSAGetCreateProc(CIStorageHandle ciStorage, 
											  OSACreateAppleEventUPP *createProc, 
											  long *refCon) {
	CallbacksRef callbacks;
	
	callbacks = (CallbacksRef)PyCObject_AsVoidPtr((**ciStorage).callbacks);
	*createProc = callbacks->createProc;
	*refCon = callbacks->createRefCon;
	return noErr;
}


static ComponentResult handleOSASetSendProc(CIStorageHandle ciStorage, 
											OSASendUPP sendProc, 
											long refCon) {
	CallbacksRef callbacks;
	
	if (!sendProc)
		sendProc = defaultSendProc;
	callbacks = (CallbacksRef)PyCObject_AsVoidPtr((**ciStorage).callbacks);
	callbacks->sendProc = sendProc;
	callbacks->sendRefCon = refCon;
	return noErr;
}


static ComponentResult handleOSAGetSendProc(CIStorageHandle ciStorage, 
											OSASendUPP *sendProc, 
											long *refCon) {
	CallbacksRef callbacks;
	
	callbacks = (CallbacksRef)PyCObject_AsVoidPtr((**ciStorage).callbacks);
	*sendProc = callbacks->sendProc;
	*refCon = callbacks->sendRefCon;
	return noErr;
}


static ComponentResult handleOSASetDefaultTarget(CIStorageHandle ciStorage, 
												 const AEAddressDesc *target) {
	return 0; // TO DO
}



/******************************************************************************/
/* Recording Scripts */

/*
static ComponentResult handleOSAStartRecording(CIStorageHandle ciStorage, 
											   OSAID *compiledScriptToModifyID) {
	return errOSABadSelector; // TO DO
}


static ComponentResult handleOSAStopRecording(CIStorageHandle ciStorage, 
											  OSAID compiledScriptID) {
	return errOSABadSelector; // TO DO
}
*/


/******************************************************************************/
/* Executing Scripts in One Step */

static ComponentResult handleOSALoadExecute(CIStorageHandle ciStorage, 
											const AEDesc *scriptData, 
											OSAID contextID, 
											long modeFlags, 
											OSAID *resultingScriptValueID) {
	return errOSABadSelector; // TO DO
}


static ComponentResult handleOSACompileExecute(CIStorageHandle ciStorage, 
											   const AEDesc *sourceData, 
											   OSAID contextID, 
											   long modeFlags, 
											   OSAID *resultingScriptValueID) {
	return errOSABadSelector; // TO DO
}


static ComponentResult handleOSADoScript(CIStorageHandle ciStorage, 
										 const AEDesc *sourceData, 
										 OSAID contextID, 
										 DescType desiredType, 
										 long modeFlags, 
										 AEDesc *resultingText) {
	return errOSABadSelector; // TO DO
}


/******************************************************************************/
/* Using Script Contexts to Handle Apple Events */

static ComponentResult handleOSASetResumeDispatchProc(CIStorageHandle ciStorage, 
													  AEEventHandlerUPP resumeDispatchProc, 
													  long refCon) {
	return 0; // TO DO
}


static ComponentResult handleOSAGetResumeDispatchProc(CIStorageHandle ciStorage, 
													  AEEventHandlerUPP *resumeDispatchProc, 
													  long *refCon) {
	return errOSABadSelector; // TO DO
}


static ComponentResult handleOSAExecuteEvent(CIStorageHandle ciStorage, 
											 const AppleEvent *theAppleEvent, 
											 OSAID contextID, 
											 long modeFlags, 
											 OSAID *resultingScriptValueID) {
	ScriptStateRef state;
	PyObject *result;
	
	printDesc(theAppleEvent, "OSAExecuteEvent event");
	state = getScriptState(ciStorage, contextID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "executeevent", "O&l",
																	   AEDescX_NewBorrowed, theAppleEvent,
																	   modeFlags);
	if (!result) return raisePythonError(ciStorage, contextID);
	return createValue(ciStorage, result, state, resultingScriptValueID);
}


static ComponentResult handleOSADoEvent(CIStorageHandle ciStorage, 
										const AppleEvent *theAppleEvent, 
										OSAID contextID, 
										long modeFlags, 
										AppleEvent *reply) {
	ScriptStateRef state;
	PyObject *result;
	
	state = getScriptState(ciStorage, contextID);
	if (!state) return errOSAInvalidID;
	result = PyObject_CallMethod(state->scriptManager, "doevent", "O&lO&",
																  AEDescX_NewBorrowed, theAppleEvent,
																  modeFlags, 
																  AEDescX_NewBorrowed, reply);
	if (!result) return raisePythonError(ciStorage, contextID);
	Py_DECREF(result);
	return noErr;
}


static ComponentResult handleOSAMakeContext(CIStorageHandle ciStorage, 
											const AEDesc *contextName, 
											OSAID parentContext, 
											OSAID *resultingContextID) {
	return errOSABadSelector;
}


/******************************************************************************/
/* REQUIRED COMPONENT MANAGER FUNCTIONS */
/******************************************************************************/

// (Note: handleComponentOpen is defined in main.c and called directly by PyOSA_main)


static ComponentResult handleComponentClose(CIStorageHandle ciStorage, 
											ComponentInstance ci) {
	return disposeComponentInstanceStorage(ciStorage);
}


static ComponentResult handleComponentCanDo(CIStorageHandle ciStorage, 
											SInt16 selector) {
	if (getComponentFunction(selector)) return true;
	return selector == kComponentOpenSelect;
}


static ComponentResult handleComponentVersion(CIStorageHandle ciStorage) {
	return COMPONENT_VERSION;
}


/******************************************************************************/
/* COMPONENT FUNCTIONS TABLE */
/******************************************************************************/

/* Macros add function pointers and UPP parameter info data to lookup table. */

#define cmFunction(name) \
	"handleComponent" #name, kComponent##name##Select, (ProcPtr)handleComponent##name, \
			kPascalStackBased \
			| RESULT_SIZE(SIZE_CODE(sizeof(ComponentResult)))

#define osaFunction(name) \
	"handleOSA" #name, kOSASelect##name, (ProcPtr)handleOSA##name, \
			kPascalStackBased \
			| RESULT_SIZE(SIZE_CODE(sizeof(ComponentResult)))

#define param(i, type) \
			| STACK_ROUTINE_PARAMETER(i, SIZE_CODE(sizeof(type)))


/* Lookup table used by getComponentFunction() to find the UPP for a component function requested by client. */

static ComponentFunctionDef componentFunctionDefs[] = {
	
	/* Required component routines */
	
	/* Note: handleComponentOpen is called directly by PyOSA_main() so isn't defined here. */

	{cmFunction(Close)
			param(1, Handle) 
			param(2, ComponentInstance)},
	
	{cmFunction(CanDo)
			param(1, Handle) 
			param(2, short)},
	
	{cmFunction(Version)
			param(1, Handle)},
	
	/* Required scripting component routines */
	
	/* Saving and Loading Script Data */
	
	{osaFunction(Store)
			param(1, Handle)
			param(2, OSAID)
			param(3, DescType)
			param(4, long)
			param(5, AEDesc *)},
	
	{osaFunction(Load)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, long)
			param(4, OSAID *)},
	
	/* Executing and Disposing of Scripts */
	
	{osaFunction(Execute)
			param(1, Handle)
			param(2, OSAID)
			param(3, OSAID)
			param(4, long)
			param(5, OSAID *)},
	
	{osaFunction(Display)
			param(1, Handle)
			param(2, OSAID)
			param(3, DescType)
			param(4, long)
			param(5, AEDesc *)},
	
	{osaFunction(ScriptError)
			param(1, Handle)
			param(2, OSType)
			param(3, DescType)
			param(4, AEDesc *)},
	
	{osaFunction(Dispose)
			param(1, Handle)
			param(2, OSAID)},
	
	/* Setting and Getting Script Information */
	
	{osaFunction(SetScriptInfo)
			param(1, Handle)
			param(2, OSAID)
			param(3, OSType)
			param(4, long)},
	
	{osaFunction(GetScriptInfo)
			param(1, Handle)
			param(2, OSAID)
			param(3, OSType)
			param(4, long *)},
	
	/* Manipulating the Active Function */
	
	{osaFunction(SetActiveProc)
			param(1, Handle)
			param(2, OSAActiveUPP)
			param(3, long)},
	
	{osaFunction(GetActiveProc)
			param(1, Handle)
			param(2, OSAActiveUPP *)
			param(3, long *)},
	
	/* Optional Scripting Component Routines */
	
	/* Compiling Scripts */
	
	{osaFunction(ScriptingComponentName)
			param(1, Handle)
			param(2, AEDesc *)},
	
	{osaFunction(Compile)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, long)
			param(4, OSAID *)},
	
	{osaFunction(CopyID)
			param(1, Handle)
			param(2, OSAID)
			param(3, OSAID *)},
	
	/* Getting Source Data */
	
	{osaFunction(GetSource)
			param(1, Handle)
			param(2, OSAID)
			param(3, DescType)
			param(4, AEDesc *)},
	
	/* Coercing Script Values */
	
	{osaFunction(CoerceFromDesc)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, long)
			param(4, OSAID *)},
	
	{osaFunction(CoerceToDesc)
			param(1, Handle)
			param(2, OSAID)
			param(3, DescType)
			param(4, long)
			param(5, AEDesc *)},
	
	/* Manipulating the Create and Send Functions */
	
	{osaFunction(SetCreateProc)
			param(1, Handle)
			param(2, OSACreateAppleEventUPP)
			param(3, long)},
	
	{osaFunction(GetCreateProc)
			param(1, Handle)
			param(2, OSACreateAppleEventUPP *)
			param(3, long *)},
	
	{osaFunction(SetSendProc)
			param(1, Handle)
			param(2, OSASendUPP)
			param(3, long)},
	
	{osaFunction(GetSendProc)
			param(1, Handle)
			param(2, OSASendUPP *)
			param(3, long *)},
	
	{osaFunction(SetDefaultTarget)
			param(1, Handle)
			param(2, AEAddressDesc *)},
	
	/* Recording Scripts */
	/*
	{osaFunction(StartRecording)
			param(1, Handle)
			param(2, OSAID *)},
	
	{osaFunction(StopRecording)
			param(1, Handle)
			param(2, OSAID)},
	*/
	/* Executing Scripts in One Step */
	
	{osaFunction(LoadExecute)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, OSAID)
			param(4, long)
			param(5, OSAID *)},
	
	{osaFunction(CompileExecute)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, OSAID)
			param(4, long)
			param(5, OSAID *)},
	
	{osaFunction(DoScript)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, OSAID)
			param(4, DescType)
			param(5, long)
			param(6, AEDesc *)},
	
	/* Using Script Contexts to Handle Apple Events */
			
	{osaFunction(SetResumeDispatchProc)
			param(1, Handle)
			param(2, AEEventHandlerUPP)
			param(3, long)},
	
	{osaFunction(GetResumeDispatchProc)
			param(1, Handle)
			param(2, AEEventHandlerUPP *)
			param(3, long *)},
	
	{osaFunction(ExecuteEvent)
			param(1, Handle)
			param(2, AppleEvent *)
			param(3, OSAID)
			param(4, long)
			param(5, OSAID *)},
	
	{osaFunction(DoEvent)
			param(1, Handle)
			param(2, AppleEvent *)
			param(3, OSAID)
			param(4, long)
			param(5, AppleEvent *)},
	
	{osaFunction(MakeContext)
			param(1, Handle)
			param(2, AEDesc *)
			param(3, OSAID)
			param(4, OSAID *)},
	
	{NULL, 0, NULL, 0, NULL}
};

#undef cmFunction
#undef osaFunction
#undef param

/* Function to create the UPPs stored in above table. */

void initializeComponentFunctions(void) {
	ComponentFunctionDef functionDef;
	int i = 0;
	
	while ((functionDef = componentFunctionDefs[i]).name != NULL) {
		componentFunctionDefs[i].componentFunctionUPP = NewComponentFunctionUPP(functionDef.procPtr, 
																				functionDef.procInfo);
		i++;
	}
}


ComponentFunctionUPP getComponentFunction(SInt16 selector) {
	ComponentFunctionDef functionDef;
	int i = 0;
	
	if (shouldInitialize) {
		initializeComponentFunctions();
		shouldInitialize = 0;
	}
	while ((functionDef = componentFunctionDefs[i]).name) {
		if (functionDef.selector == selector) {
			#ifdef DEBUG_ON
			printf("PyOSA: calling %s()\n", functionDef.name);
			#endif
			return functionDef.componentFunctionUPP;
		}
		i++;
	}
	return NULL;
}


/**********************************************************************/

#undef beginInterpreter
#undef endInterpreter
