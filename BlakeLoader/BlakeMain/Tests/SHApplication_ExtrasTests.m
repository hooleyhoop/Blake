//
//  SHApplication_ExtrasTests.m
//  BlakeLoader2
//
//  Created by steve hooley on 21/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface SHApplication_ExtrasTests : SenTestCase {
	
}

@end

@implementation SHApplication_ExtrasTests

/* Try to send a selector to our custom responder chain */
- (void)testSendSelectorReturningBool {
	// - (BOOL)sendSelectorReturningBool:(SEL)theAction
	
	// check that msg is sent to first responder that supports it
	BOOL result = [_gcc sendSelectorReturningBool:@selector(testSelectorReturningBool)];
	STAssertTrue(result==YES, @"it should have travelled up the responder chain till it found this");
	STAssertTrue(_stubView->testSelectorWasCalled==YES, @"it should have travelled up the responder chain till it found this");
}

/* Try to send a selector to our custom responder chain */
- (void)testSendSelector {
	// - (void)sendSelector:(SEL)theAction
	
	[_gcc sendSelector:@selector(testSelector)];
	STAssertTrue(_stubView->testSelectorWasCalled==YES, @"it should have travelled up the responder chain till it found this");
}


@end
