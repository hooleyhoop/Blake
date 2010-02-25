//
//  HighLevelBlakeDocumentActionsTests.m
//  BlakeLoader
//
//  Created by steve hooley on 03/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "BlakeDocumentController.h"
#import "BlakeDocument.h"
#import "BlakeNodeListWindowController.h"
#import "HighLevelBlakeDocumentActions.h"


static int _numberOfNotificationsReceived, _nodeAddedNotifications, _selectionChangedCount, _interConnectorsChanged, inputsChangedCount=0, outputsChangedCount=0;
static BOOL _allChildrenDidChange;

@interface HighLevelBlakeDocumentActionsTests : SenTestCase {
	
	BlakeDocumentController		*dc;
	BlakeDocument				*doc;
	NSUndoManager				*um;
}

@end

@implementation HighLevelBlakeDocumentActionsTests

- (void)resetObservers {
	
	_allChildrenDidChange = NO;
	_numberOfNotificationsReceived=0;
	_nodeAddedNotifications=0;
	_selectionChangedCount=0;
	_interConnectorsChanged=0, inputsChangedCount =0, outputsChangedCount =0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	_numberOfNotificationsReceived++;
	
	NSString *cntxt = (NSString *)context;
	if(cntxt==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [cntxt isEqualToString:@"HighLevelBlakeDocumentActionsTests"] )
	{
		if ([keyPath isEqualToString:@"testSHNode.allChildren"]) {
			_allChildrenDidChange = YES;
		} else
			if ([keyPath isEqual:@"nodesInside.selection"]) {
				_selectionChangedCount++;
			} else
				if ([keyPath isEqual:@"nodesInside.array"] ) {
					_nodeAddedNotifications++;
				} else if ([keyPath isEqual:@"shInterConnectorsInside.array"]) {
					_interConnectorsChanged++;
				} else if ([keyPath isEqual:@"allChildren"]) {
					_nodeAddedNotifications++;
				} else if([keyPath isEqualToString:@"inputs.array"]){
					inputsChangedCount++;
				} else if([keyPath isEqualToString:@"outputs.array"]){
					outputsChangedCount++;
				} else if([keyPath isEqualToString:@"nodesInside.array"]){
					_nodeAddedNotifications++;
				} else {
					[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
				}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	}
}

- (void)setUp {

	/* One document controller for all documents */
	dc = [BlakeDocumentController sharedDocumentController];

	//- make sure all docs are closed..
	NSArray* allDocs = [dc documents];
	NSDocument *openDoc = [allDocs lastObject];
	[openDoc updateChangeCount:  NSChangeCleared];

	[dc closeAll];
	allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"cleanUpExistingDocsBeforeMakingNew broken? %i", [allDocs count]);

	[dc newDocument:self];
	doc = [[dc frontDocument] retain];
	um = [doc undoManager];

	STAssertNotNil(doc, @"doc init failed");
	STAssertNotNil(doc.nodeGraphModel, @"doc init failed");
	STAssertFalse([doc isDocumentEdited], @"new clean doc?"); // has changes pertains to the undo manager
	
	STAssertTrue(doc.undoManager==doc.nodeGraphModel.undoManager, @"Fuck up with undo managers");
}

- (void)tearDown {

	[um setGroupsByEvent:YES];
	[um removeAllActions];
	
	[doc updateChangeCount: NSChangeCleared];
	[doc release];
	
	//- make sure all docs are closed..
	[dc closeAll];
	NSArray* allDocs = [dc documents];
	STAssertTrue([allDocs count]==0, @"closeAll broken? %i", [allDocs count]);
    
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.3]]; // must give sufficient time - zero doesnt work
}

- (void)testmakeEmptyGroupInCurrentNodeWithName {
// - (SHNode *)makeEmptyGroupInCurrentNodeWithName:(NSString *)name {
	
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	[rootNode addObserver:self forKeyPath:@"nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];
	[rootNode addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];
	[self resetObservers];
	
	[um beginUndoGrouping];
		SHNode* newNode = [doc makeEmptyGroupInCurrentNodeWithName:@"countBobulous"];
	[um endUndoGrouping];
	
	STAssertNotNil(newNode, @"should have a newNode");
	STAssertTrue([[newNode name].value isEqualToString:@"countBobulous"], @"fault setting name");
	STAssertTrue([newNode parentSHNode]==rootNode, @"did we make the node in the wrong place?");
	
	STAssertTrue([doc isDocumentEdited], @"didnt we just add a node?"); // has changes pertains to the undo manager
	STAssertTrue([um canUndo]==YES, @"didnt we just add a node?");

	STAssertTrue( _nodeAddedNotifications==1, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
	/* Test Undo And Redo */
	[um undo];
	BOOL isChild = [rootNode isChild:newNode];
	STAssertTrue(isChild==NO, @"Failed to remove node in undo");
	STAssertTrue( _nodeAddedNotifications==2, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
	[um redo];
	isChild = [rootNode isChild:newNode];
	STAssertTrue(isChild==YES, @"Failed to re-add node in redo");
	STAssertTrue( _nodeAddedNotifications==3, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
    [rootNode removeObserver:self forKeyPath:@"nodesInside.selection"];
    [rootNode removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)testmakeInputInCurrentNodeWithType {
// - (SHInputAttribute *)makeInputInCurrentNodeWithType:(NSString *)type

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	[um beginUndoGrouping];
		SHInputAttribute* newInput = [doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[um endUndoGrouping];
	
	STAssertNotNil(newInput, @"should have a SHInputAttribute");
	STAssertTrue([newInput parentSHNode]==rootNode, @"did we make the node in the wrong place?");
	
//dec09	STAssertTrue([doc isDocumentEdited], @"didnt we just add a node?"); // has changes pertains to the undo manager
	STAssertTrue([um canUndo]==YES, @"didnt we just add a node?");

	/* Test Undo And Redo */
	[um undo];
	BOOL isChild = [rootNode isChild:newInput];
	STAssertTrue(isChild==NO, @"Failed to remove node in undo");

	[um redo];
	isChild = [rootNode isChild:newInput];
	STAssertTrue(isChild==YES, @"Failed to re-add node in redo");
}

- (void)testmakeOutputInCurrentNodeWithType {
// - (SHOutputAttribute *)makeOutputInCurrentNodeWithType:(NSString *)type {

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	[um beginUndoGrouping];
		SHOutputAttribute* newOutput = [doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	[um endUndoGrouping];

	STAssertNotNil(newOutput, @"should have a SHOutputAttribute");
	STAssertTrue([newOutput parentSHNode]==rootNode, @"did we make the node in the wrong place?");
	
//dec09	STAssertTrue([doc isDocumentEdited], @"didnt we just add a node?"); // has changes pertains to the undo manager
	STAssertTrue([um canUndo]==YES, @"didnt we just add a node?");

	/* Test Undo And Redo */
	[um undo];
	BOOL isChild = [rootNode isChild:newOutput];
	STAssertTrue(isChild==NO, @"Failed to remove node in undo");

	[um redo];
	isChild = [rootNode isChild:newOutput];
	STAssertTrue(isChild==YES, @"Failed to re-add node in redo");

}

- (void)testConnectOutletOfInputToInletOfOutput {
// - (void)connectOutletOfInput:(NSUInteger)int1 toInletOfOutput:(NSUInteger)int2

	/* Valid Connections */
	//-- Case 1 -- node/input to  node/output							// ie. connect out of an attribute into an attribute
	//-- Case 2 -- node/input to  node/childNode/input					// ie. connect out of an attribute into an input of a math patch
	//-- Case 3 -- node/childNode/output to node/input					// ie. connect out of math patch output into an attribute
	//-- Case 4 -- node/childNode/output to node/childNode/input		// ie. connect out of math patch output into the input of another math patch
	/* Test em all */
	
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	SHInputAttribute* inAtt1 = [doc makeInputInCurrentNodeWithType:@"mockDataType"];
	SHInputAttribute* inAtt2 = [doc makeInputInCurrentNodeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt1 = [doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt2 = [doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt3 = [doc makeOutputInCurrentNodeWithType:@"mockDataType"];

	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
	[rootNode addChild:node1 undoManager:nil];
	
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[node1 addChild:atChild3 undoManager:nil];
	[node1 addChild:atChild4 undoManager:nil];
	
	//-- Case 1 --//
	[doc connectOutletOfInput:inAtt2 toInletOfOutput:outAtt2];
	
	[um removeAllActions];
	[um beginUndoGrouping];
	//-- Case 2 --//
		[doc connectOutletOfInput:inAtt2 toInletOfOutput:atChild3];
	[um endUndoGrouping];

	NSArray* allConnections1 = [rootNode allConnectionsToChild:outAtt1];
	STAssertTrue([allConnections1 count]==0, @"we didnt connect this.."); 

	NSArray* allConnections2 = [rootNode allConnectionsToChild:outAtt2];
	STAssertTrue([allConnections2 count]==1, @"didnt we connect?"); 

	NSArray* allConnections3 = [rootNode allConnectionsToChild:inAtt1];
	STAssertTrue([allConnections3 count]==0, @"we didnt connect this.."); 
	
	NSArray* allConnections4 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections4 count]==2, @"we didnt connect this.. %i", [allConnections4 count]); 
	
//dec09	STAssertTrue([doc isDocumentEdited], @"didnt we just add a node?"); 
	STAssertTrue([um canUndo]==YES, @"didnt we just add a node?");
	
	
	/* Test Undo And Redo */
	[um undo];
	// -- should remove from inAtt2 to atChild3
	NSArray* allConnections5 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections5 count]==1, @"we didnt connect this.. %i", [allConnections5 count]); 
	
	[um redo];
	// -- should restore from inAtt2 to atChild3
	NSArray* allConnections6 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections6 count]==2, @"we didnt connect this.. %i", [allConnections6 count]); 
	
	[um undo];
	// -- should remove from inAtt2 to atChild3
	NSArray* allConnections7 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections7 count]==1, @"we didnt connect this.. %i", [allConnections7 count]); 
	
	[um setGroupsByEvent:YES];
	[um removeAllActions];
	/* End Test Undo And Redo */

	int icCount1 = [[[rootNode shInterConnectorsInside] array] count];

	//-- Case 3 --//
	[doc connectOutletOfInput:atChild4 toInletOfOutput:outAtt3];
	int icCount2 = [[[rootNode shInterConnectorsInside] array] count];
	STAssertTrue(icCount2==icCount1+1, @"Did we add a new ic to root?");
	
	//-- Case 4 --//
	SHNode* node2 = [SHNode makeChildWithName:@""];
	[rootNode addChild:node2 undoManager:nil];
	SHInputAttribute *inAtt4 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[node2 addChild:inAtt4 undoManager:nil];
	[doc connectOutletOfInput:outAtt2 toInletOfOutput:inAtt4];
	int icCount3 = [[[rootNode shInterConnectorsInside] array] count];
	STAssertTrue(icCount3==icCount2+1, @"Did we add a new ic to root?");
}

- (void)testConnectOutletOfInputAtPathToInletOfOutputAtPath {
// - (void)connectOutletOfInputAtPath:(SH_Path *)att1 toInletOfOutputAtPath:(SH_Path *)att2

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	SHInputAttribute* inAtt1 = [doc makeInputInCurrentNodeWithType:@"mockDataType"];
	SHInputAttribute* inAtt2 = [doc makeInputInCurrentNodeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt1 = [doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	SHOutputAttribute* outAtt2 = [doc makeOutputInCurrentNodeWithType:@"mockDataType"];

	SHNode* node1 = [SHNode makeChildWithName:@"node1"];
	[rootNode addChild:node1 undoManager:nil];
	
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[node1 addChild:atChild3 undoManager:nil];
	[node1 addChild:atChild4 undoManager:nil];
	
	// -- how do we connect inAtt1 to atChild3 ?
	SH_Path *inPath1 = [rootNode relativePathToChild:inAtt2];
	SH_Path *outPath1 = [rootNode relativePathToChild:outAtt2];
	SH_Path *inPath2 = [rootNode relativePathToChild:inAtt2];
	SH_Path *inPath3 = [rootNode relativePathToChild:atChild3];
	
	[doc connectOutletOfInputAtPath:inPath1 toInletOfOutputAtPath:outPath1];
	
	[um removeAllActions];
	[um beginUndoGrouping];
		[doc connectOutletOfInputAtPath:inPath2 toInletOfOutputAtPath:inPath3];
	[um endUndoGrouping];

	NSArray* allConnections1 = [rootNode allConnectionsToChild:outAtt1];
	STAssertTrue([allConnections1 count]==0, @"we didnt connect this.."); 

	NSArray* allConnections2 = [rootNode allConnectionsToChild:outAtt2];
	STAssertTrue([allConnections2 count]==1, @"didnt we connect?"); 

	NSArray* allConnections3 = [rootNode allConnectionsToChild:inAtt1];
	STAssertTrue([allConnections3 count]==0, @"we didnt connect this.."); 
	
	NSArray* allConnections4 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections4 count]==2, @"we didnt connect this.. %i", [allConnections4 count]); 
	
//dec09	STAssertTrue([doc isDocumentEdited], @"didnt we just add a node?"); 
	STAssertTrue([um canUndo]==YES, @"didnt we just add a node?");
	
	
	/* Test Undo And Redo */
	[um undo];
	// -- should remove from inAtt2 to atChild3
	NSArray* allConnections5 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections5 count]==1, @"we didnt connect this.. %i", [allConnections5 count]); 
	
	[um redo];
	// -- should restore from inAtt2 to atChild3
	NSArray* allConnections6 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections6 count]==2, @"we didnt connect this.. %i", [allConnections6 count]); 
	
	[um undo];
	// -- should remove from inAtt2 to atChild3
	NSArray* allConnections7 = [rootNode allConnectionsToChild:inAtt2];
	STAssertTrue([allConnections7 count]==1, @"we didnt connect this.. %i", [allConnections7 count]); 
}


- (void)testAddChildrenToNodeAtIndexes {
// - (void)addChildren:(NSArray *)arrayValue toNode:(SHNode *)node atIndexes:(NSArray *)positions

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	[rootNode addObserver:self forKeyPath:@"nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];
	[rootNode addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];
	
	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *positions = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	int countOfChildren1 = [rootNode countOfChildren];
	[self resetObservers];
	
	[um beginUndoGrouping];
		[doc addChildren:children toNode:rootNode atIndexes:positions];
	[um endUndoGrouping];

	int countOfChildren2 = [rootNode countOfChildren];
	STAssertTrue(countOfChildren2==countOfChildren1+2, @"failure");
	STAssertTrue([rootNode nodeAtIndex:2]==child1, @"failure");
	STAssertTrue([rootNode nodeAtIndex:3]==child2, @"failure");

	STAssertTrue( _numberOfNotificationsReceived==1, @"what happened? %i", _numberOfNotificationsReceived);
	STAssertTrue( _nodeAddedNotifications==1, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
	/* Test Undo And Redo */
	[um undo];
	int countOfChildren3 = [rootNode countOfChildren];
	STAssertTrue(countOfChildren3==countOfChildren1, @"failure");

	STAssertTrue( _numberOfNotificationsReceived==2, @"what happened? %i", _numberOfNotificationsReceived);
	STAssertTrue( _nodeAddedNotifications==2, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
	[um redo];
	int countOfChildren4 = [rootNode countOfChildren];
	STAssertTrue(countOfChildren4==countOfChildren2, @"failure");
	STAssertTrue([rootNode nodeAtIndex:2]==child1, @"failure");
	STAssertTrue([rootNode nodeAtIndex:3]==child2, @"failure");
	
	STAssertTrue( _numberOfNotificationsReceived==3, @"what happened? %i", _numberOfNotificationsReceived);
	STAssertTrue( _nodeAddedNotifications==3, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
    [rootNode removeObserver:self forKeyPath:@"nodesInside.selection"];
    [rootNode removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)testAddChildrenToCurrentNode {
// - (void)addChildrenToCurrentNode:(NSArray *)arrayValue

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc addChildrenToCurrentNode:children];
	STAssertTrue([child1 parentSHNode]==rootNode, @"failure");
	STAssertTrue([child2 parentSHNode]==rootNode, @"failure");
	STAssertTrue([rootNode childWithKey:@"one"]==child1, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==child2, @"failure");
}

- (void)testAddChildrenToNode {
// - (void)addChildren:(NSArray *)arrayValue toNode:(SHNode *)node

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc addChildren:children toNode:rootNode];
	
	STAssertTrue([child1 parentSHNode]==rootNode, @"failure");
	STAssertTrue([child2 parentSHNode]==rootNode, @"failure");
	STAssertTrue([rootNode childWithKey:@"one"]==child1, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==child2, @"failure");
}

- (void)testAddChildrenToSelectionInNode {
	// - (void)addChildrenToSelection:(NSArray *)childrenToSelect inNode:(SHNode *)theParentNode

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	[rootNode addObserver:self forKeyPath:@"nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];
	[rootNode addObserver:self forKeyPath:@"nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];
	
	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	NSArray *children = [NSArray arrayWithObjects:child1, child2, atChild3, atChild4, nil];
	[doc addChildrenToCurrentNode:children];
	SHInterConnector* int1 = [rootNode connectOutletOfAttribute:atChild3 toInletOfAttribute:atChild4 undoManager:nil];
	/* Because we cant inspect it after we have unconnected it, how can we test that a new connection is equivalent to the old one? We must save some connection info */
//08 may	id i1Info = [int1 currentConnectionInfo];
	
	[doc deSelectAllChildrenInNode: rootNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==0, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
	NSArray *childrenToSelect = [NSArray arrayWithObjects:child1, atChild3, int1, nil];
	[self resetObservers];
	
	[um beginUndoGrouping];
		[doc addChildrenToSelection:childrenToSelect inNode: rootNode];
	[um endUndoGrouping];
	
	STAssertTrue( _nodeAddedNotifications==0, @"what happened? %i", _nodeAddedNotifications);
	STAssertTrue( _selectionChangedCount==1, @"what happened? %i", _selectionChangedCount);
	
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==3, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
	STAssertTrue([allSelected objectAtIndex:0] ==child1, @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:0]);
	STAssertTrue([allSelected objectAtIndex:1] ==atChild3, @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:1]);
	STAssertTrue([allSelected objectAtIndex:2] ==int1, @"addChildToSelectionfailed %@ - %@", int1, [allSelected objectAtIndex:2]);	
	
	/* Test Undo And Redo */
//	[um undo];
//	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
//	STAssertTrue([allSelected count]==0, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
//	STAssertTrue( _nodeAddedNotifications==1, @"what happened? %i", _nodeAddedNotifications);
//	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
//	[um redo];
//	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
//	STAssertTrue([allSelected count]==3, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
//	STAssertTrue( _nodeAddedNotifications==1, @"what happened? %i", _nodeAddedNotifications);
//	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
	
	// -- NB! It is normal that the objects won't be the EXACT originals but should be equivalent
	STAssertTrue([[allSelected objectAtIndex:0] isEquivalentTo:child1], @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:0]);
	STAssertTrue([[allSelected objectAtIndex:1] isEquivalentTo:atChild3], @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:1]);
	// STAssertTrue([[allSelected objectAtIndex:2] isEquivalentTo:i1Info], @"addChildToSelectionfailed %@ - %@", int1, [allSelected objectAtIndex:2]);
    [rootNode removeObserver:self forKeyPath:@"nodesInside.selection"];
    [rootNode removeObserver:self forKeyPath:@"nodesInside.array"];
}

- (void)testRemoveChildrenFromSelectionInNode {
	// - (void)removeChildrenFromSelection:(NSArray *)childrenToDeSelect inNode:(SHNode *)theParentNode
		
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[rootNode addObserver:self forKeyPath:@"nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	NSArray *children = [NSArray arrayWithObjects:child1, child2, atChild3, atChild4, nil];
	[doc addChildrenToCurrentNode:children];
	SHInterConnector* int1 = [rootNode connectOutletOfAttribute:atChild3 toInletOfAttribute:atChild4 undoManager:nil];

	[doc deSelectAllChildrenInNode: rootNode];
	NSArray *childrenToSelect = [NSArray arrayWithObjects:child1, child2, atChild3, atChild4, int1, nil];
	[doc addChildrenToSelection:childrenToSelect inNode:rootNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==5, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
	[self resetObservers];

	NSArray *childrenToUnSelect = [NSArray arrayWithObjects:child1, atChild3, int1, nil];
	
//08 may	[um beginUndoGrouping];
	[doc removeChildrenFromSelection:childrenToUnSelect inNode:rootNode];
//08 may	[um endUndoGrouping];

	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==2, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
	STAssertTrue([[allSelected objectAtIndex:0] isEquivalentTo:child2], @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:0]);
	STAssertTrue([[allSelected objectAtIndex:1] isEquivalentTo:atChild4], @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:1]);
	STAssertTrue( _selectionChangedCount==1, @"what happened? %i", _selectionChangedCount);

	/* Test Undo And Redo */
//08 may	[um undo];
//08 may	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
//08 may	STAssertTrue([allSelected count]==5, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );

//08 may	[um redo];
//08 may	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
//08 may	STAssertTrue([allSelected count]==2, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
//08 may	STAssertTrue([[allSelected objectAtIndex:0] isEquivalentTo:child2], @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:0]);
//08 may	STAssertTrue([[allSelected objectAtIndex:1] isEquivalentTo:atChild4], @"addChildToSelectionfailed %@",  [allSelected objectAtIndex:1]);
	
    [rootNode removeObserver:self forKeyPath:@"nodesInside.selection"];
}

- (void)testDeleteChildrenFromNode {
// - (void)deleteChildren:(NSArray *)arrayValue fromNode:(SHNode *)node

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];
	
	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];
	SHNode *child3 = [SHNode makeChildWithName:@"three"];
	SHNode *child4 = [SHNode makeChildWithName:@"four"];

	
	NSArray *children = [NSArray arrayWithObjects:child1, child2, child3, child4, nil];
	[doc addChildrenToCurrentNode:children];
	[doc addChildrenToSelection:[NSArray arrayWithObjects:child1, child2, child4, nil] inNode:rootNode];

	STAssertTrue( [rootNode nodeAtIndex:0]==child1, @"doh %@", [[rootNode nodeAtIndex:0] name]);
	STAssertTrue( [rootNode nodeAtIndex:1]==child2, @"doh %@", [[rootNode nodeAtIndex:1] name]);
	STAssertTrue( [rootNode nodeAtIndex:2]==child3, @"doh %@", [[rootNode nodeAtIndex:2] name]);
	STAssertTrue( [rootNode nodeAtIndex:3]==child4, @"doh %@", [[rootNode nodeAtIndex:3] name]);
	
	/* Test Undo / Redo */
	[um removeAllActions];
	[um beginUndoGrouping];
		[doc deleteChildren:[NSArray arrayWithObjects:child2, child4, nil] fromNode:rootNode];
	[um endUndoGrouping];

	STAssertEquals( (int)[rootNode countOfChildren], (int)2, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	STAssertTrue([child2 parentSHNode]==nil, @"failure");
	STAssertTrue([child4 parentSHNode]==nil, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==nil, @"failure");
	STAssertTrue([rootNode childWithKey:@"four"]==nil, @"failure");
	
	[um undo];
	STAssertEquals( (int)[rootNode countOfChildren], (int)4, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	STAssertTrue([child2 parentSHNode]==rootNode, @"failure");
	STAssertTrue([child4 parentSHNode]==rootNode, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==child2, @"failure");
	STAssertTrue([rootNode childWithKey:@"four"]==child4, @"failure");
	
	//-- test that the indexes have been preserved
	STAssertTrue( [rootNode nodeAtIndex:0]==child1, @"doh %@", [[rootNode nodeAtIndex:0] name]);
	STAssertTrue( [rootNode nodeAtIndex:1]==child2, @"doh %@", [[rootNode nodeAtIndex:1] name]);
	STAssertTrue( [rootNode nodeAtIndex:2]==child3, @"doh %@", [[rootNode nodeAtIndex:2] name]);
	STAssertTrue( [rootNode nodeAtIndex:3]==child4, @"doh %@", [[rootNode nodeAtIndex:3] name]);

	[um redo];
	STAssertEquals( (int)[rootNode countOfChildren], (int)2, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	
	[um undo];
	STAssertEquals( (int)[rootNode countOfChildren], (int)4, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	STAssertTrue( [rootNode nodeAtIndex:0]==child1, @"doh %@", [[rootNode nodeAtIndex:0] name]);
	STAssertTrue( [rootNode nodeAtIndex:1]==child2, @"doh %@", [[rootNode nodeAtIndex:1] name]);
	STAssertTrue( [rootNode nodeAtIndex:2]==child3, @"doh %@", [[rootNode nodeAtIndex:2] name]);
	STAssertTrue( [rootNode nodeAtIndex:3]==child4, @"doh %@", [[rootNode nodeAtIndex:3] name]);
}

- (void)testDeleteInterConnectorsFromNode {
// - (void)deleteInterConnectors:(NSArray *)ics fromNode:(SHNode *)node
	
	SHNode* root = [doc.nodeGraphModel currentNodeGroup];
	[root addObserver:self forKeyPath:@"shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"HighLevelBlakeDocumentActionsTests"];

	SHInputAttribute* atChild1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild5 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[root addChild:atChild1 undoManager:nil];
	[root addChild:atChild2 undoManager:nil];
	[root addChild:atChild5 undoManager:nil];
	
	SHNode* node1 = [SHNode makeChildWithName:@"node1"];
	[root addChild:node1 undoManager:nil];
	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild4 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[node1 addChild:atChild3 undoManager:nil];
	[node1 addChild:atChild4 undoManager:nil];
	// make all 3 possible connections
	SHInterConnector* int1 = [root connectOutletOfAttribute:atChild1 toInletOfAttribute:atChild2 undoManager:nil];
	SHInterConnector* int2 = [root connectOutletOfAttribute:atChild1 toInletOfAttribute:atChild3 undoManager:nil];
	SHInterConnector* int3 = [root connectOutletOfAttribute:atChild4 toInletOfAttribute:atChild5 undoManager:nil];
	STAssertNotNil(int1, @"interconnector failed");
	STAssertNotNil(int2, @"interconnector failed");
	STAssertNotNil(int3, @"interconnector failed");
	[self resetObservers];

	[um removeAllActions];
	[um beginUndoGrouping];
		[doc deleteInterConnectors:[NSArray arrayWithObjects:int1, nil] fromNode:root];
	[um endUndoGrouping];

	// -- now there should be 2 interconnectors and this delete should be undoable
	
	NSArray *ics = [root interConnectorsDependantOnChildren:[NSArray arrayWithObjects:atChild1, atChild5, nil]];
	STAssertTrue([ics count]==2, @"count is %i", [ics count]);
	STAssertTrue( _interConnectorsChanged==1, @"what happened? %i", _interConnectorsChanged);
	
	[um undo];
	ics = [root interConnectorsDependantOnChildren:[NSArray arrayWithObjects:atChild1, atChild5, nil]];
	STAssertTrue([ics count]==3, @"count is %i", [ics count]);
	STAssertTrue( _interConnectorsChanged==2, @"what happened? %i", _interConnectorsChanged);

	[um redo];
	ics = [root interConnectorsDependantOnChildren:[NSArray arrayWithObjects:atChild1, atChild5, nil]];
	STAssertTrue([ics count]==2, @"count is %i", [ics count]);
	STAssertTrue( _interConnectorsChanged==3, @"what happened? %i", _interConnectorsChanged);

    [root removeObserver:self forKeyPath:@"shInterConnectorsInside.array"];
}


- (void)testDeleteChildrenFromCurrentNode {
// - (void)deleteChildrenFromCurrentNode:(NSArray *)arrayValue

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc addChildrenToCurrentNode:children];
	[doc deleteChildrenFromCurrentNode:children];
	STAssertTrue([child1 parentSHNode]==nil, @"failure");
	STAssertTrue([child2 parentSHNode]==nil, @"failure");
	STAssertTrue([rootNode childWithKey:@"one"]==nil, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==nil, @"failure");
} 

- (void)testDeleteSelectedChildrenFromCurrentNode {
//- (void)deleteSelectedChildrenFromCurrentNode

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc makeEmptyGroupInCurrentNodeWithName:@"circle"];
	[doc makeEmptyGroupInCurrentNodeWithName:@"square"];
	[doc makeEmptyGroupInCurrentNodeWithName:@"triangle"];
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	NSArray *inputs = [[rootNode inputs] array];
	NSArray *outputs = [[rootNode outputs] array];
	int inputCount = [inputs count];
	int outputCount = [outputs count];
	[doc connectOutletOfInput:[inputs objectAtIndex:inputCount-3] toInletOfOutput:[outputs objectAtIndex:outputCount-3]];
	[doc connectOutletOfInput:[inputs objectAtIndex:inputCount-2] toInletOfOutput:[outputs objectAtIndex:outputCount-2]];
	[doc connectOutletOfInput:[inputs objectAtIndex:inputCount-1] toInletOfOutput:[outputs objectAtIndex:outputCount-1]];

	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];
	
	/* Beware this doesnt return an immutable array - it's contents will change */
	NSArray *alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==[allSelected count], @"select all failed" );
	STAssertTrue([alChildren count]==0, @"select all failed" );
	
	/* Test Undo And Redo */
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	inputs = [[rootNode inputs] array];
	outputs = [[rootNode outputs] array];
	[doc connectOutletOfInput:[inputs objectAtIndex:0] toInletOfOutput:[outputs objectAtIndex:0]];
	[doc deSelectAllChildrenInCurrentNode];
	NSArray *ics = [[rootNode shInterConnectorsInside] array];
	STAssertTrue([ics count]==1, @"select all failed %i", [ics count] );
	[doc addChildToSelectionInCurrentNode: [ics objectAtIndex:0]];
	
	[um removeAllActions];
	[um beginUndoGrouping];
		[doc deleteSelectedChildrenFromCurrentNode];
	[um endUndoGrouping];

	/* Beware this doesnt return an immutable array - it's contents will change */
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	STAssertTrue([alChildren count]==2, @"select all failed %i", [alChildren count] );
	
	[um undo];
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==3, @"select all failed %i", [alChildren count] );
	// STAssertTrue([alChildren count]==1, @"select all failed" );
	
	[um redo];
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==2, @"select all failed" );
	// STAssertTrue([alChildren count]==0, @"select all failed" );
	
	[um undo];
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==3, @"select all failed" );
	// STAssertTrue([alChildren count]==1, @"select all failed" );
	
	[um redo];
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==2, @"select all failed" );

}

- (void)testDeleteSelectedChildrenFromNode {
//- (void)deleteSelectedChildrenFromNode:(SHNode *)node

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];
	SHNode *child3 = [SHNode makeChildWithName:@"three"];
	SHNode *child4 = [SHNode makeChildWithName:@"four"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, child3, child4, nil];
	[doc addChildrenToCurrentNode:children];
	[doc addChildrenToSelection:[NSArray arrayWithObjects:child1, child2, child4, nil] inNode:rootNode];

	STAssertTrue( [rootNode nodeAtIndex:0]==child1, @"doh %@", [[rootNode nodeAtIndex:0] name]);
	STAssertTrue( [rootNode nodeAtIndex:1]==child2, @"doh %@", [[rootNode nodeAtIndex:1] name]);
	STAssertTrue( [rootNode nodeAtIndex:2]==child3, @"doh %@", [[rootNode nodeAtIndex:2] name]);
	STAssertTrue( [rootNode nodeAtIndex:3]==child4, @"doh %@", [[rootNode nodeAtIndex:3] name]);

	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue( [allSelected count]==3, @"doh %i", [allSelected count]);
	STAssertTrue( [allSelected objectAtIndex:0]==child1, @"doh %@", [[allSelected objectAtIndex:0] name]);
	STAssertTrue( [allSelected objectAtIndex:1]==child2, @"doh %@", [[allSelected objectAtIndex:1] name]);
	STAssertTrue( [allSelected objectAtIndex:2]==child4, @"doh %@", [[allSelected objectAtIndex:2] name]);
	
	/* Test Undo / Redo */
	[um removeAllActions];
	[um beginUndoGrouping];	
		[doc deleteSelectedChildrenFromNode:rootNode];
	[um endUndoGrouping];

	STAssertEquals( (int)[rootNode countOfChildren], (int)1, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	STAssertTrue([child2 parentSHNode]==nil, @"failure");
	STAssertTrue([child4 parentSHNode]==nil, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==nil, @"failure");
	STAssertTrue([rootNode childWithKey:@"four"]==nil, @"failure");
	
	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove nodes"], @"%@", [um undoMenuItemTitle]);

	[um undo];
	STAssertEquals( (int)[rootNode countOfChildren], (int)4, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	STAssertTrue([child2 parentSHNode]==rootNode, @"failure");
	STAssertTrue([child4 parentSHNode]==rootNode, @"failure");
	STAssertTrue([rootNode childWithKey:@"two"]==child2, @"failure");
	STAssertTrue([rootNode childWithKey:@"four"]==child4, @"failure");
	
	//-- test that the indexes have been preserved
	STAssertTrue( [rootNode nodeAtIndex:0]==child1, @"doh %@", [[rootNode nodeAtIndex:0] name]);
	STAssertTrue( [rootNode nodeAtIndex:1]==child2, @"doh %@", [[rootNode nodeAtIndex:1] name]);
	STAssertTrue( [rootNode nodeAtIndex:2]==child3, @"doh %@", [[rootNode nodeAtIndex:2] name]);
	STAssertTrue( [rootNode nodeAtIndex:3]==child4, @"doh %@", [[rootNode nodeAtIndex:3] name]);
	
	//-- test that the selections have been preserved
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue( [allSelected count]==3, @"doh %i", [allSelected count]);
	STAssertTrue( [allSelected objectAtIndex:0]==child1, @"doh %@", [[allSelected objectAtIndex:0] name]);
	STAssertTrue( [allSelected objectAtIndex:1]==child2, @"doh %@", [[allSelected objectAtIndex:1] name]);
	STAssertTrue( [allSelected objectAtIndex:2]==child4, @"doh %@", [[allSelected objectAtIndex:2] name]);

	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove nodes"], @"%@", [um redoMenuItemTitle]);
	
	[um redo];
	STAssertEquals( (int)[rootNode countOfChildren], (int)1, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue( [allSelected count]==0, @"doh %i", [allSelected count]);

	STAssertTrue([[um undoMenuItemTitle] isEqualToString:@"Undo remove nodes"], @"%@", [um undoMenuItemTitle]);

	[um undo];
	STAssertEquals( (int)[rootNode countOfChildren], (int)4, @"deleteChildren: failed %i", [rootNode countOfChildren]);
	STAssertTrue( [rootNode nodeAtIndex:0]==child1, @"doh %@", [[rootNode nodeAtIndex:0] name]);
	STAssertTrue( [rootNode nodeAtIndex:1]==child2, @"doh %@", [[rootNode nodeAtIndex:1] name]);
	STAssertTrue( [rootNode nodeAtIndex:2]==child3, @"doh %@", [[rootNode nodeAtIndex:2] name]);
	STAssertTrue( [rootNode nodeAtIndex:3]==child4, @"doh %@", [[rootNode nodeAtIndex:3] name]);

	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue( [allSelected count]==3, @"doh %i", [allSelected count]);
	STAssertTrue( [allSelected objectAtIndex:0]==child1, @"doh %@", [[allSelected objectAtIndex:0] name]);
	STAssertTrue( [allSelected objectAtIndex:1]==child2, @"doh %@", [[allSelected objectAtIndex:1] name]);
	STAssertTrue( [allSelected objectAtIndex:2]==child4, @"doh %@", [[allSelected objectAtIndex:2] name]);
	
	STAssertTrue([[um redoMenuItemTitle] isEqualToString:@"Redo remove nodes"], @"%@", [um redoMenuItemTitle]);

/* Older Tests - doesn't seem to be any harm keeping them around if they pass */
	
	/* Test Undo And Redo */	
	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];

	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	
	NSArray *inputs = [[rootNode inputs] array];
	NSArray *outputs = [[rootNode outputs] array];
	
	// we are just going to try with an interconnector…
	[doc connectOutletOfInput:[inputs objectAtIndex:0] toInletOfOutput:[outputs objectAtIndex:0]];
	NSArray *iCons = [[rootNode shInterConnectorsInside] array];
	[doc deSelectAllChildrenInNode: rootNode];
	[doc addChildToSelectionInCurrentNode:[iCons objectAtIndex:0]];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==1, @"select Interconnector failed" );
	SHInlet *inSHConnectlet1 = [(SHInterConnector *)[iCons objectAtIndex:0] inSHConnectlet];
	SHOutlet *outSHConnectlet1 = [(SHInterConnector *)[iCons objectAtIndex:0] outSHConnectlet];
	
	[um removeAllActions];
	[um beginUndoGrouping];
		[doc deleteSelectedChildrenFromCurrentNode]; // calls deleteInterConnectors
	[um endUndoGrouping];

	[um undo];									// calls connectOutletOfInputAtPath toInletOfOutputAtPath
	
	/* Beware this doesnt return an immutable array - it's contents will change */
	NSArray *alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==3, @"select all failed %i", [alChildren count]);
	iCons = [[rootNode shInterConnectorsInside] array];
	
	SHInlet *inSHConnectlet2 = [(SHInterConnector *)[iCons objectAtIndex:0] inSHConnectlet];
	SHOutlet *outSHConnectlet2 = [(SHInterConnector *)[iCons objectAtIndex:0] outSHConnectlet];
	
	STAssertEqualObjects(inSHConnectlet2, inSHConnectlet1, @"did we reconnect up the interconnector the wrong way round?");
	STAssertEqualObjects(outSHConnectlet1, outSHConnectlet2, @"did we reconnect up the interconnector the wrong way round?");
	//STAssertTrue([allSelected count]==0, @"select all failed" );
	
	[um redo];									// calls deleteInterConnectors
	/* Beware this doesnt return an immutable array - it's contents will change */
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==2, @"select all failed" );
	// STAssertTrue([alChildren count]==0, @"select all failed" );
	
	[um undo];
	/* Beware this doesnt return an immutable array - it's contents will change */
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==3, @"select all failed" );
	iCons = [[rootNode shInterConnectorsInside] array];
	SHInlet *inSHConnectlet3 = [(SHInterConnector *)[iCons objectAtIndex:0] inSHConnectlet];
	SHOutlet *outSHConnectlet3 = [(SHInterConnector *)[iCons objectAtIndex:0] outSHConnectlet];
	STAssertEqualObjects(inSHConnectlet3, inSHConnectlet1, @"did we reconnect up the interconnector the wrong way round?");
	STAssertEqualObjects(outSHConnectlet3, outSHConnectlet1, @"did we reconnect up the interconnector the wrong way round?");
	
	[um redo];
	/* Beware this doesnt return an immutable array - it's contents will change */
	alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([alChildren count]==2, @"select all failed" );
	// STAssertTrue([alChildren count]==0, @"select all failed" );
}

- (void)testSelectAllChildrenInCurrentNode {
//- (void)selectAllChildrenInCurrentNode
	
	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	NSArray *alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	[doc selectAllChildrenInCurrentNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	
	STAssertTrue([alChildren count]==[allSelected count], @"select all failed" );
}

- (void)testSelectAllChildrenInNode {
//- (void)selectAllChildrenInNode:(SHNode *)node

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];
	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc selectAllChildrenInNode:rootNode];
	NSArray *alChildren = [doc.nodeGraphModel allChildrenFromNode:rootNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];

	STAssertTrue([alChildren count]==[allSelected count], @"select all failed" );
}

- (void)testDeSelectAllChildrenInCurrentNode {
// - (void)deSelectAllChildrenInCurrentNode;

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc selectAllChildrenInNode:rootNode];
	[doc deSelectAllChildrenInCurrentNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==0, @"deSelect all failed" );
}

- (void)testDeSelectAllChildrenInNode {
// - (void)deSelectAllChildrenInNode:(SHNode *)node;

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc selectAllChildrenInNode:rootNode];
	[doc deSelectAllChildrenInNode: rootNode];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==0, @"deSelect all failed" );
}

- (void)testAddChildToSelectionInCurrentNode {
/* may have to rename this later when i find out ho the tableView handles it (we want to get the table view to use the undoable versions) */
// - (void)addChildToSelectionInCurrentNode:(id)child;

	NSUInteger childCountAtStart = [[(SHNodeGraphModel *)doc.nodeGraphModel currentNodeGroup] countOfChildren];
	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	STAssertTrue([[(SHNodeGraphModel *)doc.nodeGraphModel currentNodeGroup] countOfChildren]==childCountAtStart+2, @"doh! %i", [[(SHNodeGraphModel *)doc.nodeGraphModel currentNodeGroup] countOfChildren]);
	
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc deSelectAllChildrenInNode: rootNode];
	[doc addChildToSelectionInCurrentNode: child2];
	NSArray *allSelected = [doc.nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelected count]==1, @"addChildToSelectionInCurrentNode failed %i", [allSelected count] );
	STAssertEqualObjects([allSelected lastObject], child2, @"addChildToSelectionfailed" );
}

- (void)testMoveDownALevelIntoNodeGroup {
// - (void)moveDownALevelIntoNodeGroup:(SHNode *)aNodeGroup

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];
	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	[doc deSelectAllChildrenInNode: rootNode];
	[doc addChildToSelectionInCurrentNode: child2];
	
	[um beginUndoGrouping];
		[doc moveDownALevelIntoNodeGroup: child2];
	[um endUndoGrouping];

	SHNode* ang = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang, child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, child2);

	/* Test Undo And Redo */
	[um undo]; // calls move up and set selection
	SHNode* ang2 = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang2, rootNode, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, child2);
	//-- check the selection state
	//NSArray *currentNodeSelection = [rootNode selectedChildNodes];
	//STAssertEqualObjects([currentNodeSelection objectAtIndex:0], child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", [currentNodeSelection objectAtIndex:0], child2);

	[um redo]; // calls move down
	SHNode* ang3 = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang3, child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, child2);

}

- (void)testMoveDownAlevelIntoSelectedNodeGroup {
// - (void)moveDownAlevelIntoSelectedNodeGroup;

	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	[doc deSelectAllChildrenInNode: rootNode];
	[doc addChildToSelectionInCurrentNode: child2];
	
	[um beginUndoGrouping];
		[doc moveDownAlevelIntoSelectedNodeGroup];
	[um endUndoGrouping];

	SHNode* ang = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang, child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, child2);

	/* Test Undo And Redo */
	[um undo]; // calls move up and set selection
	SHNode* ang2 = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang2, rootNode, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, child2);
	//-- check the selection state
	//NSArray *currentNodeSelection = [rootNode selectedChildNodes];
	//STAssertEqualObjects([currentNodeSelection objectAtIndex:0], child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", [currentNodeSelection objectAtIndex:0], child2);

	[um redo]; // calls move down
	SHNode* ang3 = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang3, child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, child2);

}

- (void)testMoveUpAlevelToParentNodeGroup {
	//- (void)moveUpAlevelToParentNodeGroup
	
	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];
	[doc deSelectAllChildrenInNode: rootNode];
	[doc addChildToSelectionInCurrentNode: child2];
	[doc moveDownAlevelIntoSelectedNodeGroup];
	
	[um removeAllActions];
	[um beginUndoGrouping];
		[doc moveUpAlevelToParentNodeGroup];
	[um endUndoGrouping];
	
	SHNode* ang = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang, rootNode, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang, rootNode);

	/* Test Undo And Redo */
	[um undo];
	SHNode* ang2 = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang2, child2, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang2, rootNode);
	
	[um redo];
	SHNode* ang3 = [doc.nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang3, rootNode, @"moveDownAlevelIntoSelectedNodeGroup failed %@, %@", ang3, child2);
}

- (void)testAddContentsOfFileToNodeAtIndex {
	//- (void)addContentsOfFile:(NSString *)filePath toNode:(SHNode *)node atIndex:(int)index 
}

- (void)testAddToIndexOfChild {
	// - (void)add:(int)amountToMove toIndexOfChild:(id)aChild;
	
	SHNode* rootNode = [doc.nodeGraphModel currentNodeGroup];

	SHNode *child1 = [SHNode makeChildWithName:@"one"];
	SHNode *child2 = [SHNode makeChildWithName:@"two"];

	NSArray *children = [NSArray arrayWithObjects:child1, child2, nil];
	[doc addChildrenToCurrentNode:children];
	int childIndex = [rootNode indexOfChild:child1];

	[doc add:1 toIndexOfChild:child1];

	int newIndex = [rootNode indexOfChild:child1];
	STAssertTrue(newIndex==childIndex+1, @"should be %i, is %i", childIndex+1, newIndex);

	[um removeAllActions];
	[um beginUndoGrouping];
		[doc add:-1 toIndexOfChild:child1];
	[um endUndoGrouping];
	
	int newIndex2 = [rootNode indexOfChild:child1];
	STAssertTrue(newIndex2==childIndex, @"Failed");
	
	/* Test Undo And Redo */
	[um undo];
	int newIndex3 = [rootNode indexOfChild:child1];
	STAssertTrue(newIndex3==newIndex, @"Failed %i", newIndex3);
	
	[um redo];
	int newIndex4 = [rootNode indexOfChild:child1];
	STAssertTrue(newIndex4==childIndex, @"Failed");
}


- (void)testGroupChildren {
// - (void)groupChildren:(NSArray *)someChildren

	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];
	
	SHNode *root = [[doc nodeGraphModel] rootNodeGroup];
	SHNode *newNode1 = [doc makeEmptyGroupInCurrentNodeWithName:@"nodeToGroup_1"];
	SHNode* newNode2 = [doc makeEmptyGroupInCurrentNodeWithName:@"nodeToGroup_2"];

	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];

	NSArray *inputs = [[root inputs] array];
	NSArray *outputs = [[root outputs] array];
	SHInputAttribute *in1 =  [inputs objectAtIndex:0];
	SHInputAttribute *in2 =  [inputs objectAtIndex:1];
	SHOutputAttribute *out1 =  [outputs objectAtIndex:0];
	SHOutputAttribute *out2 =  [outputs objectAtIndex:1];
	
	[doc connectOutletOfInput:in1 toInletOfOutput:in2];
	SHInterConnector *originalIC1 = [[[root shInterConnectorsInside] array] objectAtIndex:0];
	SHConnectlet *inCon1 = [originalIC1 inSHConnectlet];
	SHConnectlet *outCon1 = [originalIC1 outSHConnectlet];
	
	[doc connectOutletOfInput:in2 toInletOfOutput:out1];
	SHInterConnector *originalIC2 = [[[root shInterConnectorsInside] array] objectAtIndex:1];
	SHConnectlet *inCon2 = [originalIC2 inSHConnectlet];
	SHConnectlet *outCon2 = [originalIC2 outSHConnectlet];
	
	[doc connectOutletOfInput:out1 toInletOfOutput:out2];
	SHInterConnector *originalIC3 = [[[root shInterConnectorsInside] array] objectAtIndex:2];
	SHConnectlet *inCon3 = [originalIC3 inSHConnectlet];
	SHConnectlet *outCon3 = [originalIC3 outSHConnectlet];
	STAssertTrue(originalIC1!=originalIC2, @"wrong connectors");
	STAssertTrue(originalIC1!=originalIC3, @"wrong connectors");
	
	SHNode *currentNodeGroup = [doc.nodeGraphModel currentNodeGroup];
	NSArray *nodes = [[root nodesInside] array];
	NSArray *ics = [[root shInterConnectorsInside] array];
	STAssertTrue([nodes count]==2, @"did we move the contents into a new node? %i", [nodes count]);
	STAssertTrue([inputs count]==2, @"did we move the contents into a new node? %i", [inputs count]);
	STAssertTrue([outputs count]==2, @"did we move the contents into a new node? %i", [outputs count]);
	STAssertTrue([ics count]==3, @"did we move the contents into a new node? %i", [ics count]);
	STAssertTrue([currentNodeGroup countOfChildren]==9, @"actually is %i", [currentNodeGroup countOfChildren]);

	/* Do the group */
	[um beginUndoGrouping];
		[doc groupChildren: [NSArray arrayWithObjects: newNode1, newNode2, in2, out1, nil]];
	[um endUndoGrouping];
	
	STAssertTrue([currentNodeGroup countOfChildren]==5, @"actually is %i", [currentNodeGroup countOfChildren]);

	// now have 1 node, 1 input and 1 output in root
	// the input in root is connected to input in new Empty node
	// the output in new Empty is connected to output in root
	NSArray *nodes1 = [[root nodesInside] array];
	inputs = [[root inputs] array];
	outputs = [[root outputs] array];
	ics = [[root shInterConnectorsInside] array];

	STAssertTrue([nodes count]==1, @"did we move the contents into a new node? %i", [nodes count]);
	STAssertTrue([inputs count]==1, @"did we move the contents into a new node? %i", [inputs count]);
	STAssertTrue([outputs count]==1, @"did we move the contents into a new node? %i", [outputs count]);
	/* one connection should have been moved inside new group leaqving 2 here */
	STAssertTrue([ics count]==2, @"did we move the contents into a new node? %i", [ics count]);
	//-- test each ics connectlets are the same way round
	SHInterConnector *remainingIC1 = [ics objectAtIndex:0];
	SHConnectlet *inCon = [remainingIC1 inSHConnectlet];
	SHConnectlet *outCon = [remainingIC1 outSHConnectlet];
	STAssertTrue(inCon==inCon1, @"Must have made a connection the wrong way round");
	STAssertTrue(outCon==outCon1, @"Must have made a connection the wrong way round");

	SHInterConnector *remainingIC2 = [ics objectAtIndex:1];
	inCon = [remainingIC2 inSHConnectlet];
	outCon = [remainingIC2 outSHConnectlet];
	STAssertTrue(inCon==inCon3, @"Must have made a connection the wrong way round");
	STAssertTrue(outCon==outCon3, @"Must have made a connection the wrong way round");
	
	SHNode *newNode = [nodes1 objectAtIndex:0];
	
	// this contains newNode1 & newNode2
	NSArray *deeperNodes = [[newNode nodesInside] array];
	NSArray *deeperInputs = [[newNode inputs] array];
	NSArray *deeperOutputs = [[newNode outputs] array];
	NSArray *deeperOConnectors = [[newNode shInterConnectorsInside] array];
	
	STAssertTrue([deeperNodes count]==2, @"did we move the contents into a new node? %i", [deeperNodes count]);
	STAssertTrue([deeperNodes objectAtIndex:0]==newNode1, @"did we move the contents into a new node? %@", [deeperNodes objectAtIndex:0]);
	STAssertTrue([deeperNodes objectAtIndex:1]==newNode2, @"did we move the contents into a new node? %@", [deeperNodes objectAtIndex:1]);

	STAssertTrue([deeperInputs count]==1, @"did we move the contents into a new node? %i", [deeperInputs count]);
	STAssertTrue([deeperOutputs count]==1, @"did we move the contents into a new node? %i", [deeperOutputs count]);
	STAssertTrue([deeperOConnectors count]==1, @"did we move the contents into a new node? %i", [deeperOConnectors count]);
	// -- test that the ics connectlets are the right way round
	SHInterConnector *deepIC = [deeperOConnectors objectAtIndex:0];
	inCon = [deepIC inSHConnectlet];
	outCon = [deepIC outSHConnectlet];
	STAssertTrue(inCon==inCon2, @"Must have made a connection the wrong way round");
	STAssertTrue(outCon==outCon2, @"Must have made a connection the wrong way round");

	//-- test undo & redo
	[um undo];
	//-- it should be like the group never happened
	SHNode *currentNodeGroup2 = [doc.nodeGraphModel currentNodeGroup];
	STAssertTrue(currentNodeGroup2==currentNodeGroup, @"eh");

	NSArray *nodes2 = [[root nodesInside] array];
	NSArray *ics2 = [[root shInterConnectorsInside] array];
	NSArray *inputs2 = [[root inputs] array];
	NSArray *outputs2 = [[root outputs] array];
	STAssertTrue([nodes2 count]==2, @"did we move the contents into a new node? %i", [nodes2 count]);
	STAssertTrue([inputs2 count]==2, @"did we move the contents into a new node? %i", [inputs2 count]);
	STAssertTrue([outputs2 count]==2, @"did we move the contents into a new node? %i", [outputs2 count]);
	STAssertTrue([ics2 count]==3, @"did we move the contents into a new node? %i", [ics2 count]);
	STAssertTrue([currentNodeGroup2 countOfChildren]==9, @"actually is %i", [currentNodeGroup2 countOfChildren]);
	
	
	[um redo];
	//-- we should be the same as after grouping
		STAssertTrue([currentNodeGroup countOfChildren]==5, @"actually is %i", [currentNodeGroup countOfChildren]);
	NSArray *nodes4 = [[root nodesInside] array];
	NSArray *inputs4 = [[root inputs] array];
	NSArray *outputs4 = [[root outputs] array];
		NSArray *ics4 = [[root shInterConnectorsInside] array];
	STAssertTrue([nodes4 count]==1, @"did we move the contents into a new node? %i", [nodes4 count]);
	STAssertTrue([inputs4 count]==1, @"did we move the contents into a new node? %i", [inputs4 count]);
	STAssertTrue([outputs4 count]==1, @"did we move the contents into a new node? %i", [outputs4 count]);
	/* one connection should have been moved inside new group leaqving 2 here */
		STAssertTrue([ics4 count]==2, @"did we move the contents into a new node? %i", [ics4 count]);

	
	[um undo];
	//-- it should be like the group never happened
	SHNode *currentNodeGroup3 = [doc.nodeGraphModel currentNodeGroup];
	STAssertTrue(currentNodeGroup3==currentNodeGroup, @"eh");

	NSArray *nodes3 = [[root nodesInside] array];
		NSArray *ics3 = [[root shInterConnectorsInside] array];
	NSArray *inputs3 = [[root inputs] array];
	NSArray *outputs3 = [[root outputs] array];
	STAssertTrue([nodes3 count]==2, @"did we move the contents into a new node? %i", [nodes3 count]);
	STAssertTrue([inputs3 count]==2, @"did we move the contents into a new node? %i", [inputs3 count]);
	STAssertTrue([outputs3 count]==2, @"did we move the contents into a new node? %i", [outputs3 count]);
		STAssertTrue([ics3 count]==3, @"did we move the contents into a new node? %i", [ics3 count]);
		STAssertTrue([currentNodeGroup3 countOfChildren]==9, @"actually is %i", [currentNodeGroup3 countOfChildren]);
	

}

- (void)testUnGroupNode {
// - (void)unGroupNode:(SHNode *)aNodeGroup 

	SHNode* root = [[doc nodeGraphModel] rootNodeGroup];
	[[doc nodeGraphModel] setCurrentNodeGroup:root];

	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];

	/* the node that we will attempt to un group */
	SHNode* macroNode = [doc makeEmptyGroupInCurrentNodeWithName:@"myMacro"];
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"]; 	
	
	//-- add some nodes inside
	[[doc nodeGraphModel] setCurrentNodeGroup:macroNode];
	SHNode* deepNode1 = [doc makeEmptyGroupInCurrentNodeWithName:@"deepNode1"];
	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
	
	// root
	// - macroNode
	//   - deepNode1
	//	 - in
	//   - out
	// - in
	// - out
	
	[[doc nodeGraphModel] setCurrentNodeGroup:root];

	//-- get references to the children
	NSArray *nodes = [[root nodesInside] array];
	STAssertTrue([nodes count]==1, @"yay %i", [nodes count]);
	NSArray *inputs = [[root inputs] array];
	NSArray *outputs = [[root outputs] array];
	STAssertTrue([inputs count]==1, @"yay %i", [inputs count]);
	STAssertTrue([outputs count]==1, @"yay %i", [outputs count]);

	NSArray *deeperNodes = [[macroNode nodesInside] array];
	NSArray *deeperInputs = [[macroNode inputs] array];
	NSArray *deeperOutputs = [[macroNode outputs] array];
	STAssertTrue([deeperNodes count]==1, @"yay %i", [deeperNodes count]);
	STAssertTrue([deeperInputs count]==1, @"yay %i", [deeperInputs count]);
	STAssertTrue([deeperOutputs count]==1, @"yay %i", [deeperOutputs count]);

	//-- Make some connections 
	//-- add a connection inside
	[macroNode connectOutletOfAttribute:[deeperInputs objectAtIndex:0]  toInletOfAttribute:[deeperOutputs objectAtIndex:0] undoManager:nil];
	
	SHInterConnector *deepIC1 = [[[macroNode shInterConnectorsInside] array] objectAtIndex:0];
	STAssertNotNil(deepIC1, @"cheeky");
	SHConnectlet *inCon = [deepIC1 inSHConnectlet];
	SHConnectlet *outCon = [deepIC1 outSHConnectlet];
	
	//-- add a couple of connections outside to inside
	[root connectOutletOfAttribute:[inputs objectAtIndex:0] toInletOfAttribute:[deeperInputs objectAtIndex:0] undoManager:nil];
	[root connectOutletOfAttribute:[deeperOutputs objectAtIndex:0] toInletOfAttribute:[outputs objectAtIndex:0] undoManager:nil];

	NSArray *ics = [[root shInterConnectorsInside] array];
	NSArray *deeperOConnectors = [[macroNode shInterConnectorsInside] array];	
	STAssertTrue([ics count]==2, @"yay %i", [ics count]);
	STAssertTrue([deeperOConnectors count]==1, @"yay %i", [deeperOConnectors count]);
	
	[[doc nodeGraphModel] setCurrentNodeGroup:root];
	[doc deSelectAllChildrenInCurrentNode];
	[root addChildToSelection:macroNode];
	
	/* Do the ungroup */
	[um beginUndoGrouping];
	//-- some connections not being made? Count em…
		[doc unGroupNode:macroNode];
	[um endUndoGrouping];

	nodes = [[root nodesInside] array];
	STAssertTrue([nodes count]==1, @"yay %i", [nodes count]);
	STAssertTrue([nodes objectAtIndex:0]==deepNode1, @"yay");

	inputs = [[root inputs] array];
	STAssertTrue([inputs count]==2, @"yay %i", [inputs count]);

	outputs = [[root outputs] array];
	STAssertTrue([outputs count]==2, @"yay %i", [outputs count]);

	ics = [[root shInterConnectorsInside] array];
	STAssertTrue([ics count]==3, @"yay %i", [ics count]);
	//-- check the connectOrder
	SHInterConnector *shallowIC1 = [ics objectAtIndex:0];
	SHInterConnector *shallowIC2 = [ics objectAtIndex:1];
	SHInterConnector *shallowIC3 = [ics objectAtIndex:2];
	
	SHConnectlet *inConCheck1 = [shallowIC1 inSHConnectlet];
	SHConnectlet *outConCheck1 = [shallowIC1 outSHConnectlet];
	SHConnectlet *inConCheck2 = [shallowIC2 inSHConnectlet];
	SHConnectlet *outConCheck2 = [shallowIC2 outSHConnectlet];
	SHConnectlet *inConCheck3 = [shallowIC3 inSHConnectlet];
	SHConnectlet *outConCheck3 = [shallowIC3 outSHConnectlet];
	
	/* Order of ic's isnt preserved */
	if(inCon==inConCheck1)
		STAssertTrue(outCon==outConCheck1, @"Must have made a connection the wrong way round");
	else if(inCon==inConCheck2)
		STAssertTrue(outCon==outConCheck2, @"Must have made a connection the wrong way round");
	else if(inCon==inConCheck3)
		STAssertTrue(outCon==outConCheck3, @"Must have made a connection the wrong way round");
	else
		STFail(@"Connector must have been wired up wrong in ungroup");

	
	//-- test undo and redo
	
	[um undo];
	//-- it should be like the ungroup never happened
	NSArray *nodes2 = [[root nodesInside] array];
	STAssertTrue([nodes2 count]==1, @"yay %i", [nodes2 count]);
	NSArray *inputs2 = [[root inputs] array];
	NSArray *outputs2 = [[root outputs] array];
	STAssertTrue([inputs2 count]==1, @"yay %i", [inputs2 count]);
	STAssertTrue([outputs2 count]==1, @"yay %i", [outputs2 count]);
	STAssertTrue([nodes2 objectAtIndex:0]==macroNode, @"yay" );
	SHNode* macroNode2 = [nodes2 objectAtIndex:0];
	NSArray *deeperNodes2 = [[macroNode2 nodesInside] array];
	NSArray *deeperInputs2 = [[macroNode2 inputs] array];
	NSArray *deeperOutputs2 = [[macroNode2 outputs] array];
	STAssertTrue([deeperNodes2 count]==1, @"yay %i", [deeperNodes2 count]);
	STAssertTrue([deeperInputs2 count]==1, @"yay %i", [deeperInputs2 count]);
	STAssertTrue([deeperOutputs2 count]==1, @"yay %i", [deeperOutputs2 count]);
		NSArray *ics2 = [[root shInterConnectorsInside] array];
		NSArray *deeperOConnectors2 = [[macroNode2 shInterConnectorsInside] array];	
		STAssertTrue([ics2 count]==2, @"yay %i", [ics2 count]);
		STAssertTrue([deeperOConnectors2 count]==1, @"yay %i", [deeperOConnectors2 count]);
	
	[um redo];
	//-- we should be in the same state as ungrouping
	NSArray *nodes3 = [[root nodesInside] array];
	STAssertTrue([nodes3 count]==1, @"yay %i", [nodes3 count]);
	STAssertTrue([nodes3 objectAtIndex:0]==deepNode1, @"yay");

	NSArray *inputs3 = [[root inputs] array];
	STAssertTrue([inputs3 count]==2, @"yay %i", [inputs3 count]);

	NSArray *outputs3 = [[root outputs] array];
	STAssertTrue([outputs3 count]==2, @"yay %i", [outputs3 count]);

	NSArray *ics3 = [[root shInterConnectorsInside] array];
	STAssertTrue([ics3 count]==3, @"yay %i", [ics3 count]);
	
	
	[um undo];
	//-- it should be like the ungroup never happened
	NSArray *nodes4 = [[root nodesInside] array];
	STAssertTrue([nodes4 count]==1, @"yay %i", [nodes4 count]);
	NSArray *inputs4 = [[root inputs] array];
	NSArray *outputs4 = [[root outputs] array];
	STAssertTrue([inputs4 count]==1, @"yay %i", [inputs4 count]);
	STAssertTrue([outputs4 count]==1, @"yay %i", [outputs4 count]);
	NSArray *deeperNodes4 = [[macroNode nodesInside] array];
	NSArray *deeperInputs4 = [[macroNode inputs] array];
	NSArray *deeperOutputs4 = [[macroNode outputs] array];
	STAssertTrue([deeperNodes4 count]==1, @"yay %i", [deeperNodes4 count]);
	STAssertTrue([deeperInputs4 count]==1, @"yay %i", [deeperInputs4 count]);
	STAssertTrue([deeperOutputs4 count]==1, @"yay %i", [deeperOutputs4 count]);
}

- (void)testMoveChildrenToInsertionIndexShouldCopy {
	// - (void)moveChildren:(NSArray *)obsToDrag toInsertionIndex:(NSUInteger)row shouldCopy:(BOOL)wasAltPressed
	
	[doc selectAllChildrenInCurrentNode];
	[doc deleteSelectedChildrenFromCurrentNode];
	
	SHNode *newNode1 = [doc makeEmptyGroupInCurrentNodeWithName:@"nodeToGroup_1"];
	SHNode *newNode2 = [doc makeEmptyGroupInCurrentNodeWithName:@"nodeToGroup_2"];
	SHNode *newNode3 = [doc makeEmptyGroupInCurrentNodeWithName:@"nodeToGroup_3"];

	[doc moveChildren:[NSArray arrayWithObjects:newNode1,newNode3,nil] toInsertionIndex:3 shouldCopy:NO];
	SHNode *currentNodeGroup = [doc.nodeGraphModel currentNodeGroup];
	NSArray *nodes1 = [[currentNodeGroup nodesInside] array];
	STAssertTrue([nodes1 objectAtIndex:0]==newNode2, @"fail" );
	STAssertTrue([nodes1 objectAtIndex:1]==newNode1, @"fail" );
	STAssertTrue([nodes1 objectAtIndex:2]==newNode3, @"fail" );
	
	[doc moveChildren:[NSArray arrayWithObjects:newNode1,newNode3,nil] toInsertionIndex:0 shouldCopy:YES];
	NSArray *nodes2 = [[currentNodeGroup nodesInside] array];
	STAssertTrue(5==[nodes2 count], @"fail %i", [nodes2 count]);
	STAssertTrue([nodes2 objectAtIndex:2]==newNode2, @"fail" );
	STAssertTrue([nodes2 objectAtIndex:3]==newNode1, @"fail" );
	STAssertTrue([nodes2 objectAtIndex:4]==newNode3, @"fail" );
}

@end
