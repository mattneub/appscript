/*
 * pythonloader.h
 * 
 * Copyright (C) 2007 HAS
 *
 * Locates and binds a Python framework at runtime.
 *
 * Import rules are as follows:
 * - If host process already contains a Python bundle, use that.
 * - Else if host application bundle has a private Python framework, load that.
 * - Else locate a public Python framework at one of the following locations and load that:
 *		~/Library/Frameworks/Python.framework
 *		/Library/Frameworks/Python.framework
 *		/Network/Library/Frameworks/Python.framework
 *		/System/Library/Frameworks/Python.framework
 *
 */

#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include <sys/stat.h>

/**********************************************************************/
 
#define DEBUG_ON

/**********************************************************************/

#define COMPONENT_NAME "PyOSA"
#define COMPONENT_VERSION 0x00010000
#define COMPONENT_IDENTIFIER "net.sourceforge.appscript.pyosa"
#define COMPONENT_OSTYPE 'PyOC'
#define PYTHON_LOCATIONS_KEY "PyFrameworkLocations"

/**********************************************************************/
// Python macros

#define Py_INCREF(op) Py_IncRef(op)
#define Py_DECREF(op) Py_DecRef(op)
#define Py_XINCREF(op) if ((op) == NULL) ; else Py_INCREF(op)
#define Py_XDECREF(op) if ((op) == NULL) ; else Py_DECREF(op)


#define PyCObject_Check(op) PyObject_IsInstance(op, (PyObject *)PyCObject_Type_ptr)
#define PyInt_Check(op) PyObject_IsInstance(op, (PyObject *)PyInt_Type_ptr)


/**********************************************************************/
// Python data type defintions

typedef int PyObject;
typedef int PyThreadState;
typedef int PyTypeObject;
typedef int Py_ssize_t;

/**********************************************************************/
// Python types, objects

PyTypeObject *PyCObject_Type_ptr; // used for checking parameters to callback functions
PyTypeObject *PyInt_Type_ptr; // used for checking values returned by Python code


/**********************************************************************/
// Python objects

PyObject *PyExc_ImportError; // used by carbonxtoolbox when raising exception


/**********************************************************************/
// TO DO: replace all this as we need an API version-agnostic alternative to Py_InitModule4

#define METH_VARARGS  0x0001
#define PYTHON_API_VERSION 1012

#define Py_InitModule(name, methods) \
	Py_InitModule4(name, methods, (char *)NULL, (PyObject *)NULL, \
		       PYTHON_API_VERSION)

struct PyMethodDef { // TO DO: avoid as we need a API-version-agnostic alternative to Py_InitModule
    char	*ml_name;	/* The name of the built-in function/method */
    void *ml_meth; // PyCFunction  ml_meth;	/* The C function that implements it */
    int		 ml_flags;	/* Combination of METH_xxx flags, which mostly
				   describe the args expected by the C func */
    char	*ml_doc;	/* The __doc__ attribute, or NULL */
};
typedef struct PyMethodDef PyMethodDef;

typedef PyObject *(*Py_InitModule4_ptr)(char *name, PyMethodDef *methods, char *doc, PyObject *self, int apiver);

Py_InitModule4_ptr Py_InitModule4;


/**********************************************************************/
// Python function typedefs

typedef int (*PyArg_ParseTuple_ptr)(PyObject *, char *, ...);

typedef void *(*PyCObject_AsVoidPtr_ptr)(PyObject *);
typedef PyObject *(*PyCObject_FromVoidPtr_ptr)(void *, void (*destr)(void *));

typedef PyObject *(*PyDict_New_ptr)(void);

typedef void (*PyErr_Fetch_ptr)(PyObject **, PyObject **, PyObject **);
typedef int (*PyErr_GivenExceptionMatches_ptr)(PyObject *, PyObject *);
typedef PyObject *(*PyErr_Occurred_ptr)(void);
typedef void (*PyErr_Print_ptr)(void);
typedef void (*PyErr_Restore_ptr)(PyObject *, PyObject *, PyObject *);
typedef void (*PyErr_SetString_ptr)(PyObject *, const char *);

typedef PyObject *(*PyImport_ImportModule_ptr)(char *);

typedef PyObject *(*PyInstance_NewRaw_ptr)(PyObject *, PyObject *);

typedef long (*PyInt_AsLong_ptr)(PyObject *);

typedef PyObject *(*PyMac_BuildFSRef_ptr)(FSRef *);
typedef PyObject *(*PyMac_BuildOSType_ptr)(OSType);
typedef PyObject *(*PyMac_Error_ptr)(OSErr);
typedef int (*PyMac_GetOSType_ptr)(PyObject *, OSType *);

typedef int (*PyOS_InterruptOccurred_ptr)(void);

typedef PyObject *(*PyObject_CallMethod_ptr)(PyObject *, char *, char *, ...);
typedef PyObject *(*PyObject_GetAttrString_ptr)(PyObject *, char *);
typedef int (*PyObject_IsInstance_ptr)(PyObject *, PyObject *);
typedef int (*PyObject_Print_ptr)(PyObject *, FILE *, int);

typedef int (*PyRun_SimpleFile_ptr)(FILE *, const char *);

typedef PyThreadState *(*PyThreadState_Get_ptr)(void);
typedef PyThreadState *(*PyThreadState_Swap_ptr)(PyThreadState *);

typedef PyObject *(*Py_BuildValue_ptr)(char *, ...);
typedef void (*Py_EndInterpreter_ptr)(PyThreadState *);
typedef void (*Py_DecRef_ptr)(PyObject *);
typedef void (*Py_IncRef_ptr)(PyObject *);
typedef void (*Py_Initialize_ptr)(void);
typedef int (*Py_IsInitialized_ptr)(void);
typedef PyThreadState *(*Py_NewInterpreter_ptr)(void);

typedef PyObject *(*PyString_FromString_ptr)(const char *);
typedef int (*PySequence_Contains_ptr)(PyObject *, PyObject *);
typedef int (*PyList_Insert_ptr)(PyObject *, Py_ssize_t, PyObject *);


/**********************************************************************/
// Python functions

PyArg_ParseTuple_ptr PyArg_ParseTuple;

PyCObject_AsVoidPtr_ptr PyCObject_AsVoidPtr;
PyCObject_FromVoidPtr_ptr PyCObject_FromVoidPtr;

PyDict_New_ptr PyDict_New;

PyErr_Fetch_ptr PyErr_Fetch;
PyErr_GivenExceptionMatches_ptr PyErr_GivenExceptionMatches;
PyErr_Occurred_ptr PyErr_Occurred;
PyErr_Print_ptr PyErr_Print;
PyErr_Restore_ptr PyErr_Restore;
PyErr_SetString_ptr PyErr_SetString;

PyImport_ImportModule_ptr PyImport_ImportModule;

PyInstance_NewRaw_ptr PyInstance_NewRaw;

PyInt_AsLong_ptr PyInt_AsLong;

PyMac_BuildFSRef_ptr PyMac_BuildFSRef;
PyMac_BuildOSType_ptr PyMac_BuildOSType;
PyMac_Error_ptr PyMac_Error;
PyMac_GetOSType_ptr PyMac_GetOSType;

PyOS_InterruptOccurred_ptr PyOS_InterruptOccurred;

PyObject_CallMethod_ptr PyObject_CallMethod;
PyObject_GetAttrString_ptr PyObject_GetAttrString;
PyObject_IsInstance_ptr PyObject_IsInstance;
PyObject_Print_ptr PyObject_Print;

PyRun_SimpleFile_ptr PyRun_SimpleFile;

PyThreadState_Get_ptr PyThreadState_Get;
PyThreadState_Swap_ptr PyThreadState_Swap;

Py_BuildValue_ptr Py_BuildValue;
Py_EndInterpreter_ptr Py_EndInterpreter;
Py_DecRef_ptr Py_DecRef;
Py_IncRef_ptr Py_IncRef;
Py_Initialize_ptr Py_Initialize;
Py_IsInitialized_ptr Py_IsInitialized;
Py_NewInterpreter_ptr Py_NewInterpreter;

PyString_FromString_ptr PyString_FromString;
PySequence_Contains_ptr PySequence_Contains;
PyList_Insert_ptr PyList_Insert;


/**********************************************************************/
// loader

Boolean loadPythonFramework(void); // returns true on success, else false; subsequent calls are a no-op

