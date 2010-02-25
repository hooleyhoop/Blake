//
//  mockDataType.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 22/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "mockDataType.h"


/* hacky */
//@implementation NSString (mockDataTypeValue)
//
//- ()mockDataTypeValue;
//
//@end
//
//@implementation NSNumber (mockDataTypeValue)
//
//- ()mockDataTypeValue
//
//@end

@implementation NSNull (Debug)

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	logWarning(@"What no selector?");
//    if ([someOtherObject respondsToSelector:
//            [anInvocation selector]])
//        [anInvocation invokeWithTarget:someOtherObject];
//    else
        [super forwardInvocation:anInvocation];
}

- (NSString *)stringValue {
	// NSAssert(YES==NO, @"should never get here");
	return [NSString stringWithFormat:@"<<NSNull>>"];
}

@end

@implementation mockDataType

#pragma mark -
#pragma mark class methods

+ (NSString *)willAsk {
	return @"mockDataTypeValue";
}

+ (NSArray *)willAnswer {
	// need to return nsnumber for sosme of the tests
	return [NSArray arrayWithObjects:@"mockDataTypeValue", @"SHNumber", @"mockDataType2Value", nil];
}

#pragma mark init methods

/* called from HooleyObject init */
- (id)initBase {
	self=[super initBase];
	if(self){
	}
	return self;
}

- (id)initWithObject:(id)arg {
	
	self=[super init];
	if(self)
	{
		if([arg isKindOfClass:[NSString class]]){
			if([arg isEqualToString:@"<<NSNull>>"]){
				[self setValue:[NSNull null]];
				return self;
			}
		}
		
		if(arg)
			[self setValue:arg];
		else
			[self setValue:[NSNull null]];
	}
	return self;
}

- (id)initWithInt:(int)val {
	return [self initWithObject:[NSNumber numberWithInt:val]];
}

- (void)dealloc {
    
    [self setValue:nil];
    [super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
	_privateValue = [[coder decodeObjectForKey:@"privateValue"] retain];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {

	[super encodeWithCoder:coder];
	[coder encodeObject:_privateValue forKey:@"privateValue"];
}

- (id)copyWithZone:(NSZone *)zone {
	
	mockDataType *copy = [super copyWithZone:zone];
	copy->_privateValue = [_privateValue copyWithZone:zone];
    return copy;
}

- (BOOL)isEquivalentToValue:(id)anObject {

	if([self class]==[anObject class])
	{
		id objVal = [anObject value];
		if([objVal isKindOfClass:[NSString class]]){
			// comparing mockDataTypeValue and 123
			// logInfo(@"comparing %@ and %@", _privateValue, [anObject value]);
			if( [_privateValue isEqualToString: objVal] )
				return YES;
		} else if([objVal isKindOfClass:[NSNumber class]]){
			if( [_privateValue isEqualToNumber: objVal] )
				return YES;
		} else {
			if( [_privateValue isEqualTo: objVal] )
				return YES;
		}
	
	}
	return NO;
}

#pragma mark accessor methods
// ===========================================================
// - displayObject:
// ===========================================================
- (id)displayObject
{
	id returnObject=nil;
	if([_privateValue isKindOfClass:[NSString class]]){
		returnObject = _privateValue;
	} else if([_privateValue isKindOfClass:[NSNumber class]]){
		returnObject = [_privateValue stringValue];
	} else if([_privateValue isKindOfClass:[NSNull class]]){
		returnObject = [_privateValue stringValue];
	} else {
		returnObject = @"i cannot make a display object value for this object";
	}
	return returnObject;
}

- (NSString *)stringValue
{
	return [self displayObject];
}

- (NSString *)fScriptSaveString
{
	// save the value to val
	NSString* outputString = [NSString stringWithFormat:@"dataValue := (%@ alloc initWithObject:'%@') autorelease.\n", [self class], [self displayObject]];
	outputString = [outputString stringByAppendingString:@"dataValue . \n"];
	return outputString;
}


- (id)mockDataTypeValue {
	return self;
}

- (id)SHNumber {
//	if(isUnset==YES)
		NSAssert(isUnset==NO, @"shouldnt be asking for unset value");
	return self;
}


- (id)value { 
//	if(isUnset==YES)
//		NSAssert(isUnset==NO, @"shouldnt be asking for unset value");
	return _privateValue; 
}

- (void)setValue:(id)aValue
{
    //logInfo(@"in -setValue:, old value of _privateValue: %@, changed to: %@", _privateValue, aValue);
	if([aValue isKindOfClass:[NSNumber class]]){
	
	
	} else if([aValue isKindOfClass:[NSString class]]){
		logInfo(@"wait - who setting string?");
	}
    if (_privateValue != aValue) {
        [_privateValue release];
        _privateValue = [aValue retain];
		
		[self setIsUnset: _privateValue==[NSNull null]];
    }
}

- (float)floatValue {
	//if(isUnset==YES)
		NSAssert(isUnset==NO, @"shouldnt be asking for unset value");

	if([_privateValue isKindOfClass:[NSNumber class]]){
		return [_privateValue floatValue];
	} else {
		logError(@"error");
	}
	return 0.0f;
}

- (NSString *)description {
//	if(isUnset==YES)
//		logWarning(@"should i be here?");
	return( [NSString stringWithFormat:@"%@ - %@", [super description], _privateValue] );
}
@end
