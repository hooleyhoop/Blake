//
//  DelayedNotificationCoalescerTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "DelayedNotificationCoalescer.h"
#import "DelayedNotifier.h"

@interface DelayedNotificationCoalescerTests : SenTestCase {
	
	OCMockObject					*_mockFilter;
	DelayedNotificationCoalescer	*_delayedNotificationCoalescer;
}

@end

@implementation DelayedNotificationCoalescerTests

- (void)setUp {
    
}

- (void)tearDown {
    
}

- (void)testSelectionStuff {

	_mockFilter = MOCK(AllChildrenFilter);
	_delayedNotificationCoalescer = [[DelayedNotificationCoalescer alloc] initWithFilter:(id)_mockFilter mode:@"SelectionChanged"];

	[_delayedNotificationCoalescer changedSelectedNodeIndexesFrom:[NSIndexSet indexSet] to:[NSIndexSet indexSetWithIndex:1]];
	[_delayedNotificationCoalescer changedSelectedNodeIndexesFrom:[NSIndexSet indexSetWithIndex:1] to:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,2)]];
	
	STAssertTrue([_delayedNotificationCoalescer.selectedNodeIndexes	isEqualToIndexSet:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,2)]], @"doh");
	STAssertTrue([_delayedNotificationCoalescer.oldSelectedNodeIndexes	isEqualToIndexSet:[NSIndexSet indexSet]], @"doh");
	
	[_delayedNotificationCoalescer release];
}

@end
