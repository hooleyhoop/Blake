//
//  DelayedNotifier.h
//  SHNodeGraph
//
//  Created by steve hooley on 27/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@class DelayedNotificationCoalescer;

@interface DelayedNotifier : _ROOT_OBJECT_ {
	
	DelayedNotificationCoalescer	*_controller;
	NSDictionary					*_data;
	CFRunLoopObserverRef			_observer;
}

- (id)initWithController:(DelayedNotificationCoalescer *)value;

- (void)doDelayedNotification:(id)callBackObject callbackMethod:(SEL)callbackMethod;

- (void)cleanupAfterFire;

- (void)fireOveride;

@end
