//
//  SHConnectableNodeTests.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 5/18/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "SHNode.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHConnectableNode.h"
#import <ProtoNodeGraph/SHInterConnector.h>
#import <ProtoNodeGraph/SHConnectlet.h>
#import <ProtoNodeGraph/NodeName.h>

@interface SHConnectableNodeTests : SenTestCase {
	
	SHNode *_parent;
	NSUndoManager *_um;
}

@end

static int _numberOfNotificationsReceived, _nodeAddedNotifications, _selectionChangedCount, _interConnectorsChanged, inputsChangedCount=0, outputsChangedCount=0;

@implementation SHConnectableNodeTests
- (void)resetObservers {
	
	_numberOfNotificationsReceived=0;
	_nodeAddedNotifications=0;
	_selectionChangedCount=0;
	_interConnectorsChanged=0, inputsChangedCount =0, outputsChangedCount =0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	_numberOfNotificationsReceived++;

	NSString *cntxt = (NSString *)context;
	if(cntxt==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];

    if( [cntxt isEqualToString:@"SHConnectableNodeTests"] )
	{
		if ([keyPath isEqualToString:@"testSHNode.allChildren"]) {
			//_allChildrenDidChange = YES;
		} else
			if ([keyPath isEqual:@"nodesInside.selection"]) {
				_selectionChangedCount++;
			} else
				if ([keyPath isEqual:@"nodesInside"] ) {
					_nodeAddedNotifications++;
				} else if ([keyPath isEqual:@"childContainer.shInterConnectorsInside.array"]) {
					_interConnectorsChanged++;
				} else if ([keyPath isEqual:@"childContainer.allChildren"]) {
					_nodeAddedNotifications++;
				} else if([keyPath isEqualToString:@"childContainer.inputs.array"]){
					inputsChangedCount++;
				} else if([keyPath isEqualToString:@"childContainer.outputs.array"]){
					outputsChangedCount++;
				} else if([keyPath isEqualToString:@"childContainer.nodesInside.array"]){
					_nodeAddedNotifications++;
				} else {
					[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
				}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	}
}

- (void)setUp {

	_parent = [[SHNode makeChildWithName:@"root"] retain];
	_um = [[NSUndoManager alloc] init];
	[self resetObservers];
}

- (void)tearDown {
	
	[_um removeAllActions];
	[_parent release];
	[_um release];
}

/* Again, there are 3 valid types of connection - test each one */
- (void)testConnectAttributeAtRelativePathToAttributeAtRelativePath {
	// - (SHInterConnector *)connectAttributeAtRelativePath:(SH_Path *)p1 toAttributeAtRelativePath:(SH_Path *)p2

	SHInputAttribute* input1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* output1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:input1 undoManager:nil];
	[_parent addChild:output1 undoManager:nil];
	
	//-- add an inner level as well
	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
	[_parent addChild:node1 undoManager:nil];
	SHInputAttribute* input2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* output2 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[node1 addChild:input2 undoManager:nil];
	[node1 addChild:output2 undoManager:nil];
	
	//-- and another inner level
	SHNode* node2 = [SHNode makeChildWithName:@"n1"];
	[_parent addChild:node2 undoManager:nil];
	SHOutputAttribute* output3 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[node2 addChild:output3 undoManager:nil];

	/* in _parent */
	//--type1
	SHInterConnector* int1 = [_parent connectAttributeAtRelativePath:[_parent relativePathToChild:input1] toAttributeAtRelativePath:[_parent relativePathToChild:output1] undoManager:_um];
	//--type2
	SHInterConnector* int2 = [_parent connectAttributeAtRelativePath:[_parent relativePathToChild:input1] toAttributeAtRelativePath:[_parent relativePathToChild:input2]  undoManager:_um];
	
	//--ERROR! This interconector should not be a child of _parent!
	SHOutputAttribute* output12 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:output12 undoManager:nil];
	SHInterConnector* int3 = [_parent connectAttributeAtRelativePath:[_parent relativePathToChild:output2] toAttributeAtRelativePath:[_parent relativePathToChild:output12] undoManager:_um];
	
	/* in node1 */
	//--type2
	SHInterConnector* int4 = [_parent connectAttributeAtRelativePath:[_parent relativePathToChild:input2] toAttributeAtRelativePath:[_parent relativePathToChild:output2] undoManager:_um];

	//--type3
	SHOutputAttribute* output122 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:output122 undoManager:nil];
	SHInterConnector* int5 = [_parent connectAttributeAtRelativePath:[_parent relativePathToChild:output3] toAttributeAtRelativePath:[_parent relativePathToChild:output122] undoManager:_um];
	
	STAssertNotNil(int1, @"relative interconnector failed");
	STAssertNotNil(int2, @"relative interconnector failed");
	STAssertNotNil(int3, @"relative interconnector failed");
	STAssertNotNil(int4, @"relative interconnector failed");
	STAssertNotNil(int5, @"relative interconnector failed");
	
	NSArray *ics = [_parent interConnectorsDependantOnChildren:[NSArray arrayWithObjects:input1, output1, nil]];
	STAssertTrue([ics count]==2, @"count is %i", [ics count]);
	
	/* _parent shoould have 3 connectors */
	NSArray *rootICs = [[_parent shInterConnectorsInside] array];
	STAssertTrue([rootICs count]==4, @"wha? %i", [rootICs count]);
	
	/* Node1 should have 1 connector */
	NSArray *node1ICs = [[node1 shInterConnectorsInside] array];
	STAssertTrue([node1ICs count]==1, @"wha? %i", [node1ICs count]);
	
	/* Undo */
	[_um undo];
	
	NSArray *rootICs2 = [[node1 shInterConnectorsInside] array];
	STAssertTrue([rootICs2 count]==0, @"wha? %i", [rootICs count]);
	
	/* Redo */
	[_um redo];
	
	NSArray *rootICs3 = [[node1 shInterConnectorsInside] array];
	STAssertTrue([rootICs3 count]==1, @"wha? %i", [rootICs3 count]);
}

- (void)testConnectOutletOfAttributeToInletOfAttribute {
//- (SHInterConnector *)connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att2

	[_parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHConnectableNodeTests"];
	
	// test1 - input to output
	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:inAtt1 undoManager:nil];
	[_parent addChild:outAtt1 undoManager:nil];
	[_parent addChild:outAtt2 undoManager:nil];
	SHInterConnector* int1 = [_parent connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1 undoManager:_um];
	STAssertTrue(_interConnectorsChanged==1, @"received incorrect number of notifications %i", _interConnectorsChanged);

	//	check that the interconnector is in root
	int i = [_parent indexOfInterConnector:int1];
	STAssertTrue(i!=NSNotFound, @"connecting 2 attributes failed");
//	NSString* UIDasARString = [NSString stringWithFormat:@"%i", [int1 temporaryID] ];
	SHOrderedDictionary* ics = [_parent shInterConnectorsInside];
	SHInterConnector* testic1 = [ics objectForKey:((NodeName *)[int1 name]).value];
	STAssertEqualObjects(testic1, int1, @"connecting 2 attributes failed");

	//	check both ends of the interconnector
	SHProtoAttribute* inAtt = [[testic1 inSHConnectlet] parentAttribute]; // out attribute
	SHProtoAttribute* outAtt = [[testic1 outSHConnectlet] parentAttribute];
	STAssertNotNil(inAtt, @"connecting 2 attributes failed");
	STAssertNotNil(outAtt, @"connecting 2 attributes failed");
	STAssertEqualObjects(inAtt, outAtt1, @"connecting 2 attributes failed");

	// test2 - input to input in child
	SHNode* childNode = [SHNode makeChildWithName:@"n1"];
	[_parent addChild:childNode undoManager:nil];
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[childNode addChild:atChild3 undoManager:nil];
	SHInterConnector* int2 = [_parent connectOutletOfAttribute:inAtt1 toInletOfAttribute:atChild3 undoManager:_um];
	STAssertTrue(_interConnectorsChanged==2, @"received incorrect number of notifications %i", _interConnectorsChanged);

	//	check that the interconnector is in root
	i = [_parent indexOfInterConnector:int2];
	STAssertTrue(i!=NSNotFound, @"connecting 2 attributes failed");
	//	check both ends of the interconnector
		
	// test3 - out to out in child
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[childNode addChild:atChild4 undoManager:nil];
	SHInterConnector* int3 = [_parent connectOutletOfAttribute:atChild4 toInletOfAttribute:outAtt2 undoManager:_um];
	STAssertTrue(_interConnectorsChanged==3, @"received incorrect number of notifications %i", _interConnectorsChanged);

	//	check that the interconnector is in root
	i = [_parent indexOfInterConnector:int3];
	STAssertTrue(i!=NSNotFound, @"connecting 2 attributes failed");
	//	check both ends of the interconnector		

	// test4 - in and out both in different child comps
	SHNode* childNode2 = [SHNode makeChildWithName:@"n1"];
	[_parent addChild:childNode2 undoManager:nil];
	SHInputAttribute* atChild5 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild5_2 = [SHOutputAttribute attributeWithType:@"mockDataType"];

	[childNode2 addChild:atChild5 undoManager:nil];
	[childNode addChild:atChild5_2 undoManager:nil];

	[_um removeAllActions];
	SHInterConnector* int4 = [_parent connectOutletOfAttribute:atChild5_2 toInletOfAttribute:atChild5 undoManager:_um];
	STAssertNotNil(int4, @"wha?");
	STAssertTrue(_interConnectorsChanged==4, @"received incorrect number of notifications %i", _interConnectorsChanged);
	STAssertTrue([[[_parent shInterConnectorsInside] array] count]==4, @"wha? %i", [[[_parent shInterConnectorsInside] array] count]);

	//	check that the interconnector is in root
	i = [_parent indexOfInterConnector:int4];
	STAssertTrue(i!=NSNotFound, @"connecting 2 attributes failed");
	//	check both ends of the interconnector	
	
	/* Undo */
	[_um undo];
	STAssertTrue(_interConnectorsChanged==5, @"received incorrect number of notifications %i", _interConnectorsChanged);
	STAssertTrue([[[_parent shInterConnectorsInside] array] count]==3, @"wha? %i", [[[_parent shInterConnectorsInside] array] count]);
	
	[_um redo];
	STAssertTrue(_interConnectorsChanged==6, @"received incorrect number of notifications %i", _interConnectorsChanged);
	STAssertTrue([[[_parent shInterConnectorsInside] array] count]==4, @"wha? %i", [[[_parent shInterConnectorsInside] array] count]);

	STAssertThrows([_parent connectOutletOfAttribute:atChild5_2 toInletOfAttribute:atChild5_2 undoManager:nil], @"doh");
	STAssertThrows([_parent connectOutletOfAttribute:atChild5_2 toInletOfAttribute:nil undoManager:nil], @"doh");
	STAssertThrows([_parent connectOutletOfAttribute:nil toInletOfAttribute:atChild5_2 undoManager:nil], @"doh");
	STAssertThrows([_parent connectOutletOfAttribute:nil toInletOfAttribute:nil undoManager:nil], @"doh");

	// -- remove observer
	[_parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.array"];
}

- (void)testInterConnectorsDependantOnChildren {
	//- (NSArray *)interConnectorsDependantOnChildren:(NSArray *)children

	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_parent addChild:inAtt1 undoManager:nil];
	[_parent addChild:outAtt1 undoManager:nil];
	// add an inner level as well
	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
	[_parent addChild:node1 undoManager:nil];
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[node1 addChild:atChild3 undoManager:nil];
	[node1 addChild:atChild4 undoManager:nil];
	// make all 3 possible connections
	SHInterConnector* int1 = [_parent connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1 undoManager:_um];
	SHInterConnector* int2 = [_parent connectOutletOfAttribute:inAtt1 toInletOfAttribute:atChild3 undoManager:_um];
	// SHInterConnector* int3 = [_parent connectOutletOfAttribute:atChild4 toInletOfAttribute:outAtt1]; // cant have 2 connections going to the same input
	STAssertNotNil(int1, @"interconnector failed");
	STAssertNotNil(int2, @"interconnector failed");
	// STAssertNotNil(int3, @"interconnector failed");

	NSArray *ics = [_parent interConnectorsDependantOnChildren:[NSArray arrayWithObjects:inAtt1, outAtt1, nil]];
	STAssertTrue([ics count]==2, @"count is %i", [ics count]);
	STAssertTrue([ics objectAtIndex:0]==int1, @"doh");
	STAssertTrue([ics objectAtIndex:1]==int2, @"doh");

	NSArray *ics2 = [_parent interConnectorsDependantOnChildren:[NSArray arrayWithObjects:int1, nil]];
	STAssertTrue([ics2 count]==1, @"count is %i", [ics count]);
	STAssertTrue([ics2 objectAtIndex:0]==int1, @"doh");
}

- (void)testIndexOfInterConnector {
	//- (int)indexOfInterConnector:(SHInterConnector *)aConnector

	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* inAtt2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* inAtt3 = [SHInputAttribute attributeWithType:@"mockDataType"];

	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt3 = [SHOutputAttribute attributeWithType:@"mockDataType"];

	[_parent addChild:inAtt1 undoManager:nil];
	[_parent addChild:inAtt2 undoManager:nil];
	[_parent addChild:inAtt3 undoManager:nil];

	[_parent addChild:outAtt1 undoManager:nil];
	[_parent addChild:outAtt2 undoManager:nil];
	[_parent addChild:outAtt3 undoManager:nil];

	SHInterConnector* int1 = [_parent connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1 undoManager:_um];
	SHInterConnector* int2 = [_parent connectOutletOfAttribute:inAtt2 toInletOfAttribute:outAtt2 undoManager:_um];
	SHInterConnector* int3 = [_parent connectOutletOfAttribute:inAtt3 toInletOfAttribute:outAtt3 undoManager:_um];

	STAssertTrue([_parent indexOfInterConnector:int1]==0, @"doh");
	STAssertTrue([_parent indexOfInterConnector:int2]==1, @"doh");
	STAssertTrue([_parent indexOfInterConnector:int3]==2, @"doh");
	
	STAssertTrue([[[_parent shInterConnectorsInside] array] count]==3, @"wha? %i", [[[_parent shInterConnectorsInside] array] count]);

	/* undo */
	[_um undo];
	STAssertTrue([[[_parent shInterConnectorsInside] array] count]==0, @"wha? %i", [[[_parent shInterConnectorsInside] array] count]);
	
	[_um redo];
	STAssertTrue([[[_parent shInterConnectorsInside] array] count]==3, @"wha? %i", [[[_parent shInterConnectorsInside] array] count]);

}

@end
