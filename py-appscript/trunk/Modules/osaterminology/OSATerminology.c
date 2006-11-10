/*
** An interface to the application scripting related functions of the OSA API.
**
** CopyScriptingDefinition - given an FSRef/posix path to an application,  
**                         returns its sdef, or None if OS version < 10.4
**                         (added 2005-05-04)
**
** GetAppTerminology - given an FSSpec/posix path to an application,
**                         returns its aevt (scripting terminology) resource(s)
**
** GetSysTerminology - given a scripting component subtype, returns its aeut
**                         (scripting terminology) resource
**
** Written by Donovan Preston. Modified by Jack Jansen. Modified by HAS.
*/
#include "Python.h"
#include "../CarbonX/carbonxtoolbox.c"

#include <Carbon/Carbon.h>

extern OSAError OSACopyScriptingDefinition(const FSRef *, SInt32, CFDataRef *) __attribute__((weak_import));


static PyObject *
PyOSA_CopyScriptingDefinition(PyObject* self, PyObject* args)
{
	PyObject *res;
	FSRef fsref;
	CFDataRef sdef;
	CFIndex dataSize;
	char *data;
	OSAError  err;
	
	if (OSACopyScriptingDefinition == NULL) {
		Py_INCREF(Py_None);
		return Py_None;
	}
	if (!PyArg_ParseTuple(args, "O&", PyMac_GetFSRef, &fsref))
		return NULL;
	err = OSACopyScriptingDefinition(&fsref, 0, &sdef);
	if (err) return PyMac_Error(err);
	dataSize = CFDataGetLength(sdef);
	data = (char *)CFDataGetBytePtr(sdef);
	if (data != NULL) {
		res = PyString_FromStringAndSize(data, dataSize);
	} else {
		data = malloc(dataSize);
		CFDataGetBytes(sdef, CFRangeMake(0, dataSize), (UInt8 *)data);
		res = PyString_FromStringAndSize(data, dataSize);
		free(data);
	}
	CFRelease(sdef);
	return res;
}

static PyObject *
PyOSA_GetAppTerminology(PyObject* self, PyObject* args)
{
	AEDesc theDesc = {0,0};
	FSSpec fss;
	ComponentInstance defaultComponent = NULL;
	SInt16 defaultTerminology = 0;
	Boolean didLaunch = 0;
	OSAError err;
	
	if (!PyArg_ParseTuple(args, "O&", PyMac_GetFSSpec, &fss))
		return NULL;
	defaultComponent = OpenDefaultComponent(kOSAComponentType, 'ascr');
	err = GetComponentInstanceError(defaultComponent);
	if (err) return PyMac_Error(err);
	err = OSAGetAppTerminology(
			defaultComponent, 
			kOSAModeNull,
			&fss, 
			defaultTerminology, 
			&didLaunch, 
			&theDesc
	);
	if (err) return PyMac_Error(err);
	return Py_BuildValue("O&i", AEDescX_New, &theDesc, didLaunch);
}

static PyObject *
PyOSA_GetSysTerminology(PyObject* self, PyObject* args)
{
	AEDesc theDesc = {0,0};
	ComponentInstance defaultComponent = NULL;
	SInt16 defaultTerminology = 0;
	OSType componentSubType;
	OSAError err;
	
	if (!PyArg_ParseTuple(args, "O&", PyMac_GetOSType, &componentSubType))
		return NULL;
	defaultComponent = OpenDefaultComponent(kOSAComponentType, componentSubType);
	err = GetComponentInstanceError(defaultComponent);
	if (err) return PyMac_Error(err);
	err = OSAGetSysTerminology(
			defaultComponent, 
			kOSAModeNull,
			defaultTerminology, 
			&theDesc
	);
	if (err) return PyMac_Error(err);
	return Py_BuildValue("O&", AEDescX_New, &theDesc);
}

/* 
 * List of methods defined in the module
 */
static struct PyMethodDef OSATerminology_methods[] =
{
  	{"CopyScriptingDefinition", 
		(PyCFunction) PyOSA_CopyScriptingDefinition,
		METH_VARARGS,
		"Get an application's sdef (returns None if OS version < 10.4): CopyScriptingDefinition(path) --> unicode | None"},
  	{"GetAppTerminology", 
		(PyCFunction) PyOSA_GetAppTerminology,
		METH_VARARGS,
		"Get an application's terminology: GetAppTerminology(path) --> AEDesc"},
  	{"GetSysTerminology", 
		(PyCFunction) PyOSA_GetSysTerminology,
		METH_VARARGS,
		"Get a scripting component's terminology: GetSysTerminology(subTypeCode) --> AEDesc"},
	{NULL, (PyCFunction) NULL, 0, NULL}
};                                 


void
initOSATerminology(void)
{
	Py_InitModule("OSATerminology", OSATerminology_methods);
}