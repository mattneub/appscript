/*
 * pythonerrors.h
 * PyOSA
 *
 * Copyright (C) 2007 HAS
 *
 *
 * Converts Exceptions raised in PyOSA's Python layer into OSA errors.
 * These exceptions may be:
 * - client script errors; errors occuring in client scripts that are trapped in Python layer, 
 *		then wrapped and re-raised as ScriptErrors
 * - component errors; ComponentErrors raised by Python layer to indicate an OSA operation has failed
 * - unexpected errors; errors caused by bugs or inadequate error checking in the Python layer (oops!)
 *
 * Note: raisePythonError should only be called when a Python interpreter function that
 * sets Python's internal exception state on failure (e.g. PyObject_CallMethod) indicates
 * an interpreter error has occurred (e.g. by returning NULL).
 *
 * Uses pyosa_errors module to do some of the error processing work.
 */

#include <Carbon/Carbon.h>
#include "Python/Python.h"

#include "statemanager.h"


typedef struct {
	AEDesc *number; // typeShortInteger
	AEDesc *message; // typeUnicodeText/typeChar
	AEDesc *briefMessage; // typeUnicodeText/typeChar
	AEDesc *application; // typeProcessSerialNumber/typeUnicodeText/typeChar
	AEDesc *partialResult; // typeBest or typeWildCard
	AEDesc *offendingObject; // typeObjectSpecifier, typeBest, or typeWildCard
	AEDesc *range; // typeOSAErrorRange
	AEDesc *expectedType; // typeType
} ScriptError, *ScriptErrorRef;


ComponentResult raisePythonError(CIStorageHandle ciStorage, OSAID scriptID);
