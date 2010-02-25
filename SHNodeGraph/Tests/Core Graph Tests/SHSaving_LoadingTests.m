//
//  SHSaving_LoadingTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 11/04/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHSaving_LoadingTests.h"
#import "mockDataType.h"
#import <FScript/FScript.h>
#import <SHNodeGraph/SHNodeGraph.h>
#import "FScriptSavingProtoNode.h"
#import "FScriptSavingAttribute.h"
#import "FScriptSavingProtoNode.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHPlusOperator.h"
#import "SHInterConnector.h"
#import "SHNodeAttributeMethods.h"


/*
 *
 */
@interface SHSaving_LoadingTests : SenTestCase {
	
	SHNodeGraphModel *_nodeGraphModel;
	
}

@end


/*
 *
*/
@implementation SHSaving_LoadingTests

// build a feedback loop to test saving
// try copying, duplicating saving is equal - on some feedback shit
- (SHNode *)feedbackLoop {

	NSError* error=nil;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* inAtt1 = [SHInputAttribute makeAttribute];
	SHInputAttribute* inAtt2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* outAtt2 = [SHOutputAttribute makeAttribute];
	[root addChild:inAtt1 autoRename:YES];
    [inAtt1 setDataType:@"SHNumber"];

	[root addChild:inAtt2 autoRename:YES];
	[root addChild:outAtt1 autoRename:YES];
	[root addChild:outAtt2 autoRename:YES];
	[inAtt2 setDataType:@"SHNumber"];
	[outAtt1 setDataType:@"SHNumber"];
	[outAtt2 setDataType:@"SHNumber"];
	SHPlusOperator* plusOp = [[[SHPlusOperator alloc] init] autorelease];	
	[root addChild:plusOp autoRename:YES];
	
	BOOL flag1 = [inAtt1 connectOutletToInletOf:(SHAttribute*)[plusOp inputAttributeAtIndex:0] withConnector:[SHInterConnector interConnector]];
	BOOL flag2 = [inAtt2 connectOutletToInletOf:(SHAttribute*)[plusOp inputAttributeAtIndex:1] withConnector:[SHInterConnector interConnector]];
	BOOL flag3 = [(SHAttribute*)[plusOp outputAttributeAtIndex:0] connectOutletToInletOf:outAtt1 withConnector:[SHInterConnector interConnector]];
	BOOL flag4 = [outAtt1 connectOutletToInletOf:outAtt2 withConnector:[SHInterConnector interConnector]];
	// now for the feedback loop..
	BOOL flag5 = [outAtt1 connectOutletToInletOf:inAtt1 withConnector:[SHInterConnector interConnector]];
	STAssertTrue(flag1, @"a"); STAssertTrue(flag2, @"a"); STAssertTrue(flag3, @"a"); STAssertTrue(flag4, @"a"); STAssertTrue(flag5, @"a"); 
	[inAtt2 publicSetValue:@"3"];
	[inAtt1 publicSetValue:@"4"]; // the order is important. if you set att1 then att2, setting att2 makes att1 become dirty and the 3 would never be used

	NSObject<SHValueProtocol>* val1 = [outAtt2 upToDateEvaluatedValue:random() head:nil error:&error];
    val1 = [outAtt2 upToDateEvaluatedValue:random() head:nil error:&error];
	return root;
}

- (void)setUp
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHAttributeTests ERROR.. Couldnt make a nodeModel");
	[pool release];
}

- (void)tearDown
{
	[_nodeGraphModel release];
	_nodeGraphModel = nil;
}

- (void)testIsEqual {
	
	//	make root node
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHNode* childNode1 = [SHNode newNode];
	SHNode* childNode2 = [SHNode newNode];
	[root addChild:childNode1 autoRename:YES];
	// STAssertFalse([childNode1 isEquivalentTo:childNode2], @"have different parents so cant be equal");
	[root addChild:childNode2 autoRename:YES];
	STAssertTrue([childNode1 isEquivalentTo:childNode2], @"should be equal");

	SHNode* childNode3 = [SHNode newNode];
	SHNode* childNode4 = [SHNode newNode];
	[childNode1 addChild:childNode3 autoRename:YES];
	STAssertFalse([childNode1 isEquivalentTo:childNode2], @"have different contents so cant be equal");
	[childNode2 addChild:childNode4 autoRename:YES];
	STAssertTrue([childNode1 isEquivalentTo:childNode2], @"should be equal");
	
	// test1 - input to output
	SHInputAttribute* atChild1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* atChild2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[childNode3 addChild:atChild1 autoRename:YES];
	STAssertFalse([childNode1 isEquivalentTo:childNode2], @"have different contents so cant be equal");
	[childNode4 addChild:atChild2 autoRename:YES];
	STAssertTrue([childNode1 isEquivalentTo:childNode2], @"should be equal");
	
	SHOutputAttribute* o1 = [SHOutputAttribute  attributeWithType:@"mockDataType"];
	SHOutputAttribute* o2 = [SHOutputAttribute  attributeWithType:@"mockDataType"];
	[childNode3 addChild:o1 autoRename:YES];
	[childNode4 addChild:o2 autoRename:YES];
	STAssertTrue([childNode1 isEquivalentTo:childNode2], @"should be equal");
	SHInterConnector* int1 = [childNode3 connectOutletOfAttribute:atChild1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"connection shouldnt have failed");
	STAssertFalse([childNode1 isEquivalentTo:childNode2], @"have different connections so cant be equal");
	SHInterConnector* int2 = [childNode4 connectOutletOfAttribute:atChild2 toInletOfAttribute:o2];
	STAssertNotNil(int2, @"connection shouldnt have failed");
	STAssertTrue([childNode1 isEquivalentTo:childNode2], @"should be equal");
}

- (void)testIsEqual_WithFeedback
{
	//	make root node
	SHNode* root1 = [self feedbackLoop];
	SHNode* root2 = [self feedbackLoop];
	STAssertTrue([root1 isEquivalentTo:root2], @"should be equal");
}

- (void)testCopyWithZone
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* o1 = [SHOutputAttribute makeAttribute];	
	[root addChild:i1 autoRename:YES];
	[root addChild:o1 autoRename:YES];
	[i1 setDataType:@"mockDataType"];
	[o1 setDataType:@"mockDataType"];
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"a");

	SHNode* root2 = [[root copy] autorelease];
	BOOL flag = [root2 isEquivalentTo: root];
	STAssertTrue(flag==YES, @"should be roughly the same");
}

- (void)testCopyWithZone_WithFeedback
{
	//	make root node
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	SHNode* root1 = [self feedbackLoop];
	SHNode* root2 = [[root1 copy] autorelease];
	STAssertTrue([root1 isEquivalentTo:root2], @"should be equal");
//	NSLog(@"!!!!! - %@, gc is %s", [root2 description], [[NSGarbageCollector defaultCollector] isEnabled] ? "on" : "off");
//	[root1 retain];
//    [pool release];
//	[_nodeGraphModel retain];
//	[NSData alloc];
//	[root2 release];
	
//	[[NSString alloc] init];
//	[[NSObject alloc] init];
//	SH_Path *path1 = [[SH_Path alloc] init];
//	[[SHNode alloc] init];
}

- (void)testFScriptString_duplicateContentsInto
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* o1 = [SHOutputAttribute makeAttribute];	
	[root addChild:i1 autoRename:YES];
	[root addChild:o1 autoRename:YES];
	[i1 setDataType:@"mockDataType"];
	[o1 setDataType:@"mockDataType"];
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"a");

	NSString* nodeString = [NSString stringWithString:@"aNode := SHNode alloc init autorelease .\n"];
	nodeString = [nodeString stringByAppendingFormat:@"aNode setName:'%@' .\n", [root name] ];

	NSString* as = [root fScriptString_duplicateContentsInto:@"aNode"];
	NSAssert(as!=nil, @"er, nil string");
	nodeString = [nodeString stringByAppendingString: as];
	
	// add onn the return value
	nodeString = [nodeString stringByAppendingString: @"aNode"];

	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: nodeString];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	logInfo(@"SHSavingAndLoadingTests: result is %@", result);

	if(!result){
		STFail(@"Failed to execute save string for node");
	}
	STAssertTrue([root isEquivalentTo:result], @"should be roughly the same");
    [pool release];
}

//#warning need to make all attributes save? what does this mean?
// ** make it so that all attributes in a feedback loop are saved **

- (void)testSaveFScriptString
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHInputAttribute* i1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* o1 = [SHOutputAttribute makeAttribute];
	SHNode* node1 = [SHNode newNode];
	SHNode* node2 = [SHNode newNode];
	SHNode* node3 = [SHNode newNode];
	[node1 setName:@"level2_node1"];
	[node2 setName:@"level2_node2"];
	[node3 setName:@"level3_node3"];
	[root addChild:node1 autoRename:YES];
	[root addChild:node2 autoRename:YES];
	[node2 addChild:node3 autoRename:YES];
	[root addChild:i1 autoRename:YES];
	[root addChild:o1 autoRename:YES];
	[i1 setDataType:@"mockDataType"];
	NSString *val1 = [NSString stringWithFormat:@"chicken3"];
	[i1 publicSetValue: val1];

	[o1 setDataType:@"mockDataType"];
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"a");
	
	NSString* saveString1 = [root fScriptString_duplicate];
		
	logInfo(@"%@", saveString1);
	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: saveString1];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	logInfo(@"result is %@", result);

	if(!result){
		STFail(@"Failed to execute save string for node");
	}
	
	STAssertTrue([root isEquivalentTo:result], @"should be roughly the same");
	
	SHInputAttribute* i2 = (SHInputAttribute *)[result inputAttributeAtIndex:0];
	STAssertTrue([[i2 displayValue] isEqualToString:[i1 displayValue]], @"should be the same");
}

- (void)testSaveName
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* node1 = [SHNode newNode];
	[node1 setName:@"level2 node1"];
	[root addChild:node1 autoRename:YES];
	[node1 setTemporaryID:999];
	NSString* saveName1 = [node1 saveName];
	STAssertTrue([saveName1 isEqualToString:@"level2node1_999"], @"should be roughly the same but is %@", saveName1);
}

- (void)testShouldRestoreState
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHInputAttribute* i1 = [SHInputAttribute makeAttribute];
	[root addChild:i1 autoRename:YES];
	[i1 setDataType:@"mockDataType"];
	[i1 setShouldRestoreState:NO];
	NSString *val1 = [NSString stringWithFormat:@"chicken3"];
	[i1 publicSetValue: val1]; // this is the value that won't be restored
	
	NSString* saveString1 = [root fScriptString_duplicate];		
	logInfo(@"%@", saveString1);
	FSInterpreter* theInterpreter = [FSInterpreter interpreter];
	FSInterpreterResult* execResult = [theInterpreter execute: saveString1];
	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	logInfo(@"result is %@", result);

	if(!result){
		STFail(@"Failed to execute save string for node");
	}
	
	STAssertFalse([root isEquivalentTo:result], @"should not be the same");

	SHInputAttribute* i2 = (SHInputAttribute *)[result inputAttributeAtIndex:0];
	STAssertFalse([[i2 displayValue] isEqualToString:[i1 displayValue]], @"should not be the same");
}


@end
