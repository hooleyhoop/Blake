//
//  DelayedNotifierTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "DelayedNotificationCoalescer.h"
#import "DelayedNotifier.h"

@interface DelayedNotifierTests : SenTestCase {
	
	OCMockObject					*_mockController;
	DelayedNotifier					*_notifier;
	NSUInteger						_fireCount;
}

@end

@implementation DelayedNotifierTests

- (void)setUp {
    
	_mockController = [MOCK(DelayedNotificationCoalescer) retain];
	_notifier = [[DelayedNotifier alloc] initWithController:(id)_mockController];
}

- (void)tearDown {
    
	[_notifier release];
	[_mockController release];
}

- (void)notificationCallback {
	_fireCount++;
}

- (void)testFire {
	
	[[_mockController expect] notificationDidFire_callback];

	[_notifier doDelayedNotification:self callbackMethod:@selector(notificationCallback)];
	[_notifier fireOveride];
	STAssertTrue( 1==_fireCount, @"doh");
	[_notifier cleanupAfterFire];
	
	[_mockController verify];
}

@end
