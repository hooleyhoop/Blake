//
//  AllChildrenProxyFactoryTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 03/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "AllChildrenProxyFactory.h"

@interface AllChildrenProxyFactoryTests : SenTestCase {
	
	AllChildrenProxyFactory *_proxyFactory;
}

@end

@implementation AllChildrenProxyFactoryTests

- (void)setUp {
    
	_proxyFactory = [[AllChildrenProxyFactory alloc] init];
}

- (void)tearDown {
    
	[_proxyFactory release];
}

- (void)testProxysForObjectsInFilter {
// - (NSMutableArray *)proxysForObjects:(NSArray *)graphObjects inFilter:(AllChildrenFilter *)filter {

	OCMockObject *mock1 = MOCK(SHNode);
	OCMockObject *mock2 = MOCK(SHNode);
	OCMockObject *mock3 = MOCK(SHNode);
	NSArray	*_mockObjects = [NSArray arrayWithObjects:mock1, mock2, mock3, nil];
	OCMockObject *_mockFilter = MOCK(NodeClassFilter);
	NSMutableArray *pr = [_proxyFactory proxysForObjects:_mockObjects inFilter:(id)_mockFilter];
	STAssertTrue(3==[pr count], @"hmm");
	STAssertTrue([[pr objectAtIndex:0] originalNode]==(id)mock1, @"hmm");
	STAssertTrue([[pr objectAtIndex:1] originalNode]==(id)mock2, @"hmm");
	STAssertTrue([[pr objectAtIndex:2] originalNode]==(id)mock3, @"hmm");
}


@end
