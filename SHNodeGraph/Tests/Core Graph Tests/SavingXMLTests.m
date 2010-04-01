//
//  SavingXMLTests.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 01/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SavingXMLTests.h"
#import "SHNodeGraphModel.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHNode.h"
#import "SHConnectableNode.h"
#import "SHNodeAttributeMethods.h"
#import "SHConnectlet.h"
#import "SH_Path.h"
#import "SHNodePrivateMethods.h"
#import "SHAttribute.h"
#import "SHInterConnector.h"
#import "SHNodeSelectingMethods.h"
#import "XMLSavingNode.h"

@interface SavingXMLTests : SenTestCase {
	
    SHNodeGraphModel *_nodeGraphModel;
	
}

@end


@implementation SavingXMLTests


- (void)setUp {
    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	STAssertNotNil(_nodeGraphModel, @"SHAttributeTests ERROR.. Couldnt make a nodeModel");
}


- (void) tearDown {
	[_nodeGraphModel release];
	_nodeGraphModel = nil;
}

/* Simplest Case */
- (void)testxmlRepresentation
{
	// - (NSXMLElement *)xmlRepresentation
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
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"a");
	// get the xml representation
	NSXMLElement* xml1 = [root xmlRepresentation];

	// instantiate a new node from xml
	SHNode* rootCopy = [SHNode newNodeWithXMLElement:xml1];
	NSXMLElement* xml2 = [rootCopy xmlRepresentation];
	STAssertNotNil(xml2, @"a");

	// check that they are equal
	STAssertTrue([root isEquivalentTo: rootCopy], @"should be roughly the same");
	
//later		SHInputAttribute* i2 = (SHInputAttribute *)[rootCopy inputAttributeAtIndex:0];
//later		STAssertTrue([[i2 displayValue] isEqualToString:[i1 displayValue]], @"should be the same");	
	
	// check some indexes are in the same order
	
}

/* restored nodes should have the same name as the originals..? */
- (void)testxmlRepresentation_NODENAME
{
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	NSXMLElement* xml1 = [root xmlRepresentation];
	SHNode* rootCopy = [SHNode newNodeWithXMLElement:xml1];
	STAssertTrue([[rootCopy name] isEqualToString:[root name]], @"should be roughly the same");
}


// check saving a feedback loop
- (void)testxmlRepresentation_FEEDBACK
{

}

- (void)testxmlRepresentation_PRIVATEMEMBERS
{

}



@end
