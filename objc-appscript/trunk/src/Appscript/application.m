//
//  application.m
//  aem
//
//  Copyright (C) 2007 HAS
//

#import "application.h"


#define osTypeToString(osType) [[[NSAppleEventDescriptor descriptorWithTypeCode: osType] coerceToDescriptorType: typeUnicodeText] stringValue]


/**********************************************************************/

// TO DO: -reconnect

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
														err, osTypeToString(creator), bundleID, name];
		errorInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
									errorDescription, NSLocalizedDescriptionKey,
									[NSNumber numberWithInt: err], kAEMErrorNumberKey,
									nil];
		*error = [NSError errorWithDomain: kAEMErrorDomain code: err userInfo: errorInfo];
		return nil;
	}
	return (NSURL *)outAppURL;
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


+ (BOOL)isApplicationRunning:(NSURL *)fileURL {
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
	FSSpec fss;
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
	err = FSGetCatalogInfo(&fsRef, kFSCatInfoNone, NULL, NULL, &fss, NULL);
	if (err) goto error;
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
	launchParams.launchAppSpec = &fss;
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
	sendProc = (AEMSendProcPtr)SendMessageThreadSafe;
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
	if ([name characterAtIndex: 0] == '/')
		url = [NSURL fileURLWithPath: name];
	else
		url = [[self class] findApplicationForCreator: kLSUnknownCreator
											   bundleID: nil
												   name: name
												  error: error];
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
	[targetData release];
	[addressDesc release];
	[defaultCodecs release];
	[super dealloc];
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


//

- (BOOL)reconnect {
	return NO; // TO DO
}

// transaction support // TO DO

- (void)beginTransaction {
	[self beginTransactionWithSession: nil];
}

- (void)beginTransactionWithSession:(id)session {
}

- (void)endTransaction {
}

- (void)abortTransaction {
}

@end
