//
//  utils.h
//  Appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


NSString *AEMDescTypeToDisplayString(OSType code);

#define AEMIsDescriptorEqualToObject(desc, obj) ( \
		[obj isKindOfClass: [NSAppleEventDescriptor class]] \
		&& ([desc descriptorType] == [obj descriptorType]) \
		&& [[desc data] isEqualToData: [obj data]])
