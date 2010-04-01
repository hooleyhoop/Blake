//
//  NSSet_ExtrasTests.m
//  SHShared
//
//  Created by steve hooley on 02/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "NSSet_Extras.h"

@interface NSSet_ExtrasTests : SenTestCase {
	
}

@end


@implementation NSSet_ExtrasTests

- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testSetMinus {
	// - (NSSet *)setMinus:(id)value
	
	NSObject *test1 = [[[NSObject alloc] init] autorelease];
	NSObject *test2 = [[[NSObject alloc] init] autorelease];
	NSSet *testSet = [NSSet setWithObjects:self, test1, test2, nil];
	STAssertTrue([testSet count]==3, @"dope");
	
	NSSet *reducedSet = [testSet setMinus:self];
	STAssertTrue([reducedSet count]==2, @"dope");
	STAssertTrue([reducedSet containsObject:test1], @"dope");
	STAssertTrue([reducedSet containsObject:test2], @"dope");
	STAssertFalse([reducedSet containsObject:self], @"dope");
	
	NSSet *reducedSet2 = [reducedSet setMinus:self];
	STAssertTrue(reducedSet2==reducedSet, @"should be the same");
}

@end
