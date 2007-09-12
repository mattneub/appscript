/* 
** PSN - Functions to launch applications and get PSN and location of  processes.
**
** (C) 2005 HAS
*/

#include "Python.h"
#include "../CarbonX/carbonxtoolbox.c"
#include <Carbon/Carbon.h>
#include <ApplicationServices/ApplicationServices.h>


/**********************************************************************/

static PyObject*
PSN_GetNextProcess(PyObject* self, PyObject* args)
{
	UInt32 highLongOfPSN;
	UInt32 lowLongOfPSN;
	ProcessSerialNumber psn;
	FSRef fsref;
	PyObject* fileObj;
	OSStatus err;
	
	if (!PyArg_ParseTuple(args, "kk", &highLongOfPSN, &lowLongOfPSN))
		return NULL;
	psn.highLongOfPSN = highLongOfPSN;
	psn.lowLongOfPSN = lowLongOfPSN;
	err = GetNextProcess(&psn);
	if (err) return PyMac_Error(err);
	err = GetProcessBundleLocation(&psn, &fsref);
	if (err) {
		Py_INCREF(Py_None);
		fileObj = Py_None;
	} else {
		fileObj = PyMac_BuildFSRef(&fsref);
	}
	return Py_BuildValue("kkO", psn.highLongOfPSN, psn.lowLongOfPSN, fileObj);
}


static PyObject*
PSN_LaunchApplication(PyObject* self, PyObject* args)
{
	FSSpec fss;
	AppleEvent firstEvent;
	LaunchFlags flags;
	AEDesc paraDesc;
	Size paraSize;
	AppParametersPtr paraData;
	ProcessSerialNumber psn;
	LaunchParamBlockRec launchParams;
	OSErr err = noErr;
	
	if (!PyArg_ParseTuple(args, "O&O&H", 
						  PyMac_GetFSSpec, &fss,
						  AEDescX_Convert, &firstEvent,
						  &flags))
		return NULL;
	err = AECoerceDesc(&firstEvent, typeAppParameters, &paraDesc);
	paraSize = AEGetDescDataSize(&paraDesc);
    paraData = (AppParametersPtr)NewPtr(paraSize);
    if (paraData == NULL) return PyMac_Error(memFullErr);
    err = AEGetDescData(&paraDesc, paraData, paraSize);
    if (err != noErr) return PyMac_Error(err);
	launchParams.launchBlockID = extendedBlock;
	launchParams.launchEPBLength = extendedBlockLen;
	launchParams.launchFileFlags = 0;
	launchParams.launchControlFlags = flags;
	launchParams.launchAppSpec = &fss;
	launchParams.launchAppParameters = paraData;
	err = LaunchApplication(&launchParams);
	if (err != noErr) return PyMac_Error(err);
	psn = launchParams.launchProcessSN;
	return Py_BuildValue("kk", 
						 psn.highLongOfPSN, 
						 psn.lowLongOfPSN);
}


/*
 * From _Launchmodule.c, _CFmodule.c, modified to avoid memory leaks
 */

static int OptCFStringRefObj_Convert(PyObject *v, CFStringRef *p_itself)
{

	if (v == Py_None) { *p_itself = NULL; return 1; }
	if (PyString_Check(v)) {
	    char *cStr;
	    if (!PyArg_Parse(v, "es", "ascii", &cStr))
	    	return 0;
		*p_itself = CFStringCreateWithCString((CFAllocatorRef)NULL, cStr, kCFStringEncodingASCII);
		PyMem_Free(cStr); // FIX
		return 1;
	}
	if (PyUnicode_Check(v)) {
		/* We use the CF types here, if Python was configured differently that will give an error */
		CFIndex size = PyUnicode_GetSize(v);
		UniChar *unichars = PyUnicode_AsUnicode(v);
		if (!unichars) return 0;
		*p_itself = CFStringCreateWithCharacters((CFAllocatorRef)NULL, unichars, size);
		return 1;
	}
/*

	if (!CFStringRefObj_Check(v))
	{
		PyErr_SetString(PyExc_TypeError, "CFStringRef required");
		return 0;
	}
	*p_itself = ((CFStringRefObject *)v)->ob_itself;
	return 1;
*/
	PyErr_SetString(PyExc_TypeError, "str/unicode required");
	return 0;
}


static PyObject *Launch_LSFindApplicationForInfo(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSStatus _err;
	OSType inCreator;
	CFStringRef inBundleID;
	CFStringRef inName;
	FSRef outAppRef;
	CFURLRef outAppURL;
	if (!PyArg_ParseTuple(_args, "O&O&O&",
	                      PyMac_GetOSType, &inCreator,
	                      OptCFStringRefObj_Convert, &inBundleID,
	                      OptCFStringRefObj_Convert, &inName))
		return NULL;
	_err = LSFindApplicationForInfo(inCreator,
	                                inBundleID,
	                                inName,
	                                &outAppRef,
	                                &outAppURL);
	if (inBundleID != NULL) CFRelease(inBundleID); // FIX
	if (inName != NULL) CFRelease(inName); // FIX
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&O&",
	                     PyMac_BuildFSRef, &outAppRef,
	                     CFURLRefObj_New, outAppURL);
	return _res;
}


/**********************************************************************/
/* 
 * List of methods defined in the module
 */
static PyMethodDef PSN_methods[] =
{
  	{"GetNextProcess", PSN_GetNextProcess, METH_VARARGS,
		PyDoc_STR("(unsigned long highLongOfPSN, unsigned long highLongOfPSN) --> (unsigned long highLongOfPSN, unsigned long lowLongOfPSN, FSRef fsref)")},
  	{"LaunchApplication", PSN_LaunchApplication, METH_VARARGS,
		PyDoc_STR("(FSSpec fss, AEDesc firstEvent, unsigned short flags) --> (unsigned long highLongOfPSN, unsigned long lowLongOfPSN)")},
	{"LSFindApplicationForInfo", (PyCFunction)Launch_LSFindApplicationForInfo, 1,
		PyDoc_STR("(OSType inCreator, CFStringRef inBundleID, CFStringRef inName) -> (FSRef outAppRef, CFURLRef outAppURL)")},
	{NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initPSN(void)
{
	(void) Py_InitModule("PSN", PSN_methods);
}
