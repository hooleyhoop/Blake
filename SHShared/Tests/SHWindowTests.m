//
//  SHWindowTests.m
//  SHShared
//
//  Created by steve hooley on 07/08/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHWindow.h"

@interface SHWindowTests : SenTestCase {
	SHWindow		*_window;
}

@end

@implementation SHWindowTests

- (void)setUp {

	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	_window = [[SHWindow alloc] initWithContentRect:NSMakeRect(100, 100, 400, 300) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
	[_window makeKeyAndOrderFront:self];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)tearDown {
	[_window close];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	
	/* NB - window doesn't need manually releasing */
}

- (void)testDefaultWindowSettings {

	STAssertTrue( [_window isOneShot], @"YES");
	STAssertTrue( [_window isOpaque], @"YES");
	STAssertTrue( [_window level]==kCGNormalWindowLevel, @"YES");
	STAssertTrue( [_window backingType]==NSBackingStoreBuffered, @"YES");
}
	
@end
