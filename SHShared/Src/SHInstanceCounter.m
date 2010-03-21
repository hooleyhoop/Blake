//
//  SHInstanceCounter.m
//  Objc-2 swizzle test
//
//  Created by steve hooley on 01/08/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHInstanceCounter.h"

@implementation SHInstanceCounter

#ifdef DEBUG

static NSPointerArray *_allInstances=nil;
static NSPointerArray *_instancesSinceMark=nil;

static NSUInteger _instanceCount;

#pragma mark -
+ (void)initialize  {
	
	static BOOL isInitialized = NO;
	if(!isInitialized)	{
		isInitialized = YES;
        _instanceCount = 0;
	} 
}

+ (void)cleanUpInstanceCounter {
    
    if([_allInstances count]>0){
        [self printLeakingObjectInfo];
    } else {
        NSLog(@"** No Leaking Objects **");
	}
    [_allInstances release];
	[_instancesSinceMark release];
    _allInstances = nil;
	_instancesSinceMark = nil;
    _instanceCount = 0;
}

+ (void)objectCreated:(id)value {

    NSAssert1([self indexOf:value]==NSNotFound, @"HMM - we already contain this object %@", [self instanceDescription: value] );

	if(_allInstances==nil){
		_allInstances = [[NSPointerArray pointerArrayWithWeakObjects] retain];
	}
	
	[_allInstances addPointer:value];

	if(_instancesSinceMark)
		[_instancesSinceMark addPointer:value];
    _instanceCount++;
}

+ (void)objectDestroyed:(id)value {

	NSAssert( _allInstances!=nil, @"Have we cleaned up preaturely?" );

	NSUInteger index = [self indexOf: value];
    NSAssert1( index!=NSNotFound, @"HMM - destroying an object we dont contain - %@", [self instanceDescription: value]);

	[_allInstances removePointerAtIndex:index];

	if(_instancesSinceMark){
		NSUInteger index2 = [self indexOfSinceMark:value];
		if(index2!=NSNotFound)
			[_instancesSinceMark removePointerAtIndex:index2];
	}

    _instanceCount--;
}

/* Cache the description if the object is a hooleyObject */
+ (NSString *)instanceDescription:(id)value {
    
	if([value respondsToSelector:@selector(shInstanceDescription)]){
		NSString *desc = [value shInstanceDescription];
		if(desc==nil){
			desc = [NSString stringWithFormat: @"%@ - %p", NSStringFromClass([value class]), value];
			[value setShInstanceDescription:desc];
			return desc;
		}
	}
    NSString *output = [NSString stringWithFormat: @"%@ - %p", NSStringFromClass([value class]), value];
	return output;
}

+ (void)printSmallLeakingObjectInfo {
	
	for( id each in _allInstances ){
//		if (![each isKindOfClass:NSClassFromString(@"NSWindow")]) {
			NSLog(@"LEAKING %@", [self instanceDescription: each] );
//		}
	}
}

+ (void)printSmallLeakingObjectInfoSinceMark {

	for( id each in _instancesSinceMark ){
//		if (![each isKindOfClass:NSClassFromString(@"NSWindow")]) {
			NSLog(@"LEAKING %@", [self instanceDescription: each] );
//		}
	}
}

+ (void)printLeakingObjectInfo {
	
	NSLog(@"***** %i UNCLEAN OBJECTS ***** Thread %@ - is main %i", _instanceCount, [NSThread currentThread], [NSThread isMainThread]);
	
	for( id each in _allInstances ){
		NSLog(@"%@", [self instanceDescription: each] );
	}
	NSLog(@"***** END UNCLEAN OBJECTS *****");
}

+ (NSInteger)instanceCount {

	if(_allInstances==nil)
		return 0;
	NSAssert2( [_allInstances count]==_instanceCount, @"Instance count is out of sync (%i, %i)", [_allInstances count], _instanceCount );
	return _instanceCount;
}

+ (NSInteger)instanceCountSinceMark {
	
	if(_instancesSinceMark==nil)
		return 0;
	return [_instancesSinceMark count];
}

+ (void)newMark {
	
	if([_instancesSinceMark count]){
		NSLog(@"	Killing Leak pool %p", _instancesSinceMark);
		[_instancesSinceMark release];
		_instancesSinceMark = nil;
	}
	if(!_instancesSinceMark) {
		_instancesSinceMark = [[NSPointerArray pointerArrayWithWeakObjects] retain];
		NSLog(@"Creating Leak pool %p", _instancesSinceMark);
	}
}

+ (NSUInteger)indexOfSinceMark:(id)value {
	
	if(_instancesSinceMark==nil)
		return NSNotFound;
	
	NSUInteger i=0;
	for( id each in _instancesSinceMark ) {
		if(value==each)
			return i;
		i++;
	}
	return NSNotFound;
}

+ (NSUInteger)indexOf:(id)value {

    if(_allInstances==nil)
		return NSNotFound;

	NSUInteger i=0;
	for( id each in _allInstances ){
		if(value==each)
			return i;
		i++;
	}
	return NSNotFound;
}
#endif

@end
