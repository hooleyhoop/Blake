//
//  UnknownEndToEndTest.m
//  BlakeLoader2
//
//  Created by steve hooley on 08/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import <SHTestUtilities/SHTestUtilities.h>

@interface UnknownEndToEndTest : AsyncTests {
	
}

@end


@implementation UnknownEndToEndTest

- (void)setUp {
	
	[[NSDocumentController sharedDocumentController] closeAll];
}

- (void)tearDown {
	[[NSDocumentController sharedDocumentController] closeAll];
}

- (void)testATesr {

	STAssertTrue(NO, @"oh shit in app test a gogo");
	STAssertTrue(YES, @"oh shit in app test a gogo");
	NSLog(@"we better get here");
}

@end
