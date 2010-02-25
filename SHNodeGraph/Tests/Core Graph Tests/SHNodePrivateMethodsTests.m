//
//  SHNodePrivateMethodsTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHNodePrivateMethodsTests.h"
#import <SHNodeGraph/SHNodeGraph.h>
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHNode.h"
#import "SHConnectableNode.h"
#import "SHNodeAttributeMethods.h"
#import "SH_Path.h"
#import "SHConnectlet.h"
#import "SHInterConnector.h"
#import "SHCustomMutableArray.h"

static int itemsAddedCount=0, selectionChangeCount=0, interConnectorsChangedCount=0, inputsChangedCount=0, outputsChangedCount=0, nodesChangedCount=0;
static int _allItems_Insertion=0, _allItems_Replacement=0, _allItems_Change=0, _allItems_Removal=0;
static NSIndexSet *_allItems_Insertion_indexes, *_allItems_Removal_indexes;


#import "SHNodeGraph.h"


@interface SHNodePrivateMethodsTests : SenTestCase {
	
    SHNodeGraphModel *_nodeGraphModel;
	SHUndoManager *_um;
	
	/* Experimental ArrayController binding tests */
	id testSHNode;
}

@end


@implementation SHNodePrivateMethodsTests

- (void)resetObservers {

	selectionChangeCount = 0;
	itemsAddedCount = 0;
	interConnectorsChangedCount=0, inputsChangedCount=0, outputsChangedCount=0, nodesChangedCount=0;
	_allItems_Insertion=0, _allItems_Replacement=0, _allItems_Change=0, _allItems_Removal=0;
	_allItems_Insertion_indexes = nil, _allItems_Removal_indexes = nil;
	[_nodeGraphModel.rootNodeGroup clearRecordedHits];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
	
    if( [context isEqualToString:@"SHNodePrivateMethodsTests"] )
	{
		if( [keyPath isEqualToString:@"rootNodeGroup.allChildren"] ){
			itemsAddedCount++;
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					_allItems_Insertion++;
					_allItems_Insertion_indexes = changeIndexes;
					break;
				case NSKeyValueChangeReplacement:
					_allItems_Replacement++;
					break;
				case NSKeyValueChangeSetting:
					_allItems_Change++;
					break;
				case NSKeyValueChangeRemoval:
					_allItems_Removal++;
					_allItems_Removal_indexes = changeIndexes;
					break;
				default:
					[NSException raise:@"filtered content changed - how?" format:@"filtered content changed - how?"];
			}
		} 
		else if( [keyPath isEqualToString:@"rootNodeGroup.nodesInside.selection"] ){
			selectionChangeCount++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.shInterConnectorsInside.array"]){
			interConnectorsChangedCount++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.nodesInside.array"]){
			nodesChangedCount++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.inputs.array"]){
			inputsChangedCount++;
		} else if([keyPath isEqualToString:@"rootNodeGroup.outputs.array"]){
			outputsChangedCount++;
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
	
	[_um setGroupsByEvent:YES];
	[_um removeAllActions];
	[_um release];
	
	[_nodeGraphModel release];
}

- (void)test_changeNameOfChild {
	// - (void)_changeNameOfChild(id)child to:(NSString *)value
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode = [SHNode newNode];
	[childnode setName:@"Sparrow1"];
	[_nodeGraphModel NEW_addChild:childnode toNode:root];
	SHInputAttribute* i1 = [SHInputAttribute attributeWithType:@"mockDataType"];
	SHOutputAttribute* o1 = [SHOutputAttribute attributeWithType:@"mockDataType"];
	[i1 setName:@"Sparrow2"];
	[o1 setName:@"Sparrow3"];
	
	[_nodeGraphModel NEW_addChild:i1 toNode:root];
	[_nodeGraphModel NEW_addChild:o1 toNode:root];
	SHInterConnector* int1 = [root connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	NSString *sparrow4 = [int1 name];
	
	[_um beginDebugUndoGroup];
		[root _changeNameOfChild:childnode to:@"shazza"];
		[root _changeNameOfChild:i1 to:@"garry"];
		[root _changeNameOfChild:o1 to:@"pizza"];
		[root _changeNameOfChild:int1 to:@"dremolt"];
	[_um endUndoGrouping];
	
	STAssertTrue([root childWithKey:@"shazza"]==childnode, @"oops");
	STAssertTrue([root childWithKey:@"garry"]==i1, @"oops");
	STAssertTrue([root childWithKey:@"pizza"]==o1, @"oops");
	STAssertTrue([root childWithKey:@"dremolt"]==int1, @"oops");

    STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo change name"], @"Incorrect Undo Title :%@", [_um undoMenuItemTitle]);
	// STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo add child"], @"Incorrect Redo Title :%@", [_um redoMenuItemTitle]);
    
	[root clearRecordedHits];
	[_um undo];
	BOOL hitRecordResult1 = [root assertRecordsIs:@"_changeNameOfChild:to:", @"_changeNameOfChild:to:", @"_changeNameOfChild:to:", @"_changeNameOfChild:to:", nil];
	NSMutableArray *actualRecordings1 = [root recordedSelectorStrings];
	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
	
	STAssertTrue([root childWithKey:@"Sparrow1"]==childnode, @"oops");
	STAssertTrue([root childWithKey:@"Sparrow2"]==i1, @"oops");
	STAssertTrue([root childWithKey:@"Sparrow3"]==o1, @"oops");

	//-- should we be able to change the name of interconnectors?
	STAssertTrue([root childWithKey:sparrow4]==int1, @"oops");
    // STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo change name"], @"Incorrect Undo Title :%@", [_um undoMenuItemTitle]);
	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo change name"], @"Incorrect Redo Title :%@", [_um redoMenuItemTitle]);
	
	[root clearRecordedHits];
	[_um redo];
	BOOL hitRecordResult2 = [root assertRecordsIs:@"_changeNameOfChild:to:", @"_changeNameOfChild:to:", @"_changeNameOfChild:to:", @"_changeNameOfChild:to:", nil];
	NSMutableArray *actualRecordings2 = [root recordedSelectorStrings];
	STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);
	
	STAssertTrue([root childWithKey:@"shazza"]==childnode, @"oops");
	STAssertTrue([root childWithKey:@"garry"]==i1, @"oops");
	STAssertTrue([root childWithKey:@"pizza"]==o1, @"oops");
	STAssertTrue([root childWithKey:@"dremolt"]==int1, @"oops");
	
    STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo change name"], @"Incorrect Undo Title :%@", [_um undoMenuItemTitle]);
	// STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo change name"], @"Incorrect Redo Title :%@", [_um redoMenuItemTitle]);
}

- (void)test_setSelectionForStorageNewSelection {
	// - (void)_setSelectionForStorage:(SHOrderedDictionary *)targetStorage newSelection:(NSMutableIndexSet *)value {
	
	//-- observe all items
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodePrivateMethodsTests"];
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];
	SHNode* childnode1 = [SHNode newNode];
	SHNode* childnode2 = [SHNode newNode];
	[childnode1 setName:@"testSHNode1"];
	[childnode2 setName:@"testSHNode2"];
	[root _addToStorage:childnode1 withKey:[childnode1 name]];
	[root _addToStorage:childnode2 withKey:[childnode2 name]];
	SHOrderedDictionary* ordered1 = [root _targetStorageForObject: childnode1];
	
	[self resetObservers];
	[root _setSelectionForStorage:ordered1 newSelection:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
	
	STAssertTrue( [[ordered1 selection] count]==2, @"didnt set selection for target");
	STAssertTrue( [[ordered1 selection] firstIndex]==0, @"didnt set selection for target");
	
	STAssertTrue(selectionChangeCount==1, @"received incorrect number of notifications %i", itemsAddedCount);

	// -- remove observer
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection"];
}

	
@end
