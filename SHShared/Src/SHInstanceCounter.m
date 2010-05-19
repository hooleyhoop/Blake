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

static CFMutableArrayRef _allInstances;
static CFMutableArrayRef _instancesSinceMark;
static NSUInteger _instanceCount;

static const void* TTRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

#pragma mark -
+ (void)initialize  {
	
	static BOOL isInitialized = NO;
	if(!isInitialized)	{
		isInitialized = YES;
        _instanceCount = 0;
	} 
}

+ (void)cleanUpInstanceCounter {
    
    if([(NSMutableArray *)_allInstances count]>0){
        [self printLeakingObjectInfo];
    } else {
        NSLog(@"** No Leaking Objects **");
	}
    [(NSMutableArray *)_allInstances release];
	[(NSMutableArray *)_instancesSinceMark release];
    _allInstances = nil;
	_instancesSinceMark = nil;
    _instanceCount = 0;
}

+ (void)objectCreated:(id)value {

    NSAssert1([self indexOf:value]==NSNotFound, @"HMM - we already contain this object %@", [self instanceDescription: value] );

	if(_allInstances==nil){
		CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
		callbacks.retain = TTRetainNoOp;
		callbacks.release = TTReleaseNoOp;
		_allInstances = CFArrayCreateMutable( kCFAllocatorDefault, 0, &callbacks );
	}
	
	[(NSMutableArray *)_allInstances addObject:value];

	if(_instancesSinceMark)
		[(NSMutableArray *)_instancesSinceMark addObject:value];
    _instanceCount++;
}

+ (void)objectDestroyed:(id)value {

	NSAssert( _allInstances!=nil, @"Have we cleaned up preaturely?" );

	NSUInteger index = [self indexOf: value];
    NSAssert1( index!=NSNotFound, @"HMM - destroying an object we dont contain - %@", [self instanceDescription: value]);

	[(NSMutableArray *)_allInstances removeObjectAtIndex:index];

	if(_instancesSinceMark){
		NSUInteger index2 = [self indexOfSinceMark:value];
		if(index2!=NSNotFound)
			[(NSMutableArray *)_instancesSinceMark removeObjectAtIndex:index2];
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
	
	for( id each in (NSMutableArray *)_allInstances ){
//		if (![each isKindOfClass:NSClassFromString(@"NSWindow")]) {
			NSLog(@"LEAKING %@", [self instanceDescription: each] );
//		}
	}
}
//OBJC_EXPORT NSUInteger NSAutoreleasePoolCountForObject( id arg );

+ (void)printSmallLeakingObjectInfoSinceMark {

	for( id eachPtr in (NSMutableArray *)_instancesSinceMark ){
//		if( [eachPtr retainCount] - NSAutoreleasePoolCountForObject(eachPtr) )

//		if (![each isKindOfClass:NSClassFromString(@"NSWindow")]) {
				NSLog(@"LEAKING %@", [self instanceDescription: eachPtr] );
//		}
	}
}

//http://developer.apple.com/mac/library/documentation/cocoa/conceptual/Strings/Articles/formatSpecifiers.html
+ (void)printLeakingObjectInfo {
	
	NSLog(@"***** %lu UNCLEAN OBJECTS ***** Thread %@ - is main %d", _instanceCount, [NSThread currentThread], [NSThread isMainThread]);
	
	for( id each in (NSMutableArray *)_allInstances ){
		NSLog(@"%@", [self instanceDescription: each] );
	}
	NSLog(@"***** END UNCLEAN OBJECTS *****");
}

+ (NSInteger)instanceCount {

	if(_allInstances==nil)
		return 0;
	NSAssert2( [(NSMutableArray *)_allInstances count]==_instanceCount, @"Instance count is out of sync (%i, %i)", [(NSMutableArray *)_allInstances count], _instanceCount );
	return _instanceCount;
}


+ (NSInteger)instanceCountSinceMark {
	
	if(_instancesSinceMark==nil)
		return 0;

	NSUInteger objectsNotInReleasePoolCount = 0;
	for( id eachPtr in (NSMutableArray *)_instancesSinceMark ) {
//		if( [eachPtr retainCount] - NSAutoreleasePoolCountForObject(eachPtr) )
			objectsNotInReleasePoolCount++;
	}
	return objectsNotInReleasePoolCount;
}

+ (void)newMark {
	
	if([(NSMutableArray *)_instancesSinceMark count]){
		NSLog(@"	Killing Leak pool %p", _instancesSinceMark);
		[(NSMutableArray *)_instancesSinceMark release];
		_instancesSinceMark = nil;
	}
	if(!_instancesSinceMark) {
		CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
		callbacks.retain = TTRetainNoOp;
		callbacks.release = TTReleaseNoOp;
		_instancesSinceMark = CFArrayCreateMutable( kCFAllocatorDefault, 0, &callbacks );
		NSLog(@"Creating Leak pool %p", _instancesSinceMark);
	}
}

+ (NSUInteger)indexOfSinceMark:(id)value {
	
	if(_instancesSinceMark==nil)
		return NSNotFound;
	
	NSUInteger i=0;
	for( id each in (NSMutableArray *)_instancesSinceMark ) {
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
	for( id each in (NSMutableArray *)_allInstances ){
		if(value==each)
			return i;
		i++;
	}
	return NSNotFound;
}
#endif

@end
