//
//  SHViewTests.m
//  SHShared
//
//  Created by steve hooley on 09/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "SHView.h"

@interface SHViewTests : SenTestCase {
	
	SHView *_testView;
}

@end

@implementation SHViewTests

- (void)setUp {

	_testView = [[SHView alloc] initWithFrame:NSMakeRect(0,0,20,20)];
}

- (void)tearDown {

	[_testView release];
}

- (void)testWorked {
	
	STAssertNotNil(_testView, @"whats up eh?");
}

@end
