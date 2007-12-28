//
//  base.h
//  aem
//
//  Copyright (C) 2007 HAS
//


#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


/**********************************************************************/

@protocol AEMCodecsProtocol

- (NSAppleEventDescriptor *)pack:(id)obj;

- (id)unpack:(NSAppleEventDescriptor *)desc;

- (id)fullyUnpackObjectSpecifier:(NSAppleEventDescriptor *)desc;

@end

/**********************************************************************/
// AEM reference base (shared by specifiers and tests)

@interface AEMQuery : NSObject {
	NSAppleEventDescriptor *cachedDesc;
}

/*
 * TO DO:
 *	- (unsigned)hash;
 *	- (BOOL)isEqual:(id)object;
 *	- (NSArray *)comparableData;
 */

// set cached descriptor; performance optimisation, used internally by AEMCodecs
- (void)setDesc:(NSAppleEventDescriptor *)desc;

// pack specifier into NSAppleEventDescriptor; used internally by AEMCodecs
- (NSAppleEventDescriptor *)packSelf:(id)codecs;

// walk reference
- (id)resolve:(id)object;

@end


/**********************************************************************/


@interface AEMResolver // TO DO: finish

- (id)app;

- (id)con;

- (id)its;

- (id)customRoot:(id)rootObject;

@end

