//
//  SimpleBlocksTests.m
//  SHShared
//
//  Created by steve hooley on 29/04/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <sys/time.h>
#import <objc/objc-runtime.h>
#import <SHShared/SHShared.h>

#pragma mark -
@implementation NSObject (JustForPerformanceTests)

- (NSNumber *)tempisKindOfClass:(Class)arg {
	if ([self isKindOfClass:arg]) {
		return [NSNumber numberWithInt:1];
	}
	return [NSNumber numberWithInt:0];
}

@end

#pragma mark -
@interface SimpleBlocksTests : SenTestCase {
	
}

@end


@implementation SimpleBlocksTests


- (void)setUp {
	
}

- (void)tearDown {
	
}

/* get "real time" in seconds; take the
 first time we get called as a reference time of zero. */
// gettimeofday is microsecond accurate. for higher resolution (nanosecond) switch to http://developer.apple.com/library/mac/#qa/qa2004/qa1398.html

double sys_getrealtime(void) {

    static struct timeval then;
    struct timeval now;
    gettimeofday(&now, 0);
    if (then.tv_sec == 0 && then.tv_usec == 0) then = now;
    return ((now.tv_sec - then.tv_sec) + (1./1000000.) * (now.tv_usec - then.tv_usec));
}

- (void)testBlocksForFilteringArray {
	
	NSMutableArray *unfilteredArray = [NSMutableArray array];
	for( int i=0; i<10000; i++){
		[unfilteredArray addObject:[[NSObject new] autorelease]];
		[unfilteredArray addObject:[[NSView new] autorelease]];
	}
	
	// time for 2 seconds
	double startTime = sys_getrealtime();

	// Original way
	NSUInteger filterCount = 0;
	do {
		NSArray *filteredArray = [unfilteredArray itemsThatResultOfSelectorIsTrue:NSSelectorFromString(@"tempisKindOfClass:") withObject:[NSView class]];
		NSAssert1( [filteredArray count]==10000, @"sheet! %i", [filteredArray count]);
		filterCount++;

	} while( (sys_getrealtime()-startTime)<2.0 );
	
	NSLog(@"Old way %i", filterCount);
	
	// And again, time for 2 seconds
	// Predicate way
	startTime = sys_getrealtime();
	
	NSUInteger filterCount2 = 0;
	do {

		NSPredicate *elePred1 = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [NSView class]];
		NSArray *filteredArray = [unfilteredArray filteredArrayUsingPredicate:elePred1];
		NSAssert( [filteredArray count]==10000, @"sheet!");
		filterCount2++;

	} while( (sys_getrealtime()-startTime)<2.0 );

	NSLog(@"Predicate way %i", filterCount2);
	
	// And again
	// Blocks way
	startTime = sys_getrealtime();
	NSUInteger filterCount3 = 0;
	do {
		NSMutableArray *filteredArray = [NSMutableArray array];
		[unfilteredArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			if([obj isKindOfClass:[NSView class]])
				[filteredArray addObject:obj];
		}];
		
		NSAssert( [filteredArray count]==10000, @"sheet!");
		filterCount3++;
		
	} while( (sys_getrealtime()-startTime)<2.0 );
	
	NSLog(@"Blocks way %i", filterCount3);


	// Results
	// 2010-05-07 17:23:09.505 otest[20809:a0f] Old way 267
	// 2010-05-07 17:23:11.512 otest[20809:a0f] Predicate way 338
	// 2010-05-07 17:23:13.515 otest[20809:a0f] Blocks way 740
	
}

@end
