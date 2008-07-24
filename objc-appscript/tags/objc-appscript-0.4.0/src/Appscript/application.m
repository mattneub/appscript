//
//  application.m
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "application.h"


/**********************************************************************/


@implementation AEMApplication

// utility class methods

+ (NSURL *)findApplicationForCreator:(OSType)creator
							bundleID:(NSString *)bundleID
								name:(NSString *)name
							   error:(NSError **)error {
	OSErr err;
	CFURLRef outAppURL;
	NSString *errorDescription;
	NSDictionary *errorInfo;
	NSError *errorStub;
	
	if (!error) error = &errorStub;
	*error = nil;
	err = LSFindApplicationForInfo(creator,
								   (CFStringRef)bundleID,
								   (CFStringRef)name,
								   NULL,
								   &outAppURL);
	if (err) {
		errorDescription = [NSString stringWithFormat: @"Can't find application with creator '%@', "
														"bundle ID %@, name %@ (error %i)", 
														AEMDescTypeToDisplayString(creator), bundleID, name, err];
		errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
									errorDescription, NSLocalizedDescriptionKey,
									[NSNumber numberWithInt: err], kAEMErrorNumberKey,
									nil];
		*error = [NSError errorWithDomain: kAEMErrorDomain code: err userInfo: errorInfo];
		return nil;
	}
	return (NSURL *)outAppURL;
}

+ (NSURL *)findApplicationForName:(NSString *)name error:(NSError **)error {
	NSURL *url;
	NSError *err;
	
	if (!error) error = &err;
	*error = nil;
	if ([name characterAtIndex: 0] == '/')
		url = [NSURL fileURLWithPath: name];
	else
		url = [self findApplicationForCreator: kLSUnknownCreator
									 bundleID: nil
										 name: name
										error: error];
	if (!url && [[name pathExtension] localizedCaseInsensitiveCompare: @"app"] != NSOrderedSame)
		return [self findApplicationForName: [NSString stringWithFormat: @"%@.app", name] error: error];
	return url;
}

+ (pid_t)findProcessIDForApplication:(NSURL *)fileURL error:(NSError **)error {
	OSStatus err;
	FSRef desired, found;
	ProcessSerialNumber psn = {0, kNoProcess};
	NSString *errorDescription;
	NSDictionary *errorInfo;
	pid_t pid;
	NSError *errorStub;
	
	if (!error) error = &errorStub;
	*error = nil;
	if (!fileURL || !CFURLGetFSRef((CFURLRef)fileURL, &desired)) {
		err = errFSBadFSRef;
		goto error;
	}
	do {
		err = GetNextProcess(&psn);
		if (err) goto error; // -600 = process not found
		err = GetProcessBundleLocation(&psn, &found);
	} while (err || FSCompareFSRefs(&desired, &found));
	err = GetProcessPID(&psn, &pid);
	if (err) goto error;
	return pid;
error:
	// TO DO: better error message
	errorDescription = [NSString stringWithFormat: @"Can't find process ID for application %@ (error %i)", fileURL, err];
	errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
			errorDescription, NSLocalizedDescriptionKey,
			[NSNumber numberWithInt: err], kAEMErrorNumberKey,
			nil];
	*error = [NSError errorWithDomain: kAEMErrorDomain code: err userInfo: errorInfo];
	return 0;
}


// Check if specified application is running


+ (BOOL)processExistsForFileURL:(NSURL *)fileURL {
	OSStatus err;
	FSRef desired, found;
	ProcessSerialNumber psn = {0, kNoProcess};

	if (!CFURLGetFSRef((CFURLRef)fileURL, &desired)) return NO;
	do {
		err = GetNextProcess(&psn);
		if (err) return NO; // -600 = process not found
		err = GetProcessBundleLocation(&psn, &found);
	} while (err || FSCompareFSRefs(&desired, &found));
	return YES;
}


+(BOOL)processExistsForPID:(pid_t)pid {
	ProcessSerialNumber psn;

	return (GetProcessForPID(pid, &psn) == noErr); // -600 if process not found
}


+(BOOL)processExistsForEppcURL:(NSURL *)eppcURL {
	NSData *data;
	NSAppleEventDescriptor *desc;
	
	data = [[eppcURL absoluteString] dataUsingEncoding: NSUTF8StringEncoding];
	desc = [NSAppleEventDescriptor descriptorWithDescriptorType: typeFileURL
														   data: data];
	return [self processExistsForDescriptor: desc];
}


+(BOOL)processExistsForDescriptor:(NSAppleEventDescriptor *)desc {
	AEMApplication *app;
	NSError *err = nil;
	
	app = [[self alloc] initWithDescriptor: desc];
	[[app eventWithEventClass: 'ascr'  eventID: 'noop'] sendWithError: &err]; // should raise -1708
	[app release];
	if (err) // e.g. -600 = not running, -905 = no network access
		return ([err code] == -1708); // -1708 = usual 'event not handled' error; TO DO: any other 'OK' codes?
	else
		return YES;
}


/*
 * Note: this uses Process Manager for 10.3 compatibility.
 *
 * TO DO: use LSLaunchApplication if available? This would give clients
 * access to additional launch flags on 10.4+.
 */
+ (pid_t)launchApplication:(NSURL *)fileURL
					 event:(NSAppleEventDescriptor *)firstEvent
					 flags:(LaunchFlags)launchFlags
					 error:(NSError **)error {
	OSStatus err;
	FSRef fsRef;
#ifndef __LP64__
	FSSpec fss;
#endif
	AEDesc paraDesc;
	Size paraSize;
	AppParametersPtr paraData = NULL; // default event is aevtoapp
	ProcessSerialNumber psn;
	LaunchParamBlockRec launchParams;
	pid_t pid;
	NSString *errorDescription;
	NSDictionary *errorInfo;
	NSError *errorStub;
	
	if (!error) error = &errorStub;
	*error = nil;
	// Get FSSpec from NSURL
	if (!fileURL || !CFURLGetFSRef((CFURLRef)fileURL, &fsRef)) {
		err = fnfErr;
		goto error;
	}
#ifndef __LP64__
	err = FSGetCatalogInfo(&fsRef, kFSCatInfoNone, NULL, NULL, &fss, NULL);
	if (err) goto error;
#endif
	// Get Apple event data
	if (firstEvent) {
		err = AECoerceDesc([firstEvent aeDesc], typeAppParameters, &paraDesc);
		paraSize = AEGetDescDataSize(&paraDesc);
		paraData = (AppParametersPtr)NewPtr(paraSize);
		if (!paraData) {
			err = memFullErr;
			goto error;
		}
		err = AEGetDescData(&paraDesc, paraData, paraSize);
		if (err) goto error;
	}
	launchParams.launchBlockID = extendedBlock;
	launchParams.launchEPBLength = extendedBlockLen;
	launchParams.launchFileFlags = 0;
	launchParams.launchControlFlags = launchFlags;
#ifdef __LP64__
	launchParams.launchAppRef = &fsRef;
#else
	launchParams.launchAppSpec = &fss;
#endif
	launchParams.launchAppParameters = paraData;
	err = LaunchApplication(&launchParams);
	if (err) goto error; // Can't launch application.
	psn = launchParams.launchProcessSN;
	err = GetProcessPID(&psn, &pid);
	if (err) goto error;
	if (paraData) DisposePtr((Ptr)paraData);
	return pid;
error:
	errorDescription = [NSString stringWithFormat: @"Can't launch application %@ (error %i)", fileURL, err];
	errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
			errorDescription, NSLocalizedDescriptionKey,
			[NSNumber numberWithInt: err], kAEMErrorNumberKey,
			nil];
	*error = [NSError errorWithDomain: kAEMErrorDomain code: err userInfo: errorInfo];
	if (paraData) DisposePtr((Ptr)paraData);
	return 0;
}


+ (pid_t)launchApplication:(NSURL *)appFileURL error:(NSError **)error {
	NSAppleEventDescriptor *evt;
	
	evt = [NSAppleEventDescriptor appleEventWithEventClass: 'ascr'
												   eventID: 'noop'
										  targetDescriptor: [NSAppleEventDescriptor nullDescriptor]
												  returnID: kAutoGenerateReturnID
											 transactionID: kAnyTransactionID];
	return [self launchApplication: appFileURL
							 event: evt
							 flags: launchContinue | launchNoFileFlags | launchDontSwitch
							 error: error];
}

+ (pid_t)runApplication:(NSURL *)appFileURL error:(NSError **)error {
	NSAppleEventDescriptor *evt;
	
	evt = [NSAppleEventDescriptor appleEventWithEventClass: 'aevt'
												   eventID: 'oapp'
										  targetDescriptor: [NSAppleEventDescriptor nullDescriptor]
												  returnID: kAutoGenerateReturnID
											 transactionID: kAnyTransactionID];
	return [self launchApplication: appFileURL
							 event: evt
							 flags: launchContinue | launchNoFileFlags | launchDontSwitch
							 error: error];
}

+ (pid_t)openDocuments:(id)documentFiles inApplication:(NSURL *)appFileURL error:(NSError **)error {
	NSAppleEventDescriptor *evt;
	
	evt = [NSAppleEventDescriptor appleEventWithEventClass: 'ascr'
												   eventID: 'noop'
										  targetDescriptor: [NSAppleEventDescriptor nullDescriptor]
												  returnID: kAutoGenerateReturnID
											 transactionID: kAnyTransactionID];
	[evt setDescriptor: [[AEMCodecs defaultCodecs] pack: documentFiles] forKeyword: '----'];
	return [self launchApplication: appFileURL
							 event: evt
							 flags: launchContinue | launchNoFileFlags | launchDontSwitch
							 error: error];
}

// make AEAddressDescs

+ (NSAppleEventDescriptor*)addressDescForLocalApplication:(NSURL *)fileURL error:(NSError **)error {
	NSError *tempError = nil;
	pid_t pid;
	NSError *err;
	
	if (!error) error = &err;
	*error = nil;
	pid = [self findProcessIDForApplication: fileURL error: &tempError];
	if (tempError) {
		if (tempError && [tempError code] != -600) {
			*error = tempError;
			return nil;
		}
		pid = [self launchApplication: fileURL
								event: nil
								flags: launchContinue | launchNoFileFlags | launchDontSwitch
								error: &tempError];
		if (tempError && [tempError code] != -600) {
			*error = tempError;
			return nil;
		}
	}
	return [self addressDescForLocalProcess: pid];
}


+ (NSAppleEventDescriptor *)addressDescForLocalProcess:(pid_t)pid {
	return [NSAppleEventDescriptor descriptorWithDescriptorType: typeKernelProcessID
														  bytes: &pid
														 length: sizeof(pid)];
}									  


+ (NSAppleEventDescriptor *)addressDescForRemoteProcess:(NSURL *)eppcURL {
	CFDataRef data;
	NSAppleEventDescriptor *desc;
	
	if (!eppcURL) return nil;
	data = CFURLCreateData(NULL, (CFURLRef)eppcURL, kCFStringEncodingUTF8, YES);
	desc = [NSAppleEventDescriptor descriptorWithDescriptorType: typeApplicationURL
														   data: (NSData *)data];
	CFRelease(data);
	return desc;
}


+ (NSAppleEventDescriptor *)addressDescForCurrentProcess {
	ProcessSerialNumber psn = {0, kCurrentProcess};
	
	return [NSAppleEventDescriptor descriptorWithDescriptorType: typeProcessSerialNumber
														  bytes: &psn
														 length: sizeof(psn)];
}


/*******/

// clients shouldn't call this initializer directly; use one of the methods below
- (id)initWithTargetType:(AEMTargetType)targetType_ data:(id)targetData_ error:(NSError **)error {
	if (!targetData_) return nil;
	self = [super init];
	if (!self) return self;
	// hooks
	createProc = (AEMCreateProcPtr)AECreateAppleEvent;
	sendProc = (AEMSendProcPtr)AEMSendMessageThreadSafe;
	eventClass = [AEMEvent class];
	// description
	targetType = targetType_;
	targetData = targetData_;
	// address desc
	switch (targetType) {
		case kAEMTargetFileURL:
			addressDesc = [[self class] addressDescForLocalApplication: targetData error: error];
			break;
		case kAEMTargetEppcURL:
			addressDesc = [[self class] addressDescForRemoteProcess: targetData];
			break;
		case kAEMTargetCurrent:
			addressDesc = [[self class] addressDescForCurrentProcess];
			break;
		default:
			addressDesc = targetData;
	}
	if (!addressDesc) return nil;
	[targetData_ retain];
	[addressDesc retain];
	// misc
	defaultCodecs = [[AEMCodecs alloc] init];
	transactionID = kAnyTransactionID;
	return self;
}

// initializers

- (id)init {
	NSError *error;
	
	return [self initWithTargetType: kAEMTargetCurrent data: [NSNull null] error: &error];
}

- (id)initWithName:(NSString *)name error:(NSError **)error {
	NSURL *url;
	NSError *err;
	
	if (!error) error = &err;
	*error = nil;
	url = [[self class] findApplicationForName: name error: error];
	if (!url) return nil;
	return [self initWithTargetType: kAEMTargetFileURL data: url error: error];
}

- (id)initWithBundleID:(NSString *)bundleID error:(NSError **)error {
	NSURL *url;
	NSError *err;
	
	if (!error) error = &err;
	*error = nil;
	url = [[self class] findApplicationForCreator: kLSUnknownCreator
										   bundleID: bundleID
											   name: nil
											  error: error];
	if (!url) return nil;
	return [self initWithTargetType: kAEMTargetFileURL data: url error: error];
}

- (id)initWithURL:(NSURL *)url error:(NSError **)error {
	NSError *err;
	
	if (!error) error = &err;
	*error = nil;
	if ([url isFileURL])
		return [self initWithTargetType: kAEMTargetFileURL data: url error: error];
	else
		return [self initWithTargetType: kAEMTargetEppcURL data: url error: error];
}

- (id)initWithPID:(pid_t)pid {
	NSError *error;
	
	return [self initWithTargetType: kAEMTargetPID data: [[self class] addressDescForLocalProcess: pid] error: &error];
}

- (id)initWithDescriptor:(NSAppleEventDescriptor *)desc {
	NSError *error;
	
	return [self initWithTargetType: kAEMTargetDescriptor data: desc error: &error];
}


// shortcuts for above

- (id)initWithName:(NSString *)name {
	return [self initWithName: name error: nil];
}

- (id)initWithBundleID:(NSString *)bundleID {
	return [self initWithBundleID: bundleID error: nil];
}

- (id)initWithURL:(NSURL *)url {
	return [self initWithURL: url error: nil];
}


// dealloc

- (void)dealloc {
	if (transactionID != kAnyTransactionID)
		[self endTransactionWithError: nil];
	[targetData release];
	[addressDesc release];
	[defaultCodecs release];
	[super dealloc];
}

- (void)finalize {
	if (transactionID != kAnyTransactionID)
		[self endTransactionWithError: nil];
	[super finalize];
}


// comparison, hash support

- (BOOL)isEqual:(id)object {
	id targetData2;

	if (self == object) return YES;
	if (!object || ![object isMemberOfClass: [self class]] || targetType != [object targetType]) return NO;
	targetData2 = [object targetData];
	if ([targetData isKindOfClass: [NSAppleEventDescriptor class]])
		// NSAppleEventDescriptors compare for object identity only, so do a more thorough comparison here
		return ([targetData2 isKindOfClass: [NSAppleEventDescriptor class]] 
			&& ([targetData descriptorType] == [targetData2 descriptorType])
			&& [[targetData data] isEqualToData: [targetData2 data]]);
	return ([targetData isEqual: targetData2] || (targetData == nil && targetData2 == nil));
}

- (AEMTargetType)targetType {
	return targetType;
}

- (id)targetData {
	return targetData;
}

- (unsigned)hash {
	return [[self description] hash];
}


// get address desc

- (NSAppleEventDescriptor *)packWithCodecs:(id)codecs {
	return addressDesc;
}

- (NSAppleEventDescriptor *)desc {
	return addressDesc;
}


// display

- (NSString *)description {
	pid_t pid;
	switch (targetType) {
		case kAEMTargetFileURL:
		case kAEMTargetEppcURL:
			return [NSString stringWithFormat: @"<AEMApplication url=%@>", targetData];
		case kAEMTargetPID:
			[[addressDesc data] getBytes: &pid length: sizeof(pid_t)];
			return [NSString stringWithFormat: @"<AEMApplication pid=%i>", pid];
		case kAEMTargetCurrent:
			return @"<AEMApplication current>";
		default:
			return [NSString stringWithFormat: @"<AEMApplication desc=%@>", addressDesc];
	}
}

// clients can call following methods to modify standard create/send behaviours

- (void)setCreateProc:(AEMCreateProcPtr)createProc_ {
	createProc = createProc_;
}

- (void)setSendProc:(AEMSendProcPtr)sendProc_ {
	sendProc = sendProc_;
}

- (void)setEventClass:(Class)eventClass_ {
	eventClass = eventClass_;
}

// create new AEMEvent object

- (id)eventWithEventClass:(AEEventClass)classCode
						  eventID:(AEEventID)code
						 returnID:(AEReturnID)returnID
						   codecs:(id)codecs {
	OSErr err;
	AppleEvent *appleEvent;
	
	appleEvent = malloc(sizeof(AEDesc));
	if (!appleEvent) return nil;
	err = createProc(classCode, code, [addressDesc aeDesc], returnID, transactionID, appleEvent);
	if (err) return nil;
	return [[[eventClass alloc] initWithEvent: appleEvent
									 codecs: codecs 
								   sendProc: sendProc] autorelease];
}

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code
				 returnID:(AEReturnID)returnID {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: returnID
							  codecs: defaultCodecs];
}

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code
				   codecs:(id)codecs {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: codecs];
}

- (id)eventWithEventClass:(AEEventClass)classCode
				  eventID:(AEEventID)code {
	return [self eventWithEventClass: classCode
							 eventID: code
							returnID: kAutoGenerateReturnID
							  codecs: defaultCodecs];
}


// reconnect to a local application specified by path

- (BOOL)reconnect {
	return [self reconnectWithError: nil];
}

- (BOOL)reconnectWithError:(NSError **)error {
	NSAppleEventDescriptor *newAddress;
	
	if (error)
		*error = nil;
	if (targetType == kAEMTargetFileURL) {
		newAddress = [[self class] addressDescForLocalApplication: targetData error: error];
		if (newAddress) {
			[addressDesc release];
			addressDesc = [newAddress retain];
			return YES;
		}
	}
	return NO;
}


// transaction support

- (BOOL)beginTransactionWithError:(NSError **)error {
	return [self beginTransactionWithSession: nil error: error];
}

- (BOOL)beginTransactionWithSession:(id)session error:(NSError **)error {
	AEMEvent *evt;
	id transactionIDObj = nil;
	NSDictionary *errorInfo;
	
	if (error)
		*error = nil;
	if (transactionID == kAnyTransactionID) {
		evt = [self eventWithEventClass: kAEMiscStandards eventID: kAEBeginTransaction];
		if (session)
			[evt setParameter: session forKeyword: keyDirectObject];
		transactionIDObj = [[evt unpackResultAsType: typeSInt32] sendWithError: error];
		if (transactionIDObj)
			transactionID = [transactionIDObj intValue];
	} else if (error) {
		errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
									@"Transaction is already active.", NSLocalizedDescriptionKey,
									[NSNumber numberWithInt: errAEInTransaction], kAEMErrorNumberKey,
									nil];
		*error = [NSError errorWithDomain: kAEMErrorDomain code: errAEInTransaction userInfo: errorInfo];
	}
	return (transactionIDObj != nil);
}

- (BOOL)endTransactionWithError:(NSError **)error {
	AEMEvent *evt;
	id result = nil;
	NSDictionary *errorInfo;

	if (error)
		*error = nil;
	if (transactionID != kAnyTransactionID) {
		evt = [self eventWithEventClass: kAEMiscStandards eventID: kAEEndTransaction];
		result = [evt sendWithError: error];
	} else if (error) {
		errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
									@"Transaction isn't active.", NSLocalizedDescriptionKey,
									[NSNumber numberWithInt: errAENoSuchTransaction], kAEMErrorNumberKey,
									nil];
		*error = [NSError errorWithDomain: kAEMErrorDomain code: errAENoSuchTransaction userInfo: errorInfo];
	}
	return (result != nil);
}

- (BOOL)abortTransactionWithError:(NSError **)error {
	AEMEvent *evt;
	id result = nil;
	NSDictionary *errorInfo;

	if (error)
		*error = nil;
	if (transactionID != kAnyTransactionID) {
		evt = [self eventWithEventClass: kAEMiscStandards eventID: kAETransactionTerminated];
		result = [evt sendWithError: error];
	} else if (error) {
		errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
									@"Transaction isn't active.", NSLocalizedDescriptionKey,
									[NSNumber numberWithInt: errAENoSuchTransaction], kAEMErrorNumberKey,
									nil];
		*error = [NSError errorWithDomain: kAEMErrorDomain code: errAENoSuchTransaction userInfo: errorInfo];
	}
	return (result != nil);
}

@end
