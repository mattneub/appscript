/* 
** aetoolbox.c
*/

#include "aetoolbox.h"

static int shouldLoad = 1;

static PyObject *(*Ptr_AE_AEDesc_New)(AEDesc *);
static PyObject *(*Ptr_AE_AEDesc_NewBorrowed)(AEDesc *);
static int (*Ptr_AE_AEDesc_Convert)(PyObject *, AEDesc *);
static int (*Ptr_AE_AEDesc_ConvertDisown)(PyObject *, AEDesc *);
static PyObject *(*Ptr_AE_GetMacOSErrorException)(void);
static PyObject *(*Ptr_AE_MacOSError)(int err);
static int (*Ptr_AE_GetOSType)(PyObject *v, OSType *pr);
static PyObject *(*Ptr_AE_BuildOSType)(OSType t);

static int LoadAEExtension(void) {
	PyObject *aeModule, *aeAPIObj;
	AE_CAPI *aeAPI;
	
	if ((aeModule = PyImport_ImportModule("aem.ae")) == NULL) goto failed;
	if ((aeAPIObj = PyObject_GetAttrString(aeModule, "aetoolbox")) == NULL) goto failed;
	if ((aeAPI = (AE_CAPI *)PyCObject_AsVoidPtr(aeAPIObj)) == NULL) goto failed;
	
	Ptr_AE_AEDesc_New = aeAPI->Ptr_AE_AEDesc_New;
	Ptr_AE_AEDesc_NewBorrowed = aeAPI->Ptr_AE_AEDesc_NewBorrowed;
	Ptr_AE_AEDesc_Convert = aeAPI->Ptr_AE_AEDesc_Convert;
	Ptr_AE_AEDesc_ConvertDisown = aeAPI->Ptr_AE_AEDesc_ConvertDisown;
	Ptr_AE_GetMacOSErrorException = aeAPI->Ptr_AE_GetMacOSErrorException;
	Ptr_AE_MacOSError = aeAPI->Ptr_AE_MacOSError;
	Ptr_AE_GetOSType = aeAPI->Ptr_AE_GetOSType;
	Ptr_AE_BuildOSType = aeAPI->Ptr_AE_BuildOSType;
	
	if (!Ptr_AE_AEDesc_New) goto failed;
	shouldLoad = 0; 
	return 1;
failed:
	PyErr_SetString(PyExc_ImportError, "Couldn't load module: aem.ae");
	return 0;
}


PyObject *AE_AEDesc_New(AppleEvent * cobj) {
    if (shouldLoad && !LoadAEExtension()) return NULL;
    return (*Ptr_AE_AEDesc_New)(cobj);
}


PyObject *AE_AEDesc_NewBorrowed(AppleEvent * cobj) {
    if (shouldLoad && !LoadAEExtension()) return NULL;
    return (*Ptr_AE_AEDesc_NewBorrowed)(cobj);
}


int AE_AEDesc_Convert(PyObject *pyobj, AppleEvent *cobj) {
    if (shouldLoad && !LoadAEExtension()) return 0;
    return (*Ptr_AE_AEDesc_Convert)(pyobj, cobj);
}


int AE_AEDesc_ConvertDisown(PyObject *pyobj, AppleEvent *cobj) {
    if (shouldLoad && !LoadAEExtension()) return 0;
    return (*Ptr_AE_AEDesc_ConvertDisown)(pyobj, cobj);
}

PyObject *AE_GetMacOSErrorException(void) {
    if (shouldLoad && !LoadAEExtension()) return NULL;
    return (*Ptr_AE_GetMacOSErrorException)();
}

PyObject *AE_MacOSError(int err) {
    if (shouldLoad && !LoadAEExtension()) return NULL;
    return (*Ptr_AE_MacOSError)(err);
}

int AE_GetOSType(PyObject *v, OSType *pr) {
    if (shouldLoad && !LoadAEExtension()) return 0;
    return (*Ptr_AE_GetOSType)(v, pr);
}

PyObject *AE_BuildOSType(OSType t) {
    if (shouldLoad && !LoadAEExtension()) return NULL;
    return (*Ptr_AE_BuildOSType)(t);
}

