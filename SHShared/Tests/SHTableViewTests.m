//
//  SHTableViewTests.m
//  SHShared
//
//  Created by steve hooley on 09/11/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHTableView.h"

@interface SHTableViewTests : SenTestCase {
	
	SHTableView *_testTable;
}

@end

@implementation SHTableViewTests

- (void)setUp {

	_testTable = [[SHTableView alloc] initWithFrame:NSMakeRect(0,0,20,20)];
}

- (void)tearDown {
	
	[_testTable release];
}

- (void)testWorked {

	STAssertNotNil(_testTable, @"whats up eh?");
}

@end
