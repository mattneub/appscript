/*
 *  Copyright (C) 2006 HAS
 *
 *  Thanks to: FUJIMOTO Hisakuni, author of RubyAEOSA
 */

#include "osx_ruby.h"
#include <Carbon/Carbon.h>

VALUE rb_ll2big(LONG_LONG);

static VALUE mAE;
static VALUE cAEDesc;
static VALUE cMacOSError;

// Note: AEDescs need extra wrapping to avoid nasty problems with Ruby's Data_Wrap_Struct.
struct rbAE_AEDescWrapper {
	AEDesc desc;
};

// These two macros are from RubyAEOSA's aedesc.c
#define AEDESC_DATA_PTR(o) ((struct rbAE_AEDescWrapper*)(DATA_PTR(o)))
#define AEDESC_OF(o) (AEDESC_DATA_PTR(o)->desc)


/**********************************************************************/
// Raise MacOS error

static void
rbAE_raiseMacOSError(const char *description, OSErr number)
{
	VALUE errObj;
	
	errObj = rb_funcall(cMacOSError, rb_intern("new"), 0);
	rb_iv_set(errObj, "@to_i", INT2NUM(number)); // returns the OS error number
	rb_iv_set(errObj, "@description", rb_str_new2(description)); // troubleshooting info
	rb_exc_raise(errObj);
}


/**********************************************************************/
// MacOSError methods

static VALUE
rbAE_MacOSError_inspect(VALUE self)
{
	char s[32];
	
	sprintf(s, "#<AE::MacOSError %i>", NUM2INT(rb_iv_get(self, "@to_i")));
	return rb_str_new2(s);
}


/**********************************************************************/
// AEDesc support functions

static DescType
rbStringToDescType(VALUE obj)
{
	if (rb_obj_is_kind_of(obj, rb_cString) && RSTRING(obj)->len == 4) {
		return CFSwapInt32HostToBig(*(DescType *)(RSTRING(obj)->ptr));
	} else {
		rb_raise(rb_eArgError, "Not a four-char-code string.");
	}
}

static void
rbAE_freeAEDesc(struct rbAE_AEDescWrapper *p)
{
	AEDisposeDesc(&(p->desc));
	free(p);
}

static VALUE
rbAE_wrapAEDesc(VALUE class, const AEDesc *desc)
{
		struct rbAE_AEDescWrapper *wrapper;
		
		// Found out how to wrap AEDescs so Ruby wouldn't crash by reading RubyAEOSA's aedesc.c
		wrapper = malloc(sizeof(struct rbAE_AEDescWrapper));
		wrapper->desc = *desc;
		return Data_Wrap_Struct(class, 0, rbAE_freeAEDesc, wrapper);
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
					   RSTRING(data)->ptr, RSTRING(data)->len,
					   &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AEDesc.", err);
	return rbAE_wrapAEDesc(class, &desc);
}


static VALUE
rbAE_AEDesc_newList(VALUE class, VALUE isRecord)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AECreateList(NULL, 0, RTEST(isRecord), &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AEDescList.", err);
	return rbAE_wrapAEDesc(class, &desc);
}


static VALUE
rbAE_AEDesc_newAppleEvent(VALUE class, VALUE eventClass, VALUE eventID, 
		VALUE target, VALUE returnID, VALUE transactionID)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AECreateAppleEvent(rbStringToDescType(eventClass), 
							 rbStringToDescType(eventID),
							 &(AEDESC_OF(target)),
							 NUM2INT(returnID), 
							 NUM2LONG(transactionID),
							 &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't create AppleEvent.", err);
	return rbAE_wrapAEDesc(class, &desc);
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
	char type[4];
	
	*(DescType*)type = CFSwapInt32HostToBig(AEDESC_OF(self).descriptorType);
	return rb_str_new(type, 4);
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


/*******/

static VALUE
rbAE_AEDesc_coerce(VALUE self, VALUE type)
{
	OSErr err = noErr;
	AEDesc desc;
	
	err = AECoerceDesc(&(AEDESC_OF(self)), rbStringToDescType(type), &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't coerce AEDesc.", err);
	return rbAE_wrapAEDesc(rb_funcall(self, rb_intern("class"), 0), &desc);
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


static VALUE
rbAE_AEDesc_putItem(VALUE self, VALUE index, VALUE desc)
{
	OSErr err = noErr;
	
	if (rb_obj_is_instance_of(desc, rb_funcall(self, rb_intern("class"), 0)) != Qtrue)
			rb_raise(rb_eTypeError, "Can't put parameter into AEDesc.");
	err = AEPutDesc(&(AEDESC_OF(self)), NUM2LONG(index), &(AEDESC_OF(desc)));
	if (err != noErr) rbAE_raiseMacOSError("Can't put item into AEDesc.", err);
	return Qnil;
}


static VALUE
rbAE_AEDesc_putParam(VALUE self, VALUE key, VALUE desc)
{
	OSErr err = noErr;
	
	if (rb_obj_is_instance_of(desc, rb_funcall(self, rb_intern("class"), 0)) != Qtrue)
			rb_raise(rb_eTypeError, "Can't put parameter into AEDesc.");
	err = AEPutParamDesc(&(AEDESC_OF(self)), rbStringToDescType(key), &(AEDESC_OF(desc)));
	if (err != noErr) rbAE_raiseMacOSError("Can't put parameter into AEDesc.", err);
	return Qnil;
}


static VALUE
rbAE_AEDesc_putAttr(VALUE self, VALUE key, VALUE desc)
{
	OSErr err = noErr;
	
	if (rb_obj_is_instance_of(desc, rb_funcall(self, rb_intern("class"), 0)) != Qtrue)
			rb_raise(rb_eTypeError, "Can't put parameter into AEDesc.");
	err = AEPutAttributeDesc(&(AEDESC_OF(self)), rbStringToDescType(key), &(AEDESC_OF(desc)));
	if (err != noErr) rbAE_raiseMacOSError("Can't put attribute into AEDesc.", err);
	return Qnil;
}


static VALUE
rbAE_AEDesc_get(VALUE self, VALUE index, VALUE type)
{
	OSErr err = noErr;
	AEKeyword key;
	AEDesc desc;
	char keyStr[4];
	
	// TO DO: this gives bus error if typeAEList and index = 0 (should be OSErr -1701); why?
	err = AEGetNthDesc(&(AEDESC_OF(self)),
					   NUM2LONG(index),
					   rbStringToDescType(type),
					   &key,
					   &desc);
	if (err != noErr) rbAE_raiseMacOSError("Can't get item from AEDesc.", err);
	*(DescType*)keyStr = CFSwapInt32HostToBig(key);
	return rb_ary_new3(2,
					   rb_str_new(keyStr, 4),
					   rbAE_wrapAEDesc(rb_funcall(self, rb_intern("class"), 0), &desc));
}


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
	return rbAE_wrapAEDesc(rb_funcall(self, rb_intern("class"), 0), &reply);
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
											 (UInt8 *)(RSTRING(bundleID)->ptr),
											 (CFIndex)(RSTRING(bundleID)->len),
											 kCFStringEncodingUTF8,
											 false);
		if (inBundleID == NULL) rb_raise(rb_eRuntimeError, "Invalid bundle ID string.");
	} else {
		inBundleID = NULL;
	}
	if (name != Qnil) {
		inName = CFStringCreateWithBytes(NULL,
										 (UInt8 *)(RSTRING(name)->ptr),
										 (CFIndex)(RSTRING(name)->len),
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
rbAE_launchApplication(VALUE self, VALUE path, VALUE firstEvent, VALUE flags)
{
	FSRef appRef;
	FSSpec fss;
	AEDesc paraDesc;
	Size paraSize;
	AppParametersPtr paraData;
	ProcessSerialNumber psn;
	LaunchParamBlockRec launchParams;
	OSErr err = noErr;
	
	err = FSPathMakeRef((UInt8 *)StringValuePtr(path), &appRef, NULL);
	if (err != 0) rbAE_raiseMacOSError("Couldn't make FSRef for application.", err);
	err = FSGetCatalogInfo(&appRef, kFSCatInfoNone, NULL, NULL, &fss, NULL);
	if (err != 0) rbAE_raiseMacOSError("Couldn't make FSSpec for application.", err);
	err = AECoerceDesc(&(AEDESC_OF(firstEvent)), typeAppParameters, &paraDesc);
	paraSize = AEGetDescDataSize(&paraDesc);
	paraData = (AppParametersPtr)NewPtr(paraSize);
	if (paraData == NULL) rbAE_raiseMacOSError("Can't make app parameters AEDesc.", memFullErr);
	err = AEGetDescData(&paraDesc, paraData, paraSize);
	if (err != noErr) rbAE_raiseMacOSError("Can't get AEDesc data.", err);
	launchParams.launchBlockID = extendedBlock;
	launchParams.launchEPBLength = extendedBlockLen;
	launchParams.launchFileFlags = 0;
	launchParams.launchControlFlags = (LaunchFlags)NUM2UINT(flags);
	launchParams.launchAppSpec = &fss;
	launchParams.launchAppParameters = paraData;
	err = LaunchApplication(&launchParams);
	if (err != noErr) rbAE_raiseMacOSError("Can't launch application.", err);
	psn = launchParams.launchProcessSN;
	return rb_ary_new3(2, INT2NUM(psn.highLongOfPSN), INT2NUM(psn.lowLongOfPSN));
}

static VALUE
rbAE_pidToPsn(VALUE self, VALUE pid)
{
	OSStatus err = 0;
	ProcessSerialNumber psn;
	
	err = GetProcessForPID((pid_t)NUM2INT(pid), &psn);
	if (err != noErr) rbAE_raiseMacOSError("Can't convert PID to PSN.", err);
	return rb_ary_new3(2, INT2NUM(psn.highLongOfPSN), INT2NUM(psn.lowLongOfPSN));
}

/**********************************************************************/

static VALUE
rbAE_convertLongDateTimeToUnixSeconds(VALUE self, VALUE ldt)
{
	OSStatus err = 0;
	CFAbsoluteTime cfTime;
	
	err = UCConvertLongDateTimeToCFAbsoluteTime(rb_big2ll(ldt), &cfTime);
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
	return rb_ll2big(ldt);
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
	rb_define_singleton_method(cAEDesc, "newList", rbAE_AEDesc_newList, 1);
	rb_define_singleton_method(cAEDesc, "newAppleEvent", rbAE_AEDesc_newAppleEvent, 5);
	
	rb_define_method(cAEDesc, "to_s", rbAE_AEDesc_inspect, 0);
	rb_define_method(cAEDesc, "inspect", rbAE_AEDesc_inspect, 0);
	rb_define_method(cAEDesc, "type", rbAE_AEDesc_type, 0);
	rb_define_method(cAEDesc, "data", rbAE_AEDesc_data, 0);
	rb_define_method(cAEDesc, "coerce", rbAE_AEDesc_coerce, 1);
	rb_define_method(cAEDesc, "length", rbAE_AEDesc_length, 0);
	rb_define_method(cAEDesc, "putItem", rbAE_AEDesc_putItem, 2);
	rb_define_method(cAEDesc, "putParam", rbAE_AEDesc_putParam, 2);
	rb_define_method(cAEDesc, "putAttr", rbAE_AEDesc_putAttr, 2);
	rb_define_method(cAEDesc, "get", rbAE_AEDesc_get, 2);
	rb_define_method(cAEDesc, "send", rbAE_AEDesc_send, 2);
	
	// AE::MacOSError
	cMacOSError = rb_define_class_under(mAE, "MacOSError", rb_eStandardError);
	
	rb_define_attr(cMacOSError, "to_i", Qtrue, Qfalse);
	rb_define_attr(cMacOSError, "description", Qtrue, Qfalse);
	
	rb_define_method(cMacOSError, "to_s", rbAE_MacOSError_inspect, 0);
	rb_define_method(cMacOSError, "inspect", rbAE_MacOSError_inspect, 0);

	// Support functions
	rb_define_module_function(mAE, "findApplication", rbAE_findApplication, 3);
	rb_define_module_function(mAE, "psnForApplicationPath", rbAE_psnForApplicationPath, 1);
	rb_define_module_function(mAE, "launchApplication", rbAE_launchApplication, 3);
	rb_define_module_function(mAE, "pidToPsn", rbAE_pidToPsn, 1);

	rb_define_module_function(mAE, "convertLongDateTimeToUnixSeconds", 
							  rbAE_convertLongDateTimeToUnixSeconds, 1);
	rb_define_module_function(mAE, "convertUnixSecondsToLongDateTime", 
							  rbAE_convertUnixSecondsToLongDateTime, 1);
}
