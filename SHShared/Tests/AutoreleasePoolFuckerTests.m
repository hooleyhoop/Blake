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


- (void)testStdOutRedirect {
	
	[self retain];
	[self retain];
	[self retain];
	
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleses:self], nil);
	[self autorelease];
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleses:self], nil);
	[self autorelease];
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleses:self], nil);
	[self autorelease];
	STAssertTrue( [AutoreleasePoolFucker isLeaking_takingIntoAccountAutoReleses:self], nil);

	NSUInteger autoreleaseCount = [AutoreleasePoolFucker autoreleaseCount:self];
	STAssertTrue( 3==autoreleaseCount, @"Fucked That up %i", autoreleaseCount );
}

@end
