//
//  NSResponder_ExtrasTests.m
//  SHShared
//
//  Created by steve hooley on 09/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import <Appkit/NSView.h>
#import "NSResponder_Extras.h"

@interface NSResponder_ExtrasTests : SenTestCase {
	
}

@end


@implementation NSResponder_ExtrasTests

- (void)testInsertIntoResponderChainAbove {
	//+ (void)insert:(NSResponder *)newItem intoResponderChainAbove:(NSResponder *)existingItem
	
	OCMockObject *newItem = MOCK(NSView);
	OCMockObject *existingItem = MOCK(NSView);
	OCMockObject *existingParent = MOCK(NSView);

	[[[existingItem expect] andReturn:existingParent] nextResponder];
	[[existingItem expect] setNextResponder:(id)newItem];
	[[newItem expect] setNextResponder:(id)existingParent];

	[NSResponder insert:(id)newItem intoResponderChainAbove:(id)existingItem];
	
	[newItem verify];
	[existingItem verify];
}

@end
