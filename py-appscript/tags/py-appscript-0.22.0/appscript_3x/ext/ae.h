/* 
 * ae.h
 *
 * Provides access to the following aem.ae C functions:
 *
 * AE_AEDesc_New				// wrap AEDesc; Python takes ownership
 * AE_AEDesc_NewBorrowed		// wrap AEDesc; caller retains ownership
 * AE_AEDesc_Convert			// unwrap AEDesc; Python retains ownership
 * AE_AEDesc_ConvertDisown		// unwrap AEDesc; caller takes ownership
 * AE_GetMacOSErrorException	// returns aem.ae.MacOSError type	
 * AE_MacOSError				// raise aem.ae.MacOSError exception
 * AE_GetOSType					// convert 4-byte bytes object to OSType
 * AE_BuildOSType				// convert OSType to 4-byte bytes object
 *
 * Extensions that need to use these functions should include ae.h
 *
 */

#ifndef AE_MODULE_H
#define AE_MODULE_H

#ifdef __cplusplus
extern "C" {
#endif

#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include <ApplicationServices/ApplicationServices.h>

/* Header file for ae module */

#ifdef AE_MODULE_C
/* This section is used when compiling ae.c */

static PyObject *	AE_AEDesc_New				(AEDesc *);
static PyObject *	AE_AEDesc_NewBorrowed		(AEDesc *);
static int 		  	AE_AEDesc_Convert			(PyObject *, AEDesc *);
static int 		  	AE_AEDesc_ConvertDisown		(PyObject *, AEDesc *);
static PyObject *	AE_GetMacOSErrorException	(void);
static PyObject *	AE_MacOSError				(int);
static int 		  	AE_GetOSType				(PyObject *, OSType *);
static PyObject *	AE_BuildOSType				(OSType);

#else /* AE_MODULE_C */
/* This section is used in modules that use the ae module's API */

static void **AE_API;

#define AE_AEDesc_New				(*(PyObject *	(*)	(AEDesc *)			  )AE_API[0])
#define AE_AEDesc_NewBorrowed		(*(PyObject *	(*)	(AEDesc *)			  )AE_API[1])
#define AE_AEDesc_Convert			(*(int			(*)	(PyObject *, AEDesc *))AE_API[2])
#define AE_AEDesc_ConvertDisown		(*(int			(*)	(PyObject *, AEDesc *))AE_API[3])
#define AE_GetMacOSErrorException	(*(PyObject *	(*)	(void)				  )AE_API[4])
#define AE_MacOSError				(*(PyObject *	(*)	(int)				  )AE_API[5])
#define AE_GetOSType				(*(int			(*)	(PyObject *, OSType *))AE_API[6])
#define AE_BuildOSType				(*(PyObject *	(*)	(OSType)			  )AE_API[7])

/* Return -1 on error, 0 on success.
 * PyCapsule_Import will set an exception if there's an error.
 */
static int
import_ae(void)
{
    AE_API = (void **)PyCapsule_Import("ae._C_API", 0);
    return (AE_API != NULL) ? 0 : -1;
}

#endif /* AE_MODULE_C */

#ifdef __cplusplus
}
#endif

#endif /* AE_MODULE_H */
