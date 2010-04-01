//
//  SHWindowControllerTests.m
//  SHShared
//
//  Created by steve hooley on 09/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import <Appkit/NSWindowController.h>
#import "SHWindowController.h"

@interface SHWindowControllerTests : SenTestCase {
	
	SHWindowController *_winController;
}

@end


@implementation SHWindowControllerTests

- (void)setUp {
	
	_winController = [[SHWindowController alloc] initWithWindowNibName:@"nibManagerTest"];
}

- (void)tearDown {
	
	[_winController release];
}

- (void)testNibName {
	// + (NSString *)nibName

	STAssertNil([SHWindowController nibName], @"when did we start using a hardcoded nib?");
}

- (void)testLoadWindow {
	// - (void)loadWindow
	
	[_winController loadWindow];
	STAssertNotNil( _winController.nibManager, @"why didnt we create nibManager");
}

@end
