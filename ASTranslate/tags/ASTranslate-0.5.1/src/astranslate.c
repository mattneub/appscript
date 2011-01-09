/*
 * astranslate
 *
 */

#include <Carbon/Carbon.h>
#include "Python.h"
#include "aetoolbox.c"


typedef struct AEDescObject {
	PyObject_HEAD
	AEDesc ob_itself;
	int ob_owned;
} AEDescObject;


static PyObject* module_AE;
static OSASendUPP upp_GenericSendFunction;


static PyObject *ASTranslate(PyObject* self, PyObject* args)
{
	ComponentInstance ci;
	AEDesc sourceDesc, resultDesc;
	AEDesc formattedSourceDesc = {typeNull, NULL};
	AEDesc errorNumber, errorMessage, errorRange;
	PyObject *handler;
	OSAID scriptID = kOSANullScript;
	OSAID resultID;
	OSErr err = noErr;

	if (!PyArg_ParseTuple(args, "O&O",
						  AE_AEDesc_Convert, &sourceDesc,
	                      &handler))
		return NULL;
	
	if (!PyCallable_Check(handler)) {
		PyErr_SetString(PyExc_TypeError, "Not a callable object.");
		return NULL;
	}
	
	ci = OpenDefaultComponent(kOSAComponentType, kAppleScriptSubtype);
	if (!ci) return AE_MacOSError(errOSACantOpenComponent);
	
	err = OSACompile(ci,
					 &sourceDesc,
					 kOSAModeNull, //kOSAModeCompileIntoContext,
					 &scriptID);
	if (err) goto cleanup;
	
	err = OSAGetSource(ci,
					   scriptID,
					   typeUnicodeText,
					   &formattedSourceDesc);
	if (err) goto cleanup;
	
	err = OSASetSendProc(ci,
						 upp_GenericSendFunction,
						 (long)handler);
	if (err) goto cleanup;
	
	err = OSAExecute(ci,
					 scriptID,
					 kOSANullScript,
					 kOSAModeNull, //kOSAModeCompileIntoContext,
					 &resultID);
	if (err) goto cleanup;
	
	err = OSACoerceToDesc(ci,
						  resultID,
						  typeWildCard,
						  kOSAModeNull,
						  &resultDesc);
	OSADispose(ci, resultID);
	
cleanup:
	if (err == errOSAScriptError) goto scriptError;
	if (scriptID != kOSANullScript) OSADispose(ci, scriptID);
	CloseComponent(ci);
	if (err) return AE_MacOSError(err);
	return Py_BuildValue("iO&O&", 1,
						 AE_AEDesc_New, &formattedSourceDesc,
						 AE_AEDesc_New, &resultDesc);

scriptError:
	err = OSAScriptError(ci,
						 kOSAErrorNumber, 
						 typeWildCard,
						 &errorNumber);
	if (err) goto cleanup;
	err = OSAScriptError(ci,
						 kOSAErrorMessage, 
						 typeUnicodeText,
						 &errorMessage);
	if (err) goto cleanup;
	err = OSAScriptError(ci,
						 kOSAErrorRange, 
						 typeWildCard,
						 &errorRange);
	if (err) goto cleanup;
	if (scriptID != kOSANullScript) OSADispose(ci, scriptID);
	CloseComponent(ci);
	return Py_BuildValue("iO&O&O&O&", 0,
						 AE_AEDesc_New, &formattedSourceDesc,
						 AE_AEDesc_New, &errorNumber,
						 AE_AEDesc_New, &errorMessage,
						 AE_AEDesc_New, &errorRange);
}


static OSErr 
GenericSendFunction(const AppleEvent *theAppleEvent,
					  AppleEvent *reply,
					  AESendMode sendMode,
					  AESendPriority sendPriority,
					  long timeOutInTicks,
					  AEIdleUPP idleProc,
					  AEFilterUPP filterProc,
					  long refcon)
{
	OSErr err = noErr;
	PyObject *args, *res;
	PyObject *ptype, *pvalue, *ptraceback, *errorArgs, *errorNum;
    PyGILState_STATE state;

	state = PyGILState_Ensure();
	args = Py_BuildValue("O&ll",
						 AE_AEDesc_New, theAppleEvent,
						 sendMode,
						 timeOutInTicks);
	if (args == NULL) {
		PySys_WriteStderr("An error occurred in SendProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	res = PyObject_CallObject((PyObject *)refcon, args);
	if (res == NULL) {
		if (PyErr_ExceptionMatches(AE_GetMacOSErrorException())) { // return error number
			PySys_WriteStderr("A MacOSError occurred in SendProc.\n");
			PyErr_Fetch(&ptype, &pvalue, &ptraceback);
			if (pvalue) {
				errorArgs = PyObject_GetAttrString(pvalue, "args");
				if (!errorArgs) {
					PySys_WriteStderr("Can't get MacOSError args in SendProc.\n");
					goto restore;
				}
				PyObject_Print(errorArgs, stderr, 0);
				errorNum = PySequence_GetItem(errorArgs, 0);
				Py_DECREF(errorArgs);
				if (!errorNum) {
					PySys_WriteStderr("Can't get MacOSError number in SendProc.\n");
					goto restore;
				}
				if (!PyInt_Check(errorNum)) {
					PySys_WriteStderr("MacOSError arg wasn't int in SendProc.\n");
					goto restore;
				}
				err = (OSErr)PyInt_AsLong(errorNum);
				Py_DECREF(errorNum);
				goto cleanup;
			}
restore:
			PyErr_Restore(ptype, pvalue, ptraceback);
			err = errOSAGeneralError;
		} else {
			PySys_WriteStderr("An error occurred in SendProc.\n");
			PyErr_Print();
			err = errOSAGeneralError;
		}
		goto cleanup;
	}
	if (!PyObject_IsInstance(res, PyObject_GetAttrString(module_AE, "AEDesc"))) {
		Py_DECREF(res);
		PySys_WriteStderr("SendProc didn't return an AEDesc.\n");
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (AEDuplicateDesc(&((AEDescObject *)res)->ob_itself, reply)) {
		Py_DECREF(res);
		err = -1;
		goto cleanup;
	}
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}


static PyMethodDef ASTranslate_methods[] = {
	
	{"translate", (PyCFunction)ASTranslate, 1, PyDoc_STR(
		"translate(scriptDesc, callback) -> resultDesc\n")},
	{NULL, NULL, 0}
};


void initastranslate(void)
{
	module_AE = PyImport_ImportModule("aem.ae");
	upp_GenericSendFunction = NewOSASendUPP(GenericSendFunction);
	Py_InitModule("astranslate", ASTranslate_methods);
}
