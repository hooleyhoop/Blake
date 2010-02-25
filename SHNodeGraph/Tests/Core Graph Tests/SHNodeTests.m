//
//  SHNodeTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright (c) 2006 HooleyHoop. All rights reserved.
//
#import <SHNodeGraph/SHNodeGraph.h>
#import <SHNodeGraph/SHInputAttribute.h>
#import <SHNodeGraph/SHOutputAttribute.h>
#import <SHNodeGraph/SHConnectableNode.h>

//!Alert-putback!#import "SHNodeAttributeMethods.h"
//!Alert-putback!#import "SH_Path.h"
//!Alert-putback!#import "SHConnectlet.h"
//!Alert-putback!#import "SHInterConnector.h"
//!Alert-putback!#import "SHCustomMutableArray.h"


@protocol DufusProtocol
@end
@interface DufusChild : SHNode <DufusProtocol> {
}
@end
@implementation DufusChild
@end

@interface SHNodeTests : SenTestCase {
	
    SHNodeGraphModel	*_nodeGraphModel;
	NSUndoManager		*_um;
	
	/* Experimental ArrayController binding tests */
	id					testSHNode;
}

@property (assign, nonatomic) id testSHNode;

@end

static int _numberOfNotificationsReceived, _nodeAddedNotifications, _selectionChangedCount, _interConnectorsChanged, inputsChangedCount=0, outputsChangedCount=0;
static BOOL _allChildrenDidChange;

/*
 *
*/
@implementation SHNodeTests


@synthesize testSHNode;

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
	
    if( [cntxt isEqualToString:@"SHNodeTests"] )
	{
		if ([keyPath isEqualToString:@"testSHNode.allChildren"]) {
			_allChildrenDidChange = YES;
		} else
		if ([keyPath isEqual:@"nodesInside.selection"]) {
			_selectionChangedCount++;
		} else
		if ([keyPath isEqual:@"nodesInside"] ) {
			_nodeAddedNotifications++;
		} else if ([keyPath isEqual:@"rootNodeGroup.shInterConnectorsInside"]) {
			_interConnectorsChanged++;
		} else if ([keyPath isEqual:@"rootNodeGroup.allChildren"]) {
			_nodeAddedNotifications++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.inputs"]){
			inputsChangedCount++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.outputs"]){
			outputsChangedCount++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.nodesInside"]){
			_nodeAddedNotifications++;
		} else {
			[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	}
}

- (void)setUp {

    _nodeGraphModel =  [[SHNodeGraphModel makeEmptyModel] retain];
	_um = [[NSUndoManager alloc] init];
	[_um setGroupsByEvent:NO];

	STAssertNotNil(_nodeGraphModel, @"SHNodeTest ERROR.. Couldnt make a nodeModel");
}

- (void)tearDown {

//!Alert-putback!	[_um setGroupsByEvent:YES];
	[_um removeAllActions];
	[_um release];
	
	[_nodeGraphModel release];
}

//- (void)resetNotificationCounts {
//	
//	nodeGuiMayNeedRebuildingCount = 0;
//}

//- (void)didWeReceiveANotification:(NSNotification *)note {
//	
//	nodeGuiMayNeedRebuildingCount++;
//}

#pragma mark -
#pragma mark SHOULD NOT HAVE UNDO REDO methods


#pragma mark -
#pragma mark -
#pragma mark WITH UNDO methods
//!Alert-putback!
//- (void)testAddChildNodeForKeyAtIndexAutoRename {
//	
//	// - (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode forKey:(NSString *)aKey atIndex:(unsigned int)ind autoRename:(BOOL)renameFlag;
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	
//	[root addObserver:self forKeyPath:@"nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
//	[root addObserver:self forKeyPath:@"nodesInside" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
//	
//	SHNode* childnode1 = [SHNode makeChildWithName:@"n1"], *childnode2 = [SHNode makeChildWithName:@"n1"], *childnode3 = [SHNode makeChildWithName:@"n1"], *childnode4 = [SHNode makeChildWithName:@"n1"];
//
//	[root addChild:childnode1 forKey:@"Transvania" atIndex:0 autoRename:YES];
//	[root addChild:childnode2 forKey:@"Transvania" atIndex:1 autoRename:YES];
//	[root addChild:childnode3 forKey:@"Transvania33" atIndex:2 autoRename:YES];
//	[self resetObservers];
//    
//    [_um beginUndoGrouping];
//        [root addChild:childnode4 forKey:@"Transvania" atIndex:1 autoRename:YES];
//	[_um endUndoGrouping];
//
//	// check nodes were renamed correctly
//	STAssertTrue( [[root nodesInside] count]==4, @"what happened?");
//	STAssertTrue( [root childWithKey:@"Transvania"]==childnode1, @"what happened?");
//	STAssertTrue( [root childWithKey:@"Transvania33"]==childnode3, @"what happened?");
//
//	// check nodes were added in correct order
//	STAssertTrue( [root nodeAtIndex:0]==childnode1, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:1]==childnode4, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:2]==childnode2, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:3]==childnode3, @"what happened?");
//
//	// hooleyhoop
//	/* Test correct notifications were received */
//	STAssertTrue( _numberOfNotificationsReceived==1, @"what happened? %i", _numberOfNotificationsReceived);
//	STAssertTrue( _nodeAddedNotifications==1, @"what happened? %i", _nodeAddedNotifications);
//	STAssertTrue( _selectionChangedCount==0, @"what happened? %i", _selectionChangedCount);
//	/* Test Undo and redo */
//	[_um undo];
//	STAssertTrue( [[root nodesInside] count]==3, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:0]==childnode1, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:1]==childnode2, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:2]==childnode3, @"what happened?");
//	
//	[_um redo];
//	STAssertTrue( [[root nodesInside] count]==4, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:0]==childnode1, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:1]==childnode4, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:2]==childnode2, @"what happened?");
//	STAssertTrue( [root nodeAtIndex:3]==childnode3, @"what happened?");
//	
//    [root removeObserver:self forKeyPath:@"nodesInside.selection"];
//    [root removeObserver:self forKeyPath:@"nodesInside"];
//}

//!Alert-putback!
//- (void)testAddChildNodeForKeyAutoRename {
//	
//	// - (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode forKey:(NSString*)aKey autoRename:(BOOL)renameFlag
//	
//	//-- observe all items
//	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.allChildren" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
//	
//	[self resetObservers];
//	SHNode* root = [_nodeGraphModel rootNodeGroup];	
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	[root addChild:childnode forKey:@"Transvania" autoRename:YES];
//	STAssertTrue( [root childWithKey:@"Transvania"]==childnode, @"what happened?");
//	
//	STAssertTrue(_nodeAddedNotifications==1, @"received incorrect number of notifications %i", _nodeAddedNotifications);
//
//	[_um undo];
//	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);
//
//	[_um redo];
//	STAssertTrue(_nodeAddedNotifications==3, @"received incorrect number of notifications %i", _nodeAddedNotifications);
//
//	// -- remove observer
//	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.allChildren"];
//}


- (void)testAddChildAtIndexAutoRename {
	// - (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode atIndex:(NSInteger)ind autoRename:(BOOL)renameFlag
	
	//-- observe all items
//!Alert-putback!	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.allChildren" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode makeChildWithName:@"Transvania"];
	[root addChild:childnode atIndex:0 autoRename:YES undoManager:nil];
	STAssertTrue( [root childWithKey:@"Transvania"]==childnode, @"what happened?");
//!Alert-putback!	STAssertTrue(_nodeAddedNotifications==1, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	
//!Alert-putback!	[_um undo];
//!Alert-putback!	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	
//!Alert-putback!	[_um redo];
//!Alert-putback!	STAssertTrue(_nodeAddedNotifications==3, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	
	// -- remove observer
//!Alert-putback!	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.allChildren"];
}


- (void)testAddChildAutoRename {
	// - (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode autoRename:(BOOL)renameFlag
	
	//-- observe all items
//!Alert-putback!	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.allChildren" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
	
	// - (BOOL)addChild:(id<SHNodeLikeProtocol>)aNode autoRename:(BOOL)renameFlag;
	[self resetObservers];
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHNode* child = [SHNode makeChildWithName:@"n1"];
	[root addChild:child undoManager:nil];
	STAssertEquals(1, (int)[root countOfChildren], @"Number ofchild nodes should be 1, but was %d instead!", [root countOfChildren]);
//!Alert-putback!	STAssertTrue(_nodeAddedNotifications==1, @"received incorrect number of notifications %i", _nodeAddedNotifications);

	// test adding an input attribute
	SHInputAttribute* child1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	[root addChild:child1 undoManager:nil];
	STAssertEquals(2, (int)[root countOfChildren], @"Number ofchild nodes should be 2, but was %d instead!", [root countOfChildren]);
	STAssertEquals(1, (int)[[root inputs] count], @"Number inputs should be 1, but was %d instead!", [[root inputs] count]);
//!Alert-putback!	STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);

	// test adding a node to itself
	BOOL flag1 = [child addChild:child undoManager:nil];
	STAssertFalse(flag1, @"cant add a node to itself");
	BOOL flag2 = [child addChild:root undoManager:nil];
	STAssertFalse(flag2, @"Doesnt make any sense");
//!Alert-putback!		STAssertTrue(_nodeAddedNotifications==2, @"received incorrect number of notifications %i", _nodeAddedNotifications);

	// test adding a node that is already the child of another node
	SHNode* child3 = [SHNode makeChildWithName:@"n3"];
	[root addChild:child3 undoManager:nil];
	BOOL flag3 = [child addChild:child3 undoManager:nil];
	STAssertFalse(flag3, @"cant add a node that already has a parent %i", flag3);
	STAssertFalse(flag2, @"cant add a child of another node");
//!Alert-putback!		STAssertTrue(_nodeAddedNotifications==3, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	
	// test adding an output attribute
	SHOutputAttribute* outChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	
	/* Test Undo */
	[_um beginUndoGrouping];
		[root addChild:outChild2 undoManager:_um];
	[_um endUndoGrouping];

	STAssertEquals(4, (int)[root countOfChildren], @"Number ofchild nodes should be 4, but was %d instead!", [root countOfChildren]);
	STAssertEquals(1, (int)[[root outputs] count], @"Number inputs should be 1, but was %d instead!", [[root outputs] count]);
//!Alert-putback!		STAssertTrue(_nodeAddedNotifications==4, @"received incorrect number of notifications %i", _nodeAddedNotifications);
	
	/* Undo */
	// [root clearRecordedHits];
	[_um undo];
	// BOOL hitRecordResult1 = [root assertRecordsIs:@"removeChildFromSelection:", @"_setSelectionForStorage:newSelection:", @"_setSelectionForStorage:newSelection:", @"_setSelectionForStorage:newSelection:", @"_setSelectionForStorage:newSelection:", @"_removeSHChild:withKey:", nil];
	// NSMutableArray *actualRecordings1 = [root recordedSelectorStrings];
	// STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
	
	STAssertEquals(3, (int)[root countOfChildren], @"Number ofchild nodes should be 3, but was %d instead!", [root countOfChildren]);
	STAssertEquals(0, (int)[[root outputs] count], @"Number inputs should be 0, but was %d instead!", [[root outputs] count]);
//!Alert-putback!		STAssertTrue(_nodeAddedNotifications==5, @"received incorrect number of notifications %i", _nodeAddedNotifications);

	// [root clearRecordedHits];
	[_um redo];
	// BOOL hitRecordResult2 = [root assertRecordsIs:@"_addSHChild:withKey:", @"_setSelectionForStorage:newSelection:", @"_setSelectionForStorage:newSelection:", @"_setSelectionForStorage:newSelection:", @"_setSelectionForStorage:newSelection:", @"addChildToSelection:", nil];
	// NSMutableArray *actualRecordings2 = [root recordedSelectorStrings];
	// STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);

	STAssertEquals(4, (int)[root countOfChildren], @"Number ofchild nodes should be 4, but was %d instead!", [root countOfChildren]);
	STAssertEquals(1, (int)[[root outputs] count], @"Number inputs should be 1, but was %d instead!", [[root outputs] count]);
//!Alert-putback!		STAssertTrue(_nodeAddedNotifications==6, @"received incorrect number of notifications %i", _nodeAddedNotifications);

	// -- remove observer
//!Alert-putback!	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.allChildren"];
}

#pragma mark -
#pragma mark -
#pragma mark SUPER *NEW* action methods
- (void)testAllChildren {
	// - (NSArray *)allChildren
	
	/* add objects */
	SHNode *root = [_nodeGraphModel rootNodeGroup];	
	SHNode *childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHInputAttribute *i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute *o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	SHInterConnector *int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1 undoManager:nil];
	STAssertNotNil(int1, @"eh");
	
	SHCustomMutableArray *allChildren = [root allChildren];
	STAssertTrue( 4==[allChildren count], @"count is %i", [allChildren count] );
	
	STAssertTrue( [allChildren objectAtIndex:0]==childnode, @"doh");
	STAssertTrue( [allChildren objectAtIndex:1]==i1, @"doh");
	STAssertTrue( [allChildren objectAtIndex:2]==o1, @"doh");
	STAssertTrue( [allChildren objectAtIndex:3]==int1, @"doh");
}

//!Alert-putback!
//- (void)testPositionsOfChildren {
//// - (NSArray *)positionsOfChildren:(NSArray *)children;
//
//	/* add objects */
//	SHNode* root = [_nodeGraphModel rootNodeGroup];	
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	[_nodeGraphModel NEW_addChild:childnode toNode:root];
//	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[_nodeGraphModel NEW_addChild:i1 toNode:root];
//	[_nodeGraphModel NEW_addChild:o1 toNode:root];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
//	STAssertNotNil(int1, @"eh");
//
//	SHNode* childnode2 = [SHNode makeChildWithName:@"n2"];
//	[_nodeGraphModel NEW_addChild:childnode2 toNode:root];
//	SHInputAttribute* i2 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* o2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[_nodeGraphModel NEW_addChild:i2 toNode:root];
//	[_nodeGraphModel NEW_addChild:o2 toNode:root];
//		
//	NSArray* allChildren = [root allChildren];
//	NSArray* positionsOfChildren = [root positionsOfChildren:allChildren];
//	STAssertTrue([positionsOfChildren count]==7, [NSString stringWithFormat:@"count is %i", [positionsOfChildren count]]);
//	
//	/* inputs outputs, nodes, connectors all have separate indexes */
//	STAssertTrue( [[positionsOfChildren objectAtIndex:0] intValue]==0, [NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:0] intValue]]);	// node 1
//	STAssertTrue( [[positionsOfChildren objectAtIndex:1] intValue]==1, [NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:1] intValue]] );	// node 2
//
//	STAssertTrue( [[positionsOfChildren objectAtIndex:2] intValue]==0, [NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:2] intValue]] );	// input 1
//	STAssertTrue( [[positionsOfChildren objectAtIndex:3] intValue]==1, [NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:3] intValue]] );	// input 2
//	
//	STAssertTrue( [[positionsOfChildren objectAtIndex:4] intValue]==0, [NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:4] intValue]] );	// output 1
//	STAssertTrue( [[positionsOfChildren objectAtIndex:5] intValue]==1, [NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:5] intValue]] );	// output 2
//	
//	STAssertTrue( [[positionsOfChildren objectAtIndex:6] intValue]==0,[NSString stringWithFormat:@"count is %i", [[positionsOfChildren objectAtIndex:6] intValue]] );	// connector 1
//}


- (void)testChildAtIndex {

	// - (id)nodeAtIndex:(int)index
	// - (id)inputAtIndex:(int)index
	// - (id)outputAtIndex:(int)index 
	// - (id)connectorAtIndex:(int)index 
	// - (id)childAtIndex:(int)index
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHOutputAttribute* atChild1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* atChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[root addChild:atChild1 undoManager:nil];
	[root addChild:atChild2 undoManager:nil];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1 undoManager:nil];
	SHNode* childnode2 = [SHNode makeChildWithName:@"n2"];
	[_nodeGraphModel NEW_addChild:childnode2 toNode:root];
	SHInputAttribute* i2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i2 toNode:root];
	[_nodeGraphModel NEW_addChild:o2 toNode:root];
	
	STAssertTrue(childnode2==[root nodeAtIndex:1], @"should be equal");
	STAssertTrue(int1==(SHInterConnector *)[root connectorAtIndex:0], @"should be equal");
	STAssertTrue(i2==[root inputAtIndex:1], @"should be equal");
	STAssertTrue(atChild2==[root outputAtIndex:1], @"should be equal");
	
	STAssertTrue(childnode2==[root childAtIndex:1], @"should be equal");
	STAssertTrue(i2==[root childAtIndex:3], @"should be equal");
	STAssertTrue(atChild2==[root childAtIndex:5], @"should be equal");
	STAssertTrue(int1==[root childAtIndex:8], @"should be equal");
	
	STAssertThrows([root childAtIndex:81], @"should do");
}


#pragma mark old action methods
//!Alert-putback!
//- (void) testInitWithParentNodeGroup
//{
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHNode* child = [SHNode makeChildWithName:@"n1"];
//	[root addChild:child undoManager:nil];
//	STAssertNotNil(child, @"SHNodeTests ERROR.. Couldnt init a child node");
//	STAssertEqualObjects(root, [child parentSHNode], @"SHNodeTests testInitWithParentNodeGroup has failed somehow");
//}

//!Alert-putback!
//- (void)testNextUniqueChildNameBasedOn 
//{
//	// - (NSString*)nextUniqueChildNameBasedOn:(NSString *)aName;
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHNode* child = [SHNode makeChildWithName:@"n1"];
//	[root addChild:child undoManager:nil];
//	[child setName:@"steve"];
//	STAssertTrue([[root nextUniqueChildNameBasedOn:@"steve"] isEqualToString:@"steve1"], @"testNextUniqueChildNameBasedOn failed");
//}


//- (void)testPostNodeGuiMayNeedRebuildingNotification
//{
//	// basically you have to redo this evrytime current nodegroup changes
//	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//
//	//15/11/05	[nc addObserver: self selector:@selector(receiveSelectedNodesChangedNotification:) name:@"SHSelectedNodeIndexesChanged" object: _currentNodeGroup ];
//	[nc addObserver:self selector:@selector(didWeReceiveANotification:) name:@"nodeGuiMayNeedRebuilding" object: root ];
//	
//	[self resetNotificationCounts];
//	
//	/* Any objects that register for notifications MUST remove themselves before the object is released! */
//	[root performSelectorOnMainThread:@selector(postNodeGuiMayNeedRebuilding_Notification) withObject:nil waitUntilDone:NO];
//
//	/* Notifications are queued - not sent immediately: how do we test? */
//	STAssertTrue( nodeGuiMayNeedRebuildingCount==1, @"didn't get correct notifications, %i", nodeGuiMayNeedRebuildingCount );
//	
//	[nc removeObserver:self name:@"nodeGuiMayNeedRebuilding" object:root];
//}

//- (void)updateNodeGUI:(NSNotification*) note
//{
//	SHNode* aNode = [note object];
//	logInfo(@"shnode testPostNodeGuiMayNeedRebuildingNotification.m: woaah, received notification a ok");
//	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//	[nc removeObserver:self];
//}

#pragma mark connection tests


//!Alert-putback!
//- (void)testAllConnectectionsToChild
//{
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
//	SHInputAttribute* atChild2 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:node1 undoManager:nil];
//	[node1 addChild:atChild2 undoManager:nil];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:atChild2];
//	STAssertNotNil(int1, @"eh");
//
//	NSMutableArray* allICs = [root allConnectionsToChild:node1];
//	
//	STAssertNotNil(allICs, @"failed to get all interconnectors");
//	STAssertTrue([allICs count]==1, @"failed to get all interconnectors");
//}

//!Alert-putback! -- use deleteChild undoManager:
//- (void)testDeleteChildInterConnector {
//	// - (BOOL)deleteChildInterConnector:(SHInterConnector *)connectorToDelete
//	
//	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.shInterConnectorsInside" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
//	[self resetObservers];
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//
//	// test1 - input to output
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1];
//	STAssertTrue(_interConnectorsChanged==1, @"received incorrect number of notifications %i", _interConnectorsChanged);
//
//	//	check that the interconnector is in root
//	BOOL flag = [root deleteChildInterConnector:int1];
//	STAssertTrue( flag, @"DELETE interconnector failed");
//	STAssertTrue(_interConnectorsChanged==2, @"received incorrect number of notifications %i", _interConnectorsChanged);
//
//	flag = [root deleteChildInterConnector:int1];
//	STAssertFalse( flag, @"DELETE interconnector should have failed");
//	STAssertTrue(_interConnectorsChanged==2, @"received incorrect number of notifications %i", _interConnectorsChanged);
//
//	// -- remove observer
//	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.shInterConnectorsInside"];
//}



//!Alert-putback!
//- (void)testNodesAndAttributesInside
//{
//	// - (NSArray *)nodesAndAttributesInside
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	// test1 - input to output
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:outAtt1 undoManager:nil];
//	[root addChild:inAtt1 undoManager:nil];
//
//	SHInterConnector* int1 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1];
//	STAssertNotNil(int1, @"eh");
//	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
//	[root addChild:node1 undoManager:nil];
//	SHNode* node2 = [SHNode makeChildWithName:@"n1"];
//	[root addChild:node2 undoManager:nil];
//
//	NSArray* nodesAndAttributesInside = [root nodesAndAttributesInside];
//	// test order - nodes, inputs, outputs
//	STAssertTrue([nodesAndAttributesInside objectAtIndex:0]==node1, @"nodesAndAttributesInside failed");
//	STAssertTrue([nodesAndAttributesInside objectAtIndex:1]==node2, @"nodesAndAttributesInside failed");
//	STAssertTrue([nodesAndAttributesInside objectAtIndex:2]==inAtt1, @"nodesAndAttributesInside failed");
//	STAssertTrue([nodesAndAttributesInside objectAtIndex:3]==outAtt1, @"nodesAndAttributesInside failed");
//}


#pragma mark selection tests

//!Alert-putback!
//- (void)testDeleteSelectedChildren {
//	// - (void)deleteSelectedChildren
//
//	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.allChildren" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	[root addChildToSelection:inAtt1];
//	[self resetObservers];
//
//	[root deleteSelectedChildren];
//	NSArray* selected = [root selectedChildren];
//	STAssertTrue([selected count]==0, @"testDeleteSelectedChildren failed");
//	STAssertTrue([[root allChildren] count]==1, @"testDeleteSelectedChildren failed");
//	STAssertTrue(_nodeAddedNotifications==1, @"received incorrect number of notifications %i", _nodeAddedNotifications);
//
//	// -- remove observer
//	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.allChildren"];
//}

//- (void)testDeleteSelectedInterConnectors {
//
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	// test1 - input to output
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1];
//	// test1 - input to nested input
//	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
//	[root addChild:node1 undoManager:nil];
//	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	[node1 addChild:atChild3 undoManager:nil];
//	SHInterConnector* int2 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:atChild3];
//	[root unSelectAllChildren];
//	//[root addChildToSelection:int1];
//	[root addChildToSelection:int2];	
//	//	check that the interconnector is in root
//	SHOrderedDictionary* childInterConnectors = [root shInterConnectorsInside];
//	[root deleteSelectedInterConnectors];
//	STAssertTrue([childInterConnectors count]==1, @"testDeleteSelectedInterConnectors failed");	
//	id inter = [childInterConnectors objectAtIndex:0];
//	STAssertTrue(inter==int1, @"testDeleteSelectedInterConnectors failed");	
//}


//- (void)testSelectedNodeAndAttributeIndexes
//{
//	// - (NSMutableIndexSet *)selectedNodeAndAttributeIndexes
//
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	[root addChildToSelection:inAtt1];
//	[root addChildToSelection:outAtt1];
//	NSMutableIndexSet* selectedNodeIndexes = [root selectedNodeAndAttributeIndexes];
//	STAssertTrue([selectedNodeIndexes count]==2, [NSString stringWithFormat:@"is %i", [selectedNodeIndexes count]]);
//	[root removeChildFromSelection:inAtt1];
//	selectedNodeIndexes = [root selectedNodeAndAttributeIndexes];
//	STAssertTrue([selectedNodeIndexes count]==1, @"testSelectedNodeIndexes failed");
//	NSArray* allNodes = [root nodesAndAttributesInside];
//	int indexOfSelectedNode = [selectedNodeIndexes firstIndex];
//	id selectedNode = [allNodes objectAtIndex:indexOfSelectedNode];
//	STAssertEqualObjects(selectedNode, outAtt1, @"testSelectedNodeIndexes failed");
//}


//- (void)testSetSelectedNodeAndAttributeIndexes
//{
//	// - (void)setSelectedNodeAndAttributeIndexes:(NSMutableIndexSet *)value
//
//	// add two interconnectors
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	// test1 - input to output
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1];
//	STAssertNotNil(int1, @"eh");
//
//	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
//	[root addChild:node1 undoManager:nil];
//	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	[node1 addChild:atChild3 undoManager:nil];
//	SHInterConnector* int2 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:atChild3];
//	STAssertNotNil(int2, @"eh");
//
//	[root unSelectAllChildren];
//	
//	NSMutableIndexSet* selectedNodeIndexes = [NSMutableIndexSet indexSetWithIndex:0];
//	[selectedNodeIndexes addIndex:1];
//	[root setSelectedNodeAndAttributeIndexes:selectedNodeIndexes];
//	NSArray* selected = [root selectedChildNodesAndAttributes];
//	STAssertTrue([selected count]==2, @"testsetSelectedNodeAndAttributeIndexes failed");
//}

//!Alert-putback!
//- (void)testSelectedInterConnectorIndexes {
//
//	// - (NSMutableIndexSet *)selectedInterConnectorIndexes
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	SHInputAttribute* atChild3 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	[root addChild:atChild3 undoManager:nil];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:outAtt1];
//	SHInterConnector* int2 = [root connectOutletOfAttribute:inAtt1 toInletOfAttribute:atChild3];
//	SHInterConnector* int3 = [root connectOutletOfAttribute:outAtt1 toInletOfAttribute:inAtt1];
//	[root unSelectAllChildren];
//	STAssertNotNil(int3, @"eh");
//
//	// select int2
//	[root addChildToSelection:int2];
//	NSMutableIndexSet *selICs = [root selectedInterConnectorIndexes];
//	STAssertTrue([selICs count]==1, @"er");
//	STAssertTrue([selICs firstIndex]==1, @"er");
//	
//	[root addChildToSelection:int1];
//	selICs = [root selectedInterConnectorIndexes];
//	STAssertTrue([selICs count]==2, @"er");
//	STAssertTrue([selICs firstIndex]==0, @"er");
//	
//	[root removeChildFromSelection:int1];
//	selICs = [root selectedInterConnectorIndexes];
//	STAssertTrue([selICs count]==1, @"er");
//	STAssertTrue([selICs firstIndex]==1, @"er");
//}

//!Alert-putback!
//- (void)testSelectedInputIndexes {
//
//	// - (NSMutableIndexSet *)selectedInputIndexes
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHInputAttribute* inAtt1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* outAtt1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	SHInputAttribute* atChild3 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:inAtt1 undoManager:nil];
//	[root addChild:outAtt1 undoManager:nil];
//	[root addChild:atChild3 undoManager:nil];
//	[root addChildToSelection:inAtt1];
//	[root addChildToSelection:outAtt1];
//	NSMutableIndexSet* selectedInputIndexes = [root selectedInputIndexes];
//	STAssertTrue([selectedInputIndexes count]==1, [NSString stringWithFormat:@"is %i", [selectedInputIndexes count]]);
//	
//	int indexOfSelectedNode = [selectedInputIndexes firstIndex];
//	SHOrderedDictionary* allInputs = [root inputs];
//	id selectedNode = [allInputs objectAtIndex:indexOfSelectedNode];
//	STAssertEqualObjects(selectedNode, inAtt1, @"testselectedInputIndexes failed");
//	
//	[root removeChildFromSelection:inAtt1];
//	selectedInputIndexes = [root selectedInputIndexes];
//	STAssertTrue([selectedInputIndexes count]==0, @"testselectedInputIndexes failed");
//}

//!Alert-putback!
//- (void)testSelectedOutputIndexes {
//
//// - (NSMutableIndexSet *)selectedOutputIndexes
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHOutputAttribute* atChild1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	SHInputAttribute* atChild2 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* atChild3 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:atChild1 undoManager:nil];
//	[root addChild:atChild2 undoManager:nil];
//	[root addChild:atChild3 undoManager:nil];
//	[root unSelectAllChildren];
//
//	[root addChildToSelection:atChild1];
//	[root addChildToSelection:atChild2];
//
//	NSMutableIndexSet* selectedOutputIndexes = [root selectedOutputIndexes];
//	STAssertTrue([selectedOutputIndexes count]==1, [NSString stringWithFormat:@"is %i", [selectedOutputIndexes count]]);
//	
//	int indexOfSelectedNode = [selectedOutputIndexes firstIndex];
//	SHOrderedDictionary* allOutputs = [root outputs];
//	id selectedNode = [allOutputs objectAtIndex:indexOfSelectedNode];
//	STAssertEqualObjects(selectedNode, atChild1, @"testselectedInputIndexes failed");
//	
//	[root removeChildFromSelection:atChild1];
//	selectedOutputIndexes = [root selectedOutputIndexes];
//	STAssertTrue([selectedOutputIndexes count]==0, @"testselectedInputIndexes failed");
//}

//!Alert-putback!
//- (void)testAllChildrenSelectedIndexes {
//	// - (NSMutableIndexSet *)allChildrenSelectedIndexes;
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	[_nodeGraphModel NEW_addChild:childnode toNode:root];
//	SHInputAttribute* atChild1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* atChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	SHInputAttribute* atChild3 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:atChild1 undoManager:nil];
//	[root addChild:atChild2 undoManager:nil];
//	[root addChild:atChild3 undoManager:nil];
//	SHInterConnector* int1 = [root connectOutletOfAttribute:atChild1 toInletOfAttribute:atChild2];
//	[root unSelectAllChildren];
//	
//	NSMutableIndexSet* selected = [root allChildrenSelectedIndexes];
//	STAssertTrue([selected count]==0, @"testsetSelectedNodeAndAttributeIndexes failed");
//	
//	[root addChildToSelection: childnode];
//	[root addChildToSelection: atChild1];
//	[root addChildToSelection: atChild3];
//	[root addChildToSelection: int1];
//
//	selected = [root allChildrenSelectedIndexes];
//	STAssertTrue([selected count]==4, @"testsetSelectedNodeAndAttributeIndexes failed");
//	
//	NSUInteger ind1 = [selected firstIndex];
//	STAssertTrue(ind1==0, @"testsetSelectedNodeAndAttributeIndexes failed");
//	NSUInteger ind2 = [selected indexGreaterThanIndex:ind1];
//	STAssertTrue(ind2==1, @"testsetSelectedNodeAndAttributeIndexes failed");
//	NSUInteger ind3 = [selected indexGreaterThanIndex:ind2];
//	STAssertTrue(ind3==3, @"testsetSelectedNodeAndAttributeIndexes failed");
//	NSUInteger ind4 = [selected indexGreaterThanIndex:ind3];
//	STAssertTrue(ind4==4, @"testsetSelectedNodeAndAttributeIndexes failed");
//}

//!Alert-putback!
//- (void)testSetAllChildrenSelectedIndexes {
//	// - (void)setAllChildrenSelectedIndexes:(NSMutableIndexSet *)value;
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	[_nodeGraphModel NEW_addChild:childnode toNode:root];
//	SHInputAttribute* atChild1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* atChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	SHInputAttribute* atChild3 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:atChild1 undoManager:nil];
//	[root addChild:atChild2 undoManager:nil];
//	[root addChild:atChild3 undoManager:nil];
//	[root connectOutletOfAttribute:atChild1 toInletOfAttribute:atChild2];
//	[root unSelectAllChildren];
//	
//	NSMutableIndexSet* selectedNodeIndexes = [NSMutableIndexSet indexSetWithIndex:0];
//	[selectedNodeIndexes addIndex: 1];
//	[selectedNodeIndexes addIndex: 2];
//	[selectedNodeIndexes addIndex: 4];
//	[root setAllChildrenSelectedIndexes:selectedNodeIndexes];
//
//	STAssertTrue( [[[root nodesInside] selectedObjects] count] == 1, @"unok %i", [[[root nodesInside] selectedObjects] count] );
//	STAssertTrue( [[[root inputs] selectedObjects] count] == 1, @"unok %i", [[[root inputs] selectedObjects] count] );
//	STAssertTrue( [[[root outputs] selectedObjects] count] == 1, @"unok %i", [[[root outputs] selectedObjects] count] );
//	STAssertTrue( [[[root shInterConnectorsInside] selectedObjects] count] == 1, @"unok %i", [[[root shInterConnectorsInside] selectedObjects] count] );
//}

- (void)testMoveSelectedChildrenDownInExecutionOrder
{
	// IMPORTANT! Operator private members must always remain at the index they were created at or saving will fail!


//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHNode* node1 = [[SHNode makeChildWithName:@"n1"];
//	SHInputAttribute* atChild1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* atChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:node1];
//	[root addChild:atChild1];
//	[root addChild:atChild2];
//	
//	id nodes = [root nodesAndAttributesInside];
//	STAssertTrue([nodes objectAtIndex:0]==node1, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:1]==atChild1, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:2]==atChild2, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	
//	[root moveNodeDownInExecutionOrder:node1];
//	STAssertTrue([nodes objectAtIndex:0]==atChild1, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:1]==node1, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:2]==atChild2, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	
//	[root moveNodeDownInExecutionOrder:node1];
//	STAssertTrue([nodes objectAtIndex:0]==atChild1, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:1]==atChild2, @"testMoveSelectedChildrenDownInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:2]==node1, @"testMoveSelectedChildrenDownInExecutionOrder failed");	
}


- (void) testMoveSelectedChildrenUpInExecutionOrder
{
	// IMPORTANT! Operator private members must always remain at the index they were created at or saving will fail!

//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	SHNode* node1 = [[SHNode makeChildWithName:@"n1"];
//	SHInputAttribute* atChild1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* atChild2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[root addChild:node1];
//	[root addChild:atChild1];
//	[root addChild:atChild2];
//	id nodes = [root nodesAndAttributesInside];
//	[root moveNodeUpInExecutionOrder:node1];
//	STAssertTrue([nodes objectAtIndex:0]==node1, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:1]==atChild1, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:2]==atChild2, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	
//	[root moveNodeUpInExecutionOrder:atChild2];
//	STAssertTrue([nodes objectAtIndex:0]==node1, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:1]==atChild2, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:2]==atChild1, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	
//	[root moveNodeUpInExecutionOrder:atChild2];
//	STAssertTrue([nodes objectAtIndex:0]==atChild2, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:1]==node1, @"testMoveSelectedChildrenUpInExecutionOrder failed");
//	STAssertTrue([nodes objectAtIndex:2]==atChild1, @"testMoveSelectedChildrenUpInExecutionOrder failed");	
}

#pragma mark execution tests

//!Alert-putback!
//- (void)testKVO_KVC_ofAllChildrenArray {
//
//	[self addObserver:self forKeyPath:@"testSHNode.allChildren" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeTests"];
//
//	SHNode* root = [_nodeGraphModel rootNodeGroup];
//	_allChildrenDidChange = NO;
//	self.testSHNode = root;
//
//	/* because testSHNode is in the keypath the notification is triggered */
//	STAssertTrue(_allChildrenDidChange, @"we should have received a notification that allChildrenDidChange");
//	_allChildrenDidChange = NO;
//
//	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
//	[root addChild:node1 undoManager:nil];
//	STAssertTrue(_allChildrenDidChange, @"we should have received a notification that allChildrenDidChange");
//	
//	SHInputAttribute* input1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	_allChildrenDidChange = NO;
//	[root addChild:input1 undoManager:nil];
//	STAssertTrue(_allChildrenDidChange, @"we should have received a notification that allChildrenDidChange");
//
//	SHOutputAttribute* output1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	_allChildrenDidChange = NO;
//	[root addChild:output1 undoManager:nil];
//	STAssertTrue(_allChildrenDidChange, @"we should have received a notification that allChildrenDidChange");
//	
//	_allChildrenDidChange = NO;
//	SHInterConnector *ic = [root connectOutletOfAttribute:input1 toInletOfAttribute:output1];
//	STAssertNotNil(ic, @"failed to make ic");
//	STAssertTrue(_allChildrenDidChange, @"we should have received a notification that allChildrenDidChange");
//	
//	[self removeObserver:self forKeyPath:@"testSHNode.allChildren"];
//}

- (void)testDepth {
	// - (NSUInteger)depth;

	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHNode* node1 = [SHNode makeChildWithName:@"n1"];
	[root addChild:node1 undoManager:nil];
	STAssertTrue([root depth]==0, @"fuck off %i", [root depth]);
	STAssertTrue([node1 depth]==1, @"fuck off %i", [node1 depth]);
}

- (void)testDirtyBit {
	// - (BOOL)dirtyBit

	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* n1 = [SHNode makeChildWithName:@"n1"];
	SHOutputAttribute* i1 = [SHOutputAttribute makeChildWithName:@"i1"];
	SHOutputAttribute* o1 = [SHOutputAttribute makeChildWithName:@"o1"];
	[_nodeGraphModel NEW_addChild:n1 toNode:root];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
		
	STAssertFalse(root.dirtyBit, @"should be clean");
}

- (void)testNearestChildNodesSupportingProtocol {
	// - (NSArray *)nearestChildNodesSupportingProtocol:(Protocol *)value
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	

	DufusChild *ch1 = [DufusChild makeChildWithName:@"1"];
	SHNode *ch2 = [SHNode makeChildWithName:@"2"];
	DufusChild *ch3 = [DufusChild makeChildWithName:@"3"];
	SHNode *node1 = [SHNode makeChildWithName:@"1"];
	SHNode *node2 = [SHNode makeChildWithName:@"2"];
	
	[root addChild:node1 atIndex:-1 undoManager:nil];
	[root addChild:node2 atIndex:-1 undoManager:nil];
	[node1 addChild:ch1 atIndex:-1 undoManager:nil];
	[node2 addChild:ch2 atIndex:-1 undoManager:nil];
	[node2 addChild:ch3 atIndex:-1 undoManager:nil];
	
	NSArray *childrenWithProtocol = [root nearestChildNodesSupportingProtocol:@protocol(DufusProtocol)];
	STAssertTrue( [childrenWithProtocol count]==2, @"%i", [childrenWithProtocol count]);
	STAssertTrue( [childrenWithProtocol objectAtIndex:0]==ch1, @"doh");
	STAssertTrue( [childrenWithProtocol objectAtIndex:1]==ch3, @"doh");
}

- (void)testNearestParentSupportingProtocol {
	// - (SHChild *)nearestParentSupportingProtocol:(Protocol *)value {

	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	
	DufusChild *ch1 = [DufusChild makeChildWithName:@"1"];
	SHNode *ch2 = [SHNode makeChildWithName:@"2"];
	SHNode *node1 = [SHNode makeChildWithName:@"1"];
	[root addChild:ch1 atIndex:-1 undoManager:nil];
	[ch1 addChild:node1 atIndex:-1 undoManager:nil];
	[node1 addChild:ch2 atIndex:-1 undoManager:nil];
	
	NSObject<ChildAndParentProtocol> *parent1 = [ch2 nearestParentSupportingProtocol:@protocol(DufusProtocol)];
	STAssertTrue( parent1==ch1, @"doh");
	
	NSObject<ChildAndParentProtocol> *parent2 = [ch1 nearestParentSupportingProtocol:@protocol(DufusProtocol)];
	STAssertTrue( parent2==nil, @"doh");
}

- (void)testSortChildrenByType {
	// + (void)sortChildrenByType:(NSArray **)children :(NSMutableSet **)nodesSetPtr :(NSMutableSet **)inputsSetPtr :(NSMutableSet **)outputsSetPtr :(NSMutableSet **)icSetPtr
	
	SHNode *parent2 = [SHNode makeChildWithName:@"p2"];
	SHNode *parent3 = [SHNode makeChildWithName:@"p3"];
	SHInputAttribute *inAtt1 = [SHInputAttribute makeChildWithName:@"inAtt1"];
	SHInputAttribute *inAtt2 = [SHInputAttribute makeChildWithName:@"inAtt2"];
	SHOutputAttribute *outAtt1 = [SHOutputAttribute makeChildWithName:@"outAtt1"];
	SHOutputAttribute *outAtt2 = [SHOutputAttribute makeChildWithName:@"outAtt2"];
	NSArray *children = [NSArray arrayWithObjects:parent2, parent3, inAtt1, inAtt2, outAtt1, outAtt2, nil];
	
	NSMutableSet *nodesSet=nil, *inputsSet=nil, *outputsSet=nil, *icSet=nil;
	[SHNode sortChildrenByType:children :&nodesSet :&inputsSet :&outputsSet :&icSet];
	
	STAssertTrue([nodesSet count]==2, @"doh %i", [nodesSet count]);
	STAssertTrue([nodesSet containsObject:parent2], @"doh");
	STAssertTrue([nodesSet containsObject:parent3], @"doh");
	
	STAssertTrue([inputsSet count]==2, @"doh");
	STAssertTrue([inputsSet containsObject:inAtt1], @"doh");
	STAssertTrue([inputsSet containsObject:inAtt2], @"doh");
	
	STAssertTrue([outputsSet count]==2, @"doh");
	STAssertTrue([outputsSet containsObject:outAtt2], @"doh");
	STAssertTrue([outputsSet containsObject:outAtt2], @"doh");
	
	STAssertTrue([icSet count]==0, @"doh");
}
		
@end
