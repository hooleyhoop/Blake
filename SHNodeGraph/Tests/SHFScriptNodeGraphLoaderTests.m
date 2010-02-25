//
//  SHFScriptNodeGraphLoaderTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 24/02/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHFScriptNodeGraphLoaderTests.h"
#import "SHNodeGraphModel.h"
#import "SHFScriptNodeGraphLoader.h"
#import "SHNode.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHConnectableNode.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"

@interface SHFScriptNodeGraphLoaderTests : SenTestCase {
	
	SHNodeGraphModel *_nodeGraphModel;
}

@end


@implementation SHFScriptNodeGraphLoaderTests

- (void)setUp {
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHAttributeTests ERROR.. Couldnt make a nodeModel");
}


- (void) tearDown {
	[_nodeGraphModel release];
	_nodeGraphModel = nil;
}

- (void)testSaveNodeToFile_loadNodeFromFile {
// - (BOOL)saveNode:aNode toFile:(NSString *)filePath
// - (SHNode *)loadNodeFromFile:(NSString *)filePath

    
     NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
// make a complicated node
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHInputAttribute* i1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* o1 = [SHOutputAttribute makeAttribute];
	SHInputAttribute* i2 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* o2 = [SHOutputAttribute makeAttribute];
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
	[root addChild:i2 autoRename:YES];
	[root addChild:o2 autoRename:YES];
	[i1 setDataType:@"mockDataType"];
	NSString *val = [NSString stringWithFormat:@"chicken1"];
	[i1 publicSetValue: val];
	[o1 setDataType:@"mockDataType"];
	[i2 setDataType:@"mockDataType"];
	[o2 setDataType:@"mockDataType"];

	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"a");

	// save
	SHFScriptNodeGraphLoader *nodeGraphLoader = [SHFScriptNodeGraphLoader nodeGraphLoader];
	NSString *stringPath = [[NSString stringWithString:@"~/Desktop/teeeeeeempp"] stringByExpandingTildeInPath];
	BOOL result = [nodeGraphLoader saveNode:root toFile:stringPath];
	STAssertTrue(result, @"should have saved");

	SHNode* newNode = [nodeGraphLoader loadNodeFromFile: stringPath];
	STAssertTrue([root isEquivalentTo: newNode], @"should be roughly the same");
//	NSFileManager* fileManager = [NSFileManager defaultManager];
//	result = [fileManager removeFileAtPath:stringPath handler:nil];
//	STAssertTrue(result, @"Not cleaning up properly after tests");
	
	[pool release];
}


// - (void)testIndentScript {
// - (NSString *)indentScript:(NSString *)aScript
// }

- (void)testFScriptWrapperFromChildren {
	// - (NSXMLElement *)fScriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode;

	SHNode* root = [_nodeGraphModel rootNodeGroup];	

	// There is..
	// a node
	SHNode* node1 = [SHNode newNode];
	[node1 setName:@"level2_node1"];
	[root addChild:node1 autoRename:YES];

	// input1
	// output1, output2
	SHInputAttribute* in1 = [SHInputAttribute makeAttribute];
	SHOutputAttribute* out1 = [SHOutputAttribute makeAttribute];
	SHOutputAttribute* out2 = [SHOutputAttribute makeAttribute];
	[in1 setDataType:@"mockDataType"];
	[out1 setDataType:@"mockDataType"];
	[out2 setDataType:@"mockDataType"];
	[root addChild:in1 autoRename:YES];
	[root addChild:out1 autoRename:YES];
	[root addChild:out2 autoRename:YES];

	// input1 is connected to output1 & output2
	SHInterConnector *con1 =[root connectOutletOfAttribute:in1 toInletOfAttribute: out1];
	[root connectOutletOfAttribute:in1 toInletOfAttribute: out2];

	// copy node, input1, output1
	SHFScriptNodeGraphLoader *nodeGraphLoader = [SHFScriptNodeGraphLoader nodeGraphLoader];
	NSXMLElement *copiedStuff = [nodeGraphLoader scriptWrapperFromChildren:[NSArray arrayWithObjects:con1, node1, in1, out1, nil] fromNode:root];

	// delete all
	[_nodeGraphModel deleteChildren:[[[_nodeGraphModel allChildrenFromCurrentNode] copy] autorelease] fromNode:root];
	NSArray *allRemainingChildren = [[[_nodeGraphModel allChildrenFromNode:root] copy] autorelease];
	STAssertTrue([allRemainingChildren count]==0, @"cant delete");
	
	// paste - we should have the Interconnector
	BOOL success = [nodeGraphLoader unArchiveChildrenFromScriptWrapper:copiedStuff intoNode:root];
	STAssertTrue(success, @"cant paste");
	
	// assert node, in, out and connector
	NSArray *nodesInside = (NSArray *)root.nodesInside;
	NSArray *inputs = (NSArray *)root.inputs;
	NSArray *outputs = (NSArray *)root.outputs;
	NSArray *shInterConnectorsInside = (NSArray *)root.shInterConnectorsInside;
	STAssertTrue([nodesInside count]==1, @"er");
	STAssertTrue([inputs count]==1, @"er");
	STAssertTrue([outputs count]==1, @"er");
	STAssertTrue([shInterConnectorsInside count]==1, @"er");
	SHInputAttribute* pastedInput = [inputs objectAtIndex:0];
	SHOutputAttribute* pastedOutput = [outputs objectAtIndex:0];
	STAssertTrue([pastedInput isAttributeDownstream:pastedOutput], @"er");
	
//	if parentNode is nil it should still work but with LESSTHAN
	
//	2.
//	copy input + output ( + connector )
	[_nodeGraphModel deleteChildren:[[[_nodeGraphModel allChildrenFromCurrentNode] copy] autorelease] fromNode:root];
	[root addChild:in1 autoRename:YES];
	[root addChild:out1 autoRename:YES];
	[root connectOutletOfAttribute:in1 toInletOfAttribute: out1];
	copiedStuff = [nodeGraphLoader scriptWrapperFromChildren:[NSArray arrayWithObjects:in1, out1, nil] fromNode:root];

	// paste 3 times
	success = [nodeGraphLoader unArchiveChildrenFromScriptWrapper:copiedStuff intoNode:root];
	success = [nodeGraphLoader unArchiveChildrenFromScriptWrapper:copiedStuff intoNode:root];
	success = [nodeGraphLoader unArchiveChildrenFromScriptWrapper:copiedStuff intoNode:root];

	// check each input is connected to one output (all different)
	nodesInside = (NSArray *)root.nodesInside;
	inputs = (NSArray *)root.inputs;
	outputs = (NSArray *)root.outputs;
	shInterConnectorsInside = (NSArray *)root.shInterConnectorsInside;

	// assert 4 inputs and 4 outputs
	STAssertTrue([nodesInside count]==0, @"er");
	STAssertTrue([inputs count]==4, @"er");
	STAssertTrue([outputs count]==4, @"er");
	STAssertTrue([shInterConnectorsInside count]==4, @"er");
	
	// with each input assert connected to different output
	NSMutableArray *foundConnectedOutputs = [NSMutableArray array];
	SHInputAttribute *eachInput;
	NSEnumerator *inputEnumerator = [inputs objectEnumerator];
	while( (eachInput = [inputEnumerator nextObject]) ){
		NSMutableArray *allConnectedInterConnectors = [eachInput allConnectedInterConnectors];
		STAssertTrue([allConnectedInterConnectors count]==1, @"er");
		SHInterConnector *inc = [allConnectedInterConnectors lastObject];
		// each connected output should be unique.. 
		id outAtt = [(SHConnectlet *)([inc outSHConnectlet]) parentAttribute];
		if([foundConnectedOutputs containsObject:outAtt]==NO)
			[foundConnectedOutputs addObject:outAtt];
		
	}
	STAssertTrue([foundConnectedOutputs count]==4, @"er");
	
	// 3. Try a more complex feedback loop
}

@end
