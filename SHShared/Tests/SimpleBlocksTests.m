//
//  SimpleBlocksTests.m
//  SHShared
//
//  Created by steve hooley on 29/04/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface SimpleBlocksTests : SenTestCase {
	
}

@end


@implementation SimpleBlocksTests


- (void)setUp {
	
}

- (void)tearDown {
	
}

- (void)testBlocksForFilteringArray {
	
	NSMutableArray *unfilteredArray = [NSMutableArray array];
	for( int i=0; i<10000; i++){
		[unfilteredArray addObject:[[NSObject new] autorelease]];
		[unfilteredArray addObject:[[NSView new] autorelease]];
	}
	
	// time for 2 seconds
	double lastDrawTime =0.0;
	struct timeval t;
	gettimeofday(&t, NULL);
	double currentTime = (double) t.tv_sec + (double) t.tv_usec / 1000000.0 ;
	
	NSUInteger filterCount = 0;
	do {
		lastDrawTime = currentTime;
		NSArray filteredArray = [unfilteredArray filter]; filter by class
		NSAssert( [filteredArray count]==10000, @"sheet!");
		filterCount++;
		gettimeofday(&t, NULL);
		currentTime = (double) t.tv_sec + (double) t.tv_usec / 1000000.0 ;		
	} while( (currentTime-lastDrawTime)<2.0 )
	
	NSLog(@"Old way %i", filterCount);
	
	// And again, time for 2 seconds
	lastDrawTime =0.0;
	gettimeofday(&t, NULL);
	currentTime = (double) t.tv_sec + (double) t.tv_usec / 1000000.0 ;
	
	NSUInteger filterCount2 = 0;
	do {
		lastDrawTime = currentTime;
		NSArray filteredArray = [unfilteredArray filter];
		NSAssert( [filteredArray count]==10000, @"sheet!");
		filterCount2++;
		gettimeofday(&t, NULL);
		currentTime = (double) t.tv_sec + (double) t.tv_usec / 1000000.0 ;		
	} while( (currentTime-lastDrawTime)<2.0 )
		
	NSLog(@"New way %i", filterCount2);
	
}

@end
