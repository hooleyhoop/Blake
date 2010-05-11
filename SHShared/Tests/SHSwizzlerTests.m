//
//  SHSwizzlerTests.m
//  Objc-2 swizzle test
//
//  Created by steve hooley on 02/08/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <Foundation/NSDebug.h>

@interface SHSwizzlerTests : SenTestCase {
	
    NSAutoreleasePool *_pool;
}

@end

@implementation SHSwizzlerTests

static int initFake_callCount=0;
- (id)initFake {
	initFake_callCount++;
	return self;
}

- (void)setUp {

    NSArray *piArgs = [[NSProcessInfo processInfo] arguments];
    for( id item in piArgs ){
        NSLog(@"ARG item %@", item);
    }
    
    _pool = [[NSAutoreleasePool alloc] init];

	if(NSDebugEnabled==NO)
		STFail(@"NSDebugEnabled must be set");
}

- (void)tearDown {
    
    [_pool drain];
}


- (void)sh_testBuildInvocationForSelector {
}

- (void)testBuildInvocationForOriginalSelector {
	// NSInvocation* buildInvocationForOriginalSelector( id self, SEL _cmd )

	STAssertNotNil( buildInvocationForOriginalSelector(self, @selector(testBuildInvocationForSelector)), @"don");
	STAssertThrows( buildInvocationForOriginalSelector(self, @selector(chicken)), @"don");
}

- (void)testFillInvocationsArgumentsFrom_va_list {
	// void fillInvocationsArgumentsFrom_va_list( va_list args, NSInvocation *invocation )
//	STFail(@"not done");
}

- (void)testCallOriginalMethod {
	// id callOriginalMethod( id self, SEL _cmd, va_list args )
//	STFail(@"not done");
}

- (void)testReplacementInit {
	// id replacementInit( id self, SEL _cmd, ... )
//	STFail(@"not done");
}

- (void)testReplacementDealloc {
	// id replacementDealloc( id self, SEL _cmd, ... )
//	STFail(@"not done");
}

- (void)testReplacementWithLog {
	// id replacementWithLog( id self, SEL _cmd, ... )
//	STFail(@"not done");
}

- (void)testSwapImplementationOfMethodNamed_ofClassNamed_withIMP {
	// + (void)swapImplementationOfMethodNamed:(NSString *)selString ofClassNamed:(NSString *)classString withIMP:(IMP)replacementMethodBody
//	STFail(@"not done");
}

- (void)test_insertDebugObjectCreationAfterInstanceMethod_ofClass {
	// + (void)insertDebugObjectCreationAfterInstanceMethod:(NSString *)selString ofClass:(NSString *)classString
//	STFail(@"not done");
}

- (void)test_insertDebugObjectDestructionBeforeInstanceMethod_ofClass {
	// + (void)insertDebugObjectDestructionBeforeInstanceMethod:(NSString *)selString ofClass:(NSString *)classString
//	STFail(@"not done");
}

- (void)test_insertDebugStringAfterInstanceMethod_ofClass {
	// + (void)insertDebugStringAfterInstanceMethod:(NSString *)selString ofClass:(NSString *)classString
//	STFail(@"not done");
}

- (void)test_insertDebugCodeForInitMethod_ofClass {
	// + (void)insertDebugCodeForInitMethod:(NSString *)selString ofClass:(NSString *)classString

	[SHSwizzler insertDebugCodeForInitMethod:@"initFake" ofClass:@"SHSwizzlerTests"];
	int preCallCount = initFake_callCount;
	SHSwizzlerTests *testInstance = [[SHSwizzlerTests alloc] initFake];
	int postCallCount = initFake_callCount;
	STAssertTrue(postCallCount==preCallCount+1, @"doh");
	[testInstance release];
}

@end
