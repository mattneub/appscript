//
//  codecs.h
//  aem
//
//   Copyright (C) 2007-2008 HAS
//

#import "specifier.h"
#import "types.h"
#import "utils.h"

// TO DO: support for unit types

/**********************************************************************/
// AE types not defined in older OS versions

enum {
	AS_typeUTF16ExternalRepresentation = 'ut16',
	AS_typeUInt16 = 'ushr',
	AS_typeUInt64 = 'ucom'
};


/**********************************************************************/


@interface AEMCodecs : NSObject <AEMCodecsProtocol>

+ (id)defaultCodecs;

//- (void)addUnitTypes:(NSArray *)typeDefs; // TO DO

/**********************************************************************/
// main pack methods

/*
 * Converts a Cocoa object to an NSAppleEventDescriptor.
 * Calls -packUnknown: if object is of an unsupported class.
 */
- (NSAppleEventDescriptor *)pack:(id)anObject;

/*
 * Called by -pack: to process a Cocoa object of unsupported class.
 * Default implementation raises "CodecsError" NSException; subclasses
 * can override this method to provide alternative behaviours if desired.
 */
- (NSAppleEventDescriptor *)packUnknown:(id)anObject;


/**********************************************************************/
/*
 * The following methods will be called by -pack: as needed.
 * Subclasses can override the following methods to provide alternative 
 * behaviours if desired, although this is generally unnecessary.
 */
- (NSAppleEventDescriptor *)packArray:(NSArray *)anObject;
- (NSAppleEventDescriptor *)packDictionary:(NSDictionary *)anObject;


/**********************************************************************/
// main unpack methods; subclasses can override to process still-unconverted objects

/*
 * Converts an NSAppleEventDescriptor to a Cocoa object.
 * Calls -unpackUnknown: if descriptor is of an unsupported type.
 */
- (id)unpack:(NSAppleEventDescriptor *)desc;

/*
 * Called by -unpack: to process an NSAppleEventDescriptor of unsupported type.
 * Default implementation checks to see if the descriptor is a record-type structure
 * and unpacks it as an NSDictionary if it is, otherwise it returns the value as-is.
 * Subclasses can override this method to provide alternative behaviours if desired.
 */
- (id)unpackUnknown:(NSAppleEventDescriptor *)desc;


/**********************************************************************/
/*
 * The following methods will be called by -unpack: as needed.
 * Subclasses can override the following methods to provide alternative 
 * behaviours if desired, although this is generally unnecessary.
 */
- (id)unpackAEList:(NSAppleEventDescriptor *)desc;
- (id)unpackAERecord:(NSAppleEventDescriptor *)desc;
- (id)unpackAERecordKey:(AEKeyword)key;

- (id)unpackType:(NSAppleEventDescriptor *)desc;
- (id)unpackEnum:(NSAppleEventDescriptor *)desc;
- (id)unpackProperty:(NSAppleEventDescriptor *)desc;
- (id)unpackKeyword:(NSAppleEventDescriptor *)desc;

- (id)fullyUnpackObjectSpecifier:(NSAppleEventDescriptor *)desc;
- (id)unpackObjectSpecifier:(NSAppleEventDescriptor *)desc;
- (id)unpackInsertionLoc:(NSAppleEventDescriptor *)desc;

- (id)app;
- (id)con;
- (id)its;
- (id)customRoot:(NSAppleEventDescriptor *)desc;

- (id)unpackCompDescriptor:(NSAppleEventDescriptor *)desc;
- (id)unpackLogicalDescriptor:(NSAppleEventDescriptor *)desc;

/*
 * Notes:
 *
 * kAEContains is also used to construct 'is in' tests, where test value is first operand and
 * reference being tested is second operand, so need to make sure first operand is an its-based ref;
 * if not, rearrange accordingly.
 *
 * Since type-checking is involved, this extra hook is provided so that appscript's ASAppData class
 * can override this method to add its own type checking.
 */
- (id)unpackContainsCompDescriptorWithOperand1:(id)op1 operand2:(id)op2;


/**********************************************************************/
/*
 * The following methods are not called by -unpack:, but are provided for benefit of
 * subclasses that may wish to use them.
 */

- (NSString *)unpackApplicationBundleID:(NSAppleEventDescriptor *)desc;

- (NSURL *)unpackApplicationURL:(NSAppleEventDescriptor *)desc;

- (OSType)unpackApplicationSignature:(NSAppleEventDescriptor *)desc;

- (pid_t)unpackProcessID:(NSAppleEventDescriptor *)desc;

- (pid_t)unpackProcessSerialNumber:(NSAppleEventDescriptor *)desc;

@end
