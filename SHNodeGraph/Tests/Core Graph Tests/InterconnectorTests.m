//
//  InterconnectorTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 22/05/2006.
//  Copyright (c) 2006 HooleyHoop. All rights reserved.
//


#import "SHInterConnector.h"
#import "SHInlet.h"
#import "SHOutlet.h"
#import "SH_Path.h"
#import "SHProtoOutputAttribute.h"
#import "SHProtoInputAttribute.h"
#import "SHParent.h"
#import "SHParent_Connectable.h"

@interface InterconnectorTests : SenTestCase {
	
	
}

@end


@implementation InterconnectorTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testInit {

	SHInterConnector* test = [[[SHInterConnector alloc] init] autorelease];
	STAssertNotNil(test, @"Cant make basic interconnector");
}

- (void)testResetNodeSHConnectlets {
	// - (void)resetNodeSHConnectlets
	
	SHInterConnector* test = [[[SHInterConnector alloc] init] autorelease];
	SHInlet* inC = [[[SHInlet alloc] initWithAttribute:nil] autorelease];
	SHOutlet* outC = [[[SHOutlet alloc] initWithAttribute:nil] autorelease];
	[test setInSHConnectlet:inC];	
	[test setOutSHConnectlet:outC];
	[test resetNodeSHConnectlets];
	
	// not sure how to test this!!
}

- (void)testCurrentConnectionInfo {
// - (NSArray *)currentConnectionInfo

	SHParent *parent = [SHParent makeChildWithName:@"parent1"];

	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[parent addChild:i1 atIndex:-1 undoManager:nil];
	[parent addChild:o1 atIndex:-1 undoManager:nil];
	[i1 setDataType:@"mockDataType"];
	[o1 setDataType:@"mockDataType"];
	[parent _makeSHInterConnectorBetweenOutletOf:i1 andInletOfAtt:o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	STAssertNotNil(int1, @"eh");
	
	/* an array with paths from parent to connectlets */
	id currentConnectionInfo = [int1 currentConnectionInfo];
	SH_Path *inPath = [currentConnectionInfo objectAtIndex:0];
	SH_Path *outPath = [currentConnectionInfo objectAtIndex:1];
	STAssertTrue([[inPath pathAsString] isEqualToString:@"o1"], @"%@", [inPath pathAsString] );
	STAssertTrue([[outPath pathAsString] isEqualToString:@"i1"], @"%@", [outPath pathAsString] );
}

/* Interconnector should conditionally encode its connectlets so we have to have some to test properly */
- (void)testEncodeWithCoder {
	//- (void)encodeWithCoder:(NSCoder *)coder
	//- (id)initWithCoder:(NSCoder *)coder
	
	// test archiving an unconnected ic
	SHInterConnector *unConnectedIC1 = [SHInterConnector interConnector];
	NSData *archive1 = [NSKeyedArchiver archivedDataWithRootObject:unConnectedIC1];
	STAssertNotNil(archive1, @"ooch");
	
	SHInterConnector *unConnectedIC2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive1];
	STAssertNotNil(unConnectedIC2, @"ooch");
	STAssertTrue([unConnectedIC1 isEquivalentTo: unConnectedIC2], @"should be roughly the same");

	// test archiving a connected ic
	SHParent *parent = [SHParent makeChildWithName:@"parent1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"]; SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[parent addChild:i1 atIndex:-1 undoManager:nil], [parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* connectedIC1 = [parent interConnectorFor:i1 and:o1];
	
	/* we cant just encode the ic as it conditionally encodes its attributes */
	NSData *archive2 = [NSKeyedArchiver archivedDataWithRootObject:parent];
	STAssertNotNil(archive2, @"ooch");
	
	id parent2 = [NSKeyedUnarchiver unarchiveObjectWithData:archive2];
	STAssertNotNil(parent2, @"ooch");
	SHInterConnector* connectedIC2 = [[parent2 shInterConnectorsInside] objectAtIndex:0];
	STAssertTrue([connectedIC1 isEquivalentTo: connectedIC2], @"should be roughly the same");
}

- (void)testIsEquivalentTo {
// - (BOOL)isEquivalentTo:(id)anObject;

	SHParent *parent = [SHParent makeChildWithName:@"parent1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"]; SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[i1 setDataType:@"mockDataType"], [o1 setDataType:@"mockDataType"];
	[parent addChild:i1 atIndex:-1 undoManager:nil], [parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	STAssertNotNil(int1, @"noo");
	// Test against self
	STAssertThrows([int1 isEquivalentTo:int1], @"The same object should be equivalent");
	
	// Test in a duplicate graph with the same connections
	SHParent *parent2 = [SHParent makeChildWithName:@"parent2"];
	SHProtoInputAttribute* i1_2 = [SHProtoInputAttribute makeChildWithName:@"i1_2"]; SHProtoOutputAttribute* o1_2 = [SHProtoOutputAttribute makeChildWithName:@"o1_2"];
	[i1_2 setDataType:@"mockDataType"], [o1_2 setDataType:@"mockDataType"];
	[parent2 addChild:i1_2 atIndex:-1 undoManager:nil], [parent2 addChild:o1_2 atIndex:-1 undoManager:nil];
	[parent2 _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1_2 andInletOfAtt:(SHProtoAttribute *)o1_2 undoManager:nil];
	SHInterConnector* int1_2 = [parent2 interConnectorFor:i1_2 and:o1_2];
	STAssertNotNil(int1_2, @"noo");
	STAssertTrue( [int1 isEquivalentTo:int1_2], @"These should be the same");

	// Delete the connector! it wont be equal to anything now..
	// Test against new connector with the same connections
	[parent deleteChild:int1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:i1 and:o1];
	STAssertNotNil(int2, @"noo");
	STAssertFalse( [int1 isEquivalentTo:int2], @"int1 isnt connected so how can they be the same?");
	
	// Test some fucked up shit with archives
	id archivedConnectionState = [int1_2 indexPathsForConnectlets];
	[parent2 deleteChild:int1_2 undoManager:nil];
	STAssertTrue([int2 isEquivalentTo:archivedConnectionState], @"Should be the same as saved info, as the 2 connectors were equivalent");
		
	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[o2 setDataType:@"mockDataType"];
	[parent addChild:o2 atIndex:-1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o2 undoManager:nil];
	SHInterConnector* int4 = [parent interConnectorFor:i1 and:o2];
	STAssertNotNil(int4, @"doo");
	archivedConnectionState = [int4 currentConnectionInfo];
	STAssertFalse([int4 isEquivalentTo:archivedConnectionState], @"eh? The 2 connectors weren't equivalent");
	

	//TODO surely it makes no sense to allow multiple connections per input and output?

}

- (void)testOutOfAtt {
//- (SHAttribute *)outOfAtt

	SHParent *parent = [SHParent makeChildWithName:@"parent1"];

	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[parent addChild:i1 atIndex:-1 undoManager:nil];
	[parent addChild:o1 atIndex:-1 undoManager:nil];
	[i1 setDataType:@"mockDataType"];
	[o1 setDataType:@"mockDataType"];

	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	STAssertTrue([int1 outOfAtt]==i1, @"wrong way round?");
}

- (void)testIntoAtt {
//- (SHAttribute *)intoAtt

	SHParent *parent = [SHParent makeChildWithName:@"parent1"];

	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[parent addChild:i1 atIndex:-1 undoManager:nil];
	[parent addChild:o1 atIndex:-1 undoManager:nil];
	[i1 setDataType:@"mockDataType"];
	[o1 setDataType:@"mockDataType"];

	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	STAssertTrue([int1 intoAtt]==o1, @"wrong way round?");
}

- (void)testIndexPathsForConnectlets {
	//- (NSArray *)indexPathsForConnectlets

	SHParent *parent = [SHParent makeChildWithName:@"parent1"];
	SHParent *parent2 = [SHParent makeChildWithName:@"p2"];
	SHParent *parent3 = [SHParent makeChildWithName:@"p3"];
	[parent addChild:parent2 atIndex:-1 undoManager:nil];
	[parent addChild:parent3 atIndex:-1 undoManager:nil];

	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoInputAttribute* i2 = [SHProtoInputAttribute makeChildWithName:@"i2"];
	SHProtoInputAttribute* i3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoOutputAttribute* o2 = [SHProtoOutputAttribute makeChildWithName:@"o2"];
	[parent addChild:i1 atIndex:-1 undoManager:nil];
	[parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent2 addChild:i2 atIndex:-1 undoManager:nil];
	[parent2 addChild:o2 atIndex:-1 undoManager:nil];
	[parent3 addChild:i3 atIndex:-1 undoManager:nil];
	
	// input to output
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	NSArray *data1 = [int1 indexPathsForConnectlets];
	STAssertTrue([[[data1 objectAtIndex:0] objectAtIndex:0] isEqualToString:@"i0"], @"must be");
	STAssertTrue([[[data1 objectAtIndex:1] objectAtIndex:0] isEqualToString:@"o0"], @"must be");

	// input to node->input
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)i2 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:i1 and:i2];
	NSArray *data2 = [int2 indexPathsForConnectlets];
	STAssertTrue([[[data2 objectAtIndex:0] objectAtIndex:0] isEqualToString:@"i0"], @"must be");
	STAssertTrue([[[data2 objectAtIndex:1] objectAtIndex:0] isEqualToString:@"n0"], @"must be %@", [[data2 objectAtIndex:1] objectAtIndex:0] );
	STAssertTrue([[[data2 objectAtIndex:1] objectAtIndex:1] isEqualToString:@"i0"], @"must be");

	// node->output to node->input
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)o2 andInletOfAtt:(SHProtoAttribute *)i3 undoManager:nil];
	SHInterConnector* int3 = [parent interConnectorFor:o2 and:i3];
	NSArray *data3 = [int3 indexPathsForConnectlets];
	STAssertTrue([[[data3 objectAtIndex:0] objectAtIndex:0] isEqualToString:@"n0"], @"must be");
	STAssertTrue([[[data3 objectAtIndex:0] objectAtIndex:1] isEqualToString:@"o0"], @"must be");
	STAssertTrue([[[data3 objectAtIndex:1] objectAtIndex:0] isEqualToString:@"n1"], @"must be %@", [[data3 objectAtIndex:1] objectAtIndex:0] );
	STAssertTrue([[[data3 objectAtIndex:1] objectAtIndex:1] isEqualToString:@"i0"], @"must be");
}

- (void)testDescription {
	// - (NSString *)description;
	SHParent *parent = [SHParent makeChildWithName:@"parent1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[parent addChild:i1 atIndex:-1 undoManager:nil];
	[parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	NSString *description = [int1 description];
	NSString *match = [NSString stringWithFormat:@"<SHInterConnector: %p> : InterConnector - InterConnector", int1];
	STAssertEqualObjects(description, match, @">%@<", description);
}

- (void)testIsConnected {
	//- (BOOL)isConnected
	
	SHInterConnector* testIC = [[[SHInterConnector alloc] init] autorelease];
	STAssertFalse([testIC isConnected], @"wooah");
	
	SHParent *parent = [SHParent makeChildWithName:@"parent1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[parent addChild:i1 atIndex:-1 undoManager:nil];
	[parent addChild:o1 atIndex:-1 undoManager:nil];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];
	STAssertTrue([int1 isConnected], @"wooah");
}

@end
