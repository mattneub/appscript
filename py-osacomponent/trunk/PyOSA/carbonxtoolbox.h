/* 
** carbonxtoolbox - CarbonX.AE new/convert functions:
** AEDescX_New, AEDescX_NewBorrowed, AEDescX_Convert, AEDescX_ConvertDisown
**
** (C) 2006 HAS
*/

#include <Carbon/Carbon.h>
#include "Python/Python.h"
#include "Python/pymactoolbox.h"


typedef struct CarbonXAE_API {
	PyObject *(*Ptr_AEDescX_New)(AppleEvent *);
	PyObject *(*Ptr_AEDescX_NewBorrowed)(AppleEvent *);
	int (*Ptr_AEDescX_Convert)(PyObject *, AppleEvent *);
	int (*Ptr_AEDescX_ConvertDisown)(PyObject *, AEDesc *);
} CarbonXAE_API;


PyObject *AEDescX_New(AppleEvent * cobj);
PyObject *AEDescX_NewBorrowed(AppleEvent * cobj);
int AEDescX_Convert(PyObject *pyobj, AppleEvent *cobj);
int AEDescX_ConvertDisown(PyObject *pyobj, AppleEvent *cobj);