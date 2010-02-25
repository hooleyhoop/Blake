//
//  SHPanelTests.m
//  SHShared
//
//  Created by steve hooley on 07/08/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHPanel.h"

@interface SHPanelTests : SenTestCase {
	
	SHPanel		*_panel;
}

@end

@implementation SHPanelTests

- (void)setUp {
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	_panel = [[SHPanel alloc] initWithContentRect:NSMakeRect(100, 100, 400, 300) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO];
	[_panel makeKeyAndOrderFront:self];
	[_panel setOneShot:YES];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)tearDown {
	[_panel close];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	
	/* NB - window doesn't need manually releasing */
}

- (void)testDefaultWindowSettings {
	
	/* seems like panels can not be one shot */
	STAssertFalse( [_panel isOneShot], @"YES");
	STAssertTrue( [_panel isOpaque], @"YES");
	STAssertTrue( [_panel level]==NSFloatingWindowLevel, @"YES");
	STAssertTrue( [_panel backingType]==NSBackingStoreBuffered, @"YES");
}


@end
