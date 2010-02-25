//
//  SHNodeSelectingMethodsTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/09/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHNodeGraph.h"

@interface SHNodeSelectingMethodsTests : SenTestCase {
    
    SHNodeGraphModel	*_nodeGraphModel;
	NSUndoManager		*_um;
	
	/* Experimental ArrayController binding tests */
	id testSHNode;
}

@end

static int nodeSelectionChanged, inputSelectionChanged, outputSelectionChanged, icSelectionChanged;

@implementation SHNodeSelectingMethodsTests

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
	
    if( [cntxt isEqualToString:@"SHNodeSelectingMethodsTests"] )
	{
		if ([keyPath isEqualToString:@"rootNodeGroup.nodesInside.selection"]) {
			nodeSelectionChanged++;
		} else if ([keyPath isEqual:@"rootNodeGroup.inputs.selection"]) {
			inputSelectionChanged++;
		} else if ([keyPath isEqual:@"rootNodeGroup.outputs.selection"]) {
			outputSelectionChanged++;
		} else if ([keyPath isEqual:@"rootNodeGroup.shInterConnectorsInside.selection"]) {
			icSelectionChanged++;
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
    
	[_um setGroupsByEvent:YES];
	[_um removeAllActions];
	[_um release];
	
	[_nodeGraphModel release];
}







- (void)testAddChildrenToSelection {
    //- (void)addChildrenToSelection:(NSArray *)children
    
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode1 = [SHNode makeChildWithName:@"n1"];
	SHNode* childnode2 = [SHNode makeChildWithName:@"n2"];
	[_nodeGraphModel NEW_addChild:childnode1 toNode:root];
	[_nodeGraphModel NEW_addChild:childnode2 toNode:root];
	[root unSelectAllChildren];
	[self resetObservers];

	/* We don't USE UNDO in selections */
    [root addChildrenToSelection:[NSArray arrayWithObjects:childnode1, childnode2, nil]];
    
	NSArray* selectedChildren = [root selectedChildren];
	STAssertTrue([selectedChildren count]==2, @"er");
	STAssertTrue([selectedChildren containsObject:childnode1], @"er");
	STAssertTrue([selectedChildren containsObject:childnode2], @"er");

	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==0, @"what happened? %i", icSelectionChanged);
	
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.inputs.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.outputs.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.shInterConnectorsInside.selection"];
}

- (void)testRemoveChildrenFromSelection {
    // - (void)removeChildrenFromSelection:(NSArray *)children

	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.inputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.outputs.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	[_nodeGraphModel addObserver:self forKeyPath:@"rootNodeGroup.shInterConnectorsInside.selection" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SHNodeSelectingMethodsTests"];
	
	SHNode* root = [_nodeGraphModel rootNodeGroup];	
	SHNode* childnode1 = [SHNode makeChildWithName:@"n1"];
	SHNode* childnode2 = [SHNode makeChildWithName:@"n2"];
	[_nodeGraphModel NEW_addChild:childnode1 toNode:root];
	[_nodeGraphModel NEW_addChild:childnode2 toNode:root];
	[root addChildrenToSelection:[NSArray arrayWithObjects:childnode1, childnode2, nil]];
   	[self resetObservers];
 
	/* We don't USE UNDO in selections */
    [root removeChildrenFromSelection:[NSArray arrayWithObjects:childnode2, nil]];
    
	NSArray* selectedChildren = [root selectedChildren];
	STAssertTrue([selectedChildren count]==1, @"er");
	STAssertTrue([selectedChildren containsObject:childnode1], @"er");
	STAssertFalse([selectedChildren containsObject:childnode2], @"er");

	STAssertTrue( nodeSelectionChanged==1, @"what happened? %i", nodeSelectionChanged);
	STAssertTrue( inputSelectionChanged==0, @"what happened? %i", inputSelectionChanged);
	STAssertTrue( outputSelectionChanged==0, @"what happened? %i", outputSelectionChanged);
	STAssertTrue( icSelectionChanged==0, @"what happened? %i", icSelectionChanged);
	
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.nodesInside.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.inputs.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.outputs.selection"];
	[_nodeGraphModel removeObserver:self forKeyPath:@"rootNodeGroup.shInterConnectorsInside.selection"];
}






@end
