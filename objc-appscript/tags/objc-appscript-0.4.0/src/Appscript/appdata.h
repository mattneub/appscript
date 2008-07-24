//
//  appdata.h
//  Appscript
//
//  Copyright (C) 2007-2008 HAS
//


#import "application.h"
#import "codecs.h"
#import "reference.h"
#import "utils.h"


/**********************************************************************/
// typedefs

typedef enum {
	kASTargetCurrent,
	kASTargetName,
	kASTargetBundleID,
	kASTargetURL,
	kASTargetPID,
	kASTargetDescriptor,
} ASTargetType;


/**********************************************************************/


@interface ASAppDataBase : AEMCodecs {
	Class aemApplicationClass;
	ASTargetType targetType;
	id targetData;
	AEMApplication *target;
}

- (id)initWithApplicationClass:(Class)appClass
					targetType:(ASTargetType)type
					targetData:(id)data;

// creates AEMApplication instance for target application; used internally
- (BOOL)connectWithError:(NSError **)error;

// returns AEMApplication instance for target application
- (id)targetWithError:(NSError **)error;

// is target application running?
- (BOOL)isRunning;

// launch the target application without sending it the usual 'run' event;
// equivalent to 'launch' command in AppleScript.
- (BOOL)launchApplicationWithError:(NSError **)error;

@end


/**********************************************************************/


@interface ASAppData : ASAppDataBase {
	Class constantClass, referenceClass;
}

- (id)initWithApplicationClass:(Class)appClass
				 constantClass:(Class)constClass
				referenceClass:(Class)refClass
					targetType:(ASTargetType)type
					targetData:(id)data;

// AEMCodecs hook allowing extra typechecking to be performed here
- (id)unpackContainsCompDescriptorWithOperand1:(id)op1 operand2:(id)op2;

@end

