/*
 * pythonerrors.c
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 */

#include "pythonerrors.h"

/******************************************************************************/
/* Error reporting function */
/******************************************************************************/

ComponentResult raisePythonError(CIStorageHandle ciStorage, OSAID scriptID) {
	OSErr err;
	PyObject *errorsModule, *componentErrorClass, *scriptErrorClass;
	PyObject *errorType, *errorValue, *errorTraceback, *macOSErrorNumber;
	
	if (!PyErr_Occurred()) { // TO DO: this shouldn't be needed
		fprintf(stderr, "PyOSA: raisePythonError was called, but no Python error occurred!\n");
		return errOSASystemError;
	}
	PyErr_Fetch(&errorType, &errorValue, &errorTraceback);
	if (!errorValue) { // bug in PyOSA's Python code
		fprintf(stderr, "PyOSA: no value given for script error:\n    ");
		PyObject_Print(errorType, stderr, 0);
		fprintf(stderr, "\n");
		return errOSASystemError;
	}
	#ifdef DEBUG_ON
	fprintf(stderr, "PyOSA: raisePythonError was called:\n    ");
	PyObject_Print(errorValue, stderr, 0);
	fprintf(stderr, "\n");
	#endif
	// get PyOSA error classes for exception checking
	// (note: this code blindly assumes the relevant pyosa_errors module, classes, instance vars are all present and correct)
	errorsModule = PyImport_ImportModule("pyosa_errors");
	componentErrorClass = PyObject_GetAttrString(errorsModule, "ComponentError");
	scriptErrorClass = PyObject_GetAttrString(errorsModule, "ScriptError");
	// set component instance's error info so that client can subsequently retrieve details via OSAScriptError if wished
	Py_XDECREF((**ciStorage).errorValue);
	(**ciStorage).errorScriptID = scriptID;
	(**ciStorage).errorValue = errorValue;
	// find out what sort of error it was
	if (PyErr_GivenExceptionMatches(errorType, componentErrorClass)) { // component deliberately raised error
		macOSErrorNumber = PyObject_GetAttrString(errorValue, "errornumber");
		err = PyInt_AsLong(macOSErrorNumber);
		Py_DECREF(macOSErrorNumber);
	} else if (PyErr_GivenExceptionMatches(errorType, scriptErrorClass)) { // client script raised error
		err = errOSAScriptError;
	} else { // caused by a bug in PyOSA's Python code
		fprintf(stderr, "\n****************************************************************************************************\n");
		fprintf(stderr, "PyOSA: an unexpected error occurred:\n");
		Py_INCREF(errorValue);
		PyErr_Restore(errorType, errorValue, errorTraceback);
		PyErr_Print();
		fprintf(stderr, "\n****************************************************************************************************\n\n");
		err = errOSASystemError;
	}
	Py_XDECREF(errorType);
	Py_XDECREF(errorTraceback);
	Py_DECREF(componentErrorClass);
	Py_DECREF(scriptErrorClass);
	Py_DECREF(errorsModule);
	return err;
}

