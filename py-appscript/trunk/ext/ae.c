/*
 * Original code taken from _AEmodule.c, _CFmodule.c, _Launchmodule.c
 *     Copyright (C) 2001-2008 Python Software Foundation.
 *
 * New code Copyright (C) 2005-2008 HAS
 */
 
/* =========================== Module AE =========================== */

#include "Python.h"
#include "aetoolbox.h"
#include "sendthreadsafe.c"

#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include <ApplicationServices/ApplicationServices.h>

extern PyObject *_AE_AEDesc_New(AEDesc *);
extern PyObject *_AE_AEDesc_NewBorrowed(AEDesc *);
extern int _AE_AEDesc_Convert(PyObject *, AEDesc *);
extern int _AE_AEDesc_ConvertDisown(PyObject *, AEDesc *);
extern PyObject *_AE_GetMacOSErrorException(void);
extern PyObject *_AE_MacOSError(int err);
extern int _AE_GetOSType(PyObject *v, OSType *pr);
extern PyObject *_AE_BuildOSType(OSType t);

#define AE_AEDesc_New _AE_AEDesc_New
#define AE_AEDesc_NewBorrowed _AE_AEDesc_NewBorrowed
#define AE_AEDesc_Convert _AE_AEDesc_Convert
#define AE_AEDesc_ConvertDisown _AE_AEDesc_ConvertDisown
#define AE_GetMacOSErrorException _AE_GetMacOSErrorException
#define AE_MacOSError _AE_MacOSError
#define AE_GetOSType _AE_GetOSType
#define AE_BuildOSType _AE_BuildOSType

// Event handling
#if __LP64__
	// SRefCon typedefed as void * by system headers
#else
	typedef long SRefCon;
#endif

AEEventHandlerUPP upp_GenericEventHandler;
AECoercionHandlerUPP upp_GenericCoercionHandler;

// Get terminology

extern OSAError OSACopyScriptingDefinition(const FSRef *, SInt32, CFDataRef *) __attribute__((weak_import));


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

/* Convert a 4-char string object argument to an OSType value */
int AE_GetOSType(PyObject *v, OSType *pr)
{
	uint32_t tmp;
	if (!PyString_Check(v) || PyString_Size(v) != 4) {
		PyErr_SetString(PyExc_TypeError,
			"OSType arg must be string of 4 chars");
		return 0;
	}
	memcpy((char *)&tmp, PyString_AsString(v), 4);
	*pr = (OSType)CFSwapInt32HostToBig(tmp);
	return 1;
}

/* Convert an OSType value to a 4-char string object */
PyObject *AE_BuildOSType(OSType t)
{
	uint32_t tmp = CFSwapInt32HostToBig((uint32_t)t);
	return PyString_FromStringAndSize((char *)&tmp, 4);
}


/* ----------------------- Object type AEDesc ----------------------- */

PyTypeObject AEDesc_Type;

#define AEDesc_Check(x) ((x)->ob_type == &AEDesc_Type || PyObject_TypeCheck((x), &AEDesc_Type))

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
	self->ob_type->tp_free((PyObject *)self);
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

static PyObject *AEDesc_AEDeleteItem(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	long index;

	if (!PyArg_ParseTuple(_args, "l",
	                      &index))
		return NULL;
	_err = AEDeleteItem(&_self->ob_itself,
	                    index);
	if (_err != noErr) return AE_MacOSError(_err);
	Py_INCREF(Py_None);
	_res = Py_None;
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

static PyObject *AEDesc_AEDeleteParam(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	AEKeyword theAEKeyword;

	if (!PyArg_ParseTuple(_args, "O&",
	                      AE_GetOSType, &theAEKeyword))
		return NULL;
	_err = AEDeleteParam(&_self->ob_itself,
	                     theAEKeyword);
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
	_err = AE_SendMessageThreadSafe(&_self->ob_itself,
									&reply,
									sendMode,
									timeOutInTicks);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("O&",
						 AE_AEDesc_New, &reply);
	return _res;
}

static PyObject *AEDesc_AEFlattenDesc(AEDescObject *_self, PyObject *_args)
{
	PyObject *_res = NULL;
	OSErr _err;
	Size dataSize;
	void *data;
	
	dataSize = AESizeOfFlattenedDesc(&_self->ob_itself);
	data = malloc(dataSize);
	_err = AEFlattenDesc(&_self->ob_itself, data, dataSize, NULL);
	if (_err != noErr) return AE_MacOSError(_err);
	_res = Py_BuildValue("s#", data, dataSize);
	free(data);
	return _res;
}

static PyMethodDef AEDesc_methods[] = {
	{"AEFlattenDesc", (PyCFunction)AEDesc_AEFlattenDesc, 1,
	 PyDoc_STR("() -> (Ptr buffer)")},
	{"AECoerceDesc", (PyCFunction)AEDesc_AECoerceDesc, 1,
	 PyDoc_STR("(DescType toType) -> (AEDesc result)")},
	{"AEDuplicateDesc", (PyCFunction)AEDesc_AEDuplicateDesc, 1,
	 PyDoc_STR("() -> (AEDesc result)")},
	{"AECountItems", (PyCFunction)AEDesc_AECountItems, 1,
	 PyDoc_STR("() -> (long theCount)")},
	{"AECheckIsRecord", (PyCFunction)AEDesc_AECheckIsRecord, 1,
	 PyDoc_STR("() -> (Boolean isRecord)")},
	{"AEPutDesc", (PyCFunction)AEDesc_AEPutDesc, 1,
	 PyDoc_STR("(long index, AEDesc theAEDesc) -> None")},
	{"AEGetNthDesc", (PyCFunction)AEDesc_AEGetNthDesc, 1,
	 PyDoc_STR("(long index, DescType desiredType) -> (AEKeyword theAEKeyword, AEDesc result)")},
	{"AEDeleteItem", (PyCFunction)AEDesc_AEDeleteItem, 1,
	 PyDoc_STR("(long index) -> None")},
	{"AEPutParamDesc", (PyCFunction)AEDesc_AEPutParamDesc, 1,
	 PyDoc_STR("(AEKeyword theAEKeyword, AEDesc theAEDesc) -> None")},
	{"AEGetParamDesc", (PyCFunction)AEDesc_AEGetParamDesc, 1,
	 PyDoc_STR("(AEKeyword theAEKeyword, DescType desiredType) -> (AEDesc result)")},
	{"AEDeleteParam", (PyCFunction)AEDesc_AEDeleteParam, 1,
	 PyDoc_STR("(AEKeyword theAEKeyword) -> None")},
	{"AEGetAttributeDesc", (PyCFunction)AEDesc_AEGetAttributeDesc, 1,
	 PyDoc_STR("(AEKeyword theAEKeyword, DescType desiredType) -> (AEDesc result)")},
	{"AEPutAttributeDesc", (PyCFunction)AEDesc_AEPutAttributeDesc, 1,
	 PyDoc_STR("(AEKeyword theAEKeyword, AEDesc theAEDesc) -> None")},
	{"AESendMessage", (PyCFunction)AEDesc_AESendMessage, 1,
	 PyDoc_STR("(AESendMode sendMode, long timeOutInTicks) -> (AppleEvent reply)")},
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
			if ( (res = PyString_FromStringAndSize(NULL, size)) == NULL )
				return NULL;
			if ( (ptr = PyString_AsString(res)) == NULL )
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


#define AEDesc_compare NULL

#define AEDesc_repr NULL

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
	PyObject_HEAD_INIT(NULL)
	0, /*ob_size*/
	"aem.ae.AEDesc", /*tp_name*/
	sizeof(AEDescObject), /*tp_basicsize*/
	0, /*tp_itemsize*/
	/* methods */
	(destructor) AEDesc_dealloc, /*tp_dealloc*/
	0, /*tp_print*/
	(getattrfunc)0, /*tp_getattr*/
	(setattrfunc)0, /*tp_setattr*/
	(cmpfunc) AEDesc_compare, /*tp_compare*/
	(reprfunc) AEDesc_repr, /*tp_repr*/
	(PyNumberMethods *)0, /* tp_as_number */
	(PySequenceMethods *)0, /* tp_as_sequence */
	(PyMappingMethods *)0, /* tp_as_mapping */
	(hashfunc) AEDesc_hash, /*tp_hash*/
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
	char *factoringPtr__in__;
	long factoringPtr__len__;
	int factoringPtr__in_len__;
	Boolean isRecord;
	AEDescList resultList;

	if (!PyArg_ParseTuple(_args, "s#b",
	                      &factoringPtr__in__, &factoringPtr__in_len__,
	                      &isRecord))
		return NULL;
	factoringPtr__len__ = factoringPtr__in_len__;
	_err = AECreateList(factoringPtr__in__, factoringPtr__len__,
	                    isRecord,
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
	AEEventHandlerUPP handler__proc__ = upp_GenericEventHandler;
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
	_res = Py_BuildValue("O",
	                     handler);
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
	AECoercionHandlerUPP handler__proc__ = upp_GenericCoercionHandler;
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
	if (PyString_Check(v)) {
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

// TO DO: replace with code that doesn't start Python.app GUI

static int AE_GetFSRef(PyObject *v, FSRef *fsr)
{
        OSStatus err;

        if ( PyString_Check(v) || PyUnicode_Check(v)) {
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


static PyObject *AE_PIDForApplicationPath(PyObject* self, PyObject* args)
{
	ProcessSerialNumber psn = {0, kNoProcess};
	FSRef appRef, foundRef;
	pid_t pid;
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
	err = GetProcessPID(&psn, &pid);
	if (err) return AE_MacOSError(err);
	return Py_BuildValue("i", pid);
}


static PyObject *AE_LaunchApplication(PyObject* self, PyObject* args)
{
	FSRef appRef;
#if !defined(__LP64__)
	FSSpec appFSS;
#endif
	AppleEvent firstEvent;
	LaunchFlags flags;
	AEDesc paraDesc;
	Size paraSize;
	AppParametersPtr paraData;
	ProcessSerialNumber psn;
	LaunchParamBlockRec launchParams;
	pid_t pid;
	OSErr err = noErr;
	
	if (!PyArg_ParseTuple(args, "O&O&H", 
						  AE_GetFSRef, &appRef,
						  AE_AEDesc_Convert, &firstEvent,
						  &flags))
		return NULL;
#if !defined(__LP64__)
	err = FSGetCatalogInfo(&appRef, kFSCatInfoNone, NULL, NULL, &appFSS, NULL);
    if (err != noErr) return AE_MacOSError(err);
#endif
	err = AECoerceDesc(&firstEvent, typeAppParameters, &paraDesc);
	paraSize = AEGetDescDataSize(&paraDesc);
    paraData = (AppParametersPtr)NewPtr(paraSize);
    if (paraData == NULL) return AE_MacOSError(memFullErr);
    err = AEGetDescData(&paraDesc, paraData, paraSize);
    if (err != noErr) return AE_MacOSError(err);
	launchParams.launchBlockID = extendedBlock;
	launchParams.launchEPBLength = extendedBlockLen;
	launchParams.launchFileFlags = 0;
	launchParams.launchControlFlags = flags;
#if defined(__LP64__)
	launchParams.launchAppRef = &appRef;
#else
	launchParams.launchAppSpec = &appFSS;
#endif
	launchParams.launchAppParameters = paraData;
	err = LaunchApplication(&launchParams);
	if (err != noErr) return AE_MacOSError(err);
	psn = launchParams.launchProcessSN;
	err = GetProcessPID(&psn, &pid);
	if (err) return AE_MacOSError(err);
	return Py_BuildValue("i", pid);
}


// only needed for checking pid exists
static PyObject *AE_IsValidPID(PyObject *_self, PyObject *_args)
{
	OSStatus _err = noErr;
	int pid;
	ProcessSerialNumber psn = {0, kNoProcess};
	
	if (!PyArg_ParseTuple(_args, "i", &pid))
		return NULL;
	_err = GetProcessForPID((pid_t)pid, &psn);
	return Py_BuildValue("b", (Boolean)(_err != noErr));
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
	
	if (OSACopyScriptingDefinition == NULL) {
		PyErr_SetString(PyExc_NotImplementedError,
						"CopyScriptingDefinition isn't available in OS X 10.3.");
		return NULL;
	}
	if (!PyArg_ParseTuple(args, "O&", AE_GetFSRef, &fsRef))
		return NULL;
	err = OSACopyScriptingDefinition(&fsRef, 0, &sdef);
	if (err) return AE_MacOSError(err);
	dataSize = CFDataGetLength(sdef);
	data = (char *)CFDataGetBytePtr(sdef);
	if (data != NULL) {
		res = PyString_FromStringAndSize(data, dataSize);
	} else {
		data = malloc(dataSize);
		CFDataGetBytes(sdef, CFRangeMake(0, dataSize), (UInt8 *)data);
		res = PyString_FromStringAndSize(data, dataSize);
		free(data);
	}
	CFRelease(sdef);
	return res;
}

static PyObject *AE_GetAppTerminology(PyObject* self, PyObject* args)
{
#if defined(__LP64__)
	PyErr_SetString(PyExc_NotImplementedError,
					"GetAppTerminology isn't available in 64-bit processes.");
	return NULL;
#else
	static ComponentInstance defaultComponent;
	FSRef fsRef;
	FSSpec fss;
	AEDesc theDesc;
	Boolean didLaunch;
	OSAError err;
	
	if (!PyArg_ParseTuple(args, "O&", AE_GetFSRef, &fsRef))
		return NULL;
	err = FSGetCatalogInfo(&fsRef, kFSCatInfoNone, NULL, NULL, &fss, NULL);
    if (err != noErr) return AE_MacOSError(err);
	if (!defaultComponent) {
		defaultComponent = OpenDefaultComponent(kOSAComponentType, 'ascr');
		err = GetComponentInstanceError(defaultComponent);
		if (err) return AE_MacOSError(err);
	}
	err = OSAGetAppTerminology(defaultComponent, 
							   kOSAModeNull,
							   &fss, 
							   0, 
							   &didLaunch, 
							   &theDesc);
	if (err) return AE_MacOSError(err);
	return BuildTerminologyList(&theDesc, typeAETE);
#endif
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
	{"AEUnflattenDesc", (PyCFunction)AE_AEUnflattenDesc, 1,
	 PyDoc_STR("(Buffer data) -> (AEDesc result)")},
	{"AECreateDesc", (PyCFunction)AE_AECreateDesc, 1,
	 PyDoc_STR("(DescType typeCode, Buffer dataPtr) -> (AEDesc result)")},
	{"AECreateList", (PyCFunction)AE_AECreateList, 1,
	 PyDoc_STR("(Buffer factoringPtr, Boolean isRecord) -> (AEDescList resultList)")},
	{"AECreateAppleEvent", (PyCFunction)AE_AECreateAppleEvent, 1,
	 PyDoc_STR("(AEEventClass theAEEventClass, AEEventID theAEEventID, AEAddressDesc target, AEReturnID returnID, AETransactionID transactionID) -> (AppleEvent result)")},
	 
	{"AEInstallEventHandler", (PyCFunction)AE_AEInstallEventHandler, 1,
	 PyDoc_STR("(AEEventClass theAEEventClass, AEEventID theAEEventID, EventHandler handler) -> None")},
	{"AERemoveEventHandler", (PyCFunction)AE_AERemoveEventHandler, 1,
	 PyDoc_STR("(AEEventClass theAEEventClass, AEEventID theAEEventID) -> None")},
	{"AEGetEventHandler", (PyCFunction)AE_AEGetEventHandler, 1,
	 PyDoc_STR("(AEEventClass theAEEventClass, AEEventID theAEEventID) -> (EventHandler handler)")},
	{"AEInstallCoercionHandler", (PyCFunction)AE_AEInstallCoercionHandler, 1,
	 PyDoc_STR("(DescType fromType, DescType toType, CoercionHandler handler) -> None")},
	{"AERemoveCoercionHandler", (PyCFunction)AE_AERemoveCoercionHandler, 1,
	 PyDoc_STR("(DescType fromType, DescType toType) -> None")},
	{"AEGetCoercionHandler", (PyCFunction)AE_AEGetCoercionHandler, 1,
	 PyDoc_STR("(DescType fromType, DescType toType) -> (CoercionHandler handler, Boolean fromTypeIsDesc)")},
	 
  	{"ConvertPathToURL", (PyCFunction)AE_ConvertPathToURL, METH_VARARGS,
		PyDoc_STR("(utf8 path, CFURLPathStyle style) --> (utf8 url)")},
  	{"ConvertURLToPath", (PyCFunction)AE_ConvertURLToPath, METH_VARARGS,
		PyDoc_STR("(utf8 url, CFURLPathStyle style) --> (utf8 path)")},
	
	{"FindApplicationForInfo", (PyCFunction)AE_LSFindApplicationForInfo, 1,
		PyDoc_STR("(OSType inCreator, CFStringRef inBundleID, CFStringRef inName) -> (unicode outAppURL)")},
	 
	{"PIDForApplicationPath", AE_PIDForApplicationPath, METH_VARARGS,
		PyDoc_STR("(unicode path) --> (pid_t pid)")},
  	{"LaunchApplication", (PyCFunction)AE_LaunchApplication, METH_VARARGS,
		PyDoc_STR("(unicode path, AEDesc firstEvent, unsigned short flags) --> (pid_t pid)")},
  	{"IsValidPID", (PyCFunction)AE_IsValidPID, METH_VARARGS,
		PyDoc_STR("(pid_t pid) --> (Boolean result)")},
		
  	{"AddressDescToPath", (PyCFunction)AE_AddressDescToPath, METH_VARARGS,
		PyDoc_STR("(AEAddressDesc desc) --> (unicode path)")},

  	{"CopyScriptingDefinition", (PyCFunction) AE_CopyScriptingDefinition, METH_VARARGS,
		PyDoc_STR("(unicode path) --> (unicode sdef)")},
  	{"GetAppTerminology", (PyCFunction) AE_GetAppTerminology, METH_VARARGS, 
		PyDoc_STR("(unicode path) --> (AEDesc aete)")},
  	{"GetSysTerminology", (PyCFunction) AE_GetSysTerminology, METH_VARARGS,
		PyDoc_STR("(OSType subTypeCode) --> (AEDesc aeut)")},
	
	{NULL, NULL, 0}
};


AE_CAPI aeCAPI = {
	AE_AEDesc_New,
	AE_AEDesc_NewBorrowed,
	AE_AEDesc_Convert,
	AE_AEDesc_ConvertDisown,
	AE_GetMacOSErrorException, 
	AE_MacOSError, 
	AE_GetOSType, 
	AE_BuildOSType
};


void initae(void)
{
	PyObject *m, *d, *errClass;

	upp_GenericEventHandler = NewAEEventHandlerUPP(GenericEventHandler);
	upp_GenericCoercionHandler = NewAECoerceDescUPP(GenericCoercionHandler);

	m = Py_InitModule("ae", AE_methods);
	d = PyModule_GetDict(m);
	errClass = AE_GetMacOSErrorException();
	if (errClass == NULL ||
	    PyDict_SetItemString(d, "MacOSError", errClass) != 0)
		return;
	AEDesc_Type.ob_type = &PyType_Type;
	if (PyType_Ready(&AEDesc_Type) < 0) return;
	Py_INCREF(&AEDesc_Type);
	PyModule_AddObject(m, "AEDesc", (PyObject *)&AEDesc_Type);

	PyObject *aeCAPIObj = PyCObject_FromVoidPtr((void *)&aeCAPI, NULL);
	PyModule_AddObject(m, "aetoolbox", aeCAPIObj);
}

/* ========================= End module AE ========================= */

