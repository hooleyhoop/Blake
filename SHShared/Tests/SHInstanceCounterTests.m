//
//  SHInstanceCounterTests.m
//  SHShared
//
//  Created by steve hooley on 17/04/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@interface SHInstanceCounterTests : SenTestCase {
	
}

@end

@implementation SHInstanceCounterTests

- (void)setUp {
	
}

- (void)tearDown {
	[SHInstanceCounter cleanUpInstanceCounter];
}

- (void)testObjectCreated {
	// + (void)objectCreated:(id)value;
	// + (void)objectDestroyed:(id)value;
    
    [SHInstanceCounter objectCreated:self];
    STAssertTrue( [SHInstanceCounter indexOf:self]!=NSNotFound, @"should contain this");
    STAssertTrue( [SHInstanceCounter instanceCount]==1, @"should be! %i", [SHInstanceCounter instanceCount] );
    
    [SHInstanceCounter objectDestroyed:self];
    STAssertTrue( [SHInstanceCounter indexOf:self]==NSNotFound, @"should contain this");
    STAssertTrue( [SHInstanceCounter instanceCount]==0, @"should be! %i", [SHInstanceCounter instanceCount] );
}

- (void)testCleanUpInstanceCounter {

	//+ (void)cleanUpInstanceCounter
	[SHInstanceCounter cleanUpInstanceCounter];
}

- (void)testInstanceDescription {
	// + (NSString *)instanceDescription:(id)value

	NSString *desc = [SHInstanceCounter instanceDescription:self];
	STAssertNotNil( desc, @"doh");
}

- (void)testPrintLeakingObjectInfo {
	// + (void)printLeakingObjectInfo

	[SHInstanceCounter printLeakingObjectInfo];
}

- (void)testNewMark {
	
	id ob1 = [NSObject new];
	[SHInstanceCounter objectCreated:ob1];

	[SHInstanceCounter newMark];
	id ob2 = [NSObject new];
	[SHInstanceCounter objectCreated:ob2];
	
    STAssertTrue( [SHInstanceCounter instanceCount]==2, @"should be!" );
    STAssertTrue( [SHInstanceCounter instanceCountSinceMark]==1, @"should be!" );
	
	[SHInstanceCounter printSmallLeakingObjectInfoSinceMark];
	
	id ob3 = [NSObject new];
	[SHInstanceCounter objectCreated:ob3];
	
    STAssertTrue( [SHInstanceCounter instanceCount]==3, @"should be!" );
    STAssertTrue( [SHInstanceCounter instanceCountSinceMark]==2, @"should be!" );
	
	[SHInstanceCounter newMark];
    STAssertTrue( [SHInstanceCounter instanceCount]==3, @"should be!" );
    STAssertTrue( [SHInstanceCounter instanceCountSinceMark]==0, @"should be!" );
	
	[SHInstanceCounter objectDestroyed:ob1];
    [SHInstanceCounter objectDestroyed:ob2];
    [SHInstanceCounter objectDestroyed:ob3];

	[ob1 release];
	[ob2 release];
	[ob3 release];
}


@end
