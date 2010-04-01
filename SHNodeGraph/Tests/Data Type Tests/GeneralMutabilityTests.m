//
//  GeneralMutabilityTests.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 20/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHMutableBool.h"

@interface GeneralMutabilityTests : SenTestCase {
	
}

@end


@implementation GeneralMutabilityTests

- (void)setUp {
	
}


- (void)tearDown {
}


- (void)testMutableChain
{
	// make a bool >> a not >> a log
	
	// make it feedback
	
	id ob1 = [[[SHMutableBool alloc] initWithObject:@"YES"] autorelease];
	STAssertNotNil(ob1, @"eh");
}

@end
