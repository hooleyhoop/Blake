//
//  SHParent_SelectionTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent.h"
#import "SHParent_Selection.h"
#import "SHParent_Connectable.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "NodeName.h"
#import "SH_Path.h"
#import "SHChildContainer.h"
#import "SHInterConnector.h"

@interface SHParent_SelectionTests : SenTestCase {

	SHParent		*parent;
	NSUndoManager	*um;
}

@end

static int nodeSelectionChanged, inputSelectionChanged, outputSelectionChanged, icSelectionChanged;


@implementation SHParent_SelectionTests

- (void)resetObservers {
	nodeSelectionChanged = 0;
	inputSelectionChanged = 0;
	outputSelectionChanged = 0;
	icSelectionChanged = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSString *cntxt = (NSString *)context;
	if(cntxt==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];

    if( [cntxt isEqualToString:@"SHParent_SelectionTests"] )
	{
		if ([keyPath isEqualToString:@"childContainer.nodesInside.selection"]) {
			nodeSelectionChanged++;
		} else if ([keyPath isEqual:@"childContainer.inputs.selection"]) {
			inputSelectionChanged++;
		} else if ([keyPath isEqual:@"childContainer.outputs.selection"]) {
			outputSelectionChanged++;
		} else if ([keyPath isEqual:@"childContainer.shInterConnectorsInside.selection"]) {
			icSelectionChanged++;
		} else {
			[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
	}
}

- (void)setUp {
	
	parent = [[SHParent alloc] init];
	[parent changeNameWithStringTo:@"rootNode" fromParent:nil undoManager:nil];
	um = [[NSUndoManager alloc] init];
}

- (void)tearDown {
	
	[um removeAllActions];
	[parent release];
	[um release];
}

- (void)testClearSelectionNoUndo {
	// - (void)clearSelectionNoUndo;

	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"in1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"out1"];
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:i1 atIndex:-1 undoManager:um];
	[parent addChild:o1 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:um];
	[parent setSelectedChildren: [NSArray arrayWithObject:childnode1]];
	
	[um removeAllActions];
	[parent clearSelectionNoUndo];
	
	NSArray* selectedChildren1 = [parent selectedChildren];
	STAssertTrue([selectedChildren1 count]==0, @"er");

	[um undo];
	NSArray* selectedChildren2 = [parent selectedChildren];
	STAssertTrue([selectedChildren2 count]==0, @"er");
}

- (void)testAddChildToSelection {
	//- (void)addChildToSelection:(id)child;
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"in1"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"out1"];
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:i1 atIndex:-1 undoManager:um];
	[parent addChild:o1 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:um];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];	
	
	STAssertTrue( [[parent selectedChildren] count]==0, @"er %i", [[parent selectedChildren] count] );
	[parent addChildToSelection: childnode1];
	STAssertTrue( [[parent selectedChildren] count]==1, @"er %i", [[parent selectedChildren] count] );
	[parent addChildToSelection: i1];
	STAssertTrue( [[parent selectedChildren] count]==2, @"er %i", [[parent selectedChildren] count] );
	[parent addChildToSelection: o1];
	STAssertTrue( [[parent selectedChildren] count]==3, @"er %i", [[parent selectedChildren] count] );
	[parent addChildToSelection: int1];
	STAssertTrue( [[parent selectedChildren] count]==4, @"er %i", [[parent selectedChildren] count] );
}

- (void)testSetSelectedChildren {
	//- (void)setSelectedChildren:(NSArray *)children
	//- (NSArray *)selectedChildren

//	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
//	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
//	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
//	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode2 = [SHParent makeChildWithName:@"n2"];
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute makeChildWithName:@"in1"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute makeChildWithName:@"out1"];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute makeChildWithName:@"in2"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute makeChildWithName:@"out2"];
	
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:childnode2 atIndex:-1 undoManager:um];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:i1 atIndex:-1 undoManager:um];
	[parent addChild:o1 atIndex:-1 undoManager:um];

	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)i1 andInletOfAtt:(SHProtoAttribute *)o1 undoManager:um];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];	
	NSArray* selectedChildren = [parent selectedChildren];
	STAssertTrue([selectedChildren count]==0, @"er");
	[self resetObservers];
	
	[parent setSelectedChildren: [NSArray arrayWithObject:childnode1]];
	selectedChildren = [parent selectedChildren];
	STAssertTrue([selectedChildren count]==1, @"er");
	STAssertTrue([selectedChildren containsObject:childnode1], @"er");
	
//	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
//	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
//	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
//	STAssertTrue( icSelectionChanged==0, @"what happened? %i", icSelectionChanged);
	
	[parent setSelectedChildren: [NSArray arrayWithObjects:childnode2, int1, nil]];
//	STAssertTrue( nodeSelectionChanged==2, @"what happened? %i", nodeSelectionChanged);
//	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
//	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
//	STAssertTrue( icSelectionChanged==1, @"what happened? %i", icSelectionChanged);
	
	selectedChildren = [parent selectedChildren];
	STAssertFalse([selectedChildren containsObject:childnode1], @"er");
	STAssertTrue([selectedChildren containsObject:childnode2], @"er");
	STAssertTrue([selectedChildren containsObject:int1], @"er");
	STAssertFalse([selectedChildren containsObject:i1], @"er");
	STAssertFalse([selectedChildren containsObject:o1], @"er");
	
	[parent setSelectedChildren: [NSArray arrayWithObjects:i1, o1, nil]];
	selectedChildren = [parent selectedChildren];
	STAssertTrue([selectedChildren containsObject:i1], @"er");
	STAssertTrue([selectedChildren containsObject:o1], @"er");
	
	// test that it can remove objects as well
	[parent setSelectedChildren: [NSArray array]];
	selectedChildren = [parent selectedChildren];
	STAssertTrue([selectedChildren count]==0, @"er");
	
//	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
//	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
//	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
//	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
	
}

- (void)testRemoveChildFromSelection {
	// - (void)removeChildFromSelection:(id)child;
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode2 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:childnode2 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* i1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* o1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:i1 atIndex:-1 undoManager:um];
	[parent addChild:o1 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:i1 andInletOfAtt:o1 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:i1 and:o1];

	[[parent nodesInside] setSelectedObjects: [NSArray arrayWithObject: childnode1]];
	[[parent shInterConnectorsInside] setSelectedObjects: [NSArray arrayWithObject: int1]];
	[[parent inputs] setSelectedObjects: [NSArray arrayWithObject:i1]];
	[[parent outputs] setSelectedObjects:[NSArray arrayWithObject:o1]];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent removeChildFromSelection: childnode1];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
    //NotUsingUndoInSelection	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo remove from selection"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);
	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	
	NSArray* selectedChildren = [parent selectedChildren];
	STAssertTrue([selectedChildren count]==3, @"er");
	STAssertTrue([selectedChildren containsObject:int1], @"er");
	STAssertTrue([selectedChildren containsObject:i1], @"er");
	STAssertTrue([selectedChildren containsObject:o1], @"er");
    
    //NotUsingUndoInSelection	[parent clearRecordedHits];
    //NotUsingUndoInSelection	[_um undo];
    
    //NotUsingUndoInSelection	BOOL hitRecordResult1 = [parent assertRecordsIs:@"addChildToSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings1 = [parent recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
    
    //NotUsingUndoInSelection	selectedChildren = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selectedChildren count]==4, @"is %i", [selectedChildren count]);
    //NotUsingUndoInSelection	STAssertTrue([selectedChildren containsObject:childnode1], @"undo should have put it back");
    
	// STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo add to selection"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);
    //NotUsingUndoInSelection	STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo remove from selection"], @"Incorrect Redo Title %@", [_um redoMenuItemTitle]);
    
    //NotUsingUndoInSelection	[parent clearRecordedHits];
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	BOOL hitRecordResult2 = [parent assertRecordsIs:@"removeChildFromSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings2 = [parent recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);
	
    //NotUsingUndoInSelection	selectedChildren = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selectedChildren count]==3, @"is %i", [selectedChildren count]);
    //NotUsingUndoInSelection	STAssertFalse([selectedChildren containsObject:childnode1], @"redo should have removed it again");
	
    //NotUsingUndoInSelection	STAssertTrue([[_um undoMenuItemTitle] isEqualToString:@"Undo remove from selection"], @"Incorrect Undo Title %@", [_um undoMenuItemTitle]);
	// STAssertTrue([[_um redoMenuItemTitle] isEqualToString:@"Redo remove from selection"], @"Incorrect Redo Title %@", [_um redoMenuItemTitle]);
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
}


- (void)testSelectAllChildren {
	// - (void)selectAllChildren
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 =  [parent interConnectorFor:atChild1 and:atChild2];
	STAssertNotNil(int1, @"eh");
	SHParent* node1 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:node1 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent selectAllChildren];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSArray* selected = [parent selectedChildren];
	STAssertTrue([selected count]==4, @"testSelectAllChildren failed. coubt is %i", [selected count]);
    
	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==1, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==1, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==1, @"what happened? %i", icSelectionChanged);
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==0, @"testSelectAllChildren failed. coubt is %i", [selected count]);
	
	/* Redo */
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==4, @"testSelectAllChildren failed. coubt is %i", [selected count]);
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}


- (void)testUnSelectAllChildren {
    // - (void)unSelectAllChildren 
    
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	// test1 - input to output
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	// test1 - input to nested input
	SHParent* node1 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:node1 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[node1 addChild:atChild3 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	[parent addChildToSelection:atChild1];
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:int1];
	[parent addChildToSelection:int2];
    
	NSArray* selected = [parent selectedChildren];
	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed");
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent unSelectAllChildren];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	selected = [parent selectedChildren];
	STAssertTrue([selected count]==0, @"testUnSelectAllChildNodes failed");
	
	STAssertTrue( nodeSelectionChanged==0, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==1, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==1, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==1, @"what happened? %i", icSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==0, @"testUnSelectAllChildNodes failed");
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

- (void)testUnSelectAllChildNodes {
    // - (void)unSelectAllChildNodes
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	// test1 - input to output
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	// test1 - input to nested input
	SHParent* node1 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:node1 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[node1 addChild:atChild3 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	[parent addChildToSelection:node1];
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:int1];
	[parent addChildToSelection:int2];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent unSelectAllChildNodes];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSArray* selected = [parent selectedChildren];
	STAssertTrue([selected count]==3, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==0, @"what happened? %i", icSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==3, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

- (void)testUnSelectAllInputs {
	// - (void)unSelectAllChildInputs
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	// test1 - input to output
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	
	// test1 - input to nested input
	SHParent* node1 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:node1 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[node1 addChild:atChild3 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	[parent addChildToSelection:node1];
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:int1];
	[parent addChildToSelection:atChild1];
	[parent addChildToSelection:int2];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent unSelectAllChildInputs];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSArray* selected = [parent selectedChildren];
	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
	STAssertTrue( nodeSelectionChanged==0, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==1, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==0, @"what happened? %i", icSelectionChanged);
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==5, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

// - (void)unSelectAllChildOutputs
- (void)testUnSelectAllChildOutputs {
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	// test1 - input to output
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	// test1 - input to nested input
	SHParent* node1 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:node1 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[node1 addChild:atChild3 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	[parent addChildToSelection:node1];
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:int1];
	[parent addChildToSelection:atChild1];
	[parent addChildToSelection:int2];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent unSelectAllChildOutputs];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSArray* selected = [parent selectedChildren];
	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed %i", [selected count]);
	STAssertTrue( nodeSelectionChanged==0, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==1, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==0, @"what happened? %i", icSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==5, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedChildren];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==4, @"testUnSelectAllChildNodes failed %i", [selected count]);
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

- (void)testUnSelectAllChildInterConnectors {
	// - (void)unSelectAllChildInterConnectors 
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	// test1 - input to output
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	// test1 - input to nested input
	SHParent* node1 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:node1 atIndex:-1 undoManager:um];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[node1 addChild:atChild3 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	
	//	check that the interconnector is in parent
	SHOrderedDictionary* childInterConnectors = [parent shInterConnectorsInside];
	STAssertTrue([childInterConnectors count]==2, @"unSelectAllChildInterConnectors failed");
	[parent unSelectAllChildren];
	[parent addChildToSelection:int1];
	[parent addChildToSelection:int2];
	NSArray* selected = [parent selectedChildInterConnectors];
	STAssertTrue([selected count]==2, @"unSelectAllChildInterConnectors failed");
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent unSelectAllChildInterConnectors];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	selected = [parent selectedChildInterConnectors];
	STAssertTrue([selected count]==0, @"unSelectAllChildInterConnectors failed");
	
	STAssertTrue( nodeSelectionChanged==0, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==1, @"what happened? %i", icSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedChildInterConnectors];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==2, @"unSelectAllChildInterConnectors failed %i", [selected count]);
    
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedChildInterConnectors];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==0, @"unSelectAllChildInterConnectors failed");
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

- (void)testSelectedChildNodes {
	// - (NSArray *)selectedChildNodes

	SHParent* atChild1 = [SHParent makeChildWithName:@"n1"];
	SHParent* atChild2 = [SHParent makeChildWithName:@"n2"];
	SHParent* atChild3 = [SHParent makeChildWithName:@"n3"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:atChild3];
	
	[self resetObservers];
	NSArray *selected = [parent selectedChildNodes];
	STAssertTrue( [selected count]==2, @"selectedChildNodes failed %i", [selected count]);
}

- (void)testSelectedChildInputs {
	// - (NSArray *)selectedChildInputs

	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];

	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];

	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:atChild3];

	[self resetObservers];
	NSArray *selected = [parent selectedChildInputs];
	STAssertTrue( [selected count]==2, @"selectedChildInputs failed %i", [selected count]);
}

- (void)testSelectedChildOutputs {
	// - (NSArray *)selectedChildOutputs

	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:atChild3];
	
	[self resetObservers];
	NSArray *selected = [parent selectedChildOutputs];
	STAssertTrue( [selected count]==2, @"selectedChildOutputs failed %i", [selected count]);
}

- (void)testSelectedChildInterConnectors {
	// - (NSArray *)selectedChildInterConnectors

	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild4 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild5 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild6 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	[parent addChild:atChild5 atIndex:-1 undoManager:um];
	[parent addChild:atChild6 atIndex:-1 undoManager:um];	

	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)atChild1 andInletOfAtt:(SHProtoAttribute *)atChild4 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)atChild2 andInletOfAtt:(SHProtoAttribute *)atChild5 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)atChild3 andInletOfAtt:(SHProtoAttribute *)atChild6 undoManager:um];
	
	// SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild4];	
	SHInterConnector* int2 = [parent interConnectorFor:atChild2 and:atChild5];	
	SHInterConnector* int3 = [parent interConnectorFor:atChild3 and:atChild6];
	
	[parent addChildToSelection:int2];
	[parent addChildToSelection:int3];

	[self resetObservers];
	NSArray *selected = [parent selectedChildInterConnectors];
	STAssertTrue( [selected count]==2, @"selectedChildOutputs failed %i", [selected count]);
}

- (void)testSelectedNodesInsideIndexes {
	// - (NSMutableIndexSet *)selectedNodesInsideIndexes

	SHParent* atChild1 = [SHParent makeChildWithName:@"n1"];
	SHParent* atChild2 = [SHParent makeChildWithName:@"n2"];
	SHParent* atChild3 = [SHParent makeChildWithName:@"n3"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:atChild3];
	
	[self resetObservers];
	NSMutableIndexSet *selected = [parent selectedNodesInsideIndexes];
	STAssertTrue( [selected count]==2, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:0]==NO, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:1]==YES, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:2]==YES, @"selectedChildInputs failed %i", [selected count]);
}

- (void)testSelectedInputIndexes {
	// - (NSMutableIndexSet *)selectedInputIndexes

	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:atChild3];
	
	[self resetObservers];
	NSMutableIndexSet *selected = [parent selectedInputIndexes];
	STAssertTrue( [selected count]==2, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:0]==NO, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:1]==YES, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:2]==YES, @"selectedChildInputs failed %i", [selected count]);
}

- (void)testSelectedOutputIndexes {
	// - (NSMutableIndexSet *)selectedOutputIndexes


	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	
	[parent addChildToSelection:atChild2];
	[parent addChildToSelection:atChild3];
	
	[self resetObservers];
	NSMutableIndexSet *selected = [parent selectedOutputIndexes];
	STAssertTrue( [selected count]==2, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:0]==NO, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:1]==YES, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:2]==YES, @"selectedChildInputs failed %i", [selected count]);
}

- (void)testSelectedInterConnectorIndexes {
	// - (NSMutableIndexSet *)selectedInterConnectorIndexes

	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild4 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild5 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild6 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	[parent addChild:atChild5 atIndex:-1 undoManager:um];
	[parent addChild:atChild6 atIndex:-1 undoManager:um];	
	
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)atChild1 andInletOfAtt:(SHProtoAttribute *)atChild4 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)atChild2 andInletOfAtt:(SHProtoAttribute *)atChild5 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)atChild3 andInletOfAtt:(SHProtoAttribute *)atChild6 undoManager:um];
	
	// SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild4];	
	SHInterConnector* int2 = [parent interConnectorFor:atChild2 and:atChild5];	
	SHInterConnector* int3 = [parent interConnectorFor:atChild3 and:atChild6];
	
	[parent addChildToSelection:int2];
	[parent addChildToSelection:int3];
	
	[self resetObservers];
	NSMutableIndexSet *selected = [parent selectedInterConnectorIndexes];
	STAssertTrue( [selected count]==2, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:0]==NO, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:1]==YES, @"selectedChildInputs failed %i", [selected count]);
	STAssertTrue( [selected containsIndex:2]==YES, @"selectedChildInputs failed %i", [selected count]);
}

#pragma mark setting indexes
- (void)testSetSelectedNodesInsideIndexes {
    // - (void)setSelectedNodesInsideIndexes:(NSMutableIndexSet *)value;
    
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode2 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode3 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:childnode2 atIndex:-1 undoManager:um];
	[parent addChild:childnode3 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
	NSMutableIndexSet* selectedNodeIndexes = [NSMutableIndexSet indexSetWithIndex:0];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent setSelectedNodesInsideIndexes:selectedNodeIndexes];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
	
	NSMutableIndexSet* selected = [parent selectedNodesInsideIndexes];
	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed");
	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[parent clearRecordedHits];
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	BOOL hitRecordResult1 = [parent assertRecordsIs:@"_setSelectionForStorage:newSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings1 = [parent recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
	
    //NotUsingUndoInSelection	selected = [parent selectedNodesInsideIndexes];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==0, @"testsetSelectedNodeAndAttributeIndexes failed");
	
	/* Redo */
    //NotUsingUndoInSelection	[parent clearRecordedHits];
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	BOOL hitRecordResult2 = [parent assertRecordsIs:@"_setSelectionForStorage:newSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings2 = [parent recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult2, @"That is what happened %@", actualRecordings2);
	
    //NotUsingUndoInSelection	selected = [parent selectedNodesInsideIndexes];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed");
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
}

- (void)testSetSelectedInputIndexes {
    // - (void)setSelectedInputIndexes:(NSMutableIndexSet *)value
	
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	
	NSMutableIndexSet* selectedNodeIndexes = [NSMutableIndexSet indexSetWithIndex:0];
	[self resetObservers];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent setSelectedInputIndexes:selectedNodeIndexes];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSMutableIndexSet* selected = [parent selectedInputIndexes];
	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed");
	STAssertTrue( inputSelectionChanged==1, @"what happened? %i", inputSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedInputIndexes];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==0, @"testsetSelectedNodeAndAttributeIndexes failed");
	
	/* Redo */
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedInputIndexes];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed");
	
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
}

- (void)testSetSelectedOutputIndexes {
    // - (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value
	
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
	NSMutableIndexSet* selectedNodeIndexes = [NSMutableIndexSet indexSetWithIndex:0];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent setSelectedOutputIndexes:selectedNodeIndexes];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSMutableIndexSet* selected = [parent selectedOutputIndexes];
	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed");
	STAssertTrue( outputSelectionChanged==1, @"what happened? %i", outputSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	selected = [parent selectedOutputIndexes];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==0, @"testsetSelectedNodeAndAttributeIndexes failed");
    
	/* Redo */
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selected = [parent selectedOutputIndexes];
    //NotUsingUndoInSelection	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed");
	
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
}

- (void)testSetSelectedInterConnectorIndexes {
    // - (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value
	
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	[parent _makeSHInterConnectorBetweenOutletOf:atChild2 andInletOfAtt:atChild1 undoManager:nil];
	SHInterConnector* int3 = [parent interConnectorFor:atChild2 and:atChild1];
	STAssertNotNil(int1, @"eh");
	STAssertNotNil(int3, @"eh");
	[parent unSelectAllChildren];
	[self resetObservers];
	
	NSMutableIndexSet *selectedIndexes = [NSMutableIndexSet indexSetWithIndex:1];
	
	/* Test Undo */
    //NotUsingUndoInSelection	[_um beginDebugUndoGroup];
    [parent setSelectedInterConnectorIndexes: selectedIndexes];
    //NotUsingUndoInSelection	[_um endUndoGrouping];
    
	NSArray* selectedChildInterConnectors = [parent selectedChildInterConnectors];
	STAssertTrue([selectedChildInterConnectors count]==1, @"er");
	STAssertTrue([selectedChildInterConnectors objectAtIndex:0]==int2, @"er");
	STAssertTrue( icSelectionChanged==1, @"what happened? %i", icSelectionChanged);
	
	/* Undo */
    //NotUsingUndoInSelection	[parent clearRecordedHits];
    //NotUsingUndoInSelection	[_um undo];
    //NotUsingUndoInSelection	BOOL hitRecordResult1 = [parent assertRecordsIs:@"_setSelectionForStorage:newSelection:", nil];
    //NotUsingUndoInSelection	NSMutableArray *actualRecordings1 = [parent recordedSelectorStrings];
    //NotUsingUndoInSelection	STAssertTrue(hitRecordResult1, @"That is what happened %@", actualRecordings1);
    
    //NotUsingUndoInSelection	selectedChildInterConnectors = [parent selectedChildInterConnectors];
    //NotUsingUndoInSelection	STAssertTrue([selectedChildInterConnectors count]==0, @"er %i", [selectedChildInterConnectors count]);
    
	/* Redo */
    //NotUsingUndoInSelection	[_um redo];
    //NotUsingUndoInSelection	selectedChildInterConnectors = [parent selectedChildInterConnectors];
    //NotUsingUndoInSelection	STAssertTrue([selectedChildInterConnectors count]==1, @"er");
	
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

#pragma mark adding indexes
- (void)testAddNodesToSelection {
	//- (void)addNodesToSelection:(NSArray *)values
	
	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode2 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode3 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:childnode2 atIndex:-1 undoManager:um];
	[parent addChild:childnode3 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
	[parent setSelectedNodesInsideIndexes:[NSMutableIndexSet indexSetWithIndex:0]];
	[parent addNodesToSelection:[NSSet setWithObjects:childnode2, childnode3, nil]];
	
	NSMutableIndexSet* selected = [parent selectedNodesInsideIndexes];
	STAssertTrue([selected count]==3, @"testsetSelectedNodeAndAttributeIndexes failed");
	STAssertTrue( nodeSelectionChanged==2, @"what happened? %i", nodeSelectionChanged);

	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
}

- (void)testAddInputsToSelection {
	//- (void)addInputsToSelection:(NSArray *)values
	
	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild4 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];

	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];

	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
    [parent setSelectedInputIndexes:[NSMutableIndexSet indexSetWithIndex:0]];
	[parent addInputsToSelection:[NSSet setWithObjects:atChild3, atChild4, nil]];

	NSMutableIndexSet* selected = [parent selectedInputIndexes];
	STAssertTrue([selected count]==3, @"testsetSelectedNodeAndAttributeIndexes failed");
	STAssertTrue( inputSelectionChanged==2, @"what happened? %i", inputSelectionChanged);

	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
}

- (void)testAddOutputsToSelection {
	//- (void)addOutputsToSelection:(NSArray *)values
	
	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild4 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	SHProtoInputAttribute* atChild2 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];

	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
    [parent setSelectedOutputIndexes:[NSMutableIndexSet indexSetWithIndex:0]];
	[parent addOutputsToSelection:[NSSet setWithObjects:atChild3, atChild4, nil]];
    
	NSMutableIndexSet* selected = [parent selectedOutputIndexes];
	STAssertTrue([selected count]==3, @"testsetSelectedNodeAndAttributeIndexes failed");
	STAssertTrue( outputSelectionChanged==2, @"what happened? %i", outputSelectionChanged);
	
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
}

- (void)testAddICsToSelection {
	//- (void)addICsToSelection:(NSArray *)values
	
	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];

	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild4 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];

	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];

	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild4 undoManager:nil];
	SHInterConnector* int3 = [parent interConnectorFor:atChild1 and:atChild4];
	
	STAssertNotNil(int1, @"eh");
	STAssertNotNil(int2, @"eh");
	STAssertNotNil(int3, @"eh");
	[parent unSelectAllChildren];
	[self resetObservers];
		
    [parent setSelectedInterConnectorIndexes: [NSMutableIndexSet indexSetWithIndex:1]];
	[parent addICsToSelection:[NSSet setWithObjects:int1, int3, nil]];
    
	NSArray* selectedChildInterConnectors = [parent selectedChildInterConnectors];
	STAssertTrue([selectedChildInterConnectors count]==3, @"er %i", [selectedChildInterConnectors count] );
	STAssertTrue([selectedChildInterConnectors objectAtIndex:0]==int1, @"er");
	STAssertTrue( icSelectionChanged==2, @"what happened? %i", icSelectionChanged);
	
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

#pragma mark removing
- (void)testRemoveNodesFromSelection {
	// - (void)removeNodesFromSelection:(NSSet *)values

	[parent addObserver:self forKeyPath:@"childContainer.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode2 = [SHParent makeChildWithName:@"n1"];
	SHParent* childnode3 = [SHParent makeChildWithName:@"n1"];
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:childnode2 atIndex:-1 undoManager:um];
	[parent addChild:childnode3 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
	[parent setSelectedNodesInsideIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	[parent removeNodesFromSelection:[NSSet setWithObjects:childnode2, childnode3, nil]];
	
	NSMutableIndexSet* selected = [parent selectedNodesInsideIndexes];
	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed %i", [selected count]);
	STAssertTrue( nodeSelectionChanged==2, @"what happened? %i", nodeSelectionChanged);
	
	[parent removeObserver:self forKeyPath:@"childContainer.nodesInside.selection"];
}

- (void)testRemoveInputsFromSelection {
	// - (void)removeInputsFromSelection:(NSSet *)values

	[parent addObserver:self forKeyPath:@"childContainer.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild4 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
		
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
    [parent setSelectedInputIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	[parent removeInputsFromSelection:[NSSet setWithObjects:atChild3, atChild4, nil]];
	
	NSMutableIndexSet* selected = [parent selectedInputIndexes];
	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed %i", [selected count]);
	STAssertTrue( inputSelectionChanged==2, @"what happened? %i", inputSelectionChanged);
	
	[parent removeObserver:self forKeyPath:@"childContainer.inputs.selection"];
}

- (void)testRemoveOutputsFromSelection {
	// - (void)removeOutputsFromSelection:(NSSet *)values

	[parent addObserver:self forKeyPath:@"childContainer.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoOutputAttribute* atChild1 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild3 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild4 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
		
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	[parent unSelectAllChildren];
	[self resetObservers];
	
    [parent setSelectedOutputIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	[parent removeOutputsFromSelection:[NSSet setWithObjects:atChild3, atChild4, nil]];
    
	NSMutableIndexSet* selected = [parent selectedOutputIndexes];
	STAssertTrue([selected count]==1, @"testsetSelectedNodeAndAttributeIndexes failed %i", [selected count]);
	STAssertTrue( outputSelectionChanged==2, @"what happened? %i", outputSelectionChanged);
	
	[parent removeObserver:self forKeyPath:@"childContainer.outputs.selection"];
}

- (void)testRemoveICsFromSelection {
	// - (void)removeICsFromSelection:(NSSet *)values

	[parent addObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHParent_SelectionTests"];
	
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoInputAttribute* atChild3 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild4 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	[parent addChild:atChild3 atIndex:-1 undoManager:um];
	[parent addChild:atChild4 atIndex:-1 undoManager:um];
	
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];
	
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild3 undoManager:nil];
	SHInterConnector* int2 = [parent interConnectorFor:atChild1 and:atChild3];
	
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild4 undoManager:nil];
	SHInterConnector* int3 = [parent interConnectorFor:atChild1 and:atChild4];
	
	STAssertNotNil(int1, @"eh");
	STAssertNotNil(int2, @"eh");
	STAssertNotNil(int3, @"eh");
	[parent unSelectAllChildren];
	[self resetObservers];
	
    [parent setSelectedInterConnectorIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	[parent removeICsFromSelection:[NSSet setWithObjects:int1, int3, nil]];
    
	NSArray* selectedChildInterConnectors = [parent selectedChildInterConnectors];
	STAssertTrue([selectedChildInterConnectors count]==1, @"er %i", [selectedChildInterConnectors count] );
	STAssertTrue([selectedChildInterConnectors objectAtIndex:0]==int2, @"er");
	STAssertTrue( icSelectionChanged==2, @"what happened? %i", icSelectionChanged);
	
	[parent removeObserver:self forKeyPath:@"childContainer.shInterConnectorsInside.selection"];
}

- (void)testHasSelection {
	//- (BOOL)hasSelection
	
	SHParent* childnode1 = [SHParent makeChildWithName:@"n1"];
	SHProtoInputAttribute* atChild1 = [SHProtoInputAttribute attributeWithType:@"mockDataType"];
	SHProtoOutputAttribute* atChild2 = [SHProtoOutputAttribute attributeWithType:@"mockDataType"];
	
	[parent addChild:childnode1 atIndex:-1 undoManager:um];
	[parent addChild:atChild1 atIndex:-1 undoManager:um];
	[parent addChild:atChild2 atIndex:-1 undoManager:um];
	
	[parent _makeSHInterConnectorBetweenOutletOf:atChild1 andInletOfAtt:atChild2 undoManager:nil];
	SHInterConnector* int1 = [parent interConnectorFor:atChild1 and:atChild2];

	[parent unSelectAllChildren];
	STAssertFalse([parent hasSelection], @"die hard");
	[parent setSelectedChildren:[NSArray arrayWithObject:childnode1]];
	STAssertTrue([parent hasSelection], @"die hard");
	[parent unSelectAllChildren];
	[parent setSelectedChildren:[NSArray arrayWithObject:atChild1]];
	STAssertTrue([parent hasSelection], @"die hard");
	[parent unSelectAllChildren];
	[parent setSelectedChildren:[NSArray arrayWithObject:atChild2]];
	STAssertTrue([parent hasSelection], @"die hard");
	[parent unSelectAllChildren];
	STAssertFalse([parent hasSelection], @"die hard");
	[parent setSelectedChildren:[NSArray arrayWithObject:int1]];
	STAssertTrue([parent hasSelection], @"die hard");
}

@end
