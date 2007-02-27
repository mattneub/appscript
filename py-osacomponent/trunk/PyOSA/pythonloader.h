/*
 * pythonloader.h
 * 
 * Copyright (C) 2007 HAS
 *
 *
 * file:///Developer/ADC%20Reference%20Library/documentation/Cocoa/Conceptual/CarbonCocoaDoc/Articles/LazyCocoaLoading.html
 * file:///Developer/ADC%20Reference%20Library/documentation/CoreFoundation/Conceptual/CFBundles/index.html
 * file:///Developer/ADC%20Reference%20Library/documentation/CoreFoundation/Reference/CFBundleRef/index.html
 *
 */

#define COMPONENT_NAME "PyOSA"
#define COMPONENT_VERSION 0x00010000
#define COMPONENT_IDENTIFIER "net.sourceforge.appscript.pyosa"
#define COMPONENT_OSTYPE 'PyOC'
#define PYTHON_LOCATIONS_KEY "PyFrameworkLocations"
 
#define DEBUG_ON

/**********************************************************************/

#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include <sys/stat.h>

/**********************************************************************/
// Python macros

#define Py_INCREF(op) Py_IncRef(op)
#define Py_DECREF(op) Py_DecRef(op)
#define Py_XINCREF(op) if ((op) == NULL) ; else Py_INCREF(op)
#define Py_XDECREF(op) if ((op) == NULL) ; else Py_DECREF(op)

// TO DO: #define PyCObject_Check(op) ((op)->ob_type == &PyCObject_Type)
#define PyCObject_Check(op) (true)

// TO DO: #define PyInt_Check(op) PyObject_TypeCheck(op, &PyInt_Type)
#define PyInt_Check(op) (true)


/**********************************************************************/
// Python data type defintions

typedef int PyObject;
typedef int PyThreadState;


/**********************************************************************/
// predefined Python objects

// TO DO: make sure these are initialised correctly (should bind Py_IsInitialized and Py_Initialize first, and call them to init framework before doing anything else)

PyObject *PyExc_ImportError;
PyObject *PyExc_TypeError;


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
// Python function defs

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
PyObject_Print_ptr PyObject_Print;

PyRun_SimpleFile_ptr PyRun_SimpleFile;

PyThreadState_Get_ptr PyThreadState_Get;
PyThreadState_Swap_ptr PyThreadState_Swap;

Py_BuildValue_ptr Py_BuildValue;
Py_EndInterpreter_ptr Py_EndInterpreter;
Py_Initialize_ptr Py_Initialize;
Py_IsInitialized_ptr Py_IsInitialized;
Py_NewInterpreter_ptr Py_NewInterpreter;


/**********************************************************************/
// TO DO

//Py_DecRef_ptr Py_DecRef; // TO DO: fails to bind; why?
//Py_IncRef_ptr Py_IncRef; // TO DO: fails to bind; why?
void Py_DecRef(PyObject *op); // TO DO: kludge; use stubby alternatives for now
void Py_IncRef(PyObject *op); // TO DO: kludge; use stubby alternatives for now


/**********************************************************************/
// loader

CFBundleRef createPythonFramework(void); // returns Python.framework bundle on success, else NULL
Boolean bindPythonFramework(CFBundleRef pyFramework);  // returns true on success, else false

Boolean isPythonFrameworkLoaded(void);
