//
//  SHMutableFloat.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SHShared/SHValueProtocol.h>
#import "SHAbstractDataType.h"

@class SHNumber;

/*
 *
*/
@interface SHMutableFloat : SHAbstractDataType <SHValueProtocol>
{

	//@public
	float		privateValue;
}

#pragma mark -
#pragma mark class methods
+ (NSString *) willAsk;
+ (NSArray *) willAnswer;

// make a new one from a typed in value
// return a new instance of this type initialized with value from the string
+ (id) dataTypeFromDisplayObject:(id)stringVal;

#pragma mark init methods
- (id) initWithObject:(id)ob;
- (id) initWithInt:(int)intVal;
- (id) initWithFloat:(float)floatVal;

#pragma mark NSCopyopying, hash, isEqual
- (id)copyWithZone:(NSZone *)zone;
- (id)duplicate;

- (BOOL) isEqual:(id)anObject;

#pragma mark action methods
- (BOOL) tryToSetValueWith:(id)aValue;

#pragma mark accessor methods
/*	The required 'willAnswer' method for this dataType 
NOTE: This value should'nt be modifyied internally unless you know what you are doing
An operator wont modify it's input values */
- (SHMutableFloat *) SHMutableFloat;

- (SHNumber*) SHNumber;

//- (int) intValue;

//- (NSString *) stringValue;

//- (float) floatValue;

/* Views DO NOT know about dataObjects, only attributes */
- (id) displayObject;

/* the obligatory save method */
- (NSString *) fScriptSaveString;

@end
