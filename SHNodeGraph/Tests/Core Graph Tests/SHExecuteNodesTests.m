//
//  SHExecuteNodesTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 11/04/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHExecuteNodesTests.h"
#import "MockProducer.h"
#import "MockProcessor.h"
#import "MockConsumer.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import "SHOutputAttribute.h"
#import "SHInputAttribute.h"
#import "SHPlusOperator.h"
#import "SHInterConnector.h"
#import "SHNodeAttributeMethods.h"


/*
 *
 */
@interface SHExecuteNodesTests : SenTestCase {
	
	SHNodeGraphModel *_nodeGraphModel;
	
}



- (void) testSetFrameSize;

- (void) testSetSamplesPerSecond;

- (void) testSetFramesPerSecond;

@end

/*
 *
*/
@implementation SHExecuteNodesTests
 
// ===========================================================
// - setUp
// ===========================================================
- (void) setUp
{
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHAttributeTests ERROR.. Couldnt make a nodeModel");
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
// - testEvaluateOncePerFrame
// ===========================================================
- (void)testEvaluateOncePerFrame
{
	// - (BOOL)evaluateOncePerFrame:(id)fp8 time:(double)compositionTime arguments:(id)fp20;	
	// make nodes of the three different execution modes and check that they render correctly once per frame
		
	// Provider		- we are asking, so render 1 per frame
	// Consumer		- render 1 per frame
	// Processor	- render 1 per frame if dirty
		
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	MockProducer* producerNode = [[[MockProducer alloc] init] autorelease];	
	MockProcessor* processorNode = [[[MockProcessor alloc] init] autorelease];
	MockConsumer* consumerNode = [[[MockConsumer alloc] init] autorelease];	

	// put an attribute in processor
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];	
	[outAtt1 setDataType:@"SHNumber"];
	[processorNode addChild:outAtt1 autoRename:YES];
	// Only set dirty on attributes
	double evalKey = (double)random();
	[outAtt1 setDirtyBit:NO uid:evalKey];
		
	[root addChild:producerNode autoRename:YES];
	[root addChild:consumerNode autoRename:YES];
	[root addChild:processorNode autoRename:YES];
	
	/* the root node doesnt use evaluate once per frame */
	// consumers and producers evaluate each time..
	BOOL res1 = [consumerNode evaluateOncePerFrame:nil head:nil time:evalKey arguments:nil];
	BOOL res2 = [producerNode evaluateOncePerFrame:nil head:nil time:evalKey arguments:nil];
	// processors only evaluate when dirty
	BOOL res3 = [processorNode evaluateOncePerFrame:nil head:nil time:evalKey arguments:nil];
	STAssertTrue(res1, @"consumerNode should evaluate");
	STAssertTrue(res2, @"producerNode should evaluate"); 
	STAssertFalse(res3, @"processorNode doesnt render if not dirty");
	STAssertTrue([consumerNode didRender]==YES, @"consumerNode should render");
	STAssertTrue([producerNode didRender]==YES, @"producer should render");
	STAssertTrue([processorNode didRender]==NO, @"processorNode should not render");

	[outAtt1 setDirtyBit:YES uid:evalKey];
	evalKey = (double)random();
	[root evaluateOncePerFrame:nil head:nil time:evalKey arguments:nil];
	STAssertTrue([processorNode didRender]==YES, @"processorNode should render");
	
//	[_nodeGraphModel closeCurrentRootNode];
}


// ===========================================================
// - testEvaluate
// ===========================================================
- (void)testExecute
{
	// - (BOOL)execute:(id)fp8 time:(double)compositionTime arguments:(id)fp20;
	
	// When we call this it should execute it's child nodes, depending on what kind they are
	SHNode* root1 = [_nodeGraphModel rootNodeGroup];
	SHNode* root2 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"root2"];
	SHNode* root3 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"root3"];

	MockProducer* producerChildNode1 = [[[MockProducer alloc] init] autorelease];	
	MockProcessor* processorChildNode1 = [[[MockProcessor alloc] init] autorelease];
	MockConsumer* consumerChildNode1 = [[[MockConsumer alloc] init] autorelease];
	MockProducer* producerChildNode2 = [[[MockProducer alloc] init] autorelease];	
	MockProcessor* processorChildNode2 = [[[MockProcessor alloc] init] autorelease];
	MockConsumer* consumerChildNode2 = [[[MockConsumer alloc] init] autorelease];
	MockProducer* producerChildNode3 = [[[MockProducer alloc] init] autorelease];	
	MockProcessor* processorChildNode3 = [[[MockProcessor alloc] init] autorelease];
	MockConsumer* consumerChildNode3 = [[[MockConsumer alloc] init] autorelease];
	
	[root1 addChild:producerChildNode1 autoRename:YES];
	[root1 addChild:processorChildNode1 autoRename:YES];
	[root1 addChild:consumerChildNode1 autoRename:YES];

	[root2 addChild:producerChildNode2 autoRename:YES];
	[root2 addChild:processorChildNode2 autoRename:YES];
	[root2 addChild:consumerChildNode2 autoRename:YES];
	
	[root3 addChild:producerChildNode3 autoRename:YES];
	[root3 addChild:processorChildNode3 autoRename:YES];
	[root3 addChild:consumerChildNode3 autoRename:YES];

	double evalKey = (double)random();
	[root1 execute:nil head:nil time:evalKey arguments:nil];
	[root2 execute:nil head:nil time:evalKey arguments:nil];
	[root3 execute:nil head:nil time:evalKey arguments:nil];

	// Consumer - call render 1 per frame
	// Provider - ignore
	// Processor - ignore
	STAssertTrue([consumerChildNode1 didRender]==YES, @"consumerNode should render");
	STAssertTrue([consumerChildNode2 didRender]==YES, @"consumerNode should render");
	STAssertTrue([consumerChildNode3 didRender]==YES, @"consumerNode should render");
	
	STAssertTrue([producerChildNode1 didRender]==NO, @"consumerNode should NOT render");
	STAssertTrue([producerChildNode2 didRender]==NO, @"consumerNode should NOT render");
	STAssertTrue([producerChildNode3 didRender]==NO, @"consumerNode should NOT render");

	STAssertTrue([processorChildNode1 didRender]==NO, @"consumerNode should NOT render");
	STAssertTrue([processorChildNode2 didRender]==NO, @"consumerNode should NOT render");
	STAssertTrue([processorChildNode3 didRender]==NO, @"consumerNode should NOT render");

//	[_nodeGraphModel closeCurrentRootNode];
//	[_nodeGraphModel closeCurrentRootNode];
//	[_nodeGraphModel closeCurrentRootNode];
}


- (void) testSetFrameSize {
//	STFail(@"Not defined yet");
}

- (void) testSetSamplesPerSecond {
//	STFail(@"Not defined yet");
}

- (void) testSetFramesPerSecond {
//	STFail(@"Not defined yet");
}


// ===========================================================
// - testEval
// ===========================================================
- (void)testEval
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];	
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[inAtt1 setDataType:@"SHNumber"];
	[inAtt2 setDataType:@"SHNumber"];
	[outAtt1 setDataType:@"SHNumber"];
	SHPlusOperator* plusOp = [[[SHPlusOperator alloc] init] autorelease];	
	[root addChild:plusOp autoRename:YES];

	SHInterConnector* connector1 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector2 = [[[SHInterConnector alloc] init] autorelease];
	SHInterConnector* connector3 = [[[SHInterConnector alloc] init] autorelease];

	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[plusOp inputAttributeAtIndex:0] withConnector:connector1];
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[plusOp inputAttributeAtIndex:1] withConnector:connector2];
	BOOL flag3 = [(SHAttribute*)[plusOp outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:connector3];
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type mockDataType");
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type mockDataType");
	STAssertTrue(flag3==YES, @"failed to connect 2 attributes of type mockDataType");

	[inAtt1 publicSetValue:@"4"];
	[inAtt2 publicSetValue:@"3"];
	NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"7"], @"should be roughly the same");
	
//	[_nodeGraphModel closeCurrentRootNode];

}

@end
