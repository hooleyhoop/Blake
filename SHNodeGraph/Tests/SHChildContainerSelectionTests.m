//
//  SHChildContainerSelectionTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChildContainer.h"
#import "SHChild.h"
#import "NodeName.h"
#import "SHParent.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"
#import "SHChildContainer_Selection.h"

@interface SHChildContainerSelectionTests : SenTestCase {
	
	SHChildContainer *container;
	NSUndoManager *um;
}

@end

@implementation SHChildContainerSelectionTests

- (void)resetObservers {

}

- (void)setUp {
	
	container = [[SHChildContainer alloc] init];
	um = [[NSUndoManager alloc] init];
	[self resetObservers];
	
}

- (void)tearDown {
	
	[um removeAllActions];
	[um release];
	[container release];
}

- (void)testClearSelectionNoUndo {
	//- (void)clearSelectionNoUndo;
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	[container setSelectedNodes: [NSArray arrayWithObject: n1]];
	[container setSelectedInterconnectors: [NSArray arrayWithObject: anInterConnector1]];
	[container setSelectedInputs: [NSArray arrayWithObject:i1]];
	[container setSelectedOutputs:[NSArray arrayWithObject:o1]];
	[um removeAllActions];
	
	[container clearSelectionNoUndo];
	NSArray* selectedChildren1 = [container selectedChildren];
	STAssertTrue([selectedChildren1 count]==0, @"er");
	
	[um undo];
	NSArray* selectedChildren2 = [container selectedChildren];
	STAssertTrue([selectedChildren2 count]==0, @"er");
}

- (void)testSelectedChildren {
	
	// - (void)setSelectedNodes:(NSArray *)nodesSet;
	// - (void)setSelectedInputs:(NSArray *)inputsSet;
	// - (void)setSelectedOutputs:(NSArray *)outputsSet;
	// - (void)setSelectedInterconnectors:(NSArray *)icSet;
	
	// - (NSArray *)selectedChildren;

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];

	[container setSelectedNodes: [NSArray arrayWithObject: n1]];
	[container setSelectedInterconnectors: [NSArray arrayWithObject: anInterConnector1]];
	[container setSelectedInputs: [NSArray arrayWithObject:i1]];
	[container setSelectedOutputs:[NSArray arrayWithObject:o1]];
	
	NSArray* selectedChildren = [container selectedChildren];
	STAssertTrue([selectedChildren count]==4, @"er");
	STAssertTrue([selectedChildren containsObject:n1], @"er");
	STAssertTrue([selectedChildren containsObject:anInterConnector1], @"er");
	STAssertTrue([selectedChildren containsObject:i1], @"er");
	STAssertTrue([selectedChildren containsObject:o1], @"er");	
}

- (void)testAddChildToSelection {
	// - (void)addChildToSelection:(id)child;
	
//	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	
	[container setSelectedNodes: [NSArray arrayWithObject: n1]];
	[container setSelectedInterconnectors: [NSArray arrayWithObject: anInterConnector1]];
	[container setSelectedInputs: [NSArray arrayWithObject:i1]];
	[container setSelectedOutputs:[NSArray arrayWithObject:o1]];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [container addChildToSelection: n2];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
	
    //NotUsingUndoInSelection	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo add to selection"], @"Incorrect Undo Title - %@", [_um undoMenuItemTitle] );
//	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	
	NSArray* selectedChildren = [container selectedChildren];
	STAssertTrue([selectedChildren count]==5, @"er");
	STAssertTrue([selectedChildren containsObject:n1], @"er");
	STAssertTrue([selectedChildren containsObject:n2], @"er");
	STAssertTrue([selectedChildren containsObject:anInterConnector1], @"er");
	STAssertTrue([selectedChildren containsObject:i1], @"er");
	STAssertTrue([selectedChildren containsObject:o1], @"er");
    
    //NotUsingUndoInSelection	[root clearRecordedHits];
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	BOOL hitRecordResult1 = [root assertRecordsIs:@"removeChildFromSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings1 = [root recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
	
    //NotUsingUndoInSelection	selectedChildren = [root selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selectedChildren count]==4, @"undo should have removed it");
    //NotUsingUndoInSelection	STAssertFalse([selectedChildren containsObject:childnode2], @"undo should have removed it");
    
    //NotUsingUndoInSelection	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);
    //NotUsingUndoInSelection	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo add to selection"], @"Incorrect Redo Title %@", [_um redoMenuItemTitle]);
    
    //NotUsingUndoInSelection	[root clearRecordedHits];
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	BOOL hitRecordResult2 = [root assertRecordsIs:@"addChildToSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings2 = [root recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);
	
    //NotUsingUndoInSelection	selectedChildren = [root selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selectedChildren count]==5, @"redo should have put it back");
    //NotUsingUndoInSelection	STAssertTrue([selectedChildren containsObject:childnode2], @"redo should have put it back");
	
//	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection"];
}

- (void)testSelectAllChildren {
	//- (void)selectAllChildren
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
		
	STAssertTrue([[container selectedChildren] count]==0, @"doh");
	[container selectAllChildren];
	STAssertTrue([[container selectedChildren] count]==[container countOfChildren], @"doh");
}

- (void)testUnSelectAllChildNodes {
	//- (void)unSelectAllChildNodes

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	
	[container selectAllChildren];
	[container unSelectAllChildNodes];
	STAssertTrue([[container selectedChildren] count]==3, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:n1]==NSNotFound, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:n2]==NSNotFound, @"doh");
}

- (void)testUnSelectAllChildInputs {
	//- (void)unSelectAllChildInputs

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	
	[container selectAllChildren];
	[container unSelectAllChildInputs];
	STAssertTrue([[container selectedChildren] count]==4, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:i1]==NSNotFound, @"doh");
}

- (void)testUnSelectAllChildOutputs {
	//- (void)unSelectAllChildOutputs

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	
	[container selectAllChildren];
	[container unSelectAllChildOutputs];
	STAssertTrue([[container selectedChildren] count]==4, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:o1]==NSNotFound, @"doh");
}

- (void)testUnSelectAllChildInterConnectors {
	//- (void)unSelectAllChildInterConnectors

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:0 withKey:@"n2" undoManager:um];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	
	[container selectAllChildren];
	[container unSelectAllChildInterConnectors];
	STAssertTrue([[container selectedChildren] count]==4, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:anInterConnector1]==NSNotFound, @"doh");
}

- (void)testSetSelectedNodesInsideIndexes {
	//- (void)setSelectedNodesInsideIndexes:(NSMutableIndexSet *)value

	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHParent *n2 = [SHParent makeChildWithName:@"n2"];
	SHParent *n3 = [SHParent makeChildWithName:@"n3"];
	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addNode:n2 atIndex:1 withKey:@"n2" undoManager:um];
	[container _addNode:n3 atIndex:2 withKey:@"n3" undoManager:um];
	
	[container setSelectedNodesInsideIndexes:[NSMutableIndexSet indexSetWithIndex:1]];
	STAssertTrue([[container selectedChildren] count]==1, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:n2]==0, @"doh");
}

- (void)testSetSelectedInputIndexes {
	//- (void)setSelectedInputIndexes:(NSMutableIndexSet *)value

	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoInputAttribute *i2 = [SHProtoInputAttribute makeChildWithName:@"i2"];
	SHProtoInputAttribute *i3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addInput:i2 atIndex:1 withKey:@"i2" undoManager:um];
	[container _addInput:i3 atIndex:2 withKey:@"i3" undoManager:um];

	[container setSelectedInputIndexes:[NSMutableIndexSet indexSetWithIndex:1]];
	STAssertTrue([[container selectedChildren] count]==1, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:i2]==0, @"doh");
}

- (void)testSetSelectedOutputIndexes {
	//- (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value

	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoOutputAttribute *o2 = [SHProtoOutputAttribute makeChildWithName:@"o2"];
	SHProtoOutputAttribute *o3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	[container _addOutput:o2 atIndex:1 withKey:@"o2" undoManager:um];
	[container _addOutput:o3 atIndex:2 withKey:@"o3" undoManager:um];

	[container setSelectedOutputIndexes:[NSMutableIndexSet indexSetWithIndex:1]];
	STAssertTrue([[container selectedChildren] count]==1, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:o2]==0, @"doh");
}

- (void)testSetSelectedInterConnectorIndexes {
	//- (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value

	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoInputAttribute *i2 = [SHProtoInputAttribute makeChildWithName:@"i2"];
	SHProtoInputAttribute *i3 = [SHProtoInputAttribute makeChildWithName:@"i3"];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addInput:i2 atIndex:1 withKey:@"i2" undoManager:um];
	[container _addInput:i3 atIndex:2 withKey:@"i3" undoManager:um];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHProtoOutputAttribute *o2 = [SHProtoOutputAttribute makeChildWithName:@"o2"];
	SHProtoOutputAttribute *o3 = [SHProtoOutputAttribute makeChildWithName:@"o3"];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	[container _addOutput:o2 atIndex:1 withKey:@"o2" undoManager:um];
	[container _addOutput:o3 atIndex:2 withKey:@"o3" undoManager:um];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];
	SHInterConnector *anInterConnector2 = [SHInterConnector makeChildWithName:@"ic2"];
	SHInterConnector *anInterConnector3 = [SHInterConnector makeChildWithName:@"ic3"];
	
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];
	[container _addInterConnector:anInterConnector2 between:i2 and:o2 undoManager:um];
	[container _addInterConnector:anInterConnector3 between:i3 and:o3 undoManager:um];

	[container setSelectedInterConnectorIndexes:[NSMutableIndexSet indexSetWithIndex:1]];
	STAssertTrue([[container selectedChildren] count]==1, @"doh");
	STAssertTrue([[container selectedChildren] indexOfObjectIdenticalTo:anInterConnector2]==0, @"doh");
}

- (void)testHasSelection {
	//- (BOOL)hasSelection
	
	SHParent *n1 = [SHParent makeChildWithName:@"n1"];
	SHProtoInputAttribute *i1 = [SHProtoInputAttribute makeChildWithName:@"i1"];
	SHProtoOutputAttribute *o1 = [SHProtoOutputAttribute makeChildWithName:@"o1"];
	SHInterConnector *anInterConnector1 = [SHInterConnector makeChildWithName:@"ic1"];

	[container _addNode:n1 atIndex:0 withKey:@"n1" undoManager:um];
	[container _addInput:i1 atIndex:0 withKey:@"i1" undoManager:um];
	[container _addOutput:o1 atIndex:0 withKey:@"o1" undoManager:um];
	[container _addInterConnector:anInterConnector1 between:i1 and:o1 undoManager:um];

	[container clearSelectionNoUndo];
	STAssertFalse([container hasSelection], @"die hard");
	
	[container addChildToSelection:n1];
	STAssertTrue([container hasSelection], @"die hard");
	[container clearSelectionNoUndo];
	
	[container addChildToSelection:i1];
	STAssertTrue([container hasSelection], @"die hard");
	[container clearSelectionNoUndo];

	[container addChildToSelection:o1];
	STAssertTrue([container hasSelection], @"die hard");
	[container clearSelectionNoUndo];

	[container addChildToSelection:anInterConnector1];
	STAssertTrue([container hasSelection], @"die hard");
	[container clearSelectionNoUndo];
	
	STAssertFalse([container hasSelection], @"die hard");
}

@end
