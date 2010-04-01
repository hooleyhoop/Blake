//
//  NSInvocation_testHelpersTests.m
//  SHShared
//
//  Created by steve hooley on 14/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import <FScript/Fscript.h>
#import "NSInvocation(ForwardedConstruction).h"

@interface NSInvocation_testHelpersTests : SenTestCase {
	
}

@end

@implementation NSInvocation_testHelpersTests

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testFScript_Block_Demo {
	
	NSArray *anArray = [[NSArray arrayWithObjects:@"one", @"two", nil] retain];
	
	// single block
	FSBlock *test = [@"[:arg1| (arg1 objectAtIndex:0) uppercaseString]" asBlock];
	NSString *really = [test value:anArray];
	STAssertTrue( [really isEqualToString:@"ONE"], @"doh");
	
	// double block
	FSBlock *test2 = _BLOCK(@"[:arg1 :arg2| arg1 value: arg2]");
	NSString *really2 = [test2 value:test value:anArray];
	STAssertTrue( [really2 isEqualToString:@"ONE"], @"doh");

	[anArray release];
}

- (void)testIsTestMethod {
	//- (BOOL)isTestMethod
	
	NSInvocation *testInvPass;
	[[NSInvocation makeRetainedInvocationWithTarget:self invocationOut:&testInvPass] testIsTestMethod];
	STAssertTrue( [testInvPass isTestMethod], @"oops");
	
	NSInvocation *testInvFail;
	[[NSInvocation makeRetainedInvocationWithTarget:self invocationOut:&testInvFail] setUp];
	STAssertFalse( [testInvFail isTestMethod], @"oops");
}


// simple case - try to call this
static BOOL _completionMethodWasCalled;
- (void)_testPrependSelector {
	_completionMethodWasCalled = YES;
}

// make an Invocation for this, top and tail it with "_", try to use it to call _bullshit1_
- (NSString *)bullshit1:(NSString *)value {
	
	[NSException raise:@"we are not going to call this" format:@""];
	return nil;
}

- (NSString *)_bullshit1:(NSString *)value {
	
	NSParameterAssert([value isEqualToString:@"antelope"]);
	return @"succzzzzes!";
}

- (void)testPrependSelector {
// - (NSInvocation *)prependSelector:(NSString *)value
	
	NSInvocation *testInvPass;
	[[NSInvocation makeRetainedInvocationWithTarget:self invocationOut:&testInvPass] testPrependSelector];
	NSInvocation *testCompletionInv = [testInvPass prependSelector:@"_"];
	[testCompletionInv invoke];
	STAssertTrue(_completionMethodWasCalled, @"yaya");
	
	// try with an argument
	NSInvocation *testInvPass2;
	[[NSInvocation makeRetainedInvocationWithTarget:self invocationOut:&testInvPass2] bullshit1:@"antelope"];
	NSInvocation *testCompletionInv2 = [testInvPass2 prependSelector:@"_"];
	[testCompletionInv2 invoke];

	id returnVal = nil;
	[testCompletionInv2 getReturnValue:&returnVal];
	STAssertTrue([returnVal isEqualToString:@"succzzzzes!"], @"doh %@", returnVal);
}



@end
