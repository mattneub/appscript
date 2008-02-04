/* 
 * aemtoolbox.h
 *
 * Provides access to the following aem.ae C functions:
 *
 * AE_AEDesc_New, AE_AEDesc_NewBorrowed
 * AE_AEDesc_Convert, AE_AEDesc_ConvertDisown
 * AE_GetMacOSErrorException, AE_MacOSError
 * AE_GetOSType, AE_BuildOSType
 *
 * Extensions that need to use these functions should include aetoolbox.c
 *
 * (C) 2006-2008 HAS
 */

#include <Carbon/Carbon.h>

#include "Python.h"

typedef struct AE_CAPI {
	PyObject *(*Ptr_AE_AEDesc_New)(AppleEvent *);
	PyObject *(*Ptr_AE_AEDesc_NewBorrowed)(AppleEvent *);
	int	(*Ptr_AE_AEDesc_Convert)(PyObject *, AppleEvent *);
	int (*Ptr_AE_AEDesc_ConvertDisown)(PyObject *, AppleEvent *);
	PyObject *(*Ptr_AE_GetMacOSErrorException)(void);
	PyObject *(*Ptr_AE_MacOSError)(int err);
	int (*Ptr_AE_GetOSType)(PyObject *v, OSType *pr);
	PyObject *(*Ptr_AE_BuildOSType)(OSType t);
} AE_CAPI;

