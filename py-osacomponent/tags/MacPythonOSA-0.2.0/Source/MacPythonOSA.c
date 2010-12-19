/* 
MacPythonOSA.c -- A thin C wrapper that forwards incoming OSA component calls to embedded Python controller module; also exports several functions used by controller module.

(C) 2005 HAS

--------------------------------------------------------------------------------

Many thanks to: Bill Fancher, Donovan Preston, Brent Simmons
*/


#include <Carbon/Carbon.h>
#include <Python/Python.h>
#include <Python/pymactoolbox.h>

#define DEBUG_ON 1

#define COMPONENT_IDENTIFIER "org.python.macpythonosa"
#define COMPONENT_VERSION 0x00010000


/******************************************************************************/
/* Type definitions */
/******************************************************************************/

/* Stores the state for a single component instance; see componentOpen(). */
typedef struct { 
	PyObject *controller;
} CIStorageType, **CIStorageHandle;


/* Stores all the information describing a single component function. */
typedef struct {
	char *name; /* name of function; used for error reporting and delegating to component module */
	int shouldDelegate; /* indicates if function is handled here or by the controller module */
	SInt16 selector; /* the selector that requests this function */
	ProcPtr procPtr; /* the function */
	ProcInfoType procInfo; /* parameter info used to construct a UPP */
	ComponentFunctionUPP componentFunctionUPP; /* the function UPP; created at startup */
} ComponentFunctionDef;


/******************************************************************************/
/* Prototypes */
/******************************************************************************/

static ComponentFunctionDef componentFunctionDefs[];

static void initializeComponentFunctionUPPs(void);
static void finalizeComponentFunctionUPPs(void);


/******************************************************************************/
/* Exported functions; used by Python controller module */
/******************************************************************************/

static PyObject* cobjectToInt(PyObject *self, PyObject *args) {
	/* TEST - Converts CObject to Python int; used by controller for logging test messages. */
	PyObject *ptrObj;
	unsigned long res;
	
	if (!PyArg_ParseTuple(args, "O",
						  &ptrObj))
		return NULL;
	if (!PyCObject_Check(ptrObj)) {
		PyErr_SetString(PyExc_TypeError, "Not a CObject.");
		return NULL;
	}
	res = (unsigned long)PyCObject_AsVoidPtr(ptrObj);
	return Py_BuildValue("k",
						 res);
}


/**************************************/
/* Used by mcpy_store to convert FSRef pointer from Python int to Carbon.File.FSRef.
(OSALoadFile assigns script's file - selector 'fref' - via OSASetScriptInfo.) */

static PyObject* intToFSRef(PyObject *self, PyObject *args) {
	long intPtr;
	
	if (!PyArg_ParseTuple(args, "l",
						  &intPtr))
		return NULL;
	return Py_BuildValue("O&",
						 PyMac_BuildFSRef, (FSRef *)intPtr);
}


/* Idle callback used by invokeSendUPP() (Code lifted from Carbon.AE.) */

static Boolean aeIdleProc(EventRecord *theEvent, SInt32 *sleepTime, RgnHandle *mouseRgn) {
	if (PyOS_InterruptOccurred())
		return 1;
	return 0;
}

AEIdleUPP aeIdleUPP;


/**************************************/
/* Default callbacks; used by component if client doesn't supply its own. */

static OSErr defaultOSAActiveProc(void) {
	// TO CHECK: Apple docs say "A scripting componentês default active function allows a user to cancel script execution by pressing Command-period and calls WaitNextEvent to give other processes time", but I'm guessing we don't need to call WaitNextEvent in OS X.
	if (PyOS_InterruptOccurred())
		return -128;
	return noErr;
}

OSAActiveUPP defaultOSAActiveUPP;


// TO CHECK: do following return appropriate values?

static PyObject* getDefaultActiveUPP(PyObject *self, PyObject *args) {
	return PyCObject_FromVoidPtr((void *)defaultOSAActiveUPP, NULL);
}

static PyObject* getDefaultCreateAppleEventUPP(PyObject *self, PyObject *args) {
	return PyCObject_FromVoidPtr(NULL, NULL);
}

static PyObject* getDefaultSendUPP(PyObject *self, PyObject *args) {
	return PyCObject_FromVoidPtr(NULL, NULL);
}

static PyObject* getDefaultResumeDispatchUPP(PyObject *self, PyObject *args) {
	return PyCObject_FromVoidPtr((void *)kOSAUseStandardDispatch, NULL);
}


/**************************************/
/* Functions to invoke callback functions (UPPs) supplied by client. */

// TO CHECK: what is correct thing to do when UPP is null?

static PyObject* invokeActiveUPP(PyObject *self, PyObject *args) {
	OSErr err = noErr;
	PyObject *ptrObj;
	OSAActiveUPP activeUPP;
	long refCon;
	
	if (!PyArg_ParseTuple(args, "Ol",
							&ptrObj,
							&refCon))
		return NULL;
	if (!PyCObject_Check(ptrObj)) {
		PyErr_SetString(PyExc_TypeError, "Not a CObject.");
		return NULL;
	}
	activeUPP = (OSAActiveUPP)PyCObject_AsVoidPtr(ptrObj);
	if (activeUPP) {
		err = InvokeOSAActiveUPP(refCon, activeUPP);
	} else {
		err = defaultOSAActiveProc();
	}
	return Py_BuildValue("l",
						err);
}

								
static PyObject* invokeCreateAppleEventUPP(PyObject *self, PyObject *args) {
	PyObject *ptrObj;
	OSACreateAppleEventUPP createAppleEventUPP;
	long refCon;
	OSErr err = noErr;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEAddressDesc target;
	AEReturnID returnID;
	AETransactionID transactionID;
	AppleEvent result;
	
	if (!PyArg_ParseTuple(args, "O&O&O&hlOl",
								PyMac_GetOSType, &theAEEventClass,
								PyMac_GetOSType, &theAEEventID,
								AEDesc_Convert, &target,
								&returnID,
								&transactionID,
								&ptrObj,
								&refCon))
		return NULL;
	if (!PyCObject_Check(ptrObj)) {
		PyErr_SetString(PyExc_TypeError, "Not a CObject.");
		return NULL;
	}
	createAppleEventUPP = (OSACreateAppleEventUPP)PyCObject_AsVoidPtr(ptrObj);
	if (createAppleEventUPP) {
		err = InvokeOSACreateAppleEventUPP(theAEEventClass,
											theAEEventID,
											&target,
											returnID,
											transactionID,
											&result,
											refCon,
											createAppleEventUPP);
	} else {
		err = AECreateAppleEvent(theAEEventClass,
									theAEEventID,
									&target,
									returnID,
									transactionID,
									&result);
	}
	if (err != noErr)
		return PyMac_Error(err);
	return Py_BuildValue("O&",
						AEDesc_New, &result);
}


static PyObject* invokeSendUPP(PyObject *self, PyObject *args) {
	PyObject *ptrObj;
	OSASendUPP sendUPP;
	long refCon;
	OSErr err = noErr;
	AppleEvent theAppleEvent, reply;
	AESendMode sendMode;
	AESendPriority sendPriority;
	long timeOutInTicks;
	
	if (!PyArg_ParseTuple(args, "O&lhlOl",
							AEDesc_Convert, &theAppleEvent,
							&sendMode,
							&sendPriority,
							&timeOutInTicks,
							&ptrObj,
							&refCon))
		return NULL;
	if (!PyCObject_Check(ptrObj)) {
		PyErr_SetString(PyExc_TypeError, "Not a CObject.");
		return NULL;
	}
	sendUPP = (OSASendUPP)PyCObject_AsVoidPtr(ptrObj);
	if (sendUPP) {
		err = InvokeOSASendUPP(&theAppleEvent,
								&reply,
								sendMode,
								sendPriority,
								timeOutInTicks,
								aeIdleUPP,
								(AEFilterUPP)0,
								refCon,
								sendUPP);
	} else {
		err = AESend(&theAppleEvent,
						&reply,
						sendMode,
						sendPriority,
						timeOutInTicks,
						aeIdleUPP,
						(AEFilterUPP)0);
	}
	if (err != noErr)
		return PyMac_Error(err);
	return Py_BuildValue("O&",
						AEDesc_New, &reply);
}


static PyObject* invokeEventHandlerUPP(PyObject *self, PyObject *args) { 
	/* Used by resume dispatch. */
	OSErr err = noErr;
	AppleEvent theAppleEvent, reply;
	PyObject *ptrObj;
	AEEventHandlerUPP eventHandlerUPP;
	long refCon;
	
	if (!PyArg_ParseTuple(args, "O&Ol",
							AEDesc_Convert, &theAppleEvent,
							&ptrObj,
							&refCon))
		return NULL;
	if (!PyCObject_Check(ptrObj)) {
		PyErr_SetString(PyExc_TypeError, "Not a CObject.");
		return NULL;
	}
	eventHandlerUPP = (AEEventHandlerUPP)PyCObject_AsVoidPtr(ptrObj);
	err = InvokeAEEventHandlerUPP(&theAppleEvent,
									&reply,
									refCon,
									eventHandlerUPP); // TO FIX: what to do when UPP is kOSAUseStandardDispatch/kOSANoDispatch? InvokeAEEventHandlerUPP() just seems to crash.
	/* Notes:
		- resumeDispatchProc constants:
			kOSAUseStandardDispatch = kAEUseStandardDispatch = 0xFFFFFFFF # tells AEM to dispatch the event using standard Apple event dispatching
			kOSANoDispatch = kAENoDispatch = 0x00000000 # tells AEM that processing of event is complete and it does not need to be dispatched
		- refCon constant:
			kOSADontUsePhac = 1 # used in conjunction with kOSAUseStandardDispatch; causes AEM to bypass special event handlers and send event straight to standard event handlers (avoids possible circular calls where special event handler would send the event straight back to the script that just forwarded it)
	*/
	if (err != noErr)
		return PyMac_Error(err);
	return Py_BuildValue("O&",
						AEDesc_New, &reply);
}


/**************************************/
/* Manipulate generic storage descriptors; used by controller.handleOSALoad(), controller.handleOSAStore() */

static PyObject* addStorageType(PyObject *self, PyObject *args) {
	OSErr err = noErr;
	AEDesc scriptData;
	DescType desiredType;
	
	if (!PyArg_ParseTuple(args, "O&O&",
							AEDesc_Convert, &scriptData,
							PyMac_GetOSType, &desiredType))
		return NULL;
	err = OSAAddStorageType(scriptData.dataHandle, desiredType);
	if (err != noErr)
		return PyMac_Error(err);
	Py_INCREF(Py_None);
	return Py_None;
}


static PyObject* getStorageType(PyObject *self, PyObject *args) {
	OSErr err = noErr;
	AEDesc scriptData;
	DescType desiredType;
	
	if (!PyArg_ParseTuple(args, "O&",
							AEDesc_Convert, &scriptData))
		return NULL;
	err = OSAGetStorageType(scriptData.dataHandle, &desiredType);
	if (err != noErr)
		return PyMac_Error(err);
	return Py_BuildValue("O&",
							PyMac_BuildOSType, desiredType);
}


static PyObject* removeStorageType(PyObject *self, PyObject *args) {
	OSErr err = noErr;
	AEDesc scriptData;
	
	if (!PyArg_ParseTuple(args, "O&",
							AEDesc_Convert, &scriptData))
		return NULL;
	err = OSARemoveStorageType(scriptData.dataHandle);
	if (err != noErr)
		return PyMac_Error(err);
	Py_INCREF(Py_None);
	return Py_None;
}


/**************************************/
/* Return path to host application; used to retrieve terminology. */

static PyObject* pathToHost(PyObject *self, PyObject *args) {
	OSErr err = noErr;
	ProcessSerialNumber psn;
	FSRef location;
	char path[PATH_MAX];
	
	err = GetCurrentProcess(&psn);
	if (err == noErr)
		err = GetProcessBundleLocation(&psn, &location);
	if (err == noErr)
		err = FSRefMakePath(&location, (UInt8*)path, PATH_MAX);
	if (err != noErr)
		return PyMac_Error(err);
	return PyUnicode_DecodeUTF8(path, strlen(path), "strict");
}


/**************************************/
/* Export mcpy_support functions. */

static PyMethodDef mcpy_supportFunctions[] = {
	{"cobjectToInt", cobjectToInt, METH_VARARGS, 
			"cobjectToInt(CObject ptrObj) -> long result"}, // TEST
			
	{"intToFSRef", intToFSRef, METH_VARARGS, 
			"intToFSRef(long intPtr) -> FSRef fileRef"},
	
	{"defaultActiveProc", getDefaultActiveUPP, METH_NOARGS, 
			"defaultActiveProc() -> CObject ptrObj"},
	{"defaultCreateAppleEventProc", getDefaultCreateAppleEventUPP, METH_NOARGS, 
			"defaultCreateAppleEventProc() -> CObject ptrObj"},
	{"defaultSendProc", getDefaultSendUPP, METH_NOARGS, 
			"defaultSendProc() -> CObject ptrObj"},
	{"defaultResumeDispatchProc", getDefaultResumeDispatchUPP, METH_NOARGS, 
			"defaultResumeDispatchProc() -> CObject ptrObj"},
	
	{"invokeActiveUPP", invokeActiveUPP, METH_VARARGS, 
			"invokeActiveUPP(CObject ptrObj, long refCon) -> None)"},
	{"invokeCreateAppleEventUPP", invokeCreateAppleEventUPP, METH_VARARGS, 
			"invokeCreateAppleEventUPP(AEEventClass theAEEventClass, AEEventID theAEEventID, AEAddressDesc target, AEReturnID returnID, AETransactionID transactionID, CObject ptrObj, long refCon) -> AppleEvent result"},
	{"invokeSendUPP", invokeSendUPP, METH_VARARGS, 
			"invokeSendUPP(AEDesc theAppleEvent, AESendMode sendMode, AESendPriority sendPriority, long timeOutInTicks, CObject ptrObj, long refCon) -> AEDesc reply"},
	{"invokeEventHandlerUPP", invokeEventHandlerUPP, METH_VARARGS, 
			"invokeEventHandlerUPP(AppleEvent theAppleEvent, AppleEvent reply, CObject ptrObj, long refCon) -> None"},
	
	{"addStorageType", addStorageType, METH_VARARGS, 
			"addStorageType(AEDesc, OSType) -> None"},
	{"getStorageType", getStorageType, METH_VARARGS, 
			"getStorageType(AEDesc) -> OSType"},
	{"removeStorageType", removeStorageType, METH_VARARGS, 
			"removeStorageType(AEDesc) -> None"},
	
	{"pathToHost", pathToHost, METH_NOARGS, 
			"pathToHost() -> UInt8[] path"},
	
	{NULL, NULL, 0, NULL}
};


/******************************************************************************/
/* Support functions; used by handleOSA...() functions below */
/******************************************************************************/

static ComponentResult reportComponentError(CIStorageHandle ciStorage, char *name) {
	/* Deal with exceptions deliberately or accidentally raised in controller module. */
	PyObject *controllerErrorModule, *controllerErrorClass, *errorType, *errorValue, *errorTraceback, *macOSErrorNumber;
	int isComponentError;
	long err;
	
	if ((controllerErrorModule = PyImport_AddModule("mcpy_error")) == NULL ||
			(controllerErrorClass = PyObject_GetAttrString(controllerErrorModule, "ComponentError")) == NULL) {
		fprintf(stderr, "MacPythonOSA unexpectedly errored: can't get mcpy_error.ComponentError class.");
		return errOSASystemError;
	}
	isComponentError = PyErr_ExceptionMatches(controllerErrorClass);
	Py_DECREF(controllerErrorClass);
	if (isComponentError) { 
		/* It's a component error deliberately raised by controller, so forward it to client. */
		PyErr_Fetch(&errorType, &errorValue, &errorTraceback);
		macOSErrorNumber = PyObject_GetAttrString(errorValue, "macOSError");
		#ifdef DEBUG_ON
		fprintf(stderr, "A ComponentError exception was deliberately raised:\n==========\n");
		PyErr_Restore(errorType, errorValue, errorTraceback);
		PyErr_Print();
		fprintf(stderr, "\n==========\n");
		#else
		Py_DECREF(errorType);
		Py_XDECREF(errorValue);
		Py_XDECREF(errorTraceback);
		#endif
		if (macOSErrorNumber == NULL) {
			fprintf(stderr, "MacPythonOSA unexpectedly errored: can't get ComponentError.macOSErrorNumber\n");
			return errOSASystemError;
		}
		err = PyInt_AsLong(macOSErrorNumber);
		Py_DECREF(macOSErrorNumber);
		return err;
	} else { 
		/* It's an unexpected error in controller (sloppy!), so print traceback to stderr and return general errOSASystemError. */
		fprintf(stderr, "MacPythonOSA controller.%s() unexpectedly errored:\n", name);
		PyErr_Print();
		fprintf(stderr, "\n\n");
		return errOSASystemError;
	}
}


/******************************************************************************/
/* OSA component callbacks; these forward client's calls to Python controller module */
/******************************************************************************/

/* Macros to retrieve and bind the module callback function, prepare its arguments and process its results: */

/* Declares handler and res variables and binds appropriate controller module function to handler variable: */
#define macro_bindHandler(name) \
	PyObject *handler, *res; \
	handler = PyObject_GetAttrString((**ciStorage).controller, #name); \
	if (!(handler && PyCallable_Check(handler))) { \
		fprintf(stderr, "MacPythonOSA unexpectedly errored: controller.%s() doesn't exist or isn't callable\n", #name); \
		return badComponentSelector; \
	}


/* Duplicates an argument containing data supplied as AEDesc, binding the duplicate AEDesc to tempArgDesc variable. 
		Prevents client and Python arguing over ownership/deallocation of the original (see NOTES.txt). TO DO: get rid of this.*/
#define macro_bindTempArgDesc(arg) \
	AEDesc tempArgDesc; \
	if (AEDuplicateDesc(arg, &tempArgDesc)) \
		return errOSASystemError;


/* If controller function raised a deliberate or accidental exception, handles it and returns a MacOS error code. */
#define _macro_checkForComponentError(name) \
	if (res == NULL) { \
		return reportComponentError(ciStorage, #name); \
	}


/* Clean up and return when the caller takes no result. */
#define macro_resToNone(name) \
	_macro_checkForComponentError(name); \
	Py_DECREF(res); \
	return noErr;


/* Clean up and return when the caller takes a number as result. */
/* TO DO: check PyInt is in valid range for a long/unsigned long? */
#define _macro_resToNum(name, resultVar, func) \
	_macro_checkForComponentError(name); \
	if (!PyInt_Check(res)) { \
		Py_DECREF(res); \
		fprintf(stderr, "MacPythonOSA unexpectedly errored: controller.%s() didn't return an int.\n", #name); \
		return errOSASystemError; \
	} \
	*resultVar = func(res); \
	Py_DECREF(res); \
	return noErr;


/* Clean up and return when the caller takes a long as result. */
#define macro_resToLong(name, resultVar) _macro_resToNum(name, resultVar, PyInt_AsLong)


/* Clean up and return when the caller takes an OSAID as result. */
#define macro_resToOSAID(name, resultVar) _macro_resToNum(name, resultVar, PyInt_AsUnsignedLongMask)


/* Clean up and return when the caller takes an AEDesc as result (see NOTES.txt regarding AEDesc duplication; TO DO: get rid of this). */
#define macro_resToAEDesc(name, resultVar) \
	_macro_checkForComponentError(name); \
	AEDesc tempResultDesc; \
	if (!AEDesc_Convert(res, &tempResultDesc)) { \
		Py_DECREF(res); \
		fprintf(stderr, "MacPythonOSA unexpectedly errored: controller.%s() didn't return an AEDesc.\n", #name); \
		return errOSASystemError; \
	} \
	if (AEDuplicateDesc(&tempResultDesc, resultVar)) { \
		Py_DECREF(res); \
		return errOSASystemError; \
	} \
	Py_DECREF(res); \
	return noErr;


/* Code for handleOSASet...Proc() functions. */
#define macro_storeUPP(name, ptrArg, longArg) \
	PyObject *ptrObj; \
	ptrObj = PyCObject_FromVoidPtr((void *)ptrArg, NULL); \
	macro_bindHandler(name); \
	res = PyObject_CallFunction(handler, "Ol", \
								ptrObj, \
								longArg); \
	macro_resToNone(handleOSASetActiveProc);


/* Code for handleOSAGet...Proc() functions. */
#define macro_fetchUPP(name, uppType, uppResult, longResult) \
	macro_bindHandler(name); \
	res = PyObject_CallFunction(handler, NULL); \
	_macro_checkForComponentError(name); \
	if (!PyTuple_Check(res) || PyTuple_Size(res) != 2) { \
		Py_DECREF(res); \
		fprintf(stderr, "MacPythonOSA unexpectedly errored: controller.%s() didn't return a (CObject, int) tuple.\n", #name); \
		return errOSASystemError; \
	} \
	PyObject *ptrObj, *longObj; \
	ptrObj = PyTuple_GetItem(res, 0); \
	longObj = PyTuple_GetItem(res, 1); \
	if (!(PyCObject_Check(ptrObj) && PyInt_Check(longObj))) { \
		Py_DECREF(res); \
		fprintf(stderr, "MacPythonOSA unexpectedly errored: controller.%s() didn't return a (CObject, int) tuple.\n", #name); \
		return errOSASystemError; \
	} \
	*uppResult = (uppType)PyCObject_AsVoidPtr(ptrObj); \
	*longResult = PyInt_AsLong(longObj); \
	Py_DECREF(res); \
	return noErr;


/**************************************/
/* Required scripting component routines */

/* Saving and Loading Script Data */
// Note: OSALoadFile, OSAStoreFile invoke these, then use OSASetScriptInfo to specify file path ('fref')

static ComponentResult handleOSAStore(CIStorageHandle ciStorage, OSAID scriptID, DescType desiredType, long modeFlags, AEDesc *resultingScriptData) {
	/* Serialises a stored script. */
	/* Calls controller.handleOSAStore(OSAID scriptID, DescType desiredType, long modeFlags) -> AEDesc resultingScriptData */
	macro_bindHandler(handleOSAStore);
	res = PyObject_CallFunction(handler, "kO&l", 
								scriptID, 
								PyMac_BuildOSType, desiredType, 
								modeFlags);
	macro_resToAEDesc(handleOSAStore, resultingScriptData);
}

static ComponentResult handleOSALoad(CIStorageHandle ciStorage, AEDesc *scriptData, long modeFlags, OSAID *resultingScriptID) {
	/* Reconstitutes and stores a serialised script. */
	/* Calls controller.handleOSALoad(AEDesc scriptData, long modeFlags) -> OSAID resultingScriptID */
	macro_bindTempArgDesc(scriptData);
	macro_bindHandler(handleOSALoad);
	res = PyObject_CallFunction(handler, "O&l",
								AEDesc_New, &tempArgDesc,
								modeFlags);
	macro_resToOSAID(handleOSALoad, resultingScriptID);
}


/* Executing and Disposing of Scripts */

static ComponentResult handleOSAExecute(CIStorageHandle ciStorage, OSAID compiledScriptID, OSAID contextID, long modeFlags, OSAID *resultingScriptValueID) {
	/* Executes a stored script; may use fresh or existing state. Script's result is stored in script store under a new ID. */
	/* Calls controller.handleOSAExecute(OSAID compiledScriptID, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID */
	macro_bindHandler(handleOSAExecute);
	res = PyObject_CallFunction(handler, "kkl", 
								compiledScriptID,
								contextID,
								modeFlags);
	macro_resToOSAID(handleOSAExecute, resultingScriptValueID);
}


static ComponentResult handleOSADisplay(CIStorageHandle ciStorage, OSAID scriptValueID, DescType desiredType, long modeFlags, AEDesc *resultingText) {
	/* Displays a result value stored in script store. */
	/* Calls controller.handleOSADisplay(OSAID scriptValueID, DescType desiredType, long modeFlags) -> AEDesc resultingText */
	macro_bindHandler(handleOSADisplay);
	res = PyObject_CallFunction(handler, "kO&l", 
								scriptValueID,
								PyMac_BuildOSType, desiredType,
								modeFlags);
	macro_resToAEDesc(handleOSADisplay, resultingText);
}


static ComponentResult handleOSAScriptError(CIStorageHandle ciStorage, OSType selector, DescType desiredType, AEDesc *resultingErrorDescription) {
	/* Returns detailed information on why a script failed to compile, execute or handle an Apple event. */
	/* Calls controller.handleOSAScriptError(OSType selector, DescType desiredType) -> AEDesc resultingErrorDescription */
	macro_bindHandler(handleOSAScriptError);
	res = PyObject_CallFunction(handler, "O&O&", 
								PyMac_BuildOSType, selector,
								PyMac_BuildOSType, desiredType);
	macro_resToAEDesc(handleOSAScriptError, resultingErrorDescription);
}


static ComponentResult handleOSADispose(CIStorageHandle ciStorage, OSAID scriptID) {
	/* Deletes a stored script. */
	/* Calls controller.handleOSADispose(OSAID scriptID) -> None */
	macro_bindHandler(handleOSADispose);
	res = PyObject_CallFunction(handler, "(k)",
								scriptID);
	macro_resToNone(handleOSADispose);
}


/* Setting and Getting Script Information */

static ComponentResult handleOSASetScriptInfo(CIStorageHandle ciStorage, OSAID scriptID, OSType selector, long value) {
	/* Calls controller.handleOSASetScriptInfo(OSAID scriptID, OSType selector, long value) -> None */
	macro_bindHandler(handleOSASetScriptInfo);
	res = PyObject_CallFunction(handler, "kO&l", 
								scriptID,
								PyMac_BuildOSType, selector,
								value);
	macro_resToNone(handleOSASetScriptInfo);
}


static ComponentResult handleOSAGetScriptInfo(CIStorageHandle ciStorage, OSAID scriptID, OSType selector, long *result) {
	/* Calls controller.handleOSAGetScriptInfo(OSAID scriptID, OSType selector) -> long result */
	macro_bindHandler(handleOSAGetScriptInfo);
	res = PyObject_CallFunction(handler, "kO&", 
								scriptID,
								PyMac_BuildOSType, selector);
	macro_resToLong(handleOSAGetScriptInfo, result);
}


// create a struct

/********/
/* Manipulating the Active Function */

static ComponentResult handleOSASetActiveProc(CIStorageHandle ciStorage, OSAActiveUPP activeProc, long refCon) {
	/* Calls controller.handleOSASetActiveProc(OSAActiveUPP activeProc, long refCon) -> None */
	macro_storeUPP(handleOSASetActiveProc, activeProc, refCon);
}


static ComponentResult handleOSAGetActiveProc(CIStorageHandle ciStorage, OSAActiveUPP *activeProc, long *refCon) {
	/* Calls controller.handleOSAGetActiveProc() -> (OSAActiveUPP activeProc, long refCon) */
	macro_fetchUPP(handleOSAGetActiveProc, OSAActiveUPP, activeProc, refCon);
}


/**************************************/
/* Optional Scripting Component Routines */

/* Compiling Scripts */

static ComponentResult handleOSAScriptingComponentName(CIStorageHandle ciStorage, AEDesc *resultingScriptingComponentName) {
	/* Calls controller.handleOSAScriptingComponentName() -> AEDesc resultingScriptingComponentName */
	macro_bindHandler(handleOSAScriptingComponentName);
	res = PyObject_CallFunction(handler, NULL);
	macro_resToAEDesc(handleOSAScriptingComponentName, resultingScriptingComponentName);
}


static ComponentResult handleOSACompile(CIStorageHandle ciStorage, const AEDesc *sourceData, long modeFlags, OSAID *previousAndResultingScriptID) {
	/* Calls controller.handleOSACompile(AEDesc sourceData, long modeFlags, OSAID previousScriptID) -> OSAID resultingScriptID */
	macro_bindTempArgDesc(sourceData);
	macro_bindHandler(handleOSACompile);
	res = PyObject_CallFunction(handler, "O&lk",
								AEDesc_New, &tempArgDesc,
								modeFlags,
								*previousAndResultingScriptID);
	macro_resToOSAID(handleOSACompile, previousAndResultingScriptID);
}


static ComponentResult handleOSACopyID(CIStorageHandle ciStorage, OSAID fromID, OSAID *toID) {
	/* Calls controller.handleOSACopyID(OSAID fromID, OSAID toID) -> OSAID toID */
	macro_bindHandler(handleOSACopyID);
	res = PyObject_CallFunction(handler, "kk", 
								fromID,
								*toID);
	macro_resToOSAID(handleOSACopyID, toID);
}


/* Getting Source Data */

static ComponentResult handleOSAGetSource(CIStorageHandle ciStorage, OSAID scriptID, DescType desiredType, AEDesc *resultingSourceData) {
	/* Calls controller.handleOSAGetSource(OSAID scriptID, DescType desiredType) -> AEDesc resultingSourceData */
	macro_bindHandler(handleOSAGetSource);
	res = PyObject_CallFunction(handler, "kO&", 
								scriptID,
								PyMac_BuildOSType, desiredType);
	macro_resToAEDesc(handleOSAGetSource, resultingSourceData);
}


/* Coercing Script Values */

static ComponentResult handleOSACoerceFromDesc(CIStorageHandle ciStorage, AEDesc *scriptData, long modeFlags, OSAID *resultingScriptValueID) {
	/* Calls controller.handleOSACoerceFromDesc(AEDesc scriptData, long modeFlags) -> OSAID resultingScriptValueID */
	macro_bindTempArgDesc(scriptData);
	macro_bindHandler(handleOSACoerceFromDesc);
	res = PyObject_CallFunction(handler, "O&l",
								AEDesc_New, &tempArgDesc,
								modeFlags);
	macro_resToOSAID(handleOSACoerceFromDesc, resultingScriptValueID);
}


static ComponentResult handleOSACoerceToDesc(CIStorageHandle ciStorage, OSAID scriptValueID, DescType desiredType, long modeFlags, AEDesc *result) {
	/* Calls controller.handleOSACoerceToDesc(OSAID scriptValueID, DescType desiredType, long modeFlags) -> AEDesc result */
	macro_bindHandler(handleOSACoerceToDesc);
	res = PyObject_CallFunction(handler, "kO&l", 
								scriptValueID, 
								PyMac_BuildOSType, desiredType, 
								modeFlags);
	macro_resToAEDesc(handleOSACoerceToDesc, result);
}


/* Manipulating the Create and Send Functions */

static ComponentResult handleOSASetCreateProc(CIStorageHandle ciStorage, OSACreateAppleEventUPP createProc, long refCon) {
	/* Calls controller.handleOSASetCreateProc(OSACreateAppleEventUPP createProc, long refCon) -> None */
	macro_storeUPP(handleOSASetCreateProc, createProc, refCon);
}


static ComponentResult handleOSAGetCreateProc(CIStorageHandle ciStorage, OSACreateAppleEventUPP *createProc, long *refCon) {
	/* Calls controller.handleOSAGetCreateProc() -> (OSACreateAppleEventUPP createProc, long refCon) */
	macro_fetchUPP(handleOSAGetCreateProc, OSACreateAppleEventUPP, createProc, refCon);
}


static ComponentResult handleOSASetSendProc(CIStorageHandle ciStorage, OSASendUPP sendProc, long refCon) {
	/* Calls controller.handleOSAGetCreateProc(OSACreateAppleEventUPP *createProc, long *refCon) -> None */
	macro_storeUPP(handleOSASetSendProc, sendProc, refCon);
}


static ComponentResult handleOSAGetSendProc(CIStorageHandle ciStorage, OSASendUPP *sendProc, long *refCon) {
	/* Calls controller.handleOSAGetSendProc() -> (OSASendUPP sendProc, long refCon) */
	macro_fetchUPP(handleOSAGetSendProc, OSASendUPP, sendProc, refCon);
}


static ComponentResult handleOSASetDefaultTarget(CIStorageHandle ciStorage, const AEAddressDesc *target) {
	/* Calls controller.handleOSASetDefaultTarget(AEAddressDesc target) -> None */
	macro_bindTempArgDesc(target);
	macro_bindHandler(handleOSASetDefaultTarget);
	res = PyObject_CallFunction(handler, "(O&)",
								AEDesc_New, &tempArgDesc);
	macro_resToNone(handleOSASetDefaultTarget);
}



/* Recording Scripts */

static ComponentResult handleOSAStartRecording(CIStorageHandle ciStorage, OSAID *compiledScriptToModifyID) {
	/* Calls controller.handleOSAStartRecording(OSAID compiledScriptToModifyID) -> OSAID compiledScriptToModifyID */
	macro_bindHandler(handleOSAStartRecording);
	res = PyObject_CallFunction(handler, "(k)",
								*compiledScriptToModifyID);
	macro_resToOSAID(handleOSAStartRecording, compiledScriptToModifyID);
}


static ComponentResult handleOSAStopRecording(CIStorageHandle ciStorage, OSAID compiledScriptID) {
	/* Calls controller.handleOSAStopRecording(OSAID compiledScriptID) -> None */
	macro_bindHandler(handleOSAStopRecording);
	res = PyObject_CallFunction(handler, "(k)",
								compiledScriptID);		
	macro_resToNone(handleOSAStopRecording);
}


/* Executing Scripts in One Step */

static ComponentResult handleOSALoadExecute(CIStorageHandle ciStorage, const AEDesc *scriptData, OSAID contextID, long modeFlags, OSAID *resultingScriptValueID) {
	/* Calls controller.handleOSALoadExecute(AEDesc scriptData, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID */
	macro_bindTempArgDesc(scriptData);
	macro_bindHandler(handleOSALoadExecute);
	res = PyObject_CallFunction(handler, "O&kl",
								AEDesc_New, &tempArgDesc,
								contextID,
								modeFlags);
	macro_resToOSAID(handleOSALoadExecute, resultingScriptValueID);
}


static ComponentResult handleOSACompileExecute(CIStorageHandle ciStorage, const AEDesc *sourceData, OSAID contextID, long modeFlags, OSAID *resultingScriptValueID) {
	/* Calls controller.handleOSACompileExecute(AEDesc sourceData, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID */
	macro_bindTempArgDesc(sourceData);
	macro_bindHandler(handleOSACompileExecute);
	res = PyObject_CallFunction(handler, "O&kl",
								AEDesc_New, &tempArgDesc,
								contextID,
								modeFlags);
	macro_resToOSAID(handleOSACompileExecute, resultingScriptValueID);
}


static ComponentResult handleOSADoScript(CIStorageHandle ciStorage, const AEDesc *sourceData, OSAID contextID, DescType desiredType, long modeFlags, AEDesc *resultingText) {
	/* Calls controller.handleOSADoScript(AEDesc sourceData, OSAID contextID, DescType desiredType, long modeFlags) -> AEDesc resultingText */
	macro_bindTempArgDesc(sourceData);
	macro_bindHandler(handleOSADoScript);
	res = PyObject_CallFunction(handler, "O&kO&l",
								AEDesc_New, &tempArgDesc,
								contextID,
								PyMac_BuildOSType, desiredType,
								modeFlags);
	macro_resToAEDesc(handleOSADoScript, resultingText);
}


/* Using Script Contexts to Handle Apple Events */

static ComponentResult handleOSASetResumeDispatchProc(CIStorageHandle ciStorage, AEEventHandlerUPP resumeDispatchProc, long refCon) {
	/* Calls controller.handleOSASetResumeDispatchProc(AEEventHandlerUPP resumeDispatchProc, long refCon) -> None */
	macro_storeUPP(handleOSASetResumeDispatchProc, resumeDispatchProc, refCon);
}


static ComponentResult handleOSAGetResumeDispatchProc(CIStorageHandle ciStorage, AEEventHandlerUPP *resumeDispatchProc, long *refCon) {
	/* Calls controller.handleOSAGetResumeDispatchProc() -> (AEEventHandlerUPP resumeDispatchProc, long refCon) */
	macro_fetchUPP(handleOSAGetResumeDispatchProc, AEEventHandlerUPP, resumeDispatchProc, refCon);
}


static ComponentResult handleOSAExecuteEvent(CIStorageHandle ciStorage, const AppleEvent *theAppleEvent, OSAID contextID, long modeFlags, OSAID *resultingScriptValueID) {
	/* Calls controller.handleOSAExecuteEvent(AppleEvent theAppleEvent, OSAID contextID, long modeFlags) -> OSAID resultingScriptValueID */
	macro_bindTempArgDesc(theAppleEvent);
	macro_bindHandler(handleOSAExecuteEvent);
	res = PyObject_CallFunction(handler, "O&kl",
								AEDesc_New, &tempArgDesc,
								contextID,
								modeFlags);
	macro_resToOSAID(handleOSAExecuteEvent, resultingScriptValueID);
}


static ComponentResult handleOSADoEvent(CIStorageHandle ciStorage, const AppleEvent *theAppleEvent, OSAID contextID, long modeFlags, AppleEvent *reply) {
	/* Calls controller.handleOSADoEvent(AppleEvent theAppleEvent, OSAID contextID, long modeFlags, AppleEvent reply)
		NOTE: AEDesc objects must NOT be retained by Python code after handleOSADoEvent() returns.
	*/
	macro_bindHandler(handleOSADoEvent);
	res = PyObject_CallFunction(handler, "O&klO&",
								AEDesc_NewBorrowed, theAppleEvent,
								contextID,
								modeFlags, 
								AEDesc_NewBorrowed, reply);
	macro_resToNone(handleOSADoEvent);
}


static ComponentResult handleOSAMakeContext(CIStorageHandle ciStorage, const AEDesc *contextName, OSAID parentContext, OSAID *resultingContextID) {
	/* Calls controller.handleOSAMakeContext(AEDesc contextName, OSAID parentContext) -> OSAID resultingContextID */
	macro_bindTempArgDesc(contextName);
	macro_bindHandler(handleOSAMakeContext);
	res = PyObject_CallFunction(handler, "O&k",
								AEDesc_New, &tempArgDesc,
								parentContext);
	macro_resToOSAID(handleOSAMakeContext, resultingContextID);
}


/******************************************************************************/
/* Support functions; used by handleComponentOpen() function below */
/******************************************************************************/
	
static Boolean urlToPathCString(CFURLRef url, char *pathCStr) {
	/* Converts CFURLRef to C string. Note: this releases the CFURLRef. */
	CFURLRef absURL;
	CFStringRef pathStr;
	Boolean err;
	
	absURL = CFURLCopyAbsoluteURL(url);
	CFRelease(url);
	pathStr = CFURLCopyFileSystemPath(absURL, kCFURLPOSIXPathStyle);
	CFRelease(absURL);
	err = CFStringGetCString(pathStr, pathCStr, PATH_MAX, kCFStringEncodingUTF8); 
	CFRelease(pathStr);
	return err;
}


static OSErr setPythonSysPath(void) {
	/* Runs Resources/mcpy_syspath.py script to add module search paths to Python interpreter. */
	CFBundleRef mainBundle;
	CFURLRef scriptURL;
	char scriptPath[PATH_MAX];
	FILE *fp;
	int err;
	
	mainBundle = CFBundleGetBundleWithIdentifier(CFSTR(COMPONENT_IDENTIFIER));
	#ifdef DEBUG_ON
	char bundlePath[PATH_MAX];
	urlToPathCString(CFBundleCopyBundleURL(mainBundle), bundlePath);
	printf("\tMacPythonOSA component bundle path: %s\n", bundlePath);
	#endif
	scriptURL = CFBundleCopyResourceURL(mainBundle, CFSTR("mcpy_syspath.py"), NULL, NULL);
	if (scriptURL == NULL || !urlToPathCString(scriptURL, scriptPath)) {
		fprintf(stderr, "Can't open MacPythonOSA component: can't get mcpy_syspath file.\n");
		return 1;
	}
	#ifdef DEBUG_ON
	printf("\tmcpy_syspath.py file path: %s\n", scriptPath);
	#endif
	fp = fopen(scriptPath, "r");
	err = PyRun_SimpleFile(fp, scriptPath);
	fclose(fp);
	if (err) {
		fprintf(stderr, "Can't open MacPythonOSA component: mcpy_syspath failed.\n");
		return 1;
	}
	return 0;
}


static void initialiseAll(void) {
		Py_Initialize();
		initializeComponentFunctionUPPs();
		aeIdleUPP = NewAEIdleUPP((AEIdleProcPtr)&aeIdleProc); // TO CHECK: is this correct?
		defaultOSAActiveUPP = NewOSAActiveUPP((OSAActiveProcPtr)&defaultOSAActiveProc); // TO CHECK: is this correct?
}


static void finaliseAll(void) {
		DisposeOSAActiveUPP(defaultOSAActiveUPP);
		DisposeAEIdleUPP(aeIdleUPP);
		finalizeComponentFunctionUPPs();
		Py_Finalize();
}


/******************************************************************************/
/* Component callbacks */
/******************************************************************************/

static ComponentResult handleComponentOpen(ComponentInstance self) {
	/* Creates a new MacPythonOSA component instance. Each component instance stores its unique state in a CIStorageType struct (i.e. ADT). Each time CM calls MacPythonOSA's componentEntry(), this struct is passed in so the component's other functions can access this state. Thus a client can create and use multiple independent component instances at the same time. This is probably more valuable with languages such as AppleScript which don't provide built-in multithreading support, as it provides a way to execute multiple AS scripts in parallel: just spawn a bunch of application threads, each containing a separate component instance handling one of the scripts.
	*/
	CIStorageHandle ciStorage = nil;
	
	#ifdef DEBUG_ON
	printf("\tOpening MacPythonOSA component instance...\n");
	#endif
	/* Create storage struct containing mcpy_controller module and bind it to component instance. */
	ciStorage = (CIStorageHandle)NewHandleClear(sizeof(CIStorageType));
	if (ciStorage == nil)
		return memFullErr; // (if this ever happens, handleComponentClose() will crash as component instance's storage hasn't yet been set)
	SetComponentInstanceStorage(self, (Handle)ciStorage);
	/* Initialise component. */
	if (!Py_IsInitialized()) {
		initialiseAll();
		if (setPythonSysPath())
			return errOSACantOpenComponent;
		#ifdef DEBUG_ON
		printf("\tPython interpreter and UPP table initialised. Initialising controller module and storage...\n");
		#endif
	}
	/* Export extension functions used by controller module. */
	Py_InitModule("mcpy_support", mcpy_supportFunctions);
	/* Bind controller module to storage. */
	if (((**ciStorage).controller = PyImport_ImportModule("mcpy_controller")) == NULL) {
		fprintf(stderr, "Can't open MacPythonOSA component: controller module failed to load:\n");
		PyErr_Print();
		return errOSACantOpenComponent;
	}
	#ifdef DEBUG_ON
	printf("\tComponent instance ready.\n");
	#endif
	return noErr;
}


static ComponentResult handleComponentClose(CIStorageHandle ciStorage, ComponentInstance self) {
	//#ifdef DEBUG_ON
	printf("Closing MacPythonOSA component instance.\n");
	//#endif
	Py_XDECREF((**ciStorage).controller); // TO CHECK: who is responsible for disposing ciStorage struct?
	if (0) // TO DO: finalise UPPs and Python when there are no more component instances using it. TO DECIDE: might be best not to finalise at all?
		finaliseAll();
	return noErr;
}


static ComponentResult handleComponentCanDo(CIStorageHandle ciStorage, SInt16 selector) {
	/* Is a given function supported? */
	ComponentFunctionDef functionDef;
	PyObject *handler;
	int i = 0; 
	
	while ((functionDef = componentFunctionDefs[i]).name != NULL) {
		if (functionDef.selector == selector) {
			if (functionDef.shouldDelegate) {
				handler = PyObject_GetAttrString((**ciStorage).controller, functionDef.name);
				return handler && PyCallable_Check(handler);
			} else {
				return true;
			}
		}
		i++;
	}
	return selector == kComponentOpenSelect; /* ComponentOpen() is supported but not defined in the componentFunctionDefs table as it takes its arguments differently. */
}


static ComponentResult handleComponentVersion(CIStorageHandle ciStorage) {
	return COMPONENT_VERSION;
}


/******************************************************************************/
/* Component function lookup table */
/******************************************************************************/

/* Macros add function pointers and UPP parameter info data to lookup table. */

#define macro_componentFunction(name) \
	"handleComponent" #name, 0, kComponent##name##Select, (ProcPtr)handleComponent##name, \
			kPascalStackBased \
			| RESULT_SIZE(SIZE_CODE(sizeof(ComponentResult)))

#define macro_osaFunction(name) \
	"handleOSA" #name, 1, kOSASelect##name, (ProcPtr)handleOSA##name, \
			kPascalStackBased \
			| RESULT_SIZE(SIZE_CODE(sizeof(ComponentResult)))

#define macro_param(i, type) \
			| STACK_ROUTINE_PARAMETER(i, SIZE_CODE(sizeof(type)))


/* Lookup table used by centralDispatch() to find the UPP for a component function requested by client. */

static ComponentFunctionDef componentFunctionDefs[] = {
	
	/* Required component routines */
	
	/* Note: handleComponentOpen is called directly by centralDispatch() so isn't defined here. */

	{macro_componentFunction(Close)
			macro_param(1, Handle) 
			macro_param(2, ComponentInstance)},
	
	{macro_componentFunction(CanDo)
			macro_param(1, Handle) 
			macro_param(2, short)},
	
	{macro_componentFunction(Version)
			macro_param(1, Handle)},
	
	/* Required scripting component routines */
	
	/* Saving and Loading Script Data */
	
	{macro_osaFunction(Store)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, DescType)
			macro_param(4, long)
			macro_param(5, AEDesc *)},
	
	{macro_osaFunction(Load)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, long)
			macro_param(4, OSAID *)},
	
	/* Executing and Disposing of Scripts */
	
	{macro_osaFunction(Execute)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, OSAID)
			macro_param(4, long)
			macro_param(5, OSAID *)},
	
	{macro_osaFunction(Display)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, DescType)
			macro_param(4, long)
			macro_param(5, AEDesc *)},
	
	{macro_osaFunction(ScriptError)
			macro_param(1, Handle)
			macro_param(2, OSType)
			macro_param(3, DescType)
			macro_param(4, AEDesc *)},
	
	{macro_osaFunction(Dispose)
			macro_param(1, Handle)
			macro_param(2, OSAID)},
	
	/* Setting and Getting Script Information */
	
	{macro_osaFunction(SetScriptInfo)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, OSType)
			macro_param(4, long)},
	
	{macro_osaFunction(GetScriptInfo)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, OSType)
			macro_param(4, long *)},
	
	/* Manipulating the Active Function */
	
	{macro_osaFunction(SetActiveProc)
			macro_param(1, Handle)
			macro_param(2, OSAActiveUPP)
			macro_param(3, long)},
	
	{macro_osaFunction(GetActiveProc)
			macro_param(1, Handle)
			macro_param(2, OSAActiveUPP *)
			macro_param(3, long *)},
	
	/* Optional Scripting Component Routines */
	
	/* Compiling Scripts */
	
	{macro_osaFunction(ScriptingComponentName)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)},
	
	{macro_osaFunction(Compile)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, long)
			macro_param(4, OSAID *)},
	
	{macro_osaFunction(CopyID)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, OSAID *)},
	
	/* Getting Source Data */
	
	{macro_osaFunction(GetSource)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, DescType)
			macro_param(4, AEDesc *)},
	
	/* Coercing Script Values */
	
	{macro_osaFunction(CoerceFromDesc)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, long)
			macro_param(4, OSAID *)},
	
	{macro_osaFunction(CoerceToDesc)
			macro_param(1, Handle)
			macro_param(2, OSAID)
			macro_param(3, DescType)
			macro_param(4, long)
			macro_param(5, AEDesc *)},
	
	/* Manipulating the Create and Send Functions */
	
	{macro_osaFunction(SetCreateProc)
			macro_param(1, Handle)
			macro_param(2, OSACreateAppleEventUPP)
			macro_param(3, long)},
	
	{macro_osaFunction(GetCreateProc)
			macro_param(1, Handle)
			macro_param(2, OSACreateAppleEventUPP *)
			macro_param(3, long *)},
	
	{macro_osaFunction(SetSendProc)
			macro_param(1, Handle)
			macro_param(2, OSASendUPP)
			macro_param(3, long)},
	
	{macro_osaFunction(GetSendProc)
			macro_param(1, Handle)
			macro_param(2, OSASendUPP *)
			macro_param(3, long *)},
	
	{macro_osaFunction(SetDefaultTarget)
			macro_param(1, Handle)
			macro_param(2, AEAddressDesc *)},
	
	/* Recording Scripts */
		
	{macro_osaFunction(StartRecording)
			macro_param(1, Handle)
			macro_param(2, OSAID *)},
	
	{macro_osaFunction(StopRecording)
			macro_param(1, Handle)
			macro_param(2, OSAID)},
	
	/* Executing Scripts in One Step */
	
	{macro_osaFunction(LoadExecute)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, OSAID)
			macro_param(4, long)
			macro_param(5, OSAID *)},
	
	{macro_osaFunction(CompileExecute)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, OSAID)
			macro_param(4, long)
			macro_param(5, OSAID *)},
	
	{macro_osaFunction(DoScript)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, OSAID)
			macro_param(4, DescType)
			macro_param(5, long)
			macro_param(6, AEDesc *)},
	
	/* Using Script Contexts to Handle Apple Events */
			
	{macro_osaFunction(SetResumeDispatchProc)
			macro_param(1, Handle)
			macro_param(2, AEEventHandlerUPP)
			macro_param(3, long)},
	
	{macro_osaFunction(GetResumeDispatchProc)
			macro_param(1, Handle)
			macro_param(2, AEEventHandlerUPP *)
			macro_param(3, long *)},
	
	{macro_osaFunction(ExecuteEvent)
			macro_param(1, Handle)
			macro_param(2, AppleEvent *)
			macro_param(3, OSAID)
			macro_param(4, long)
			macro_param(5, OSAID *)},
	
	{macro_osaFunction(DoEvent)
			macro_param(1, Handle)
			macro_param(2, AppleEvent *)
			macro_param(3, OSAID)
			macro_param(4, long)
			macro_param(5, AppleEvent *)},
	
	{macro_osaFunction(MakeContext)
			macro_param(1, Handle)
			macro_param(2, AEDesc *)
			macro_param(3, OSAID)
			macro_param(4, OSAID *)},
	
	{NULL, 0, 0, NULL, 0, NULL}
};


/* Functions to create and destroy the UPPs stored in above table. */

static void initializeComponentFunctionUPPs(void) {
	ComponentFunctionDef functionDef;
	int i = 0;
	
	while ((functionDef = componentFunctionDefs[i]).name != NULL) {
		componentFunctionDefs[i].componentFunctionUPP = NewComponentFunctionUPP(functionDef.procPtr, functionDef.procInfo);
		i++;
	}
}

static void finalizeComponentFunctionUPPs(void) {
	ComponentFunctionDef functionDef;
	int i = 0;
	
	while ((functionDef = componentFunctionDefs[i]).name != NULL) {
		DisposeComponentFunctionUPP(functionDef.componentFunctionUPP);
		i++;
	}
}


/******************************************************************************/
/* MacPythonOSA component's entry point */
/******************************************************************************/

ComponentResult MacPythonOSA_centralDispatch(ComponentParameters *params, Handle ciStorage) {
	/* Every component exports a single named function as its entry point. Component Manager calls this function to access the component's services.
	*/
	ComponentFunctionDef functionDef;
	SInt16 selector = params->what;
	int i = 0;
	
	while ((functionDef = componentFunctionDefs[i]).name != NULL) {
		if (functionDef.selector == selector) {
			#ifdef DEBUG_ON
			printf("MacPythonOSA: calling %s()\n", functionDef.name);
			#endif
			return CallComponentFunctionWithStorage(ciStorage, params, functionDef.componentFunctionUPP);
		}
		i++;
	}
	if (selector == kComponentOpenSelect) {
		#ifdef DEBUG_ON
		printf("MacPythonOSA: calling handleComponentOpen()\n");
		#endif
		return handleComponentOpen((ComponentInstance)(params->params[0]));
	} else {
		fprintf(stderr, "MacPythonOSA warning: client requested an unsupported function: %i\n", selector);
		return badComponentSelector;
	}
}


