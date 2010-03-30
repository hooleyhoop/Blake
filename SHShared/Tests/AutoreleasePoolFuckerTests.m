//
//  AutoreleasePoolFuckerTests.m
//  SHShared
//
//  Created by steve hooley on 25/03/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "AutoreleasePoolFucker.h"

@interface AutoreleasePoolFuckerTests : SenTestCase {
	
}

@end


@implementation AutoreleasePoolFuckerTests

- (void)testMultipleObjects {

	NSObject *ob1 = [[NSObject alloc] init];
	NSObject *ob2 = [[NSObject alloc] init];
	NSObject *ob3 = [[NSObject alloc] init];

	[[ob1 retain] autorelease];
	[[ob2 retain] autorelease];

	AutoreleasePoolFucker *poolFucker = [AutoreleasePoolFucker poolFucker];
	
	STAssertTrue( [poolFucker mult_isLeaking_takingIntoAccountAutoReleases:ob1], nil);
	STAssertTrue( [poolFucker mult_isLeaking_takingIntoAccountAutoReleases:ob2], nil);
	STAssertFalse( [poolFucker mult_isLeaking_takingIntoAccountAutoReleases:ob3], nil);
	
	[ob1 release];
	[ob2 release];
	[ob3 release];
	
	NSLog(@"eek - check that this still works");
}

- (void)testStdOutRedirect {
	
	[self retain];
	[self retain];
	[self retain];
	
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleases:self], nil);
	[self autorelease];
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleases:self], nil);
	[self autorelease];
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleases:self], nil);
	[self autorelease];
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleases:self], nil);

	NSUInteger autoreleaseCount = [AutoreleasePoolFucker autoreleaseCount:self];
	STAssertTrue( 3==autoreleaseCount, @"Fucked That up %i", autoreleaseCount );
}

@end
