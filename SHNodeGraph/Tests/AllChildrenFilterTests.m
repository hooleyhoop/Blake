//
//  AllChildrenFilterTests.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/05/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "AbtractModelFilter.h"
#import "MockProducer.h"
#import "MockConsumer.h"
#import "MockProcessor.h"
#import "DelayedNotificationCoalescer.h"
#import "AllChildrenProxyFactory.h"
#import "SHParent_Selection.h"
#import "AllChildProxy.h"

static NSUInteger _willInsertContent, _didInsertContent, _willRemoveContent, _didRemoveContent, _willChangeSelection, _didChangeSelection;

@interface AllChildrenFilterTests : SenTestCase <SHContentProviderUserProtocol> {
	
	SHNodeGraphModel		*_model;
	AllChildrenFilter		*_childProvider;
	
	NSArray					*_insertedItems, *_removedItems;
	NSIndexSet				*_insertedItemsIndexes, *_removedItemsIndexes, *_selectionIndexes, *_newlySelectedIndexes, *_newlyDeselectedIndexes;
}

@end


@implementation AllChildrenFilterTests

#pragma mark setup
- (void)resetStuff {

	_willInsertContent = 0;
	_didInsertContent = 0;
	_willRemoveContent = 0;
	_didRemoveContent = 0;
	_willChangeSelection = 0;
	_didChangeSelection = 0;
}

- (void)setUp {
	
	_model = [[SHNodeGraphModel makeEmptyModel] retain];
	
	_childProvider = [[AllChildrenFilter alloc] init];
	
	/* lets begin with some content in the model to verify it picks it up */
//	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"];
//	MockProducer *graphic1 = [MockProducer makeChildWithName:@"grap1"];
//	[ng1 addChild:graphic1 undoManager:nil];
//	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
    [_childProvider setModel:_model];
	
	[_childProvider registerAUser:self];
	
//	// check the initial proxy tree
//	STAssertTrue( [_childProvider.rootNodeProxy.filteredContent count]==1, @"%i", [_childProvider.rootNodeProxy.filteredContent count] );
//	NodeProxy *child1 = [_childProvider.rootNodeProxy.filteredContent objectAtIndex:0];
//	STAssertTrue( child1.originalNode == ng1, @"should be %@", child1.originalNode.name );
//	STAssertTrue( [child1.filteredContent count]==1, @"%i", [child1.filteredContent count] );
//	NodeProxy *child2_1 = [child1.filteredContent objectAtIndex:0];
//	STAssertTrue( child2_1.originalNode == graphic1, @"should be");
//	
//	STAssertTrue(_childProvider.rootNodeProxy.isObservingChildren, @"Doh");
//	STAssertTrue(child1.isObservingChildren, @"Doh");
	
	
	//	[_childProvider addObserver:self forKeyPath:@"filteredContent" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"AllChildrenFilterTests"];
	// 	[_childProvider addObserver:self forKeyPath:@"filteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"AllChildrenFilterTests"];
}

- (void)tearDown {

	[self resetStuff];

	[_childProvider unRegisterAUser:self];

	[_childProvider cleanUpFilter];	
	// 	[_childProvider removeObserver:self forKeyPath:@"filteredContentSelectionIndexes"];
	//	[_childProvider removeObserver:self forKeyPath:@"filteredContent"];
	[_childProvider release];
	[_model.undoManager removeAllActions];
	[_model release];
	
	[_insertedItems release];
	[_insertedItemsIndexes release];
	[_selectionIndexes release]; 
	[_newlySelectedIndexes release]; 
	[_newlyDeselectedIndexes release]; 
	[_removedItems release]; 
	[_removedItemsIndexes release]; 
	
	_insertedItems = nil;
	_insertedItemsIndexes = nil;
	_selectionIndexes = nil;
	_newlySelectedIndexes = nil;
	_newlyDeselectedIndexes = nil;
	_removedItems = nil;
	_removedItemsIndexes = nil;
}

- (void)addTestNodes {
    
	SHNode *root = _model.rootNodeGroup;
	
	SHNode *ng2 = [SHNode makeChildWithName:@"nodeGroup2"], *ng3 = [SHNode makeChildWithName:@"nodeGroup3"], *ng4 = [SHNode makeChildWithName:@"nodeGroup4"];
	SHInputAttribute *i1 = [SHInputAttribute makeChildWithName:@"i1"], *i2 = [SHInputAttribute makeChildWithName:@"i2"], *i3 = [SHInputAttribute makeChildWithName:@"i3"];
	SHOutputAttribute *o1 = [SHOutputAttribute makeChildWithName:@"o1"], *o2 = [SHOutputAttribute makeChildWithName:@"o2"], *o3 = [SHOutputAttribute makeChildWithName:@"o3"];

	[_model insertGraphics:[NSArray arrayWithObjects:ng2,ng3,ng4,nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	[_model insertGraphics:[NSArray arrayWithObjects:i1,i2,i3,nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
	[_model insertGraphics:[NSArray arrayWithObjects:o1,o2,o3,nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];

	//TODO: woah! we don't have a way to make multiple connections? we need a way.
	[_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	[_model connectOutletOfAttribute:i2 toInletOfAttribute:o2];
	[_model connectOutletOfAttribute:i3 toInletOfAttribute:o3];
}

#pragma mark callbacks
static AbtractModelFilter *filt;
- (AbtractModelFilter *)filter {
	return filt;
}

- (void)setFilter:(AbtractModelFilter *)value {
	filt = value;
}

/* content */
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
	
	[NSException raise:@"should we ever get here?" format:@""];
	// _willChangeContent++;
}
- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	[NSException raise:@"should we ever get here?" format:@""];

//	_didChangeContent++;
//	
//	[_changedItems release];
//	[_changedItemsIndexes release];
//	_changedItems = [values retain];
//	_changedItemsIndexes = [indexes retain];
}

- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {

	_willInsertContent++;
}

- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {

	_didInsertContent++;

	[_insertedItems release];
	[_insertedItemsIndexes release];
	_insertedItems = [proxiesForsuccessFullObjects retain];
	_insertedItemsIndexes = [indexes retain];
}

- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	_willRemoveContent++;
}

- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	_didRemoveContent++;
	[_removedItems release]; 
	[_removedItemsIndexes release];
	_removedItems = [values retain];
	_removedItemsIndexes = [indexes retain];
}

/* selection */
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {

	_willChangeSelection++;
}

// bear in mind that indexesOfSelectedObjectsThatPassFilter is actually an array and the changed indexes are actually the first item
- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {
	
	NSParameterAssert(proxy);
	NSAssert1( [indexesOfSelectedObjectsThatPassFilter count]==3, @"i though we hacked this %i", [indexesOfSelectedObjectsThatPassFilter count] );

	_didChangeSelection++;
	[_selectionIndexes release];
	[_newlySelectedIndexes release];
	[_newlyDeselectedIndexes release];
	_selectionIndexes = [[(NSArray *)indexesOfSelectedObjectsThatPassFilter objectAtIndex:0] retain];
	_newlySelectedIndexes = [[(NSArray *)indexesOfSelectedObjectsThatPassFilter objectAtIndex:1] retain];
	_newlyDeselectedIndexes = [[(NSArray *)indexesOfSelectedObjectsThatPassFilter objectAtIndex:2] retain];
}

#pragma mark Tests 
- (void)testBasics {

	[_childProvider makeFilteredTreeUpToDate:_childProvider.rootNodeProxy];
	
	/* add objects */
	SHNode* childnode = [SHNode makeChildWithName:@"n1"];
	[_model NEW_addChild:childnode toNode:_model.rootNodeGroup];
	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"i1"];
	SHOutputAttribute* o1 = [SHOutputAttribute makeChildWithName:@"o1"];
	
	[_model NEW_addChild:i1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:o1 toNode:_model.rootNodeGroup];
	

	SHInterConnector* int1 = [_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	//- check that we got notified
	STAssertTrue([_insertedItems count]==4, @"wha? %i", [_insertedItems count]); // inserted {childnode,i1,o1, int1}
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:0] originalNode]==(id)childnode, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:1] originalNode]==(id)i1, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:2] originalNode]==(id)o1, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:3] originalNode]==(id)int1, @"wha?");

	STAssertTrue([_insertedItemsIndexes count]==4, @"wha? %i", [_insertedItemsIndexes count]);// at indexes 0,1,2,3
	STAssertTrue([_insertedItemsIndexes containsIndex:0], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:1], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:2], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:3], @"wha?");
}

/* lets get down to the meat and veg instead of this added stuff to the model crap */
//- (void)testModelChanged_NodesInside_to {
//	// - (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue;
//	
//	// ng1 ¬
//	//	-- graphic1
//	//	-- ng2 ¬
//	//		-- graphic2
//	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"], *ng2 = [SHNode makeChildWithName:@"ng2"];
//	MockProducer *graphic1 = [MockProducer makeChildWithName:@"graphic1"], *graphic2 = [MockProducer makeChildWithName:@"graphic2"];
//	[ng1 addChild:graphic1 undoManager:nil];
//	[ng2 addChild:graphic2 undoManager:nil];
//	[ng1 addChild:ng2 undoManager:nil];
//	
//	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_childProvider object:ng1];
//	// update
//	[_childProvider makeFilteredTreeUpToDate:rootProxy]; 
//	
//	
//	// we will swap in this stuff and check that all levels are reflected in the filtered model and that all observancies are correct
//	// ng1 ¬
//	//	-- r_audio1
//	//	-- r_graphic1
//	//	-- r_ng2 ¬
//	//		-- r_audio2
//	//		-- r_audio3
//	//		-- r_ng3
//	SHNode *r_ng2=[SHNode makeChildWithName:@"r_ng2"], *r_ng3=[SHNode makeChildWithName:@"r_ng3"];
//	MockProducer *r_graphic1=[MockProducer makeChildWithName:@"r_graphic1"];
//	MockConsumer *r_audio1=[MockConsumer makeChildWithName:@"r_audio1"], *r_audio2=[MockConsumer makeChildWithName:@"r_audio2"], *r_audio3=[MockConsumer makeChildWithName:@"r_audio3"];
//	
//	[r_ng2 addChild:r_audio2 undoManager:nil];
//	[r_ng2 addChild:r_audio3 undoManager:nil];
//	[r_ng2 addChild:r_ng3 undoManager:nil];
//	
//	NSArray *newNodesInside = [NSArray arrayWithObjects: r_audio1, r_graphic1, r_ng2, nil];
//	
//	[rootProxy startObservingOriginalNode];
//	[_childProvider modelChanged:rootProxy nodesInside_to:newNodesInside from:nil]; // from isn't used at the moment
//	
//	/* check the objects inside */
//	STAssertTrue( [rootProxy.filteredContent count]==2, @"%i", [rootProxy.filteredContent count] );
//	NodeProxy *child1 = [rootProxy.filteredContent objectAtIndex:0];
//	NodeProxy *child2 = [rootProxy.filteredContent objectAtIndex:1];
//	STAssertTrue( child1.originalNode == r_graphic1, @"should be %@", child1.originalNode.name );
//	STAssertTrue( child2.originalNode == r_ng2, @"should be %@", child2.originalNode.name);
//	STAssertTrue( [child1.filteredContent count]==0, @"%i", [child1.filteredContent count] );
//	STAssertTrue( [child2.filteredContent count]==1, @"%i", [child2.filteredContent count] );
//	NodeProxy *child2_1 = [child2.filteredContent objectAtIndex:0];
//	STAssertTrue( child2_1.originalNode == r_ng3, @"should be");
//	
//	/* check the indexes inside */
//	STAssertTrue( [rootProxy.indexesOfFilteredContent count]==2, @"%i", [rootProxy.indexesOfFilteredContent count] );
//	STAssertTrue( [rootProxy.indexesOfFilteredContent firstIndex]==1, @"%i", [rootProxy.indexesOfFilteredContent firstIndex] );
//	STAssertTrue( [child1.indexesOfFilteredContent count]==0, @"%i", [child1.indexesOfFilteredContent count] );
//	STAssertTrue( [child2.indexesOfFilteredContent count]==1, @"%i", [child2.indexesOfFilteredContent count] );
//	STAssertTrue( [child2.indexesOfFilteredContent firstIndex]==2, @"%i", [child2.indexesOfFilteredContent firstIndex] );
//	
//	/* check that observations have been set */
//	STAssertTrue( [rootProxy isObservingChildren]==YES, @"%i", [rootProxy isObservingChildren] );
//	STAssertTrue( [child1 isObservingChildren]==NO, @"%i", [child1 isObservingChildren] );
//	STAssertTrue( [child2 isObservingChildren]==YES, @"%i", [child2 isObservingChildren] );
//	STAssertTrue( [child2_1 isObservingChildren]==YES, @"%i", [child2_1 isObservingChildren] );
//	
//	/* How many notifications were received? */
//	//ng1 ¬				2
//	//	-- r_audio1		0
//	//	-- r_graphic1	1
//	//	-- r_ng2 ¬		1
//	//		-- r_audio2	0
//	//		-- r_audio3	0
//	//		-- r_ng3	1
//	
//	//V2
//	STAssertTrue( [rootProxy debug_arrayNotificationsReceivedCount]==0, @"%i", [rootProxy debug_arrayNotificationsReceivedCount] );
//	STAssertTrue( [child1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child1 debug_arrayNotificationsReceivedCount] );
//	STAssertTrue( [child2 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2 debug_arrayNotificationsReceivedCount] );
//	STAssertTrue( [child2_1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2_1 debug_arrayNotificationsReceivedCount] );
//	[rootProxy stopObservingOriginalNode];
//}

// which keypaths of the model does the filter observe?
- (void)testModelKeyPathsToObserve {
// + (NSArray *)modelKeyPathsToObserve
	
	NSArray *mk = [AllChildrenFilter modelKeyPathsToObserve];
	
	STAssertTrue( [[mk objectAtIndex:0] isEqualToString:@"childContainer.nodesInside.array"], @"should be %@", [mk objectAtIndex:0] );
	STAssertTrue( [[mk objectAtIndex:1] isEqualToString:@"childContainer.inputs.array"], @"should be" );
	STAssertTrue( [[mk objectAtIndex:2] isEqualToString:@"childContainer.outputs.array"], @"should be" );
	STAssertTrue( [[mk objectAtIndex:3] isEqualToString: @"childContainer.shInterConnectorsInside.array"], @"should be" );
		 
	STAssertTrue( [[mk objectAtIndex:4] isEqualToString:@"childContainer.nodesInside.selection"], @"should be" );
	STAssertTrue( [[mk objectAtIndex:5] isEqualToString:@"childContainer.inputs.selection"], @"should be" );
	STAssertTrue( [[mk objectAtIndex:6] isEqualToString:@"childContainer.outputs.selection"], @"should be" );
	STAssertTrue( [[mk objectAtIndex:7] isEqualToString:@"childContainer.shInterConnectorsInside.selection"], @"should be" );
}

- (void)testSelectorForChangedKeyPath {
// + (SEL)selectorForWillChangeKeyPath:(NSString *)keyPath
// + (SEL)selectorForChangedKeyPath:(NSString *)keyPath
	
	/* When the model changes, what would you like to get called? */
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillChange:nodesInside_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.inputs.array"]==@selector(modelWillChange:inputs_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.outputs.array"]==@selector(modelWillChange:outputs_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelWillChange:shInterConnectorsInside_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillChange:nodesInsideSelection_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.inputs.selection"]==@selector(modelWillChange:inputsSelection_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.outputs.selection"]==@selector(modelWillChange:outputsSelection_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillChangeKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelWillChange:shInterConnectorsInsideSelection_to:from:), @"should be");
	STAssertThrows( [NodeClassFilter selectorForWillChangeKeyPath:@"chicken"], @"must be validkeypath" );	
	
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelChanged:nodesInside_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.inputs.array"]==@selector(modelChanged:inputs_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.outputs.array"]==@selector(modelChanged:outputs_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelChanged:shInterConnectorsInside_to:from:), @"should be");

	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelChanged:nodesInsideSelection_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.inputs.selection"]==@selector(modelChanged:inputsSelection_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.outputs.selection"]==@selector(modelChanged:outputsSelection_to:from:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForChangedKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelChanged:shInterConnectorsInsideSelection_to:from:), @"should be");

	STAssertThrows( [NodeClassFilter selectorForChangedKeyPath:@"chicken"], @"must be validkeypath" );
}

- (void)testSelectorForInsertedKeyPath {
	// + (SEL)selectorForWillInsertKeyPath:(NSString *)keyPath
	// + (SEL)selectorForInsertedKeyPath:(NSString *)keyPath

/* When the model changes, what would you like to get called? */
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillInsert:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.array"]));
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.inputs.array"]==@selector(modelWillInsert:inputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.outputs.array"]==@selector(modelWillInsert:outputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelWillInsert:shInterConnectorsInside:atIndexes:), @"should be");
	
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillInsert:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.selection"]));
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.inputs.selection"]==@selector(modelWillInsert:inputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.outputs.selection"]==@selector(modelWillInsert:outputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillInsertKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelWillInsert:shInterConnectorsInsideSelection:atIndexes:), @"should be");
	STAssertThrows( [NodeClassFilter selectorForWillInsertKeyPath:@"chicken"], @"must be validkeypath" );
	
	
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelInserted:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.array"]));
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.inputs.array"]==@selector(modelInserted:inputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.outputs.array"]==@selector(modelInserted:outputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelInserted:shInterConnectorsInside:atIndexes:), @"should be");
	
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelInserted:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.selection"]));
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.inputs.selection"]==@selector(modelInserted:inputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.outputs.selection"]==@selector(modelInserted:outputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForInsertedKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelInserted:shInterConnectorsInsideSelection:atIndexes:), @"should be");
	
	STAssertThrows( [NodeClassFilter selectorForInsertedKeyPath:@"chicken"], @"must be validkeypath" );
}

- (void)testSelectorForReplacedKeyPath {
//+ (SEL)selectorForWillReplaceKeyPath:(NSString *)keyPath
//+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath

	/* When the model changes, what would you like to get called? */
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillReplace:nodesInside:with:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.array"]) );
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.inputs.array"]==@selector(modelWillReplace:inputs:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.outputs.array"]==@selector(modelWillReplace:outputs:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelWillReplace:shInterConnectorsInside:with:atIndexes:), @"should be");
	
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillReplace:nodesInsideSelection:with:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.selection"]));
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.inputs.selection"]==@selector(modelWillReplace:inputsSelection:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.outputs.selection"]==@selector(modelWillReplace:outputsSelection:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillReplaceKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelWillReplace:shInterConnectorsInsideSelection:with:atIndexes:), @"should be");
	
	STAssertThrows( [NodeClassFilter selectorForWillReplaceKeyPath:@"chicken"], @"must be validkeypath" );
	
	
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelReplaced:nodesInside:with:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.array"]) );
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.inputs.array"]==@selector(modelReplaced:inputs:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.outputs.array"]==@selector(modelReplaced:outputs:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelReplaced:shInterConnectorsInside:with:atIndexes:), @"should be");
	
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelReplaced:nodesInsideSelection:with:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.selection"]));
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.inputs.selection"]==@selector(modelReplaced:inputsSelection:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.outputs.selection"]==@selector(modelReplaced:outputsSelection:with:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForReplacedKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelReplaced:shInterConnectorsInsideSelection:with:atIndexes:), @"should be");

	STAssertThrows( [NodeClassFilter selectorForReplacedKeyPath:@"chicken"], @"must be validkeypath" );
}

- (void)testSelectorForRemovedKeyPath {
	// + (SEL)selectorForWillRemoveKeyPath:(NSString *)keyPath
	// + (SEL)selectorForRemovedKeyPath:(NSString *)keyPath
	
	/* When the model changes, what would you like to get called? */
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillRemove:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.array"]));
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.inputs.array"]==@selector(modelWillRemove:inputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.outputs.array"]==@selector(modelWillRemove:outputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelWillRemove:shInterConnectorsInside:atIndexes:), @"should be");
	
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillRemove:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.selection"]));
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.inputs.selection"]==@selector(modelWillRemove:inputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.outputs.selection"]==@selector(modelWillRemove:outputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForWillRemoveKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelWillRemove:shInterConnectorsInsideSelection:atIndexes:), @"should be");
	
	STAssertThrows( [NodeClassFilter selectorForWillRemoveKeyPath:@"chicken"], @"must be validkeypath" );
	
	
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelRemoved:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.array"]));
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.inputs.array"]==@selector(modelRemoved:inputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.outputs.array"]==@selector(modelRemoved:outputs:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.shInterConnectorsInside.array"]==@selector(modelRemoved:shInterConnectorsInside:atIndexes:), @"should be");
	
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelRemoved:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.selection"]));
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.inputs.selection"]==@selector(modelRemoved:inputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.outputs.selection"]==@selector(modelRemoved:outputsSelection:atIndexes:), @"should be");
	STAssertTrue( [AllChildrenFilter selectorForRemovedKeyPath:@"childContainer.shInterConnectorsInside.selection"]==@selector(modelRemoved:shInterConnectorsInsideSelection:atIndexes:), @"should be");
	
	STAssertThrows( [NodeClassFilter selectorForRemovedKeyPath:@"chicken"], @"must be validkeypath" );
}

#pragma mark -
#pragma mark Custom Methods for responding to Model events
#pragma mark -- Children --
// Changed
- (void)testModelChangednodesInside_tofrom {
//- (void)modelWillChange:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue
//- (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue

	id mockProxy = [OCMockObject mockForClass:[NodeProxy class]];
	STAssertThrows( [_childProvider modelWillChange:mockProxy nodesInside_to:nil from:nil], @"doh");
	STAssertThrows( [_childProvider modelChanged:mockProxy nodesInside_to:nil from:nil], @"doh");
}

- (void)testModelChangedinputs_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy inputs_to:(id)newValue from:(id)oldValue;
// - (void)modelChanged:(NodeProxy *)proxy inputs_to:(id)newValue from:(id)oldValue

	id mockProxy = [OCMockObject mockForClass:[NodeProxy class]];
	STAssertThrows( [_childProvider modelWillChange:mockProxy inputs_to:nil from:nil], @"doh");
	STAssertThrows( [_childProvider modelChanged:mockProxy inputs_to:nil from:nil], @"doh");
}

- (void)testModelChangedoutputs_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy outputs_to:(id)newValue from:(id)oldValue;
// - (void)modelChanged:(NodeProxy *)proxy outputs_to:(id)newValue from:(id)oldValue

	id mockProxy = [OCMockObject mockForClass:[NodeProxy class]];
	STAssertThrows( [_childProvider modelWillChange:mockProxy outputs_to:nil from:nil], @"doh");
	STAssertThrows( [_childProvider modelChanged:mockProxy outputs_to:nil from:nil], @"doh");
}

- (void)testModelChangedshInterConnectorsInside_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy shInterConnectorsInside_to:(id)newValue from:(id)oldValue;
// - (void)modelChanged:(NodeProxy *)proxy shInterConnectorsInside_to:(id)newValue from:(id)oldValue
	
	id mockProxy = [OCMockObject mockForClass:[NodeProxy class]];
	STAssertThrows( [_childProvider modelWillChange:mockProxy shInterConnectorsInside_to:nil from:nil], @"doh");
	STAssertThrows( [_childProvider modelChanged:mockProxy shInterConnectorsInside_to:nil from:nil], @"doh");
}

// Inserted
- (void)testModelInsertedNodesInsideAtIndexes {
// - (void)modelWillInsert:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelInserted:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	
	// swap out some stuff to help testing
//hmm	id mockProxyMaker = [OCMockObject mockForClass:[AllChildrenProxyFactory class]];	
	id mockContentInsertionNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentInsertionNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	
	id originalContentInsertionNotificationCoalescer = _childProvider->_contentInsertionNotificationCoalescer;
//hmm	id originalProxyMaker = _childProvider->_proxyMaker;
	_childProvider->_contentInsertionNotificationCoalescer = mockContentInsertionNotificationCoalescer;	
//hmm	_childProvider->_proxyMaker = mockProxyMaker;
	
	[_childProvider modelWillInsert:_childProvider.currentNodeProxy nodesInside:nil atIndexes:nil];
	[mockContentInsertionNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	NSMutableArray *insertedValues = [NSMutableArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *insertedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
//hmm	id mockProxies = [NSArray array];
	
//hmm	[[[mockProxyMaker expect] andReturn:mockProxies] proxysForObjects:insertedValues inFilter:_childProvider];

	[[mockContentInsertionNotificationCoalescer expect] performSelector:@selector(appendNodesInserted:atIndexes:) withObject:insertedValues withObject:insertedIndexes];
	[[mockContentInsertionNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelInserted:_childProvider.currentNodeProxy nodesInside:insertedValues atIndexes:insertedIndexes];
	[mockContentInsertionNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentInsertionNotificationCoalescer = originalContentInsertionNotificationCoalescer;
//hmm	_childProvider->_proxyMaker = originalProxyMaker;
}

- (void)testModelInsertedInputsAtIndexes {
// - (void)modelWillInsert:(NodeProxy *)proxy inputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelInserted:(NodeProxy *)proxy inputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
		
	// swap out some stuff to help testing
//hmm	id mockProxyMaker = [OCMockObject mockForClass:[AllChildrenProxyFactory class]];	
	id mockContentInsertionNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentInsertionNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];

	id originalContentInsertionNotificationCoalescer = _childProvider->_contentInsertionNotificationCoalescer;
//hmm	id originalProxyMaker = _childProvider->_proxyMaker;
	_childProvider->_contentInsertionNotificationCoalescer = mockContentInsertionNotificationCoalescer;	
//hmm	_childProvider->_proxyMaker = mockProxyMaker;
	
	[_childProvider modelWillInsert:_childProvider.currentNodeProxy inputs:nil atIndexes:nil];
	[mockContentInsertionNotificationCoalescer verify];
		
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	NSMutableArray *insertedValues = [NSMutableArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *insertedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
//hmm	id mockProxies = [NSArray array];
	
//hmm	[[[mockProxyMaker expect] andReturn:mockProxies] proxysForObjects:insertedValues inFilter:_childProvider];
	
	[[mockContentInsertionNotificationCoalescer expect] performSelector:@selector(appendInputsInserted:atIndexes:) withObject:insertedValues withObject:insertedIndexes];
	[[mockContentInsertionNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelInserted:_childProvider.currentNodeProxy inputs:insertedValues atIndexes:insertedIndexes];
	[mockContentInsertionNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentInsertionNotificationCoalescer = originalContentInsertionNotificationCoalescer;
//hmm	_childProvider->_proxyMaker = originalProxyMaker;
}

- (void)testModelInsertedOutputsAtIndexes {
//- (void)modelWillInsert:(NodeProxy *)proxy outputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
//- (void)modelInserted:(NodeProxy *)proxy outputs:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	
	// swap out some stuff to help testing
//hmm	id mockProxyMaker = [OCMockObject mockForClass:[AllChildrenProxyFactory class]];	
	id mockContentInsertionNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentInsertionNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	
	id originalContentInsertionNotificationCoalescer = _childProvider->_contentInsertionNotificationCoalescer;
//hmm	id originalProxyMaker = _childProvider->_proxyMaker;
	_childProvider->_contentInsertionNotificationCoalescer = mockContentInsertionNotificationCoalescer;	
//hmm	_childProvider->_proxyMaker = mockProxyMaker;
	
	[_childProvider modelWillInsert:_childProvider.currentNodeProxy outputs:nil atIndexes:nil];
	[mockContentInsertionNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	NSMutableArray *insertedValues = [NSMutableArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *insertedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
//hmm	id mockProxies = [NSArray array];
	
//hmm	[[[mockProxyMaker expect] andReturn:mockProxies] proxysForObjects:insertedValues inFilter:_childProvider];

	[[mockContentInsertionNotificationCoalescer expect] performSelector:@selector(appendOutputsInserted:atIndexes:) withObject:insertedValues withObject:insertedIndexes];
	[[mockContentInsertionNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelInserted:_childProvider.currentNodeProxy outputs:insertedValues atIndexes:insertedIndexes];
	[mockContentInsertionNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentInsertionNotificationCoalescer = originalContentInsertionNotificationCoalescer;
//hmm	_childProvider->_proxyMaker = originalProxyMaker;	
}

- (void)testModelInsertedSHInterConnectorsInsideAtIndexes {
//- (void)modelWillInsert:(NodeProxy *)proxy shInterConnectorsInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelInserted:(NodeProxy *)proxy shInterConnectorsInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes

	// swap out some stuff to help testing
//hmm	id mockProxyMaker = [OCMockObject mockForClass:[AllChildrenProxyFactory class]];	
	id mockContentInsertionNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentInsertionNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	
	id originalContentInsertionNotificationCoalescer = _childProvider->_contentInsertionNotificationCoalescer;
//hmm	id originalProxyMaker = _childProvider->_proxyMaker;
	_childProvider->_contentInsertionNotificationCoalescer = mockContentInsertionNotificationCoalescer;	
//hmm	_childProvider->_proxyMaker = mockProxyMaker;
	
	[_childProvider modelWillInsert:_childProvider.currentNodeProxy shInterConnectorsInside:nil atIndexes:nil];
	[mockContentInsertionNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	NSMutableArray *insertedValues = [NSMutableArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *insertedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
//hmm	id mockProxies = [NSArray array];
	
//hmm	[[[mockProxyMaker expect] andReturn:mockProxies] proxysForObjects:insertedValues inFilter:_childProvider];

	[[mockContentInsertionNotificationCoalescer expect] performSelector:@selector(appendIcsInserted:atIndexes:) withObject:insertedValues withObject:insertedIndexes];
	[[mockContentInsertionNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelInserted:_childProvider.currentNodeProxy shInterConnectorsInside:insertedValues atIndexes:insertedIndexes];
	[mockContentInsertionNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentInsertionNotificationCoalescer = originalContentInsertionNotificationCoalescer;
//hmm	_childProvider->_proxyMaker = originalProxyMaker;
}

// Removed
- (void)testModelRemovedNodesInsideAtIndexes {
// - (void)modelWillRemove:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelRemoved:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	
	// swap out some stuff to help testing
	id mockContentRemovedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentRemovedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	id originalContentRemovedNotificationCoalescer = _childProvider->_contentRemovedNotificationCoalescer;
	_childProvider->_contentRemovedNotificationCoalescer = mockContentRemovedNotificationCoalescer;	
	
	[_childProvider modelWillRemove:_childProvider.currentNodeProxy nodesInside:nil atIndexes:nil];
	[mockContentRemovedNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	id removedValues = [NSArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	
	[[mockContentRemovedNotificationCoalescer expect] performSelector:@selector(appendNodesRemoved:atIndexes:) withObject:removedValues withObject:removedIndexes];
	[[mockContentRemovedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelRemoved:_childProvider.currentNodeProxy nodesInside:removedValues atIndexes:removedIndexes];
	[mockContentRemovedNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentRemovedNotificationCoalescer = originalContentRemovedNotificationCoalescer;
}

- (void)testModelRemovedInputsAtIndexes {
// - (void)modelWillRemove:(NodeProxy *)proxy inputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelRemoved:(NodeProxy *)proxy inputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes

	// swap out some stuff to help testing
	id mockContentRemovedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentRemovedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	id originalContentRemovedNotificationCoalescer = _childProvider->_contentRemovedNotificationCoalescer;
	_childProvider->_contentRemovedNotificationCoalescer = mockContentRemovedNotificationCoalescer;	
	
	[_childProvider modelWillRemove:_childProvider.currentNodeProxy inputs:nil atIndexes:nil];
	[mockContentRemovedNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	id removedValues = [NSArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];

	[[mockContentRemovedNotificationCoalescer expect] performSelector:@selector(appendInputsRemoved:atIndexes:) withObject:removedValues withObject:removedIndexes];
	[[mockContentRemovedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelRemoved:_childProvider.currentNodeProxy inputs:removedValues atIndexes:removedIndexes];
	[mockContentRemovedNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentRemovedNotificationCoalescer = originalContentRemovedNotificationCoalescer;
}

- (void)testModelRemovedOutputsAtIndexes {
//- (void)modelWillRemove:(NodeProxy *)proxy outputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelRemoved:(NodeProxy *)proxy outputs:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes

	// swap out some stuff to help testing
	id mockContentRemovedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentRemovedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	id originalContentRemovedNotificationCoalescer = _childProvider->_contentRemovedNotificationCoalescer;
	_childProvider->_contentRemovedNotificationCoalescer = mockContentRemovedNotificationCoalescer;	
	
	[_childProvider modelWillRemove:_childProvider.currentNodeProxy outputs:nil atIndexes:nil];
	[mockContentRemovedNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	id removedValues = [NSArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	
	[[mockContentRemovedNotificationCoalescer expect] performSelector:@selector(appendOutputsRemoved:atIndexes:) withObject:removedValues withObject:removedIndexes];
	[[mockContentRemovedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelRemoved:_childProvider.currentNodeProxy outputs:removedValues atIndexes:removedIndexes];
	[mockContentRemovedNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentRemovedNotificationCoalescer = originalContentRemovedNotificationCoalescer;
}

- (void)testModelRemovedSHInterConnectorsInsideAtIndexes {
//- (void)modelWillRemove:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
// - (void)modelRemoved:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes

	// swap out some stuff to help testing
	id mockContentRemovedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockContentRemovedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	id originalContentRemovedNotificationCoalescer = _childProvider->_contentRemovedNotificationCoalescer;
	_childProvider->_contentRemovedNotificationCoalescer = mockContentRemovedNotificationCoalescer;	
	
	[_childProvider modelWillRemove:_childProvider.currentNodeProxy shInterConnectorsInside:nil atIndexes:nil];
	[mockContentRemovedNotificationCoalescer verify];
	
	id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	id removedValues = [NSArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	
	[[mockContentRemovedNotificationCoalescer expect] performSelector:@selector(appendIcsRemoved:atIndexes:) withObject:removedValues withObject:removedIndexes];
	[[mockContentRemovedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelRemoved:_childProvider.currentNodeProxy shInterConnectorsInside:removedValues atIndexes:removedIndexes];
	[mockContentRemovedNotificationCoalescer verify];
	
	// swap back real stuff
	_childProvider->_contentRemovedNotificationCoalescer = originalContentRemovedNotificationCoalescer;
}

#pragma mark -- Selection --
// Changed
- (void)testModelChangedNodesInsideSelection_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue
// - (void)modelChanged:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue

	id mockSelectionChangedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockSelectionChangedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	
	id originalSelectionChangedNotificationCoalescer = _childProvider->_selectionChangedNotificationCoalescer;
	_childProvider->_selectionChangedNotificationCoalescer = mockSelectionChangedNotificationCoalescer;
	
	[_childProvider modelWillChange:_childProvider.currentNodeProxy nodesInsideSelection_to:nil from:nil];
	[mockSelectionChangedNotificationCoalescer verify];
	
	NSIndexSet *oldSelectionIndexes = [NSIndexSet indexSetWithIndex:1];
	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	[[mockSelectionChangedNotificationCoalescer expect] performSelector:@selector(changedSelectedNodeIndexesFrom:to:) withObject:oldSelectionIndexes withObject:newSelectionIndexes];
	[[mockSelectionChangedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelChanged:_childProvider.currentNodeProxy nodesInsideSelection_to:newSelectionIndexes from:oldSelectionIndexes];
	
	[mockSelectionChangedNotificationCoalescer verify];
	
	_childProvider->_selectionChangedNotificationCoalescer = originalSelectionChangedNotificationCoalescer;	
}

- (void)testModelChangedInputsSelection_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy inputsSelection_to:(id)newValue from:(id)oldValue
// - (void)modelChanged:(NodeProxy *)proxy inputsSelection_to:(id)newValue from:g
	
	id mockSelectionChangedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockSelectionChangedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];

	id originalSelectionChangedNotificationCoalescer = _childProvider->_selectionChangedNotificationCoalescer;
	_childProvider->_selectionChangedNotificationCoalescer = mockSelectionChangedNotificationCoalescer;

	[_childProvider modelWillChange:_childProvider.currentNodeProxy inputsSelection_to:nil from:nil];
	[mockSelectionChangedNotificationCoalescer verify];
	
	NSIndexSet *oldSelectionIndexes = [NSIndexSet indexSetWithIndex:1];
	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	
	[[mockSelectionChangedNotificationCoalescer expect] performSelector:@selector(changedSelectedInputIndexesFrom:to:) withObject:oldSelectionIndexes withObject:newSelectionIndexes];
	[[mockSelectionChangedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];

	[_childProvider modelChanged:_childProvider.currentNodeProxy inputsSelection_to:newSelectionIndexes from:oldSelectionIndexes];
	
	[mockSelectionChangedNotificationCoalescer verify];
	
	_childProvider->_selectionChangedNotificationCoalescer = originalSelectionChangedNotificationCoalescer;
}

- (void)testModelChangedOutputsSelection_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy outputsSelection_to:(id)newValue from:(id)oldValue
// - (void)modelChanged:(NodeProxy *)proxy outputsSelection_to:(id)newValue from:(id)oldValue

	id mockSelectionChangedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockSelectionChangedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	
	id originalSelectionChangedNotificationCoalescer = _childProvider->_selectionChangedNotificationCoalescer;
	_childProvider->_selectionChangedNotificationCoalescer = mockSelectionChangedNotificationCoalescer;
	
	[_childProvider modelWillChange:_childProvider.currentNodeProxy outputsSelection_to:nil from:nil];
	[mockSelectionChangedNotificationCoalescer verify];
	
	NSIndexSet *oldSelectionIndexes = [NSIndexSet indexSetWithIndex:1];
	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	[[mockSelectionChangedNotificationCoalescer expect] performSelector:@selector(changedSelectedOutputIndexesFrom:to:) withObject:oldSelectionIndexes withObject:newSelectionIndexes];
	[[mockSelectionChangedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelChanged:_childProvider.currentNodeProxy outputsSelection_to:newSelectionIndexes from:oldSelectionIndexes];
	
	[mockSelectionChangedNotificationCoalescer verify];
	
	_childProvider->_selectionChangedNotificationCoalescer = originalSelectionChangedNotificationCoalescer;
}

- (void)testModelChangedSHInterConnectorsInsideSelection_tofrom {
// - (void)modelWillChange:(NodeProxy *)proxy shInterConnectorsInsideSelection_to:(id)newValue from:(id)oldValue
// - (void)modelChanged:(NodeProxy *)proxy shInterConnectorsInsideSelection_to:(id)newValue from:(id)oldValue
	
	id mockSelectionChangedNotificationCoalescer = [OCMockObject mockForClass:[DelayedNotificationCoalescer class]];
	[[mockSelectionChangedNotificationCoalescer expect] fireSingleWillChangeNotification:_childProvider.currentNodeProxy];
	
	id originalSelectionChangedNotificationCoalescer = _childProvider->_selectionChangedNotificationCoalescer;
	_childProvider->_selectionChangedNotificationCoalescer = mockSelectionChangedNotificationCoalescer;
	
	[_childProvider modelWillChange:_childProvider.currentNodeProxy shInterConnectorsInsideSelection_to:nil from:nil];
	[mockSelectionChangedNotificationCoalescer verify];
	
	NSIndexSet *oldSelectionIndexes = [NSIndexSet indexSetWithIndex:1];
	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	[[mockSelectionChangedNotificationCoalescer expect] performSelector:@selector(changedSelectedICIndexesFrom:to:) withObject:oldSelectionIndexes withObject:newSelectionIndexes];
	[[mockSelectionChangedNotificationCoalescer expect] queueSinglePostponedNotification:_childProvider.currentNodeProxy];
	
	[_childProvider modelChanged:_childProvider.currentNodeProxy shInterConnectorsInsideSelection_to:newSelectionIndexes from:oldSelectionIndexes];
	
	[mockSelectionChangedNotificationCoalescer verify];
	
	_childProvider->_selectionChangedNotificationCoalescer = originalSelectionChangedNotificationCoalescer;
}

// Inserted

- (void)testmodelInsertednodesInsideSelectionAtIndexes {
//- (void)modelInserted:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelInserted:nil nodesInsideSelection:nil atIndexes:nil], @"should do");
}

- (void)testmodelInsertedinputsSelectionAtIndexes {
//- (void)modelInserted:(NodeProxy *)proxy inputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelInserted:nil inputsSelection:nil atIndexes:nil], @"should do");
}

- (void)testmodelInsertedoutputsSelectionAtIndexes {
//- (void)modelInserted:(NodeProxy *)proxy outputsSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelInserted:nil outputsSelection:nil atIndexes:nil], @"should do");
}

- (void)testmodelInsertedshInterConnectorsInsideSelectionAtIndexes {
//- (void)modelInserted:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelInserted:nil shInterConnectorsInsideSelection:nil atIndexes:nil], @"should do");
}

// Replaced

- (void)testmodelReplacednodesInsideSelectionwithAtIndexes {
//- (void)modelReplaced:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil nodesInsideSelection:nil with:nil atIndexes:nil], @"should do");
}

- (void)testmodelReplacedinputsSelectionwithAtIndexes {
//- (void)modelReplaced:(NodeProxy *)proxy inputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil inputsSelection:nil with:nil atIndexes:nil], @"should do");
}

- (void)testmodelReplacedoutputsSelectionwithAtIndexes {
//- (void)modelReplaced:(NodeProxy *)proxy outputsSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil outputsSelection:nil with:nil atIndexes:nil], @"should do");
}

- (void)testmodelReplacedshInterConnectorsInsideSelectionwithAtIndexes {
// - (void)modelReplaced:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil shInterConnectorsInsideSelection:nil with:nil atIndexes:nil], @"should do");
}

// Removed
- (void)testmodelRemovednodesInsideSelectionAtIndexes {
// - (void)modelRemoved:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelRemoved:nil nodesInsideSelection:nil atIndexes:nil], @"should do");
}

- (void)testmodelRemovedinputsSelectionAtIndexes {
//- (void)modelRemoved:(NodeProxy *)proxy inputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelRemoved:nil inputsSelection:nil atIndexes:nil], @"should do");
}

- (void)testmodelRemovedoutputsSelectionAtIndexes {
//- (void)modelRemoved:(NodeProxy *)proxy outputsSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelRemoved:nil outputsSelection:nil atIndexes:nil], @"should do");
}

- (void)testmodelRemovedshInterConnectorsInsideSelectionAtIndexes {
// - (void)modelRemoved:(NodeProxy *)proxy shInterConnectorsInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelRemoved:nil shInterConnectorsInsideSelection:nil atIndexes:nil], @"should do");
}

// Replaced
- (void)testmodelReplacednodesInsidewithAtIndexes {
	//- (void)modelReplaced:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil nodesInside:nil with:nil atIndexes:nil], @"should do");
}

- (void)testmodelReplacedinputswithAtIndexes {
	//- (void)modelReplaced:(NodeProxy *)proxy inputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil inputs:nil with:nil atIndexes:nil], @"should do");
}

- (void)testmodelReplacedoutputswithAtIndexes {
	//- (void)modelReplaced:(NodeProxy *)proxy outputs:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil outputs:nil with:nil atIndexes:nil], @"should do");
}

- (void)testmodelReplacedshInterConnectorsInsidewithAtIndexes {
	//- (void)modelReplaced:(NodeProxy *)proxy shInterConnectorsInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	STAssertThrows([_childProvider modelReplaced:nil shInterConnectorsInside:nil with:nil atIndexes:nil], @"should do");
}

#pragma mark Test the real shit
- (void)test_doPreRemoveNotification {
	// - (void)_doPreRemoveNotification
	
	[self resetStuff];
	[_childProvider _doPreRemoveNotification];
	STAssertTrue(_willRemoveContent==1, @"doh");
}

- (void)test_doDelayedRemoveNotification {
	// - (void)_doDelayedRemoveNotification
		
	[_childProvider makeFilteredTreeUpToDate:_childProvider.rootNodeProxy];
	[self addTestNodes];
	[_childProvider _doDelayedInsertionNotification];
	
	// NEED TO RESET THE COALESCER	
	[_childProvider->_contentInsertionNotificationCoalescer notificationDidFire_callback];
//	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	
	// -- remove some stuff
	NSArray *allNodes = [[_model.currentNodeGroup nodesInside] array];
	NSArray *allInputs = [[_model.currentNodeGroup inputs] array];
	NSArray *allOutputs = [[_model.currentNodeGroup outputs] array];
	NSArray *allICs = [[_model.currentNodeGroup shInterConnectorsInside] array];
	STAssertTrue([allNodes count]==3, @"Doh");
	
	NSArray *itemsToRemove = [NSArray arrayWithObjects: 
							  [allNodes objectAtIndex:1], [allNodes objectAtIndex:2],
							  [allInputs objectAtIndex:1], [allInputs objectAtIndex:2],
							  [allOutputs objectAtIndex:1], [allOutputs objectAtIndex:2],
							  [allICs objectAtIndex:1], [allICs objectAtIndex:2],
							  nil];

	[_model deleteChildren:itemsToRemove fromNode:_model.currentNodeGroup];
	
	// do it
	[self resetStuff];
	[_childProvider _doDelayedRemoveNotification];

	// did it work?
	STAssertTrue( _didRemoveContent==1, @"doh" );
	STAssertTrue([_removedItems count]==8, @"doh");
	STAssertTrue([_removedItemsIndexes count]==8, @"doh");
	
	/* Did the filter correctly update the proxy tree? */
	NSIndexSet *npFilteredContentIndexes = [_childProvider.currentNodeProxy indexesOfFilteredContent];
	STAssertTrue([npFilteredContentIndexes count]==4, @"doh %i", [npFilteredContentIndexes count]);
	STAssertTrue([npFilteredContentIndexes containsIndex:0], @"doh %@", npFilteredContentIndexes );
	STAssertTrue([npFilteredContentIndexes containsIndex:1], @"doh %@", npFilteredContentIndexes );
	STAssertTrue([npFilteredContentIndexes containsIndex:2], @"doh %@", npFilteredContentIndexes );
	STAssertTrue([npFilteredContentIndexes containsIndex:3], @"doh %@", npFilteredContentIndexes );
		
	NSArray *npFilteredContent = [_childProvider.currentNodeProxy filteredContent];
	STAssertTrue([npFilteredContent count]==4, @"doh %i", [npFilteredContent count]);
	STAssertTrue( [[[[[npFilteredContent objectAtIndex:0] originalNode] name] value] isEqualTo:@"nodeGroup2"], @"doh %@", [[[[npFilteredContent objectAtIndex:0] originalNode] name] value] );
	STAssertTrue( [[[[[npFilteredContent objectAtIndex:1] originalNode] name] value] isEqualTo:@"i1"], @"doh %@", [[[[npFilteredContent objectAtIndex:1] originalNode] name] value] );
	STAssertTrue( [[[[[npFilteredContent objectAtIndex:2] originalNode] name] value] isEqualTo:@"o1"], @"doh %@", [[[[npFilteredContent objectAtIndex:2] originalNode] name] value] );

	// NEED TO RESET THE COALESCER
	[_childProvider->_contentRemovedNotificationCoalescer notificationDidFire_callback];
}

- (void)test_doPreInsertionNotification {
	// - (void)_doPreInsertionNotification
	
	[self resetStuff];
	[_childProvider _doPreInsertionNotification];
	STAssertTrue(_willInsertContent==1, @"doh");
}

- (void)test_doDelayedInsertionNotification {
	// - (void)_doDelayedInsertionNotification
	
	[_childProvider makeFilteredTreeUpToDate:_childProvider.rootNodeProxy];
	[self addTestNodes];

	// do it
	[self resetStuff];
	[_childProvider _doDelayedInsertionNotification];
	
	// Did it work?
	STAssertTrue(_didInsertContent==1, @"doh");
	STAssertTrue([_insertedItems count]==12, @"doh");
	STAssertTrue([_insertedItemsIndexes count]==12, @"doh");

	/* Did the filter correctly update the proxy tree? */
	NSIndexSet *npFilteredContentIndexes = [_childProvider.currentNodeProxy indexesOfFilteredContent];
	STAssertTrue([npFilteredContentIndexes count]==12, @"doh %i", [npFilteredContentIndexes count]);
	STAssertTrue([npFilteredContentIndexes containsIndexesInRange:NSMakeRange(0,12)], @"doh" );

	NSArray *npFilteredContent = [_childProvider.currentNodeProxy filteredContent];
	STAssertTrue([npFilteredContent count]==12, @"doh %i", [npFilteredContent count]);
	STAssertTrue( [[[[[npFilteredContent objectAtIndex:0] originalNode] name] value] isEqualTo:@"nodeGroup2"], @"doh %@", [[[[npFilteredContent objectAtIndex:0] originalNode] name] value] );
	STAssertTrue( [[[[[npFilteredContent objectAtIndex:3] originalNode] name] value] isEqualTo:@"i1"], @"doh %@", [[[[npFilteredContent objectAtIndex:3] originalNode] name] value] );
	STAssertTrue( [[[[[npFilteredContent objectAtIndex:6] originalNode] name] value] isEqualTo:@"o1"], @"doh %@", [[[[npFilteredContent objectAtIndex:6] originalNode] name] value] );

	// -- add some more
	// NEED TO RESET THE COALESCER
	[_childProvider->_contentInsertionNotificationCoalescer notificationDidFire_callback];

	SHInputAttribute *i4 = [SHInputAttribute makeChildWithName:@"i4"], *i5 = [SHInputAttribute makeChildWithName:@"i5"];
	SHOutputAttribute *o4 = [SHOutputAttribute makeChildWithName:@"o4"], *o5 = [SHOutputAttribute makeChildWithName:@"o5"];
	[_model insertGraphics:[NSArray arrayWithObjects:i4,i5,nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:o4,o5,nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
		
	[_childProvider _doDelayedInsertionNotification];

	// Did it work?
	STAssertTrue(_didInsertContent==2, @"doh %i", _didInsertContent);
	STAssertTrue([_insertedItems count]==4, @"doh");
	STAssertTrue([_insertedItemsIndexes count]==4, @"doh");
	STAssertTrue([_insertedItemsIndexes containsIndexesInRange:NSMakeRange(3,2)], @"doh %@", _insertedItemsIndexes );
	STAssertTrue([_insertedItemsIndexes containsIndexesInRange:NSMakeRange(8,2)], @"doh %@", _insertedItemsIndexes );
	
	npFilteredContent = [_childProvider.currentNodeProxy filteredContent];
	STAssertTrue([npFilteredContent count]==16, @"doh %i", [npFilteredContent count]);

	// -- move some about - sheeeeeeeet!
	// NEED TO RESET THE COALESCER
	[_childProvider->_contentInsertionNotificationCoalescer notificationDidFire_callback];

	id i1 = [[npFilteredContent objectAtIndex:5] originalNode];
	id o1 = [[npFilteredContent objectAtIndex:10] originalNode];
	STAssertTrue( [[[i1 name] value] isEqualTo:@"i1"], @"doh %@", [[i1 name] value] );
	STAssertTrue( [[[o1 name] value] isEqualTo:@"o1"], @"doh %@", [[o1 name] value] );

	[_model add:1 toIndexOfChild:i1];
	[_model add:1 toIndexOfChild:o1];
	
	[_childProvider _doDelayedInsertionNotification];
	STAssertTrue(_didInsertContent==3, @"doh %i", _didInsertContent);
	STAssertTrue([_insertedItems count]==2, @"doh");
	STAssertTrue([_insertedItemsIndexes count]==2, @"doh");
	STAssertTrue([_insertedItemsIndexes containsIndexesInRange:NSMakeRange(6,1)], @"doh %@", _insertedItemsIndexes );
	STAssertTrue([_insertedItemsIndexes containsIndexesInRange:NSMakeRange(11,1)], @"doh %@", _insertedItemsIndexes );
	
	npFilteredContent = [_childProvider.currentNodeProxy filteredContent];
	STAssertTrue([npFilteredContent count]==16, @"doh %i", [npFilteredContent count]);
	
	[_childProvider->_contentInsertionNotificationCoalescer notificationDidFire_callback];
}

- (void)test_doPreSelectionNotification {
	// - (void)_doPreSelectionNotification
	
	[self resetStuff];
	[_childProvider _doPreSelectionNotification];
	STAssertTrue(_willChangeSelection==1, @"doh");
}

- (void)test_doDelayedSelectionNotification {
	// - (void)_doDelayedSelectionNotification
	
	[_childProvider makeFilteredTreeUpToDate:_childProvider.rootNodeProxy];
	[self addTestNodes];

	// NEED TO RESET THE COALESCER
	[_childProvider _doDelayedInsertionNotification];
	[_childProvider->_contentInsertionNotificationCoalescer notificationDidFire_callback];
	
	STAssertTrue( [[_childProvider.currentNodeProxy filteredContent] count]==12, @"doh %i", [[_childProvider.currentNodeProxy filteredContent] count] );

	// -- do some selection
	NSArray *allNodes = [[_model.currentNodeGroup nodesInside] array];
	NSArray *allInputs = [[_model.currentNodeGroup inputs] array];
	NSArray *allOutputs = [[_model.currentNodeGroup outputs] array];
	NSArray *allICs = [[_model.currentNodeGroup shInterConnectorsInside] array];
	
	NSArray *childrenToSelect = [NSArray arrayWithObjects: 
								 [allNodes objectAtIndex:1], [allNodes objectAtIndex:2],
								 [allInputs objectAtIndex:1], [allInputs objectAtIndex:2],
								 [allOutputs objectAtIndex:1], [allOutputs objectAtIndex:2],
								 [allICs objectAtIndex:1], [allICs objectAtIndex:2],
								 nil];

	[_model.currentNodeGroup setSelectedChildren:childrenToSelect];

	// do it
	[self resetStuff];
	[_childProvider _doDelayedSelectionNotification];

	STAssertTrue(_didChangeSelection==1, @"doh");
	STAssertTrue([_selectionIndexes count]==8, @"doh %i", [_selectionIndexes count]);
	STAssertTrue([_newlySelectedIndexes count]==8, @"doh %i", [_newlySelectedIndexes count]);
	STAssertTrue([_newlyDeselectedIndexes count]==0, @"doh %i", [_newlyDeselectedIndexes count]);
	
	//-- get selecton from proxy
	NSMutableIndexSet *npSelectionIndexes = [_childProvider.currentNodeProxy filteredContentSelectionIndexes];
	STAssertTrue([npSelectionIndexes count]==8, @"doh %i", [npSelectionIndexes count]);
	STAssertTrue([npSelectionIndexes containsIndex:2], @"doh %@", npSelectionIndexes );
	STAssertTrue([npSelectionIndexes containsIndex:5], @"doh %@", npSelectionIndexes );
	STAssertTrue([npSelectionIndexes containsIndex:8], @"doh %@", npSelectionIndexes );
	STAssertTrue([npSelectionIndexes containsIndex:11], @"doh %@", npSelectionIndexes );
	
	// NEED TO RESET THE COALESCER
	[_childProvider->_selectionChangedNotificationCoalescer notificationDidFire_callback];
	
	//-- do more complex
	NSArray *childrenToDeselect = [NSArray arrayWithObjects: 
								   [allNodes objectAtIndex:1], 
								   [allNodes objectAtIndex:2],
								   [allInputs objectAtIndex:1],
								   [allOutputs objectAtIndex:1],
								   [allICs objectAtIndex:1],
								 nil];

	STAssertTrue([[_model.currentNodeGroup selectedChildren] count]==8, @"hm %i", [[_model.currentNodeGroup selectedChildren] count]);
	[_model.currentNodeGroup removeChildrenFromSelection:childrenToDeselect];
	STAssertTrue([[_model.currentNodeGroup selectedChildren] count]==3, @"hm %i", [[_model.currentNodeGroup selectedChildren] count]);

	[_childProvider _doDelayedSelectionNotification];

	STAssertTrue(_didChangeSelection==2, @"doh");
	STAssertTrue([_selectionIndexes count]==3, @"doh %i", [_selectionIndexes count]);
	STAssertTrue([_newlySelectedIndexes count]==0, @"doh %i", [_newlySelectedIndexes count]);
	STAssertTrue([_newlyDeselectedIndexes count]==5, @"doh %i", [_newlyDeselectedIndexes count]); // _newlyDeselectedIndexes is actually 'deselected' objects
// 
	//-- get selecton from proxy
	npSelectionIndexes = [_childProvider.currentNodeProxy filteredContentSelectionIndexes];
	STAssertTrue([npSelectionIndexes count]==3, @"doh %i", [npSelectionIndexes count]);
	STAssertTrue([npSelectionIndexes containsIndex:5], @"doh %@", npSelectionIndexes );
	STAssertTrue([npSelectionIndexes containsIndex:8], @"doh %@", npSelectionIndexes );
	STAssertTrue([npSelectionIndexes containsIndex:11], @"doh %@", npSelectionIndexes );
	
	// NEED TO RESET THE COALESCER
	[_childProvider->_selectionChangedNotificationCoalescer notificationDidFire_callback];
}

 - (void)testActualOperation {
	 
	 // [value registerContentFilter:[NodeClassFilter class] andUser:self options:[NSDictionary dictionaryWithObject:@"Graphic" forKey:@"Class"]]
	 // [_model unregisterContentFilter:[NodeClassFilter class] andUser:self options:[NSDictionary dictionaryWithObject:@"Graphic" forKey:@"Class"]]
	 
	 [self resetStuff];
	 
	 id firstObj = [[NSObject new] autorelease], secondObj = [[NSObject new] autorelease], thirdObj = [[NSObject new] autorelease];
	 NSMutableArray *insertedValues = [NSMutableArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	 NSIndexSet *insertedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	 
	 [_childProvider modelWillInsert:_childProvider.currentNodeProxy outputs:nil atIndexes:nil];
	 STAssertTrue( _willInsertContent==1, @"hmm" );
	 
	 [_childProvider modelInserted:_childProvider.currentNodeProxy outputs:insertedValues atIndexes:insertedIndexes];
	 
	 // -- cycle runloop - notification is sent at the end of the runloop
	 [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	 
	 STAssertTrue( _didInsertContent==1, @"hmm" );
	 STAssertTrue( [_insertedItems count]==[insertedValues count], @"doh");
	 STAssertTrue( [[_insertedItems objectAtIndex:0] originalNode]==[insertedValues objectAtIndex:0], @"doh");
	 STAssertTrue( [[_insertedItems objectAtIndex:1] originalNode]==[insertedValues objectAtIndex:1], @"doh");
	 STAssertTrue( [[_insertedItems objectAtIndex:2] originalNode]==[insertedValues objectAtIndex:2], @"doh");
	 STAssertTrue( [_insertedItemsIndexes isEqualToIndexSet:insertedIndexes], @"doh");
	 

	 [self resetStuff];
	 
	 [_childProvider modelWillRemove:_childProvider.currentNodeProxy outputs:nil atIndexes:nil];
	 
	 STAssertTrue( _willRemoveContent==1, @"hmm" );
	 
	 NSArray *removedValues = [NSArray arrayWithObjects:firstObj, secondObj, thirdObj, nil];
	 NSIndexSet *removedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)];
	 [_childProvider modelRemoved:_childProvider.currentNodeProxy outputs:removedValues atIndexes:removedIndexes];

	 // -- cycle runloop - notification is sent at the end of the runloop
	 [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	 STAssertTrue( _didRemoveContent==1, @"hmm" );
	 STAssertTrue( [_removedItems count]==[removedValues count], @"doh");
	 STAssertTrue( [[_removedItems objectAtIndex:0] originalNode]==[removedValues objectAtIndex:0], @"doh");
	 STAssertTrue( [[_removedItems objectAtIndex:1] originalNode]==[removedValues objectAtIndex:1], @"doh");
	 STAssertTrue( [[_removedItems objectAtIndex:2] originalNode]==[removedValues objectAtIndex:2], @"doh");
	 STAssertTrue( [_removedItemsIndexes isEqualToIndexSet:removedIndexes], @"doh");	
}

- (void)testMakeFilteredContentUptodateConfusion {
	
	SHNodeGraphModel *tempModel = [SHNodeGraphModel makeEmptyModel];
	
	[self addTestNodes];
	SHNode *current = [SHNode makeChildWithName:@"current"];
	
	[tempModel NEW_addChild:current toNode:tempModel.rootNodeGroup atIndex:0];
	[tempModel setCurrentNodeGroup:current];
	
	// -- cycle runloop - notification is sent at the end of the runloop
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];

	[tempModel registerContentFilter:[AllChildrenFilter class] andUser:self options:nil];
	
	NSArray *filteredContent = filt.currentNodeProxy.filteredContent;
	
	[tempModel unregisterContentFilter:[AllChildrenFilter class] andUser:self options:nil];
	
	[_model.undoManager removeAllActions];
}

- (void)testPostPendingNotifications {
	
	[self addTestNodes];

	STAssertTrue([_childProvider hasPendingNotifications], @"sh");
	[_childProvider postPendingNotificationsExcept:nil];
	STAssertFalse([_childProvider hasPendingNotifications], @"sh");
}

- (void)testVeryDifficultProblems {
	//oh no! Meaty unforseen  problems.

	//have some inputs connected to attributes at different levels

	// such that deleting an attyribute from the current Node removes an ic at a deeper level. THIS BREAKS OUR V2 RULE.
	// Select the att in current level and delete it. Delete will be sent before queued selection notification is ent breaking our all items filter

// lets build up a bit of structure
// - *current
//	- inAtt1
//	- outAtt1
//	- *inner
//	 - inAtt2
//	 - outAtt2
	
	SHNode *current = [SHNode makeChildWithName:@"current"];
	
	[_model NEW_addChild:current toNode:_model.rootNodeGroup atIndex:0];
	[_model setCurrentNodeGroup:current];

	SHInputAttribute *inAtt1 = [SHInputAttribute makeChildWithName:@"inAtt1"];
	SHOutputAttribute *outAtt1 = [SHOutputAttribute makeChildWithName:@"outAtt1"];

	SHNode *inner = [SHNode makeChildWithName:@"inner"];
	SHInputAttribute *inAtt2 = [SHInputAttribute makeChildWithName:@"inAtt2"];
	SHOutputAttribute *outAtt2 = [SHOutputAttribute makeChildWithName:@"outAtt2"];

	[current addChild:inAtt1 atIndex:-1 undoManager:nil];
	[current addChild:outAtt1 atIndex:-1 undoManager:nil];
	[current addChild:inner atIndex:-1 undoManager:nil];

	[_model setCurrentNodeGroup:inner];
	
	[inner addChild:inAtt2 atIndex:-1 undoManager:nil];
	[inner addChild:outAtt2 atIndex:-1 undoManager:nil];

	[_model setCurrentNodeGroup:current];
	NodeProxy *currentProxy = [_childProvider currentNodeProxy];

	[current _makeSHInterConnectorBetweenOutletOf:(SHProtoAttribute *)outAtt2 andInletOfAtt:(SHProtoAttribute *)inAtt1 undoManager:nil];
	STAssertTrue([[current nodesInside] count]==1, @"doh");
	STAssertTrue([[current inputs] count]==1, @"doh");
	STAssertTrue([[current outputs] count]==1, @"doh");
	STAssertTrue([[current shInterConnectorsInside] count]==1, @"doh");
	STAssertTrue([[inner nodesInside] count]==0, @"doh");
	STAssertTrue([[inner inputs] count]==1, @"doh");
	STAssertTrue([[inner outputs] count]==1, @"doh");
	STAssertTrue([[inner shInterConnectorsInside] count]==0, @"doh");
	
	//	-- go back down
	[_model setCurrentNodeGroup:inner];

	//	-- select and delete
	[inner unSelectAllChildren];
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObject:outAtt2]];
	//-- if we dont fire the queued notification here it will cause another to be sent
		
	STAssertTrue([[inner selectedChildren] count]==1, @"doh");
	[_model deleteChildren:[NSArray arrayWithObject:outAtt2] fromNode:inner];
	
	NodeProxy *innerProxy = [_childProvider currentNodeProxy];
	
	// reming outAtt2 from inner should have removed ic from current 
	//-- check all proxies correspond to nodes
	STAssertTrue([[current nodesInside] count]==1, @"doh %i", [[current nodesInside] count]);
	STAssertTrue([[current inputs] count]==1, @"doh %i", [[current inputs] count]);
	STAssertTrue([[current outputs] count]==1, @"doh %i", [[current outputs] count]);
	STAssertTrue([[current shInterConnectorsInside] count]==0, @"doh %i", [[current shInterConnectorsInside] count]);
	STAssertTrue(0==[[inner nodesInside] count], @"doh %i", [[inner nodesInside] count]);
	STAssertTrue(1==[[inner inputs] count], @"doh %i", [[inner inputs] count]);
	STAssertTrue(0==[[inner outputs] count], @"doh %i", [[inner outputs] count]);
	STAssertTrue(0==[[inner shInterConnectorsInside] count], @"doh %i", [[inner shInterConnectorsInside] count]);
	
	// notification shouldnt have touched proxy yet
	STAssertTrue(2==[[innerProxy filteredContent] count], @"shucks %i", [[innerProxy filteredContent] count]);
	STAssertTrue(3==[[currentProxy filteredContent] count], @"shucks %i", [[currentProxy filteredContent] count]);
	
	//-- make sure nothing got out of sync when you go back up
	[_model setCurrentNodeGroup:current];

	// .. but now we should be up to date
	STAssertTrue(1==[[innerProxy filteredContent] count], @"shit %i", [[innerProxy filteredContent]count]);
	STAssertTrue(3==[[currentProxy filteredContent] count], @"shit %i", [[currentProxy filteredContent]count]);
	
	/*
	- harder case
	 */
	//- node1
	//-- node2
	//--- output
	//-- node3
	//--- input
	SHNode *innerNode1 = [SHNode makeChildWithName:@"innerNode1"];
	SHNode *innerNode2 = [SHNode makeChildWithName:@"innerNode2"];
	SHInputAttribute *deepInput = [SHInputAttribute makeChildWithName:@"deepInput"];
	SHOutputAttribute *deepOutput = [SHOutputAttribute makeChildWithName:@"deepOutput"];
	
	[current addChild:innerNode1 atIndex:-1 undoManager:nil];
	[current addChild:innerNode2 atIndex:-1 undoManager:nil];
	[_model setCurrentNodeGroup:innerNode1];
	[innerNode1 addChild:deepOutput atIndex:-1 undoManager:nil];
	[_model setCurrentNodeGroup:innerNode2];
	[innerNode2 addChild:deepInput atIndex:-1 undoManager:nil];

	[_model setCurrentNodeGroup:current];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:deepOutput toInletOfAttribute:deepInput];

	//ic is in node1 (yes two levels up!)
	STAssertTrue( int1 && [int1 parentSHNode]==current, @"doh");
	
	//delete input and it should delete ic from node1. how will we make node1 proxy dirty?
	[_model setCurrentNodeGroup:innerNode1];
	STAssertTrue(6==[[currentProxy filteredContent] count], @"shit %i", [[currentProxy filteredContent]count]);

	[_model.currentNodeGroup deleteChild:deepOutput undoManager:nil];
	
	[_model setCurrentNodeGroup:current];
	STAssertTrue(5==[[currentProxy filteredContent] count], @"shit %i", [[currentProxy filteredContent]count]);

}

- (void)testRemovingAnAttributeRemovesICFromAboveAndMarksItAsDirty {

	SHNode *childnode1=[SHNode makeChildWithName:@"n1"], *childnode2=[SHNode makeChildWithName:@"n2"];
	SHInputAttribute *i1 = [SHInputAttribute makeChildWithName:@"i1"];
	SHOutputAttribute *o1 = [SHOutputAttribute makeChildWithName:@"o1"];
	
	// add some shit
	[_model insertGraphics:[NSArray arrayWithObjects:childnode1, childnode2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	_model.currentNodeGroup = childnode1;
	[_model insertGraphics:[NSArray arrayWithObjects:o1, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
	_model.currentNodeGroup = childnode2;
	[_model insertGraphics:[NSArray arrayWithObjects:i1, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
	_model.currentNodeGroup = (id)[childnode1 parentSHNode];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:o1 toInletOfAttribute:i1];
	STAssertNotNil(int1, @"hmm");
	
	AllChildProxy *dirtyProxy = (AllChildProxy *)[_childProvider nodeProxyForNode:_model.currentNodeGroup];
	STAssertNotNil(dirtyProxy, @"hmm");

	STAssertFalse(dirtyProxy.icWasRemovedHint, @"fucked up");

	_model.currentNodeGroup = childnode1;
	[_model deleteChildren:[NSArray arrayWithObject:o1] fromNode:_model.currentNodeGroup];
	[_childProvider postPendingNotificationsExcept:nil];

	STAssertTrue(dirtyProxy.icWasRemovedHint, @"fucked up");
	_model.currentNodeGroup = (id)[childnode1 parentSHNode];
	
	NSArray *justToGiveItAPoke_becauseItUpdatesLazily = [dirtyProxy filteredContent];
	STAssertTrue([dirtyProxy originalNode]==_model.currentNodeGroup, @"what?");
	STAssertFalse(dirtyProxy.icWasRemovedHint, @"fucked up");
}

/*
- (void)testMouseDragLoopSendsQueuedNotification {

	It does if you use common modes - not if you use default modes
}
*/

- (void)testEveryCombinationOfBelow {

	SHNode *childnode1=[SHNode makeChildWithName:@"n1"], *childnode2=[SHNode makeChildWithName:@"n2"];
	SHInputAttribute *i1 = [SHInputAttribute makeChildWithName:@"i1"], *i2 = [SHInputAttribute makeChildWithName:@"i2"];
	SHOutputAttribute *o1 = [SHOutputAttribute makeChildWithName:@"o1"], *o2 = [SHOutputAttribute makeChildWithName:@"o2"];
	
	// add some shit
	[_model insertGraphics:[NSArray arrayWithObjects:childnode1, childnode2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:i1, i2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:o1, o2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	
	// select some shit
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode1]];
	
	// remove some shit
	[_model.currentNodeGroup deleteChild:i1 undoManager:nil];
	
	// add some more
	SHInterConnector* int2 = [_model connectOutletOfAttribute:i2 toInletOfAttribute:o2];

	// POST
	[_childProvider postPendingNotificationsExcept:nil];
}


- (void)testMultipleSelection {

	SHNode *childnode1=[SHNode makeChildWithName:@"n1"], *childnode2=[SHNode makeChildWithName:@"n2"];
	SHInputAttribute *i1 = [SHInputAttribute makeChildWithName:@"i1"], *i2 = [SHInputAttribute makeChildWithName:@"i2"];
	SHInputAttribute *i3 = [SHInputAttribute makeChildWithName:@"i3"], *i4 = [SHInputAttribute makeChildWithName:@"i4"];
	SHOutputAttribute *o1 = [SHOutputAttribute makeChildWithName:@"o1"], *o2 = [SHOutputAttribute makeChildWithName:@"o2"];
	[_model insertGraphics:[NSArray arrayWithObjects:childnode1, childnode2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:i1, i2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:i3, i4, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:o1, o2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	SHInterConnector* int2 = [_model connectOutletOfAttribute:i2 toInletOfAttribute:o2];
	[_childProvider postPendingNotificationsExcept:nil];

	// select some shit
	[_model.currentNodeGroup unSelectAllChildren];
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode1]];
	
	[_childProvider postPendingNotificationsExcept:nil];
	
	STAssertTrue( 1==[_selectionIndexes count], @"doh %i", [_selectionIndexes count]);
	STAssertTrue( 1==[_newlySelectedIndexes count], @"doh %i", [_newlySelectedIndexes count]);
	STAssertTrue( [_newlySelectedIndexes containsIndex:0], @"doh");
	STAssertTrue( 0==[_newlyDeselectedIndexes count], @"doh %i", [_newlyDeselectedIndexes count]);

	// select some more
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObject:childnode2]];
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObjects:i1, i2, nil]];
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObjects:i3, i4, nil]];
	[_model addChildrenToCurrentSelection:[NSArray arrayWithObject:int1]];

	[_childProvider postPendingNotificationsExcept:nil];
	
	STAssertTrue( 7==[_selectionIndexes count], @"doh %i", [_selectionIndexes count]);
	
	STAssertTrue( 6==[_newlySelectedIndexes count], @"doh %i", [_newlySelectedIndexes count]);
	STAssertTrue( [_newlySelectedIndexes containsIndex:1], @"doh");
	STAssertTrue( [_newlySelectedIndexes containsIndex:2], @"doh");
	STAssertTrue( [_newlySelectedIndexes containsIndex:3], @"doh");
	STAssertTrue( [_newlySelectedIndexes containsIndex:4], @"doh");
	STAssertTrue( [_newlySelectedIndexes containsIndex:5], @"doh");
	STAssertTrue( [_newlySelectedIndexes containsIndex:8], @"doh");

	STAssertTrue( 0==[_newlyDeselectedIndexes count], @"doh %i", [_newlyDeselectedIndexes count]);
	
	// try unselecting 
	[_model removeChildrenFromCurrentSelection:[NSArray arrayWithObject:childnode2]];
	[_childProvider postPendingNotificationsExcept:nil];

	//this is bullshit. _newlySelectedIndexes is fake - find out!
	
	STAssertTrue( 6==[_selectionIndexes count], @"doh %i", [_selectionIndexes count]);
	STAssertTrue( 0==[_newlySelectedIndexes count], @"doh %i", [_newlySelectedIndexes count]);
	STAssertTrue( 1==[_newlyDeselectedIndexes count], @"doh %i", [_newlyDeselectedIndexes count]);
	STAssertTrue( [_newlyDeselectedIndexes containsIndex:1], @"doh");
}

- (void)testMultipleRemove {

	SHNode *childnode1=[SHNode makeChildWithName:@"n1"], *childnode2=[SHNode makeChildWithName:@"n2"];
	SHNode *childnode3=[SHNode makeChildWithName:@"n3"], *childnode4=[SHNode makeChildWithName:@"n4"];
	SHInputAttribute *i1 = [SHInputAttribute makeChildWithName:@"i1"], *i2 = [SHInputAttribute makeChildWithName:@"i2"];
	SHOutputAttribute *o1 = [SHOutputAttribute makeChildWithName:@"o1"], *o2 = [SHOutputAttribute makeChildWithName:@"o2"];
	[_model insertGraphics:[NSArray arrayWithObjects:childnode1, childnode2, childnode3, childnode4, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,4)]];
	[_model insertGraphics:[NSArray arrayWithObjects:i1, i2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	[_model insertGraphics:[NSArray arrayWithObjects:o1, o2, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	SHInterConnector* int2 = [_model connectOutletOfAttribute:i2 toInletOfAttribute:o2];
	
	[_childProvider postPendingNotificationsExcept:nil];
	STAssertTrue(_willInsertContent==1, @"wha? %i", _willInsertContent);
	STAssertTrue(_didInsertContent==1, @"wha? %i", _didInsertContent);
	STAssertTrue([_insertedItems count]==10, @"wha? %i", [_insertedItems count]);

	// SIMPLE REMOVE
	[_model.currentNodeGroup deleteChild:childnode3 undoManager:nil];
	[_model.currentNodeGroup deleteChild:childnode1 undoManager:nil];
	[_model.currentNodeGroup deleteChild:childnode2 undoManager:nil];

	[_childProvider postPendingNotificationsExcept:nil];
	
	STAssertTrue([_removedItems count]==3, @"wha? %i", [_removedItems count]);
	STAssertTrue([_removedItemsIndexes count]==3, @"wha? %i", [_removedItemsIndexes count]);
	STAssertTrue([_insertedItemsIndexes containsIndex:0], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:1], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:2], @"wha?");
	
	// COMPLEX?
	NSUInteger ti1 = [_model.currentNodeGroup indexOfChild:childnode4];
	NSUInteger ti2 = [_model.currentNodeGroup indexOfChild:i2];
	NSUInteger ti3 = [_model.currentNodeGroup indexOfChild:o1];
	NSUInteger ti4 = [_model.currentNodeGroup indexOfChild:int1];
	NSUInteger ti5 = [_model.currentNodeGroup indexOfChild:int2];

	[_model.currentNodeGroup deleteChildren:[NSArray arrayWithObjects:childnode4, i2, nil] undoManager:nil];
	[_model.currentNodeGroup deleteChild:o1 undoManager:nil];

	[_childProvider postPendingNotificationsExcept:nil];
	
	// ics should have been removed too as we removed the attributes
	STAssertTrue([_removedItems count]==5, @"wha? %i", [_removedItems count]);
	STAssertTrue([_removedItemsIndexes count]==5, @"wha? %i", [_removedItemsIndexes count]);
	STAssertTrue([_removedItemsIndexes containsIndex:0], @"wha?");
	STAssertTrue([_removedItemsIndexes containsIndex:2], @"wha?");
	STAssertTrue([_removedItemsIndexes containsIndex:3], @"wha?");
	STAssertTrue([_removedItemsIndexes containsIndex:5], @"wha?");
	STAssertTrue([_removedItemsIndexes containsIndex:6], @"wha?");
}

- (void)testMultipleInsert{
	
	[_childProvider makeFilteredTreeUpToDate:_childProvider.rootNodeProxy];
	
	/* add objects */
	SHNode* childnode1 = [SHNode makeChildWithName:@"n1"];
	SHNode* childnode2 = [SHNode makeChildWithName:@"n2"];
	SHInputAttribute* i1 = [SHInputAttribute makeChildWithName:@"i1"];
	SHInputAttribute* i2 = [SHInputAttribute makeChildWithName:@"i2"];
	SHOutputAttribute* o1 = [SHOutputAttribute makeChildWithName:@"o1"];
	SHOutputAttribute* o2 = [SHOutputAttribute makeChildWithName:@"o2"];
	[_model NEW_addChild:childnode1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:childnode2 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:i1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:i2 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:o1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:o2 toNode:_model.rootNodeGroup];
	SHInterConnector* int1 = [_model connectOutletOfAttribute:i1 toInletOfAttribute:o1];
	SHInterConnector* int2 = [_model connectOutletOfAttribute:i2 toInletOfAttribute:o2];
	
	[_childProvider postPendingNotificationsExcept:nil];
	
	//- check that we got notified
	STAssertTrue([_insertedItems count]==8, @"wha? %i", [_insertedItems count]);
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:0] originalNode]==(id)childnode1, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:1] originalNode]==(id)childnode2, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:2] originalNode]==(id)i1, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:3] originalNode]==(id)i2, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:4] originalNode]==(id)o1, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:5] originalNode]==(id)o2, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:6] originalNode]==(id)int1, @"wha?");
	STAssertTrue([(NodeProxy *)[_insertedItems objectAtIndex:7] originalNode]==(id)int2, @"wha?");

	STAssertTrue([_insertedItemsIndexes count]==8, @"wha? %i", [_insertedItemsIndexes count]);// at indexes 0,1,2,3
	STAssertTrue([_insertedItemsIndexes containsIndex:0], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:1], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:2], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:3], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:4], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:5], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:6], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:7], @"wha?");
	
	/* Do a more compilicated index insert here ? */
	SHNode* childnode3 = [SHNode makeChildWithName:@"n1"];
	SHNode* childnode4 = [SHNode makeChildWithName:@"n2"];
	NSArray *childrenToInsert1 = [NSArray arrayWithObjects:childnode3, childnode4, nil];
	NSMutableIndexSet *insertionIndexes1 = [NSMutableIndexSet indexSetWithIndex:0];
	[insertionIndexes1 addIndex:2];
	[_model insertGraphics:childrenToInsert1 atIndexes:insertionIndexes1];
	 
	SHInputAttribute* i3 = [SHInputAttribute makeChildWithName:@"i3"];
	SHInputAttribute* i4 = [SHInputAttribute makeChildWithName:@"i4"];
	NSArray *childrenToInsert2 = [NSArray arrayWithObjects:i3, i4, nil];
	NSMutableIndexSet *insertionIndexes2 = [NSMutableIndexSet indexSetWithIndex:0];
	[insertionIndexes2 addIndex:2];
	[_model insertGraphics:childrenToInsert2 atIndexes:insertionIndexes2];

	[_childProvider postPendingNotificationsExcept:nil];

	STAssertTrue([_insertedItems count]==4, @"wha? %i", [_insertedItems count]);
	STAssertTrue([_insertedItemsIndexes containsIndex:0], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:2], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:4], @"wha?");
	STAssertTrue([_insertedItemsIndexes containsIndex:6], @"wha?");
}
//
//- (void)testCleansUpProperly {
//	
//	[_childProvider makeFilteredTreeUpToDate:_childProvider.rootNodeProxy];
//	[self addTestNodes];
//	
//	// NEED TO RESET THE COALESCER
//	[_childProvider _doDelayedInsertionNotification];
//	[_childProvider->_contentInsertionNotificationCoalescer notificationDidFire_callback];
//	
//	STAssertTrue( [[_childProvider.currentNodeProxy filteredContent] count]==12, @"doh %i", [[_childProvider.currentNodeProxy filteredContent] count] );
//	
//	// -- do some selection
//	NSArray *allNodes = [[_model.currentNodeGroup nodesInside] array];
//	NSArray *allInputs = [[_model.currentNodeGroup inputs] array];
//	NSArray *allOutputs = [[_model.currentNodeGroup outputs] array];
//	NSArray *allICs = [[_model.currentNodeGroup shInterConnectorsInside] array];
//	
//	NSArray *childrenToSelect = [NSArray arrayWithObjects: 
//								 [allNodes objectAtIndex:1], [allNodes objectAtIndex:2],
//								 [allInputs objectAtIndex:1], [allInputs objectAtIndex:2],
//								 [allOutputs objectAtIndex:1], [allOutputs objectAtIndex:2],
//								 [allICs objectAtIndex:1], [allICs objectAtIndex:2],
//								 nil];
//	
//	[_model.currentNodeGroup setSelectedChildren:childrenToSelect];
//	
//	// clean up
//	[_childProvider unRegisterAUser:self];
//	[_childProvider cleanUpFilter];	
//}

@end
