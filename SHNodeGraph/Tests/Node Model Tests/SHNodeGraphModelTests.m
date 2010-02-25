//
//  SHNodeGraphModelTests.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import <stdio.h>

#import <SHShared/SHShared.h>
#import <SHNodeGraph/SHNodeGraph.h>
#import "MockProcessor.h"
#import "MockProducer.h"
//!Alert-putback!#import "SHInputAttribute.h"
//!Alert-putback!#import "SHOutputAttribute.h"
#import "SHConnectableNode.h"
#import "SHNodeGraphModel.h"
#import "StubContentFilter.h"
#import "StubFilterUser.h"

#import <SenTestingKit/SenTestingKit.h>

@interface SHNodeGraphModelTests : SenTestCase {
	
    SHNodeGraphModel	*_nodeGraphModel;
	NSUndoManager		*_um;
}

@end


static NSUInteger _nodesAddedNotifications=0, _inputsAddedNotifications=0, _outputsAddedNotifications=0, _icsAddedNotifications=0;
static NSUInteger _nodesSelectionChangeCount=0, _inputsSelectionChangeCount=0, _outputsSelectionChangeCount, _icsSelectionChangeCount, currentNodeGroupChangedCount=0;
static NSUInteger _nodesInsertedKindNotifications = 0, _nodesReplacedKindNotifications = 0, _nodesChangedKindNotifications = 0, _nodesRemovalKindNotifications = 0;
static NSUInteger _inputsInsertedKindNotifications = 0, _inputsReplacedKindNotifications = 0, _inputsChangedKindNotifications = 0, _inputsRemovalKindNotifications = 0;
static NSUInteger _outputsInsertedKindNotifications = 0, _outputsReplacedKindNotifications = 0, _outputsChangedKindNotifications = 0, _outputsRemovalKindNotifications = 0;
static NSUInteger _icsInsertedKindNotifications = 0, _icsReplacedKindNotifications = 0, _icsChangedKindNotifications = 0, _icsRemovalKindNotifications = 0;

/*
 *
*/
@implementation SHNodeGraphModelTests

- (void)resetObservers {

	currentNodeGroupChangedCount = 0;
	
	/* changed property */
	_nodesAddedNotifications = 0, _inputsAddedNotifications = 0, _outputsAddedNotifications = 0, _icsAddedNotifications = 0;
	_nodesSelectionChangeCount = 0, _inputsSelectionChangeCount = 0, _outputsSelectionChangeCount = 0, _icsSelectionChangeCount = 0;

	/* change kinds */
	_nodesInsertedKindNotifications = 0, _nodesReplacedKindNotifications = 0, _nodesChangedKindNotifications = 0, _nodesRemovalKindNotifications = 0;
	_outputsInsertedKindNotifications = 0, _outputsReplacedKindNotifications = 0, _outputsChangedKindNotifications = 0, _outputsRemovalKindNotifications = 0;
	_inputsInsertedKindNotifications = 0, _inputsReplacedKindNotifications = 0, _inputsChangedKindNotifications = 0, _inputsRemovalKindNotifications = 0;
	_icsInsertedKindNotifications = 0, _icsReplacedKindNotifications = 0, _icsChangedKindNotifications = 0, _icsRemovalKindNotifications = 0;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];

	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey]; //  NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, or NSKeyValueChangeReplacement, 		
	
    if( [context isEqualToString:@"SHNodeGraphModelTests"] )
	{
		/* content change */
		if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.nodesInside.array"] ){
			_nodesAddedNotifications++;
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
					NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
					NSAssert( changeIndexes!=nil, @"need this for an insertion?");
					_nodesInsertedKindNotifications++;
					break;
				case NSKeyValueChangeReplacement:
					NSAssert( oldValueNullOrNil==NO, @"must have replaced something");
					NSAssert( newValueNullOrNil==NO, @"need this for a replacement");
					NSAssert( changeIndexes!=nil, @"need this for a replacement");
					_nodesReplacedKindNotifications++;
					break;
				case NSKeyValueChangeSetting:
					_nodesChangedKindNotifications++;
					break;
				case NSKeyValueChangeRemoval:
					NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
					NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
					NSAssert( changeIndexes!=nil, @"need this for an removal");
					_nodesRemovalKindNotifications++;
					break;
			}

		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.inputs.array"] ){
			_inputsAddedNotifications++;
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
					NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
					NSAssert( changeIndexes!=nil, @"need this for an insertion?");
					_inputsInsertedKindNotifications++;
					break;
				case NSKeyValueChangeReplacement:
					NSAssert( oldValueNullOrNil==NO, @"must have replaced something");
					NSAssert( newValueNullOrNil==NO, @"need this for a replacement");
					NSAssert( changeIndexes!=nil, @"need this for a replacement");
					_inputsReplacedKindNotifications++;
					break;
				case NSKeyValueChangeSetting:
					_inputsChangedKindNotifications++;
					break;
				case NSKeyValueChangeRemoval:
					NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
					NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
					NSAssert( changeIndexes!=nil, @"need this for an removal");
					_inputsRemovalKindNotifications++;
					break;
			}
		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.outputs.array"] ){
			_outputsAddedNotifications++;
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
					NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
					NSAssert( changeIndexes!=nil, @"need this for an insertion?");
					_outputsInsertedKindNotifications++;
					break;
				case NSKeyValueChangeReplacement:
					NSAssert( oldValueNullOrNil==NO, @"must have replaced something");
					NSAssert( newValueNullOrNil==NO, @"need this for a replacement");
					NSAssert( changeIndexes!=nil, @"need this for a replacement");
					_outputsReplacedKindNotifications++;
					break;
				case NSKeyValueChangeSetting:
					_outputsChangedKindNotifications++;
					break;
				case NSKeyValueChangeRemoval:
					NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
					NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
					NSAssert( changeIndexes!=nil, @"need this for an removal");
					_outputsRemovalKindNotifications++;
					break;
			}
		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.shInterConnectorsInside.array"] ){
			_icsAddedNotifications++;
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
					NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
					NSAssert( changeIndexes!=nil, @"need this for an insertion?");
					_icsInsertedKindNotifications++;
					break;
				case NSKeyValueChangeReplacement:
					NSAssert( oldValueNullOrNil==NO, @"must have replaced something");
					NSAssert( newValueNullOrNil==NO, @"need this for a replacement");
					NSAssert( changeIndexes!=nil, @"need this for a replacement");
					_icsReplacedKindNotifications++;
					break;
				case NSKeyValueChangeSetting:
					_icsChangedKindNotifications++;
					break;
				case NSKeyValueChangeRemoval:
					NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
					NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
					NSAssert( changeIndexes!=nil, @"need this for an removal");
					_icsRemovalKindNotifications++;
					break;
			}

		/* content selection change */
		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.nodesInside.selection"] ){
			_nodesSelectionChangeCount++;
		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.inputs.selection"] ){
			_inputsSelectionChangeCount++;
		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.outputs.selection"] ){
			_outputsSelectionChangeCount++;
		} else if( [keyPath isEqualToString:@"currentNodeGroup.childContainer.shInterConnectorsInside.selection"] ){
			_icsSelectionChangeCount++;

		/* current nodegroup */
		} else if( [keyPath isEqualToString:@"currentNodeGroup"] ){
			currentNodeGroupChangedCount++;
			
//		} else if ([keyPath isEqualToString:@"currentNodeGroup.allChildren"]) {
//			graphicsChangeCount++;
		} else {
			[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];      
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)setUp {
// - (id)initEmptyModel 

    _nodeGraphModel = [(SHNodeGraphModel *)[SHNodeGraphModel makeEmptyModel] retain];
	_um = [[_nodeGraphModel undoManager] retain];

	SHNode *root = _nodeGraphModel.rootNodeGroup;
	SHNode *current = _nodeGraphModel.currentNodeGroup;
	STAssertNotNil(_nodeGraphModel, @"SHNodeGraphModelTests ERROR.. Couldnt make a nodeModel");
	STAssertTrue(_nodeGraphModel.undoManager!=nil, @"model setup incorrectly");
//!Alert-putback!	STAssertTrue(_nodeGraphModel.savingAndLoadingDelegate!=nil, @"model setup incorrectly");
//!Alert-putback!	STAssertTrue(_nodeGraphModel.scheduler!=nil, @"model setup incorrectly");
	STAssertTrue(root==current, @"model setup incorrectly");
//!Alert-putback!	STAssertTrue(root.temporaryID>0, @"model setup incorrectly");
	STAssertTrue(root.parentSHNode==nil, @"model setup incorrectly");
	STAssertTrue(root.nodeGraphModel==_nodeGraphModel, @"model setup incorrectly");

	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.nodesInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.inputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.outputs.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.shInterConnectorsInside.array" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
	
	[self resetObservers];
}

- (void)tearDown {

	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.nodesInside.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.nodesInside.array"];
	
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.inputs.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.inputs.array"];
	
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.outputs.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.outputs.array"];
	
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.shInterConnectorsInside.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.childContainer.shInterConnectorsInside.array"];
	
	[_um setGroupsByEvent:YES];
	[_um removeAllActions];
	[_um release];
	
    [_nodeGraphModel release];
	_nodeGraphModel = nil;
}

- (void)testMoveUpAlevelToParentNodeGroup {

	// - (void)moveUpAlevelToParentNodeGroup

	SHNode* root = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"node1"];
	SHNode* child = [SHNode makeChildWithName:@"n1"];
	[root addChild:child undoManager:_um];
	[_nodeGraphModel setCurrentNodeGroup:child];
	
	[_um removeAllActions];
	
	/* Test Undo Redo */
	[_um beginUndoGrouping];
		[_nodeGraphModel moveUpAlevelToParentNodeGroup];
	[_um endUndoGrouping];
	
	SHNode* ang = [_nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang, root, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	
	// -- check undo menu title
	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo set current level"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);

	/* Undo */
	[root clearRecordedHits];
	[_um undo]; //-- move back down
	STAssertEqualObjects([_nodeGraphModel currentNodeGroup], child, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo set current level"], @"Incorrect Undo Title %@", [_um redoMenuItemTitle]);

	/* Redo */
	[root clearRecordedHits];
	[_um redo]; //-- move up
	STAssertEqualObjects([_nodeGraphModel currentNodeGroup], root, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo set current level"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);

	/* Undo */
	[root clearRecordedHits];
	[_um undo]; //-- down again
	STAssertEqualObjects([_nodeGraphModel currentNodeGroup], child, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo set current level"], @"Incorrect Undo Title %@", [_um redoMenuItemTitle]);
}


- (void)testMoveDownAlevelIntoSelectedNodeGroup {

	// - (void)moveDownALevelIntoNodeGroup:(SHNode *)aNodeGroup
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* child1 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"node1"];
	SHNode* child2 = [SHNode makeChildWithName:@"node2"];

	BOOL result = [child1 addChild:child2 undoManager:_um];
	STAssertTrue(result, @"Failed to add child");
	[_nodeGraphModel setCurrentNodeGroup:root];
	[root unSelectAllChildren];
	[root addChildToSelection: child1];

	/* Test Undo Redo */
	[_um beginUndoGrouping];
		[_nodeGraphModel moveDownALevelIntoNodeGroup:child1];
	[_um endUndoGrouping];

	SHNode* ang = [_nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(ang, child1, @"SHNodeGraphModelTests ERROR in testMoveDownAlevelIntoSelectedNodeGroup %@, %@", ang, child1);
	
	// -- check undo menu title
	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo set current level"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);
	
	/* Undo */
	[root clearRecordedHits];
	[_um undo]; //-- move back up
	STAssertEqualObjects([_nodeGraphModel currentNodeGroup], root, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo set current level"], @"Incorrect Undo Title %@", [_um redoMenuItemTitle]);

	/* Redo */
	[root clearRecordedHits];
	[_um redo]; //-- move down
	STAssertEqualObjects([_nodeGraphModel currentNodeGroup], child1, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo set current level"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);

	/* Undo */
	[root clearRecordedHits];
	[_um undo]; //-- down again
	STAssertEqualObjects([_nodeGraphModel currentNodeGroup], root, @"SHNodeGraphModelTests ERROR in testMoveUpAlevelToParentNodeGroup");
	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo set current level"], @"Incorrect Undo Title %@", [_um redoMenuItemTitle]);
}

//#pragma mark -
//#pragma mark SUPER *NEW* TEST methods
//
////NotReady- (void)testNEW_addChildrenToNodeAtIndexes {
//	// - (void)NEW_addChildren:graphics toNode:_rootNodeGroup atIndexes:indexes;
//	
////NotReady	SHNode *newGraphic1 = [[[SHNode alloc] init] autorelease];
////NotReady	[_nodeGraphModel NEW_addChild:newGraphic1 toNode:_nodeGraphModel.rootNodeGroup];
////NotReady	[_nodeGraphModel.rootNodeGroup addChildToSelection: newGraphic1];
//	
////NotReady	SHNode *newGraphic2 = [[[SHNode alloc] init] autorelease];
////NotReady	SHNode *newGraphic3 = [[[SHNode alloc] init] autorelease];
////NotReady	SHNode *newGraphic4 = [[[SHNode alloc] init] autorelease];
//
////NotReady	[self resetObservers];
////NotReady	[_nodeGraphModel NEW_addChildren:[NSArray arrayWithObjects:newGraphic2, newGraphic3, newGraphic4, nil] toNode:_nodeGraphModel.rootNodeGroup atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
//	
////NotReady	STAssertTrue([_nodeGraphModel.rootNodeGroup countOfChildren]==4, @"wrong count %i", [_nodeGraphModel.rootNodeGroup countOfChildren]);
////NotReady	STAssertTrue([_nodeGraphModel.rootNodeGroup nodeAtIndex:3]==newGraphic1, @"wrong node");
//
//	/* i guess the selection should change..? not absolutely sure.. */
////NotReady	STAssertTrue(_nodesAddedNotifications==1, @"received incorrect number of notifications %i", _nodesAddedNotifications);
////NotReady	STAssertTrue(_nodesSelectionChangeCount==1, @"received incorrect number of notifications %i", _nodesSelectionChangeCount);
////NotReady}

- (void)testNewEmptyNodeInCurrentNodeWithName {
	//- (SHNode *)makeEmptyNodeInCurrentNodeWithName:(NSString *)aName

	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* ob1 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"one"]; 
	SHNode* ob2 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"two"];
	STAssertNotNil(ob1,@"eh"); STAssertNotNil(ob2,@"eh");
	STAssertTrue(ob1!=ob2, @"SHNodeGraphModelTests making a new root returns the same object %@, %@", ob1,ob2);
	NodeName *name1 = [ob1 name];
	NodeName *name2 = [ob2 name];
	STAssertTrue([name1.value isEqualToString:@"one"], @"eh, %@", name1); 
	STAssertTrue([name2.value isEqualToString:@"two"], @"eh %@", name2);
	id ob3 = [root childWithKey:name1.value];
	id ob4 = [root childWithKey:name2.value];
	STAssertEqualObjects(ob3, ob1, @"SHNodeGraphModelTests making a root node has returned equal objects %@, %@", ob3, ob1 );
	STAssertEqualObjects(ob4, ob2, @"SHNodeGraphModelTests making a root node has returned equal objects %@, %@", ob4, ob2 );
}

//- (void)testMakeEmptyNodeInNodeWithName {
//// - (SHNode *)makeEmptyNodeInNode:(SHNode *)parentNode WithName:(NSString *)aName;
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];	
//	SHNode* ob1 = [_nodeGraphModel makeEmptyNodeInNode:root withName:@"one"]; 
//	SHNode* ob2 = [_nodeGraphModel makeEmptyNodeInNode:root withName:@"two"];
//	STAssertNotNil(ob1,@"eh"); 
//	STAssertNotNil(ob2,@"eh");
//	STAssertTrue(ob1!=ob2, @"SHNodeGraphModelTests making a new root returns the same object %@, %@", ob1,ob2);
//	id name1 = [ob1 name]; id name2 = [ob2 name];
//	STAssertTrue([name1 isEqualToString:@"one"], @"eh, %@", name1); STAssertTrue([name2 isEqualToString:@"two"], @"eh %@", name2);
//	id ob3 = [root childWithKey:name1];
//	id ob4 = [root childWithKey:name2];
//	STAssertEqualObjects(ob3, ob1, @"SHNodeGraphModelTests making a root node has returned equal objects %@, %@", ob3, ob1 );
//	STAssertEqualObjects(ob4, ob2, @"SHNodeGraphModelTests making a root node has returned equal objects %@, %@", ob4, ob2 );
//}

- (void)testNEW_addChildToNodeAtIndex {
	//- (void)NEW_addChild:(id)newchild toNode:(SHNode *)targetNode atIndex:(NSInteger)nindex

	SHNode* child2 = [SHNode makeChildWithName:@"n1"];
	SHNode* child1 = [SHNode makeChildWithName:@"n1"];
	STAssertThrows([_nodeGraphModel NEW_addChild:child1 toNode:child2 atIndex:0], @"doh");
	
	SHNode* current = [_nodeGraphModel currentNodeGroup];	
	STAssertTrue([current countOfChildren]==0, @"ERROR with children %i", [current countOfChildren]);

	/* add a group */
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:current atIndex:0];
	
	STAssertTrue(_nodesAddedNotifications==1, @"doh %i", _nodesAddedNotifications);
	STAssertTrue(_nodesInsertedKindNotifications==1, @"doh");

	/* add an attribute */
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:current atIndex:0];
	[_nodeGraphModel NEW_addChild:o1 toNode:current atIndex:0];
	
	STAssertTrue(_inputsAddedNotifications==1, @"doh %i", _inputsAddedNotifications);
	STAssertTrue(_inputsInsertedKindNotifications==1, @"doh %i", _inputsInsertedKindNotifications);
	
	STAssertTrue(_outputsAddedNotifications==1, @"doh %i", _outputsAddedNotifications);
	STAssertTrue(_outputsInsertedKindNotifications==1, @"doh %i", _outputsInsertedKindNotifications);
	
	/* add a connector */
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"e");
	STAssertTrue([current countOfChildren]==4, @"ERROR with children");
	
	STAssertTrue(_icsAddedNotifications==1, @"doh");
	STAssertTrue(_icsInsertedKindNotifications==1, @"doh");
	
	// test undo
	[_nodeGraphModel.undoManager undo];
	
	STAssertTrue([current countOfChildren]==0, @"ERROR with children %i", [current countOfChildren]);
	STAssertTrue([[current shInterConnectorsInside]count]==0, @"ERROR with children %i", [[current shInterConnectorsInside]count]);

	STAssertTrue(_nodesAddedNotifications==2, @"ERROR with children %i", _nodesAddedNotifications);
	STAssertTrue(_nodesRemovalKindNotifications==1, @"ERROR with children");
	
	STAssertTrue(_inputsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_inputsRemovalKindNotifications==1, @"ERROR with children");
	
	STAssertTrue(_outputsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_outputsRemovalKindNotifications==1, @"ERROR with children");
	
	STAssertTrue(_icsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_icsRemovalKindNotifications==1, @"ERROR with children");
}

- (void)testNEW_addChildToNode {
	//- (void)NEW_addChild:(id)newchild toNode:(SHNode *)targetNode

	SHNode* child2 = [SHNode makeChildWithName:@"n1"];
	SHNode* child1 = [SHNode makeChildWithName:@"n1"];
	STAssertThrows([_nodeGraphModel NEW_addChild:child1 toNode:child2], @"doh");

	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	STAssertTrue([root countOfChildren]==0, @"ERROR with children");

	/* add a group */
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];

	/* add an attribute */
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];

	/* add a connector */
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"e");
	STAssertTrue([root countOfChildren]==4, @"ERROR with children");
	
	// test undo
	[_nodeGraphModel.undoManager undo];
	
	STAssertTrue([root countOfChildren]==0, @"ERROR with children %i", [root countOfChildren]);
	STAssertTrue([[root shInterConnectorsInside]count]==0, @"ERROR with children %i", [[root shInterConnectorsInside]count]);
	
	STAssertTrue(_nodesAddedNotifications==2, @"ERROR with children %i", _nodesAddedNotifications);
	STAssertTrue(_nodesRemovalKindNotifications==1, @"ERROR with children");
	
	STAssertTrue(_inputsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_inputsRemovalKindNotifications==1, @"ERROR with children");
	
	STAssertTrue(_outputsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_outputsRemovalKindNotifications==1, @"ERROR with children");
	
	STAssertTrue(_icsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_icsRemovalKindNotifications==1, @"ERROR with children");
}

- (void)testNEW_addChildAtIndex {
	// - (void)NEW_addChild:(id)newchild atIndex:(NSInteger)nindex;
	
	SHNode* current = [_nodeGraphModel currentNodeGroup];
	
	/* add an attribute */
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHNode* child1 = [SHNode makeChildWithName:@"n1"];
	SHNode* child2 = [SHNode makeChildWithName:@"n2"];
	SHNode* child3 = [SHNode makeChildWithName:@"n3"];
	[_nodeGraphModel NEW_addChild:i1 atIndex:0];
	[_nodeGraphModel NEW_addChild:o1 atIndex:0];
	[_nodeGraphModel NEW_addChild:child1 atIndex:0];
	[_nodeGraphModel NEW_addChild:child3 atIndex:1];
	[_nodeGraphModel NEW_addChild:child2 atIndex:2];

	STAssertTrue(_nodesAddedNotifications==3, @"ERROR with children %i", _nodesAddedNotifications);
	STAssertTrue(_nodesInsertedKindNotifications==3, @"ERROR with children %i", _nodesInsertedKindNotifications);

	/* add a connector */
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"e");
	
	STAssertTrue([current countOfChildren]==6, @"ERROR with children %i", [current countOfChildren]);
	STAssertEqualObjects([current nodeAtIndex:0], child1, @"ERROR with children");
	
	// test undo
	[_nodeGraphModel.undoManager undo];
	
	STAssertTrue([current countOfChildren]==0, @"ERROR with children %i", [current countOfChildren]);
	STAssertTrue(_nodesAddedNotifications==6, @"ERROR with children %i", _nodesAddedNotifications);
	STAssertTrue(_nodesRemovalKindNotifications==3, @"ERROR with children %i", _nodesInsertedKindNotifications);
	
	STAssertTrue(_icsAddedNotifications==2, @"ERROR with children %i", _icsAddedNotifications);
	STAssertTrue(_icsRemovalKindNotifications==1, @"ERROR with children %i", _icsRemovalKindNotifications);
}

- (void)testConnectOutletOfAttributeToInletOfAttribute {
	// - (SHInterConnector *)connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att2 {

	/* add an attribute */
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHNode* child1 = [SHNode makeChildWithName:@"n1"];
	SHNode* child2 = [SHNode makeChildWithName:@"n2"];
	SHNode* child3 = [SHNode makeChildWithName:@"n3"];
	[_nodeGraphModel NEW_addChild:i1 atIndex:0];
	[_nodeGraphModel NEW_addChild:o1 atIndex:0];
	[_nodeGraphModel NEW_addChild:child1 atIndex:0];
	[_nodeGraphModel NEW_addChild:child3 atIndex:1];
	[_nodeGraphModel NEW_addChild:child2 atIndex:2];
	
	[_nodeGraphModel.undoManager removeAllActions];
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"e");
	STAssertTrue(_icsAddedNotifications==1, @"ERROR with children %i", _icsAddedNotifications);
	STAssertTrue([[[_nodeGraphModel currentNodeGroup] shInterConnectorsInside] count]==1, @"ERROR with children %i", [[[_nodeGraphModel currentNodeGroup] shInterConnectorsInside] count]);

	[_nodeGraphModel.undoManager undo];
	STAssertTrue(_icsAddedNotifications==2, @"ERROR with children %i", _icsAddedNotifications);
	STAssertTrue([[[_nodeGraphModel currentNodeGroup] shInterConnectorsInside] count]==0, @"ERROR with children %i", [[[_nodeGraphModel currentNodeGroup] shInterConnectorsInside] count]);

	[_nodeGraphModel.undoManager redo];
	STAssertTrue(_icsAddedNotifications==3, @"ERROR with children %i", _icsAddedNotifications);
	STAssertTrue([[[_nodeGraphModel currentNodeGroup] shInterConnectorsInside] count]==1, @"ERROR with children %i", [[[_nodeGraphModel currentNodeGroup] shInterConnectorsInside] count]);
}

- (void)testInsertGraphicsAtIndexes {
	// - (void)insertGraphics:(NSArray *)graphics atIndexes:(NSIndexSet *)indexes
	
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	[_nodeGraphModel NEW_addChild:newGraphic1 toNode:_nodeGraphModel.rootNodeGroup atIndex:0];
	
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic4 = [[[MockProducer alloc] init] autorelease];
	
	[_nodeGraphModel.undoManager removeAllActions];
	[self resetObservers];
	[_nodeGraphModel insertGraphics:[NSArray arrayWithObjects:newGraphic2, newGraphic3, newGraphic4, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
	
	// if we added an array with nodes, inputs, outputs AND we were observing all Objects etc we would receive one notification for each kind.. is this something i should address????
	STAssertTrue(_nodesAddedNotifications==1, @"received incorrect number of notifications %i", _nodesAddedNotifications);
	STAssertTrue(_nodesSelectionChangeCount==0, @"received incorrect number of notifications %i", _nodesSelectionChangeCount);
	STAssertTrue(_nodesInsertedKindNotifications==1, @"ERROR with children %i", _nodesInsertedKindNotifications);
	
	// test undo
	[_nodeGraphModel.undoManager undo];
	
	STAssertTrue([_nodeGraphModel.currentNodeGroup countOfChildren]==1, @"ERROR with children");
	STAssertTrue(_nodesAddedNotifications==2, @"ERROR with children %i", _nodesAddedNotifications);
	STAssertTrue(_nodesRemovalKindNotifications==1, @"ERROR with children %i", _nodesRemovalKindNotifications);
}

#pragma mark Remove methods
- (void)testRemoveGraphicsAtIndexes {
	// - (void)removeGraphicsAtIndexes:(NSIndexSet *)indexes
	
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
	[_nodeGraphModel insertGraphics:[NSArray arrayWithObjects:newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];

	[_nodeGraphModel removeGraphicsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	
	STAssertTrue([_nodeGraphModel.currentNodeGroup.nodesInside count]==1, @"yay");
	STAssertTrue([_nodeGraphModel.currentNodeGroup.nodesInside objectAtIndex:0]==newGraphic3, @"yay");
}

- (void)testRemoveGraphicAtIndex {
	// - (void)removeGraphicAtIndex:(NSUInteger)index
	
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];

	[_nodeGraphModel NEW_addChild:newGraphic1 toNode:_nodeGraphModel.rootNodeGroup atIndex:0];
	[_nodeGraphModel NEW_addChild:newGraphic2 toNode:_nodeGraphModel.rootNodeGroup atIndex:1];
	[self resetObservers];
	[_nodeGraphModel removeGraphicAtIndex:0];
	
	STAssertTrue(_nodesAddedNotifications==1, @"received incorrect number of notifications");
	STAssertTrue(_nodesSelectionChangeCount==0, @"received incorrect number of notifications %i", _nodesSelectionChangeCount);
	
	STAssertTrue([_nodeGraphModel.currentNodeGroup.nodesInside count]==1, @"yay");
	STAssertTrue([_nodeGraphModel.currentNodeGroup.nodesInside objectAtIndex:0]==newGraphic2, @"yay");
}

// try manipulating the selection!
- (void)testChangeNodeSelectionTo {
	
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
	[_nodeGraphModel insertGraphics:[NSArray arrayWithObjects:newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
	
	[self resetObservers];
	[_nodeGraphModel changeNodeSelectionTo:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	
	STAssertTrue(_nodesAddedNotifications==0, @"received incorrect number of notifications %i", _nodesAddedNotifications);
	STAssertTrue(_nodesSelectionChangeCount==1, @"received incorrect number of notifications %i", _nodesSelectionChangeCount);

	// test undo - selection not undoable?
	// [_nodeGraphModel.undoManager undo];
	// STAssertTrue(_nodesSelectionChangeCount==2, @"received incorrect number of notifications %i", _nodesSelectionChangeCount);
}

- (void)testAddChildrenToCurrentSelection {
//- (void)addChildrenToCurrentSelection:(NSArray *)arrayValue
	
	/* add objects */
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:_nodeGraphModel.currentNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:_nodeGraphModel.currentNodeGroup];
	[_nodeGraphModel NEW_addChild:o1 toNode:_nodeGraphModel.currentNodeGroup];
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	
	/* select them */
	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode]];
	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObjects:i1, o1, int1, nil]];
	
	/* get the selection */
	NSArray* selectedObs = [_nodeGraphModel.currentNodeGroup selectedChildren];
	STAssertTrue([selectedObs count]==4, @"is %i", [selectedObs count]);
}

- (void)testRemoveChildrenFromCurrentSelection {
//- (void)removeChildrenFromCurrentSelection:(NSArray *)arrayValue

	/* add objects */
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:_nodeGraphModel.currentNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:_nodeGraphModel.currentNodeGroup];
	[_nodeGraphModel NEW_addChild:o1 toNode:_nodeGraphModel.currentNodeGroup];
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	
	/* select them */
	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode]];
	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObjects:i1, o1, int1, nil]];
	
	[_nodeGraphModel removeChildrenFromCurrentSelection:[NSArray arrayWithObjects: o1, int1, nil]];
	
	/* get the selection */
	NSArray* selectedObs = [_nodeGraphModel.currentNodeGroup selectedChildren];
	STAssertTrue([selectedObs count]==2, @"is %i", [selectedObs count]);
	STAssertTrue([selectedObs containsObject:childnode], @"er");
	STAssertTrue([selectedObs containsObject:i1], @"er");
}

//- (void)testAddChildrenToSelection {
//	// - (void)addChildrenToSelection:(NSArray *)arrayValue inNode:(SHNode *)node;
//
//	// - surely we can only select in the current Node? No
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];	
//	
//	/* add objects */
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	[_nodeGraphModel NEW_addChild:childnode toNode:root];
//	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[_nodeGraphModel NEW_addChild:i1 toNode:root];
//	[_nodeGraphModel NEW_addChild:o1 toNode:root];
//	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
//	
//	/* select them */
//	[_nodeGraphModel addChildrenToSelection:[NSArray arrayWithObject:childnode] inNode:root];
//	[_nodeGraphModel addChildrenToSelection:[NSArray arrayWithObjects:i1, o1, int1, nil] inNode:root];
//	
//	/* get the selection */
//	NSArray* selectedObs = [root selectedChildren];
//	STAssertTrue([selectedObs count]==4, @"is %i", [selectedObs count]);
//}

//- (void)testRemoveChildrenFromSelectionInNode {
//// - (void)removeChildrenFromSelection:(NSArray *)arrayValue inNode:(SHNode *)node;
//	
//	i think we should only manipulate selection in current node.
//	
//	SHNode* root = [_nodeGraphModel rootNodeGroup];	
//	
//	/* add objects */
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	[_nodeGraphModel NEW_addChild:childnode toNode:root];
//	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
//	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
//	[_nodeGraphModel NEW_addChild:i1 toNode:root];
//	[_nodeGraphModel NEW_addChild:o1 toNode:root];
//	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
//	
//	/* select them */
//	[_nodeGraphModel addChildrenToSelection:[NSArray arrayWithObject:childnode] inNode:root];
//	[_nodeGraphModel addChildrenToSelection:[NSArray arrayWithObjects:i1, o1, int1, nil] inNode:root];
//	
//	[_nodeGraphModel removeChildrenFromSelection:[NSArray arrayWithObjects: o1, int1, nil] inNode:root];
//	/* get the selection */
//	NSArray* selectedObs = [root selectedChildren];
//	STAssertTrue([selectedObs count]==2, @"is %i", [selectedObs count]);
//	STAssertTrue([selectedObs containsObject:childnode], @"er");
//	STAssertTrue([selectedObs containsObject:i1], @"er");
//}

- (void)testDeleteChildrenFromNode {
	// - (void)deleteChildren:(NSArray *)arrayValue fromNode:(SHNode *)node

	//-- observe all items
//	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.allChildren" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];

	SHNode* root = [_nodeGraphModel rootNodeGroup];	

	/* add objects */
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* i2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHInputAttribute* i3 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o3 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	_nodeGraphModel.currentNodeGroup = childnode;
	[_nodeGraphModel NEW_addChild:i2 toNode:childnode];
	[_nodeGraphModel NEW_addChild:o2 toNode:childnode];
	_nodeGraphModel.currentNodeGroup = root;
	[_nodeGraphModel NEW_addChild:i3 toNode:root];
	[_nodeGraphModel NEW_addChild:o3 toNode:root];
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	SHInterConnector* int2 = [_nodeGraphModel connectOutletOfAttribute:i3 toInletOfAttribute:i2];
	SHInterConnector* int3 = [_nodeGraphModel connectOutletOfAttribute:o2 toInletOfAttribute:o3];
	STAssertNotNil( int2, @"no way");
	STAssertNotNil( int3, @"no way");
	STAssertTrue( [root countOfChildren]==8, @"is %i", [root countOfChildren] );

	[self resetObservers];

	/* delete them */
	[_nodeGraphModel deleteChildren:[NSArray arrayWithObjects:childnode, o3, int1, i1, nil ] fromNode:root];
	STAssertTrue([root countOfChildren]==2, @"is %i", [root countOfChildren]);

	/* Ideally this would be one, but im not sure it is worth the extra effort at thr moment
		STAssertTrue(_nodesAddedNotifications==1, @"received incorrect number of notifications %i", _nodesAddedNotifications);
	*/
	STAssertTrue(_nodesAddedNotifications==1, @"received incorrect number of notifications %i", _nodesAddedNotifications);
	STAssertTrue(_inputsAddedNotifications==1, @"received incorrect number of notifications %i", _inputsAddedNotifications);
	STAssertTrue(_outputsAddedNotifications==1, @"received incorrect number of notifications %i", _outputsAddedNotifications);
	STAssertTrue(_icsAddedNotifications==1, @"received incorrect number of notifications %i", _icsAddedNotifications);

	STAssertTrue(_nodesSelectionChangeCount==0, @"received incorrect number of notifications %i", _nodesSelectionChangeCount);

	// -- remove observer
//	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.allChildren"];
}

//- (void)testIsEquivalentTo {
//// - (BOOL)isEquivalentTo:(SHNodeGraphModel *)value;
//
//    SHNodeGraphModel *nodeGraphModelA = _nodeGraphModel;
//    SHNodeGraphModel *nodeGraphModelB = [SHNodeGraphModel makeEmptyModel];
//
//	SHNode* rootA1 = [nodeGraphModelA rootNodeGroup];
//	STAssertNotNil(rootA1, @"err");
//
//	SHInputAttribute* Ai1 = [SHInputAttribute makeChildWithName:@"1"];
//	SHOutputAttribute* Ao1 = [SHOutputAttribute makeChildWithName:@"2"];
//	SHNode* nodeA1 = [SHNode makeChildWithName:@"level2_node1"];
//	SHNode* nodeA2 = [SHNode makeChildWithName:@"level2_node2"];
//	SHNode* nodeA3 = [SHNode makeChildWithName:@"level3_node3"];
//	[rootA1 addChild:nodeA1 undoManager:_um];
//	[rootA1 addChild:nodeA2 undoManager:_um];
//	[nodeA2 addChild:nodeA3 undoManager:_um];
//	[rootA1 addChild:Ai1 undoManager:_um];
//	[rootA1 addChild:Ao1 undoManager:_um];
//	[Ai1 setDataType:@"mockDataType"];
//	[Ao1 setDataType:@"mockDataType"];
//	SHInterConnector* intA1 = [rootA1 connectOutletOfAttribute:Ai1 toInletOfAttribute:Ao1];	
//	STAssertNotNil(intA1, @"eh");
//	SHNode* rootB1 = [nodeGraphModelB rootNodeGroup];	
//	STAssertNotNil(rootB1, @"err");
//	SHInputAttribute* Bi1 = [SHInputAttribute makeChildWithName:@"1"];
//	SHOutputAttribute* Bo1 = [SHOutputAttribute makeChildWithName:@"1"];
//	SHNode* nodeB1 = [SHNode makeChildWithName:@"level2_node1"];
//	SHNode* nodeB2 = [SHNode makeChildWithName:@"level2_node2"];
//	SHNode* nodeB3 = [SHNode makeChildWithName:@"level3_node3"];
//	[rootB1 addChild:nodeB1 undoManager:_um];
//	[rootB1 addChild:nodeB2 undoManager:_um];
//	[nodeB2 addChild:nodeB3 undoManager:_um];
//	[rootB1 addChild:Bi1 undoManager:_um];
//	[rootB1 addChild:Bo1 undoManager:_um];
//	[Bi1 setDataType:@"mockDataType"];
//	[Bo1 setDataType:@"mockDataType"];
//	SHInterConnector* intB1 = [rootB1 connectOutletOfAttribute:Bi1 toInletOfAttribute:Bo1];	
//
//	STAssertTrue([nodeGraphModelA isEquivalentTo:nodeGraphModelB], @"should be roughly the same");
//	[rootB1 deleteChild:intB1 undoManager:nil];
//	STAssertFalse([nodeGraphModelA isEquivalentTo:nodeGraphModelB], @"should not be roughly the same");
//}
//
//- (void)testUndoManager {
//	// - (SHUndoManager *)undoManager;
//	STAssertNotNil([_nodeGraphModel undoManager], @"this should be our undoManager");
//}
//
- (void)testAllChildrenFromCurrentNode {
// - (NSArray *)allChildrenFromCurrentNode
	SHNode* rootA1 = [_nodeGraphModel rootNodeGroup];	

	SHInputAttribute* Ai1 = [SHInputAttribute makeChildWithName:@"1"];
	SHOutputAttribute* Ao1 = [SHOutputAttribute makeChildWithName:@"1"];
	SHNode* nodeA1 = [SHNode makeChildWithName:@"level2_node1"];
	SHNode* nodeA2 = [SHNode makeChildWithName:@"level2_node2"];
	SHNode* nodeA3 = [SHNode makeChildWithName:@"level3_node3"];
	[rootA1 addChild:nodeA1 undoManager:_um];
	[rootA1 addChild:nodeA2 undoManager:_um];
	[rootA1 addChild:nodeA3 undoManager:_um];
	[rootA1 addChild:Ai1 undoManager:_um];
	[rootA1 addChild:Ao1 undoManager:_um];
	[Ai1 setDataType:@"mockDataType"];
	[Ao1 setDataType:@"mockDataType"];
	SHInterConnector* intA1 = [_nodeGraphModel connectOutletOfAttribute:Ai1 toInletOfAttribute:Ao1];	
	STAssertNotNil(intA1, @"eh");

	[rootA1 deleteChild:nodeA2 undoManager:nil];

	NSArray *allRootChildren = [_nodeGraphModel allChildrenFromCurrentNode];
	STAssertTrue([allRootChildren count]==5, @"count of children is %i", [allRootChildren count]);
	STAssertTrue([allRootChildren containsObject:nodeA1 ], @"didnt we just add that object?");
	STAssertFalse([allRootChildren containsObject:nodeA2 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:nodeA3 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:Ai1 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:Ao1 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:intA1 ], @"didnt we just add that object?");
}

- (void)testAllChildrenFromNode {
// - (NSArray *)allChildrenFromNode:(SHNode *)aNode

	SHNode* rootA1 = [_nodeGraphModel rootNodeGroup];	

	SHInputAttribute* Ai1 = [SHInputAttribute makeChildWithName:@"1"];
	SHOutputAttribute* Ao1 = [SHOutputAttribute makeChildWithName:@"1"];
	SHNode* nodeA1 = [SHNode makeChildWithName:@"level2_node1"];
	SHNode* nodeA2 = [SHNode makeChildWithName:@"level2_node2"];
	SHNode* nodeA3 = [SHNode makeChildWithName:@"level3_node3"];
	[rootA1 addChild:nodeA1 undoManager:_um];
	[rootA1 addChild:nodeA2 undoManager:_um];
	[rootA1 addChild:nodeA3 undoManager:_um];
	[rootA1 addChild:Ai1 undoManager:_um];
	[rootA1 addChild:Ao1 undoManager:_um];
	[Ai1 setDataType:@"mockDataType"];
	[Ao1 setDataType:@"mockDataType"];
	SHInterConnector* intA1 = [_nodeGraphModel connectOutletOfAttribute:Ai1 toInletOfAttribute:Ao1];	
	STAssertNotNil(intA1, @"eh");

	[rootA1 deleteChild:nodeA2 undoManager:nil];

	NSArray *allRootChildren = [_nodeGraphModel allChildrenFromNode:rootA1];
	STAssertTrue([allRootChildren count]==5, @"count of children is %i", [allRootChildren count]);
	STAssertTrue([allRootChildren containsObject:nodeA1 ], @"didnt we just add that object?");
	STAssertFalse([allRootChildren containsObject:nodeA2 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:nodeA3 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:Ai1 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:Ao1 ], @"didnt we just add that object?");
	STAssertTrue([allRootChildren containsObject:intA1 ], @"didnt we just add that object?");
}

//- (void)testAllSelectedChildrenFromNode {
//// - (NSArray *)allSelectedChildrenFromNode:(SHNode *)aNode
//
//	SHNode* rootA1 = [_nodeGraphModel rootNodeGroup];	
//
//	SHInputAttribute* Ai1 = [SHInputAttribute makeChildWithName:@"1"];
//	SHOutputAttribute* Ao1 = [SHOutputAttribute makeChildWithName:@"1"];
//	SHNode* nodeA1 = [SHNode makeChildWithName:@"level2_node1"];
//	SHNode* nodeA2 = [SHNode makeChildWithName:@"level2_node2"];
//	SHNode* nodeA3 = [SHNode makeChildWithName:@"level3_node3"];
//	[rootA1 addChild:nodeA1 undoManager:_um];
//	[rootA1 addChild:nodeA2 undoManager:_um];
//	[rootA1 addChild:nodeA3 undoManager:_um];
//	[rootA1 addChild:Ai1 undoManager:_um];
//	[rootA1 addChild:Ao1 undoManager:_um];
//	[Ai1 setDataType:@"mockDataType"];
//	[Ao1 setDataType:@"mockDataType"];
//	SHInterConnector* intA1 = [rootA1 connectOutletOfAttribute:Ai1 toInletOfAttribute:Ao1];	
//	STAssertNotNil(intA1, @"eh");
//
//	[rootA1 unSelectAllChildren];
//	NSArray *allSelectedRootChildren = [_nodeGraphModel allSelectedChildrenFromNode:rootA1];
//	STAssertTrue([allSelectedRootChildren count]==0, @"count of children is %i", [allSelectedRootChildren count]);
//	[rootA1 addChildToSelection: nodeA2];
//	allSelectedRootChildren = [_nodeGraphModel allSelectedChildrenFromNode:rootA1];
//	STAssertTrue([allSelectedRootChildren count]==1, @"count of children is %i", [allSelectedRootChildren count]);
//	STAssertTrue([allSelectedRootChildren containsObject:nodeA2 ], @"didnt we just add that object?");
//
//	[rootA1 addChildToSelection: nodeA3];
//	allSelectedRootChildren = [_nodeGraphModel allSelectedChildrenFromNode:rootA1];
//	STAssertTrue([allSelectedRootChildren count]==2, @"count of children is %i", [allSelectedRootChildren count]);
//	STAssertTrue([allSelectedRootChildren containsObject:nodeA3 ], @"didnt we just add that object?");
//	
//	[rootA1 addChildToSelection: intA1];
//	allSelectedRootChildren = [_nodeGraphModel allSelectedChildrenFromNode:rootA1];
//	STAssertTrue([allSelectedRootChildren count]==3, @"count of children is %i", [allSelectedRootChildren count]);
//	STAssertTrue([allSelectedRootChildren containsObject:intA1 ], @"didnt we just add that object?");
//	
//	[rootA1 addChildToSelection: Ai1];
//	allSelectedRootChildren = [_nodeGraphModel allSelectedChildrenFromNode:rootA1];
//	STAssertTrue([allSelectedRootChildren count]==4, @"count of children is %i", [allSelectedRootChildren count]);
//	STAssertTrue([allSelectedRootChildren containsObject:Ai1 ], @"didnt we just add that object?");
//	
//	[rootA1 deleteChild: nodeA2];
//	allSelectedRootChildren = [_nodeGraphModel allSelectedChildrenFromNode:rootA1];
//	STAssertTrue([allSelectedRootChildren count]==0, @"count of children is %i", [allSelectedRootChildren count]);
////08 may	STAssertFalse([allSelectedRootChildren containsObject:nodeA2 ], @"didnt we just DELETE that object?");
////08 may	STAssertTrue([allSelectedRootChildren containsObject:intA1 ], @"didnt we just add that object?");
////08 may	STAssertTrue([allSelectedRootChildren containsObject:nodeA3 ], @"didnt we just add that object?");
////08 may	STAssertTrue([allSelectedRootChildren containsObject:Ai1 ], @"didnt we just add that object?");	
//}

- (void)testallSelectedChildrenFromCurrentNode {
//- (NSArray *)allSelectedChildrenFromCurrentNode

	SHNode* rootA1 = [_nodeGraphModel rootNodeGroup];
	SHNode* nodeA1 = [SHNode makeChildWithName:@"level2_node1"];

	[rootA1 addChild:nodeA1 undoManager:_um];
	[_nodeGraphModel setCurrentNodeGroup: nodeA1];
	
	SHInputAttribute* Ai1 = [SHInputAttribute makeChildWithName:@"1"];
	SHOutputAttribute* Ao1 = [SHOutputAttribute makeChildWithName:@"1"];
	SHNode* nodeA2 = [SHNode makeChildWithName:@"level2_node2"];
	SHNode* nodeA3 = [SHNode makeChildWithName:@"level3_node3"];

	[nodeA1 addChild:nodeA2 undoManager:_um];
	[nodeA1 addChild:nodeA3 undoManager:_um];
	[nodeA1 addChild:Ai1 undoManager:_um];
	[nodeA1 addChild:Ao1 undoManager:_um];
	[Ai1 setDataType:@"mockDataType"];
	[Ao1 setDataType:@"mockDataType"];
	SHInterConnector* intA1 = [_nodeGraphModel connectOutletOfAttribute:Ai1 toInletOfAttribute:Ao1];	
	STAssertNotNil(intA1, @"eh");

	[nodeA1 unSelectAllChildren];
	[nodeA1 addChildToSelection: intA1];
	[nodeA1 addChildToSelection: nodeA3];
	[nodeA1 addChildToSelection: nodeA2];
	[nodeA1 addChildToSelection: Ai1];

	NSArray *allSelectedChildren = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
	STAssertTrue([allSelectedChildren count]==4, @"count of children is %i", [allSelectedChildren count]);
	STAssertTrue([allSelectedChildren containsObject:intA1 ], @"didnt we just add that object?");
	STAssertTrue([allSelectedChildren containsObject:nodeA3 ], @"didnt we just add that object?");
	STAssertTrue([allSelectedChildren containsObject:Ai1 ], @"didnt we just add that object?");	
}

- (void)testMoveChildrenToIndex {
	// - (void)moveChildrenToInsertionIndex
	
	/* add objects */
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode *childnode1=[SHNode makeChildWithName:@"n1"], *childnode2=[SHNode makeChildWithName:@"n2"], *childnode3=[SHNode makeChildWithName:@"n3"], *childnode4=[SHNode makeChildWithName:@"n4"];
	SHInputAttribute *i1=[SHInputAttribute attributeWithType:@"mockDataType"],*i2=[SHInputAttribute attributeWithType:@"mockDataType"], *i3=[SHInputAttribute attributeWithType:@"mockDataType"], *i4=[SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute *o1=[SHOutputAttribute attributeWithType:@"mockDataType"], *o2=[SHOutputAttribute attributeWithType:@"mockDataType"], *o3=[SHOutputAttribute attributeWithType:@"mockDataType"], *o4=[SHOutputAttribute attributeWithType:@"mockDataType"];
	
	[_nodeGraphModel insertGraphics:[NSArray arrayWithObjects:childnode1,childnode2,childnode3,childnode4, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSMakeRange(0,4))]];
	[_nodeGraphModel insertGraphics:[NSArray arrayWithObjects:i1,i2,i3,i4, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSMakeRange(0,4))]];
	[_nodeGraphModel insertGraphics:[NSArray arrayWithObjects:o1,o2,o3,o4, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:(NSMakeRange(0,4))]];

	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"eh");
	[_nodeGraphModel connectOutletOfAttribute:i2 toInletOfAttribute:o2];
	
	/* Verify initial setup */
	STAssertTrue(1==[root indexOfChild:childnode2], @"is %i", [root indexOfChild:childnode2]);
	STAssertTrue(2==[root indexOfChild:i3], @"is %i", [root indexOfChild:i3]);
	STAssertTrue(3==[root indexOfChild:o4], @"is %i", [root indexOfChild:o4]);
	
	/* Move some stuff around */
	STAssertThrows([_nodeGraphModel moveChildren:[NSArray arrayWithObjects:nil] toInsertionIndex:0], @"Children must be the same type");
	[_um removeAllActions];
	[_nodeGraphModel moveChildren:[NSArray arrayWithObjects:childnode2,childnode3,nil] toInsertionIndex:0];
	STAssertTrue([_nodeGraphModel.currentNodeGroup nodeAtIndex:0]==childnode2, @"hmm");
	STAssertTrue([_nodeGraphModel.currentNodeGroup nodeAtIndex:1]==childnode3, @"hmm");
	STAssertTrue([_nodeGraphModel.currentNodeGroup nodeAtIndex:2]==childnode1, @"hmm");
	[_um undo];
	STAssertTrue([_nodeGraphModel.currentNodeGroup nodeAtIndex:0]==childnode1, @"hmm");
	STAssertTrue([_nodeGraphModel.currentNodeGroup nodeAtIndex:1]==childnode2, @"hmm");
	STAssertTrue([_nodeGraphModel.currentNodeGroup nodeAtIndex:2]==childnode3, @"hmm");
}

- (void)testAddToIndexOfChild {
// - (void)add:(int)amountToMove toIndexOfChild:(id)aChild;

/* add objects */
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertNotNil(int1, @"eh");

	SHNode* childnode2 = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode2 toNode:root];
	SHInputAttribute* i2 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o2 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[_nodeGraphModel NEW_addChild:i2 toNode:root];
	[_nodeGraphModel NEW_addChild:o2 toNode:root];
	[_nodeGraphModel connectOutletOfAttribute:i2 toInletOfAttribute:o2];

	[_nodeGraphModel add:-1 toIndexOfChild:childnode2];
	[_nodeGraphModel add:-1 toIndexOfChild:o2];
	[_nodeGraphModel add:1 toIndexOfChild:i1];

	int ind1 = [root indexOfChild:childnode2];
	int ind2 = [root indexOfChild:o2];
	int ind3 = [root indexOfChild:i1];

	STAssertTrue(ind1==0, @"is %i", ind1);
	STAssertTrue(ind2==0, @"is %i", ind2);
	STAssertTrue(ind3==1, @"is %i", ind3);
	
	[_nodeGraphModel.undoManager removeAllActions];
	[self resetObservers];
	[_nodeGraphModel add:1 toIndexOfChild:childnode2];
	[_nodeGraphModel add:1 toIndexOfChild:o2];
	
	ind1 = [root indexOfChild:childnode2];
	ind2 = [root indexOfChild:o2];
	STAssertTrue(ind1==1, @"eek");
	STAssertTrue(ind2==1, @"eek");
	
	STAssertTrue(_nodesAddedNotifications==1, @"ERROR with children %i", _nodesAddedNotifications);

	// test undo
	[_nodeGraphModel.undoManager undo];
	
	STAssertTrue([root indexOfChild:childnode2]==0, @"is %i", [root indexOfChild:childnode2]);
	STAssertTrue([root indexOfChild:o2]==0, @"is %i",  [root indexOfChild:o2]);
	STAssertTrue([root indexOfChild:i1]==1, @"is %i", [root indexOfChild:i1]);

	STAssertTrue(_nodesAddedNotifications==2, @"ERROR with children %i", _nodesAddedNotifications);
	STAssertTrue(_nodesInsertedKindNotifications==2, @"ERROR with children");
	
	STAssertTrue(_inputsAddedNotifications==0, @"ERROR with children");
	STAssertTrue(_inputsInsertedKindNotifications==0, @"ERROR with children");
	STAssertTrue(_outputsAddedNotifications==2, @"ERROR with children");
	STAssertTrue(_outputsInsertedKindNotifications==2, @"ERROR with children");
	STAssertTrue(_icsAddedNotifications==0, @"ERROR with children");
	STAssertTrue(_icsInsertedKindNotifications==0, @"ERROR with children");
}

//#pragma mark -
//#pragma mark old tests
//
//
////- (void)testNewRootNode {
////	
////	SHNode* ob1 = [_nodeGraphModel newFirstLevelNode]; 
////	SHNode* ob2 = [_nodeGraphModel newFirstLevelNode];
////	STAssertTrue(ob1!=ob2, @"SHNodeGraphModelTests making a new root returns the same object %@, %@", ob1,ob2);
////	id name1 = [ob1 name];
////	id name2 = [ob2 name];
////	id ob3 = [_nodeGraphModel firstLevelNodeWithKey:name1];
////	id ob4 = [_nodeGraphModel firstLevelNodeWithKey:name2];
////	STAssertEqualObjects(ob3, ob1, @"SHNodeGraphModelTests making a root node has returned equal objects %@, %@", ob3, ob1 );
////	STAssertEqualObjects(ob4, ob2, @"SHNodeGraphModelTests making a root node has returned equal objects %@, %@", ob4, ob2 );
////}
//
//
//
////- (void)testNewFirstLevelNodeWithName {
////
////	SHNode* ob1 = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* ob2 = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	STAssertTrue(ob1!=ob2, @"SHNodeGraphModelTests making a new root returns the same object");
////	id name1 = [ob1 name];
////	id name2 = [ob2 name];
////	id ob3 = [_nodeGraphModel firstLevelNodeWithKey:name1];
////	id ob4 = [_nodeGraphModel firstLevelNodeWithKey:name2];
////	STAssertEqualObjects(ob3, ob1, @"SHNodeGraphModelTests making a root node has returned equal objects");
////	STAssertEqualObjects(ob4, ob2, @"SHNodeGraphModelTests making a root node has returned equal objects");
////}
//
//
////- (void)testAddNodeToFirstLevel
////{
////	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
////	id childatt = [SHProtoInputAttribute makeChildWithName:@"n2"];
////	STAssertNoThrow([_nodeGraphModel addNodeToFirstLevel:childnode], @"SHNodeGraphModelTests addNodeToFirstLevel Shouldn't raise exception!");
////	STAssertThrows([_nodeGraphModel addNodeToFirstLevel:childatt],  @"SHNodeGraphModelTests addNodeToFirstLevel Should raise exception!");
////}


- (void)testSetCurrentNodeGroup {
// - (void)setCurrentNodeGroup:(SHNode *)aNodeGroup

	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];

	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode1 = [SHNode makeChildWithName:@"n1"];
	SHNode* childnode2 = [SHNode makeChildWithName:@"n1"];
	[root addChild:childnode1 undoManager:nil];
	[root addChild:childnode2 undoManager:nil];
	[_nodeGraphModel setCurrentNodeGroup:childnode1];
	STAssertTrue(currentNodeGroupChangedCount==1, @"oop");
	SHNode* currentNode1 = [_nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(currentNode1, childnode1, @"SHNodeGraphModelTests ERROR in testSetCurrentNodeGroup");
	
	[self resetObservers];
	[_nodeGraphModel.undoManager removeAllActions];

	[_nodeGraphModel setCurrentNodeGroup:childnode2];
	STAssertTrue(currentNodeGroupChangedCount==1, @"oop");
	SHNode* currentNode2 = [_nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(currentNode2, childnode2, @"SHNodeGraphModelTests ERROR in testSetCurrentNodeGroup");
	
	// test undo
	[_nodeGraphModel.undoManager undo];
	STAssertTrue(currentNodeGroupChangedCount==2, @"oop %i", currentNodeGroupChangedCount);
	SHNode* currentNode3 = [_nodeGraphModel currentNodeGroup];
	STAssertEqualObjects(currentNode3, childnode1, @"SHNodeGraphModelTests ERROR in testSetCurrentNodeGroup");
	
	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup"];
}

- (void)testSetRootNodeGroup {
// - (void)setRootNodeGroup:(SHNode *)aNode
	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel setRootNodeGroup:childnode];
	STAssertTrue(_nodeGraphModel.rootNodeGroup==childnode, @"model setup incorrectly");
	STAssertTrue(_nodeGraphModel.rootNodeGroup.nodeGraphModel==_nodeGraphModel, @"model setup incorrectly");
}

////- (void)testSetCurrentNodeGroupToNodeAtPath
////{
////	SHNode* aNode = [_nodeGraphModel newFirstLevelNode];
////	[aNode setName:@"firstLevel"];
////	SHNode* childnode = [SHNode makeChildWithName:@"child"];
////	[aNode addChild:childnode undoManager:_um];
////
////	SHNode* childnode2 = [SHNode makeChildWithName:@"child2"];
////	[childnode addChild:childnode2 undoManager:_um];
////
////	NSString* p = [[childnode absolutePath] pathAsString];
////	//logInfo(@"name of current node is %@", p);
////
////	[_nodeGraphModel setCurrentNodeGroupToNodeAtPath:p];
////	SHNode* ang2 = [_nodeGraphModel currentNodeGroup];
////
////	STAssertEqualObjects(ang2, childnode, @"SHNodeGraphModelTests ERROR in testSetCurrentNodeGroupToNodeAtPath");	 
////}
//
//
////- (void)testCloseCurrentRootNode
////{
////	SHNode* aNode = [_nodeGraphModel newFirstLevelNode];
////	[aNode setName:@"root1"];
////	SHNode* aNode2 = [_nodeGraphModel newFirstLevelNode];
////	[aNode2 setName:@"root2"];
////	BOOL flag1 = [_nodeGraphModel closeFirstLevelNode:aNode];
////	BOOL flag2 = [_nodeGraphModel closeFirstLevelNode:aNode2];
////	BOOL flag3 = [_nodeGraphModel closeFirstLevelNode:nil];
//////	STAssertThrows([_nodeGraphModel closeCurrentRootNode],  @"SHNodeGraphModelTests testCloseCurrentRootNode Should raise exception if no root nodes to close!");
////	STAssertEquals(flag1, YES, @"how come?");
////	STAssertEquals(flag2, YES, @"how come?");
////	STAssertEquals(flag3, NO, @"how come?");
////	return;
////}
//
//
////- (void)testDeleteSelectedItemsFromCurrentNodeGroup
////{
////	SHNode* root = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	[_nodeGraphModel setCurrentNodeGroup:root];
////	SHNode* child = [SHNode makeChildWithName:@"n1"];
////	[root addChild:child undoManager:_um];
////	SHNode* child2 = [SHNode makeChildWithName:@"n1"];
////	[root addChild:child2 undoManager:_um];
////	
////	[root addChildToSelection:child];
////	[root addChildToSelection:child2];
////	[_nodeGraphModel deleteAllSelectedFromCurrentNodeGroup];
////	
////	
//////	NSArray* ss = [root selectedChildNodesAndAttributes];
//////	int c = [ss count];
//////	STAssertEquals(0, (int)c, @"testDeleteSelectedItemsFromCurrentNodeGroup: Number of selected nodes should be 0, but was %d instead!", c);
////	int coc = [root countOfChildren];
////	STAssertEquals(0, (int)coc, @"Number of child nodes should be 0, but was %d instead!", coc);
////	[_nodeGraphModel closeFirstLevelNode:root];
////}
//
//
////- (void)testDeselectAllItemsInCurrentNodeGroup
////{
////	SHNode* root = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* child = [SHNode makeChildWithName:@"n1"];
////	[root addChild:child undoManager:_um];
////	SHNode* child2 = [SHNode makeChildWithName:@"n1"];
////	[root addChild:child2 undoManager:_um];
////	[root addChildToSelection:child];
////	[root addChildToSelection:child2];
////	NSArray* ss = [root selectedChildNodesAndAttributes];
////	int c = [ss count];
////	STAssertEquals(2, (int)c, @"testDeselectAllItemsInCurrentNodeGroup: Number of selected nodes should be 2, but was %d instead!", c);
////	
////	[root unSelectAllChildren];
////	ss = [root selectedChildNodesAndAttributes];
////	c = [ss count];
////	STAssertEquals(0, (int)c, @"testDeselectAllItemsInCurrentNodeGroup: Number of selected nodes should be 0, but was %d instead!", c);
////}
//
//
////- (void)testSelectNodeInCurrentNodeGroup {
////	SHNode* root = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* child = [[SHNode makeChildWithName:@"n1"];
////	[root addChild:child];
////	SHNode* child2 = [[SHNode makeChildWithName:@"n1"];
////	[root addChild:child2];
////	[root addChildToSelection:child];
////	[root addChildToSelection:child2];
////	NSArray* ss = [root selectedChildNodesAndAttributes];
////	int c = [ss count];
////	STAssertEquals(2, (int)c, @"testDeselectAllItemsInCurrentNodeGroup: Number of selected nodes should be 2, but was %d instead!", c);
////	
////	[root unSelectAllChildren];
////	ss = [root selectedChildNodesAndAttributes];
////	c = [ss count];
////	STAssertEquals(0, (int)c, @"testDeselectAllItemsInCurrentNodeGroup: Number of selected nodes should be 0, but was %d instead!", c);
////}
//
//
////- (void)testDeselectNodeInCurrentNoderoup{
//////	STFail(@"Not defined yet");
////}
//
//
////- (void)testMakeSelectedChildNodeGroupCurrent
////{
////	SHNode* root = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* child = [SHNode makeChildWithName:@"n1"];
////	[root addChild:child undoManager:_um];
////	SHNode* child2 = [SHNode makeChildWithName:@"n1"];
////	[child addChild:child2 undoManager:_um];
////	[_nodeGraphModel setCurrentNodeGroup:root];
////	
////	[root addChildToSelection:child];
////	[_nodeGraphModel moveDownAlevelIntoSelectedNodeGroup];
////	[child addChildToSelection:child2];
////	[_nodeGraphModel moveDownAlevelIntoSelectedNodeGroup];
////	
////	SHNode* ang2 = [_nodeGraphModel currentNodeGroup];
////	
////	STAssertEqualObjects(child2, ang2, @"ERROR cant move down into selected object");
////	
////	// [_nodeGraphModel closeCurrentRootNode];
////}
//
////- (void)testSelectNodeAtPath
////{
////	BOOL	here;
////	SHNode* root = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* child = [SHNode makeChildWithName:@"n1"];
////	[root addChild:child undoManager:_um];
////	SHNode* child2 = [SHNode makeChildWithName:@"n1"];
////	[child addChild:child2 undoManager:_um];
////	SH_Path* path1 = [child absolutePath];
////	SH_Path* path2 = [child2 absolutePath];
////	[_nodeGraphModel setCurrentNodeGroupToNodeAtPath:[path1 pathAsString]];
////	[_nodeGraphModel selectNodeAtPath:[path2 pathAsString]];
////	
////	NSArray* ss = [child selectedChildNodesAndAttributes];
////	int c = [ss count];
////	STAssertEquals(1, (int)c, @"testSelectNodeAtPath: Number of selected nodes should be 1, but was %d instead!", c);
////	if(c>0){
////		id ob = [child lastSelectedChild];
////		STAssertEqualObjects(child2, ob, @"ERROR in set current node group from path");
////	} else {
////		STFail(@"Object Failed to select with path");
////	}
////	
//////	[_nodeGraphModel closeCurrentRootNode];
////}
//
//
////- (void)testIsfirstLevelNodeNameTaken
////{
////	// - (BOOL)isfirstLevelNodeNameTaken:(NSString*)rootName;
////	SHNode* root1 = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* root2 = [_nodeGraphModel newFirstLevelNodeWithName:@"node2"];
////
////	STAssertTrue([_nodeGraphModel isfirstLevelNodeNameTaken:@"node1"]==YES, @"fuck" );
////	STAssertTrue([_nodeGraphModel isfirstLevelNodeNameTaken:@"node2"]==YES, @"fuck" );
////	STAssertTrue([_nodeGraphModel isfirstLevelNodeNameTaken:@"node3"]==NO, @"fuck" );
////}
//
//
////- (void)testNextUniqueRootNameBasedOn
////{
////	// - (NSString)nextUniqueRootNameBasedOn:(NSString*)rootName;
////	SHNode* root1 = [_nodeGraphModel newFirstLevelNodeWithName:@"node1"];
////	SHNode* root2 = [_nodeGraphModel newFirstLevelNodeWithName:@"node2"];
////	STAssertTrue([[_nodeGraphModel nextUniqueRootNameBasedOn:@"node1"] isEqualToString:@"node3"], @"%@", [_nodeGraphModel nextUniqueRootNameBasedOn:@"node1"] );
////}		

- (void)testSaveAndLoadNodeGraphModel {
	// - (BOOL)saveNode:(SHNode*)aNode toFile:(NSString *)fileName;
	// - (SHNode *)loadNodeFromFile:(NSString *)fileName;
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* n1 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName: @"testSaveAndLoad"];

	SHNode* node1 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"one"];
	STAssertNotNil(node1, @"er");
	SHNode* node2 = [_nodeGraphModel makeEmptyNodeInCurrentNodeWithName:@"one"]; 
	SHNode* node3 = [SHNode makeChildWithName:@"n1"];
	[node2 addChild:node3 undoManager:_um];

	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];	
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	SHInterConnector* int1 = [_nodeGraphModel connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	STAssertTrue(n1!=nil && int1!=nil, @"just stopping compiler warning");

	NSString *stringPath = [[NSString stringWithString:@"~/Desktop/teeeeeeempp"] stringByExpandingTildeInPath];
	BOOL success = [_nodeGraphModel saveNode:root toFile:stringPath];
	STAssertTrue(success, @"Failed To save");
	SHNode* loadedNode = [_nodeGraphModel loadNodeFromFile:stringPath];
	STAssertTrue([loadedNode isEquivalentTo:root], @"ERR");

	NSFileManager* fileManager = [NSFileManager defaultManager];
	BOOL result = [fileManager removeFileAtPath:stringPath handler:nil];
	STAssertTrue(result, @"Not cleaning up properly after tests");
}

//- (void)testFScriptWrapperFromChildrenFromNode {
//// - (NSXMLElement *)fScriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode 
//// - (BOOL)unArchiveChildrenFromFScriptWrapper:(NSXMLElement *)copiedStuffWrapper intoNode:(SHNode *)parentNode 
//
//	SHNode* root = [_nodeGraphModel rootNodeGroup];	
//	SHNode* node1 = [SHNode makeChildWithName:@"level2_node1"];
//	[root addChild:node1 undoManager:_um];
//	SHInputAttribute* in1 = [SHInputAttribute makeChildWithName:];
//	SHOutputAttribute* out1 = [SHOutputAttribute makeChildWithName:];
//	[in1 setDataType:@"mockDataType"];
//	[out1 setDataType:@"mockDataType"];
//	[root addChild:in1 undoManager:_um];
//	[root addChild:out1 undoManager:_um];
//	SHInterConnector *con1 =[_nodeGraphModel connectOutletOfAttribute:in1 toInletOfAttribute: out1];
//	[_nodeGraphModel connectOutletOfAttribute:in1 toInletOfAttribute: out1];
//	NSXMLElement *copiedStuff = [_nodeGraphModel fScriptWrapperFromChildren:[NSArray arrayWithObjects:con1, node1, in1, out1, nil] fromNode:root];
//	
//	[_nodeGraphModel deleteChildren:[[[_nodeGraphModel allChildrenFromCurrentNode] copy] autorelease] fromNode:root];
//
//	BOOL success = [_nodeGraphModel unArchiveChildrenFromFScriptWrapper:copiedStuff intoNode:root];
//	STAssertTrue(success, @"cant paste");
//
//	// assert node, in, out and connector
//	NSArray *nodesInside = (NSArray *)root.nodesInside;
//	NSArray *inputs = (NSArray *)root.inputs;
//	NSArray *outputs = (NSArray *)root.outputs;
//	NSArray *shInterConnectorsInside = (NSArray *)root.shInterConnectorsInside;
//	STAssertTrue([nodesInside count]==1, @"er");
//	STAssertTrue([inputs count]==1, @"er");
//	STAssertTrue([outputs count]==1, @"er");
//	STAssertTrue([shInterConnectorsInside count]==1, @"er");
//}
//
//
////- (void)testxmlRepresentation
////{
////	// - (NSXMLDocument *)xmlRepresentation
////}

- (void)testWeHaveSelectedNodesOrAttributesOrICs {
// - (BOOL)weHaveSelectedNodesOrAttributesOrICs {
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"1"];
	SHOutputAttribute* o1 = [SHOutputAttribute makeChildWithName:@"2"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	
	STAssertFalse([_nodeGraphModel weHaveSelectedNodesOrAttributesOrICs], @"ERR");
	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObject:i1]];
	STAssertTrue([_nodeGraphModel weHaveSelectedNodesOrAttributesOrICs], @"ERR");

	//-- all objects are deselected when we delete an object, so it is not relevant that we are deleting the selected one */
	[_nodeGraphModel deleteChildren:[NSArray arrayWithObject:i1] fromNode:root];
	STAssertFalse([_nodeGraphModel weHaveSelectedNodesOrAttributesOrICs], @"ERR");
}

- (void)testCurrentNodeGroupIsValid {
	// - (BOOL)currentNodeGroupIsValid {
	
	// 	what do we mewan valid.. currentNodeGroup isNot nill, is a SHNode, allowsSubpatches
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	MockProcessor* notGroupNode = [MockProcessor makeChildWithName:@"n1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"i1"];
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	
	[_nodeGraphModel setCurrentNodeGroup:root];
	STAssertTrue([_nodeGraphModel currentNodeGroupIsValid], @"ERR");
	[_nodeGraphModel setCurrentNodeGroup:childnode];
	STAssertTrue([_nodeGraphModel currentNodeGroupIsValid], @"ERR");			
}

- (void)testIsValidCurrentNode {
	//+ (BOOL)isValidCurrentNode:(id)value
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	MockProcessor* notGroupNode = [MockProcessor makeChildWithName:@"n1"];
	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"i1"];
	
	STAssertTrue([SHNodeGraphModel isValidCurrentNode:root], @"ERR");
	STAssertTrue([SHNodeGraphModel isValidCurrentNode:childnode], @"ERR");	
	STAssertFalse([SHNodeGraphModel isValidCurrentNode:notGroupNode], @"ERR");
	STAssertFalse([SHNodeGraphModel isValidCurrentNode:i1], @"ERR");	
}

//// notifications are bullshit ! do not use
//// - (void)testPostSHNodeMadeCurrent_Notification {
//// - (void)postSHNodeMadeCurrent_Notification:(id)aNode
//// }
//
//
//- (void)testSomeKVO {
//
//	[_nodeGraphModel addObserver:self forKeyPath:@"currentNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeGraphModelTests"];
//  
//	/* add objects */
//	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
//	SHNode *root = _nodeGraphModel.rootNodeGroup;
//	[_nodeGraphModel NEW_addChild:childnode toNode:root];
//	
//	/* select them */
//	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode]];
//	
//	 selectionDiDChangeKVO = NO;
//	[_nodeGraphModel.currentNodeGroup clearSelectionNoUndo];
//	STAssertTrue(selectionDiDChangeKVO, @"what happened to KVO notification of selection change?");
//
//	[_nodeGraphModel addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode]];
//	 selectionDiDChangeKVO = NO;
//	[(SHOrderedDictionary *)_nodeGraphModel.currentNodeGroup.nodesInside setSelection: [NSMutableIndexSet indexSet]];
//	STAssertTrue(selectionDiDChangeKVO, @"what happened to KVO notification of selection change?");
//
//	[_nodeGraphModel removeObserver:self forKeyPath:@"currentNodeGroup.nodesInside.selection"];
//}
//

#pragma mark test filter methods
- (void)testRegisterContentFilter {
	// - (void)registerContentFilter:(Class)filterClass andUser:(id <SHContentProviderUserProtocol>)user options:(NSDictionary *)optValues
	// - (void)unregisterContentFilter:(Class)filterClass andUser:(id <SHContentProviderUserProtocol>)user options:(NSDictionary *)optValues
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    Class filterClass = [StubContentFilter class];
    	
    // register two random users for the filter class
	StubFilterUser *stubUser1 = [[[StubFilterUser alloc] init] autorelease];
	StubFilterUser *stubUser2 = [[[StubFilterUser alloc] init] autorelease];

	[_nodeGraphModel registerContentFilter:filterClass andUser:stubUser1 options:nil];
	STAssertTrue([[stubUser1 filter] isKindOfClass:filterClass], @"did we set the filter?");
    [_nodeGraphModel registerContentFilter:filterClass andUser:stubUser2 options:nil];
	
    // StubContentFilter singleton has been initialized
    STAssertNotNil([StubContentFilter sharedInstance], @"should have just been initialized");
    
    // StubContentFilter singleton model is _nodeGraphModel
    STAssertEqualObjects([StubContentFilter sharedInstance].model, _nodeGraphModel, @"registering the filter should set the model");
	
    // _nodeGraphModel.contentFilters contains one instance of StubContentFilter
    NSArray *filters = [_nodeGraphModel.contentFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", filterClass]];
    STAssertTrue([filters count]==1, @"who else registered a filter, eh? %i", [filters count]);
    STAssertTrue([[[filters lastObject] registeredUsers] count]==2, @"who else registered a filter, eh? %i", [[[filters lastObject] registeredUsers] count]);
    
    [_nodeGraphModel unregisterContentFilter:[StubContentFilter class] andUser:stubUser1 options:nil];
    filters = [_nodeGraphModel.contentFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", filterClass]];
    STAssertTrue([filters count]==1, @"who else registered a filter, eh? %i", [filters count]);
    STAssertTrue([[[filters lastObject] registeredUsers] count]==1, @"who else registered a filter, eh? %i", [[[filters lastObject] registeredUsers] count]);
	
    [_nodeGraphModel unregisterContentFilter:[StubContentFilter class] andUser:stubUser2 options:nil];
    
    // _nodeGraphModel.contentFilters contains no instance of StubContentFilter
    filters = [_nodeGraphModel.contentFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", filterClass]];
    STAssertTrue([filters count]==0, @"who else registered a filter, eh?");
	    
	[pool release];
	
    // StubContentFilter singlton has been deallocted
    STAssertNil([StubContentFilter sharedInstance], @"should have just been released and dealloced");
}

- (void)testReplaceUndomanager {
	// - (void)replaceUndomanager:(NSUndoManager *)value
	
	NSUndoManager *defaultUM = _nodeGraphModel.undoManager;
	STAssertNotNil(defaultUM, @"bugger");
	
	NSUndoManager *replacementUM = [[[NSUndoManager alloc] init] autorelease];
	[_nodeGraphModel replaceUndomanager:replacementUM];
	
	STAssertTrue(_nodeGraphModel.undoManager==replacementUM, @"fucka");
	[_nodeGraphModel replaceUndomanager:nil];
}

@end
