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

- (NSAppleEventDescriptor *)packSelf:(id)codecs;

- (id)resolve:(id)object;

@end


/**********************************************************************/


@interface AEMResolver // TO DO: finish

- (id)app;

- (id)con;

- (id)its;

- (id)customRoot:(id)rootObject;

@end

