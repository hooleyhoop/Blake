//
//  HooSenTestProbe.m
//  InAppTests
//
//  Created by steve hooley on 07/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "HooSenTestProbe.h"
#import <Appkit/NSApplication.h>
@class SenTestCaseSuite;

@interface SenTestCase (HooSenTestCase)

- (void)logException:(NSException *)anException;

@end

@interface SenTestCase (HooSenTestCase2)

- (void)setRun:(id)value;

@end

@implementation SenTestCase (HooSenTestCase2)

- (void)setRun:(id)value {

	if(run!=value){
		[run release];
		run = [value retain];
	}
}

- (void)performTest_begin:(SenTestRun *)testCaseRun {
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	NSException *exception = nil;
	[self setRun:testCaseRun];
	[self setUp];
	[testCaseRun start];
	@try {
		NSInvocation *actualTest = [self invocation];
		//									id target  = [actualTest target];
		//									NSString *targetSel = NSStringFromSelector([actualTest selector]);
		[actualTest invoke];
	}
	@catch (NSException *anException) {
		exception = [[anException retain] autorelease];
	}
//	[testCaseRun stop];
//	[self tearDown];
	if (exception != nil) {
		[self logException:exception];
	}

}

- (void)performTest_end:(SenTestRun *)testCaseRun {
// the order has to be swapped around a bit because of exception
	[testCaseRun stop];
	[self tearDown];
//	if (exception != nil) {
//		[self logException:exception];
//	}
	[self setRun:nil];
	//	[pool release];
}

@end

@implementation HooSenTestProbe

+ (void)runTestsInBundle:(NSBundle *)aBundle {
	
	NSParameterAssert(aBundle);
	BOOL shouldTerminate = YES;
	
	SenTestSuite *mySuiteOfTests = [SenTestSuite testSuiteForBundlePath:[aBundle bundlePath]];
	SenTestSuiteRun *testSuiteRun = [SenTestSuiteRun testRunWithTest:mySuiteOfTests];
	// > [mySuiteOfTests performTest:testSuiteRun];
	{
		[mySuiteOfTests setUp];
		[testSuiteRun start];
		NSArray *tests = [mySuiteOfTests tests];
		for( id eachTestCaseSuite in tests ) // SenTestCaseSuite
		{
			SenTestSuiteRun *testRun;
		// > testRun = [eachTestCaseSuite run];
			{
				testRun = [SenTestSuiteRun testRunWithTest:(id)eachTestCaseSuite];
				// > [eachTestCaseSuite performTest:testRun];
				{
					[eachTestCaseSuite setUp];
					[testRun start];
					NSArray *tests2= [eachTestCaseSuite tests];
					for( SenTestCase *eachTestCase in tests2 ) 
					{
						SenTestCaseRun *testCaseRun;
						// > testCaseRun = [eachTestCase run];
						{
							testCaseRun = [SenTestCaseRun testRunWithTest:eachTestCase];
							// > [eachTestCase performTest:testCaseRun];
							{
								NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
								NSException *exception = nil;
								[eachTestCase setRun:testCaseRun];
								[eachTestCase setUp];
								[testCaseRun start];
								@try {
									NSInvocation *actualTest = [eachTestCase invocation];
//									id target  = [actualTest target];
//									NSString *targetSel = NSStringFromSelector([actualTest selector]);
									[actualTest invoke];
								}
								@catch (NSException *anException) {
									exception = [[anException retain] autorelease];
								}
								[testCaseRun stop];
								[eachTestCase tearDown];
								if (exception != nil) {
									[eachTestCase logException:exception];
								}
								[eachTestCase setRun:nil];
								[pool release];
							}
							// return testCaseRun;
						}
						[(SenTestSuiteRun *)testRun addTestRun:testCaseRun];
					}
					[testRun stop];
					[eachTestCaseSuite tearDown];
				}
				//return testRun;
			}
			[(SenTestSuiteRun *)testSuiteRun addTestRun:testRun];
		}
		[testSuiteRun stop];
		[mySuiteOfTests tearDown];
	}
	BOOL hasFailed = ![testSuiteRun hasSucceeded];
	NSLog(@"Tests Failed? %@", hasFailed ? @"YES" : @"NO");
	
	if(shouldTerminate)
		[[NSApplication sharedApplication] terminate:self];
}

@end


@implementation SenTestSuite (HooSenTestSuite)

- (NSMutableArray *)tests {
	return tests;
}

@end


@implementation SenTestSuiteRun (HooSenTestSuiteRun)

- (void)printHasSucceeded {

	BOOL result = [self hasSucceeded];
	NSLog(@"Has succeeded %i", result);
}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//
//	NSLog(@"forwardingTargetForSelector %@", NSStringFromSelector(aSelector));
//	return nil;
//}
//
//+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
//	
//	NSLog(@"instanceMethodSignatureForSelector %@", NSStringFromSelector(aSelector));
//	return nil;
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//
//	NSLog(@"methodSignatureForSelector %@", NSStringFromSelector(aSelector));
//	NSMethodSignature *ms = [super methodSignatureForSelector:aSelector];
//	if(!ms)
//		NSLog(@"what the!");
//	return ms;
//}
//
//- (void)forwardInvocation:(NSInvocation *)forwardedInvocation {
//	
//	NSLog(@"forwardInvocation %@", forwardedInvocation);
//}


@end