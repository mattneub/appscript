//
//  bridgedata.h
//  Appscript
//
//  Copyright (C) 2008 HAS
//

#import "appdata.h"
#import "parser.h"
#import "terminology.h"

@interface ASBridgeData : ASAppDataBase {
	AEMCodecs *referenceCodecs;
	id terms;
	ASTerminology *defaultTerms;
	id converter;
}

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data
				   terminology:(id)terms_
				  defaultTerms:(ASTerminology *)defaultTerms_
			  keywordConverter:(id)converter_;

- (ASTargetType)targetType;

- (id)targetData;

- (void)setReferenceCodecs:(id)codecs_;

- (id)referenceCodecs;

- (ASTerminology *)terminology;

- (NSString *)unpackApplicationBundleID:(NSAppleEventDescriptor *)desc;

- (NSURL *)unpackApplicationURL:(NSAppleEventDescriptor *)desc;

- (OSType)unpackApplicationSignature:(NSAppleEventDescriptor *)desc;

- (pid_t)unpackProcessID:(NSAppleEventDescriptor *)desc;

- (pid_t)unpackProcessSerialNumber:(NSAppleEventDescriptor *)desc;

@end
