//
//  NSCHaracterSet_ExtensionsTests.m
//  SHShared
//
//  Created by steve hooley on 17/04/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@interface NSCHaracterSet_ExtensionsTests : SenTestCase {
	
}

@end

@implementation NSCHaracterSet_ExtensionsTests

- (void)testNodeNameCharacterSet {
	// + (NSCharacterSet *)nodeNameCharacterSet
	// + (void)cleanUpNodeNameCharacterSet
	
	NSCharacterSet *nn = [NSCharacterSet nodeNameCharacterSet];
	STAssertNotNil(nn, @"nah");
	[NSCharacterSet cleanUpNodeNameCharacterSet];
}


@end
