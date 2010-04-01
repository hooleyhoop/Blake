//
//  SHMutableFloat.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHMutableFloat.h"
#import "SHNumber.h"

#import <FScript/FScript.h>

// globals for this file
static NSString*	_willAsk;
static NSArray*		_willAnswer;

/*
 *
 */
@interface SHMutableFloat (PrivateMethods)
- (void) setValue:(float) aValue;
@end

/*
 * any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
 * however, a single data type might respond to more than one request (string and number, etc.)
 *
*/
@implementation SHMutableFloat

#pragma mark -
#pragma mark class methods

+ (void)initialize {

    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        _willAsk		= @"SHMutableFloat";
        _willAnswer		= [[NSArray arrayWithObjects:@"SHMutableFloat", @"SHNumber", nil] retain];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"what is going on with these multiple initializes?"];
    }
}

//=========================================================== 
// - willAsk:
//=========================================================== 
+ (NSString*) willAsk {
	return _willAsk;
}

//=========================================================== 
// - willAnswer:
//=========================================================== 
+ (NSArray*) willAnswer {
	return _willAnswer;
}

//=========================================================== 
// - dataTypeFromDisplayObject:
//=========================================================== 
+ (id) dataTypeFromDisplayObject:(id)stringVal
{
	id adt = [[[self class] alloc] initWithObject:stringVal];
	return [adt autorelease];
}

#pragma mark init methods
//=========================================================== 
// - init:
//=========================================================== 
- (id) init
{
	return [self initWithFloat:0.0f];
}

/* init with an initial value from your custom operator */
- (id) initWithObject:(id)ob
{
	id newOb = [self init];
	[newOb tryToSetValueWith:ob];
	return newOb;
}

//=========================================================== 
// - initWithFloat:
//=========================================================== 
- (id) initWithFloat:(float)floatVal
{
    if ((self = [super init]) != nil) {
		[self setValue: floatVal];
	}
	return self;
}

//=========================================================== 
// - initWithInt:
//=========================================================== 
- (id) initWithInt:(int)intVal
{
	return [self initWithFloat: round(intVal)];
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
//	[self setValue: nil];
    [super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual
//=========================================================== 
// - copyWithZone:
//=========================================================== 
- (id) copyWithZone:(NSZone *)zone
{
	almost certainly wrong! we need to super copy

	// logInfo(@"SHNumber.m: copyWithZone");
    id copy = [[[self class] allocWithZone: zone] initWithFloat: privateValue ];
    return copy;
}

// why is this in every class?

- (id)duplicate
{
	logWarning(@"BEWARE - DOES NOT RETURN AUTORELEASED OBJECT!");
	return [self copy];
}

//=========================================================== 
// - isEqual:
//=========================================================== 
- (BOOL) isEqual:(id)anObject
{
	if([self class]==[anObject class])
		if( privateValue == ((SHMutableFloat*)anObject)->privateValue )
			return YES;
	return NO;
}


#pragma mark action methods


//=========================================================== 
// - tryToSetValueWith:
//=========================================================== 
// NSString
// NSNumber
// Block
// respondsTo 'boolValue'
// respondsTo 'floatValue'
// respondsTo 'intValue'
- (BOOL) tryToSetValueWith:(id)aValue
{
	if([aValue isKindOfClass:[NSNumber class]])
	{
		[self setValue: [aValue floatValue]];
		return YES;
		
	} else if([aValue isKindOfClass:[NSString class]])
	{
		aValue = [aValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		// is it a number in a string?
		NSNumber* result;
		BOOL flag = [aValue isNumber:&result];
		if(flag){
			[self setValue: (float)[aValue doubleValue]];
			return YES;
		}
		
		
		// is the string a YES or a NO
		NSString* uppercaseVersion = [aValue uppercaseString];
		if([uppercaseVersion isEqualToString:@"YES"] || [uppercaseVersion isEqualToString:@"TRUE"])
		{
			[self setValue:1.0f];
			return YES;	
		} else if([uppercaseVersion isEqualToString:@"NO"] || [uppercaseVersion isEqualToString:@"FALSE"])
		{
			[self setValue:0.0f];
			return YES;	
		} 
		
		FSInterpreter* theInterpreter = [FSInterpreter interpreter];
		FSInterpreterResult* execResult = [theInterpreter execute: aValue];
		if([execResult isOK]){
			id fscriptReturned = [execResult result];
			if(fscriptReturned){
				// possible infine recursion loop here...
				return [self tryToSetValueWith:fscriptReturned];
			}
		}
	} else if([aValue respondsToSelector:@selector(floatValue)])
	{
		[self setValue:[aValue floatValue]];
		return YES;
		
	} else if([aValue isKindOfClass:[Block class]])
	{
		// possible infine recursion loop here...
		id fscriptReturned = [aValue value]; // execute the block
		return [self tryToSetValueWith:fscriptReturned];
	}	
	else if([aValue respondsToSelector:@selector(floatValue)])
	{
		[self setValue:[aValue floatValue]];
		return YES;
	}
	else if([aValue respondsToSelector:@selector(intValue)])
	{
		[self setValue:(float)[(id)aValue intValue]];
		return YES;
	}
	return NO;
}

#pragma mark accessor methods
//=========================================================== 
// - SHMutableFloat:
//=========================================================== 
- (SHMutableFloat*) SHMutableFloat {
	// we are mutable, so we must be careful to manipulate the values
	// only if that is what we are sure we should do. ie. we are an output attribute of an operator
	return [[self retain] autorelease];	
}

//=========================================================== 
// - SHNumber:
//===========================================================
- (SHNumber *) SHNumber {
	return [[[SHNumber alloc] initWithFloat: privateValue] autorelease];
}

//=========================================================== 
// - intValue:
//=========================================================== 
//- (int) intValue {
//	return round(value);
//}

//=========================================================== 
//  stringValue 
//=========================================================== 
- (NSString *) stringValue {
	return [[NSNumber numberWithFloat: privateValue] stringValue];
}

//=========================================================== 
//  floatValue 
//=========================================================== 
//- (float) floatValue
//{
//	return value;
//}

//=========================================================== 
//  displayObject 
//=========================================================== 
- (id) displayObject {
	return [self stringValue];
}

//=========================================================== 
//  fScriptSaveString 
//=========================================================== 
- (NSString*) fScriptSaveString
{	
	// save the value to val
	NSString* outputString = [NSString string];
	outputString = [outputString stringByAppendingFormat:@"dataValue := (%@ alloc initWithFloat:%f) autorelease.\n", [self class], privateValue];
	outputString = [outputString stringByAppendingString:@"dataValue . \n"];
	return outputString;
}


#pragma mark private methods

//=========================================================== 
//  setValue 
//=========================================================== 
- (void)setValue:(float) aValue {
	//  logInfo(@"SHNumber.m: in -setValue:, old value of value: %@, changed to: %@", value, aValue);
	privateValue = aValue;
//TODO
//	[self setIsUnset: privateValue==[NSNull null]];

}


@end
