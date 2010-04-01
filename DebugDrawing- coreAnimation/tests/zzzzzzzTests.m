//
//  zzzzzzzTests.m
//  DebugDrawing
//
//  Created by steve hooley on 14/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "zzzzzzzTests.h"
#import "AppControl.h"


@implementation zzzzzzzTests

- (void)setUp {
}

- (void)tearDown {
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
}

- (void)testCleanup {
	
	AppControl *sh = [[NSApplication sharedApplication] delegate];
	[sh applicationWillTerminate:nil];
}

@end
