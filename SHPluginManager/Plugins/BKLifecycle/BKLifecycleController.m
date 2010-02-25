//
//  BKLifecycleController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//


#import "BKLifecycleController.h"
#import "BKLifecycleProtocols.h"
#import "BBPluginRegistry.h"

@implementation BKLifecycleController

#pragma mark class methods

static id sharedInstance = nil;

+ (id)sharedInstance {

    if( nil==sharedInstance ) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark init

- (id)init {
	
	self = [super init];
    if(self) {
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(applicationWillFinishLaunchingNotification:) name:NSApplicationWillFinishLaunchingNotification object:nil];
		[center addObserver:self selector:@selector(applicationDidFinishLaunchingNotification:) name:NSApplicationDidFinishLaunchingNotification object:nil];
		[center addObserver:self selector:@selector(applicationWillTerminateNotification:) name:NSApplicationWillTerminateNotification object:nil];
		[self performSelector:@selector(applicationLaunching)];
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark private

- (void)applicationLaunching {
    [BBPluginRegistry performSelector:@selector(applicationLaunching)
					 forExtensionPoint:@"uk.co.stevehooley.BKLifecycle.lifecycle"
							  protocol:@protocol(BKLifecycleProtocol)];
}

- (void)applicationWillFinishLaunchingNotification:(NSNotification *)notification {
    [BBPluginRegistry performSelector:@selector(applicationWillFinishLaunching)
					 forExtensionPoint:@"uk.co.stevehooley.BKLifecycle.lifecycle"
							  protocol:@protocol(BKLifecycleProtocol)];
}

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification {
    [BBPluginRegistry performSelector:@selector(applicationDidFinishLaunching)
					 forExtensionPoint:@"uk.co.stevehooley.BKLifecycle.lifecycle"
							  protocol:@protocol(BKLifecycleProtocol)];
}

- (void)applicationWillTerminateNotification:(NSNotification *)notification {
    [BBPluginRegistry performSelector:@selector(applicationWillTerminate)
					 forExtensionPoint:@"uk.co.stevehooley.BKLifecycle.lifecycle"
							  protocol:@protocol(BKLifecycleProtocol)];
}

@end
