//
//  SHAttributeTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright (c) 2006 HooleyHoop. All rights reserved.
//

#import "SHAttributeTests.h"
#import "mockDataType.h"
#import <FScript/FScript.h>
#import <SHNodeGraph/SHNodeGraph.h>
#import "FScriptSavingAttribute.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHMutableBool.h"
#import "SHPlusOperator.h"
#import "SHInterConnector.h"
#import "SHConnectableNode.h"
#import "SHNodeAttributeMethods.h"


/*
 *
 */
@interface SHAttributeTests : SenTestCase {
	
    SHNodeGraphModel *_nodeGraphModel;
	SHUndoManager *_um;
}


@end

/*
 *
*/
@implementation SHAttributeTests


- (void)setUp
{
	_nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	_um = [[NSUndoManager alloc] init];

	STAssertNotNil( _nodeGraphModel, @"SHAttributeTests ERROR.. Couldnt make a nodeModel");
	STAssertNotNil( _um, @"SHAttributeTests ERROR.. need an undo ma thingy");
}


- (void)tearDown
{
	[_nodeGraphModel release];
	[_um release];
}


- (void)testAttributeWithType
{
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	STAssertNotNil(inAtt1, @"SHAttributeTests ERROR.. Couldnt init a child node");
	SHNode* ob1 = [_nodeGraphModel rootNodeGroup];
	[ob1 addChild:inAtt1 autoRename:YES];
	// test this somehow
}
	

- (void)testInitWithParentNodeGroup
{
	SHNode* ob1 = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* child = [SHInputAttribute attributeWithType:@"mockDataType"];
	[ob1 addChild:child autoRename:YES];
	STAssertNotNil(child, @"SHAttributeTests ERROR.. Couldnt init a child node");
	STAssertEqualObjects(ob1, [child parentSHNode], @"attribute testInitWithParentNodeGroup has failed somehow");

	SHOutputAttribute* child2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[ob1 addChild:child2 autoRename:YES];
	STAssertNotNil(child2, @"SHAttributeTests ERROR.. Couldnt init a child node");
	STAssertEqualObjects(ob1, [child2 parentSHNode], @"attribute testInitWithParentNodeGroup has failed somehow");
}

static BOOL nameDiDChangeKVO = NO;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"name"]) {
			nameDiDChangeKVO = YES;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];      
    }
}

- (void)testSetName
{
	// - (BOOL)setName:(NSString *)aName;
	SHNode* ob1 = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* child = [SHInputAttribute attributeWithType:@"mockDataType"];
	[ob1 addChild:child autoRename:YES];
	[child addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
	[child setName:@"steve"];
	id ob2 = [ob1 childWithKey:@"steve"];
	STAssertNotNil(ob2, @"SHAttributeTests setName has failed somehow");
	STAssertEqualObjects(child, ob2, @"SHAttributeTests setName has failed somehow");
	STAssertTrue(nameDiDChangeKVO, @"what happened to KVO notification of name change?");
	nameDiDChangeKVO = NO;

	SHOutputAttribute* ob3 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[ob1 addChild:ob3 autoRename:YES];

	[ob3 setName:@"att3"];
	STAssertNotNil(ob3, @"SHAttributeTests setName has failed somehow");
	STAssertThrows([ob3 setName:@"steve"], @"Need to check name is unique first");
	NSString* ob4 = [ob3 name];
	STAssertTrue([ob4 isEqualToString:@"steve"]==NO, @"SHAttributeTests setName shouldn't let you have duplicate names");
	id nilObject = [ob1 childWithKey:@"doesnt exist"];
	STAssertTrue(nilObject==nil, @"SHAttributeTests somehow got a node for a madeup name");
	
	// test that we can change name when connected
	SHInterConnector* test = [[[SHInterConnector alloc] init] autorelease];
	
	// inAttribute to inAttribute
	SHInputAttribute* att1 = child;
	SHOutputAttribute* att2 = ob3;
	BOOL flag1 = [att1 connectOutletToInletOf:att2 withConnector:test];

	BOOL flag2 = [att1 isOutletConnected];
	BOOL flag3 = [att2 isInletConnected];
	STAssertTrue(flag1, @"eh");
	STAssertTrue(flag2==YES, @"return connectlet state is wrong");
	STAssertTrue(flag3==YES, @"return connectlet state is wrong");
	[att1 setName:@"frump"];
	[att2 setName:@"aLump"];
	flag2 = [att1 isOutletConnected];
	flag3 = [att2 isInletConnected];
	STAssertTrue(flag2==YES, @"return connectlet state is wrong");
	STAssertTrue(flag3==YES, @"return connectlet state is wrong");
	
	/* Test Undo */
	[_um beginDebugUndoGroup];
		[child setName:@"undoRedo"];
		STAssertTrue([[child name] isEqualToString:@"undoRedo"]==YES, @"should work");
	[_um endUndoGrouping];
	
	[child clearRecordedHits];
	nameDiDChangeKVO = NO;
	[_um undo];
	BOOL hitRecordResult1 = [child assertRecordsIs:@"_setUniqueName:", nil];
	NSMutableArray *actualRecordings1 = [child recordedSelectorStrings];
	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
	
	STAssertTrue(nameDiDChangeKVO, @"what happened to KVO notification of name change?");
	STAssertTrue([[child name] isEqualToString:@"frump"]==YES, @"should work - %@", [child name] );	

	[child clearRecordedHits];
	[_um redo];
	BOOL hitRecordResult2 = [child assertRecordsIs:@"_setUniqueName:", nil];
	NSMutableArray *actualRecordings2 = [child recordedSelectorStrings];
	STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);	
	
	STAssertTrue([[child name] isEqualToString:@"undoRedo"]==YES, @"should work");
	
    [child removeObserver:self forKeyPath:@"name"];
}


- (void)testchildWithKey
{
	SHNode* ob1 = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* child = [SHInputAttribute attributeWithType:@"mockDataType"];
	[ob1 addChild:child autoRename:YES];

	[child setName:@"steve"];
	id ob2 = [ob1 childWithKey:@"steve"];
	STAssertEqualObjects(child, ob2, @"SHAttributeTests testNodeNamed has failed somehow");
}


//- (void)testPostNodeGuiMayNeedRebuildingNotification
//{
//	// basically you have to redo this evrytime current nodegroup changes
//	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//	SHNode* ob1 = [_nodeGraphModel rootNodeGroup];
//	SHInputAttribute* child = [SHInputAttribute attributeWithType:@"mockDataType"];
//	[ob1 addChild:child autoRename:YES];
//
//	//15/11/05	[nc addObserver: self selector:@selector(receiveSelectedNodesChangedNotification:) name:@"SHSelectedNodeIndexesChanged" object: _currentNodeGroup ];
//	[nc addObserver: self selector:@selector(updateNodeGUI:) name:@"nodeGuiMayNeedRebuilding" object:child ];
//
//	[child performSelectorOnMainThread:@selector(postNodeGuiMayNeedRebuilding_Notification) withObject:nil waitUntilDone:NO];
//}

// ===========================================================
// - updateNodeGUI:
// ===========================================================
//- (void)updateNodeGUI:(NSNotification*) note
//{
//	SHNode* aNode = [note object];
//	logInfo(@"attribute testPostNodeGuiMayNeedRebuildingNotification.m: woaah, received notification a ok");
//	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//	[nc removeObserver:self];
//}



- (void)testValueWasUpdatedManually
{
	NSError* error=nil;
	
	// - (void) valueWasUpdatedManually
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"SHMutableBool"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"SHMutableBool"];
	[root addChild:i1 autoRename:YES];
	[root addChild:o1 autoRename:YES];
	SHInterConnector* c1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(c1, @"eh");
	// the input and the output are now the same value
	
	SHMutableBool* naughtyValue = (SHMutableBool*)[i1 upToDateEvaluatedValue:random() head:nil error:&error];
	SHMutableBool* wellBehavedValue = (SHMutableBool*)[o1 upToDateEvaluatedValue:random() head:nil error:&error];
	STAssertNotNil(naughtyValue, @"eh");
	STAssertNotNil(wellBehavedValue, @"eh");
	
	// all dirty flags are now set to clean
	[naughtyValue setBoolValue: YES];
	STAssertTrue([o1 dirtyBit]==NO, @"testValueWasUpdatedManually is wrong");
	[i1 valueWasUpdatedManually];
	STAssertTrue([o1 dirtyBit]==YES, @"testValueWasUpdatedManually is wrong");
	STAssertTrue([o1 dirtyBit]==YES, @"testValueWasUpdatedManually is wrong");
}

- (void)testSetSelectorToUseWhenAnswering
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[root addChild:i1 autoRename:YES];

	BOOL flag1 = [i1 setSelectorToUseWhenAnswering:@"mockDataType2Value"];
	STAssertTrue(flag1==NO, @"failed to setSelectorToUseWhenAnswering");
	
	BOOL flag2 = [i1 setSelectorToUseWhenAnswering:@"mockDataTypeValue"];
	STAssertTrue(flag2==YES, @"failed to setSelectorToUseWhenAnswering");
	//get selector from string
	//check that value responds to that selector
}

- (void)testFScriptString_duplicateContentsInto
{
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];

	NSString* attributeString = [NSString stringWithString:@"attribute := (SHInputAttribute alloc init) autorelease.\n"];
	attributeString = [attributeString stringByAppendingFormat:@"attribute setName:'%@' .\n", [inAtt1 name]];

	NSString* as = [inAtt1 fScriptString_duplicateContentsInto:@"attribute" restoreState:YES];
	NSAssert(as!=nil, @"er, nil string");
	attributeString = [attributeString stringByAppendingString: as];

	// append the return value
	attributeString = [attributeString stringByAppendingString:@"attribute"];
	
	FSInterpreterResult* execResult = [[FSInterpreter interpreter] execute: attributeString];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	logInfo(@"SHAttributeTests: result is %@", result);

	if(!result){
		STFail(@"Failed to execute save string for node");
	}
	
	STAssertTrue([inAtt1 isEquivalentTo:result], @"should be roughly the same");
}

- (void)testSaveFScriptString
{
	// make an attribute
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[root addChild:i1 autoRename:YES];
	[root addChild:o1 autoRename:YES];
	
	// get the save string
	NSString* saveString1 = [i1 fScriptString_duplicate];
	NSString* saveString2 = [o1 fScriptString_duplicate];
	
	logInfo(@"saveString1: %@", saveString1);
	// execute the save strings in fscript
	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: saveString1];
	logWarning(saveString1);
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	if(!result){
		STFail(@"Failed to execute save string");
	}			
	// is it the same
	STAssertTrue([i1 isEquivalentTo:result], @"should be roughly the same");

	execResult = [theInterpreter execute: saveString2];
	result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	if(!result){
		STFail(@"Failed to execute save string");
	}
	STAssertTrue([o1 isEquivalentTo:result], @"should be roughly the same");
}

- (void)testUpToDateEvaluatedValue_inToOut
{
	NSError* error=nil;

	// in to out
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	SHInterConnector* connector = [[[SHInterConnector alloc] init] autorelease];
	BOOL didConnect = [inAtt1 connectOutletToInletOf:outAtt1 withConnector:connector];
	STAssertTrue(didConnect, @"should be able to connect");
	if(didConnect){
		NSString *val2 = [NSString stringWithFormat:@"chicken9"];
		[inAtt1 publicSetValue: val2];
		NSObject<SHValueProtocol>* val = [outAtt1 upToDateEvaluatedValue:random() head:nil error:&error];
		STAssertTrue([[val displayObject] isEqualToString:@"chicken9"], @"should be roughly the same");
	}
}

- (void)testUpToDateEvaluatedValue_simpleInToIn
{
	NSError* error=nil;
	// simple in to in
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* inAtt2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:inAtt2 autoRename:YES];
	NSString *val2 = [NSString stringWithFormat:@"donald"];
	[inAtt2 publicSetValue: val2];

	SHInterConnector* connector = [[[SHInterConnector alloc] init] autorelease];
	BOOL flag2 = [inAtt1 connectOutletToInletOf:inAtt2 withConnector:connector];
	STAssertTrue(flag2, @"should be able to connect");
	if(flag2){
		NSString *val3 = [NSString stringWithFormat:@"fecker"];
		[inAtt1 publicSetValue: val3];
		NSObject<SHValueProtocol>* val2_n = [inAtt2 upToDateEvaluatedValue:random() head:nil error:&error];
		id ob2Val = [val2_n displayObject];
		STAssertTrue([ob2Val isEqualToString:@"fecker"], @"should be roughly the same");
	}
}

- (void)testUpToDateEvaluatedValue_inToIn
{
	NSError* error=nil;

	// in to in
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* inAtt2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	NSString *val3 = [NSString stringWithFormat:@"donald"];
	[inAtt2 publicSetValue: val3];
	SHNode* n1 = [SHNode newNode];

	[root addChild:inAtt1 autoRename:YES];
	[n1 addChild:inAtt2 autoRename:YES];
	[root addChild:n1 autoRename:YES];
	SHInterConnector* connector = [[[SHInterConnector alloc] init] autorelease];
	BOOL flag2 = [inAtt1 connectOutletToInletOf:inAtt2 withConnector:connector];
	STAssertTrue(flag2, @"should be able to connect");
	if(flag2){
		NSString *val4 = [NSString stringWithFormat:@"fecker"];
		[inAtt1 publicSetValue: val4];
		NSObject<SHValueProtocol>* val2 = [inAtt2 upToDateEvaluatedValue:random() head:nil error:&error];
		id ob2Val = [val2 displayObject];
		STAssertTrue([ob2Val isEqualToString:@"fecker"], @"should be roughly the same");
	}
}

- (void)testUpToDateEvaluatedValue_outToOut
{
	NSError* error=nil;
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHNode* n1 = [SHNode newNode];

	// out to out
	SHOutputAttribute* outAtt2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt3 = [SHOutputAttribute attributeWithType:@"mockDataType"];

	[n1 addChild:outAtt2 autoRename:YES];
	[root addChild:outAtt3 autoRename:YES];
	SHInterConnector* connector3 = [[[SHInterConnector alloc] init] autorelease];
	BOOL flag3 = [outAtt2 connectOutletToInletOf:outAtt3 withConnector:connector3];
	STAssertTrue(flag3, @"should be able to connect");
	if(flag3){
		NSString *val4 = [NSString stringWithFormat:@"shaznee"];
		[outAtt2 publicSetValue: val4];
		NSObject<SHValueProtocol>* val3 = [outAtt3 upToDateEvaluatedValue:random() head:nil error:&error];
		STAssertTrue([[val3 displayObject] isEqualToString:@"shaznee"], @"should be roughly the same");
	}
}

- (void)testIsInFeedBackLoop
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];

	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt2 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[root addChild:inAtt1 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [outAtt1 connectOutletToInletOf:inAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag3 = [outAtt1 connectOutletToInletOf:outAtt2 withConnector:[SHInterConnector interConnector]];

	STAssertTrue(flag1==YES, @"return connectlet state is wrong");
	STAssertTrue(flag2==YES, @"return connectlet state is wrong");
	STAssertTrue(flag3==YES, @"return connectlet state is wrong");

	STAssertTrue([inAtt1 isInFeedbackLoop]==YES, @"return connectlet state is wrong");
	STAssertTrue([outAtt1 isInFeedbackLoop]==YES, @"return connectlet state is wrong");
	STAssertTrue([outAtt2 isInFeedbackLoop]==NO, @"return connectlet state is wrong");

	STAssertTrue(flag1==YES, @"return connectlet state is wrong");
}

/* same as above, lets go into depth - there is a bug there somewhere */
- (void)testisAttributeDownstream {
//- (BOOL)isAttributeDownstream:(SHAttribute *)anAtt

// need to try all dificult combinations
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* i2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[i1 setName:@"root_in1"];
	[i2 setName:@"root_in2"];
	[root addChild:i1 autoRename:YES];
	[root addChild:i2 autoRename:YES];

	// add subgroup
		SHNode* node1 = [SHNode newNode];
		[node1 setName:@"root_subgroup"];
		[root addChild:node1 autoRename:YES];
		
		// add 2 inputs
		SHInputAttribute* subi1 = [SHInputAttribute attributeWithType:@"mockDataType"];
		SHInputAttribute* subi2 = [SHInputAttribute attributeWithType:@"mockDataType"];
		[subi1 setName:@"sub_in1"];
		[subi2 setName:@"sub_in2"];
		[node1 addChild:subi1 autoRename:YES];
		[node1 addChild:subi2 autoRename:YES];
	
		// add plus
		SHPlusOperator* plusChild = [SHPlusOperator newNode];
		[node1 addChild:plusChild autoRename:YES];

		// add output
		SHOutputAttribute* subo1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
		[subo1 setName:@"sub_out1"];
		[node1 addChild:subo1 autoRename:YES];
		
		// connect in child
		BOOL flag1 = [(SHAttribute*)subi1 connectOutletToInletOf:(SHAttribute*)[plusChild inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
		BOOL flag2 = [(SHAttribute*)subi2 connectOutletToInletOf:(SHAttribute*)[plusChild inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
		BOOL flag3 = [(SHAttribute*)[plusChild outputAttributeAtIndex:0] connectOutletToInletOf:subo1 withConnector:[SHInterConnector interConnector]];

	STAssertTrue(flag1, @"eh");
	STAssertTrue(flag2, @"eh");
	STAssertTrue(flag3, @"eh");
	
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[o1 setName:@"root_out1"];
	[root addChild:o1 autoRename:YES];
	
	// connect root
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:(SHAttribute*)[node1 inputAttributeAtIndex:0]];
	SHInterConnector* int2 = [root connectOutletOfAttribute:i2 toInletOfAttribute:(SHAttribute*)[node1 inputAttributeAtIndex:1]];
	SHInterConnector* int3 = [root connectOutletOfAttribute:(SHAttribute*)[node1 outputAttributeAtIndex:0] toInletOfAttribute:o1];
	STAssertNotNil(int1, @"eh");
	STAssertNotNil(int2, @"eh");
	STAssertNotNil(int3, @"eh");

	// easy case
	BOOL res5 = [subo1 isAttributeDownstream:o1];
	STAssertTrue(res5, @"dsd");
	
	// 2 atts either side of plus operator - needs to take into account nodeIAffect
	BOOL res3 = [subi1 isAttributeDownstream:subo1];
	STAssertTrue(res3, @"dsd");
	
	// is o1 downstream of i1 ?
	BOOL res1 = [i1 isAttributeDownstream:o1];
	BOOL res2 = [i1 isAttributeDownstream:i2];
	STAssertTrue(res1, @"simple");
	STAssertFalse(res2, @"obvious");

	// now mix it up
	// this is connecting the in to the out instead of what we want!
	SHInterConnector* int4 = [root connectOutletOfAttribute:o1 toInletOfAttribute:i1];
	STAssertNotNil(int4, @"eh");

	// do tests again
	SHInputAttribute* plusin1 = (SHInputAttribute*)[plusChild inputAttributeAtIndex:0];
	BOOL res4 = [o1 isAttributeDownstream:plusin1];
	STAssertTrue(res4, @"feeback stuff NOT working");
}

- (void)testValue {
	//- (NSObject<SHValueProtocol> *)value
	//	STFail(@"Todo");
}

- (void)testSetValue {
	//- (void)setValue:(NSObject<SHValueProtocol> *)a_value
	//	STFail(@"Todo");
}

- (void)testWillAsk {
	//- (NSString*)willAsk
	// 	STFail(@"Todo");
}

- (void)testSetDirtyBit {
	//- (void)setDirtyBit:(BOOL)flag uid:(int)uid
	//	STFail(@"Todo");
}

- (void)testSetSelectorToUseWhenAnswering {
	//- (BOOL)setSelectorToUseWhenAnswering:(NSString *)aSelectorName
	// STFail(@"Todo");
}

- (void)testSetDirtyBelow {
	//- (void)setDirtyBelow:(int)uid
	
	//	STFail(@"Put back");
	// - test the state lock thing.. is it an instance var? or a class var? looks VERY dodgy
	//	SHNode* root = [_nodeGraphModel rootNodeGroup];
	//	SHProtoInputAttribute* i1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	//	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	//	SHNode* n1 = [SHNode newNode];
	//	
	//	[root addChild:i1 autoRename:YES];
	//	[root addChild:o1 autoRename:YES];
	//	[root addChild:n1 autoRename:YES];
	//	
	//	SHProtoInputAttribute* i2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	//	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	//	
	//	[n1 addChild:i2 autoRename:YES];
	//	[n1 addChild:o2 autoRename:YES];
	//	
	//	SHProtoInterConnector* c1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:i2];
	//	SHProtoInterConnector* c2 = [n1 connectOutletOfAttribute:i2 toInletOfAttribute:o2];
	//	SHProtoInterConnector* c3 = [root connectOutletOfAttribute:o2 toInletOfAttribute:o1];
	//	STAssertNotNil(c1, @"eh");
	//	STAssertNotNil(c2, @"eh");
	//	STAssertNotNil(c3, @"eh");
	//	
	//	[i1 setDirtyBit:NO uid:random()];
	//	[o1 setDirtyBit:NO uid:random()];
	//	[i2 setDirtyBit:NO uid:random()];
	//	[o2 setDirtyBit:NO uid:random()];
	//	
	//	[i1 setDirtyBelow:random()];
	//	
	//	STAssertTrue([i1 dirtyBit]==NO, @"1 testSetDirtyBelow failed");
	//	STAssertTrue([root dirtyBit]==YES, @"2 testSetDirtyBelow failed");
	//	STAssertTrue([o1 dirtyBit]==YES, @"3 testSetDirtyBelow failed");
	//	STAssertTrue([n1 dirtyBit]==YES, @"4 testSetDirtyBelow failed");
	//	STAssertTrue([i2 dirtyBit]==YES, @"5 testSetDirtyBelow failed");
	//	STAssertTrue([o2 dirtyBit]==YES, @"6 testSetDirtyBelow failed");
	//
	//	[o2 setDirtyBit:NO uid:random()];
	//	[o1 setDirtyBit:NO uid:random()];
	//	[o2 setDirtyBelow:random()];
	//	STAssertTrue([o2 dirtyBit]==NO, @"testSetDirtyBelow failed");
	//	STAssertTrue([o1 dirtyBit]==YES, @"testSetDirtyBelow failed");	
}

- (void)testSetDataType {
	//- (void)setDataType:(NSString *)aClassName
	//- (void)setDataType:(NSString *)aClassName withValue:(id)arg
	
	//	SHNode* root = [_nodeGraphModel rootNodeGroup];
	//	SHInputAttribute* i1 = [SHInputAttribute makeAttribute];
	//	SHOutputAttribute* o1 = [SHOutputAttribute makeAttribute];	
	//	[root addChild:i1 autoRename:YES];
	//	[root addChild:o1 autoRename:YES];
	//	
	//	[i1 setDataType:@"mockDataType"];
	//	[o1 setDataType:@"mockDataType"];
	//	
	//	// not much of a test
	//	SHInterConnector* test = [[[SHInterConnector alloc] init] autorelease];
	//	BOOL flag1 = [i1 connectOutletToInletOf:o1 withConnector:test];
	//	STAssertTrue(flag1==YES, @"failed to connect 2 attributes of type mockDataType");
	
	// see if there is a class called "datatypeClassString"
	// if the class is different from the current class
	// make a new instance with initial value
	// set value
	// get will answer array
	// set selector to use = will answer[0] // not actually important 
	// disconnect connected interconnectors if no longer compatible
	// post gui may need rebuilding notification
}

Protoattrube is just about adding and removing nodes, move this stuff back to attribute
- (void)testDirtyBit {
	//- (BOOL)dirtyBit
	
	SHProtoAttribute *att = [SHProtoAttribute attributeWithType:@"mockDataType"];
	STAssertFalse([att dirtyBit], @"should be clean");
}

- (void)testPublicSetValue {
	// - (void)publicSetValue:(id)aValue;
	
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[i1 publicSetValue:@"chicken8"];
	id ob = [i1 displayValue];
	STAssertTrue([ob isEqualToString:@"chicken8"], @"should be roughly the same %@", [i1 displayValue]);
}

- (void)testDisplayValue {
	
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	id ob = [i1 displayValue];
	STAssertTrue([ob isEqualToString:@"<<NSNull>>"], @"should be roughly the same");
}

@end
