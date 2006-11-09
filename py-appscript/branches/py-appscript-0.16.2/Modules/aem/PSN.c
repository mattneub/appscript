/* 
** PSN - Functions to launch applications and get PSN and location of  processes.
**
** (C) 2005 HAS
*/

#include "Python.h"
#include "pymactoolbox.h"
#include <Carbon/Carbon.h>


extern int _AEDescX_Convert(PyObject *, AEDesc *) __attribute__((weak_import));


int AEDescX_Convert(PyObject *pyobj, AEDesc *cobj) { 
    if (!_AEDescX_Convert) { 
       if (!PyImport_ImportModule("CarbonX.AE")) return NULL; 
       if (!_AEDescX_Convert) { 
           PyErr_SetString(PyExc_ImportError, "Module did not provide routine: CarbonX.AE: AEDescX_Convert"); 
           return NULL; 
       } 
    } 
    return _AEDescX_Convert(pyobj, cobj); 
}


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
	{NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initPSN(void)
{
	(void) Py_InitModule("PSN", PSN_methods);
}
