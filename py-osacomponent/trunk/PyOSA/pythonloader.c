/*
 * pythonloader.c
 *
 * Copyright (C) 2007 HAS
 *
 */

#include "pythonloader.h"

static isPythonFrameworkLoaded = false;


/**********************************************************************/
// Kludge; Python 2.3 doesn't export Py_DecRef or Py_IncRef (only added in Python 2.4),
// so need to define alternatives here

void Py_DecRef_py23(PyObject *op) { // TO DO: finish implementation
    if (op != NULL) {
        --(*op);
    }
}

void Py_IncRef_py23(PyObject *op) { // TO DO: finish implementation
    if (op != NULL) {
        ++(*op);
    }
}


/**********************************************************************/


static Boolean existsPath(char *path) {
	struct stat sb;
	return !stat(path, &sb);
}

static CFURLRef locatePrivatePythonFramework(void) {
	CFBundleRef hostBundle = NULL;
	CFURLRef baseURL = NULL;
	CFURLRef bundleURL = NULL;
	UInt8 bundlePath[PATH_MAX];
	
	hostBundle= CFBundleGetMainBundle();
	if (!hostBundle) return NULL;
	baseURL = CFBundleCopyPrivateFrameworksURL(hostBundle);
	if (!baseURL) return NULL;
	bundleURL = CFURLCreateCopyAppendingPathComponent(kCFAllocatorDefault, 
													  baseURL, 
													  CFSTR("Python.framework"), 
													  true);
	CFRelease(baseURL);
	if (!bundleURL) return NULL;
	if (CFURLGetFileSystemRepresentation(bundleURL, true, bundlePath, PATH_MAX))
		if (existsPath((char *)bundlePath)) return bundleURL;
	CFRelease(bundleURL);
	return NULL;
}


static CFURLRef locatePublicPythonFramework(void) {
	CFBundleRef pyosaBundle = NULL;
	CFDictionaryRef hostInfo = NULL;
	CFArrayRef pyFrameworkPaths = NULL;
	CFStringRef pyFrameworkPath = NULL;
	int i, count;
	char path[PATH_MAX];
	char expandedPath[PATH_MAX];
	CFStringRef expandedPathString;
	
	pyosaBundle = CFBundleGetBundleWithIdentifier(CFSTR(COMPONENT_IDENTIFIER));
	if (!pyosaBundle) return NULL;
	hostInfo = CFBundleGetInfoDictionary(pyosaBundle);
	if (!hostInfo) return NULL;
	pyFrameworkPaths = CFDictionaryGetValue(hostInfo, CFSTR(PYTHON_LOCATIONS_KEY));
	if (!pyFrameworkPaths) return NULL;
	count = CFArrayGetCount(pyFrameworkPaths);
	for (i = 0; i < count; i++) {
		pyFrameworkPath = (CFStringRef)CFArrayGetValueAtIndex(pyFrameworkPaths, i);
		if (pyFrameworkPath)
			if (CFStringGetFileSystemRepresentation(pyFrameworkPath, path, PATH_MAX))
				if (realpath(path, expandedPath)) {
					#ifdef DEBUG_ON
					fprintf(stderr, "    checking path: %s\n", expandedPath);
					#endif
					if (existsPath(expandedPath)) {
						#ifdef DEBUG_ON
						fprintf(stderr, "    ...found.\n");
						#endif
						expandedPathString = CFStringCreateWithFileSystemRepresentation(NULL, expandedPath);
						if (expandedPathString)
							return CFURLCreateWithFileSystemPath(NULL, expandedPathString, kCFURLPOSIXPathStyle, true);
					}
				}
	}
	return NULL;
}



static CFBundleRef createPythonFrameworkForFileURL(CFURLRef bundleURL) {
	CFBundleRef pyFramework = NULL;
	
	#ifdef DEBUG_ON
	CFDataRef d = CFURLCreateData(NULL, bundleURL, 0, 0);
	fprintf(stderr, "Creating CFBundle for %s\n", CFDataGetBytePtr(d));
	#endif
	pyFramework = CFBundleCreate(kCFAllocatorDefault, bundleURL);
	CFRelease(bundleURL);
	if (CFBundleLoadExecutable(pyFramework)) return pyFramework;
	CFRelease(pyFramework);
	return NULL;
}


/**********************************************************************/


static CFBundleRef createPythonFramework(void) {
	CFBundleRef pyFramework = NULL;
	CFURLRef bundleURL = NULL;
	
	// first see if Python framework is already loaded
	pyFramework = CFBundleGetBundleWithIdentifier(CFSTR("org.python.python"));
	if (pyFramework) {
		#ifdef DEBUG_ON
			fprintf(stderr, "PyOSA: Using existing Python framework\n");
		#endif
		return pyFramework;
	}
	// if not, see if host application has a private Python framework
	#ifdef DEBUG_ON
	fprintf(stderr, "PyOSA: checking for private framework...\n");
	#endif
	bundleURL = locatePrivatePythonFramework();
	if (bundleURL)
		pyFramework = createPythonFrameworkForFileURL(bundleURL);
	if (pyFramework) {
		return pyFramework;
	}
	// else search known locations for a public Python framework
	#ifdef DEBUG_ON
	fprintf(stderr, "PyOSA: checking for public framework...\n");
	#endif
	bundleURL = locatePublicPythonFramework();
	if (bundleURL)
		pyFramework = createPythonFrameworkForFileURL(bundleURL);
	if (pyFramework) {
		return pyFramework;
	}
	return NULL;
}



Boolean bindFunctions(CFBundleRef pyFramework) {
	// Python 2.3 doesn't export these symbols
	Py_DecRef = (Py_DecRef_ptr)CFBundleGetFunctionPointerForName(pyFramework, CFSTR("Py_DecRef"));
	if (!Py_DecRef)
		Py_DecRef = Py_DecRef_py23;
	Py_IncRef = (Py_IncRef_ptr)CFBundleGetFunctionPointerForName(pyFramework, CFSTR("Py_IncRef"));
	if (!Py_DecRef)
		Py_IncRef = Py_IncRef_py23;
		
#define bindFunction(name) \
	name = (name ## _ptr)CFBundleGetFunctionPointerForName(pyFramework, CFSTR(#name)); \
	if (!name) { \
		fprintf(stderr, "PyOSA: Couldn't bind " #name "\n"); \
		return 0; \
	}
	
	bindFunction(PyArg_ParseTuple);

	bindFunction(PyCObject_AsVoidPtr);
	bindFunction(PyCObject_FromVoidPtr);

	bindFunction(PyDict_New);

	bindFunction(PyErr_Fetch);
	bindFunction(PyErr_GivenExceptionMatches);
	bindFunction(PyErr_Occurred);
	bindFunction(PyErr_Print);
	bindFunction(PyErr_Restore);
	bindFunction(PyErr_SetString);

	bindFunction(PyImport_ImportModule);

	bindFunction(PyInstance_NewRaw);

	bindFunction(PyInt_AsLong);

	bindFunction(PyMac_BuildFSRef);
	bindFunction(PyMac_BuildOSType);
	bindFunction(PyMac_Error);
	bindFunction(PyMac_GetOSType);

	bindFunction(PyOS_InterruptOccurred);

	bindFunction(PyObject_CallMethod);
	bindFunction(PyObject_GetAttrString);
	bindFunction(PyObject_IsInstance);
	bindFunction(PyObject_Print);

	bindFunction(PyRun_SimpleFile);

	bindFunction(PyThreadState_Get);
	bindFunction(PyThreadState_Swap);
	
	bindFunction(Py_BuildValue);
	bindFunction(Py_EndInterpreter);
	bindFunction(Py_InitModule4); // TO DO: Py_InitModule is Python API version-dependent so need to replace with an API-independent alternative
	bindFunction(Py_Initialize);
	bindFunction(Py_IsInitialized);
	bindFunction(Py_NewInterpreter);

#undef bindFunction

	return 1;
}



static Boolean bindOther(CFBundleRef pyFramework) {
#define bindSymbol(name) \
	name ## _ptr = CFBundleGetDataPointerForName(pyFramework, CFSTR(#name)); \
	if (!name ## _ptr) { \
		fprintf(stderr, "PyOSA: Couldn't bind " #name "\n"); \
		return 0; \
	}
#define bindPyObject(name) \
	name = NULL; \
	void *name ## _ptr = NULL; \
	bindSymbol(name); \
	name = *((PyObject **)name ## _ptr); \
	if (!name) { \
		fprintf(stderr, "PyOSA: Couldn't get value for " #name "\n"); \
		return 0; \
	}
	
	bindSymbol(PyCObject_Type);
	bindSymbol(PyInt_Type);
	
	bindPyObject(PyExc_ImportError);
	
#undef bindSymbol
#undef bindPyObject
	
	return 1;
}


/**********************************************************************/
// loader

Boolean loadPythonFramework(void) {
	CFBundleRef pyFramework;
	
	if (!isPythonFrameworkLoaded) {
		pyFramework = createPythonFramework();
			if (!pyFramework) {
				fprintf(stderr, "Couldn't create Python framework.\n");
				return false;
			}
			if (!bindFunctions(pyFramework)) return false;
			if (!Py_IsInitialized()) {
				Py_Initialize();
				#ifdef DEBUG_ON
				fprintf(stderr, "Python interpreter initialised.\n");
				#endif
			}
			if (!bindOther(pyFramework)) return false;
		isPythonFrameworkLoaded = true;
	}
	return true;
}

