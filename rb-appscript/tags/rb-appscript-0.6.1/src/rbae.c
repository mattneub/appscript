/*
 * rb-appscript
 *
 * ae -- a low-level API providing a basic Ruby wrapper around the various 
 *    Apple Event Manager, Process Manager and Launch Services APIs used by aem
 *
 *  Thanks to:
 *  - FUJIMOTO Hisakuni, author of RubyAEOSA
 *  - Jordan Breeding (64-bit support patch)
 */

#include "osx_ruby.h"
#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#include "SendThreadSafe.h"

// AE module and classes
static VALUE mAE;
static VALUE cAEDesc;
static VALUE cMacOSError;

// Note: AEDescs need extra wrapping to avoid nasty problems with Ruby's Data_Wrap_Struct.
struct rbAE_AEDescWrapper {
	AEDesc desc;
};

// (these two macros are basically cribbed from RubyAEOSA's aedesc.c)
#define AEDESC_DATA_PTR(o) ((struct rbAE_AEDescWrapper*)(DATA_PTR(o)))
#define AEDESC_OF(o) (AEDESC_DATA_PTR(o)->desc)

// Event handling
#if __LP64__
	// SRefCon typedefed as void * by system headers
#else
	typedef long SRefCon;
#endif

AEEventHandlerUPP upp_GenericEventHandler;
AECoercionHandlerUPP upp_GenericCoercionHandler;


// these macros were added in 1.8.6

#if !defined(RSTRING_LEN)
#define RSTRING_LEN(x) (RSTRING(x)->len)
#define RSTRING_PTR(x) (RSTRING(x)->ptr)
#endif


/**********************************************************************/
// Raise MacOS error

/*
 * Note: MacOSError should only be raised by AE module; attempting to raise it from Ruby
 * just results in unexpected errors. (I've not quite figured out how to implement an
 * Exception class in C that constructs correctly in both C and Ruby. Not serious, since
 * nobody else needs to raise MacOSErrors - just a bit irritating.)
 */ 

static void
rbAE_raiseMacOSError(const char *description, OSErr number)
{
	VALUE errObj;
	
	errObj = rb_funcall(cMacOSError, rb_intern("new"), 0);
	rb_iv_set(errObj, "@number", INT2NUM(number)); // returns the OS error number
	rb_iv_set(errObj, "@description", rb_str_new2(description)); // troubleshooting info
	rb_exc_raise(errObj);
}


/**********************************************************************/
// MacOSError methods

static VALUE
rbAE_MacOSError_inspect(VALUE self)
{
	char s[32];
	
	sprintf(s, "#<AE::MacOSError %li>", (long)NUM2INT(rb_iv_get(self, "@number")));
	return rb_str_new2(s);
}


/**********************************************************************/
// AEDesc support functions

static DescType
rbStringToDescType(VALUE obj)
{
	if (rb_obj_is_kind_of(obj, rb_cString) && RSTRING_LEN(obj) == 4) {
		return CFSwapInt32HostToBig(*(DescType *)(RSTRING_PTR(obj)));
	} else {
		rb_raise(rb_eArgError, "Not a four-char-code string.");
	}
}

static VALUE
rbDescTypeToString(DescType descType)
{
	char s[4];
	
	*(DescType*)s = CFSwapInt32HostToBig(descType);
	return rb_str_new(s, 4);
}

/*******/

static void
rbAE_freeAEDesc(struct rbAE_AEDescWrapper *p)
{
	AEDisposeDesc(&(p->desc));
	free(p);
}

static VALUE
rbAE_wrapAEDesc(const AEDesc *desc)
{
		struct rbAE_AEDescWrapper *wrapper;
		
		// Found out how to wrap AEDescs so Ruby wouldn't crash by reading RubyAEOSA's aedesc.c
		wrapper = malloc(sizeof(struct rbAE_AEDescWrapper));
		wrapper->desc = *desc;
		return Data_Wrap_Struct(cAEDesc, 0, rbAE_freeAEDesc, wrapper);
}

/*******/
// Note: clients should not attempt to use retain/use borrowed AE::AEDesc instances after handler callbacks return,
// as AEM will have disposed of the underlying AEDesc objects by then

static void
rbAE_freeBorrowedAEDesc(struct rbAE_AEDescWrapper *p)
{
	free(p);
}

static VALUE
rbAE_wrapBorrowedAEDesc(const AEDesc *desc)
{
		struct rbAE_AEDescWrapper *wrapper;
		
		wrapper = malloc(sizeof(struct rbAE_AEDescWrapper));
		wrapper->desc = *desc;
		return Data_Wrap_Struct(cAEDesc, 0, rbAE_freeBorrowedAEDesc, wrapper);
}

/**********************************************************************/
// AEDesc constructors

static VALUE
rbAE_AEDesc_new(VALUE class, VALUE type, VALUE data)
{
	OSErr err = noErr;
	AEDesc desc;
	
	Check_Type(data, T_STRING);
	err = AECreateDesc(rbStringToDescType(type),
					   RSTRING_PTR(data), RSTRING_LEN(data),
					   &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AEDesc.", err);
	return rbAE_wrapAEDesc(&desc);
}


static VALUE
rbAE_AEDesc_newList(VALUE class, VALUE isRecord)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AECreateList(NULL, 0, RTEST(isRecord), &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AEDescList.", err);
	return rbAE_wrapAEDesc(&desc);
}


static VALUE
rbAE_AEDesc_newAppleEvent(VALUE class, VALUE eventClassValue, VALUE eventIDValue, 
		VALUE targetValue, VALUE returnIDValue, VALUE transactionIDValue)
{
	OSErr err = noErr;
	AEEventClass theAEEventClass = rbStringToDescType(eventClassValue);
	AEEventID theAEEventID = rbStringToDescType(eventIDValue);
	AEAddressDesc target = AEDESC_OF(targetValue);
	AEReturnID returnID = NUM2INT(returnIDValue);
	AETransactionID transactionID = NUM2LONG(transactionIDValue);
	AppleEvent result;
	
	err = AECreateAppleEvent(theAEEventClass, 
							 theAEEventID,
							 &target,
							 returnID, 
							 transactionID,
							 &result);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AppleEvent.", err);
	// workaround for return ID bug in 10.6
	AEDesc returnIDDesc;
	if (returnID == kAutoGenerateReturnID) {
		err = AEGetAttributeDesc(&result, keyReturnIDAttr, typeSInt32, &returnIDDesc);
		if (err != noErr) rbAE_raiseMacOSError("Can't create AppleEvent.", err);
		err = AEGetDescData(&returnIDDesc, &returnID, sizeof(returnID));
		if (err != noErr) rbAE_raiseMacOSError("Can't create AppleEvent.", err);
		if (returnID == -1) {
			AEDisposeDesc(&result);
			err = AECreateAppleEvent(theAEEventClass,
						  theAEEventID,
						  &target,
						  returnID,
						  transactionID,
						  &result);
			if (err != noErr) rbAE_raiseMacOSError("Can't create AppleEvent.", err);
		}
	}
	return rbAE_wrapAEDesc(&result);
}


static VALUE
rbAE_AEDesc_newUnflatten(VALUE class, VALUE data)
{
	OSErr err = noErr;
	AEDesc desc;
	
	Check_Type(data, T_STRING);
	err = AEUnflattenDesc(RSTRING_PTR(data), &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AEDesc.", err);
	return rbAE_wrapAEDesc(&desc);
}


/**********************************************************************/
// AEDesc methods

static VALUE
rbAE_AEDesc_inspect(VALUE self)
{
	VALUE s, type;
	Size dataSize;
	
	s = rb_str_new2("#<AE::AEDesc type=%s size=%i>");
	type = rb_funcall(self, rb_intern("type"), 0);
	dataSize = AEGetDescDataSize(&(AEDESC_OF(self)));
	return rb_funcall(s, 
					  rb_intern("%"), 
					  1,
					  rb_ary_new3(2, 
								  rb_funcall(type, rb_intern("inspect"), 0),
								  INT2NUM(dataSize)
					  )
	);
}


/*******/

static VALUE
rbAE_AEDesc_type(VALUE self)
{	
	return rbDescTypeToString(AEDESC_OF(self).descriptorType);
}


static VALUE
rbAE_AEDesc_data(VALUE self)
{
	OSErr err = noErr;
	Size dataSize;
	void *data;
	VALUE result;
	
	dataSize = AEGetDescDataSize(&(AEDESC_OF(self)));
	data = malloc(dataSize);
	err = AEGetDescData(&(AEDESC_OF(self)), data, dataSize);
	if (err != noErr) rbAE_raiseMacOSError("Can't get AEDesc data.", err);
	result = rb_str_new(data, dataSize);
	free(data);
	return result;
}


static VALUE
rbAE_AEDesc_flatten(VALUE self)
{
	OSErr err = noErr;
	Size dataSize;
	void *data;
	VALUE result;
	
	dataSize = AESizeOfFlattenedDesc(&(AEDESC_OF(self)));
	data = malloc(dataSize);
	err = AEFlattenDesc(&(AEDESC_OF(self)), data, dataSize, NULL);
	if (err != noErr) rbAE_raiseMacOSError("Can't flatten AEDesc.", err);
	result = rb_str_new(data, dataSize);
	free(data);
	return result;
}


/*******/

static VALUE
rbAE_AEDesc_isRecord(VALUE self)
{
	return AECheckIsRecord(&(AEDESC_OF(self))) ? Qtrue : Qfalse;
}


static VALUE
rbAE_AEDesc_coerce(VALUE self, VALUE type)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AECoerceDesc(&(AEDESC_OF(self)), rbStringToDescType(type), &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't coerce AEDesc.", err);
	return rbAE_wrapAEDesc(&desc);
}


static VALUE
rbAE_AEDesc_length(VALUE self)
{
	OSErr err = noErr;
	long length;
	
	err = AECountItems(&(AEDESC_OF(self)), &length);
	if (err != noErr) rbAE_raiseMacOSError("Can't get length of AEDesc.", err);
	return INT2NUM(length);
}


/*******/

static VALUE
rbAE_AEDesc_putItem(VALUE self, VALUE index, VALUE desc)
{
	OSErr err = noErr;
	
	if (rb_obj_is_instance_of(desc, cAEDesc) == Qfalse)
			rb_raise(rb_eTypeError, "Can't put non-AEDesc item into AEDesc.");
	err = AEPutDesc(&(AEDESC_OF(self)), NUM2LONG(index), &(AEDESC_OF(desc)));
	if (err != noErr) rbAE_raiseMacOSError("Can't put item into AEDesc.", err);
	return Qnil;
}


static VALUE
rbAE_AEDesc_putParam(VALUE self, VALUE key, VALUE desc)
{
	OSErr err = noErr;
	
	if (rb_obj_is_instance_of(desc, cAEDesc) == Qfalse)
			rb_raise(rb_eTypeError, "Can't put non-AEDesc parameter into AEDesc.");
	err = AEPutParamDesc(&(AEDESC_OF(self)), rbStringToDescType(key), &(AEDESC_OF(desc)));
	if (err != noErr) rbAE_raiseMacOSError("Can't put parameter into AEDesc.", err);
	return Qnil;
}


static VALUE
rbAE_AEDesc_putAttr(VALUE self, VALUE key, VALUE desc)
{
	OSErr err = noErr;
	
	if (rb_obj_is_instance_of(desc, cAEDesc) == Qfalse)
			rb_raise(rb_eTypeError, "Can't put non-AEDesc attribute into AEDesc.");
	err = AEPutAttributeDesc(&(AEDESC_OF(self)), rbStringToDescType(key), &(AEDESC_OF(desc)));
	if (err != noErr) rbAE_raiseMacOSError("Can't put attribute into AEDesc.", err);
	return Qnil;
}


/*******/

static VALUE
rbAE_AEDesc_getItem(VALUE self, VALUE index, VALUE type)
{
	OSErr err = noErr;
	AEKeyword key;
	AEDesc desc;
	
	err = AEGetNthDesc(&(AEDESC_OF(self)),
					   NUM2LONG(index),
					   rbStringToDescType(type),
					   &key,
					   &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't get item from AEDesc.", err);
	return rb_ary_new3(2,
					   rbDescTypeToString(key),
					   rbAE_wrapAEDesc(&desc));
}


static VALUE
rbAE_AEDesc_getParam(VALUE self, VALUE key, VALUE type)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AEGetParamDesc(&(AEDESC_OF(self)),
						 rbStringToDescType(key),
						 rbStringToDescType(type),
						 &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't get parameter from AEDesc.", err);
	return rbAE_wrapAEDesc(&desc);
}


static VALUE
rbAE_AEDesc_getAttr(VALUE self, VALUE key, VALUE type)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AEGetAttributeDesc(&(AEDESC_OF(self)),
							 rbStringToDescType(key),
							 rbStringToDescType(type),
							 &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't get attribute from AEDesc.", err);
	return rbAE_wrapAEDesc(&desc);
}


/*******/

static VALUE
rbAE_AEDesc_send(VALUE self, VALUE sendMode, VALUE timeout)
{
	OSErr err = noErr;
	AppleEvent reply;
	
	err = AESendMessage(&(AEDESC_OF(self)),
						&reply,
						(AESendMode)NUM2LONG(sendMode),
						NUM2LONG(timeout));
	if (err != noErr) rbAE_raiseMacOSError("Can't send Apple event.", err);
	return rbAE_wrapAEDesc(&reply);
}

static VALUE
rbAE_AEDesc_sendThreadSafe(VALUE self, VALUE sendMode, VALUE timeout)
{
	OSErr err = noErr;
	AppleEvent reply;
	
	err = SendMessageThreadSafe(&(AEDESC_OF(self)),
								&reply,
								(AESendMode)NUM2LONG(sendMode),
								NUM2LONG(timeout));
	if (err != noErr) rbAE_raiseMacOSError("Can't send Apple event.", err);
	return rbAE_wrapAEDesc(&reply);
}


/**********************************************************************/
// Find and launch applications

static VALUE
rbAE_findApplication(VALUE self, VALUE creator, VALUE bundleID, VALUE name)
{
	OSStatus err = 0;
	
	OSType inCreator;
	CFStringRef inName;
	CFStringRef inBundleID;
	FSRef outAppRef;
	UInt8 path[PATH_MAX];
	
	inCreator = (creator == Qnil) ? kLSUnknownCreator : rbStringToDescType(creator);
	if (bundleID != Qnil) {
		inBundleID = CFStringCreateWithBytes(NULL,
											 (UInt8 *)(RSTRING_PTR(bundleID)),
											 (CFIndex)(RSTRING_LEN(bundleID)),
											 kCFStringEncodingUTF8,
											 false);
		if (inBundleID == NULL) rb_raise(rb_eRuntimeError, "Invalid bundle ID string.");
	} else {
		inBundleID = NULL;
	}
	if (name != Qnil) {
		inName = CFStringCreateWithBytes(NULL,
										 (UInt8 *)(RSTRING_PTR(name)),
										 (CFIndex)(RSTRING_LEN(name)),
										 kCFStringEncodingUTF8,
										 false);
		if (inName == NULL) {
			if (inBundleID != NULL) CFRelease(inBundleID);
			rb_raise(rb_eRuntimeError, "Invalid name string.");
		}
	} else {
		inName = NULL;
	}
	err = LSFindApplicationForInfo(inCreator,
								   inBundleID,
								   inName,
								   &outAppRef,
								   NULL);
	if (inBundleID != NULL) CFRelease(inBundleID);
	if (inName != NULL) CFRelease(inName);
	if (err != 0) rbAE_raiseMacOSError("Couldn't find application.", err);
	err = FSRefMakePath(&outAppRef, path, PATH_MAX);
	if (err != 0) rbAE_raiseMacOSError("Couldn't get application path.", err);
	return rb_str_new2((char *)path);
}


static VALUE
rbAE_psnForApplicationPath(VALUE self, VALUE path)
{
	OSStatus err = noErr;
	ProcessSerialNumber psn = {0, kNoProcess};
	FSRef appRef, foundRef;

	err = FSPathMakeRef((UInt8 *)StringValuePtr(path), &appRef, NULL);
	if (err != 0) rbAE_raiseMacOSError("Couldn't make FSRef for application.", err);
	while (1) {
		err = GetNextProcess(&psn);
		if (err != 0) rbAE_raiseMacOSError("Can't get next process.", err); // -600 if no more processes left
		err = GetProcessBundleLocation(&psn, &foundRef);
		if (err != 0) continue;
		if (FSCompareFSRefs(&appRef, &foundRef) == noErr) 
				return rb_ary_new3(2, INT2NUM(psn.highLongOfPSN), INT2NUM(psn.lowLongOfPSN));
	}
}


static VALUE
rbAE_psnForPID(VALUE self, VALUE pid)
{
	OSStatus err = noErr;
	ProcessSerialNumber psn = {0, kNoProcess};

	err = GetProcessForPID(NUM2INT(pid), &psn);
	if (err != 0) rbAE_raiseMacOSError("Can't get next process.", err); // -600 if process not found
	return rb_ary_new3(2, INT2NUM(psn.highLongOfPSN), INT2NUM(psn.lowLongOfPSN));
}


static VALUE
rbAE_launchApplication(VALUE self, VALUE path, VALUE firstEvent, VALUE flags)
{
	FSRef appRef;
	ProcessSerialNumber psn;
	OSStatus err = noErr;
	
	err = FSPathMakeRef((UInt8 *)StringValuePtr(path), &appRef, NULL);
	if (err != noErr) rbAE_raiseMacOSError("Couldn't make FSRef for application.", err);
	LSApplicationParameters appParams = {0, 
										 (LSLaunchFlags)NUM2UINT(flags), 
										 &appRef, 
										 NULL, NULL, NULL, 
										 &(AEDESC_OF(firstEvent))};
	err = LSOpenApplication(&appParams, &psn);
	if (err != noErr) rbAE_raiseMacOSError("Can't launch application.", err);
	return rb_ary_new3(2, INT2NUM(psn.highLongOfPSN), INT2NUM(psn.lowLongOfPSN));
}

/**********************************************************************/
// HFS/POSIX path conversions

static VALUE
rbAE_convertPathToURL(VALUE self, VALUE path, VALUE pathStyle)
{
	CFStringRef str;
	CFURLRef url;
	UInt8 buffer[PATH_MAX];
	
	str = CFStringCreateWithBytes(NULL,
								  (UInt8 *)(RSTRING_PTR(path)),
								  (CFIndex)(RSTRING_LEN(path)),
								  kCFStringEncodingUTF8,
								  false);
	if (str == NULL) rb_raise(rb_eRuntimeError, "Bad path string.");
	url = CFURLCreateWithFileSystemPath(NULL,
										str,
										NUM2LONG(pathStyle),
										false);
	CFRelease(str);
	if (url == NULL) rb_raise(rb_eRuntimeError, "Invalid path.");
	buffer[CFURLGetBytes(url, buffer, PATH_MAX - 1)] = '\0';
	CFRelease(url);
	return rb_str_new2((char *)buffer);
}

static VALUE
rbAE_convertURLToPath(VALUE self, VALUE urlStr, VALUE pathStyle)
{
	Boolean err;
	CFURLRef url;
	CFStringRef str;
	char buffer[PATH_MAX];

	url = CFURLCreateWithBytes(NULL,
							   (UInt8 *)(RSTRING_PTR(urlStr)),
							   (CFIndex)(RSTRING_LEN(urlStr)),
							   kCFStringEncodingUTF8,
							   NULL);
	if (url == NULL) rb_raise(rb_eRuntimeError, "Bad URL string.");
	str = CFURLCopyFileSystemPath(url, NUM2LONG(pathStyle));
	CFRelease(url);
	if (str == NULL) rb_raise(rb_eRuntimeError, "Can't get path.");
	err = CFStringGetCString(str,
							 buffer,
							 PATH_MAX,
							 kCFStringEncodingUTF8);
	CFRelease(str);
	if (!err) rb_raise(rb_eRuntimeError, "Can't get path.");
	return rb_str_new2(buffer);
}


/**********************************************************************/
// Date conversion

static VALUE
rbAE_convertLongDateTimeToString(VALUE self, VALUE ldt)
{
	Boolean bErr;
	OSStatus err = 0;
	CFAbsoluteTime cfTime;
	CFDateFormatterRef formatter;
	CFStringRef str;
	char buffer[20]; // size of format string + nul
	
	err = UCConvertLongDateTimeToCFAbsoluteTime(NUM2LL(ldt), &cfTime);
	if (err != noErr) rbAE_raiseMacOSError("Can't convert LongDateTime to seconds.", err);
	formatter = CFDateFormatterCreate(NULL, NULL,  kCFDateFormatterNoStyle,  kCFDateFormatterNoStyle);
	if (!formatter) rbAE_raiseMacOSError("Can't create date formatter.", err);
	CFDateFormatterSetFormat(formatter, CFSTR("yyyy-MM-dd HH:mm:ss"));
	str = CFDateFormatterCreateStringWithAbsoluteTime(NULL, formatter, cfTime);
	CFRelease(formatter);
	if (!str) rbAE_raiseMacOSError("Can't create date string.", err);
	bErr = CFStringGetCString(str,
							 buffer,
							 sizeof(buffer),
							 kCFStringEncodingUTF8);
	CFRelease(str);
	if (!bErr) rb_raise(rb_eRuntimeError, "Can't convert date string.");
	return rb_str_new2(buffer);
}


static VALUE
rbAE_convertStringToLongDateTime(VALUE self, VALUE datetime)
{
	CFStringRef str;
	CFAbsoluteTime cfTime;
	CFDateFormatterRef formatter;
	OSStatus err = 0;
	Boolean bErr;
	SInt64 ldt;
	
	str = CFStringCreateWithBytes(NULL,
								  (UInt8 *)(RSTRING_PTR(datetime)),
								  (CFIndex)(RSTRING_LEN(datetime)),
								  kCFStringEncodingUTF8,
								  false);
	if (str == NULL || CFStringGetLength(str) != 19) rb_raise(rb_eRuntimeError, "Bad datetime string.");
	formatter = CFDateFormatterCreate(NULL, NULL,  kCFDateFormatterNoStyle,  kCFDateFormatterNoStyle);
	if (!formatter) rbAE_raiseMacOSError("Can't create date formatter.", err);
	CFDateFormatterSetFormat(formatter, CFSTR("yyyy-MM-dd HH:mm:ss"));
	bErr = CFDateFormatterGetAbsoluteTimeFromString(formatter, str, NULL, &cfTime);
	CFRelease(formatter);
	CFRelease(str);
	if (!bErr) rb_raise(rb_eRuntimeError, "Can't convert date string.");
	err = UCConvertCFAbsoluteTimeToLongDateTime(cfTime, &ldt);
	if (err != noErr) rbAE_raiseMacOSError("Can't convert seconds to LongDateTime.", err);
	return LL2NUM(ldt);
}


static VALUE
rbAE_convertLongDateTimeToUnixSeconds(VALUE self, VALUE ldt)
{
	OSStatus err = 0;
	CFAbsoluteTime cfTime;
	
	err = UCConvertLongDateTimeToCFAbsoluteTime(NUM2LL(ldt), &cfTime);
	if (err != noErr) rbAE_raiseMacOSError("Can't convert LongDateTime to seconds.", err);
	return rb_float_new(cfTime + kCFAbsoluteTimeIntervalSince1970);
}


static VALUE
rbAE_convertUnixSecondsToLongDateTime(VALUE self, VALUE secs)
{
	OSStatus err = 0;
	SInt64 ldt;

	err = UCConvertCFAbsoluteTimeToLongDateTime(NUM2DBL(secs) - kCFAbsoluteTimeIntervalSince1970, &ldt);
	if (err != noErr) rbAE_raiseMacOSError("Can't convert seconds to LongDateTime.", err);
	return LL2NUM(ldt);
}


/**********************************************************************/
// Get aete

static VALUE
rbAE_OSACopyScriptingDefinition(VALUE self, VALUE path)
{
	FSRef fsRef;
	CFDataRef sdef;
	CFIndex dataSize;
	char *data;
	VALUE res;
	OSErr err = noErr;
	
	err = FSPathMakeRef((UInt8 *)StringValuePtr(path), &fsRef, NULL);
	if (err != 0) rbAE_raiseMacOSError("Couldn't make FSRef for path.", err);
	err = OSACopyScriptingDefinition(&fsRef, 0, &sdef);
	if (err) rbAE_raiseMacOSError("Couldn't get sdef.", err);
	dataSize = CFDataGetLength(sdef);
	data = (char *)CFDataGetBytePtr(sdef);
	if (data != NULL) {
		res = rb_str_new(data, dataSize);
	} else {
		data = malloc(dataSize);
		CFDataGetBytes(sdef, CFRangeMake(0, dataSize), (UInt8 *)data);
		res = rb_str_new(data, dataSize);
		free(data);
	}
	CFRelease(sdef);
	return res;
}


/**********************************************************************/
// Install event handlers

// Based on Python's CarbonX.AE extension

static pascal OSErr
rbAE_GenericEventHandler(const AppleEvent *request, AppleEvent *reply, SRefCon refcon)
{
	VALUE err;
	
	err = rb_funcall((VALUE)refcon, 
					 rb_intern("handle_event"), 
					 2, 
					 rbAE_wrapBorrowedAEDesc(request),
					 rbAE_wrapBorrowedAEDesc(reply));
	return NUM2INT(err);
}

/*******/

static VALUE
rbAE_AEInstallEventHandler(VALUE self, VALUE eventClass, VALUE eventID, SRefCon handler)
{
	/* 
	 * eventClass and eventID must be four-character code strings
	 *
	 * handler must be a Ruby object containing a method named 'handle_event' that takes two
	 * AppleEvent descriptors (request and reply) as arguments, and returns an integer.
	 * Note that this object is responsible for trapping any unhandled exceptions and returning
	 * an OS error number as appropriate (or 0 if no error), otherwise the program will exit.
	 */
	OSErr err = noErr;
	
	err = AEInstallEventHandler(rbStringToDescType(eventClass),
								rbStringToDescType(eventID),
	                            upp_GenericEventHandler, handler,
	                            0);
	if (err != noErr) rbAE_raiseMacOSError("Can't install event handler.", err);
	return Qnil;
}


static VALUE
rbAE_AERemoveEventHandler(VALUE self, VALUE eventClass, VALUE eventID)
{
	OSErr err = noErr;
	
	err = AERemoveEventHandler(rbStringToDescType(eventClass),
							   rbStringToDescType(eventID),
							   upp_GenericEventHandler,
							   0);
	if (err != noErr) rbAE_raiseMacOSError("Can't remove event handler.", err);
	return Qnil;
}


static VALUE
rbAE_AEGetEventHandler(VALUE self, VALUE eventClass, VALUE eventID)
{
	OSErr err = noErr;
	AEEventHandlerUPP handlerUPP;
	SRefCon handler;
	
	err = AEGetEventHandler(rbStringToDescType(eventClass),
							 rbStringToDescType(eventID),
	                         &handlerUPP, &handler,
	                         0);
	if (err != noErr) rbAE_raiseMacOSError("Can't get event handler.", err);
	return (VALUE)handler;
}


/**********************************************************************/
// Install coercion handlers

static pascal OSErr
rbAE_GenericCoercionHandler(const AEDesc *fromDesc, DescType toType, SRefCon refcon, AEDesc *toDesc)
{
	// handle_coercion method should return an AE::AEDesc, or nil if an error occurred
	OSErr err = noErr;
	VALUE res;
	
	res = rb_funcall((VALUE)refcon, 
					 rb_intern("handle_coercion"),
					 2,
					 rbAE_wrapBorrowedAEDesc(fromDesc),
					 rbDescTypeToString(toType));
	if (rb_obj_is_instance_of(res, cAEDesc) != Qtrue) return errAECoercionFail;
	err = AEDuplicateDesc(&AEDESC_OF(res), toDesc);
	return err;
}


/*******/

static VALUE
rbAE_AEInstallCoercionHandler(VALUE self, VALUE fromType, VALUE toType, SRefCon handler)
{
	/* 
	 * fromType and toType must be four-character code strings
	 *
	 * handler must be a Ruby object containing a method named 'handle_coercion' that takes an
	 * AEDesc and a four-character code (original value, desired type) as arguments, and returns an
	 * AEDesc of the desired type.Note that this object is responsible for trapping any unhandled 
	 * exceptions and returning nil (or any other non-AEDesc value) as appropriate, otherwise the 
	 * program will exit.
	 */
	OSErr err = noErr;
	
	err = AEInstallCoercionHandler(rbStringToDescType(fromType),
								   rbStringToDescType(toType),
								   upp_GenericCoercionHandler, handler,
								   1, 0);
	if (err != noErr) rbAE_raiseMacOSError("Can't install coercion handler.", err);
	return Qnil;
}


static VALUE
rbAE_AERemoveCoercionHandler(VALUE self, VALUE fromType, VALUE toType)
{
	OSErr err = noErr;
	
	err = AERemoveCoercionHandler(rbStringToDescType(fromType),
								  rbStringToDescType(toType),
								  upp_GenericCoercionHandler,
								  0);
	if (err != noErr) rbAE_raiseMacOSError("Can't remove coercion handler.", err);
	return Qnil;
}


static VALUE
rbAE_AEGetCoercionHandler(VALUE self, VALUE fromType, VALUE toType)
{
	OSErr err = noErr;
	AECoercionHandlerUPP handlerUPP;
	SRefCon handler;
	Boolean fromTypeIsDesc;
	
	err = AEGetCoercionHandler(rbStringToDescType(fromType),
							   rbStringToDescType(toType),
							   &handlerUPP, &handler,
							   &fromTypeIsDesc,
							   0);
	if (err != noErr) rbAE_raiseMacOSError("Can't get coercion handler.", err);
	return rb_ary_new3(2, handler, fromTypeIsDesc ? Qtrue : Qfalse);
}



		
/**********************************************************************/
// Process management
static VALUE
rbAE_transformProcessToForegroundApplication(VALUE self)
{
	OSStatus err = 0;
	ProcessSerialNumber psn = {0, kCurrentProcess};
	
	err = TransformProcessType(& psn, kProcessTransformToForegroundApplication);
	if( err != 0) rbAE_raiseMacOSError("Can't transform process.", err);
	return Qnil;
}

		
/**********************************************************************/
// Initialisation

void
Init_ae (void)
{

	mAE = rb_define_module("AE");

	// AE::AEDesc
	
	cAEDesc = rb_define_class_under(mAE, "AEDesc", rb_cObject);
	
	rb_define_singleton_method(cAEDesc, "new", rbAE_AEDesc_new, 2);
	rb_define_singleton_method(cAEDesc, "new_list", rbAE_AEDesc_newList, 1);
	rb_define_singleton_method(cAEDesc, "new_apple_event", rbAE_AEDesc_newAppleEvent, 5);
	rb_define_singleton_method(cAEDesc, "unflatten", rbAE_AEDesc_newUnflatten, 1);
	
	rb_define_method(cAEDesc, "to_s", rbAE_AEDesc_inspect, 0);
	rb_define_method(cAEDesc, "inspect", rbAE_AEDesc_inspect, 0);
	rb_define_method(cAEDesc, "type", rbAE_AEDesc_type, 0);
	rb_define_method(cAEDesc, "data", rbAE_AEDesc_data, 0);
	rb_define_method(cAEDesc, "flatten", rbAE_AEDesc_flatten, 0);
	rb_define_method(cAEDesc, "is_record?", rbAE_AEDesc_isRecord, 0);
	rb_define_method(cAEDesc, "coerce", rbAE_AEDesc_coerce, 1);
	rb_define_method(cAEDesc, "length", rbAE_AEDesc_length, 0);
	rb_define_method(cAEDesc, "put_item", rbAE_AEDesc_putItem, 2);
	rb_define_method(cAEDesc, "put_param", rbAE_AEDesc_putParam, 2);
	rb_define_method(cAEDesc, "put_attr", rbAE_AEDesc_putAttr, 2);
	rb_define_method(cAEDesc, "get_item", rbAE_AEDesc_getItem, 2);
	rb_define_method(cAEDesc, "get_param", rbAE_AEDesc_getParam, 2);
	rb_define_method(cAEDesc, "get_attr", rbAE_AEDesc_getAttr, 2);
	rb_define_method(cAEDesc, "send", rbAE_AEDesc_send, 2);
	rb_define_method(cAEDesc, "send_thread_safe", rbAE_AEDesc_sendThreadSafe, 2);
	
	// AE::MacOSError
	
	cMacOSError = rb_define_class_under(mAE, "MacOSError", rb_eStandardError);
	
	rb_define_attr(cMacOSError, "number", Qtrue, Qfalse);
	rb_define_attr(cMacOSError, "description", Qtrue, Qfalse);
	
	rb_define_alias(cMacOSError, "to_i", "number");
	
	rb_define_method(cMacOSError, "to_s", rbAE_MacOSError_inspect, 0);
	rb_define_method(cMacOSError, "inspect", rbAE_MacOSError_inspect, 0);

	// Support functions
	
	rb_define_module_function(mAE, "find_application", rbAE_findApplication, 3);
	rb_define_module_function(mAE, "psn_for_application_path", rbAE_psnForApplicationPath, 1);
	rb_define_module_function(mAE, "psn_for_process_id", rbAE_psnForPID, 1);
	rb_define_module_function(mAE, "launch_application", rbAE_launchApplication, 3);
	
	rb_define_module_function(mAE, "convert_path_to_url", 
							  rbAE_convertPathToURL, 2);
	rb_define_module_function(mAE, "convert_url_to_path", 
							  rbAE_convertURLToPath, 2);

	rb_define_module_function(mAE, "convert_long_date_time_to_string", 
							  rbAE_convertLongDateTimeToString, 1);
	rb_define_module_function(mAE, "convert_string_to_long_date_time", 
							  rbAE_convertStringToLongDateTime, 1);
	rb_define_module_function(mAE, "convert_long_date_time_to_unix_seconds", 
							  rbAE_convertLongDateTimeToUnixSeconds, 1);
	rb_define_module_function(mAE, "convert_unix_seconds_to_long_date_time", 
							  rbAE_convertUnixSecondsToLongDateTime, 1);
							  
	rb_define_module_function(mAE, "copy_scripting_definition", rbAE_OSACopyScriptingDefinition, 1);
	
	// Event handling
	
	upp_GenericEventHandler = NewAEEventHandlerUPP(rbAE_GenericEventHandler);
	upp_GenericCoercionHandler = NewAECoerceDescUPP(rbAE_GenericCoercionHandler);
	
	rb_define_module_function(mAE, "install_event_handler", rbAE_AEInstallEventHandler, 3);
	rb_define_module_function(mAE, "remove_event_handler", rbAE_AERemoveEventHandler, 2);
	rb_define_module_function(mAE, "get_event_handler", rbAE_AEGetEventHandler, 2);
	
	rb_define_module_function(mAE, "install_coercion_handler", rbAE_AEInstallCoercionHandler, 3);
	rb_define_module_function(mAE, "remove_coercion_handler", rbAE_AERemoveCoercionHandler, 2);
	rb_define_module_function(mAE, "get_coercion_handler", rbAE_AEGetCoercionHandler, 2);
	
	rb_define_module_function(mAE, "transform_process_to_foreground_application", 
							  rbAE_transformProcessToForegroundApplication, 0);
}
