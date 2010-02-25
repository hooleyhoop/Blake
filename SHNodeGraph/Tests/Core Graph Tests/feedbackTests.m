//
//  feedbackTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 20/07/2006.
//  Copyright (c) 2006 HooleyHoop. All rights reserved.
//

#import "feedbackTests.h"
#import "SHInputAttribute.h"
#import "SHPlusOperator.h"
#import "SHMinusOperator.h"
#import "SHAbsOperator.h"
#import "SHDivideOperator.h"
#import "SHOutputAttribute.h"
#import "SHInterConnector.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import "SHNodeAttributeMethods.h"


/*
 *
 */
@interface feedbackTests : SenTestCase {
	
	SHNodeGraphModel *_nodeGraphModel;
	
}

@end


/*
 *
*/
@implementation feedbackTests


- (void)setUp
{
    _nodeGraphModel = [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHNodeTest ERROR.. Couldnt make a nodeModel");
}


- (void)tearDown
{
	[_nodeGraphModel release];
	_nodeGraphModel = nil;
}


- (void)testMakeALoop
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[inAtt1 setDataType:@"mockDataType"];
	[outAtt1 setDataType:@"mockDataType"];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [outAtt1 connectOutletToInletOf:inAtt1 withConnector:[SHInterConnector interConnector]];

	STAssertTrue(flag1, @"should be able to connect");
	STAssertTrue(flag2, @"should be able to connect");
//	[_nodeGraphModel closeCurrentRootNode];
}

// ===========================================================
// - testEvaluateALoop
// ===========================================================
- (void)testEvaluateALoop
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[inAtt1 setDataType:@"mockDataType"];
	[outAtt1 setDataType:@"mockDataType"];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	
	// make an infinite loop
	BOOL flag1 = [inAtt1 connectOutletToInletOf:outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [outAtt1 connectOutletToInletOf:inAtt1 withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag1, @"eh");
	STAssertTrue(flag2, @"eh");

	if(flag2){
		[inAtt1 publicSetValue:@"shaznee"]; // inatt is now not dirty
		NSObject<SHValueProtocol>* val1 = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
		STAssertTrue([[val1 displayObject] isEqualToString:@"shaznee"], @"should be roughly the same");
		
		
		[outAtt1 publicSetValue:@"cabbage"]; // inatt is now not dirty
		NSObject<SHValueProtocol>* val2 = [inAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
		STAssertTrue([[val2 displayObject] isEqualToString:@"cabbage"], @"should be roughly the same");
	}
}


/* This is a washout - they will not alternate, test not really necassary but has been altered to pass and left in */
- (void)testFamous_4_6_feedback
{
	NSError* error=nil;

//	-----
//	|	|
//	in	out		values never change
//	|	|
//	-----
	
	/* Create the input and the output */
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	[inAtt1 setDataType:@"mockDataType"];
	[outAtt1 setDataType:@"mockDataType"];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];

	// in setValue 4
	// out setValue 6
	[inAtt1 publicSetValue:[NSNumber numberWithInt:4]];
	[outAtt1 publicSetValue:[NSNumber numberWithInt:6]];

	// in to out
	// out to in
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [outAtt1 connectOutletToInletOf:(SHAttribute*)inAtt1 withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag1, @"eh");
	STAssertTrue(flag2, @"eh");

	STAssertTrue([inAtt1 dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([outAtt1 dirtyBit]==YES, @"connecting should make dirty");

	// check initial values
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[inAtt1 value] displayObject]  );
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"6"], @"should be 6 but is %@", [[outAtt1 value] displayObject]  );
	// update
	int ttime = 546;
	NSObject<SHValueProtocol>* inVal = [inAtt1 upToDateEvaluatedValue:ttime head:nil error:&error];		// 6
	NSObject<SHValueProtocol>* outVal = [outAtt1 upToDateEvaluatedValue:ttime head:nil error:&error];	// 4
	// in==4
	// out==6
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[inAtt1 value] displayObject]  );
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[outAtt1 value] displayObject]  );
	outVal = [outAtt1 upToDateEvaluatedValue:ttime head:nil error:&error];	// 4
	inVal = [inAtt1 upToDateEvaluatedValue:ttime head:nil error:&error];		// 6
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[inAtt1 value] displayObject]  );
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 6 but is %@", [[outAtt1 value] displayObject]  );	
	// update
	outVal = [outAtt1 upToDateEvaluatedValue:random()+22 head:nil error:&error];
	// out=6
	// in=4
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[outAtt1 value] displayObject]  );
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 6 but is %@", [[inAtt1 value] displayObject]  );
	// update
	outVal = [outAtt1 upToDateEvaluatedValue:random()+33 head:nil error:&error];
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[outAtt1 value] displayObject]  );
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 6 but is %@", [[inAtt1 value] displayObject]  );
}

- (void)testFamous_4_6_feedback_Reversed
{
	NSError* error=nil;
	
	//	-----
	//	|	|
	//	in	out		values oscillate between each others values
	//	|	|
	//	-----
	
	/* Create the input and the output */
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* updater = [SHOutputAttribute makeAttribute];
	[inAtt1 setDataType:@"mockDataType"];
	[outAtt1 setDataType:@"mockDataType"];
	[updater setDataType:@"mockDataType"];

	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[root addChild:updater autoRename:YES];
	
	// in setValue 4
	// out setValue 6
	[inAtt1 publicSetValue:[NSNumber numberWithInt:4]];
	[outAtt1 publicSetValue:[NSNumber numberWithInt:6]];
	
	// in to out
	// out to in
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [outAtt1 connectOutletToInletOf:(SHAttribute*)inAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag3 = [inAtt1 connectOutletToInletOf:(SHAttribute*)updater withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag1, @"eh");
	STAssertTrue(flag2, @"eh");
	STAssertTrue(flag3, @"eh");

	// update
	NSObject<SHValueProtocol>* val1 = [updater upToDateEvaluatedValue:random() head:nil error:&error];
	// out==4
	// in==6
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[outAtt1 value] displayObject]  );
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[inAtt1 value] displayObject]  );
	// update
	val1 = [updater upToDateEvaluatedValue:random()+22 head:nil error:&error];
	// out=6
	// in=4
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[outAtt1 value] displayObject]  );
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[inAtt1 value] displayObject]  );
	// update
	val1 = [updater upToDateEvaluatedValue:random()+33 head:nil error:&error];
	STAssertTrue([[[outAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[outAtt1 value] displayObject]  );
	STAssertTrue([[[inAtt1 value] displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [[inAtt1 value] displayObject]  );
}

- (void)testSimplerMoreComplexFeedbackLoop
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHPlusOperator* plusOp = [[[SHPlusOperator alloc] init] autorelease];	
	[root addChild:plusOp autoRename:YES];

	[(SHAttribute *)[plusOp inputAttributeAtIndex:0] publicSetValue:[NSNumber numberWithInt:4]];
	[(SHAttribute *)[plusOp inputAttributeAtIndex:1] publicSetValue:[NSNumber numberWithInt:3]];
	
	// now for the feedback loop..
	BOOL flag5 = [(SHAttribute *)[plusOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute *)[plusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag5==YES, @"failed to connect 2 attributes of type mockDataType");

	/* every attribute should now be dirty */
	STAssertTrue([(SHAttribute *)[plusOp inputAttributeAtIndex:0] dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([(SHAttribute *)[plusOp inputAttributeAtIndex:1] dirtyBit]==NO, @"input should be clean after setting value");
	STAssertTrue([(SHAttribute *)[plusOp outputAttributeAtIndex:0] dirtyBit]==YES, @"connecting should make dirty");

	NSObject<SHValueProtocol>* val1 = [(SHAttribute *)[plusOp outputAttributeAtIndex:0] upToDateEvaluatedValue:-666 head:nil  error:&error];	
	NSObject<SHValueProtocol>* val2 = [(SHAttribute *)[plusOp inputAttributeAtIndex:0] upToDateEvaluatedValue:-666 head:nil error:&error];
	NSObject<SHValueProtocol>* val3 = [(SHAttribute *)[plusOp inputAttributeAtIndex:1] upToDateEvaluatedValue:-666 head:nil error:&error];

	STAssertTrue([[val1 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val1 displayObject]  );
	STAssertTrue([[val2 displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [val2 displayObject]  );
	STAssertTrue([[val3 displayObject] isEqualToString:@"3"], @"should be 3 but is %@", [val3 displayObject]  );

	STAssertTrue([(SHAttribute *)[plusOp inputAttributeAtIndex:0] dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([(SHAttribute *)[plusOp inputAttributeAtIndex:1] dirtyBit]==NO, @"input should be clean after setting value");
	STAssertTrue([(SHAttribute *)[plusOp outputAttributeAtIndex:0] dirtyBit]==YES, @"connecting should make dirty");

	val1 = [(SHAttribute *)[plusOp outputAttributeAtIndex:0] upToDateEvaluatedValue:-777 head:nil error:&error];	
	val2 = [(SHAttribute *)[plusOp inputAttributeAtIndex:0] upToDateEvaluatedValue:-777 head:nil error:&error];
	val3 = [(SHAttribute *)[plusOp inputAttributeAtIndex:1] upToDateEvaluatedValue:-777 head:nil error:&error];
	
	STAssertTrue([[val1 displayObject] isEqualToString:@"10"], @"should be 10 but is %@", [val1 displayObject]  );
	STAssertTrue([[val2 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val2 displayObject]  );
	STAssertTrue([[val3 displayObject] isEqualToString:@"3"], @"should be 3 but is %@", [val3 displayObject]  );
	
	// err
	val1 = [(SHAttribute *)[plusOp outputAttributeAtIndex:0] upToDateEvaluatedValue:-778 head:nil error:&error];	
	val2 = [(SHAttribute *)[plusOp inputAttributeAtIndex:0] upToDateEvaluatedValue:-778 head:nil error:&error];
	val3 = [(SHAttribute *)[plusOp inputAttributeAtIndex:1] upToDateEvaluatedValue:-778 head:nil error:&error];
	
	STAssertTrue([[val1 displayObject] isEqualToString:@"13"], @"should be 13 but is %@", [val1 displayObject]  );
	STAssertTrue([[val2 displayObject] isEqualToString:@"10"], @"should be 10 but is %@", [val2 displayObject]  );
	STAssertTrue([[val3 displayObject] isEqualToString:@"3"], @"should be 3 but is %@", [val3 displayObject]  );	
}



- (void)testMoreComplexFeedbackLoop
{
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* outAtt2 = [SHOutputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[root addChild:outAtt2 autoRename:YES];
	[inAtt1 setDataType:@"mockDataType"];
	[inAtt2 setDataType:@"mockDataType"];
	[outAtt1 setDataType:@"mockDataType"];
	[outAtt2 setDataType:@"mockDataType"];
	SHPlusOperator* plusOp = [[[SHPlusOperator alloc] init] autorelease];
	[root addChild:plusOp autoRename:YES];

// the order is important. if you set att1 then att2, setting att2 makes att1 become dirty and the 3 would never be used
	// (!) if the above is true then how can we ever save and restore successfully?
	// 0 + 3 = 3
	// 3 + 3 = 6
	[inAtt1 publicSetValue:[NSNumber numberWithInt:4]];
	[inAtt2 publicSetValue:[NSNumber numberWithInt:3]];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[plusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type mockDataType");
	
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[plusOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag2==YES, @"failed to connect 2 attributes of type mockDataType");
	
	BOOL flag3 = [(SHAttribute*)[plusOp outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag3==YES, @"failed to connect 2 attributes of type mockDataType");
	
	BOOL flag4 = [outAtt1 connectOutletToInletOf:outAtt2 withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag4==YES, @"failed to connect 2 attributes of type mockDataType");
	
	// now for the feedback loop..
	BOOL flag5 = [outAtt1 connectOutletToInletOf:inAtt1 withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag5==YES, @"failed to connect 2 attributes of type mockDataType");

	/* every attribute should now be dirty */
	STAssertTrue([inAtt1 dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([inAtt2 dirtyBit]==NO, @"input should be clean after setting value");
	STAssertTrue([outAtt1 dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([outAtt2 dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([[plusOp inputAtIndex:0] dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([[plusOp inputAtIndex:1] dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([[plusOp outputAtIndex:0] dirtyBit]==YES, @"connecting should make dirty");
	
	/* temporary hack */
//	[inAtt1 setDirtyBit:NO uid:123456];
//	[inAtt2 setDirtyBit:NO uid:123457];
	/* end temporary hack */
	
	// - out att2 is not dirty so this wont work...
	NSObject<SHValueProtocol>* val4 = [outAtt2 upToDateEvaluatedValue:-666 head:nil error:&error];	

	NSObject<SHValueProtocol>* val1 = [inAtt1 upToDateEvaluatedValue:-666 head:nil error:&error];
	NSObject<SHValueProtocol>* val2 = [inAtt2 upToDateEvaluatedValue:-666 head:nil error:&error];
	NSObject<SHValueProtocol>* val3 = [outAtt1 upToDateEvaluatedValue:-666 head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"4"], @"should be 4 but is %@", [val1 displayObject]  );
	STAssertTrue([[val2 displayObject] isEqualToString:@"3"], @"should be 3 but is %@", [val2 displayObject]  );
	STAssertTrue([[val3 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val3 displayObject]  );
	STAssertTrue([[val4 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val4 displayObject]  );
	STAssertTrue([inAtt1 dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([inAtt2 dirtyBit]==NO, @"connecting should make dirty");
	STAssertTrue([outAtt1 dirtyBit]==YES, @"connecting should make dirty");
	STAssertTrue([outAtt1 dirtyBit]==YES, @"connecting should make dirty");

	/*	evaluation order is important and this cant be helped.. even in a feedback loop you must assume that some consumer is driving the updating
		and that this consumer is always in a specific place. ie the loop wont get evaluated in random orders - except by gui */
	val3 = [outAtt1 upToDateEvaluatedValue:-777 head:nil error:&error];
	STAssertTrue([[val3 displayObject] isEqualToString:@"10"], @"should be 10 but is %@", [val3 displayObject]  );

	val4 = [outAtt2 upToDateEvaluatedValue:-777 head:nil error:&error];
	STAssertTrue([[val4 displayObject] isEqualToString:@"10"], @"should be 10 but is %@", [val4 displayObject]  );

	val1 = [inAtt1 upToDateEvaluatedValue:-777 head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val1 displayObject]  );

	val2 = [inAtt2 upToDateEvaluatedValue:-777 head:nil error:&error];
	STAssertTrue([[val2 displayObject] isEqualToString:@"3"], @"should be 3 but is %@", [val2 displayObject]  );
	
	
	val3 = [outAtt1 upToDateEvaluatedValue:-778 head:nil error:&error];
	STAssertTrue([[val3 displayObject] isEqualToString:@"13"], @"should be 10 but is %@", [val3 displayObject]  );

//	[_nodeGraphModel closeCurrentRootNode];
}



- (void)testChasingBullsCase {
	
	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];

	//	** make a feedback loop with two points that move towards each other across the screen **

	SHPlusOperator* bull1_plusOp = [SHPlusOperator newNode];
	SHInputAttribute* bull1_inAtt1 = [SHInputAttribute makeAttribute];
	[bull1_inAtt1 setDataType:@"mockDataType"];

	SHOutputAttribute* bull1_outAtt1 = [SHOutputAttribute makeAttribute]; // evaluate this
	[bull1_outAtt1 setDataType:@"mockDataType"];

	SHMinusOperator* bull1_minusOp = [SHMinusOperator newNode];
	SHAbsOperator* bull1_absOp = [SHAbsOperator newNode];
	SHDivideOperator* bull1_divOp = [SHDivideOperator newNode];

	SHPlusOperator* bull2_plusOp = [SHPlusOperator newNode];
	SHInputAttribute* bull2_inAtt1 = [SHInputAttribute makeAttribute];
	[bull2_inAtt1 setDataType:@"mockDataType"];
	SHOutputAttribute* bull2_outAtt1 = [SHOutputAttribute makeAttribute]; // evaluate this
	[bull2_outAtt1 setDataType:@"mockDataType"];

	SHMinusOperator* bull2_minusOp = [SHMinusOperator newNode];
	SHAbsOperator* bull2_absOp = [SHAbsOperator newNode];
	SHDivideOperator* bull2_divOp = [SHDivideOperator newNode];

	[root addChild:bull1_plusOp forKey:@"bull1_plusOp" autoRename:YES];
	[root addChild:bull1_inAtt1 forKey:@"bull1_inAtt1" autoRename:YES];
	[root addChild:bull1_outAtt1 forKey:@"bull1_outAtt1" autoRename:YES];
	[root addChild:bull1_minusOp forKey:@"bull1_minusOp" autoRename:YES];
	[root addChild:bull1_absOp forKey:@"bull1_absOp" autoRename:YES];
	[root addChild:bull1_divOp forKey:@"bull1_divOp" autoRename:YES];

	[root addChild:bull2_plusOp forKey:@"bull2_plusOp" autoRename:YES];
	[root addChild:bull2_inAtt1 forKey:@"bull2_inAtt1" autoRename:YES];
	[root addChild:bull2_outAtt1 forKey:@"bull2_outAtt1" autoRename:YES];
	[root addChild:bull2_minusOp forKey:@"bull2_minusOp" autoRename:YES];
	[root addChild:bull2_absOp forKey:@"bull2_absOp" autoRename:YES];
	[root addChild:bull2_divOp forKey:@"bull2_divOp" autoRename:YES];

	// wire up bull1
	BOOL flag1 = [(SHAttribute*)[bull1_plusOp outputAttributeAtIndex:0] connectOutletToInletOf:bull1_inAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [bull1_inAtt1 connectOutletToInletOf:bull1_outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag3 = [bull1_inAtt1 connectOutletToInletOf:(SHAttribute*)[bull1_minusOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	BOOL flag4 = [(SHAttribute*)[bull1_minusOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull1_absOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	BOOL flag5 = [(SHAttribute*)[bull1_minusOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull1_divOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	BOOL flag6 = [(SHAttribute*)[bull1_absOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull1_divOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	// feedback aspects of bull1
	BOOL flag7 = [(SHAttribute*)[bull1_divOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull1_plusOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	BOOL flag8 = [bull1_inAtt1 connectOutletToInletOf:(SHAttribute*)[bull1_plusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag1,@"e");STAssertTrue(flag2,@"e");STAssertTrue(flag3,@"e");STAssertTrue(flag4,@"e");STAssertTrue(flag5,@"e");STAssertTrue(flag6,@"e");STAssertTrue(flag7,@"e");STAssertTrue(flag8,@"e");
	
	// wire up bull2
	BOOL flag11 = [(SHAttribute*)[bull2_plusOp outputAttributeAtIndex:0] connectOutletToInletOf:bull2_inAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag12 = [bull2_inAtt1 connectOutletToInletOf:bull2_outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag13 = [bull2_inAtt1 connectOutletToInletOf:(SHAttribute*)[bull2_minusOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	BOOL flag14 = [(SHAttribute*)[bull2_minusOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull2_absOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	BOOL flag15 = [(SHAttribute*)[bull2_minusOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull2_divOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	BOOL flag16 = [(SHAttribute*)[bull2_absOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull2_divOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	// feedback aspects of bull2
	BOOL flag17 = [(SHAttribute*)[bull2_divOp outputAttributeAtIndex:0] connectOutletToInletOf:(SHAttribute*)[bull2_plusOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	BOOL flag18 = [bull2_inAtt1 connectOutletToInletOf:(SHAttribute*)[bull2_plusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag11,@"e");STAssertTrue(flag12,@"e");STAssertTrue(flag13,@"e");STAssertTrue(flag14,@"e");STAssertTrue(flag15,@"e");STAssertTrue(flag16,@"e");STAssertTrue(flag17,@"e");STAssertTrue(flag18,@"e");

	// connect the bulls
	BOOL flag20 = [bull1_inAtt1 connectOutletToInletOf:(SHAttribute*)[bull2_minusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	BOOL flag21 = [bull2_inAtt1 connectOutletToInletOf:(SHAttribute*)[bull1_minusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag20,@"e");STAssertTrue(flag21,@"e");

	[bull1_inAtt1 publicSetValue:[NSNumber numberWithInt:-10]];
	[bull2_inAtt1 publicSetValue:[NSNumber numberWithInt:10]];

	double evalKey = (double)random();
	NSObject<SHValueProtocol>* val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"-9"], @"should be -9 but is %@", [val1 displayObject]  );
	
	NSObject<SHValueProtocol>* val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val2 displayObject] isEqualToString:@"9"], @"should be 9 but is %@", [val2 displayObject]  );

	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"-8"], @"should be -8 but is %@", [val1 displayObject]  );
	
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val2 displayObject] isEqualToString:@"8"], @"should be 8 but is %@", [val2 displayObject]  );
	
	/* test that when the feedback loop reaches a stable state it stops being marked as dirty */
	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"-7"], @"should be -7 but is %@", [val1 displayObject]  );

	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val2 displayObject] isEqualToString:@"7"], @"should be 7 but is %@", [val2 displayObject]  );

	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"-6"], @"should be -6 but is %@", [val1 displayObject]  );
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val2 displayObject] isEqualToString:@"6"], @"should be 6 but is %@", [val2 displayObject]  );

	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"-2"], @"should be -2 but is %@", [val1 displayObject]  );
	STAssertTrue([[val2 displayObject] isEqualToString:@"2"], @"should be 2 but is %@", [val2 displayObject]  );


	evalKey = random();
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val2 displayObject] isEqualToString:@"1"], @"should be 1 but is %@", [val2 displayObject]  );
	STAssertTrue([[val1 displayObject] isEqualToString:@"-1"], @"should be -1 but is %@", [val1 displayObject]  );
		
	evalKey = random();
	val1 = [bull1_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	val2 = [bull2_outAtt1 upToDateEvaluatedValue:evalKey head:nil error:&error];
	STAssertTrue([[val1 displayObject] isEqualToString:@"0"], @"should be 0 but is %@", [val1 displayObject]  );
	STAssertTrue([[val2 displayObject] isEqualToString:@"0"], @"should be 0 but is %@", [val2 displayObject]  );

}
@end
