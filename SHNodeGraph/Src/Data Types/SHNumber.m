 //
//  SHNumber.m
//  InterfaceTest
//
//  Created by Steve Hooley on Thu Jan 08 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

#import "SHNumber.h"
#import "SHMutableBool.h"
#import "SHAbstractDataType.h"


// globals for this file
static NSString*	_willAsk;
static NSArray*		_willAnswer;

/*
 *
*/
@interface SHNumber (PrivateMethods)
	- (void)setPrivateValue:(id) aValue;
@end



/*
 * any data type will only ever ask a connected datatype for one type of data (string, number, etc.)
 * however, a single data type might respond to more than one request (string and number, etc.)
 *
*/
@implementation SHNumber

#pragma mark -
#pragma mark class methods
+ (void)initialize {

    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        _willAsk		= @"SHNumber";
        _willAnswer		= [[NSArray arrayWithObjects:@"SHNumber", @"SHMutableBool", @"mockDataTypeValue", nil] retain];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"what is going on with these multiple initializes?"];
    }
}

+ (NSString*)willAsk {
	return _willAsk;
}

+ (NSArray*)willAnswer {
	return _willAnswer;
}

+ (id)dataTypeFromDisplayObject:(id)stringVal {
	return [self numberWithObject:stringVal];
}

+ (id)numberWithObject:(id)ob {
	return [[[SHNumber alloc] initWithObject:ob] autorelease];
}

+ (id)numberWithInt:(int)intVal {
	return [[[SHNumber alloc] initWithInt:intVal] autorelease];
}

+ (id)numberWithFloat:(float)floatVal {
	return [[[SHNumber alloc] initWithFloat:floatVal] autorelease];
}

+ (id)numberWithBool:(BOOL)boolVal {
	return [[[SHNumber alloc] initWithBool:boolVal] autorelease];
}

#pragma mark init methods

- (id)init {
	return [self initWithObject:[NSNull null]];
}

/* init with an initial value from your custom operator */
// designated initializer
- (id)initWithObject:(id)ob
{
    if( (self=[super init])!= nil )
	{
		if(ob==nil){
			[self setPrivateValue: [NSNull null]];
			
		// eek! NSNull==NSUnset. i cant see this changing so im not going to bother checking both. so lazy! writing this comment took much longer.
		} else if(ob==[NSNull null]){ 
			[self setPrivateValue: [NSNull null]];
			
		} else if([ob isKindOfClass:[NSNumber class]]){
			[self setPrivateValue: ob];
			
		} else if([ob isKindOfClass:[SHNumber class]]){
			if([ob isUnset])
				[self setPrivateValue:[NSNull null]];
			else
				[self setPrivateValue: [NSNumber numberWithFloat:[ob floatValue]]];
			
		} else if([ob respondsToSelector:@selector(floatValue)]){
			NSNumber* initialValue = [NSNumber numberWithFloat:[ob floatValue]];
			[self setPrivateValue: initialValue];
		}
	}
	NSAssert(privateValue!=nil, @"value should never be nil");
	return self;
}

- (id)initWithFloat:(float)floatVal
{
	NSNumber* initialValue = [NSNumber numberWithFloat:floatVal];
	return [self initWithObject: initialValue];
}

- (id)initWithInt:(int)intVal {
	NSNumber* initialValue = [NSNumber numberWithInt:intVal];
	return [self initWithObject: initialValue];
}

- (id)initWithBool:(BOOL)boolVal {
	NSNumber* initialValue = [NSNumber numberWithBool:boolVal];
	return [self initWithObject: initialValue];
}

- (void)dealloc {
	[self setPrivateValue: nil];
    [super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual
- (id)copyWithZone:(NSZone *)zone
{
	almost certainly wrong! we need to super copy

	// logInfo(@"SHNumber.m: copyWithZone");
	NSAssert(privateValue!=nil, @"value should never be nil");
    id copy = [[[self class] allocWithZone:zone] initWithObject: privateValue];
    return copy;
}

// why is this in every class? DRY this is a real mess

- (id) duplicate
{
	logWarning(@"BEWARE - DOES NOT RETURN AUTORELEASED OBJECT!");
	return [self copy];
}

//=========================================================== 
// - isEqual:
//=========================================================== 
- (BOOL)isEqual:(id)anObject
{
	if([self class]==[anObject class])
	{
		id obPrivate = ((SHNumber*)anObject)->privateValue;
		if([privateValue isKindOfClass:[NSNumber class]] && [obPrivate isKindOfClass:[NSNumber class]] )
		{
			if( [privateValue isEqualToNumber: obPrivate] )
				return YES;
		} else if([privateValue isKindOfClass:[NSNull class]] && [obPrivate isKindOfClass:[NSNull class]]){
			return YES;
		} else {
			return [privateValue isEqual: obPrivate];
		}
	}
	return NO;
}


#pragma mark action methods

#pragma mark accessor methods

- (SHNumber *)SHNumber {
	return [[self retain] autorelease];
}

- (SHMutableBool *)SHMutableBool {
	return [[[SHMutableBool alloc] initWithBool:[privateValue boolValue] ] autorelease];
}

- (id)mockDataTypeValue {
	return [[[NSClassFromString(@"mockDataType") alloc] initWithObject: privateValue] autorelease];
}



//=========================================================== 
//  stringValue 
//=========================================================== 
- (NSString *)stringValue {
	//return _displayString;
	return [privateValue stringValue];
}

/* must be able to return 'unset' */
// get rid of this - operators shouldnt access workings - SHNsumber should have an add method or something? maybe
- (float) floatValue {
//if(isUnset==YES)
		NSAssert(isUnset==NO, @"shouldnt be asking for unset value");
	float fv = [privateValue floatValue];
	return fv;
}

//=========================================================== 
//  intValue 
//=========================================================== 
//- (int) intValue {
//	return [value intValue];
//}

//=========================================================== 
//  boolValue 
//=========================================================== 
//- (BOOL) boolValue {
//	return [value boolValue];
//}

//=========================================================== 
//  displayObject 
//=========================================================== 
- (id)displayObject {
	return [self stringValue];
}

//=========================================================== 
//  theEditView 
//=========================================================== 
//- (NSView*) theEditView {
//	if(_theEditView==nil){
//		[_SHNumberNib instantiateNibWithOwner:self topLevelObjects:nil];
//		NSAssert(_theEditView != nil, @"IBOutlets were not set correctly in SHNumber.nib");
//	}
	
	// should we dispose of these when we are done? maybe we should…
	
//	return _theEditView;
//}

//=========================================================== 
//  parentAttr 
//=========================================================== 
//15/02/2006 - (NSObject *) parentAttr { return _parentAttr; }
//- (void) setParentAttr: (NSObject *) aParentAttr {
    //logInfo(@"in -setParentAttr:, old value of _parentAttr: %@, changed to: %@", _parentAttr, aParentAttr);
//    if (_parentAttr != aParentAttr) {
//        [aParentAttr retain];
 //       [_parentAttr release];
 //       _parentAttr = aParentAttr;
//    }
//}

//=========================================================== 
//  value 
//=========================================================== 
// - (NSNumber *) value { return value; }


//=========================================================== 
//  fScriptSaveString 
//=========================================================== 
- (NSString *)fScriptSaveString
{	
	// save the value to val
	NSString* outputString	= [NSString string];
	NSAssert(privateValue !=nil, @"value should never be nil");
	if((NSObject *)privateValue == [NSNull null])
		outputString = [outputString stringByAppendingFormat:@"dataValue := (%@ alloc init) autorelease.\n", [self class]];
	else
		outputString = [outputString stringByAppendingFormat:@"dataValue := (%@ alloc initWithFloat:%f) autorelease.\n", [self class], [privateValue floatValue]];
	outputString = [outputString stringByAppendingString:@"dataValue . \n"];
	return outputString;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"SHNumber %@", [self stringValue]];
}
#pragma mark private methods

- (void)setPrivateValue:(id)aValue {
  //  logInfo(@"SHNumber.m: in -setPrivateValue:, old value of value: %@, changed to: %@", value, aValue);
	
    if( privateValue!=aValue ) 
	{
        [privateValue release];
        privateValue = [aValue retain];
		
		[self setIsUnset: ((id)privateValue==[NSNull null]) ];
    }
}


@end