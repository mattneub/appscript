/*
 *  supportmodule.c
 *  PyOSA
 *
 *  Created by Hamish Sanderson on 09/02/2007.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#include "supportmodule.h"



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
/* Export mcpy_support functions. */

PyMethodDef mcpy_supportFunctions[] = {
	{"cobjectToInt", cobjectToInt, METH_VARARGS, 
			"cobjectToInt(CObject ptrObj) -> long result"}, // TEST
	
	{NULL, NULL, 0, NULL}
};

