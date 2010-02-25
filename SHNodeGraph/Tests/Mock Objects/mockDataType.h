//
//  mockDataType.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 22/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHValueProtocol.h"
#import <ProtoNodeGraph/SHAbstractDataType.h>

/*
 *
*/
@interface mockDataType : SHAbstractDataType <SHValueProtocol, NSCopying, NSCoding> {
	
	id _privateValue;
}

#pragma mark -
#pragma mark class methods
+ (NSString *)willAsk;		// any data type will only ever ask a connected datatype for one type of data (string, number, etc.)

+ (NSArray *)willAnswer;	// however, a single data type might respond to more than one request (string and number, etc.)

#pragma mark NSCopyopying, hash, isEqual

#pragma mark init methods
- (id)initWithObject:(id)ob;
- (id)initWithInt:(int)val;

#pragma mark accessor methods

- (id)displayObject;

- (NSString *)stringValue;
- (NSString *)fScriptSaveString;
- (id)mockDataTypeValue;

- (id)value;
- (void)setValue:(id)aValue;

- (float)floatValue;

@end
