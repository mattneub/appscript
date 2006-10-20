
//	Modified by HAS, 2005

/* ========================== Module _OSA =========================== */

#include "Python.h"

#include "pymactoolbox.h"

/* Macro to test whether a weak-loaded CFM function exists */
#define PyMac_PRECHECK(rtn) do { if ( &rtn == NULL )  {\
        PyErr_SetString(PyExc_NotImplementedError, \
        "Not available in this shared library/OS version"); \
        return NULL; \
    }} while(0)


#if PY_VERSION_HEX < 0x02040000
PyObject *PyMac_GetOSErrException(void);
#endif
#include <Carbon/Carbon.h>

#ifdef USE_TOOLBOX_OBJECT_GLUE
extern PyObject *_OSAObj_New(ComponentInstance);
extern int _OSAObj_Convert(PyObject *, ComponentInstance *);

#define OSAObj_New _OSAObj_New
#define OSAObj_Convert _OSAObj_Convert
#endif

/*************************** BEGIN NEW CODE *****************************/

#include "GetASFormatting.c"
#include "SetASFormatting.c"

#define CheckComponentSubtype(subtype) \
	ComponentDescription cd; \
	_err = GetComponentInfo((Component)_self->ob_itself, &cd, NULL, NULL, NULL); \
	if (_err != noErr) return PyMac_Error(_err); \
	if (cd.componentSubType != subtype) return PyMac_Error(errOSABadSelector);


PyObject* module_AE;
AEIdleUPP upp_AEIdleProc;

static pascal OSErr GenericActiveFunction(long refcon);


static pascal OSErr 
GenericCreateAppleEventFunction(AEEventClass theAEEventClass,
								AEEventID theAEEventID,
								const AEAddressDesc *target,
								short returnID,
								long transactionID,
								AppleEvent *result,
								long refcon);


static pascal OSErr 
GenericSendFunction(const AppleEvent *theAppleEvent,
					AppleEvent *reply,
					AESendMode sendMode,
					AESendPriority sendPriority,
					long timeOutInTicks,
					AEIdleUPP idleProc,
					AEFilterUPP filterProc,
					long refcon);


static pascal OSErr 
GenericEventHandlerFunction(const AppleEvent *theAppleEvent, 
							AppleEvent *reply,
							SInt32 refcon);

OSAActiveUPP upp_GenericActiveFunction;
OSACreateAppleEventUPP upp_GenericCreateAppleEventFunction;
OSASendUPP upp_GenericSendFunction;
AEEventHandlerUPP upp_GenericEventHandlerFunction;

PyObject *ActiveUPPWrapper_NEW(OSAActiveUPP procUPP, long refcon);
PyObject *CreateAppleEventUPPWrapper_NEW(OSACreateAppleEventUPP procUPP, long refcon);
PyObject *SendUPPWrapper_NEW(OSASendUPP procUPP, long refcon);
PyObject *EventHandlerUPPWrapper_NEW(AEEventHandlerUPP procUPP, long refcon);

PyTypeObject ActiveUPPWrapper_Type;
PyTypeObject CreateAppleEventUPPWrapper_Type;
PyTypeObject SendUPPWrapper_Type;
PyTypeObject EventHandlerUPPWrapper_Type;


typedef struct {
  PyObject_HEAD
  void *procUPP;
  long refcon;
} UPPWrapperObject;


/* nicked from _AEmodule.c */

static pascal Boolean AEIdleProc(EventRecord *theEvent, long *sleepTime, RgnHandle *mouseRgn)
{
	if ( PyOS_InterruptOccurred() )
		return 1;
	return 0;
}

typedef struct AEDescObject {
	PyObject_HEAD
	AEDesc ob_itself;
	int ob_owned;
} AEDescObject;

/* end nicked */

/***************************** END NEW CODE *****************************/

static PyObject *OSA_Error;

/* ---------------- Object type OSAComponentInstance ---------------- */

PyTypeObject OSAComponentInstance_Type;

#define OSAObj_Check(x) ((x)->ob_type == &OSAComponentInstance_Type || PyObject_TypeCheck((x), &OSAComponentInstance_Type))

typedef struct OSAComponentInstanceObject {
	PyObject_HEAD
	ComponentInstance ob_itself;
} OSAComponentInstanceObject;

PyObject *OSAObj_New(ComponentInstance itself)
{
	OSAComponentInstanceObject *it;
	if (itself == NULL) {
						PyErr_SetString(OSA_Error,"NULL ComponentInstance");
						return NULL;
					}
	it = PyObject_NEW(OSAComponentInstanceObject, &OSAComponentInstance_Type);
	if (it == NULL) return NULL;
	it->ob_itself = itself;
	return (PyObject *)it;
}
int OSAObj_Convert(PyObject *v, ComponentInstance *p_itself)
{

				if (CmpInstObj_Convert(v, p_itself))
					return 1;
				PyErr_Clear();
				
	if (!OSAObj_Check(v))
	{
		PyErr_SetString(PyExc_TypeError, "OSAComponentInstance required");
		return 0;
	}
	*p_itself = ((OSAComponentInstanceObject *)v)->ob_itself;
	return 1;
}

static void OSAObj_dealloc(OSAComponentInstanceObject *self)
{
	/* Cleanup of self->ob_itself goes here */
	self->ob_type->tp_free((PyObject *)self);
}

static PyObject *OSAObj_OSALoad(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc scriptData;
	long modeFlags;
	OSAID resultingScriptID;
#ifndef OSALoad
	PyMac_PRECHECK(OSALoad);
#endif
	if (!PyArg_ParseTuple(_args, "O&l",
	                      AEDesc_Convert, &scriptData,
	                      &modeFlags))
		return NULL;
	_err = OSALoad(_self->ob_itself,
	               &scriptData,
	               modeFlags,
	               &resultingScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptID);
	return _res;
}

static PyObject *OSAObj_OSAStore(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
	DescType desiredType;
	long modeFlags;
	AEDesc resultingScriptData;
#ifndef OSAStore
	PyMac_PRECHECK(OSAStore);
#endif
	if (!PyArg_ParseTuple(_args, "lO&l",
	                      &scriptID,
	                      PyMac_GetOSType, &desiredType,
	                      &modeFlags))
		return NULL;
	_err = OSAStore(_self->ob_itself,
	                scriptID,
	                desiredType,
	                modeFlags,
	                &resultingScriptData);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingScriptData);
	return _res;
}

static PyObject *OSAObj_OSAExecute(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID compiledScriptID;
	OSAID contextID;
	long modeFlags;
	OSAID resultingScriptValueID;
#ifndef OSAExecute
	PyMac_PRECHECK(OSAExecute);
#endif
	if (!PyArg_ParseTuple(_args, "lll",
	                      &compiledScriptID,
	                      &contextID,
	                      &modeFlags))
		return NULL;
	_err = OSAExecute(_self->ob_itself,
	                  compiledScriptID,
	                  contextID,
	                  modeFlags,
	                  &resultingScriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptValueID);
	return _res;
}

static PyObject *OSAObj_OSADisplay(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptValueID;
	DescType desiredType;
	long modeFlags;
	AEDesc resultingText;
#ifndef OSADisplay
	PyMac_PRECHECK(OSADisplay);
#endif
	if (!PyArg_ParseTuple(_args, "lO&l",
	                      &scriptValueID,
	                      PyMac_GetOSType, &desiredType,
	                      &modeFlags))
		return NULL;
	_err = OSADisplay(_self->ob_itself,
	                  scriptValueID,
	                  desiredType,
	                  modeFlags,
	                  &resultingText);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingText);
	return _res;
}

static PyObject *OSAObj_OSAScriptError(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSType selector;
	DescType desiredType;
	AEDesc resultingErrorDescription;
#ifndef OSAScriptError
	PyMac_PRECHECK(OSAScriptError);
#endif
	if (!PyArg_ParseTuple(_args, "O&O&",
	                      PyMac_GetOSType, &selector,
	                      PyMac_GetOSType, &desiredType))
		return NULL;
	_err = OSAScriptError(_self->ob_itself,
	                      selector,
	                      desiredType,
	                      &resultingErrorDescription);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingErrorDescription);
	return _res;
}

static PyObject *OSAObj_OSADispose(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
#ifndef OSADispose
	PyMac_PRECHECK(OSADispose);
#endif
	if (!PyArg_ParseTuple(_args, "l",
	                      &scriptID))
		return NULL;
	_err = OSADispose(_self->ob_itself,
	                  scriptID);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *OSAObj_OSASetScriptInfo(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
	OSType selector;
	long value;
#ifndef OSASetScriptInfo
	PyMac_PRECHECK(OSASetScriptInfo);
#endif
	if (!PyArg_ParseTuple(_args, "lO&l",
	                      &scriptID,
	                      PyMac_GetOSType, &selector,
	                      &value))
		return NULL;
	_err = OSASetScriptInfo(_self->ob_itself,
	                        scriptID,
	                        selector,
	                        value);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *OSAObj_OSAGetScriptInfo(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
	OSType selector;
	long result;
#ifndef OSAGetScriptInfo
	PyMac_PRECHECK(OSAGetScriptInfo);
#endif
	if (!PyArg_ParseTuple(_args, "lO&",
	                      &scriptID,
	                      PyMac_GetOSType, &selector))
		return NULL;
	_err = OSAGetScriptInfo(_self->ob_itself,
	                        scriptID,
	                        selector,
	                        &result);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     result);
	return _res;
}

static PyObject *OSAObj_OSAScriptingComponentName(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc resultingScriptingComponentName;
#ifndef OSAScriptingComponentName
	PyMac_PRECHECK(OSAScriptingComponentName);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAScriptingComponentName(_self->ob_itself,
	                                 &resultingScriptingComponentName);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingScriptingComponentName);
	return _res;
}

static PyObject *OSAObj_OSACompile(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc sourceData;
	long modeFlags;
	OSAID previousAndResultingScriptID = kOSANullScript;
#ifndef OSACompile
	PyMac_PRECHECK(OSACompile);
#endif
	if (!PyArg_ParseTuple(_args, "O&ll",
	                      AEDesc_Convert, &sourceData,
	                      &modeFlags,
						  &previousAndResultingScriptID)) // FIXED
		return NULL;
	_err = OSACompile(_self->ob_itself,
	                  &sourceData,
	                  modeFlags,
	                  &previousAndResultingScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     previousAndResultingScriptID);
	return _res;
}

static PyObject *OSAObj_OSACopyID(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID fromID;
	OSAID toID;
#ifndef OSACopyID
	PyMac_PRECHECK(OSACopyID);
#endif
	if (!PyArg_ParseTuple(_args, "l",
	                      &fromID))
		return NULL;
	_err = OSACopyID(_self->ob_itself,
	                 fromID,
	                 &toID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     toID);
	return _res;
}

static PyObject *OSAObj_OSAGetSource(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
	DescType desiredType;
	AEDesc resultingSourceData;
#ifndef OSAGetSource
	PyMac_PRECHECK(OSAGetSource);
#endif
	if (!PyArg_ParseTuple(_args, "lO&",
	                      &scriptID,
	                      PyMac_GetOSType, &desiredType))
		return NULL;
	_err = OSAGetSource(_self->ob_itself,
	                    scriptID,
	                    desiredType,
	                    &resultingSourceData);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingSourceData);
	return _res;
}

static PyObject *OSAObj_OSACoerceFromDesc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc scriptData;
	long modeFlags;
	OSAID resultingScriptID;
#ifndef OSACoerceFromDesc
	PyMac_PRECHECK(OSACoerceFromDesc);
#endif
	if (!PyArg_ParseTuple(_args, "O&l",
	                      AEDesc_Convert, &scriptData,
	                      &modeFlags))
		return NULL;
	_err = OSACoerceFromDesc(_self->ob_itself,
	                         &scriptData,
	                         modeFlags,
	                         &resultingScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptID);
	return _res;
}

static PyObject *OSAObj_OSACoerceToDesc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
	DescType desiredType;
	long modeFlags;
	AEDesc result;
#ifndef OSACoerceToDesc
	PyMac_PRECHECK(OSACoerceToDesc);
#endif
	if (!PyArg_ParseTuple(_args, "lO&l",
	                      &scriptID,
	                      PyMac_GetOSType, &desiredType,
	                      &modeFlags))
		return NULL;
	_err = OSACoerceToDesc(_self->ob_itself,
	                       scriptID,
	                       desiredType,
	                       modeFlags,
	                       &result);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &result);
	return _res;
}

static PyObject *OSAObj_OSASetDefaultTarget(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEAddressDesc target;
#ifndef OSASetDefaultTarget
	PyMac_PRECHECK(OSASetDefaultTarget);
#endif
	if (!PyArg_ParseTuple(_args, "O&",
	                      AEDesc_Convert, &target))
		return NULL;
	_err = OSASetDefaultTarget(_self->ob_itself,
	                           &target);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *OSAObj_OSAStartRecording(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID compiledScriptToModifyID;
#ifndef OSAStartRecording
	PyMac_PRECHECK(OSAStartRecording);
#endif
	if (!PyArg_ParseTuple(_args, "l",
	                      &compiledScriptToModifyID)) // FIXED
		return NULL;
	_err = OSAStartRecording(_self->ob_itself,
	                         &compiledScriptToModifyID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     compiledScriptToModifyID);
	return _res;
}

static PyObject *OSAObj_OSAStopRecording(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID compiledScriptID;
#ifndef OSAStopRecording
	PyMac_PRECHECK(OSAStopRecording);
#endif
	if (!PyArg_ParseTuple(_args, "l",
	                      &compiledScriptID))
		return NULL;
	_err = OSAStopRecording(_self->ob_itself,
	                        compiledScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *OSAObj_OSALoadExecute(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc scriptData;
	OSAID contextID;
	long modeFlags;
	OSAID resultingScriptValueID;
#ifndef OSALoadExecute
	PyMac_PRECHECK(OSALoadExecute);
#endif
	if (!PyArg_ParseTuple(_args, "O&ll",
	                      AEDesc_Convert, &scriptData,
	                      &contextID,
	                      &modeFlags))
		return NULL;
	_err = OSALoadExecute(_self->ob_itself,
	                      &scriptData,
	                      contextID,
	                      modeFlags,
	                      &resultingScriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptValueID);
	return _res;
}

static PyObject *OSAObj_OSACompileExecute(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc sourceData;
	OSAID contextID;
	long modeFlags;
	OSAID resultingScriptValueID;
#ifndef OSACompileExecute
	PyMac_PRECHECK(OSACompileExecute);
#endif
	if (!PyArg_ParseTuple(_args, "O&ll",
	                      AEDesc_Convert, &sourceData,
	                      &contextID,
	                      &modeFlags))
		return NULL;
	_err = OSACompileExecute(_self->ob_itself,
	                         &sourceData,
	                         contextID,
	                         modeFlags,
	                         &resultingScriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptValueID);
	return _res;
}

static PyObject *OSAObj_OSADoScript(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc sourceData;
	OSAID contextID;
	DescType desiredType;
	long modeFlags;
	AEDesc resultingText;
#ifndef OSADoScript
	PyMac_PRECHECK(OSADoScript);
#endif
	if (!PyArg_ParseTuple(_args, "O&lO&l",
	                      AEDesc_Convert, &sourceData,
	                      &contextID,
	                      PyMac_GetOSType, &desiredType,
	                      &modeFlags))
		return NULL;
	_err = OSADoScript(_self->ob_itself,
	                   &sourceData,
	                   contextID,
	                   desiredType,
	                   modeFlags,
	                   &resultingText);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingText);
	return _res;
}

static PyObject *OSAObj_OSASetCurrentDialect(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	short dialectCode;
#ifndef OSASetCurrentDialect
	PyMac_PRECHECK(OSASetCurrentDialect);
#endif
	if (!PyArg_ParseTuple(_args, "h",
	                      &dialectCode))
		return NULL;
	_err = OSASetCurrentDialect(_self->ob_itself,
	                            dialectCode);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *OSAObj_OSAGetCurrentDialect(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	short resultingDialectCode;
#ifndef OSAGetCurrentDialect
	PyMac_PRECHECK(OSAGetCurrentDialect);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAGetCurrentDialect(_self->ob_itself,
	                            &resultingDialectCode);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("h",
	                     resultingDialectCode);
	return _res;
}

static PyObject *OSAObj_OSAAvailableDialects(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc resultingDialectInfoList;
#ifndef OSAAvailableDialects
	PyMac_PRECHECK(OSAAvailableDialects);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAAvailableDialects(_self->ob_itself,
	                            &resultingDialectInfoList);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingDialectInfoList);
	return _res;
}

static PyObject *OSAObj_OSAGetDialectInfo(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	short dialectCode;
	OSType selector;
	AEDesc resultingDialectInfo;
#ifndef OSAGetDialectInfo
	PyMac_PRECHECK(OSAGetDialectInfo);
#endif
	if (!PyArg_ParseTuple(_args, "hO&",
	                      &dialectCode,
	                      PyMac_GetOSType, &selector))
		return NULL;
	_err = OSAGetDialectInfo(_self->ob_itself,
	                         dialectCode,
	                         selector,
	                         &resultingDialectInfo);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingDialectInfo);
	return _res;
}

static PyObject *OSAObj_OSAAvailableDialectCodeList(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc resultingDialectCodeList;
#ifndef OSAAvailableDialectCodeList
	PyMac_PRECHECK(OSAAvailableDialectCodeList);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAAvailableDialectCodeList(_self->ob_itself,
	                                   &resultingDialectCodeList);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingDialectCodeList);
	return _res;
}

static PyObject *OSAObj_OSAExecuteEvent(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AppleEvent theAppleEvent;
	OSAID contextID;
	long modeFlags;
	OSAID resultingScriptValueID;
#ifndef OSAExecuteEvent
	PyMac_PRECHECK(OSAExecuteEvent);
#endif
	if (!PyArg_ParseTuple(_args, "O&ll",
	                      AEDesc_Convert, &theAppleEvent,
	                      &contextID,
	                      &modeFlags))
		return NULL;
	_err = OSAExecuteEvent(_self->ob_itself,
	                       &theAppleEvent,
	                       contextID,
	                       modeFlags,
	                       &resultingScriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptValueID);
	return _res;
}

static PyObject *OSAObj_OSADoEvent(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AppleEvent theAppleEvent;
	OSAID contextID;
	long modeFlags;
	AppleEvent reply;
#ifndef OSADoEvent
	PyMac_PRECHECK(OSADoEvent);
#endif
	if (!PyArg_ParseTuple(_args, "O&llO&",
	                      AEDesc_Convert, &theAppleEvent,
	                      &contextID,
	                      &modeFlags,
						  AEDesc_Convert, &reply)) // FIXED
		return NULL;
	_err = OSADoEvent(_self->ob_itself,
	                  &theAppleEvent,
	                  contextID,
	                  modeFlags,
	                  &reply);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res; // FIXED
}

static PyObject *OSAObj_OSAMakeContext(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc contextName;
	OSAID parentContext;
	OSAID resultingContextID;
#ifndef OSAMakeContext
	PyMac_PRECHECK(OSAMakeContext);
#endif
	if (!PyArg_ParseTuple(_args, "O&l",
	                      AEDesc_Convert, &contextName,
	                      &parentContext))
		return NULL;
	_err = OSAMakeContext(_self->ob_itself,
	                      &contextName,
	                      parentContext,
	                      &resultingContextID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingContextID);
	return _res;
}


/*************************** BEGIN NEW CODE *****************************/



static PyObject *OSAObj_OSAGetActiveProc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	OSAActiveUPP procUPP;
	long refcon;
	PyObject *handler;
#ifndef OSAGetActiveProc
	PyMac_PRECHECK(OSAGetActiveProc);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAGetActiveProc(_self->ob_itself,
							&procUPP, 
							&refcon);
	if (_err != noErr) return PyMac_Error(_err);
	
	if (procUPP == upp_GenericActiveFunction) {
		handler = (PyObject *)refcon;
		_res = Py_BuildValue("O",
							 handler); // increments refcount of returned Python function
	} else
		_res = ActiveUPPWrapper_NEW(procUPP, refcon); // returns wrapper instance with refcount of 1
	return _res;
}


static PyObject *OSAObj_OSASetActiveProc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	OSAActiveUPP procUPP, oldProcUPP;
	long refcon, oldRefcon;
	PyObject *handler;
#ifndef OSASetActiveProc
	PyMac_PRECHECK(OSASetActiveProc);
#endif
	if (!PyArg_ParseTuple(_args, "O",
	                      &handler))
		return NULL;
	if (PyObject_TypeCheck(handler, &ActiveUPPWrapper_Type)) {
		procUPP = ((UPPWrapperObject *)handler)->procUPP;
		refcon = ((UPPWrapperObject *)handler)->refcon;
	} else if (PyCallable_Check(handler)) {
		procUPP = upp_GenericActiveFunction;
		refcon = (long)handler;
	} else {
		PyErr_SetString(PyExc_TypeError, "Not a callable object.");
		return NULL;
	}
	_err = OSAGetActiveProc(_self->ob_itself,
							&oldProcUPP, 
							&oldRefcon);
	if (_err != noErr) return PyMac_Error(_err);
	_err = OSASetActiveProc(_self->ob_itself,
							procUPP,
							refcon);
	if (_err != noErr) return PyMac_Error(_err);
	if (oldProcUPP == upp_GenericActiveFunction) {
		Py_DECREF((PyObject *)oldRefcon); // when replacing a Python callback, decrement its refcount
	}
	if (procUPP == upp_GenericActiveFunction) {
		Py_INCREF(handler); // when inserting a Python callback, increment its refcount
	}
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}



static PyObject *OSAObj_OSAGetCreateProc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	OSACreateAppleEventUPP procUPP;
	long refcon;
	PyObject *handler;
#ifndef OSAGetCreateProc
	PyMac_PRECHECK(OSAGetCreateProc);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAGetCreateProc(_self->ob_itself,
							&procUPP, 
							&refcon);
	if (_err != noErr) return PyMac_Error(_err);
	
	if (procUPP == upp_GenericCreateAppleEventFunction) {
		handler = (PyObject *)refcon;
		_res = Py_BuildValue("O",
							 handler);
	} else
		_res = CreateAppleEventUPPWrapper_NEW(procUPP, refcon);
	return _res;
}


static PyObject *OSAObj_OSASetCreateProc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	OSACreateAppleEventUPP procUPP, oldProcUPP;
	long refcon, oldRefcon;
	PyObject *handler;
#ifndef OSASetCreateProc
	PyMac_PRECHECK(OSASetCreateProc);
#endif
	if (!PyArg_ParseTuple(_args, "O",
	                      &handler))
		return NULL;
	if (PyObject_TypeCheck(handler, &CreateAppleEventUPPWrapper_Type)) {
		procUPP = ((UPPWrapperObject *)handler)->procUPP;
		refcon = ((UPPWrapperObject *)handler)->refcon;
	} else if (PyCallable_Check(handler)) {
		procUPP = upp_GenericCreateAppleEventFunction;
		refcon = (long)handler;
	} else {
		PyErr_SetString(PyExc_TypeError, "Not a callable object.");
		return NULL;
	}
	_err = OSAGetCreateProc(_self->ob_itself,
							&oldProcUPP, 
							&oldRefcon);
	if (_err != noErr) return PyMac_Error(_err);
	_err = OSASetCreateProc(_self->ob_itself,
							procUPP,
							refcon);
	if (_err != noErr) return PyMac_Error(_err);
	if (oldProcUPP == upp_GenericCreateAppleEventFunction) {
		Py_DECREF((PyObject *)oldRefcon); // when replacing a Python callback, decrement its refcount
	}
	if (procUPP == upp_GenericCreateAppleEventFunction) {
		Py_INCREF(handler); // when inserting a Python callback, increment its refcount
	}
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}



static PyObject *OSAObj_OSAGetSendProc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	OSASendUPP procUPP;
	long refcon;
	PyObject *handler;
#ifndef OSAGetSendProc
	PyMac_PRECHECK(OSAGetSendProc);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAGetSendProc(_self->ob_itself,
						  &procUPP, 
						  &refcon);
	if (_err != noErr) return PyMac_Error(_err);
	
	if (procUPP == upp_GenericSendFunction) {
		handler = (PyObject *)refcon;
		_res = Py_BuildValue("O",
							 handler);
	} else
		_res = SendUPPWrapper_NEW(procUPP, refcon);
	return _res;
}


static PyObject *OSAObj_OSASetSendProc(OSAComponentInstanceObject *_self, PyObject *_args)
// TO DO: Py_DECREF() current refcon if current procUPP is upp_GenericUPPWrapper
{
	PyObject *_res = NULL;
	OSErr _err;
	OSASendUPP procUPP, oldProcUPP;
	long refcon, oldRefcon;
	PyObject *handler;
#ifndef OSASetSendProc
	PyMac_PRECHECK(OSASetSendProc);
#endif
	if (!PyArg_ParseTuple(_args, "O",
	                      &handler))
		return NULL;
	if (PyObject_TypeCheck(handler, &SendUPPWrapper_Type)) {
		procUPP = ((UPPWrapperObject *)handler)->procUPP;
		refcon = ((UPPWrapperObject *)handler)->refcon;
	} else if (PyCallable_Check(handler)) {
		procUPP = upp_GenericSendFunction;
		refcon = (long)handler;
	} else {
		PyErr_SetString(PyExc_TypeError, "Not a callable object.");
		return NULL;
	}
	_err = OSAGetSendProc(_self->ob_itself,
						  &oldProcUPP, 
						  &oldRefcon);
	if (_err != noErr) return PyMac_Error(_err);
	_err = OSASetSendProc(_self->ob_itself,
						  procUPP,
						  refcon);
	if (_err != noErr) return PyMac_Error(_err);
	if (oldProcUPP == upp_GenericSendFunction) {
		Py_DECREF((PyObject *)oldRefcon); // when replacing a Python callback, decrement its refcount
	}
	if (procUPP == upp_GenericSendFunction) {
		Py_INCREF(handler); // when inserting a Python callback, increment its refcount
	}
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}


/*
resumeDispatchProc may be a function pointer:
 - upp_GenericEventHandlerFunction (Py func)
 - EventHandlerUPPWrapper instance (C func)
or one of the following constants:
 - kAENoDispatch = 0
 - kAEUseStandardDispatch = 0xFFFFFFFF 
 
if resumeDispatchProc = kAEUseStandardDispatch, refcon may optionally be:
 - kOSADontUsePhac = 0x0001
*/

static PyObject *OSAObj_OSAGetResumeDispatchProc(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEEventHandlerUPP procUPP;
	long refcon;
	PyObject *handler;
#ifndef OSAGetResumeDispatchProc
	PyMac_PRECHECK(OSAGetResumeDispatchProc);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAGetResumeDispatchProc(_self->ob_itself,
									&procUPP, 
									&refcon);
	if (_err != noErr) return PyMac_Error(_err);
	if ((long)procUPP == kAENoDispatch || (long)procUPP == kAEUseStandardDispatch) {
		_res = Py_BuildValue("ll",
							 (long)procUPP, refcon);
	} else if (procUPP == upp_GenericEventHandlerFunction) {
		handler = (PyObject *)refcon;
		_res = Py_BuildValue("O",
							 handler);
	} else
		_res = EventHandlerUPPWrapper_NEW(procUPP, refcon);
	return _res;
}


static PyObject *OSAObj_OSASetResumeDispatchProc(OSAComponentInstanceObject *_self, PyObject *_args)
// TO DO: Py_DECREF() current refcon if current procUPP is not upp_GenericUPPWrapper
{
	PyObject *_res = NULL;
	OSErr _err;
	AEEventHandlerUPP procUPP, oldProcUPP;
	long refcon, oldRefcon;
	PyObject *handler;
#ifndef OSASetResumeDispatchProc
	PyMac_PRECHECK(OSASetResumeDispatchProc);
#endif
	if (!PyArg_ParseTuple(_args, "O",
	                      &handler))
		return NULL;
	if (PyObject_TypeCheck(handler, &SendUPPWrapper_Type)) {
		procUPP = ((UPPWrapperObject *)handler)->procUPP;
		refcon = ((UPPWrapperObject *)handler)->refcon;
	} else if (PyCallable_Check(handler)) {
		procUPP = upp_GenericEventHandlerFunction;
		refcon = (long)handler;
	} else {
		if (!PyArg_ParseTuple(handler, "ll",
	                      &procUPP,
						  &refcon))
			return NULL;
		if ((long)procUPP != kAENoDispatch && (long)procUPP != kAEUseStandardDispatch) {
			PyErr_SetString(PyExc_ValueError, "Not kAENoDispatch or kAEUseStandardDispatch.");
			return NULL;
		}
	}
	_err = OSAGetResumeDispatchProc(_self->ob_itself,
									&oldProcUPP, 
									&oldRefcon);
	if (_err != noErr) return PyMac_Error(_err);
	_err = OSASetResumeDispatchProc(_self->ob_itself,
									procUPP,
									refcon);
	if (_err != noErr) return PyMac_Error(_err);
	if (oldProcUPP == upp_GenericEventHandlerFunction) {
		Py_DECREF((PyObject *)oldRefcon); // when replacing a Python callback, decrement its refcount
	}
	if (procUPP == upp_GenericEventHandlerFunction) {
		Py_INCREF(handler); // when inserting a Python callback, increment its refcount
	}
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}


static PyObject *OSAObj_OSAGetHandler(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	OSAID contextID;
	AEDesc handlerName;
	OSAID resultingCompiledScriptID;
#ifndef OSAGetHandler
	PyMac_PRECHECK(OSAGetHandler);
#endif
	if (!PyArg_ParseTuple(_args, "llO&",
	                      &modeFlags,
						  &contextID,
	                      AEDesc_Convert, &handlerName))
		return NULL;
	_err = OSAGetHandler(_self->ob_itself,
						 modeFlags,
						 contextID,
	                     &handlerName,
						 &resultingCompiledScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingCompiledScriptID);
	return _res;
}


static PyObject *OSAObj_OSAGetHandlerNames(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	OSAID contextID;
	AEDescList resultingHandlerNames;
#ifndef OSAGetHandlerNames
	PyMac_PRECHECK(OSAGetHandlerNames);
#endif
	if (!PyArg_ParseTuple(_args, "ll",
	                      &modeFlags,
						  &contextID))
		return NULL;
	_err = OSAGetHandlerNames(_self->ob_itself,
							  modeFlags,
							  contextID,
							  &resultingHandlerNames);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingHandlerNames);
	return _res;
}


static PyObject *OSAObj_OSAGetProperty(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	OSAID contextID;
	AEDesc variableName;
	OSAID resultingScriptValueID;
#ifndef OSAGetProperty
	PyMac_PRECHECK(OSAGetProperty);
#endif
	if (!PyArg_ParseTuple(_args, "llO&",
	                      &modeFlags,
						  &contextID,
	                      AEDesc_Convert, &variableName))
		return NULL;
	_err = OSAGetProperty(_self->ob_itself,
						  modeFlags,
						  contextID,
	                      &variableName,
						  &resultingScriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptValueID);
	return _res;
}


static PyObject *OSAObj_OSAGetPropertyNames(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	OSAID contextID;
	AEDescList resultingPropertyNames;
#ifndef OSAGetPropertyNames
	PyMac_PRECHECK(OSAGetPropertyNames);
#endif
	if (!PyArg_ParseTuple(_args, "ll",
	                      &modeFlags,
						  &contextID))
		return NULL;
	_err = OSAGetPropertyNames(_self->ob_itself,
							   modeFlags,
							   contextID,
							   &resultingPropertyNames);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingPropertyNames);
	return _res;
}


static PyObject *OSAObj_OSASetHandler(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	OSAID contextID;
	AEDesc handlerName;
	OSAID compiledScriptID;
#ifndef OSASetHandler
	PyMac_PRECHECK(OSASetHandler);
#endif
	if (!PyArg_ParseTuple(_args, "llO&l",
	                      &modeFlags,
						  &contextID,
	                      AEDesc_Convert, &handlerName,
						  &compiledScriptID))
		return NULL;
	_err = OSASetHandler(_self->ob_itself,
						 modeFlags,
						 contextID,
	                     &handlerName,
						 compiledScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res; 
}


static PyObject *OSAObj_OSASetProperty(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	OSAID contextID;
	AEDesc variableName;
	OSAID scriptValueID;
#ifndef OSASetProperty
	PyMac_PRECHECK(OSASetProperty);
#endif
	if (!PyArg_ParseTuple(_args, "llO&l",
	                      &modeFlags,
						  &contextID,
	                      AEDesc_Convert, &variableName,
						  &scriptValueID))
		return NULL;
	_err = OSASetProperty(_self->ob_itself,
						  modeFlags,
						  contextID,
	                      &variableName,
						  scriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res; 
}



static PyObject *OSAObj_OSALoadFile(OSAComponentInstanceObject *_self, PyObject *_args)
{
#ifdef AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
	PyObject *_res = NULL;
	OSAError _err;
	FSRef scriptFile;
	Boolean storable = true; // TO FIX: think this should be a parameter too (True/False/None)
	long modeFlags;
	OSAID resultingScriptID;
#ifndef OSALoadFile
	PyMac_PRECHECK(OSALoadFile);
#endif
	if (!PyArg_ParseTuple(_args, "O&l",
	                      PyMac_GetFSRef, &scriptFile,
	                      &modeFlags))
		return NULL;
	_err = OSALoadFile(_self->ob_itself,
	               &scriptFile,
				   &storable,
	               modeFlags,
	               &resultingScriptID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("ll",
	                     resultingScriptID,
						 (long)storable);
	return _res;
#else
	PyErr_SetString(PyExc_NotImplementedError, "OSALoadFile not supported before OS 10.3.");
	return NULL;
#endif
}


static PyObject *OSAObj_OSAStoreFile(OSAComponentInstanceObject *_self, PyObject *_args)
{
#ifdef AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
	PyObject *_res = NULL;
	OSAError _err;
	OSAID scriptID;
	DescType desiredType;
	long modeFlags;
	FSRef scriptFile;
#ifndef OSAStoreFile
	PyMac_PRECHECK(OSAStoreFile);
#endif
	if (!PyArg_ParseTuple(_args, "lO&lO&",
	                      &scriptID,
	                      PyMac_GetOSType, &desiredType,
	                      &modeFlags,
	                      PyMac_GetFSRef, &scriptFile))
		return NULL;
	_err = OSAStoreFile(_self->ob_itself,
						scriptID,
						desiredType,
						modeFlags,
						&scriptFile);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
#else
	PyErr_SetString(PyExc_NotImplementedError, "OSAStoreFile not supported before OS 10.3.");
	return NULL;
#endif
}


static PyObject *OSAObj_OSALoadExecuteFile(OSAComponentInstanceObject *_self, PyObject *_args)
{
#ifdef AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
	PyObject *_res = NULL;
	OSAError _err;
	FSRef scriptFile;
	OSAID contextID;
	long modeFlags;
	OSAID resultingScriptValueID;
#ifndef OSALoadExecuteFile
	PyMac_PRECHECK(OSALoadExecuteFile);
#endif
	if (!PyArg_ParseTuple(_args, "O&ll",
	                      PyMac_GetFSRef, &scriptFile,
	                      &contextID,
	                      &modeFlags))
		return NULL;
	_err = OSALoadExecuteFile(_self->ob_itself,
							  &scriptFile,
							  contextID,
							  modeFlags,
							  &resultingScriptValueID);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
	                     resultingScriptValueID);
	return _res;
#else
	PyErr_SetString(PyExc_NotImplementedError, "OSALoadExecuteFile not supported before OS 10.3.");
	return NULL;
#endif
}


static PyObject *OSAObj_OSADoScriptFile(OSAComponentInstanceObject *_self, PyObject *_args)
{
#ifdef AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
	PyObject *_res = NULL;
	OSAError _err;
	FSRef scriptFile;
	OSAID contextID;
	DescType desiredType;
	long modeFlags;
	AEDesc resultingText;
#ifndef OSADoScriptFile
	PyMac_PRECHECK(OSADoScriptFile);
#endif
	if (!PyArg_ParseTuple(_args, "O&lO&l",
	                      PyMac_GetFSRef, &scriptFile,
	                      &contextID,
	                      PyMac_GetOSType, &desiredType,
	                      &modeFlags))
		return NULL;
	_err = OSADoScriptFile(_self->ob_itself,
						   &scriptFile,
						   contextID,
						   desiredType,
						   modeFlags,
						   &resultingText);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingText);
	return _res;
#else
	PyErr_SetString(PyExc_NotImplementedError, "OSADoScriptFile not supported before OS 10.3.");
	return NULL;
#endif
}


static PyObject *OSAObj_OSAGetScriptingComponentFromStored(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDesc scriptData;
	ScriptingComponentSelector scriptingSubType;
#ifndef OSAGetScriptingComponentFromStored
	PyMac_PRECHECK(OSAGetScriptingComponentFromStored);
#endif
	if (!PyArg_ParseTuple(_args, "O&",
	                      AEDesc_Convert, &scriptData))
		return NULL;
	_err = OSAGetScriptingComponentFromStored(_self->ob_itself,
											  &scriptData,
											  &scriptingSubType);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     PyMac_BuildOSType, scriptingSubType);
	return _res;
}


static PyObject *OSAObj_OSAGetScriptingComponent(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	ScriptingComponentSelector scriptingSubType;
	ComponentInstance scriptingInstance;
#ifndef OSAGetScriptingComponent
	PyMac_PRECHECK(OSAGetScriptingComponent);
#endif
	if (!PyArg_ParseTuple(_args, "O&",
	                      PyMac_GetOSType, &scriptingSubType))
		return NULL;
	_err = OSAGetScriptingComponent(_self->ob_itself,
									scriptingSubType,
									&scriptingInstance);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
						 OSAObj_New, &scriptingInstance);
	return _res;
}


static PyObject *OSAObj_OSAGenericToRealID(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID theScriptID;
	ComponentInstance theExactComponent;
#ifndef OSAGenericToRealID
	PyMac_PRECHECK(OSAGenericToRealID);
#endif
	if (!PyArg_ParseTuple(_args, "l",
	                      &theScriptID))
		return NULL;
	_err = OSAGenericToRealID(_self->ob_itself,
							  &theScriptID,
							  &theExactComponent);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("lO&",
						 theScriptID,
	                     OSAObj_New, theExactComponent);
	return _res;
}


static PyObject *OSAObj_OSARealToGenericID(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	OSAID theScriptID;
	ComponentInstance theExactComponent;
#ifndef OSARealToGenericID
	PyMac_PRECHECK(OSARealToGenericID);
#endif
	if (!PyArg_ParseTuple(_args, "lO&",
	                      &theScriptID,
						  OSAObj_Convert, &theExactComponent))
		return NULL;
	_err = OSARealToGenericID(_self->ob_itself,
							  &theScriptID,
							  theExactComponent);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("l",
						 theScriptID);
	return _res;
}


static PyObject *OSAObj_OSAGetDefaultScriptingComponent(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	ScriptingComponentSelector scriptingSubType;
#ifndef OSAGetDefaultScriptingComponent
	PyMac_PRECHECK(OSAGetDefaultScriptingComponent);
#endif
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = OSAGetDefaultScriptingComponent(_self->ob_itself,
										   &scriptingSubType);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
						 PyMac_BuildOSType, scriptingSubType);
	return _res;
}


static PyObject *OSAObj_OSASetDefaultScriptingComponent(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	ScriptingComponentSelector scriptingSubType;
#ifndef OSASetDefaultScriptingComponent
	PyMac_PRECHECK(OSASetDefaultScriptingComponent);
#endif
	if (!PyArg_ParseTuple(_args, "O&",
	                      PyMac_GetOSType, &scriptingSubType))
		return NULL;
	_err = OSASetDefaultScriptingComponent(_self->ob_itself,
										   scriptingSubType);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}



static PyObject *OSAObj_ASInit(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	long minStackSize;
	long preferredStackSize;
	long maxStackSize;
	long minHeapSize;
	long preferredHeapSize;
	long maxHeapSize;
#ifndef ASInit
	PyMac_PRECHECK(ASInit);
#endif
	CheckComponentSubtype(kAppleScriptSubtype);
	if (!PyArg_ParseTuple(_args, "lllllll",
	                      &modeFlags,
						  &minStackSize,
						  &preferredStackSize,
						  &maxStackSize,
						  &minHeapSize,
						  &preferredHeapSize,
						  &maxHeapSize))
		return NULL;
	_err = ASInit(_self->ob_itself,
				  modeFlags,
				  minStackSize,
				  preferredStackSize,
				  maxStackSize,
				  minHeapSize,
				  preferredHeapSize,
				  maxHeapSize);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}


static PyObject *OSAObj_ASGetSourceStyleNames(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	long modeFlags;
	AEDescList resultingSourceStyleNamesList;
#ifndef ASGetSourceStyleNames
	PyMac_PRECHECK(ASGetSourceStyleNames);
#endif
	CheckComponentSubtype(kAppleScriptSubtype);
	if (!PyArg_ParseTuple(_args, "l",
	                      &modeFlags))
		return NULL;
	_err = ASGetSourceStyleNames(_self->ob_itself,
								 modeFlags,
								 &resultingSourceStyleNamesList);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &resultingSourceStyleNamesList);
	return _res;
}


static PyObject *OSAObj_ASGetSourceStyles(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	STHandle sourceStyles;
	AEDescList formatList;
#ifndef ASGetSourceStyles
	PyMac_PRECHECK(ASGetSourceStyles);
#endif
	CheckComponentSubtype(kAppleScriptSubtype);
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = ASGetSourceStyles(_self->ob_itself,
							 &sourceStyles);
	if (_err != noErr) return PyMac_Error(_err);
	_err = OSA_StyleRecToDesc(sourceStyles,
							  &formatList);
	if (_err != noErr) return PyMac_Error(_err);
	_res = Py_BuildValue("O&",
	                     AEDesc_New, &formatList);
	return _res;
}


static PyObject *OSAObj_ASSetSourceStyles(OSAComponentInstanceObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSAError _err;
	AEDescList formatList;
	STHandle sourceStyles = 0;
#ifndef ASSetSourceStyles
	PyMac_PRECHECK(ASSetSourceStyles);
#endif
	CheckComponentSubtype(kAppleScriptSubtype);
	if (!PyArg_ParseTuple(_args, "O&",
	                      AEDesc_Convert, &formatList))
		return NULL;
	sourceStyles = (STHandle)NewHandleClear(sizeof(STElement) * kASNumberOfSourceStyles);
	_err = OSA_StyleDescToRec(formatList, &sourceStyles);
	if (_err != noErr) return PyMac_Error(_err);
	_err = ASSetSourceStyles(_self->ob_itself,
							 sourceStyles);
	if (sourceStyles != 0)
		DisposeHandle((Handle)sourceStyles);
	if (_err != noErr) return PyMac_Error(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}



/***************************** END NEW CODE *****************************/


static PyMethodDef OSAObj_methods[] = {
	{"OSALoad", (PyCFunction)OSAObj_OSALoad, 1,
	 PyDoc_STR("(AEDesc scriptData, long modeFlags) -> (OSAID resultingScriptID)")},
	{"OSAStore", (PyCFunction)OSAObj_OSAStore, 1,
	 PyDoc_STR("(OSAID scriptID, DescType desiredType, long modeFlags) -> (AEDesc resultingScriptData)")},
	{"OSAExecute", (PyCFunction)OSAObj_OSAExecute, 1,
	 PyDoc_STR("(OSAID compiledScriptID, OSAID contextID, long modeFlags) -> (OSAID resultingScriptValueID)")},
	{"OSADisplay", (PyCFunction)OSAObj_OSADisplay, 1,
	 PyDoc_STR("(OSAID scriptValueID, DescType desiredType, long modeFlags) -> (AEDesc resultingText)")},
	{"OSAScriptError", (PyCFunction)OSAObj_OSAScriptError, 1,
	 PyDoc_STR("(OSType selector, DescType desiredType) -> (AEDesc resultingErrorDescription)")},
	{"OSADispose", (PyCFunction)OSAObj_OSADispose, 1,
	 PyDoc_STR("(OSAID scriptID) -> None")},
	{"OSASetScriptInfo", (PyCFunction)OSAObj_OSASetScriptInfo, 1,
	 PyDoc_STR("(OSAID scriptID, OSType selector, long value) -> None")},
	{"OSAGetScriptInfo", (PyCFunction)OSAObj_OSAGetScriptInfo, 1,
	 PyDoc_STR("(OSAID scriptID, OSType selector) -> (long result)")},
	{"OSAScriptingComponentName", (PyCFunction)OSAObj_OSAScriptingComponentName, 1,
	 PyDoc_STR("() -> (AEDesc resultingScriptingComponentName)")},
	{"OSACompile", (PyCFunction)OSAObj_OSACompile, 1,
	 PyDoc_STR("(AEDesc sourceData, long modeFlags, long previousAndResultingScriptID) -> (OSAID previousAndResultingScriptID)")},
	{"OSACopyID", (PyCFunction)OSAObj_OSACopyID, 1,
	 PyDoc_STR("(OSAID fromID) -> (OSAID toID)")},
	{"OSAGetSource", (PyCFunction)OSAObj_OSAGetSource, 1,
	 PyDoc_STR("(OSAID scriptID, DescType desiredType) -> (AEDesc resultingSourceData)")},
	{"OSACoerceFromDesc", (PyCFunction)OSAObj_OSACoerceFromDesc, 1,
	 PyDoc_STR("(AEDesc scriptData, long modeFlags) -> (OSAID resultingScriptID)")},
	{"OSACoerceToDesc", (PyCFunction)OSAObj_OSACoerceToDesc, 1,
	 PyDoc_STR("(OSAID scriptID, DescType desiredType, long modeFlags) -> (AEDesc result)")},
	{"OSASetDefaultTarget", (PyCFunction)OSAObj_OSASetDefaultTarget, 1,
	 PyDoc_STR("(AEAddressDesc target) -> None")},
	{"OSAStartRecording", (PyCFunction)OSAObj_OSAStartRecording, 1,
	 PyDoc_STR("(OSAID compiledScriptToModifyID) -> (OSAID compiledScriptToModifyID)")},
	{"OSAStopRecording", (PyCFunction)OSAObj_OSAStopRecording, 1,
	 PyDoc_STR("(OSAID compiledScriptID) -> None")},
	{"OSALoadExecute", (PyCFunction)OSAObj_OSALoadExecute, 1,
	 PyDoc_STR("(AEDesc scriptData, OSAID contextID, long modeFlags) -> (OSAID resultingScriptValueID)")},
	{"OSACompileExecute", (PyCFunction)OSAObj_OSACompileExecute, 1,
	 PyDoc_STR("(AEDesc sourceData, OSAID contextID, long modeFlags) -> (OSAID resultingScriptValueID)")},
	{"OSADoScript", (PyCFunction)OSAObj_OSADoScript, 1,
	 PyDoc_STR("(AEDesc sourceData, OSAID contextID, DescType desiredType, long modeFlags) -> (AEDesc resultingText)")},
	{"OSASetCurrentDialect", (PyCFunction)OSAObj_OSASetCurrentDialect, 1,
	 PyDoc_STR("(short dialectCode) -> None")},
	{"OSAGetCurrentDialect", (PyCFunction)OSAObj_OSAGetCurrentDialect, 1,
	 PyDoc_STR("() -> (short resultingDialectCode)")},
	{"OSAAvailableDialects", (PyCFunction)OSAObj_OSAAvailableDialects, 1,
	 PyDoc_STR("() -> (AEDesc resultingDialectInfoList)")},
	{"OSAGetDialectInfo", (PyCFunction)OSAObj_OSAGetDialectInfo, 1,
	 PyDoc_STR("(short dialectCode, OSType selector) -> (AEDesc resultingDialectInfo)")},
	{"OSAAvailableDialectCodeList", (PyCFunction)OSAObj_OSAAvailableDialectCodeList, 1,
	 PyDoc_STR("() -> (AEDesc resultingDialectCodeList)")},
	{"OSAExecuteEvent", (PyCFunction)OSAObj_OSAExecuteEvent, 1,
	 PyDoc_STR("(AppleEvent theAppleEvent, OSAID contextID, long modeFlags) -> (OSAID resultingScriptValueID)")},
	{"OSADoEvent", (PyCFunction)OSAObj_OSADoEvent, 1,
	 PyDoc_STR("(AppleEvent theAppleEvent, OSAID contextID, long modeFlags) -> (AppleEvent reply)")},
	{"OSAMakeContext", (PyCFunction)OSAObj_OSAMakeContext, 1,
	 PyDoc_STR("(AEDesc contextName, OSAID parentContext) -> (OSAID resultingContextID)")},
	
	/*************************** BEGIN NEW CODE *****************************/
	
	{"OSASetActiveProc", (PyCFunction)OSAObj_OSASetActiveProc, 1,
	 PyDoc_STR("(ActiveProc handler) -> None")},
	{"OSAGetActiveProc", (PyCFunction)OSAObj_OSAGetActiveProc, 1,
	 PyDoc_STR("() -> (ActiveProc handler)")},
	{"OSASetCreateProc", (PyCFunction)OSAObj_OSASetCreateProc, 1,
	 PyDoc_STR("(CreateAppleEventProc handler) -> None")},
	{"OSAGetCreateProc", (PyCFunction)OSAObj_OSAGetCreateProc, 1,
	 PyDoc_STR("() -> (CreateAppleEventProc handler)")},
	{"OSASetSendProc", (PyCFunction)OSAObj_OSASetSendProc, 1,
	 PyDoc_STR("(SendProc handler) -> None")},
	{"OSAGetSendProc", (PyCFunction)OSAObj_OSAGetSendProc, 1,
	 PyDoc_STR("() -> (SendProc handler)")},
	{"OSAGetResumeDispatchProc", (PyCFunction)OSAObj_OSAGetResumeDispatchProc, 1,
	 PyDoc_STR("() -> EventHandlerProc handler")},
	{"OSASetResumeDispatchProc", (PyCFunction)OSAObj_OSASetResumeDispatchProc, 1,
	 PyDoc_STR("(EventHandlerProc handler) -> None")},
	
	{"OSAGetHandler", (PyCFunction)OSAObj_OSAGetHandler, 1,
	 PyDoc_STR("(long modeFlags, OSAID contextID, AEDesc handlerName) -> (OSAID resultingCompiledScriptID)")},
	{"OSAGetHandlerNames", (PyCFunction)OSAObj_OSAGetHandlerNames, 1,
	 PyDoc_STR("(long modeFlags, OSAID contextID) -> (AEDescList resultingHandlerNames)")},
	{"OSAGetProperty", (PyCFunction)OSAObj_OSAGetProperty, 1,
	 PyDoc_STR("(long modeFlags, OSAID contextID, AEDesc variableName) -> (OSAID resultingScriptValueID)")},
	{"OSAGetPropertyNames", (PyCFunction)OSAObj_OSAGetPropertyNames, 1,
	 PyDoc_STR("(long modeFlags, OSAID contextID) -> (AEDesc resultingPropertyNames)")},
	{"OSASetHandler", (PyCFunction)OSAObj_OSASetHandler, 1,
	 PyDoc_STR("(long modeFlags, OSAID contextID, AEDesc handlerName, OSAID compiledScriptID) -> None")},
	{"OSASetProperty", (PyCFunction)OSAObj_OSASetProperty, 1,
	 PyDoc_STR("(long modeFlags, OSAID contextID, AEDesc variableName, OSAID scriptValueID) -> None")},
	
	{"OSALoadFile", (PyCFunction)OSAObj_OSALoadFile, 1,
	 PyDoc_STR("(FSRef scriptFile, long modeFlags) -> (OSAID resultingScriptID, long storable)")},
	{"OSAStoreFile", (PyCFunction)OSAObj_OSAStoreFile, 1,
	 PyDoc_STR("(OSAID scriptID, DescType desiredType, long modeFlags, FSRef scriptFile) -> None")},
	{"OSALoadExecuteFile", (PyCFunction)OSAObj_OSALoadExecuteFile, 1,
	 PyDoc_STR("(FSRef scriptFile, OSAID contextID, long modeFlags) -> (OSAID resultingScriptValueID)")},
	{"OSADoScriptFile", (PyCFunction)OSAObj_OSADoScriptFile, 1,
	 PyDoc_STR("(FSRef scriptFile, OSAID contextID, DescType desiredType, long modeFlags) -> (AEDesc resultingText)")},
	
	{"OSAGetScriptingComponentFromStored", (PyCFunction)OSAObj_OSAGetScriptingComponentFromStored, 1,
	 PyDoc_STR("(AEDesc scriptData) -> ScriptingComponentSelector scriptingSubType")},
	{"OSAGetScriptingComponent", (PyCFunction)OSAObj_OSAGetScriptingComponent, 1,
	 PyDoc_STR("(ScriptingComponentSelector scriptingSubType) -> OSAComponentInstance scriptingInstance")},
	{"OSAGenericToRealID", (PyCFunction)OSAObj_OSAGenericToRealID, 1,
	 PyDoc_STR("(OSAID theScriptID) -> (OSAID theScriptID, ComponentInstance theExactComponent)")},
	{"OSARealToGenericID", (PyCFunction)OSAObj_OSARealToGenericID, 1,
	 PyDoc_STR("(OSAID theScriptID, ComponentInstance theExactComponent) -> OSAID theScriptID")},
	
	{"OSAGetDefaultScriptingComponent", (PyCFunction)OSAObj_OSAGetDefaultScriptingComponent, 1,
	 PyDoc_STR("() -> ScriptingComponentSelector scriptingSubType")},
	{"OSASetDefaultScriptingComponent", (PyCFunction)OSAObj_OSASetDefaultScriptingComponent, 1,
	 PyDoc_STR("(ScriptingComponentSelector scriptingSubType) -> None")},
	
	{"ASInit", (PyCFunction)OSAObj_ASInit, 1,
	 PyDoc_STR("(long modeFlags, long minStackSize, long preferredStackSize, long maxStackSize, long minHeapSize, long preferredHeapSize, long maxHeapSize) -> None")},
	{"ASGetSourceStyleNames", (PyCFunction)OSAObj_ASGetSourceStyleNames, 1,
	 PyDoc_STR("(long modeFlags) -> AEDescList resultingSourceStyleNamesList")},
	{"ASGetSourceStyles", (PyCFunction)OSAObj_ASGetSourceStyles, 1,
	 PyDoc_STR("() -> AEDescList sourceStyles")},
	{"ASSetSourceStyles", (PyCFunction)OSAObj_ASSetSourceStyles, 1,
	 PyDoc_STR("(AEDescList sourceStyles) -> None")},

	
	
	/***************************** END NEW CODE *****************************/
	
	{NULL, NULL, 0}
};

#define OSAObj_getsetlist NULL


#define OSAObj_compare NULL

#define OSAObj_repr NULL

#define OSAObj_hash NULL
#define OSAObj_tp_init 0

#define OSAObj_tp_alloc PyType_GenericAlloc

static PyObject *OSAObj_tp_new(PyTypeObject *type, PyObject *args, PyObject *kwds)
{
	PyObject *self;
	ComponentInstance itself;
	char *kw[] = {"itself", 0};

	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&", kw, OSAObj_Convert, &itself)) return NULL;
	if ((self = type->tp_alloc(type, 0)) == NULL) return NULL;
	((OSAComponentInstanceObject *)self)->ob_itself = itself;
	return self;
}

#define OSAObj_tp_free PyObject_Del


PyTypeObject OSAComponentInstance_Type = {
	PyObject_HEAD_INIT(NULL)
	0, /*ob_size*/
	"_OSA.OSAComponentInstance", /*tp_name*/
	sizeof(OSAComponentInstanceObject), /*tp_basicsize*/
	0, /*tp_itemsize*/
	/* methods */
	(destructor) OSAObj_dealloc, /*tp_dealloc*/
	0, /*tp_print*/
	(getattrfunc)0, /*tp_getattr*/
	(setattrfunc)0, /*tp_setattr*/
	(cmpfunc) OSAObj_compare, /*tp_compare*/
	(reprfunc) OSAObj_repr, /*tp_repr*/
	(PyNumberMethods *)0, /* tp_as_number */
	(PySequenceMethods *)0, /* tp_as_sequence */
	(PyMappingMethods *)0, /* tp_as_mapping */
	(hashfunc) OSAObj_hash, /*tp_hash*/
	0, /*tp_call*/
	0, /*tp_str*/
	PyObject_GenericGetAttr, /*tp_getattro*/
	PyObject_GenericSetAttr, /*tp_setattro */
	0, /*tp_as_buffer*/
	Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE, /* tp_flags */
	0, /*tp_doc*/
	0, /*tp_traverse*/
	0, /*tp_clear*/
	0, /*tp_richcompare*/
	0, /*tp_weaklistoffset*/
	0, /*tp_iter*/
	0, /*tp_iternext*/
	OSAObj_methods, /* tp_methods */
	0, /*tp_members*/
	OSAObj_getsetlist, /*tp_getset*/
	0, /*tp_base*/
	0, /*tp_dict*/
	0, /*tp_descr_get*/
	0, /*tp_descr_set*/
	0, /*tp_dictoffset*/
	OSAObj_tp_init, /* tp_init */
	OSAObj_tp_alloc, /* tp_alloc */
	OSAObj_tp_new, /* tp_new */
	OSAObj_tp_free, /* tp_free */
};

/* -------------- End object type OSAComponentInstance -------------- */


/*************************** BEGIN NEW CODE *****************************/

/* -------------- Begin object type ActiveUPPWrapper -------------- */


PyObject *ActiveUPPWrapper_NEW(OSAActiveUPP procUPP, long refcon)
{
	UPPWrapperObject *it;
	
	it = PyObject_NEW(UPPWrapperObject, &ActiveUPPWrapper_Type);
	if (it != NULL) {
		it->procUPP = procUPP;
		it->refcon = refcon;
	}
	return (PyObject *)it;
}


void ActiveUPPWrapper_dealloc(PyObject *self)
{
	PyMem_DEL(self);
}


PyObject *ActiveUPPWrapper_call(UPPWrapperObject *self, PyObject *args, PyObject *kw)
{
	OSErr err = noErr;
#ifndef InvokeOSAActiveUPP
	PyMac_PRECHECK(InvokeOSAActiveUPP);
#endif
	err = InvokeOSAActiveUPP(self->refcon,
							 (OSAActiveUPP)self->procUPP);
	return Py_BuildValue("l",
						 err);
}


PyTypeObject ActiveUPPWrapper_Type = {
	PyObject_HEAD_INIT(&PyType_Type)
	0,											/* ob_size */
	"ActiveUPPWrapper",							/* char *tp_name; */
	sizeof(UPPWrapperObject),					/* int tp_basicsize */
	0,											/* int tp_itemsize */
	ActiveUPPWrapper_dealloc,					/* destructor tp_dealloc */
	0,											/* printfunc tp_print */
	0,											/* getattrfunc tp_getattr */
	0,											/* setattrfunc tp_setattr */
	0,											/* cmpfunc tp_compare */
	0,											/* reprfunc tp_repr */
	0,											/* PyNumberMethods *tp_as_number */
	0,											/* PySequenceMethods *tp_as_sequence */
	0,											/* PyMappingMethods *tp_as_mapping */
	0,											/* hashfunc tp_hash */
	(ternaryfunc)ActiveUPPWrapper_call,			/* ternaryfunc tp_call */
	0,											/* reprfunc tp_str */
};


/* -------------- End object type ActiveUPPWrapper -------------- */

/* -------------- Begin object type CreateAppleEventUPPWrapper -------------- */


PyObject *CreateAppleEventUPPWrapper_NEW(OSACreateAppleEventUPP procUPP, long refcon)
{
	UPPWrapperObject *it;
	
	it = PyObject_NEW(UPPWrapperObject, &CreateAppleEventUPPWrapper_Type);
	if (it != NULL) {
		it->procUPP = procUPP;
		it->refcon = refcon;
	}
	return (PyObject *)it;
}


void CreateAppleEventUPPWrapper_dealloc(PyObject *self)
{
	PyMem_DEL(self);
}


PyObject *CreateAppleEventUPPWrapper_call(UPPWrapperObject *self, PyObject *args, PyObject *kw)
{
	OSErr err = noErr;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEAddressDesc target;
	AEReturnID returnID;
	AETransactionID transactionID;
	AppleEvent result;
#ifndef InvokeOSACreateAppleEventUPP
	PyMac_PRECHECK(InvokeOSACreateAppleEventUPP);
#endif
	if (!PyArg_ParseTuple(args, "O&O&O&hl",
	                      PyMac_GetOSType, &theAEEventClass,
	                      PyMac_GetOSType, &theAEEventID,
	                      AEDesc_Convert, &target,
	                      &returnID,
	                      &transactionID))
		return NULL;
	err = InvokeOSACreateAppleEventUPP(theAEEventClass,
									   theAEEventID,
									   &target,
									   returnID,
									   transactionID,
									   &result,
									   self->refcon,
									   (OSACreateAppleEventUPP)self->procUPP);
	if (err != noErr) return PyMac_Error(err);
	return Py_BuildValue("O&",
						 AEDesc_New, &result);
}


PyTypeObject CreateAppleEventUPPWrapper_Type = {
	PyObject_HEAD_INIT(&PyType_Type)
	0,												/* ob_size */
	"CreateUPPWrapper",								/* char *tp_name; */
	sizeof(UPPWrapperObject),						/* int tp_basicsize */
	0,												/* int tp_itemsize */
	ActiveUPPWrapper_dealloc,						/* destructor tp_dealloc */
	0,												/* printfunc tp_print */
	0,												/* getattrfunc tp_getattr */
	0,												/* setattrfunc tp_setattr */
	0,												/* cmpfunc tp_compare */
	0,												/* reprfunc tp_repr */
	0,												/* PyNumberMethods *tp_as_number */
	0,												/* PySequenceMethods *tp_as_sequence */
	0,												/* PyMappingMethods *tp_as_mapping */
	0,												/* hashfunc tp_hash */
	(ternaryfunc)CreateAppleEventUPPWrapper_call,	/* ternaryfunc tp_call */
	0,												/* reprfunc tp_str */
};


/* -------------- End object type CreateAppleEventUPPWrapper -------------- */

/* -------------- Begin object type SendUPPWrapper -------------- */


PyObject *SendUPPWrapper_NEW(OSASendUPP procUPP, long refcon)
{
	UPPWrapperObject *it;
	
	it = PyObject_NEW(UPPWrapperObject, &SendUPPWrapper_Type);
	if (it != NULL) {
		it->procUPP = procUPP;
		it->refcon = refcon;
	}
	return (PyObject *)it;
}


void SendUPPWrapper_dealloc(PyObject *self)
{
	PyMem_DEL(self);
}


PyObject *SendUPPWrapper_call(UPPWrapperObject *self, PyObject *args, PyObject *kw)
{
	OSErr err = noErr;
	AppleEvent theAppleEvent;
	AppleEvent reply;
	AESendMode sendMode;
	AESendPriority sendPriority;
	long timeOutInTicks;
#ifndef InvokeOSASendUPP
	PyMac_PRECHECK(InvokeOSASendUPP);
#endif
	if (!PyArg_ParseTuple(args, "O&lhl",
	                      AEDesc_Convert, &theAppleEvent,
	                      &sendMode,
	                      &sendPriority,
	                      &timeOutInTicks))
		return NULL;
	err = InvokeOSASendUPP(&theAppleEvent,
						   &reply,
						   sendMode,
						   sendPriority,
						   timeOutInTicks,
						   upp_AEIdleProc,
						   (AEFilterUPP)0,
						   self->refcon,
						   (OSASendUPP)self->procUPP);
	if (err != noErr) return PyMac_Error(err);
	return Py_BuildValue("O&",
						 AEDesc_New, &reply);
}


PyTypeObject SendUPPWrapper_Type = {
	PyObject_HEAD_INIT(&PyType_Type)
	0,											/* ob_size */
	"SendUPPWrapper",							/* char *tp_name; */
	sizeof(UPPWrapperObject),					/* int tp_basicsize */
	0,											/* int tp_itemsize */
	SendUPPWrapper_dealloc,						/* destructor tp_dealloc */
	0,											/* printfunc tp_print */
	0,											/* getattrfunc tp_getattr */
	0,											/* setattrfunc tp_setattr */
	0,											/* cmpfunc tp_compare */
	0,											/* reprfunc tp_repr */
	0,											/* PyNumberMethods *tp_as_number */
	0,											/* PySequenceMethods *tp_as_sequence */
	0,											/* PyMappingMethods *tp_as_mapping */
	0,											/* hashfunc tp_hash */
	(ternaryfunc)SendUPPWrapper_call,			/* ternaryfunc tp_call */
	0,											/* reprfunc tp_str */
};


/* -------------- End object type SendUPPWrapper -------------- */

/* -------------- Begin object type EventHandlerUPPWrapper -------------- */


PyObject *EventHandlerUPPWrapper_NEW(AEEventHandlerUPP procUPP, long refcon)
{
	UPPWrapperObject *it;
	
	it = PyObject_NEW(UPPWrapperObject, &EventHandlerUPPWrapper_Type);
	if (it != NULL) {
		it->procUPP = procUPP;
		it->refcon = refcon;
	}
	return (PyObject *)it;
}


void EventHandlerUPPWrapper_dealloc(PyObject *self)
{
	PyMem_DEL(self);
}



PyObject *EventHandlerUPPWrapper_call(UPPWrapperObject *self, PyObject *args, PyObject *kw)
{
	OSErr err = noErr;
	AppleEvent theAppleEvent;
	AppleEvent reply;
#ifndef InvokeAEEventHandlerUPP
	PyMac_PRECHECK(InvokeAEEventHandlerUPP);
#endif
	if (!PyArg_ParseTuple(args, "O&O&",
	                      AEDesc_Convert, &theAppleEvent,
	                      AEDesc_Convert, &reply))
		return NULL;
	err = InvokeAEEventHandlerUPP(&theAppleEvent,
								  &reply,
								  self->refcon,
								  (AEEventHandlerUPP)self->procUPP);
	return Py_BuildValue("l",
						 err);
}


PyTypeObject EventHandlerUPPWrapper_Type = {
	PyObject_HEAD_INIT(&PyType_Type)
	0,											/* ob_size */
	"EventHandlerUPPWrapper",					/* char *tp_name; */
	sizeof(UPPWrapperObject),					/* int tp_basicsize */
	0,											/* int tp_itemsize */
	EventHandlerUPPWrapper_dealloc,				/* destructor tp_dealloc */
	0,											/* printfunc tp_print */
	0,											/* getattrfunc tp_getattr */
	0,											/* setattrfunc tp_setattr */
	0,											/* cmpfunc tp_compare */
	0,											/* reprfunc tp_repr */
	0,											/* PyNumberMethods *tp_as_number */
	0,											/* PySequenceMethods *tp_as_sequence */
	0,											/* PyMappingMethods *tp_as_mapping */
	0,											/* hashfunc tp_hash */
	(ternaryfunc)EventHandlerUPPWrapper_call,	/* ternaryfunc tp_call */
	0,											/* reprfunc tp_str */
};


/* -------------- End object type EventHandlerUPPWrapper -------------- */

/***************************** END NEW CODE *****************************/



static PyMethodDef OSA_methods[] = {
	{NULL, NULL, 0}
};


/*************************** BEGIN NEW CODE *****************************/

static pascal OSErr 
GenericActiveFunction(long refcon)
{
	OSErr err = noErr;
	PyObject *res;
	PyGILState_STATE state;

	state = PyGILState_Ensure();
	res = PyEval_CallObject((PyObject *)refcon, NULL);
	if (res == NULL) {
		PySys_WriteStderr("An error occurred in ActiveProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (!PyInt_Check(res)) {
		Py_DECREF(res);
		PySys_WriteStderr("ActiveProc didn't return an OSErr.\n");
		err = errOSAGeneralError;
		goto cleanup;
	}
	err = PyInt_AsLong(res); // TO DO: trap MacOS.Error and report those? What's best? See AE.c for ideas.
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}


static pascal OSErr 
GenericCreateAppleEventFunction(AEEventClass theAEEventClass,
								  AEEventID theAEEventID,
								  const AEAddressDesc *target,
								  short returnID,
								  long transactionID,
								  AppleEvent *result,
								  long refcon)
{
	PyObject *args, *res;
	OSErr err = noErr;
	PyGILState_STATE state;

	state = PyGILState_Ensure();
	args = Py_BuildValue("O&O&O&hl",
								PyMac_BuildOSType, theAEEventClass,
								PyMac_BuildOSType, theAEEventID,
								AEDesc_New, target,
								returnID,
								transactionID);
	if (args == NULL) {
		PySys_WriteStderr("An error occurred in CreateAppleEventProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	res = PyEval_CallObject((PyObject *)refcon, args);
	if (res == NULL) {
		PySys_WriteStderr("An error occurred in CreateAppleEventProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (!PyObject_IsInstance(res, PyObject_GetAttrString(module_AE, "AEDesc"))) {
		Py_DECREF(res);
		PySys_WriteStderr("CreateAppleEventProc didn't return an AEDesc.\n");
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (AEDuplicateDesc(&((AEDescObject *)res)->ob_itself, result)) {
		Py_DECREF(res);
		err = -1;
		goto cleanup;
	}
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}


static pascal OSErr 
GenericSendFunction(const AppleEvent *theAppleEvent,
					  AppleEvent *reply,
					  AESendMode sendMode,
					  AESendPriority sendPriority,
					  long timeOutInTicks,
					  AEIdleUPP idleProc,
					  AEFilterUPP filterProc,
					  long refcon)
{
	OSErr err = noErr;
	PyObject *args, *res;
    PyGILState_STATE state;

	state = PyGILState_Ensure();
	args = Py_BuildValue("O&lhl",
							AEDesc_New, theAppleEvent,
							sendMode,
							sendPriority,
							timeOutInTicks);
	if (args == NULL) {
		PySys_WriteStderr("An error occurred in SendProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	res = PyObject_CallObject((PyObject *)refcon, args);
	if (res == NULL) {
		PySys_WriteStderr("An error occurred in SendProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (!PyObject_IsInstance(res, PyObject_GetAttrString(module_AE, "AEDesc"))) {
		Py_DECREF(res);
		PySys_WriteStderr("SendProc didn't return an AEDesc.\n");
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (AEDuplicateDesc(&((AEDescObject *)res)->ob_itself, reply)) {
		Py_DECREF(res);
		err = -1;
		goto cleanup;
	}
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}


static pascal OSErr
GenericEventHandlerFunction(const AppleEvent *theAppleEvent,
							AppleEvent *reply,
							SInt32 refcon)
{
	OSErr err = noErr;
	PyObject *args, *res;
    PyGILState_STATE state;

	state = PyGILState_Ensure();
	args = Py_BuildValue("(O&)",
						 AEDesc_New, theAppleEvent);
	if (args == NULL) {
		PySys_WriteStderr("An error occurred in ResumeDispatchProc.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	res = PyEval_CallObject((PyObject *)refcon, args);
	if (res == NULL) {
		PySys_WriteStderr("An error occurred in ResumeDispatchProc function.\n");
		PyErr_Print();
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (!PyObject_IsInstance(res, PyObject_GetAttrString(module_AE, "AEDesc"))) {
		Py_DECREF(res);
		PySys_WriteStderr("ResumeDispatchProc function didn't return an AEDesc.\n");
		err = errOSAGeneralError;
		goto cleanup;
	}
	if (AEDuplicateDesc(&((AEDescObject *)res)->ob_itself, reply)) {
		Py_DECREF(res);
		err = -1;
		goto cleanup;
	}
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}

/***************************** END NEW CODE *****************************/


void init_OSA(void)
{
	PyObject *m;
	PyObject *d;



	/*
		PyMac_INIT_TOOLBOX_OBJECT_NEW(ComponentInstance, OSAObj_New);
		PyMac_INIT_TOOLBOX_OBJECT_CONVERT(ComponentInstance, OSAObj_Convert);
	*/

		/*************************** BEGIN NEW CODE *****************************/
		
		module_AE = PyImport_ImportModule("CarbonX.AE");
		
		upp_GenericActiveFunction = NewOSAActiveUPP(GenericActiveFunction);
		upp_GenericCreateAppleEventFunction = NewOSACreateAppleEventUPP(GenericCreateAppleEventFunction);
		upp_GenericSendFunction = NewOSASendUPP(GenericSendFunction);
		upp_GenericEventHandlerFunction = NewAEEventHandlerUPP(GenericEventHandlerFunction);
		upp_AEIdleProc = NewAEIdleUPP(AEIdleProc);
		
		/***************************** END NEW CODE *****************************/

	m = Py_InitModule("_OSA", OSA_methods);
	d = PyModule_GetDict(m);
	OSA_Error = PyMac_GetOSErrException();
	if (OSA_Error == NULL ||
	    PyDict_SetItemString(d, "Error", OSA_Error) != 0)
		return;
	OSAComponentInstance_Type.ob_type = &PyType_Type;
	if (PyType_Ready(&OSAComponentInstance_Type) < 0) return;
	Py_INCREF(&OSAComponentInstance_Type);
	PyModule_AddObject(m, "OSAComponentInstance", (PyObject *)&OSAComponentInstance_Type);
	/* Backward-compatible name */
	Py_INCREF(&OSAComponentInstance_Type);
	PyModule_AddObject(m, "OSAComponentInstanceType", (PyObject *)&OSAComponentInstance_Type);
	
	/*************************** BEGIN NEW CODE *****************************/
	
	if (PyType_Ready(&ActiveUPPWrapper_Type) < 0) return;
	Py_INCREF(&ActiveUPPWrapper_Type);
	PyModule_AddObject(m, "ActiveUPPWrapper", (PyObject *)&ActiveUPPWrapper_Type);
	
	if (PyType_Ready(&CreateAppleEventUPPWrapper_Type) < 0) return;
	Py_INCREF(&CreateAppleEventUPPWrapper_Type);
	PyModule_AddObject(m, "CreateAppleEventUPPWrapper", (PyObject *)&CreateAppleEventUPPWrapper_Type);
	
	if (PyType_Ready(&SendUPPWrapper_Type) < 0) return;
	Py_INCREF(&SendUPPWrapper_Type);
	PyModule_AddObject(m, "SendUPPWrapper", (PyObject *)&SendUPPWrapper_Type);
	
	if (PyType_Ready(&EventHandlerUPPWrapper_Type) < 0) return;
	Py_INCREF(&EventHandlerUPPWrapper_Type);
	PyModule_AddObject(m, "EventHandlerUPPWrapper", (PyObject *)&EventHandlerUPPWrapper_Type);
	
	/***************************** END NEW CODE *****************************/
}

/* ======================== End module _OSA ========================= */

