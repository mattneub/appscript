/*
 * Original code taken from _AEmodule.c, _CFmodule.c, _Launchmodule.c
 *     Copyright (C) 2001-2008 Python Software Foundation.
 *
 * Docstring descriptions taken from Apple developer documentation
 *     Copyright (C) 1993-2008 Apple Inc.
 *
 */
 
/* =========================== Module AE =========================== */

#include "Python.h"

#define AE_MODULE_C
#include "ae.h"
#include "sendthreadsafe.c"

// Event handling
#if __LP64__
	// SRefCon typedefed as void * by system headers
#else
	typedef long SRefCon;
#endif

AEEventHandlerUPP upp_GenericEventHandler;
AECoercionHandlerUPP upp_GenericCoercionHandler;


/* --------------------------- MacOSError ---------------------------- */

/* Exception object used by AE extension for OS errors */

/* Initialize and return macOSErrException */
PyObject *AE_GetMacOSErrorException(void)
{
	static PyObject *macOSErrException;
	
	if (macOSErrException == NULL)
		macOSErrException = PyErr_NewException("aem.ae.MacOSError", NULL, NULL);
	return macOSErrException;
}


/* Set a MAC-specific error from errno, and return NULL; return None if no error */
PyObject *AE_MacOSError(int err)
{
	PyObject *v;
	
	if (err == 0 && !PyErr_Occurred()) {
		Py_INCREF(Py_None);
		return Py_None;
	}
	if (err == -1 && PyErr_Occurred())
		return NULL;
	v = Py_BuildValue("(i)", err);
	PyErr_SetObject(AE_GetMacOSErrorException(), v);
	Py_DECREF(v);
	return NULL;
}


/* ----------------------- OSType converters ------------------------ */

/* Convert a 4-byte bytes object argument to an OSType value */
int AE_GetOSType(PyObject *v, OSType *pr)
{
	uint32_t tmp;
	if (!PyBytes_Check(v) || PyBytes_Size(v) != 4) {
		PyErr_SetString(PyExc_TypeError,
			"OSType arg must be a bytes object, 4 bytes in length.");
		return 0;
	}
	memcpy((char *)&tmp, PyBytes_AsString(v), 4);
	*pr = (OSType)CFSwapInt32HostToBig(tmp);
	return 1;
}

/* Convert an OSType value to a 4-byte bytes object */
PyObject *AE_BuildOSType(OSType t)
{
	uint32_t tmp = CFSwapInt32HostToBig((uint32_t)t);
	return PyBytes_FromStringAndSize((char *)&tmp, 4);
}


/* ----------------------- Object type AEDesc ----------------------- */

PyTypeObject AEDesc_Type;

#define AEDesc_Check(x) (Py_TYPE(x) == &AEDesc_Type || PyObject_TypeCheck((x), &AEDesc_Type))

typedef struct AEDescObject {
	PyObject_HEAD
	AEDesc ob_itself;
	int ob_owned;
} AEDescObject;

PyObject *AE_AEDesc_New(AEDesc *itself)
{
	AEDescObject *it;
	it = PyObject_NEW(AEDescObject, &AEDesc_Type);
	if (it == NULL) return NULL;
	it->ob_itself = *itself;
	it->ob_owned = 1;
	return (PyObject *)it;
}

PyObject *AE_AEDesc_NewBorrowed(AEDesc *itself)
{
	PyObject *it;
	
	it = AE_AEDesc_New(itself);
	if (it)
		((AEDescObject *)it)->ob_owned = 0;
	return (PyObject *)it;
}

int AE_AEDesc_Convert(PyObject *v, AEDesc *p_itself)
{
	if (!AEDesc_Check(v))
	{
		PyErr_SetString(PyExc_TypeError, "aem.ae.AEDesc required");
		return 0;
	}
	*p_itself = ((AEDescObject *)v)->ob_itself;
	return 1;
}

int AE_AEDesc_ConvertDisown(PyObject *v, AEDesc *p_itself) {
	if (!AE_AEDesc_Convert(v, p_itself)) return 0;
	((AEDescObject *)v)->ob_owned = 0;
	return 1;
}

static void AEDesc_dealloc(AEDescObject *self)
{
	if (self->ob_owned) AEDisposeDesc(&self->ob_itself);
	Py_TYPE(self)->tp_free((PyObject *)self);
}

static PyObject *AEDesc_AEFlattenDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	Size dataSize;
	void *data;
	
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	dataSize = AESizeOfFlattenedDesc(&_self->ob_itself);
	data = malloc(dataSize);
	_err = AEFlattenDesc(&_self->ob_itself, data, dataSize, NULL);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("s#", data, dataSize);
	free(data);
	return _res;
}

static PyObject *AEDesc_AECoerceDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	DescType toType;
	AEDesc result;

	if (!PyArg_ParseTuple(_args, "O&",
	                      AE_GetOSType, &toType))
		return NULL;
	_err = AECoerceDesc(&_self->ob_itself,
	                    toType,
	                    &result);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AEDesc_AEDuplicateDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEDesc result;

	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = AEDuplicateDesc(&_self->ob_itself,
	                       &result);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AEDesc_AECountItems(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	long theCount;

	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = AECountItems(&_self->ob_itself,
	                    &theCount);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("l",
	                     theCount);
	return _res;
}

static PyObject *AEDesc_AECheckIsRecord(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	Boolean isRecord;

	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	isRecord = AECheckIsRecord(&_self->ob_itself);
	_res = Py_BuildValue("b",
	                     isRecord);
	return _res;
}

static PyObject *AEDesc_AEPutDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	long index;
	AEDesc theAEDesc;

	if (!PyArg_ParseTuple(_args, "lO&",
	                      &index,
	                      AE_AEDesc_Convert, &theAEDesc))
		return NULL;
	_err = AEPutDesc(&_self->ob_itself,
	                 index,
	                 &theAEDesc);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *AEDesc_AEGetNthDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	long index;
	DescType desiredType;
	AEKeyword theAEKeyword;
	AEDesc result;

	if (!PyArg_ParseTuple(_args, "lO&",
	                      &index,
	                      AE_GetOSType, &desiredType))
		return NULL;
	_err = AEGetNthDesc(&_self->ob_itself,
	                    index,
	                    desiredType,
	                    &theAEKeyword,
	                    &result);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&O&",
	                     AE_BuildOSType, theAEKeyword,
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AEDesc_AEPutParamDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEKeyword theAEKeyword;
	AEDesc theAEDesc;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &theAEKeyword,
	                      AE_AEDesc_Convert, &theAEDesc))
		return NULL;
	_err = AEPutParamDesc(&_self->ob_itself,
	                      theAEKeyword,
	                      &theAEDesc);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *AEDesc_AEGetParamDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEKeyword theAEKeyword;
	DescType desiredType;
	AEDesc result;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &theAEKeyword,
	                      AE_GetOSType, &desiredType))
		return NULL;
	_err = AEGetParamDesc(&_self->ob_itself,
	                      theAEKeyword,
	                      desiredType,
	                      &result);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AEDesc_AEPutAttributeDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEKeyword theAEKeyword;
	AEDesc theAEDesc;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &theAEKeyword,
	                      AE_AEDesc_Convert, &theAEDesc))
		return NULL;
	_err = AEPutAttributeDesc(&_self->ob_itself,
	                          theAEKeyword,
	                          &theAEDesc);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *AEDesc_AEGetAttributeDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEKeyword theAEKeyword;
	DescType desiredType;
	AEDesc result;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &theAEKeyword,
	                      AE_GetOSType, &desiredType))
		return NULL;
	_err = AEGetAttributeDesc(&_self->ob_itself,
	                          theAEKeyword,
	                          desiredType,
	                          &result);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AEDesc_AESendMessage(AEDescObject *_self, PyObject *_args) // thread-safe
{
	PyObject *_res = NULL;
	OSErr _err;
	AppleEvent reply;
	AESendMode sendMode;
	long timeOutInTicks;

	if (!PyArg_ParseTuple(_args, "il",
						  &sendMode,
						  &timeOutInTicks))
		return NULL;
	Py_BEGIN_ALLOW_THREADS
	_err = AE_SendMessageThreadSafe(&_self->ob_itself,
									&reply,
									sendMode,
									timeOutInTicks);
	Py_END_ALLOW_THREADS
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
						 AE_AEDesc_New, &reply);
	return _res;
}

static PyMethodDef AEDesc_methods[] = {
	
	{"flatten", (PyCFunction)AEDesc_AEFlattenDesc, 1, PyDoc_STR(
		"D.flatten() -> (Ptr buffer)\n"
		"Flattens the specified descriptor and stores the data in the\n"
		"supplied buffer.")},
	
	{"coerce", (PyCFunction)AEDesc_AECoerceDesc, 1, PyDoc_STR(
		"D.coerce(DescType toType) -> (AEDesc result)\n"
		"Coerces the data in a descriptor to another descriptor type and\n"
		"creates a descriptor containing the newly coerced data.")},
	
	{"duplicate", (PyCFunction)AEDesc_AEDuplicateDesc, 1, PyDoc_STR(
		"D.duplicate() -> (AEDesc result)\n"
		"Creates a copy of a descriptor.")},
	
	{"count", (PyCFunction)AEDesc_AECountItems, 1, PyDoc_STR(
		"D.count() -> (long theCount)\n"
		"Counts the number of descriptors in a descriptor list.")},
	
	{"isrecord", (PyCFunction)AEDesc_AECheckIsRecord, 1, PyDoc_STR(
		"D.isrecord() -> (Boolean isRecord)\n"
		"Determines whether a descriptor is truly an AERecord.")},
	
	
	{"setitem", (PyCFunction)AEDesc_AEPutDesc, 1, PyDoc_STR(
		"D.setitem(long index, AEDesc theAEDesc) -> None\n"
		"Inserts a descriptor and a keyword into an Apple event record as an\n"
		"Apple event parameter.")},
	
	{"getitem", (PyCFunction)AEDesc_AEGetNthDesc, 1, PyDoc_STR(
		"D.getitem(long index, DescType desiredType)\n"
		"-> (AEKeyword theAEKeyword, AEDesc result)\n"
		"Copies a descriptor from a specified position in a descriptor list\n"
		"into a specified descriptor.")},
	
	
	{"setparam", (PyCFunction)AEDesc_AEPutParamDesc, 1, PyDoc_STR(
		"D.setparam(AEKeyword theAEKeyword, AEDesc theAEDesc) -> None\n"
		"Inserts a descriptor and a keyword into an Apple event or Apple\n"
		"event record as an Apple event parameter.")},
	
	{"getparam", (PyCFunction)AEDesc_AEGetParamDesc, 1, PyDoc_STR(
		"D.getparam(AEKeyword theAEKeyword, DescType desiredType)\n"
		"-> (AEDesc result)\n"
		"Gets a copy of the descriptor for a keyword-specified Apple event\n"
		"parameter from an Apple event or an Apple event record.")},
	
	
	{"setattr", (PyCFunction)AEDesc_AEPutAttributeDesc, 1, PyDoc_STR(
		"D.setattr(AEKeyword theAEKeyword, AEDesc theAEDesc) -> None\n"
		"Adds a descriptor and a keyword to an Apple event as an attribute.")},
	
	{"getattr", (PyCFunction)AEDesc_AEGetAttributeDesc, 1, PyDoc_STR(
		"D.getattr(AEKeyword theAEKeyword, DescType desiredType)\n"
		"-> (AEDesc result)\n"
		"Gets a copy of the descriptor for a specified Apple event attribute\n"
		"from an Apple event.")},
	
	
	{"send", (PyCFunction)AEDesc_AESendMessage, 1, PyDoc_STR(
		"D.send(AESendMode sendMode, long timeOutInTicks)\n"
		"-> (AppleEvent reply)\n"
		"Sends an AppleEvent to a target process.")},
	
	{NULL, NULL, 0}
};

static PyObject *AEDesc_get_type(AEDescObject *self, void *closure)
{
	return AE_BuildOSType(self->ob_itself.descriptorType);
}

#define AEDesc_set_type NULL

static PyObject *AEDesc_get_data(AEDescObject *self, void *closure)
{
	PyObject *res;
	Size size;
	char *ptr;
	OSErr err;
	
	size = AEGetDescDataSize(&self->ob_itself);
	if ( (res = PyBytes_FromStringAndSize(NULL, size)) == NULL )
		return NULL;
	if ( (ptr = PyBytes_AsString(res)) == NULL )
		return NULL;
	if ( (err=AEGetDescData(&self->ob_itself, ptr, size)) < 0 )
		return AE_MacOSError(err);	
	return res;
}

#define AEDesc_set_data NULL

static PyGetSetDef AEDesc_getsetlist[] = {
	{"type", (getter)AEDesc_get_type, (setter)AEDesc_set_type, "Type of this AEDesc"},
	{"data", (getter)AEDesc_get_data, (setter)AEDesc_set_data, "The raw data in this AEDesc"},
	{NULL, NULL, NULL, NULL},
};

static PyObject *AEDesc_repr(AEDescObject *self)
{
	PyObject *type, *rep;
	
	type = AE_BuildOSType(self->ob_itself.descriptorType);
	rep = PyUnicode_FromFormat("<aem.ae.AEDesc type=%R size=%ld>",
							  type,
							  AEGetDescDataSize(&self->ob_itself));
	Py_DECREF(type);
	return rep;
}

#define AEDesc_hash NULL
#define AEDesc_tp_init 0

#define AEDesc_tp_alloc PyType_GenericAlloc

static PyObject *AEDesc_tp_new(PyTypeObject *type, PyObject *args, PyObject *kwds)
{
	PyObject *self;
	AEDesc itself;
	char *kw[] = {"itself", 0};

	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&", kw, AE_AEDesc_Convert, &itself)) return NULL;
	if ((self = type->tp_alloc(type, 0)) == NULL) return NULL;
	((AEDescObject *)self)->ob_itself = itself;
	return self;
}

#define AEDesc_tp_free PyObject_Del


PyTypeObject AEDesc_Type = {
	PyVarObject_HEAD_INIT(&PyType_Type, 0)
	"aem.ae.AEDesc", /*tp_name*/
	sizeof(AEDescObject), /*tp_basicsize*/
	0, /*tp_itemsize*/
	/* methods */
	(destructor)AEDesc_dealloc, /*tp_dealloc*/
	0, /*tp_print*/
	0, /*tp_getattr*/
	0, /*tp_setattr*/
	0, /*tp_reserved*/
	(reprfunc)AEDesc_repr, /*tp_repr*/
	0, /* tp_as_number */
	0, /* tp_as_sequence */
	0, /* tp_as_mapping */
	(hashfunc)AEDesc_hash, /*tp_hash*/
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
	AEDesc_methods, /* tp_methods */
	0, /*tp_members*/
	AEDesc_getsetlist, /*tp_getset*/
	0, /*tp_base*/
	0, /*tp_dict*/
	0, /*tp_descr_get*/
	0, /*tp_descr_set*/
	0, /*tp_dictoffset*/
	AEDesc_tp_init, /* tp_init */
	AEDesc_tp_alloc, /* tp_alloc */
	AEDesc_tp_new, /* tp_new */
	AEDesc_tp_free, /* tp_free */
};

/* --------------------- End object type AEDesc --------------------- */

/* ----------------------- AEDesc constructors ---------------------- */


static PyObject *AE_AECreateDesc(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	DescType typeCode;
	char *dataPtr__in__;
	long dataPtr__len__;
	int dataPtr__in_len__;
	AEDesc result;

	if (!PyArg_ParseTuple(_args, "O&s#",
	                      AE_GetOSType, &typeCode,
	                      &dataPtr__in__, &dataPtr__in_len__))
		return NULL;
	dataPtr__len__ = dataPtr__in_len__;
	_err = AECreateDesc(typeCode,
	                    dataPtr__in__, dataPtr__len__,
	                    &result);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AE_AECreateList(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEDescList resultList;

	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = AECreateList(NULL, 0,
	                    0,
	                    &resultList);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &resultList);
	return _res;
}

static PyObject *AE_AECreateRecord(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEDescList resultList;

	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	_err = AECreateList(NULL, 0,
	                    1,
	                    &resultList);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &resultList);
	return _res;
}

static PyObject *AE_AECreateAppleEvent(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEAddressDesc target;
	AEReturnID returnID;
	AETransactionID transactionID;
	AppleEvent result;

	if (!PyArg_ParseTuple(_args, "O&O&O&hi",
	                      AE_GetOSType, &theAEEventClass,
	                      AE_GetOSType, &theAEEventID,
	                      AE_AEDesc_Convert, &target,
	                      &returnID,
	                      &transactionID))
		return NULL;
	_err = AECreateAppleEvent(theAEEventClass,
	                          theAEEventID,
	                          &target,
	                          returnID,
	                          transactionID,
	                          &result);
	if (_err != noErr) return AE_MacOSError(_err);
	// workaround for return ID bug in 10.6
	DescType typeCode;
	Size actualSize;
	SInt32 actualReturnID;
	if (returnID == kAutoGenerateReturnID) {
		_err = AEGetAttributePtr(&result, 
								 keyReturnIDAttr, 
								 typeSInt32,
								 &typeCode,
								 &actualReturnID,
								 sizeof(actualReturnID),
								 &actualSize);
		if (_err != noErr) return AE_MacOSError(_err);
		if (actualReturnID == -1) {
			AEDisposeDesc(&result);
			_err = AECreateAppleEvent(theAEEventClass,
									  theAEEventID,
									  &target,
									  returnID,
									  transactionID,
									  &result);
			if (_err != noErr) return AE_MacOSError(_err);
		}
	}
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
	return _res;
}

static PyObject *AE_AEUnflattenDesc(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	void *data;
	Size dataSize;
	AEDesc desc;
	
	if (!PyArg_ParseTuple(_args, "s#",
	                      &data, &dataSize))
		return NULL;
	_err = AEUnflattenDesc(data, &desc);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
	                     AE_AEDesc_New, &desc);
	return _res;
}


/* --------------------- Event, Coercion Handlers --------------------- */

static PyObject *AE_AEInstallEventHandler(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEEventHandlerUPP handler__proc__ = upp_GenericEventHandler;
	PyObject *handler;

	if (!PyArg_ParseTuple(_args, "O&O&O",
	                      AE_GetOSType, &theAEEventClass,
	                      AE_GetOSType, &theAEEventID,
	                      &handler))
		return NULL;
	_err = AEInstallEventHandler(theAEEventClass,
	                             theAEEventID,
	                             handler__proc__, (SRefCon)handler,
	                             0);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	Py_INCREF(handler); /* XXX leak, but needed */
	return _res;
}

static PyObject *AE_AERemoveEventHandler(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &theAEEventClass,
	                      AE_GetOSType, &theAEEventID))
		return NULL;
	_err = AERemoveEventHandler(theAEEventClass,
	                            theAEEventID,
	                            upp_GenericEventHandler,
	                            0);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *AE_AEGetEventHandler(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEEventClass theAEEventClass;
	AEEventID theAEEventID;
	AEEventHandlerUPP handler__proc__;
	PyObject *handler;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &theAEEventClass,
	                      AE_GetOSType, &theAEEventID))
		return NULL;
	_err = AEGetEventHandler(theAEEventClass,
	                         theAEEventID,
	                         &handler__proc__, (SRefCon *)&handler,
	                         0);
	if (_err != noErr) return AE_MacOSError(_err);
	/* currently only supports getting handlers installed via aem.ae.installeventhandler */
	if (handler__proc__ != upp_GenericEventHandler)
		return AE_MacOSError(errAEHandlerNotFound);
	_res = Py_BuildValue("O", handler);
	Py_INCREF(handler); /* XXX leak, but needed */
	return _res;
}

static PyObject *AE_AEInstallCoercionHandler(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	DescType fromType, toType;
	AECoercionHandlerUPP handler__proc__ = upp_GenericCoercionHandler;
	PyObject *handler;

	if (!PyArg_ParseTuple(_args, "O&O&O",
	                      AE_GetOSType, &fromType,
	                      AE_GetOSType, &toType,
	                      &handler))
		return NULL;
	_err = AEInstallCoercionHandler(fromType,
	                                toType,
	                                handler__proc__, (SRefCon)handler,
	                                1, 0);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	Py_INCREF(handler); /* XXX leak, but needed */
	return _res;
}

static PyObject *AE_AERemoveCoercionHandler(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	DescType fromType, toType;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &fromType,
	                      AE_GetOSType, &toType))
		return NULL;
	_err = AERemoveCoercionHandler(fromType,
	                            toType,
	                            upp_GenericCoercionHandler,
	                            0);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
	return _res;
}

static PyObject *AE_AEGetCoercionHandler(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	DescType fromType, toType;
	AECoercionHandlerUPP handler__proc__;
	PyObject *handler;
	Boolean fromTypeIsDesc;

	if (!PyArg_ParseTuple(_args, "O&O&",
	                      AE_GetOSType, &fromType,
	                      AE_GetOSType, &toType))
		return NULL;
	_err = AEGetCoercionHandler(fromType,
	                         toType,
	                         &handler__proc__, (SRefCon *)&handler,
	                         &fromTypeIsDesc,
	                         0);
	if (_err != noErr) return AE_MacOSError(_err);
	/* currently only supports getting handlers installed via aem.ae.installcoercionhandler */
	if (handler__proc__ != upp_GenericCoercionHandler)
		return AE_MacOSError(errAEHandlerNotFound);
	_res = Py_BuildValue("Ob",
	                     handler,
	                     fromTypeIsDesc);
	Py_INCREF(handler); /* XXX leak, but needed */
	return _res;
}

static OSErr GenericEventHandler(const AppleEvent *request, AppleEvent *reply, SRefCon refcon)
{
	PyObject *handler = (PyObject *)refcon;
	AEDescObject *requestObject, *replyObject;
	PyObject *args, *res;
    PyGILState_STATE state;
	OSErr err = noErr;
	
	state = PyGILState_Ensure();
	if ((requestObject = (AEDescObject *)AE_AEDesc_New((AppleEvent *)request)) == NULL) {
		err = -1;
		goto cleanup;
	}
	if ((replyObject = (AEDescObject *)AE_AEDesc_New(reply)) == NULL) {
		Py_DECREF(requestObject);
		err = -1;
		goto cleanup;
	}
	if ((args = Py_BuildValue("OO", requestObject, replyObject)) == NULL) {
		Py_DECREF(requestObject);
		Py_DECREF(replyObject);
		err = -1;
		goto cleanup;
	}
	res = PyEval_CallObject(handler, args);
	requestObject->ob_itself.descriptorType = 'null';
	requestObject->ob_itself.dataHandle = NULL;
	replyObject->ob_itself.descriptorType = 'null';
	replyObject->ob_itself.dataHandle = NULL;
	Py_DECREF(args);
	if (res == NULL) {
		PySys_WriteStderr("Exception in AE event handler function\n");
		PyErr_Print();
		err = -1;
		goto cleanup;
	}
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}

static OSErr GenericCoercionHandler(const AEDesc *fromDesc, DescType toType, SRefCon refcon, AEDesc *toDesc)
{	
	PyObject *handler = (PyObject *)refcon;
	AEDescObject *fromObject;
	PyObject *args, *res;
    PyGILState_STATE state;
	OSErr err = noErr;
	
	state = PyGILState_Ensure();
	if ((fromObject = (AEDescObject *)AE_AEDesc_New((AEDesc *)fromDesc)) == NULL) {
		err = -1;
		goto cleanup;
	}
	if ((args = Py_BuildValue("OO&", fromObject, AE_BuildOSType, &toType)) == NULL) {
		Py_DECREF(fromObject);
		err = -1;
		goto cleanup;
	}
	res = PyEval_CallObject(handler, args);
	fromObject->ob_itself.descriptorType = 'null';
	fromObject->ob_itself.dataHandle = NULL;
	Py_DECREF(args);
	if (res == NULL) {
		PySys_WriteStderr("Exception in AE coercion handler function\n");
		PyErr_Print();
		err = errAECoercionFail;
		goto cleanup;
	}
	if (!AEDesc_Check(res)) {
		PySys_WriteStderr("AE coercion handler function did not return an AEDesc\n");
		Py_DECREF(res);
		err = errAECoercionFail;
		goto cleanup;
	}
	if (AEDuplicateDesc(&((AEDescObject *)res)->ob_itself, toDesc)) {
		Py_DECREF(res);
		err = -1;
		goto cleanup;
	}
	Py_DECREF(res);
cleanup:
	PyGILState_Release(state);
	return err;
}

/* --------------------- Miscellaneous functions ---------------------- */

static PyObject *AE_GetOSStatusStrings(PyObject* self, PyObject* args)
{
	OSStatus errNum;
	
	if (!PyArg_ParseTuple(args, "i", &errNum))
		return NULL;
	const char *errorStr = GetMacOSStatusErrorString(errNum);
	const char *commentStr = GetMacOSStatusCommentString(errNum);
	return Py_BuildValue("ss", errorStr, commentStr);
}


static PyObject *AE_ConvertPathToURL(PyObject* self, PyObject* args)
{
	char *cStr;
	CFURLPathStyle style;
	CFStringRef str;
	CFURLRef url;
	CFIndex len;
	char buffer[PATH_MAX];
	
	if (!PyArg_ParseTuple(args, "esl", "utf8", &cStr, &style))
		return NULL;
	str = CFStringCreateWithBytes(NULL,
								  (UInt8 *)cStr,
								  (CFIndex)strlen(cStr),
								  kCFStringEncodingUTF8,
								  false);
	if (!str) return AE_MacOSError(1000);
	url = CFURLCreateWithFileSystemPath(NULL,
										str,
										(CFURLPathStyle)style,
										false);
	PyMem_Free(cStr);
	if (!url) return AE_MacOSError(1001);
	len = CFURLGetBytes(url, (UInt8 *)buffer, PATH_MAX);
	CFRelease(url);
	return PyUnicode_DecodeUTF8(buffer, len, NULL);
}



static PyObject *AE_ConvertURLToPath(PyObject* self, PyObject* args)
{
	char *cStr;
	CFURLPathStyle style;
	CFURLRef url;
	CFStringRef str;
	char buffer[PATH_MAX];
	Boolean err;

	if (!PyArg_ParseTuple(args, "esl", 
						  "utf8", &cStr, 
						  &style))
		return NULL;
	url = CFURLCreateWithBytes(NULL,
							   (UInt8 *)cStr,
							   (CFIndex)strlen(cStr),
							   kCFStringEncodingUTF8,
							   NULL);
	PyMem_Free(cStr);
	if (!url) return AE_MacOSError(1000);
	str = CFURLCopyFileSystemPath(url, (CFURLPathStyle)style);
	CFRelease(url);
	if (!str) return AE_MacOSError(1001);
	err = CFStringGetCString(str,
							 buffer,
							 PATH_MAX,
							 kCFStringEncodingUTF8);
	CFRelease(str);
	if (!err) return AE_MacOSError(1002);
	return PyUnicode_DecodeUTF8(buffer, strlen(buffer), NULL);
}


/*-------------------------------------------------*/


static int AE_GetCFStringRef(PyObject *v, CFStringRef *p_itself)
{
	if (v == Py_None) { *p_itself = NULL; return 1; }
	if (PyBytes_Check(v)) {
	    char *cStr;
	    if (!PyArg_Parse(v, "es", "ascii", &cStr))
	    	return 0;
		*p_itself = CFStringCreateWithCString((CFAllocatorRef)NULL, cStr, kCFStringEncodingASCII);
		PyMem_Free(cStr);
		return 1;
	}
	if (PyUnicode_Check(v)) {
#ifdef Py_UNICODE_WIDE
	CFIndex size = PyUnicode_GET_DATA_SIZE(v);
	UTF32Char *unichars = PyUnicode_AsUnicode(v);
	*p_itself = CFStringCreateWithBytes((CFAllocatorRef)NULL,
										unichars,
										size,
										kCFStringEncodingUTF32, // 10.4+
										false); // ?
#else
		CFIndex size = PyUnicode_GetSize(v);
		UniChar *unichars = PyUnicode_AsUnicode(v);
		if (!unichars) return 0;
		*p_itself = CFStringCreateWithCharacters((CFAllocatorRef)NULL, unichars, size);
#endif
		return 1;
	}
	PyErr_SetString(PyExc_TypeError, "str/unicode required");
	return 0;
}


static PyObject *AE_LSFindApplicationForInfo(PyObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSStatus _err;
	OSType inCreator;
	CFStringRef inBundleID;
	CFStringRef inName;
	FSRef outAppRef;
	char path[PATH_MAX];
	
	if (!PyArg_ParseTuple(_args, "O&O&O&",
	                      AE_GetOSType, &inCreator,
	                      AE_GetCFStringRef, &inBundleID,
	                      AE_GetCFStringRef, &inName))
		return NULL;
	_err = LSFindApplicationForInfo(inCreator,
	                                inBundleID,
	                                inName,
	                                &outAppRef,
	                                NULL);
	if (inBundleID != NULL) CFRelease(inBundleID);
	if (inName != NULL) CFRelease(inName);
	if (_err != noErr) return AE_MacOSError(_err);
	_err = FSRefMakePath(&outAppRef, (UInt8 *)path, PATH_MAX);
	_res = PyUnicode_DecodeUTF8(path, strlen(path), NULL);
	return _res;
}


/* ------------------- Process Manager functions --------------------- */

static int AE_GetFSRef(PyObject *v, FSRef *fsr)
{
        OSStatus err;

        if ( PyBytes_Check(v) || PyUnicode_Check(v)) {
                char *path = NULL;
                if (!PyArg_Parse(v, "et", Py_FileSystemDefaultEncoding, &path))
                        return 0;
                if ( (err=FSPathMakeRef((UInt8 *)path, fsr, NULL)) )
                        AE_MacOSError(err);
                PyMem_Free(path);
                return !err;
        }
        PyErr_SetString(PyExc_TypeError, "Pathname required");
        return 0;
}


static PyObject *AE_PSNDescForApplicationPath(PyObject* self, PyObject* args)
{
	ProcessSerialNumber psn = {0, kNoProcess};
	FSRef appRef, foundRef;
	AEDesc result;
	OSStatus err;
	
	if (!PyArg_ParseTuple(args, "O&", 
								AE_GetFSRef, &appRef))
		return NULL;
	while (1) {
		err = GetNextProcess(&psn);
		if (err) return AE_MacOSError(err);
		err = GetProcessBundleLocation(&psn, &foundRef);
		if (err == noErr && FSCompareFSRefs(&appRef, &foundRef) == noErr) break;
	}
	err = AECreateDesc(typeProcessSerialNumber,
	                   &psn, sizeof(psn),
	                   &result);
	if (err != noErr) return AE_MacOSError(err);
	return Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
}


static PyObject *AE_LaunchApplication(PyObject* self, PyObject* args)
{
	FSRef appRef;
	AppleEvent firstEvent;
	LSLaunchFlags flags;
	ProcessSerialNumber psn;
	AEDesc result;
	OSStatus err = noErr;

	if (!PyArg_ParseTuple(args, "O&O&I", 
						  AE_GetFSRef, &appRef,
						  AE_AEDesc_Convert, &firstEvent,
						  &flags))
		return NULL;
	LSApplicationParameters appParams = {0, flags, &appRef, NULL, NULL, NULL, &firstEvent};
	err = LSOpenApplication(&appParams, &psn);
	err = AECreateDesc(typeProcessSerialNumber,
	                   &psn, sizeof(psn),
	                   &result);
	if (err != noErr) return AE_MacOSError(err);
	return Py_BuildValue("O&",
	                     AE_AEDesc_New, &result);
}


static PyObject *AE_TransformProcessToForegroundApplication(PyObject *_self, PyObject *_args)
{
	OSStatus err = 0;
	ProcessSerialNumber psn = {0, kCurrentProcess};
	
	if (!PyArg_ParseTuple(_args, ""))
		return NULL;
	err = TransformProcessType(& psn, kProcessTransformToForegroundApplication);
	if (err != noErr) return AE_MacOSError(err);
	Py_INCREF(Py_None);
	return Py_None;
}


// only needed for checking pid exists
static PyObject *AE_IsValidPID(PyObject *_self, PyObject *_args)
{
	int pid, err;
	
	if (!PyArg_ParseTuple(_args, "i", &pid))
		return NULL;
	err = kill((pid_t)pid, 0);
	return Py_BuildValue("b", (Boolean)(err == 0));
}


static PyObject *AE_AddressDescToPath(PyObject *_self, PyObject *_args)
{
	AEDesc desc;
	ProcessSerialNumber psn;
	pid_t pid;
	OSType creatorType = kLSUnknownCreator;
	Size cSize;
	char *cStr;
	CFStringRef bundleID = NULL;
	FSRef fsref;
	UInt8 path[PATH_MAX];
	PyObject* pathObj;
	OSStatus err;
	
	if (!PyArg_ParseTuple(_args, "O&",
						  AE_AEDesc_Convert, &desc))
	return NULL;
	
	switch (desc.descriptorType) {
	
		case typeKernelProcessID:
			err = AEGetDescData(&desc, &pid, sizeof(pid));
			if (err) return AE_MacOSError(err);
			err = GetProcessForPID(pid, &psn);
			if (err) return AE_MacOSError(err);
			err = GetProcessBundleLocation(&psn, &fsref);
			if (err) return AE_MacOSError(err);
			break;
		
		case typeProcessSerialNumber:
			err = AEGetDescData(&desc, &psn, sizeof(psn));
			if (err) return AE_MacOSError(err);
			err = GetProcessBundleLocation(&psn, &fsref);
			if (err) return AE_MacOSError(err);
			break;
		
		case typeApplSignature:
			err = AEGetDescData(&desc, &creatorType, sizeof(creatorType));
			if (err) return AE_MacOSError(err);
			err = LSFindApplicationForInfo(creatorType, bundleID, NULL, &fsref, NULL);
			if (err) return AE_MacOSError(err);
			break;
		
		case typeApplicationBundleID:
			cSize = AEGetDescDataSize(&desc);
			cStr = malloc((size_t)cSize);
			if (!cStr) return AE_MacOSError(errAECoercionFail);
			err = AEGetDescData(&desc, cStr, cSize);
			if (err) return AE_MacOSError(err);
			bundleID = CFStringCreateWithBytes(NULL, (UInt8 *)cStr, (CFIndex)cSize, kCFStringEncodingUTF8, 0);
			free(cStr);
			if (!bundleID) return AE_MacOSError(errAECoercionFail);
			err = LSFindApplicationForInfo(creatorType, bundleID, NULL, &fsref, NULL);
			if (err) return AE_MacOSError(err);
			break;
		
		case typeMachPort: // unsupported
		case typeApplicationURL: // unsupported (remote applications)
		default: 
			return AE_MacOSError(errAECoercionFail);
	}

	err = FSRefMakePath(&fsref, path, sizeof(path));
	if (err) return AE_MacOSError(err);
	pathObj = PyUnicode_DecodeUTF8((char *)path, strlen((char *)path), NULL);
	return Py_BuildValue("O", pathObj);
}

/* ------------------------ Get aete/aeut/sdef ------------------------ */


static PyObject *BuildTerminologyList(AEDesc *theDesc, DescType requiredType) {
	AEDesc item;
	long size, i;
	AEKeyword key;
	PyObject *itemObj, *result;
	OSErr err;
	
	result = PyList_New(0);
	if (!result) return NULL;
	if (theDesc->descriptorType == typeAEList) {
		err = AECountItems(theDesc, &size);
		if (err) {
			Py_DECREF(result);
			return AE_MacOSError(err);
		}
		for (i = 1; i <= size; i++) {			
			err = AEGetNthDesc(theDesc, i, requiredType, &key, &item);
			if (!err) {
				itemObj = AE_AEDesc_New(&item);
				if (!itemObj) {
					AEDisposeDesc(&item);
					Py_DECREF(result);
					return NULL;
				}
				err = PyList_Append(result, itemObj);
				if (err) {
					Py_DECREF(itemObj);
					Py_DECREF(result);
					return NULL;
				}
			} else if (err != errAECoercionFail) {
				Py_DECREF(result);
				return AE_MacOSError(err);
			}
		}
	} else {
		itemObj = AE_AEDesc_New(theDesc);
		if (!itemObj) {
			AEDisposeDesc(theDesc);
			Py_DECREF(result);
			return NULL;
		}
		err = PyList_Append(result, itemObj);
		if (err) {
			Py_DECREF(itemObj);
			Py_DECREF(result);
			return NULL;
		}
	}
	return result;
}


static PyObject *AE_CopyScriptingDefinition(PyObject* self, PyObject* args)
{
	PyObject *res;
	FSRef fsRef;
	CFDataRef sdef;
	CFIndex dataSize;
	char *data;
	OSAError  err;
	
	if (!PyArg_ParseTuple(args, "O&", AE_GetFSRef, &fsRef))
		return NULL;
	err = OSACopyScriptingDefinition(&fsRef, 0, &sdef);
	if (err) return AE_MacOSError(err);
	dataSize = CFDataGetLength(sdef);
	data = (char *)CFDataGetBytePtr(sdef);
	if (data != NULL) {
		res = PyBytes_FromStringAndSize(data, dataSize);
	} else {
		data = malloc(dataSize);
		CFDataGetBytes(sdef, CFRangeMake(0, dataSize), (UInt8 *)data);
		res = PyBytes_FromStringAndSize(data, dataSize);
		free(data);
	}
	CFRelease(sdef);
	return res;
}


static PyObject *AE_GetSysTerminology(PyObject* self, PyObject* args)
{
	OSType componentSubType;
	ComponentInstance component;
	AEDesc theDesc;
	OSAError err;
	
	if (!PyArg_ParseTuple(args, "O&", AE_GetOSType, &componentSubType))
		return NULL;
	component = OpenDefaultComponent(kOSAComponentType, componentSubType);
	err = GetComponentInstanceError(component);
	if (err) return AE_MacOSError(err);
	err = OSAGetSysTerminology(component, 
							   kOSAModeNull,
							   0, 
							   &theDesc);
	CloseComponent(component);
	if (err) return AE_MacOSError(err);
	return BuildTerminologyList(&theDesc, typeAEUT);
}


/* ------------------------- Module functions ------------------------- */

static PyMethodDef AE_methods[] = {
	
	{"unflattendesc", (PyCFunction)AE_AEUnflattenDesc, 1, PyDoc_STR(
		"unflattendesc(Buffer data) -> (AEDesc result)\n"
		"Unflattens the data in the passed buffer and creates a descriptor\n"
		"from it.")},
		
	{"newdesc", (PyCFunction)AE_AECreateDesc, 1, PyDoc_STR(
		"newdesc(DescType typeCode, Buffer dataPtr) -> (AEDesc result)\n"
		"Creates a new descriptor that incorporates the specified data.")},
		
	{"newlist", (PyCFunction)AE_AECreateList, 1, PyDoc_STR(
		"newlist() -> (AEDescList result)\n"
		"Creates an empty descriptor list.")},
		
	{"newrecord", (PyCFunction)AE_AECreateRecord, 1, PyDoc_STR(
		"newrecord() -> (AERecord result)\n"
		"Creates an empty Apple event record.")},
	
	{"newappleevent", (PyCFunction)AE_AECreateAppleEvent, 1, PyDoc_STR(
		"newappleevent(AEEventClass theAEEventClass,\n"
		"              AEEventID theAEEventID,\n"
		"              AEAddressDesc target,\n"
		"              AEReturnID returnID,\n"
		"              AETransactionID transactionID)\n"
		"-> (AppleEvent result)\n"
		"Creates an Apple event with several important attributes but no\n"
		"parameters.")},
	
	 
	{"installeventhandler", (PyCFunction)AE_AEInstallEventHandler, 1, PyDoc_STR(
		"installeventhandler(AEEventClass theAEEventClass,\n"
		"                    AEEventID theAEEventID,\n"
		"                    EventHandler handler)\n"
		"-> None\n"
		"Adds an entry for an event handler to an Apple event dispatch table.")},
		
	{"removeeventhandler", (PyCFunction)AE_AERemoveEventHandler, 1, PyDoc_STR(
		"removeeventhandler(AEEventClass theAEEventClass,\n"
		"                   AEEventID theAEEventID)\n"
		"-> None\n"
		"Removes an event handler entry from an Apple event dispatch table.")},
		
	{"geteventhandler", (PyCFunction)AE_AEGetEventHandler, 1, PyDoc_STR(
		"geteventhandler(AEEventClass theAEEventClass,\n"
		"                AEEventID theAEEventID)\n"
		"-> (EventHandler handler)\n"
		"Gets an event handler from an Apple event dispatch table.")},
		
	{"installcoercionhandler", (PyCFunction)AE_AEInstallCoercionHandler, 1, PyDoc_STR(
		"installcoercionhandler(DescType fromType,\n"
		"                       DescType toType,\n"
		"                       CoercionHandler handler)\n"
		"-> None\n"
		"Installs a coercion handler in the application coercion handler\n"
		"dispatch table.")},
		
	{"removecoercionhandler", (PyCFunction)AE_AERemoveCoercionHandler, 1, PyDoc_STR(
		"removecoercionhandler(DescType fromType,\n"
		"                      DescType toType)\n"
		"-> None\n"
		"Removes a coercion handler from a coercion handler dispatch table.")},
		
	{"getcoercionhandler", (PyCFunction)AE_AEGetCoercionHandler, 1, PyDoc_STR(
		"getcoercionhandler(DescType fromType,\n"
		"                   DescType toType)\n"
		"-> (CoercionHandler handler, Boolean fromTypeIsDesc)\n"
		"Gets the coercion handler for a specified descriptor type.")},
	
	
	{"stringsforosstatus", (PyCFunction)AE_GetOSStatusStrings, METH_VARARGS, PyDoc_STR(
		"stringsforosstatus(OSStatus errNum) -> (str errorStr, str commentStr)")},
	
  	{"convertpathtourl", (PyCFunction)AE_ConvertPathToURL, METH_VARARGS, PyDoc_STR(
		"convertpathtourl(utf8 path, CFURLPathStyle style) -> (utf8 url)")},
	
  	{"converturltopath", (PyCFunction)AE_ConvertURLToPath, METH_VARARGS, PyDoc_STR(
		"converturltopath(utf8 url, CFURLPathStyle style) -> (utf8 path)")},
	
	{"findapplicationforinfo", (PyCFunction)AE_LSFindApplicationForInfo, 1, PyDoc_STR(
		"findapplicationforinfo(OSType inCreator,\n"
		"                       CFStringRef inBundleID,\n"
		"                       CFStringRef inName)\n"
		"-> (unicode outAppURL)\n"
		"Locates the preferred application for opening items with a specified\n"
		"file type, creator signature, filename extension, or any combination\n"
		"of these characteristics.")},
	 
	
	{"psnforapplicationpath", AE_PSNDescForApplicationPath, METH_VARARGS, PyDoc_STR(
		"psnforapplicationpath(unicode path) -> (AEAddressDesc desc)")},
	
  	{"launchapplication", (PyCFunction)AE_LaunchApplication, METH_VARARGS, PyDoc_STR(
		"launchapplication(unicode path,\n"
		"                  AEDesc firstEvent,\n"
		"                  unsigned short flags)\n"
		"-> (pid_t pid)")},
	
  	{"transformprocesstoforegroundapplication", 
  		(PyCFunction)AE_TransformProcessToForegroundApplication, METH_VARARGS, PyDoc_STR(
		"transformprocesstoforegroundapplication() -> None")},
	
  	{"isvalidpid", (PyCFunction)AE_IsValidPID, METH_VARARGS, PyDoc_STR(
		"isvalidpid(pid_t pid) -> (Boolean result)")},
	
		
  	{"addressdesctopath", (PyCFunction)AE_AddressDescToPath, METH_VARARGS, PyDoc_STR(
		"addressdesctopath(AEAddressDesc desc) -> (unicode path)")},
	
	
  	{"copyscriptingdefinition", (PyCFunction) AE_CopyScriptingDefinition, METH_VARARGS, PyDoc_STR(
		"copyscriptingdefinition(unicode path) -> (unicode sdef)\n"
		"Creates a copy of a scripting definition (sdef) from the specified\n"
		"file or bundle.")},
		
  	{"getsysterminology", (PyCFunction) AE_GetSysTerminology, METH_VARARGS, PyDoc_STR(
		"getsysterminology(OSType subTypeCode) -> (AEDesc aeut)\n"
		"Gets one or more scripting terminology resources from the OSA system.")},
	
	{NULL, NULL, 0}
};



PyDoc_STRVAR(AE_module_doc,
"Low-level bindings for Carbon Apple Event Manager and other\n"
"Mac OS X APIs used by aem/appscript.");


static struct PyModuleDef AE_module = {
	PyModuleDef_HEAD_INIT,
	"ae",
	AE_module_doc,
	-1,
	AE_methods,
	NULL,
	NULL,
	NULL,
	NULL
};



PyMODINIT_FUNC
PyInit_ae(void)
{
	PyObject *m, *errClass;

	upp_GenericEventHandler = NewAEEventHandlerUPP(GenericEventHandler);
	upp_GenericCoercionHandler = NewAECoerceDescUPP(GenericCoercionHandler);
	
	m = PyModule_Create(&AE_module);
	
	errClass = AE_GetMacOSErrorException();
	if (!errClass || PyModule_AddObject(m, "MacOSError", errClass)) goto fail;
	
	if (PyType_Ready(&AEDesc_Type)) goto fail;
	Py_INCREF(&AEDesc_Type);
	PyModule_AddObject(m, "AEDesc", (PyObject *)&AEDesc_Type);
	
	/* Create capsule for C API */
	static void *aeAPI[] = {AE_AEDesc_New,
							AE_AEDesc_NewBorrowed,
							AE_AEDesc_Convert,
							AE_AEDesc_ConvertDisown,
							AE_GetMacOSErrorException,
							AE_MacOSError,
							AE_GetOSType,
							AE_BuildOSType};
	
	PyObject *aeAPIObj = PyCapsule_New((void *)aeAPI, "ae._C_API", NULL);
	if (aeAPIObj)
		PyModule_AddObject(m, "_C_API", aeAPIObj);
	return m;
 fail:
	Py_XDECREF(m);
	return NULL;
}

/* ========================= End module AE ========================= */

