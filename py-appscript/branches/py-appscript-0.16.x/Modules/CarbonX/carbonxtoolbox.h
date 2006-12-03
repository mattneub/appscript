/* 
** carbonxtoolbox - CarbonX.AE new/convert functions:
** AEDescX_New, AEDescX_NewBorrowed, AEDescX_Convert
**
** (C) 2006 HAS
*/

#include "pymactoolbox.h"

typedef struct CarbonXAE_API {
	PyObject *(*Ptr_AEDescX_New)(AppleEvent *);
	PyObject *(*Ptr_AEDescX_NewBorrowed)(AppleEvent *);
	int (*Ptr_AEDescX_Convert)(PyObject *, AppleEvent *);
} CarbonXAE_API;

