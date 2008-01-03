/* 
** carbonxtoolbox - CarbonX.AE new/convert functions:
** AEDescX_New, AEDescX_NewBorrowed, AEDescX_Convert
**
** (C) 2006 HAS
*/

#include "carbonxtoolbox.h"

static int shouldLoad = 1;

static PyObject *(*Ptr_AEDescX_New)(AEDesc *);
static PyObject *(*Ptr_AEDescX_NewBorrowed)(AEDesc *);
static int (*Ptr_AEDescX_Convert)(PyObject *, AEDesc *);
static int (*Ptr_AEDescX_ConvertDisown)(PyObject *, AEDesc *);


static int LoadCarbonXAE() {
	PyObject *aeModule, *aeAPIObj;
	CarbonXAE_API *aeAPI;
	
	if ((aeModule = PyImport_ImportModule("CarbonX.AE")) == NULL) goto failed;
	if ((aeAPIObj = PyObject_GetAttrString(aeModule, "aeAPI")) == NULL) goto failed;
	if ((aeAPI = (CarbonXAE_API *)PyCObject_AsVoidPtr(aeAPIObj)) == NULL) goto failed;
	
	Ptr_AEDescX_New = aeAPI->Ptr_AEDescX_New;
	Ptr_AEDescX_NewBorrowed = aeAPI->Ptr_AEDescX_NewBorrowed;
	Ptr_AEDescX_Convert = aeAPI->Ptr_AEDescX_Convert;
	Ptr_AEDescX_ConvertDisown = aeAPI->Ptr_AEDescX_ConvertDisown;
	
	if (!Ptr_AEDescX_New) goto failed;
	shouldLoad = 0; 
	return 1;
failed:
	PyErr_SetString(PyExc_ImportError, "Couldn't load module: CarbonX.AE");
	return 0;
}


PyObject *AEDescX_New(AppleEvent * cobj) {
    if (shouldLoad) {
       if (!LoadCarbonXAE()) return NULL;
    }
    return (*Ptr_AEDescX_New)(cobj);
}


PyObject *AEDescX_NewBorrowed(AppleEvent * cobj) {
    if (shouldLoad) {
       if (!LoadCarbonXAE()) return NULL;
    }
    return (*Ptr_AEDescX_NewBorrowed)(cobj);
}


int AEDescX_Convert(PyObject *pyobj, AppleEvent *cobj) {
    if (shouldLoad) {
       if (!LoadCarbonXAE()) return 0;
    }
    return (*Ptr_AEDescX_Convert)(pyobj, cobj);
}


int AEDescX_ConvertDisown(PyObject *pyobj, AppleEvent *cobj) {
    if (shouldLoad) {
       if (!LoadCarbonXAE()) return 0;
    }
    return (*Ptr_AEDescX_ConvertDisown)(pyobj, cobj);
}
