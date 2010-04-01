//
//  AllChildProxyTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 02/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "AllChildProxy.h"
#import "MockProducer.h"
#import "AllChildrenFilter.h"
#import "SHNodeGraphModel.h"
#import "MockConsumer.h"

@interface AllChildProxyTests : SenTestCase {
	
    SHNodeGraphModel *_model;
	AllChildrenFilter *_filter;
}

@end


@implementation AllChildProxyTests

- (void)setUp {
	
	_model = [[SHNodeGraphModel makeEmptyModel] retain];
	_filter = [[AllChildrenFilter alloc] init];
    [_filter setModel:_model];
}

- (void)tearDown {

	[_filter cleanUpFilter];	
	[_filter release];
	[_model release];
}

- (void)testDontKnowWhat {

	SHNode *ng1 = [[SHNode new] autorelease], *ng2 = [[SHNode new] autorelease], *ng3 = [[SHNode new] autorelease];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_model NEW_addChild:ng1 atIndex:-1];
	[_model NEW_addChild:ng2 atIndex:-1];
	[_model NEW_addChild:ng3 atIndex:-1];
	[_model NEW_addChild:graphic1 atIndex:-1];
	[_model NEW_addChild:graphic2 atIndex:-1];
	[_model NEW_addChild:audio1 atIndex:-1];
	[_model NEW_addChild:audio2 atIndex:-1];
	[_model NEW_addChild:i1 atIndex:-1];
	[_model NEW_addChild:o1 atIndex:-1];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"oops");
	
	// all children filter coalcses updates. Give it a poke - 
	[_filter postPendingNotificationsExcept:nil];

	AllChildProxy *rootProxy = (AllChildProxy *)[_filter rootNodeProxy];
    
	NSArray *nodeProxies = [rootProxy nodeProxies];
	NSArray *inputProxies = [rootProxy inputProxies];
	NSArray *outputProxies = [rootProxy outputProxies];
	NSArray *icProxies = [rootProxy icProxies];

	STAssertTrue( 7==[nodeProxies count], @"aw %i", [nodeProxies count] );
	STAssertTrue( [[nodeProxies objectAtIndex:0] originalNode]==ng1, @"aw" );
	STAssertTrue( [[nodeProxies objectAtIndex:1] originalNode]==ng2, @"aw" );
	STAssertTrue( [[nodeProxies objectAtIndex:2] originalNode]==ng3, @"aw" );
	STAssertTrue( [[nodeProxies objectAtIndex:3] originalNode]==graphic1, @"aw" );
	STAssertTrue( [[nodeProxies objectAtIndex:4] originalNode]==graphic2, @"aw" );
	STAssertTrue( [[nodeProxies objectAtIndex:5] originalNode]==audio1, @"aw" );
	STAssertTrue( [[nodeProxies objectAtIndex:6] originalNode]==audio2, @"aw" );

	STAssertTrue( 1==[inputProxies count], @"aw %i", [inputProxies count] );
	STAssertTrue( (id)[[inputProxies objectAtIndex:0] originalNode]==i1, @"aw" );

	STAssertTrue( 1==[outputProxies count], @"aw %i", [outputProxies count] );
	STAssertTrue( (id)[[outputProxies objectAtIndex:0] originalNode]==o1, @"aw" );

	STAssertTrue( 1==[icProxies count], @"aw %i", [icProxies count] );
	STAssertTrue( (id)[[icProxies objectAtIndex:0] originalNode]==int1, @"aw" );
}

@end
