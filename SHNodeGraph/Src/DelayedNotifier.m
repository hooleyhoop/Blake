//
//  DelayedNotifier.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "DelayedNotifier.h"
#import "AllChildrenFilter.h"
#import "DelayedNotificationCoalescer.h"

@implementation DelayedNotifier

- (id)initWithController:(DelayedNotificationCoalescer *)value {

	self = [super init];
	if(self){
		_controller = value;
	}
	return self;
}

// runloop callback
static void cf_observer_delayedNotification( CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info ) {
	
	NSDictionary *data = (NSDictionary *)info;
	AllChildrenFilter *filter = (AllChildrenFilter *)[data objectForKey:@"key1"];
	NSString *methodName = (NSString *)[data objectForKey:@"key2"];
	DelayedNotifier *self = (DelayedNotifier*)[data objectForKey:@"key3"];
	
	NSCAssert( filter, @"dum dum" );
	NSCAssert( methodName, @"dum dum" );	
	NSCAssert( self->_controller, @"dum dum" );
	
	//[filter performSelector:NSSelectorFromString(methodName)];
	objc_msgSend(filter,NSSelectorFromString(methodName));
	 
	[self->_controller notificationDidFire_callback];
}

#define RUNLOOPMODE kCFRunLoopCommonModes

/* add a callback to the runloop with our callback objects in an info dictionary */
- (void)doDelayedNotification:(id)callBackObject callbackMethod:(SEL)callbackMethod {

	NSAssert(_data==nil, @"hmm");
	NSAssert(_observer==nil, @"hmm");
	
	_data = [[NSDictionary dictionaryWithObjectsAndKeys:	callBackObject, @"key1", 
															NSStringFromSelector(callbackMethod), @"key2", 
															self, @"key3", 
															nil] retain];
	
	CFRunLoopObserverContext context = {0, _data, NULL, NULL, NULL};
	_observer = CFRunLoopObserverCreate( kCFAllocatorDefault, kCFRunLoopExit, NO, 0, &cf_observer_delayedNotification, &context);
	NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
	CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
	
	/* This is REALLY IMPORTANT
	 * If we use kCFRunLoopDefaultMode it will behave 'normally'
	 * If i use kCFRunLoopCommonModes it will work even when we are in a mouse drag and have hijacked the runloop, this seems better - 
	 * But i don't understand what is happening behind the scenes, which worries me
	 */
	
	CFRunLoopAddObserver( cfLoop, _observer, RUNLOOPMODE );
}

- (void)cleanupAfterFire {
	
	NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
	CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
	CFRunLoopRemoveObserver(cfLoop, _observer, RUNLOOPMODE);
	CFRelease(_observer);
	_observer = nil;
	
	NSAssert(_data, @"hmm");
	[_data release];
	_data = nil;
}

- (void)fireOveride {
	cf_observer_delayedNotification( _observer, kCFRunLoopEntry, _data );
}

@end
