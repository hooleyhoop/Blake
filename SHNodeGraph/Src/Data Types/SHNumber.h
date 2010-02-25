//
//  SHNumber.h
//  InterfaceTest
//
//  Created by Steve Hooley on Thu Jan 08 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

#import <SHShared/SHValueProtocol.h>
#import "SHAbstractDataType.h"

@class SHMutableBool;

/*
 * A simple wrapper around NSNumber
*/
@interface SHNumber : SHAbstractDataType <SHValueProtocol>
{
	// private
	// @public
	NSNumber*		privateValue;
}

#pragma mark -
#pragma mark class methods
+ (NSString *)willAsk;
+ (NSArray *)willAnswer;

// make a new one from a typed in value
// return a new instance of this type initialized with value from the string
+ (id)dataTypeFromDisplayObject:(id)stringVal; /* required method */

/* convienience constructors */
+ (id)numberWithObject:(id)ob;
+ (id)numberWithInt:(int)intVal;
+ (id)numberWithFloat:(float)floatVal;
+ (id)numberWithBool:(BOOL)boolVal;

#pragma mark init methods
- (id)initWithObject:(id)ob;
- (id)initWithInt:(int)intVal;
- (id)initWithFloat:(float)floatVal;
- (id)initWithBool:(BOOL)BoolVal;

//- (id) initWithParent:(NSObject*) parentAttr;

#pragma mark NSCopyopying, hash, isEqual
- (id)copyWithZone:(NSZone *)zone;
- (id)duplicate;

- (BOOL)isEqual:(id)anObject;

#pragma mark action methods

#pragma mark accessor methods
/* The required 'willAnswer' method for this dataType */
- (SHNumber *)SHNumber;
- (SHMutableBool *)SHMutableBool;

//- (NSString *)stringValue;

//- (float)floatValue;
//- (int)intValue;
//- (BOOL)boolValue;

/* Views DO NOT know about dataObjects, only attributes */
- (id)displayObject;

/* the obligatory save method */
- (NSString *)fScriptSaveString;


@end