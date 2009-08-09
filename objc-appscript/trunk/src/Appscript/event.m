//
//  event.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "event.h"


/**********************************************************************/
// NSError userInfo constants

NSString *const kASErrorDomain				= @"net.sourceforge.appscript.objc-appscript.ErrorDomain";

NSString *const kASErrorNumberKey			= @"ErrorNumber";
NSString *const kASErrorStringKey			= @"ErrorString";
NSString *const kASErrorBriefMessageKey		= @"ErrorBriefMessage";
NSString *const kASErrorExpectedTypeKey		= @"ErrorExpectedType";
NSString *const kASErrorOffendingObjectKey	= @"ErrorOffendingObject";
NSString *const kASErrorFailedEvent			= @"ErrorFailedEvent";


/**********************************************************************/
// Attribute keys

typedef struct {
	NSString *name;
	OSType code;
}  ASEventAttributeDescription;

// All known Apple event attributes:
static ASEventAttributeDescription attributeKeys[] = {
	{@"EventClass       ", keyEventClassAttr},
	{@"EventID          ", keyEventIDAttr},
	{@"TransactionID    ", keyTransactionIDAttr},
	{@"ReturnID         ", keyReturnIDAttr},
	{@"Address          ", keyAddressAttr},
	{@"OptionalKeyword  ", keyOptionalKeywordAttr},
	{@"Timeout          ", keyTimeoutAttr},
	{@"InteractLevel    ", keyInteractLevelAttr},
	{@"EventSource      ", keyEventSourceAttr},
	{@"OriginalAddress  ", keyOriginalAddressAttr},
	{@"AcceptTimeout    ", keyAcceptTimeoutAttr},
	{@"Considerations   ", enumConsiderations},
	{@"ConsidsAndIgnores", enumConsidsAndIgnores},
	{@"Subject          ", keySubjectAttr},
	{nil, 0}
};


/**********************************************************************/


@implementation AEMEvent

/*
 * Note: new AEMEvent instances are constructed by AEMApplication objects; 
 * clients shouldn't instantiate this class directly.
 */
- (id)initWithEvent:(AppleEvent *)event_
			 codecs:(id)codecs_
		   sendProc:(AEMSendProcPtr)sendProc_ {
	self = [super init];
	if (!self) return self;
	event = event_; // note: AEMEvent instance takes ownership of the given AppleEvent descriptor
	[codecs_ retain];
	codecs = codecs_;
	sendProc = sendProc_;
	resultFormat = kAEMUnpackAsItem;
	resultType = typeWildCard;
	return self;
}

- (void)dealloc {
	AEDisposeDesc(event);
	free(event);
	[codecs release];
	[super dealloc];
}

-(void)finalize {
	AEDisposeDesc(event);
	free(event);
	[super finalize];
}

- (NSString *)description {
	AEDesc aeDesc;
	NSAppleEventDescriptor *descriptor;
	NSMutableString *result;
	int i = 0;
	OSErr err;
	
	result = [NSMutableString stringWithString: @"<AEMEvent {"];
	do {
		err = AEGetAttributeDesc(event, 
								 attributeKeys[i].code,
								 typeWildCard,
								 &aeDesc);
		if (!err) {
			descriptor = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &aeDesc];
			[result appendFormat: @"\n    %@ = %@;", 
					attributeKeys[i].name,
					[[AEMCodecs defaultCodecs] unpack: descriptor]];
			[descriptor release];
		}
		i += 1;
	} while (attributeKeys[i].name != nil);
	[result appendString: @"\n}, "];
	err = AECoerceDesc(event, typeAERecord, &aeDesc);
	if (err) return nil;
	descriptor = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &aeDesc];
	[result appendFormat: @"%@>", [[AEMCodecs defaultCodecs] unpack: descriptor]];
	[descriptor release];
	return (NSString *)result;
}

// Access codecs object

- (id)codecs {
	return codecs;
}

// Access underlying AEDesc

- (const AppleEvent *)aeDesc {
	return event;
}


- (NSAppleEventDescriptor *)descriptor {
	AppleEvent eventCopy;
	
	AEDuplicateDesc(event, &eventCopy);
	return [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &eventCopy] autorelease];
}

// Pack event's attributes and parameters, if any.

- (void)setAttribute:(id)value forKeyword:(AEKeyword)key {
	if (!value) [NSException raise: @"AEMEventError"
							format: @"Error packing attribute '%@': value cannot be nil.",
									[AEMObjectRenderer formatOSType: key]];
	OSErr err = AEPutAttributeDesc(event, key, [[codecs pack: value] aeDesc]);
	if (err) [NSException raise: @"AEMEventError"
						 format: @"Error %i packing attribute '%@' value: %@", 
								 err, [AEMObjectRenderer formatOSType: key],value];
}

- (void)setParameter:(id)value forKeyword:(AEKeyword)key {
	if (!value) [NSException raise: @"AEMEventError"
							format: @"Parameters may not be nil."];
	OSErr err = AEPutParamDesc(event, key, [[codecs pack: value] aeDesc]);
	if (err) [NSException raise: @"AEMEventError"
						 format: @"Error %i packing parameter '%@' value: %@", 
								 err, [AEMObjectRenderer formatOSType: key],value];
}

// Get attributes and parameters:

- (id)attributeForKeyword:(AEKeyword)key type:(DescType)type error:(out NSError **)error {
	AEDesc aeDesc;
	NSAppleEventDescriptor *desc;
	
	if (error)
		*error = nil;
	OSErr err = AEGetAttributeDesc(event, key, type, &aeDesc);
	if (err) {
		if (error)
			*error = [NSError errorWithDomain: kASErrorDomain code: err userInfo: nil];
		return nil;
	}
	desc = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &aeDesc] autorelease];
	return [codecs unpack: desc];
}

- (id)attributeForKeyword:(AEKeyword)key {
	return [self attributeForKeyword: key type: typeWildCard error: nil];
}

- (id)parameterForKeyword:(AEKeyword)key type:(DescType)type error:(out NSError **)error  {
	AEDesc aeDesc;
	NSAppleEventDescriptor *desc;
	
	if (error)
		*error = nil;
	OSErr err = AEGetParamDesc(event, key, typeWildCard, &aeDesc);
	if (err) {
		if (error)
			*error = [NSError errorWithDomain: kASErrorDomain code: err userInfo: nil];
		return nil;
	}
	desc = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &aeDesc] autorelease];
	return [codecs unpack: desc];
}

- (id)parameterForKeyword:(AEKeyword)key {
	return [self parameterForKeyword: key type: typeWildCard error: nil];
}

//

- (void)setUnpackFormat:(AEMUnpackFormat)format_ type:(DescType)type_ {
	resultFormat = format_;
	resultType = type_;
}

- (void)getUnpackFormat:(AEMUnpackFormat *)format_ type:(DescType *)type_ {
	*format_ = resultFormat;
	*type_ = resultType;
}


/*
 * Send event.
 *
 * (-send, -sendWithMode:, -sendWithTimeout: are convenience shortcuts for -sendWithMode:timeout:)
 *
 * (Note: a single event can be sent multiple times if desired.)
 *
 * (Note: if an Apple Event Manager/application error occurs, these methods will return nil.
 * Clients should test for this, and use the error argument to retrieve additional error information
 * if needed.
 */

- (id)sendWithMode:(AESendMode)sendMode timeout:(long)timeoutInTicks error:(out NSError **)error {
	OSErr err, errorNumber;
	NSString *errorString, *errorDescription;
	NSDictionary *errorInfo;
	AEDesc replyDesc = {typeNull, NULL};
	AEDesc classDesc, idDesc;
	OSType classCode, idCode;
	NSAppleEventDescriptor *replyData, *result;
	NSAppleEventDescriptor *errorMessage, *errorObject, *errorType;

	if (error)
		*error = nil;
	// send event
	errorNumber = sendProc(event, &replyDesc, sendMode, timeoutInTicks);	
	if (errorNumber) {
		// ignore 'invalid connection' errors caused by application quitting normally after being sent a quit event
		if (errorNumber == connectionInvalid) {
			err = AEGetAttributeDesc(event, keyEventClassAttr, typeType, &classDesc);
			if (err) return nil;
			err = AEGetDescData(&classDesc, &classCode, sizeof(classCode));
			AEDisposeDesc(&classDesc);
			if (err) return nil;
			err = AEGetAttributeDesc(event, keyEventIDAttr, typeType, &idDesc);
			if (err) return nil;
			err = AEGetDescData(&idDesc, &idCode, sizeof(idCode));
			AEDisposeDesc(&idDesc);
			if (err) return nil;
			if (classCode == kCoreEventClass && idCode == kAEQuitApplication) goto noResult;
		}
		// for any other Apple Event Manager errors, generate an NSError if one is requested, then return nil
		if (error) {
			errorDescription = [NSString stringWithFormat: @"Apple Event Manager error: %@ (%i)", 
															ASDescriptionForError(errorNumber), errorNumber];
			errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
					errorDescription,						NSLocalizedDescriptionKey,
					[NSNumber numberWithInt: errorNumber],	kASErrorNumberKey,
					self,									kASErrorFailedEvent,
					nil];
			*error = [NSError errorWithDomain: kASErrorDomain code: errorNumber userInfo: errorInfo];
		}
		return nil;
	}
	// extract reply data, if any
	if (replyDesc.descriptorType == typeNull) goto noResult; // application didn't return anything
	// wrap AEDesc as NSAppleEventDescriptor for convenience // TO DO: might be easier to use C API and wrap AEDescs later
	replyData = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &replyDesc];
	/*
	 * Check for an application error
	 *
	 *	Note: Apple spec says that both keyErrorNumber and keyErrorString parameters should be checked to determine if an 
	 *	error occurred; however, AppleScript only checks keyErrorNmber so we copy its behaviour for compatibility.
	 *	
	 *	Note: some apps (e.g. Finder) may return noErr on success, so ignore that too.
	 */
	errorNumber = (OSErr)[[replyData paramDescriptorForKeyword: keyErrorNumber] int32Value];
	if (errorNumber) {
		// if an application error occurred, generate an NSError if one is requested, then return nil
		if (error) {
			errorString = [[replyData paramDescriptorForKeyword: keyErrorString] stringValue];
			if (errorString)
				errorDescription = [NSString stringWithFormat: @"Application error: %@ (%i)", errorString, errorNumber];
			else
				errorDescription = [NSString stringWithFormat: @"Application error: %@ (%i)", 
																ASDescriptionForError(errorNumber), errorNumber];
			errorInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
					errorDescription,						NSLocalizedDescriptionKey,
					[NSNumber numberWithInt: errorNumber],	kASErrorNumberKey,
					self,									kASErrorFailedEvent,
					nil];
			if (errorString)
				[errorInfo setValue: errorString forKey: kASErrorStringKey];
			if (errorMessage = [replyData paramDescriptorForKeyword: kOSAErrorBriefMessage])
				[errorInfo setValue: [errorMessage stringValue] forKey: kASErrorBriefMessageKey];
			if (errorObject = [replyData paramDescriptorForKeyword: kOSAErrorOffendingObject])
				[errorInfo setValue: [codecs unpack: errorObject] forKey: kASErrorOffendingObjectKey];
			if (errorType = [replyData paramDescriptorForKeyword: kOSAErrorExpectedType])
				[errorInfo setValue: [codecs unpack: errorType] forKey: kASErrorExpectedTypeKey];
			*error = [NSError errorWithDomain: kASErrorDomain code: errorNumber userInfo: errorInfo];
		}
		[replyData release];
		return nil;
	}
	/*
	 * Check for an application result, returning NSNull instance if none was given
	 */
	result = [replyData paramDescriptorForKeyword: keyAEResult];
	[replyData release];
	if (!result) goto noResult;
	/*
	 * If client invoked -setUnpackFormat:type: with kAEMDontUnpack format, return the descriptor as-is
	 */
	if (resultFormat == kAEMDontUnpack) return result;
	/*
	 * Unpack result, performing any coercions specified via -setUnpackFormat:type: before unpacking the descriptor
	 */
	if (resultFormat == kAEMUnpackAsList) {
		if ([result descriptorType] != typeAEList) 
			result = [result coerceToDescriptorType: typeAEList];
		if (resultType != typeWildCard) {
			NSMutableArray *resultList;
			NSAppleEventDescriptor *item;
			int i, length;
			resultList = [NSMutableArray array];
			length = [result numberOfItems];
			for (i = 1; i <= length; i++) {
				item = [result descriptorAtIndex: i];
				if (resultType != typeWildCard && [item descriptorType] != resultType) {
					NSAppleEventDescriptor *originalItem = item;
					item = [item coerceToDescriptorType: resultType];
					if (!item) { // a coercion error occurred
						if (error) {
							errorDescription = [NSString stringWithFormat: @"Couldn't coerce item %i of returned list to type '%@': %@", 
																			i, [AEMObjectRenderer formatOSType: resultType], result];
							errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSAppleEventDescriptor descriptorWithTypeCode: resultType],	kASErrorExpectedTypeKey,
									originalItem,													kASErrorOffendingObjectKey,
									errorDescription,												NSLocalizedDescriptionKey, 
									[NSNumber numberWithInt: errorNumber],							kASErrorNumberKey, 
									self,															kASErrorFailedEvent,
									nil];
							*error = [NSError errorWithDomain: kASErrorDomain code: errAECoercionFail userInfo: errorInfo];
						}
						return nil;
					}
				}
				[resultList addObject: [codecs unpack: item]];
			}
			return resultList;
		}
	} else if (resultType != typeWildCard && [result descriptorType] != resultType) {
		NSAppleEventDescriptor *originalResult = result;
		result = [result coerceToDescriptorType: resultType];
		if (!result) { // a coercion error occurred
			if (error) {
				errorDescription = [NSString stringWithFormat: @"Couldn't coerce returned item to type '%@': %@", 
																[AEMObjectRenderer formatOSType: resultType], originalResult];
				errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSAppleEventDescriptor descriptorWithTypeCode: resultType],	kASErrorExpectedTypeKey,
						originalResult,													kASErrorOffendingObjectKey,
						errorDescription,												NSLocalizedDescriptionKey, 
						[NSNumber numberWithInt: errorNumber],							kASErrorNumberKey, 
						self,															kASErrorFailedEvent,
						nil];
				*error = [NSError errorWithDomain: kASErrorDomain code: errAECoercionFail userInfo: errorInfo];
			}
			return nil;
		}
	}
	return [codecs unpack: result];
noResult:
	if (resultFormat == kAEMUnpackAsList)
		return [NSArray array];
	else
		return [NSNull null];
}

- (id)sendWithError:(out NSError **)error {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout error: error];
}

- (id)send {
	return [self sendWithMode: kAEWaitReply timeout: kAEDefaultTimeout error: nil];
}

@end
