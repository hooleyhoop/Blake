//
//  SHParent_ConnectableTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 09/04/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent.h"
#import "SHParent_Connectable.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "NodeName.h"
#import "SH_Path.h"
#import "SHChildContainer.h"
#import "SHInterConnector.h"

@interface SHParent_ConnectableTests : SenTestCase {
	
	SHParent *parent;
}

@end


@implementation SHParent_ConnectableTests

- (void)setUp {
	
	parent = [[SHParent alloc] init];
	[parent changeNameWithStringTo:@"rootNode" fromParent:nil undoManager:nil];
}

- (void)tearDown {
	
	[parent release];
}

- (void)testAllConnectionsToChild {
	//- (NSMutableArray *)allConnectionsToChild:(id)aChild;

	SHParent* parent2 = [SHParent makeChildWithName:@"p2"];
	[parent addChild:parent2 atIndex:-1 undoManager:nil];

	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	SHProtoInputAttribute* inAtt3 = [SHProtoInputAttribute makeChildWithName:@"inAtt3"];
	SHProtoInputAttribute* inAtt4 = [SHProtoInputAttribute makeChildWithName:@"inAtt4"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute *outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	SHProtoOutputAttribute *outAtt3 = [SHProtoOutputAttribute makeChildWithName:@"outAtt3"];
	SHProtoOutputAttribute *outAtt4 = [SHProtoOutputAttribute makeChildWithName:@"outAtt4"];

	// add some attributes to node1
	[parent addItemsOfSingleType:[NSArray arrayWithObjects:inAtt4, nil] atIndexes:nil undoManager:nil];
	[parent addItemsOfSingleType:[NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil] atIndexes:nil undoManager:nil];

	// add some attributes to node2
	[parent2 addItemsOfSingleType:[NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil] atIndexes:nil undoManager:nil];
	[parent2 addItemsOfSingleType:[NSArray arrayWithObjects:outAtt4, nil] atIndexes:nil undoManager:nil];

	// make some connections
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt3 andInletOfAtt:(SHProtoAttribute *)inAtt3 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt4 andInletOfAtt:(SHProtoAttribute *)inAtt4 undoManager:nil];

	NSMutableArray *allConnections = [parent allConnectionsToChild:parent2];
	STAssertTrue([allConnections count]==4, @"should be but is - %i", [allConnections count]);

	STAssertThrows( [parent allConnectionsToChild:inAtt3], @"doh" );

	STAssertTrue([[parent allConnectionsToChild:outAtt2] count]==1, @"should be but is - %i", [[parent allConnectionsToChild:outAtt2] count]);
	STAssertTrue([[parent2 allConnectionsToChild:inAtt1] count]==1, @"should be but is - %i", [[parent2 allConnectionsToChild:inAtt1] count]);
}

- (void)testInterConnectorForAnd {
	//- (SHInterConnector *)interConnectorFor:(SHProtoAttribute *)inAtt1 and:(SHProtoAttribute *)inAtt2

	SHParent* parent2 = [SHParent makeChildWithName:@"p2"];
	[parent addChild:parent2 atIndex:-1 undoManager:nil];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	SHProtoInputAttribute* inAtt3 = [SHProtoInputAttribute makeChildWithName:@"inAtt3"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	SHProtoOutputAttribute *outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	SHProtoOutputAttribute *outAtt3 = [SHProtoOutputAttribute makeChildWithName:@"outAtt3"];
	[parent addItemsOfSingleType:[NSArray arrayWithObjects:outAtt1, outAtt2, outAtt3, nil] atIndexes:nil undoManager:nil];
	[parent2 addItemsOfSingleType:[NSArray arrayWithObjects:inAtt1, inAtt2, inAtt3, nil] atIndexes:nil undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt1 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt2 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt3 andInletOfAtt:(SHProtoAttribute *)inAtt3 undoManager:nil];
	
	STAssertNotNil([parent interConnectorFor:inAtt1 and:outAtt1], @"doh");
	STAssertNotNil([parent interConnectorFor:inAtt2 and:outAtt2], @"doh");
	STAssertNotNil([parent interConnectorFor:inAtt3 and:outAtt3], @"doh");
	STAssertNil([parent interConnectorFor:inAtt1 and:outAtt2], @"doh");
	STAssertThrows([parent interConnectorFor:inAtt2 and:inAtt2], @"doh");
	STAssertThrows([parent interConnectorFor:inAtt2 and:nil], @"doh");
}

/* It seems that ics that make a connection between nodes always 'live' in the upper node */
- (void)testWhereICSGo {

	// lets build up a bit of structure
	// - *current
	//	- inAtt1
	//	- outAtt1
	//	- *inner
	//	 - inAtt2
	//	 - outAtt2
	SHParent *current = [SHParent makeChildWithName:@"current"];
	SHProtoInputAttribute* inAtt1 = [SHProtoInputAttribute makeChildWithName:@"inAtt1"];
	SHProtoOutputAttribute *outAtt1 = [SHProtoOutputAttribute makeChildWithName:@"outAtt1"];
	
	SHParent *inner = [SHParent makeChildWithName:@"inner"];
	SHProtoInputAttribute* inAtt2 = [SHProtoInputAttribute makeChildWithName:@"inAtt2"];
	SHProtoOutputAttribute *outAtt2 = [SHProtoOutputAttribute makeChildWithName:@"outAtt2"];
	
	[inner addChild:inAtt2 atIndex:-1 undoManager:nil];
	[inner addChild:outAtt2 atIndex:-1 undoManager:nil];

	[current addChild:inAtt1 atIndex:-1 undoManager:nil];
	[current addChild:outAtt1 atIndex:-1 undoManager:nil];

	[current addChild:inner atIndex:-1 undoManager:nil];

	//-- how do we get a connection to live at the deeper level?
	STAssertTrue([current _validParentForConnectionBetweenOutletOf:outAtt2 andInletOfAtt:inAtt1], @"doh");
	[current _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];

}

@end
