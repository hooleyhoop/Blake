//
//  SHMutableBool.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHMutableBool.h"
#import "SHNumber.h"
#import <FScript/FScript.h>

// globals for this file
static NSString*	_willAsk;
static NSArray*		_willAnswer;

/*
 *
*/
@interface SHMutableBool (PrivateMethods)
	- (void) setValue:(id) aValue;
@end

/*
 * any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
 * however, a single data type might respond to more than one request (string and number, etc.)
 *
*/
@implementation SHMutableBool

#pragma mark -
#pragma mark class methods

+ (void)initialize {
    
    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        isInitialized = YES;
        _willAsk = @"SHMutableBool";
        _willAnswer = [[NSArray arrayWithObjects:@"SHMutableBool", @"SHNumber", nil] retain];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"what is going on with these multiple initializes?"];
    }
}


+ (NSString *) willAsk {
	return _willAsk;
}


+ (NSArray *)willAnswer {
	return _willAnswer;
}


+ (id)dataTypeFromDisplayObject:(id)stringVal
{
	id adt = [[[self class] alloc] initWithObject:stringVal];
	return [adt autorelease];
}

#pragma mark init methods

- (id)init
{
    if ((self = [super init]) != nil) {
		[self setValue:[NSNull null]];
	}
	return self;
}

/* init with an initial value from your custom operator */
- (id)initWithObject:(id)ob
{
	id newOb = [self init];
	[newOb tryToSetValueWith:ob];
	return newOb;
}

- (id)initWithBool:(BOOL)boolVal
{
    if ((self = [self init]) != nil) {
		[self setBoolValue: boolVal];
	}
	return self;
}

//=========================================================== 
// - initWithFloat:
//=========================================================== 
- (id) initWithFloat:(float)floatVal
{
	return [self initWithBool: [[NSNumber numberWithInt:round(floatVal)] boolValue]];
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
	[self setValue: nil];
    [super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual

/* Must be a deep copy - copy must be independant from original */
- (id)copyWithZone:(NSZone *)zone {
	
	almost certainly wrong! we need to super copy

    id copy = [[[self class] allocWithZone: zone] initWithBool: [privateValue boolValue]];
    return copy;
}

// why is this in every class?

- (id)duplicate {
	logWarning(@"BEWARE - DOES NOT RETURN AUTORELEASED OBJECT!");
	return [self copy];
}

- (BOOL)isEqual:(id)anObject
{
	if([self class]==[anObject class])
		if( privateValue == ((SHMutableBool*)anObject)->privateValue )
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
- (BOOL)tryToSetValueWith:(id)aValue
{	
	if([aValue isKindOfClass:[NSString class]])
	{
		aValue = [aValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		// is it a number in a string?
		NSNumber* result;
		BOOL flag = [aValue isNumber:&result];
		if(flag){
			[self setValue: [NSNumber numberWithInt:round([aValue doubleValue])]];
			return YES;
		}

		
		// is the string a YES or a NO
		NSString* uppercaseVersion = [aValue uppercaseString];
		if([uppercaseVersion isEqualToString:@"YES"] || [uppercaseVersion isEqualToString:@"TRUE"])
		{
			[self setBoolValue:YES];
			return YES;	
		} else if([uppercaseVersion isEqualToString:@"NO"] || [uppercaseVersion isEqualToString:@"FALSE"])
		{
			[self setValue:NO];
			return YES;	
		} 
		
		FSInterpreter* theInterpreter = [FSInterpreter interpreter];
		FSInterpreterResult* execResult=nil;
		
		@try {
			execResult = [theInterpreter execute: aValue];
		} @catch (NSException *exception) {
			logError(@"SHMutableBool.m: ERROR Caught %@: %@", [exception name], [exception reason]);
		} @finally {
			/* we really must clean up here */
			logError(@"where next?");
		}
			
		if([execResult isOK])
		{
			id fscriptReturned = [execResult result];
			if(fscriptReturned){
				// possible infine recursion loop here...
				return [self tryToSetValueWith:fscriptReturned];
			}
		}
	} else if([aValue isKindOfClass:[NSNumber class]])
	{
		[self setValue: [NSNumber numberWithInt:round([aValue floatValue])]];
		return YES;
	} else if([aValue isKindOfClass:[Block class]])
	{
		// possible infine recursion loop here...
		id fscriptReturned = [aValue value]; // execute the block
		return [self tryToSetValueWith:fscriptReturned];
	}
	
	if([aValue respondsToSelector:@selector(boolValue)])
	{
		[self setValue:[NSNumber numberWithBool:[aValue boolValue]]];
		return YES;
		
	} 
	else if([aValue respondsToSelector:@selector(floatValue)])
	{
		[self setValue: [NSNumber numberWithInt:round([aValue floatValue])]];
		return YES;
	}
	else if([aValue respondsToSelector:@selector(intValue)])
	{
		[self setValue: [NSNumber numberWithInt:[aValue intValue]]];
		return YES;
	}
	return NO;
}

#pragma mark accessor methods
//=========================================================== 
// - SHMutableBool:
//=========================================================== 
- (SHMutableBool*) SHMutableBool {
	// we are mutable, so we must be careful to manipulate the values
	// only if that is what we are sure we should do. ie. we are an output attribute of an operator
	return [[self retain] autorelease];	
}

- (SHNumber *)SHNumber {
	return [[[SHNumber alloc] initWithObject: privateValue] autorelease];
}

- (BOOL)boolValue {
	return [privateValue boolValue];
}

- (void)setBoolValue:(BOOL)val {
	privateValue = [NSNumber numberWithBool:val];
}

- (NSString *)stringValue {
	if( [privateValue boolValue] )
		return @"YES";
	return @"NO";
}


- (float)floatValue {
	return [privateValue floatValue];
}

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
	outputString = [outputString stringByAppendingFormat:@"dataValue := (%@ alloc initWithBool:%@) autorelease .\n", [self class], [self stringValue]];
	outputString = [outputString stringByAppendingString:@"dataValue . \n"];
	return outputString;
}


#pragma mark private methods

- (id)value { 
	return privateValue; 
}

- (void)setValue:(id)aValue {
  //  logInfo(@"SHNumber.m: in -setValue:, old value of value: %@, changed to: %@", value, aValue);
	
	
	if([aValue isKindOfClass:[NSNumber class]]){
		
		
	} else if([aValue isKindOfClass:[NSString class]]){
		logWarning(@"wait - who setting string?");
	}
	
    if (privateValue != aValue) {
        [privateValue release];
        privateValue = [aValue retain];
		
		[self setIsUnset: privateValue==[NSNull null]];
    }
}



@end
