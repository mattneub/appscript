/*
 * statemanager.c
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 */

#include "statemanager.h"

/*
PyThreadState* global_state = PyThreadState_Get();
//PyThreadState* ts = Py_NewInterpreter();
PyThreadState_Swap(global_state);
…
PyThreadState_Swap(ts);
// code to execute in interpreter
PyThreadState_Swap(global_state);
…
PyThreadState_Swap(ts);
//Py_EndInterpreter( ts );
PyThreadState_Swap(global_state);
*/

/**********************************************************************/


static Boolean urlToPath(CFURLRef url, char *pathCStr) {
	/* Converts a CFURLRef to UTF8-encoded path string, releasing the CFURLRef when done. */
	CFURLRef absURL;
	CFStringRef pathStr;
	Boolean success;
	
	absURL = CFURLCopyAbsoluteURL(url);
	CFRelease(url);
	pathStr = CFURLCopyFileSystemPath(absURL, kCFURLPOSIXPathStyle);
	CFRelease(absURL);
	success = CFStringGetCString(pathStr, pathCStr, PATH_MAX, kCFStringEncodingUTF8); 
	CFRelease(pathStr);
	return success;
}


static Boolean getSetupScriptPath(char *setupScriptPath) {
	/* Runs Resources/pyosa_syspath.py script to add module search paths to Python interpreter. */
	CFBundleRef mainBundle;
	CFURLRef setupScriptURL;
	
	mainBundle = CFBundleGetBundleWithIdentifier(CFSTR(COMPONENT_IDENTIFIER));
	#ifdef DEBUG_ON
	char bundlePath[PATH_MAX];
	urlToPath(CFBundleCopyBundleURL(mainBundle), bundlePath);
	fprintf(stderr, "\tPyOSA component bundle path: %s\n", bundlePath);
	#endif
	setupScriptURL = CFBundleCopyResourceURL(mainBundle, CFSTR("pyosa_syspath.py"), NULL, NULL);
	if (!setupScriptURL) return 0;
	return urlToPath(setupScriptURL, setupScriptPath);
}


static Boolean setSysPath(char *setupScriptPath) {
	FILE *fp;
	Boolean success;
	
	fp = fopen(setupScriptPath, "r");
	success = !PyRun_SimpleFile(fp, setupScriptPath);
	fclose(fp);
	return success;
}


/**********************************************************************/
// Script execution context; these functions called by createScriptState, disposeScriptState


static OSErr createExecutionContext(CIStorageHandle ciStorage, ExecutionContextRef *context) {
	*context = malloc(sizeof(ExecutionContext));
	(*context)->refcount = 1;
	#ifdef SUBINTERPRETERS_ENABLED
	PyThreadState* currentState = PyThreadState_Get();
	(*context)->context = Py_NewInterpreter();
	importCallbacksModule();
	// set up interpreter's sys.path
	if (!setSysPath((**ciStorage).setupScriptPath)) {
		fprintf(stderr, "PyOSA: pyosa_syspath failed.\n");
		return errOSASystemError;
	}
	#endif
	// import script manager module
	(*context)->scriptManagerModule = PyImport_ImportModule("pyosa_scriptmanager");
	if (!((*context)->scriptManagerModule)) {
		PyErr_Print();
		return errOSASystemError;
	}
	#ifdef SUBINTERPRETERS_ENABLED
	PyThreadState_Swap(currentState);
	#endif
	return noErr;
}

static void retainExecutionContext(ExecutionContextRef context) {
	(context->refcount)++;
}

static void releaseExecutionContext(ExecutionContextRef context) {
	if (!((context->refcount)--)) {
		#ifdef SUBINTERPRETERS_ENABLED
		PyThreadState *currentState = PyThreadState_Get();
		PyThreadState_Swap(context->context);
		Py_EndInterpreter(context->context);
		PyThreadState_Swap(currentState);
		#endif
		free(context);
	}
}


/**********************************************************************/
// Component instances


OSErr createComponentInstanceStorage(CIStorageHandle *ciStorage) {
	PyObject *appscriptServicesModule, *appscriptServicesClass, *result;
	
	*ciStorage = (CIStorageHandle)NewHandleClear(sizeof(ComponentInstanceStorage));
	if (!(*ciStorage)) return memFullErr;
	(**ciStorage)->scripts = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
	(**ciStorage)->callbacks = createCallbacks();
	(**ciStorage)->terminologyCache = PyDict_New();
	// locate Python script used to set up interpreter's sys.path
	if (!getSetupScriptPath((**ciStorage)->setupScriptPath)) {
		fprintf(stderr, "PyOSA: can't get pyosa_syspath.py\n");
		return errOSASystemError;
	}
	// set up main interpreter's sys.path
	if (!setSysPath((**ciStorage)->setupScriptPath)) {
		fprintf(stderr, "PyOSA: pyosa_syspath failed.\n");
		return errOSASystemError;
	}
	// create appscript services
	importCallbacksModule();
	appscriptServicesModule = PyImport_ImportModule("pyosa_appscript");
	if (!appscriptServicesModule) {
		PyErr_Print();
		return errOSASystemError;
	}
	appscriptServicesClass = PyObject_GetAttrString(appscriptServicesModule, "AppscriptServices");
	if (!appscriptServicesClass) {
		PyErr_Print();
		return errOSASystemError;
	}
	Py_DECREF(appscriptServicesModule);
	(**ciStorage)->appscriptServices = PyInstance_NewRaw(appscriptServicesClass, NULL);
	if (!((**ciStorage)->appscriptServices)) {
		PyErr_Print();
		return errOSASystemError;
	}
	Py_DECREF(appscriptServicesClass);
	#ifdef DEBUG_ON
	fprintf(stderr, "initing AppscriptServices:\n");
	PyObject_Print((**ciStorage)->callbacks, stderr, 0);
	PyObject_Print((**ciStorage)->terminologyCache, stderr, 0);
	fprintf(stderr, "\n");
	#endif
	result = PyObject_CallMethod((**ciStorage)->appscriptServices, "__init__", "OO",
																			   (**ciStorage)->callbacks,
																			   (**ciStorage)->terminologyCache);
	if (!result) {
		PyErr_Print();
		return errOSASystemError;
	}
	return noErr;
}

OSErr disposeComponentInstanceStorage(CIStorageHandle ciStorage) {
	CFMutableDictionaryRef scripts;
	CFIndex scriptStatesCount;
	
	if (ciStorage) {
		scripts = (**ciStorage).scripts;
		if (scripts) {
			scriptStatesCount = CFDictionaryGetCount(scripts);
			// TO DO: if !scriptStatesCount, dispose remaining scripts
			CFRelease(scripts);
		}
		Py_XDECREF((**ciStorage).appscriptServices);
		Py_XDECREF((**ciStorage).terminologyCache);
		Py_XDECREF((**ciStorage).callbacks);
		Py_XDECREF((**ciStorage).errorValue);
	}
	return noErr;
}


OSAID createScriptID(CIStorageHandle ciStorage) {
	return ++((**ciStorage).idCount); // TO DO: overflow, collision checking
}


/**********************************************************************/
// Scripts


OSErr createScriptState(CIStorageHandle ciStorage,
						ScriptStateRef parent,
						OSAID *scriptID,
						ScriptStateRef *scriptState) {
	OSErr err;
	ExecutionContextRef context;
	PyObject *scriptManagerClass, *result;
	
	// create new script state
	*scriptID = createScriptID(ciStorage);
	#ifdef DEBUG_ON
		fprintf(stderr, "Creating new script state %i...\n", *scriptID);
	#endif
	*scriptState = malloc(sizeof(ScriptState));
	(*scriptState)->scriptID = *scriptID;
	// assign it a context
	if (parent) { // script was created by another script, so reuse that script's context
		#ifdef DEBUG_ON
			fprintf(stderr, "    reusing context from script %i\n", parent->scriptID);
		#endif
		context = parent->context;
		retainExecutionContext(context);
	} else { // script was created by client, so create new context
		#ifdef DEBUG_ON
			fprintf(stderr, "    creating new context\n");
		#endif
		err = createExecutionContext(ciStorage, &context);
		if (err) {
			free(*scriptState);
			return err;
		}
	}
	((*scriptState)->context) = context;
	// assign it a script manager
	scriptManagerClass = PyObject_GetAttrString(context->scriptManagerModule, "ScriptManager");
	if (!scriptManagerClass) {
		PyErr_Print();
		return errOSASystemError;
	}
	(*scriptState)->scriptManager = PyInstance_NewRaw(scriptManagerClass, NULL);
	if (!((*scriptState)->scriptManager)) {
		PyErr_Print();
		return errOSASystemError;
	}
	result = PyObject_CallMethod((*scriptState)->scriptManager, "__init__", "(O)", 
																			(**ciStorage).appscriptServices);
	if (!result) {
		PyErr_Print();
		return errOSASystemError;
	}
	CFDictionarySetValue((**ciStorage).scripts, (void *)(*scriptID), (void *)(*scriptState));
	#ifdef DEBUG_ON
		fprintf(stderr, "...done.\n");
	#endif
	return noErr;
}


OSErr disposeScriptState(CIStorageHandle ciStorage, OSAID scriptID) {
	ScriptStateRef scriptState;
	
	scriptState = getScriptState(ciStorage, scriptID);
	if (!scriptState) return errOSAInvalidID;
	CFDictionaryRemoveValue((**ciStorage).scripts, (void *)scriptID);
	Py_DECREF(scriptState->scriptManager);
	releaseExecutionContext(scriptState->context);
	free(scriptState);
	return noErr;
}


ScriptStateRef getScriptState(CIStorageHandle ciStorage, OSAID scriptID) {
	return (ScriptStateRef)CFDictionaryGetValue((**ciStorage).scripts, (void *)scriptID);
}


PyObject* getContextManager(CIStorageHandle ciStorage, OSAID contextID) {
	ScriptStateRef contextState;
	
	if (contextID) {
		contextState = getScriptState(ciStorage, contextID);
		if (!contextState) return NULL;
		Py_INCREF(contextState->scriptManager);
		return contextState->scriptManager;
	} else
		return Py_BuildValue(""); // return None
}


OSErr createValue(CIStorageHandle ciStorage, PyObject *value, ScriptStateRef parent, OSAID *valueID) {
	// note: this function takes ownership of the value argument
	OSErr err;
	ScriptStateRef state;
	PyObject *result;
	
	err = createScriptState(ciStorage, parent, valueID, &state);
	if (err) {
		Py_DECREF(value);
		return err;
	}
	result = PyObject_CallMethod(state->scriptManager, "setvalue", "(O)", value);
	if (!result) {
		err = raisePythonError(ciStorage, *valueID);
		disposeScriptState(ciStorage, *valueID);
		Py_DECREF(value);
		return err;
	}
	Py_DECREF(result);
	return noErr;
}

