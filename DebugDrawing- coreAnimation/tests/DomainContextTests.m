//
//  DomainContextTests.m
//  DebugDrawing
//
//  Created by steve hooley on 19/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "DomainContext.h"
#import "StarScene.h"

@interface DomainContextTests : SenTestCase {
	
	DomainContext *_domainCntxt;
}

@end

@implementation DomainContextTests

- (void)setUp {
	
	_domainCntxt = [[DomainContext alloc] init];
}

- (void)tearDown {
	
	[_domainCntxt release];
}

- (void)testNodeUnderPoint {
	//- (SHNode *)nodeUnderPoint:(NSPoint)pt

	SHNode *n = [_domainCntxt nodeUnderPoint:NSMakePoint(10,10)];
	STAssertNotNil(n, @"doh");
}

- (void)testIndexesOfGraphicsIntersectingRect {
	//- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(CGRect)rect

	NSIndexSet *s = [_domainCntxt indexesOfGraphicsIntersectingRect:CGRectMake(0, 0, 10, 10)];
	STAssertTrue( [s isEqualToIndexSet:[NSIndexSet indexSetWithIndex:0]], @"fuck off");
}

- (void)testNodeProxyForNode {
	//- (NodeProxy *)nodeProxyForNode:(id)value

	id aNodeInDomain = [[[[_domainCntxt starScene] stars] lastObject] originalNode];
	NodeProxy *n = [_domainCntxt nodeProxyForNode: aNodeInDomain];
	STAssertNotNil(aNodeInDomain, @"whoops");
}

- (void)testCurrentFilteredContentSelectionIndexes {
	//- (NSIndexSet *)currentFilteredContentSelectionIndexes

	NSIndexSet *is = [_domainCntxt currentFilteredContentSelectionIndexes];
	STAssertTrue( [is isEqualToIndexSet:[NSIndexSet indexSet]], @"fuck off");

}
	
@end
