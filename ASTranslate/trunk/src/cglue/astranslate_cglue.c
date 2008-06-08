
#include "Python.h"
#include "pymactoolbox.h"
#include <Carbon/Carbon.h>


/**********************************************************************/

static PyObject*
astranslate_cglue_PSNToPath(PyObject* self, PyObject* args)
{
	UInt32 highLongOfPSN;
	UInt32 lowLongOfPSN;
	ProcessSerialNumber psn;
	FSRef fsref;
	UInt8 path[PATH_MAX];
	PyObject* pathObj;
	OSStatus err;
	
	if (!PyArg_ParseTuple(args, "kk", &highLongOfPSN, &lowLongOfPSN))
		return NULL;
	psn.highLongOfPSN = highLongOfPSN;
	psn.lowLongOfPSN = lowLongOfPSN;
	err = GetProcessBundleLocation(&psn, &fsref);
	if (err) return PyMac_Error(err);
	err = FSRefMakePath(&fsref, path, sizeof(path));
	if (err) return PyMac_Error(err);
	pathObj = PyUnicode_DecodeUTF8((char *)path, strlen((char *)path), NULL);
	return Py_BuildValue("O", pathObj);
}


/**********************************************************************/

static PyMethodDef astranslate_cglue_methods[] = {
  	{"psntopath", astranslate_cglue_PSNToPath, METH_VARARGS,
		PyDoc_STR("(unsigned long highLongOfPSN, unsigned long highLongOfPSN) --> (UInt8 *path)")},
	{NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initastranslate_cglue(void)
{
	(void) Py_InitModule("astranslate_cglue", astranslate_cglue_methods);
}
