//
//  MiscUtilitiesTests.m
//  DebugDrawing
//
//  Created by steve hooley on 20/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "MoreMiscUtilities.h"


@interface MiscUtilitiesTests : SenTestCase {
	
}

@end


@implementation MiscUtilitiesTests
 
- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testNSStringFromCGAffineTransform {
	// + (NSString *)NSStringFromCGAffineTransform:(CGAffineTransform)t
	
	NSString *str = [MoreMiscUtilities NSStringFromCGAffineTransform:CGAffineTransformIdentity];
	STAssertTrue( [str isEqualToString:@"1, 0, 0, 1, 0, 0"], @"doh - %@", str);
}

@end
