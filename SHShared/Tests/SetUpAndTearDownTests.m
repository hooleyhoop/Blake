//
//  SetUpAndTearDownTests.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 3/2/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>


@interface aaaaaSetUpAndTearDownTests : SenTestCase {
	
}

@end

@implementation aaaaaSetUpAndTearDownTests

+ (void)setup {
	Class SwizzleListClass = NSClassFromString(@"SwizzleList");
	[SwizzleListClass performSelector:@selector(setupSwizzles)];
}

+ (void)teardown {
	Class SwizzleListClass = NSClassFromString(@"SwizzleList");
	[SwizzleListClass performSelector:@selector(tearDownSwizzles)];
}

@end

// static NSMutableDictionary *_mypools=nil;
static CFMutableDictionaryRef _mypools=nil;

@implementation SenTestRun (Hack)

// +load may be a good place to do this. Interstingly +load is called on all classes AND all categories. 
+ (void)initialize {
	
	static BOOL isInited=NO;
	if(!isInited)
	{
		isInited=YES;
		NSString *forceLoad = [SenTestRun description];
		NSLog(@"we need this.. to force loading. %@", forceLoad );
		
		Class targetClass2 = NSClassFromString(@"SenTestRun");
		SEL targetSEL2 = NSSelectorFromString(@"start");
		SEL targetSEL3 = NSSelectorFromString(@"stop");
		SEL replacementSEL2 = NSSelectorFromString(@"my_start");
		SEL replacementSEL3 = NSSelectorFromString(@"my_stop");

		Method methodToReplace2 = class_getInstanceMethod( targetClass2, targetSEL2 );
		Method replacementMethod2 = class_getInstanceMethod( targetClass2, replacementSEL2 );
		method_exchangeImplementations( methodToReplace2, replacementMethod2 );
		
		Method methodToReplace3 = class_getInstanceMethod( targetClass2, targetSEL3 );
		Method replacementMethod3 = class_getInstanceMethod( targetClass2, replacementSEL3 );
		method_exchangeImplementations( methodToReplace3, replacementMethod3 );
		
		// _mypools = [[NSMutableDictionary dictionaryWithCapacity:3] retain];
		_mypools = CFDictionaryCreateMutable( kCFAllocatorDefault, 0, NULL, NULL );
	}
}

// called before each test - recursively?
- (void)my_start {

	// SentestCase autoreleasePool doesn't cleanup before Hooley leak checker runs - i need to insert a pool here
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	[_mypools setObject:[NSValue valueWithNonretainedObject:pool] forKey:[NSValue valueWithNonretainedObject:self]];
	CFDictionaryAddValue( _mypools, self, pool );
		
	Class SHInstanceCounterClass = NSClassFromString(@"SHInstanceCounter");
	[SHInstanceCounterClass performSelector:@selector(newMark)];
	[self my_start];
	
	[pool release];
}

// called after each test
- (void)my_stop {
	
	[self my_stop];
	
//	NSAutoreleasePool *pool = [[_mypools objectForKey:[NSValue valueWithNonretainedObject:self]] nonretainedObjectValue];
//	[_mypools removeObjectForKey:[NSValue valueWithNonretainedObject:self]];
//	[pool release];
	
	NSAutoreleasePool *pool = (NSAutoreleasePool *)CFDictionaryGetValue( _mypools, self );
	NSAssert( pool, @"what?");
	CFDictionaryRemoveValue( _mypools, self );
	pool = nil;

	Class SHInstanceCounterClass = NSClassFromString(@"SHInstanceCounter");
	if( [SHInstanceCounterClass performSelector:@selector(instanceCountSinceMark)]>0 )
	{
		NSLog(@"%@", [test description]);
		[SHInstanceCounterClass performSelector:@selector(printSmallLeakingObjectInfoSinceMark)];

		//		NSLog( @"%@", NSStringFromClass([test class]));
		//		[SHInstanceCounter printLeakingObjectInfo];
	}
}
@end

@implementation SenTestProbe (Hack)

// Called first. Entry point that will set up swizzles
+ (void)initialize {

	BOOL isTesting = [SenTestProbe isTesting];
	NSLog(@"we need this.. to force loading. %i", isTesting );
	
	Class targetClass = NSClassFromString(@"SenTestProbe");
	SEL targetSEL = NSSelectorFromString(@"runTests:");
	SEL replacementSEL = NSSelectorFromString(@"my_runTests:");
	Method methodToReplace = class_getClassMethod( targetClass, targetSEL );
	Method replacementMethod = class_getClassMethod( targetClass, replacementSEL );
	method_exchangeImplementations( methodToReplace, replacementMethod );
}

OBJC_EXPORT void addDestructorCallback(  Class classValue, SEL callback ) __attribute__((weak_import));

+ (void)my_runTests:(id)fp8 {
	
	[aaaaaSetUpAndTearDownTests setup];

	if(addDestructorCallback)
		addDestructorCallback( [self class], @selector(releasePoolCheck) );
	
	// this never returns
	[self my_runTests:fp8];
	
	/* This is never reached */
	// [aaaaaSetUpAndTearDownTests teardown];
}

+ (void)releasePoolCheck {
	
//	NSCAssert( 0==[_mypools count], @"fuck!" );
//	[_mypools release];

	NSCAssert( 0==CFDictionaryGetCount(_mypools), @"fuck!" );
	CFRelease(_mypools);
}

// we already have a destructor inSHShared
//__attribute__((destructor)) void onExit(void) {	
// [self releasePoolCheck];
// [aaaaaSetUpAndTearDownTests teardown];
//}

	
	
	
	
	
	
	
	
@end

