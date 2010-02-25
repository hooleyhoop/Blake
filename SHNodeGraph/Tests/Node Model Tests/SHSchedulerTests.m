//
//  SHSchedulerTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 18/06/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "mockLoopTestProxy.h"
#import "mockExternalTimeSourceOperator.h"
#import "mockDataProducingOperator.h"
#import "SHNodeGraphScheduler.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import "SHOutputAttribute.h"

@interface SHSchedulerTests : SenTestCase {
	
    SHNodeGraphModel *_nodeGraphModel;
	
}


@implementation SHSchedulerTests
// ===========================================================
// - setUp
// ===========================================================
- (void) setUp
{
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHNodeGraphModelTests ERROR.. Couldnt make a nodeModel");
}

// ===========================================================
// - tearDown
// ===========================================================
- (void) tearDown
{
    [_nodeGraphModel release];
	_nodeGraphModel = nil;
}

// ===========================================================
// - testCachedScheduler
// ===========================================================
-(void) testCachedScheduler
{

}

#pragma mark init methods
#pragma mark action methods
// ===========================================================
// - testClearHist
// ===========================================================
- (void) testClearHist
{

}

// ===========================================================
// - testAddHist
// ===========================================================
- (void) testAddHist
{

}

// ===========================================================
// - testShowHist
// ===========================================================
- (void) testShowHist
{

}

// ===========================================================
// - testSched_tick
// ===========================================================
- (void) testSched_tick
{

}

// ===========================================================
// - testScheduler
// ===========================================================
- (void) testScheduler
{

}

// ===========================================================
// - testStop
// ===========================================================
- (void) testStop
{

}

// ===========================================================
// - testPlay
// ===========================================================
- (void) testPlay
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];

	// inAttribute to inAttribute
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[inAtt1 setDataType:@"mockDataType"];
	[inAtt2 setDataType:@"mockDataType"];
	SHInterConnector* in1 = [root connectOutletOfAttribute:(SHAttribute*)inAtt1 toInletOfAttribute:(SHAttribute*)inAtt2];
	STAssertNotNil(in1, @"a");

	// outAttribute to outAttribute
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* outAtt2 = [SHOutputAttribute makeAttribute];
	[outAtt1 setDataType:@"mockDataType"];
	[outAtt2 setDataType:@"mockDataType"];
	[root addChild:outAtt1 autoRename:YES];
	[root addChild:outAtt2 autoRename:YES];
	SHInterConnector* in2 = [root connectOutletOfAttribute:outAtt1 toInletOfAttribute:outAtt2];
	STAssertNotNil(in2, @"a");

	// inAttribute to outAttribute
	SHInterConnector* in3 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1];
	STAssertNotNil(in3, @"a");
	
	[_nodeGraphModel setCurrentNodeGroup:root];

	SHNodeGraphScheduler* sched =[SHNodeGraphScheduler scheduler];
	STAssertNotNil(sched, @"SHSchedulerTests ERROR.. Couldnt get a cached scheduler");
	
	id shouldLoopProxy = [mockLoopTestProxy loopTestProxy];
	[shouldLoopProxy reset];
	[sched setShouldLoopProxy:shouldLoopProxy];
	[sched schedulerStopCallBack:nil]; // hack cause i dont know hoe to test notifications

	[sched play:root];

	STAssertTrue([shouldLoopProxy success], @"should have looped 10 times");
	
//	[_nodeGraphModel closeCurrentRootNode];
}

- (void)testPlayWithExternalTimeSource
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHNode<SHExternalTimeSourceProtocol>* mockDAC = [[[mockExternalTimeSourceOperator alloc] init] autorelease];
	mockDataProducingOperator* mockSinWave = [[[mockDataProducingOperator alloc] init] autorelease];
	[root addChild:mockDAC autoRename:YES];
	[root addChild:mockSinWave autoRename:YES];
	id outAtt = [mockSinWave outputAttributeAtIndex:0];
	id inAtt = [mockDAC inputAttributeAtIndex:0];
	id connector = [root connectOutletOfAttribute:outAtt toInletOfAttribute:inAtt];
	STAssertNotNil(outAtt, @"SHSchedulerTests ERROR.. cant get output");
	STAssertNotNil(inAtt, @"SHSchedulerTests ERROR.. cant get input");
	STAssertNotNil(connector, @"SHSchedulerTests ERROR.. cant connect output to input");

	//	set external time source to DAC
	SHNodeGraphScheduler* sched =[SHNodeGraphScheduler scheduler];
	STAssertNotNil(sched, @"SHSchedulerTests ERROR.. Couldnt get a cached scheduler");
	[sched setExternalTimesource:mockDAC];
	
	id shouldLoopProxy = [mockLoopTestProxy loopTestProxy];
	[shouldLoopProxy reset];
	[sched setShouldLoopProxy:shouldLoopProxy];
	[sched schedulerStopCallBack:nil]; // hack cause i dont know hoe to test notifications

	[sched play:root];
			
	STAssertTrue([shouldLoopProxy success], @"should have looped 10 times");

}

#pragma mark accessor methods
// ===========================================================
// - testIsPlaying
// ===========================================================
- (void) testIsPlaying
{

}

// ===========================================================
// - testAddIdleHook
// ===========================================================
- (void) testAddIdleHook
{

}

// ===========================================================
// - testRemoveIdleHook
// ===========================================================
- (void) testRemoveIdleHook
{

}

#pragma mark call back methods
// ===========================================================
// - testSchedulerStopCallBack
// ===========================================================
- (void) testSchedulerStopCallBack
{

}


@end
