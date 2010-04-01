//
//  NodeClassFilterTests.m
//  BlakeLoader
//
//  Created by steve hooley on 21/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/SHNodeGraph.h>
#import <SHNodeGraph/NodeClassFilter.h>
#import <SHNodeGraph/NodeProxy.h>
#import <SHNodeGraph/SHAbstractOperator.h>

#import "MockProducer.h"
#import "MockConsumer.h"
#import "MockProcessor.h"

@interface NodeClassFilterTests : SenTestCase <SHContentProviderUserProtocol> {
	
	SHNodeGraphModel		*_model;
	NodeClassFilter			*_graphicsProvider;
	
	NodeProxy *_changedProxy;
	NSArray *_changedContent;
	NSArray *_insertedContent;
	NSArray *_removedContent;
	NSMutableIndexSet *_changedSelectionIndexes;
}

@end

static BOOL selectionDidChange = NO;
static BOOL filteredContentDidChange = NO;
static int selectionChangeCount = 0;
static int filteredContentChangeCount = 0;
static id changeIndexes;


@implementation NodeClassFilterTests
		
//-- filter to only provide circles & Groups
+ (void)resetObservers {

	selectionDidChange = NO;
	filteredContentDidChange = NO;
	selectionChangeCount = 0;
	filteredContentChangeCount = 0;
    changeIndexes = nil;
}

- (void)setUp {

	_model = [[SHNodeGraphModel makeEmptyModel] retain];

	_graphicsProvider = [[NodeClassFilter alloc] init];
    [_graphicsProvider setClassFilter:@"MockProducer"];
	
	/* lets begin with some content in the model to verify it picks it up */
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"];
	MockProducer *graphic1 = [MockProducer makeChildWithName:@"graphic1"];
	[ng1 addChild:graphic1 undoManager:nil];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:0];
    [_graphicsProvider setModel:_model];
	
	// check the initial proxy tree
	STAssertTrue( [_graphicsProvider.rootNodeProxy.filteredContent count]==1, @"%i", [_graphicsProvider.rootNodeProxy.filteredContent count] );
	NodeProxy *child1 = [_graphicsProvider.rootNodeProxy.filteredContent objectAtIndex:0];
	STAssertTrue( child1.originalNode == ng1, @"should be %@", child1.originalNode.name );
	STAssertTrue( [child1.filteredContent count]==1, @"%i", [child1.filteredContent count] );
	NodeProxy *child2_1 = [child1.filteredContent objectAtIndex:0];
	STAssertTrue( child2_1.originalNode == graphic1, @"should be");
	
//doWeNeedToObserveEachProxy	STAssertTrue(_graphicsProvider.rootNodeProxy.isObservingChildren, @"Doh");
//doWeNeedToObserveEachProxy	STAssertTrue(child1.isObservingChildren, @"Doh");

	
 //	[_graphicsProvider addObserver:self forKeyPath:@"filteredContent" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"NodeClassFilterTests"];
// 	[_graphicsProvider addObserver:self forKeyPath:@"filteredContentSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"NodeClassFilterTests"];
}

- (void)tearDown {

	[_graphicsProvider cleanUpFilter];	
// 	[_graphicsProvider removeObserver:self forKeyPath:@"filteredContentSelectionIndexes"];
//	[_graphicsProvider removeObserver:self forKeyPath:@"filteredContent"];
	[_graphicsProvider release];
	[_model release];
}

static AbtractModelFilter *filt;
- (AbtractModelFilter *)filter {
	return filt;
}
- (void)setFilter:(AbtractModelFilter *)value {
	filt = value;
}

#pragma mark Our custom notification handlers
/* content */
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
	_changedProxy = proxy;
	_changedContent = values;	
}

- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {
	_changedProxy = proxy;
	_insertedContent = proxiesForsuccessFullObjects;	
}

- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
	_changedProxy = proxy;
	_removedContent = values;	
}

/* selection */
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {
}
// bear in mind that indexesOfSelectedObjectsThatPassFilter is actually an array and the changed indexes are actually the first item
- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {
	_changedProxy = proxy;
	// experimenting with passing an array instead of NSMutableIndexSet.
	// the NSMutableIndexSet contained changed indexes - 
	// the array contains changed indexes, new indexes, old indexes
	_changedSelectionIndexes = [(NSArray *)indexesOfSelectedObjectsThatPassFilter objectAtIndex:0];
	selectionDidChange = YES;
	selectionChangeCount++;
}

#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
	changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
    
    if( [context isEqualToString:@"NodeClassFilterTests"] )
	{
		if( [keyPath isEqualToString:@"filteredContent"] ){
			filteredContentDidChange = YES;
			filteredContentChangeCount++;
			
		 } else if( [keyPath isEqualToString:@"filteredContentSelectionIndexes"] ){
			selectionDidChange = YES;
			selectionChangeCount++;
		 }
		
	 } else {
         NSLog(@"Unknown context is %@", context);
         [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	 }
}

#pragma mark Class methods
// which keypaths of the model does the filter observe?
- (void)testModelKeyPathsToObserve {
	// + (NSArray *)modelKeyPathsToObserve
	
	NSArray *mk = [NodeClassFilter modelKeyPathsToObserve];
	STAssertTrue( [[mk objectAtIndex:0] isEqualToString:@"childContainer.nodesInside.array"], @"should be %@", [mk objectAtIndex:0] );	
	STAssertTrue( [[mk objectAtIndex:1] isEqualToString:@"childContainer.nodesInside.selection"], @"should be" );
}

- (void)testSelectorForChangedKeyPath {
	// + (SEL)selectorForWillChangeKeyPath:(NSString *)keyPath
	// + (SEL)selectorForChangedKeyPath:(NSString *)keyPath
	
	/* When the model changes, what would you like to get called? */
	STAssertTrue( [NodeClassFilter selectorForWillChangeKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillChange:nodesInside_to:from:), @"should be");
	STAssertTrue( [NodeClassFilter selectorForWillChangeKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillChange:nodesInsideSelection_to:from:), @"should be");
	STAssertThrows( [NodeClassFilter selectorForWillChangeKeyPath:@"chicken"], @"must be validkeypath" );
	
	STAssertTrue( [NodeClassFilter selectorForChangedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelChanged:nodesInside_to:from:), @"should be");
	STAssertTrue( [NodeClassFilter selectorForChangedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelChanged:nodesInsideSelection_to:from:), @"should be");
	STAssertThrows( [NodeClassFilter selectorForChangedKeyPath:@"chicken"], @"must be validkeypath" );
}

- (void)testSelectorForInsertedKeyPath {
	// + (SEL)selectorForWillInsertKeyPath:(NSString *)keyPath
	// + (SEL)selectorForInsertedKeyPath:(NSString *)keyPath
	
	/* When the model changes, what would you like to get called? */
	STAssertTrue( [NodeClassFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillInsert:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.array"]));
	
	STAssertTrue( [NodeClassFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillInsert:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForWillInsertKeyPath:@"childContainer.nodesInside.selection"]));
	
	STAssertThrows( [NodeClassFilter selectorForWillInsertKeyPath:@"chicken"], @"must be validkeypath" );
	
	STAssertTrue( [NodeClassFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelInserted:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.array"]));

	STAssertTrue( [NodeClassFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelInserted:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForInsertedKeyPath:@"childContainer.nodesInside.selection"]));

	STAssertThrows( [NodeClassFilter selectorForInsertedKeyPath:@"chicken"], @"must be validkeypath" );
}

- (void)testSelectorForReplacedKeyPath {
	// + (SEL)selectorForWillReplaceKeyPath:(NSString *)keyPath
	//+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath
	
	/* When the model changes, what would you like to get called? */
	STAssertTrue( [NodeClassFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillReplace:nodesInside:with:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.array"]) );
	
	STAssertTrue( [NodeClassFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillReplace:nodesInsideSelection:with:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForWillReplaceKeyPath:@"childContainer.nodesInside.selection"]));
	
	STAssertThrows( [NodeClassFilter selectorForWillReplaceKeyPath:@"chicken"], @"must be validkeypath" );
	
	STAssertTrue( [NodeClassFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelReplaced:nodesInside:with:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.array"]) );

	STAssertTrue( [NodeClassFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelReplaced:nodesInsideSelection:with:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForReplacedKeyPath:@"childContainer.nodesInside.selection"]));
	
	STAssertThrows( [NodeClassFilter selectorForReplacedKeyPath:@"chicken"], @"must be validkeypath" );
}

- (void)testSelectorForRemovedKeyPath {
	// + (SEL)selectorForWillRemoveKeyPath:(NSString *)keyPath
	// + (SEL)selectorForRemovedKeyPath:(NSString *)keyPath
	
	/* When the model changes, what would you like to get called? */
	STAssertTrue( [NodeClassFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.array"]==@selector(modelWillRemove:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.array"]));
	
	STAssertTrue( [NodeClassFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelWillRemove:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForWillRemoveKeyPath:@"childContainer.nodesInside.selection"]));
	
	STAssertThrows( [NodeClassFilter selectorForWillRemoveKeyPath:@"chicken"], @"must be validkeypath" );	
	
	
	STAssertTrue( [NodeClassFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.array"]==@selector(modelRemoved:nodesInside:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.array"]));

	STAssertTrue( [NodeClassFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.selection"]==@selector(modelRemoved:nodesInsideSelection:atIndexes:), @"should be %@", NSStringFromSelector([NodeClassFilter selectorForRemovedKeyPath:@"childContainer.nodesInside.selection"]));

	STAssertThrows( [NodeClassFilter selectorForRemovedKeyPath:@"chicken"], @"must be validkeypath" );
}

#pragma mark Instance Methods
- (void)testObjectPassesFilter {
	// - (BOOL)objectPassesFilter:(id)value

	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockConsumer *noneGraphic = [[[MockConsumer alloc] init] autorelease];

	STAssertTrue([_graphicsProvider objectPassesFilter:newGraphic1], @"didnt we set the filter?");
	STAssertFalse([_graphicsProvider objectPassesFilter:noneGraphic], @"didnt we set the filter?");
	STAssertFalse([_graphicsProvider objectPassesFilter:nil], @"didnt we set the filter?");
}

/* Test that the culling works */
- (void)testObjectsAndIndexesThatPassFilter {
	// - (void)objectsAndIndexesThatPassFilter:(NSArray *)objects :(NSIndexSet *)indexes :(NSMutableArray *)successFullObjects :(NSMutableIndexSet *)successFullIndexes

	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
	
	NSArray *graphics = [NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil];
	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,6)];
	NSMutableArray *successFullObjects = [NSMutableArray array];
	NSMutableIndexSet *successFullIndexes = [NSMutableIndexSet indexSet];
	
	[_graphicsProvider objectsAndIndexesThatPassFilter:graphics :indexes :successFullObjects :successFullIndexes];
	STAssertTrue([successFullObjects count]==3, @"er?");
	STAssertTrue([successFullObjects objectAtIndex:0]==newGraphic1, @"er?");
	STAssertTrue([successFullObjects objectAtIndex:1]==newGraphic2, @"er?");
	STAssertTrue([successFullObjects objectAtIndex:2]==newGraphic3, @"er?");

	STAssertTrue([successFullIndexes count]==3, @"er?");
	STAssertTrue([successFullIndexes containsIndex:0], @"er?");
	STAssertTrue([successFullIndexes containsIndex:2], @"er?");
	STAssertTrue([successFullIndexes containsIndex:4], @"er?");
}

- (void)testRegisterAsUser {
	//- (void)registerAUser:(id<SHContentProviderUserProtocol>)user
	//- (void)unRegisterAUser:(id<SHContentProviderUserProtocol>)user
	//- (BOOL)hasUsers
		
	STAssertFalse([_graphicsProvider hasUsers], @"doh!");
	[_graphicsProvider registerAUser:self];
	STAssertTrue([_graphicsProvider hasUsers], @"doh!");
	[_graphicsProvider unRegisterAUser:self];
	STAssertFalse([_graphicsProvider hasUsers], @"doh!");
}

// V2 method to add all children of a proxy
- (void)testMakeFilteredTreeUpToDate {
// - (void)makeFilteredTreeUpToDate:(NodeProxy *)value

	// ng1 ¬
	//	-- graphic1
	//	-- ng2 ¬
	//		-- graphic2
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"], *ng2 = [SHNode makeChildWithName:@"ng2"];
	MockProducer *graphic1 = [MockProducer makeChildWithName:@"graphic1"], *graphic2 = [MockProducer makeChildWithName:@"graphic2"];
	[ng1 addChild:graphic1 undoManager:nil];
	[ng2 addChild:graphic2 undoManager:nil];
	[ng1 addChild:ng2 undoManager:nil];
	NodeProxy *rootNodeProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
	
	// Lazily building content, calling -filteredContent causes -makeFilteredTreeUpToDate to be called
	STAssertTrue( [rootNodeProxy.filteredContent count]==2, @"%i", [rootNodeProxy.filteredContent count] );
	
	// update
	STAssertThrows([_graphicsProvider makeFilteredTreeUpToDate:rootNodeProxy], @"we shouldnt be able"); 

	STAssertTrue( [rootNodeProxy.filteredContent count]==2, @"%i", [rootNodeProxy.filteredContent count] );
	NodeProxy *child1 = [rootNodeProxy.filteredContent objectAtIndex:0];
	NodeProxy *child2 = [rootNodeProxy.filteredContent objectAtIndex:1];
	STAssertTrue( child1.originalNode == graphic1, @"should be %@", child1.originalNode.name );
	STAssertTrue( child2.originalNode == ng2, @"should be %@", child2.originalNode.name );
	STAssertTrue( [child2.filteredContent count]==1, @"%i", [child2.filteredContent count] );
	NodeProxy *child2_1 = [child2.filteredContent objectAtIndex:0];
	STAssertTrue( child2_1.originalNode == graphic2, @"should be");
	
	// -- check that all Proxies are observing their original nodes
	// rootNodeProxy wont be because we aren't using a model
	STAssertFalse(rootNodeProxy.isObservingChildren, @"Doh");
	
	STAssertFalse(child1.isObservingChildren, @"Doh");
	STAssertFalse(child2.isObservingChildren, @"Doh");
	STAssertFalse(child2_1.isObservingChildren, @"Doh");
	
	[rootNodeProxy stopObservingOriginalNode];
}

#pragma mark TEST FilteredTree Mirrors Model

/* lets get down to the meat and veg instead of this added stuff to the model crap */
- (void)testModelChanged_NodesInside_to {
	// - (void)modelWillChange:(NodeProxy *)proxy nodesInside_to:(id)newValue from:(id)oldValue
	// - (void)modelChanged:(NodeProxy *)proxy nodesInside_to:(id)newValue;
	
	// ng1 ¬
	//	-- graphic1
	//	-- ng2 ¬
	//		-- graphic2
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"], *ng2 = [SHNode makeChildWithName:@"ng2"];
	MockProducer *graphic1 = [MockProducer makeChildWithName:@"graphic1"], *graphic2 = [MockProducer makeChildWithName:@"graphic2"];
	[ng1 addChild:graphic1 undoManager:nil];
	[ng2 addChild:graphic2 undoManager:nil];
	[ng1 addChild:ng2 undoManager:nil];
	
	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
	// update
	[_graphicsProvider makeFilteredTreeUpToDate:rootProxy]; 
	[_graphicsProvider registerAUser:self];


	// we will swap in this stuff and check that all levels are reflected in the filtered model and that all observancies are correct
	// ng1 ¬
	//	-- r_audio1
	//	-- r_graphic1
	//	-- r_ng2 ¬
	//		-- r_audio2
	//		-- r_audio3
	//		-- r_ng3
	SHNode *r_ng2=[SHNode makeChildWithName:@"r_ng2"], *r_ng3=[SHNode makeChildWithName:@"r_ng3"];
	MockProducer *r_graphic1=[MockProducer makeChildWithName:@"r_graphic1"];
	MockConsumer *r_audio1=[MockConsumer makeChildWithName:@"r_audio1"], *r_audio2=[MockConsumer makeChildWithName:@"r_audio2"], *r_audio3=[MockConsumer makeChildWithName:@"r_audio3"];

	[r_ng2 addChild:r_audio2 undoManager:nil];
	[r_ng2 addChild:r_audio3 undoManager:nil];
	[r_ng2 addChild:r_ng3 undoManager:nil];

	NSArray *newNodesInside = [NSArray arrayWithObjects: r_audio1, r_graphic1, r_ng2, nil];

//doWeNeedToObserveEachProxy	[rootProxy startObservingOriginalNode];
	
	[_graphicsProvider modelWillChange:rootProxy nodesInside_to:newNodesInside from:nil]; // from isn't used at the moment
	[_graphicsProvider modelChanged:rootProxy nodesInside_to:newNodesInside from:nil]; // from isn't used at the moment
	
	/* check the objects inside */
	STAssertTrue( [rootProxy.filteredContent count]==2, @"%i", [rootProxy.filteredContent count] );
	NodeProxy *child1 = [rootProxy.filteredContent objectAtIndex:0];
	NodeProxy *child2 = [rootProxy.filteredContent objectAtIndex:1];
	STAssertTrue( child1.originalNode == r_graphic1, @"should be %@", child1.originalNode.name );
	STAssertTrue( child2.originalNode == r_ng2, @"should be %@", child2.originalNode.name);
	STAssertTrue( [child1.filteredContent count]==0, @"%i", [child1.filteredContent count] );
	STAssertTrue( [child2.filteredContent count]==1, @"%i", [child2.filteredContent count] );
	NodeProxy *child2_1 = [child2.filteredContent objectAtIndex:0];
	STAssertTrue( child2_1.originalNode == r_ng3, @"should be");

	/* check the indexes inside */
	STAssertTrue( [rootProxy.indexesOfFilteredContent count]==2, @"%i", [rootProxy.indexesOfFilteredContent count] );
	STAssertTrue( [rootProxy.indexesOfFilteredContent firstIndex]==1, @"%i", [rootProxy.indexesOfFilteredContent firstIndex] );
	STAssertTrue( [child1.indexesOfFilteredContent count]==0, @"%i", [child1.indexesOfFilteredContent count] );
	STAssertTrue( [child2.indexesOfFilteredContent count]==1, @"%i", [child2.indexesOfFilteredContent count] );
	STAssertTrue( [child2.indexesOfFilteredContent firstIndex]==2, @"%i", [child2.indexesOfFilteredContent firstIndex] );
	
	/* check that observations have been set */
	STAssertTrue( [rootProxy isObservingChildren]==NO, @"%i", [rootProxy isObservingChildren] );
	STAssertTrue( [child1 isObservingChildren]==NO, @"%i", [child1 isObservingChildren] );
	STAssertTrue( [child2 isObservingChildren]==NO, @"%i", [child2 isObservingChildren] );
	STAssertTrue( [child2_1 isObservingChildren]==NO, @"%i", [child2_1 isObservingChildren] );
	
	/* How many notifications were received? */
	//ng1 ¬				2
	//	-- r_audio1		0
	//	-- r_graphic1	1
	//	-- r_ng2 ¬		1
	//		-- r_audio2	0
	//		-- r_audio3	0
	//		-- r_ng3	1

	STAssertTrue(_changedProxy==rootProxy, @"eh?");
	STAssertTrue([_changedContent count]==2, @"eh?");
	STAssertTrue([[_changedContent objectAtIndex:0] originalNode]==r_graphic1, @"eh? %@", [[_changedContent objectAtIndex:0] originalNode]);
	STAssertTrue([[_changedContent objectAtIndex:1] originalNode]==r_ng2, @"eh?");
	
	//V2
	STAssertTrue( [rootProxy debug_arrayNotificationsReceivedCount]==0, @"%i", [rootProxy debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [child1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child1 debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [child2 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2 debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [child2_1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2_1 debug_arrayNotificationsReceivedCount] );

	[_graphicsProvider unRegisterAUser:self];
	[rootProxy stopObservingOriginalNode];
}

- (void)testModelInserted_nodesInside_atIndexes {
	// - (void)modelWillInsert:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
	//- (void)modelInserted:(NodeProxy *)proxy nodesInside:(id)newValue atIndexes:(NSIndexSet *)changeIndexes

	// ng1 ¬
	//	-- graphic1
	//	-- ng2 ¬
	//		-- graphic2
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"], *ng2 = [SHNode makeChildWithName:@"ng2"];
	MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
	[ng1 addChild:graphic1 undoManager:nil];
	[ng2 addChild:graphic2 undoManager:nil];
	[ng1 addChild:ng2 undoManager:nil];

	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
//	[_graphicsProvider makeFilteredTreeUpToDate:rootProxy]; 
//doWeNeedToObserveEachProxy	[rootProxy startObservingOriginalNode];
	
	// this will cause us to create the children proxies
	STAssertTrue( [rootProxy.filteredContent count]==2, @"%i", [rootProxy.filteredContent count] );
	NodeProxy *child1 = [rootProxy.filteredContent objectAtIndex:0];
	NodeProxy *ng2Proxy = [rootProxy.filteredContent objectAtIndex:1];
	STAssertTrue( child1.originalNode == graphic1, @"should be");
	STAssertTrue( ng2Proxy.originalNode == ng2, @"should be");

	/* Insert some new nodes into the structure */
	SHNode *r_ng2 = [SHNode makeChildWithName:@"n1"];
	MockProducer *r_graphic1 = [[MockProducer new] autorelease], *r_graphic3 = [[MockProducer new] autorelease];
	MockConsumer *r_audio1 = [[MockConsumer new] autorelease];
	[r_ng2 addChild:r_graphic3 undoManager:nil];

	// ng1 ¬
	//	-- graphic1
	//	-- ng2 ¬
	//		-- ** r_graphic1 **
	//		-- r_graphic1
	//		-- ** r_ng2 ** ¬
	//			-- r_graphic2
	NSArray *nodesToInsert = [NSArray arrayWithObjects: r_graphic1, r_audio1, r_ng2, nil];
	NSMutableIndexSet *insertionPoints = [NSMutableIndexSet indexSetWithIndex:0];
	[insertionPoints addIndexesInRange:NSMakeRange(2, 2)];

	// oh! for this we must insert into the model and let the kvo call the method we want to test 
	// (there is some debugging stuff in node proxy which will verify it's values against the original values in the model, it will fail if they aren't really in sync)

	[_graphicsProvider registerAUser:self];
	[_graphicsProvider setCurrentNodeProxy:ng2Proxy];
	
	/*	Important - we assume that you only want notifications if you have already started using the value. ie - there is no 'initial' notification 
		Therefore is we left out the following line we would not receive a notification of the insert
	 */
	STAssertTrue( [ng2Proxy.filteredContent count]==1, @"%i", [ng2Proxy.filteredContent count] );
	[ng2 addItemsOfSingleType:nodesToInsert atIndexes:insertionPoints undoManager:nil];
	// [_graphicsProvider modelInserted:ng2Proxy nodesInside:nodesToInsert atIndexes:insertionPoints];

	/* check the objects inside */
	STAssertTrue( [child1.filteredContent count]==0, @"%i", [child1.filteredContent count] );
	STAssertTrue( [ng2Proxy.filteredContent count]==3, @"%i", [ng2Proxy.filteredContent count] );
	NodeProxy *child2_1 = [ng2Proxy.filteredContent objectAtIndex:0];
	NodeProxy *child2_2 = [ng2Proxy.filteredContent objectAtIndex:1];
	NodeProxy *child2_3 = [ng2Proxy.filteredContent objectAtIndex:2];
	STAssertTrue( child2_1.originalNode == r_graphic1, @"should be %@", child2_1.originalNode);
	STAssertTrue( child2_2.originalNode == graphic2, @"should be %@", child2_2.originalNode );
	STAssertTrue( child2_3.originalNode == r_ng2, @"should be %@", child2_3.originalNode );
	STAssertTrue( [child2_3.filteredContent count]==1, @"%i", [child2_3.filteredContent count] );

	/* check the indexes inside */
	STAssertTrue( [ng2Proxy.indexesOfFilteredContent count]==3, @"%i", [ng2Proxy.indexesOfFilteredContent count] );
	STAssertTrue( [child2_1.indexesOfFilteredContent count]==0, @"%i", [child2_1.indexesOfFilteredContent count] );
	STAssertTrue( [child2_2.indexesOfFilteredContent count]==0, @"%i", [child2_2.indexesOfFilteredContent count] );
	STAssertTrue( [child2_3.indexesOfFilteredContent count]==1, @"%i", [child2_3.indexesOfFilteredContent count] );

	/* check that observations have been set */
	STAssertTrue( [ng2Proxy isObservingChildren]==YES, @"%i", [ng2Proxy isObservingChildren] );
	STAssertTrue( [child2_1 isObservingChildren]==NO, @"%i", [child2_1 isObservingChildren] );
	STAssertTrue( [child2_2 isObservingChildren]==NO, @"%i", [child2_2 isObservingChildren] );
	STAssertTrue( [child2_3 isObservingChildren]==NO, @"%i", [child2_2 isObservingChildren] );

	/* How many notifications were received? */
	STAssertTrue(_changedProxy==ng2Proxy, @"eh?");
	STAssertTrue([_insertedContent count]==2, @"eh?");
	STAssertTrue([[_insertedContent objectAtIndex:0] originalNode]==r_graphic1, @"eh?");
	STAssertTrue([[_insertedContent objectAtIndex:1] originalNode]==r_ng2, @"eh?");
	
	/* when this breaks cause we have added selection: change notificationsReceivedCount to graphics_notificationsReceivedCount and selection_notificationsReceivedCount */
	STAssertTrue( [child1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child1 debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [ng2Proxy debug_arrayNotificationsReceivedCount]==1, @"%i", [ng2Proxy debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [child2_1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2_1 debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [child2_2 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2_2 debug_arrayNotificationsReceivedCount] );
	STAssertTrue( [child2_3 debug_arrayNotificationsReceivedCount]==0, @"%i", [child2_3 debug_arrayNotificationsReceivedCount] );
	[_graphicsProvider unRegisterAUser:self];
	[rootProxy stopObservingOriginalNode];
}

- (void)testInsertWorksWhenReorderingNodes {

	SHNode *ng1 = [SHNode makeChildWithName:@"n1"], *ng2 = [SHNode makeChildWithName:@"n2"], *ng3 = [SHNode makeChildWithName:@"n3"];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];

	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:audio1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:graphic1 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:audio2 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:ng3 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:ng2 toNode:_model.rootNodeGroup];
	[_model NEW_addChild:graphic2 toNode:_model.rootNodeGroup];

	/* SWAP INDEXES */
	/* -- now to break it, swap the order of some child nodes -- */
	[_model add:1 toIndexOfChild:ng3];

	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];
	NSArray *filteredContent = rootProxy.filteredContent;
	STAssertTrue([filteredContent count]==6, @"eh %i", [filteredContent count]);
	// NodeProxy *o1 = [filteredContent objectAtIndex:0]; // this should be the one added in setup
	NodeProxy *o2 = [filteredContent objectAtIndex:1];
	NodeProxy *o3 = [filteredContent objectAtIndex:2];	
	NodeProxy *o4 = [filteredContent objectAtIndex:3];
	NodeProxy *o5 = [filteredContent objectAtIndex:4];
	NodeProxy *o6 = [filteredContent objectAtIndex:5];
	// STAssertTrue( o1.originalNode == ng1, @"should be %@", o1.originalNode); // this should be the one added in setup
	STAssertTrue( o2.originalNode == ng1, @"should be %@", o2.originalNode );
	STAssertTrue( o3.originalNode == graphic1, @"should be %@", o3.originalNode );
	STAssertTrue( o4.originalNode == ng2, @"should be %@", o4.originalNode);
	STAssertTrue( o5.originalNode == ng3, @"should be %@", o5.originalNode );
	STAssertTrue( o6.originalNode == graphic2, @"should be %@", o6.originalNode );

	[_model add:1 toIndexOfChild:audio1];
}

- (void)testModelWillReplaceNodesInsideWithAtIndexes {
	// - (void)modelWillReplace:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes

	SHNode *ng1 = [SHNode makeChildWithName:@"n1"];
	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
	NSArray *currentNodes = [NSArray arrayWithObjects: ng1, nil];

	/* Insert some new nodes into the structure */
	MockProducer *r_graphic1 = [[MockProducer new] autorelease];
	NSArray *nodesToInsert = [NSArray arrayWithObjects: r_graphic1, nil];
	NSMutableIndexSet *insertionPoints = [NSMutableIndexSet indexSetWithIndex:0];
	
	STAssertThrows( [_graphicsProvider modelWillReplace:rootProxy nodesInside:currentNodes with:nodesToInsert atIndexes:insertionPoints], @"BAh!" );
}

- (void)testModelReplacedNodesInsideWithAtIndexes {
	// - (void)modelReplaced:(NodeProxy *)proxy nodesInside:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes

	SHNode *ng1 = [SHNode makeChildWithName:@"n1"];
	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
	NSArray *currentNodes = [NSArray arrayWithObjects: ng1, nil];

//doWeNeedToObserveEachProxy	[rootProxy startObservingOriginalNode];
	
	/* Insert some new nodes into the structure */
	MockProducer *r_graphic1 = [[MockProducer new] autorelease];
	NSArray *nodesToInsert = [NSArray arrayWithObjects: r_graphic1, nil];
	NSMutableIndexSet *insertionPoints = [NSMutableIndexSet indexSetWithIndex:0];
	
	STAssertThrows( [_graphicsProvider modelReplaced:rootProxy nodesInside:currentNodes with:nodesToInsert atIndexes:insertionPoints], @"BAh!" );
	
//doWeNeedToObserveEachProxy	[rootProxy stopObservingOriginalNode];
}

//-- root¬ (3)
//-- -- ng1¬	(4)
//-- -- -- audio1
//-- -- -- graphic1
//-- -- -- ng2¬	(4)
//-- -- -- -- audio2
//-- -- -- -- ng3
//-- -- -- -- graphic3
//-- -- -- -- graphic4
//-- -- -- graphic2
//-- -- ng4
//-- -- graphic5
- (NodeProxy *)addTestNodes {
    
	SHNode *root = _model.rootNodeGroup;
	SHNode *ng1 = (SHNode *)[root nodeAtIndex:0];
	STAssertTrue([[ng1.name value] isEqualToString:@"ng1"], @"%@", [ng1.name value]);

	SHNode *ng2 = [SHNode makeChildWithName:@"nodeGroup2"],  *ng3 = [SHNode makeChildWithName:@"nodeGroup3"], *ng4 = [SHNode makeChildWithName:@"nodeGroup4"];
	MockProducer *graphic2 = [MockProducer makeChildWithName:@"graphic2"], *graphic3 = [MockProducer makeChildWithName:@"graphic3"], *graphic4 = [MockProducer makeChildWithName:@"graphic4"], *graphic5 = [MockProducer makeChildWithName:@"graphic5"];
	MockConsumer *audio1 = [MockConsumer makeChildWithName:@"audio1"], *audio2 = [MockConsumer makeChildWithName:@"audio2"];

	_model.currentNodeGroup = ng1;
	[ng1 addChild:audio1 atIndex:0 undoManager:nil];
//    [ng1 addChild:graphic1 undoManager:nil];

    [ng2 addChild:audio2 undoManager:nil];
	[ng2 addChild:ng3 undoManager:nil];
	[ng2 addChild:graphic3 undoManager:nil];
	[ng2 addChild:graphic4 undoManager:nil];

    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];

	_model.currentNodeGroup = root;
	[root addChild:ng4 undoManager:nil];
	[root addChild:graphic5 undoManager:nil];

	STAssertTrue([root countOfChildren]==3, @"doh %i", [root countOfChildren] );
	STAssertTrue([ng1 countOfChildren]==4, @"doh %i", [ng1 countOfChildren] );
	STAssertTrue([ng2 countOfChildren]==4, @"doh %i", [ng2 countOfChildren] );

	//	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
 //doWeNeedToObserveEachProxy [rootProxy startObservingOriginalNode];
    return nil;
}

- (void)testModelRemovedNodesInsideAtIndexes {
	// - (void)modelWillRemove:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	// - (void)modelRemoved:(NodeProxy *)proxy nodesInside:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
	
	SHNode *ng1 = [SHNode makeChildWithName:@"n1"],  *ng2 = [SHNode makeChildWithName:@"n2"], *ng3 = [SHNode makeChildWithName:@"n3"];
	MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
	MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	NodeProxy *rootProxy = [NodeProxy makeNodeProxyWithFilter:_graphicsProvider object:ng1];
	
	// update -- this would normally be called when we setModel
	[_graphicsProvider registerAUser:self];
	[_graphicsProvider makeFilteredTreeUpToDate:rootProxy]; 
	
//doWeNeedToObserveEachProxy	[rootProxy startObservingOriginalNode];

	// Remove some children from model
	NSArray *currentNodes = [NSArray arrayWithObjects:audio1, ng2, graphic2, nil];
	NSMutableIndexSet *removalPoints = [NSMutableIndexSet indexSetWithIndex:0];
	[removalPoints addIndexesInRange:NSMakeRange(2,2)];
	
	[_graphicsProvider modelWillRemove:rootProxy nodesInside:currentNodes atIndexes:removalPoints];
	[_graphicsProvider modelRemoved:rootProxy nodesInside:currentNodes atIndexes:removalPoints];

	STAssertTrue( [rootProxy.filteredContent count]==1, @"%i", [rootProxy.filteredContent count] );
	NodeProxy *child1 = [rootProxy.filteredContent objectAtIndex:0];
	STAssertTrue( child1.originalNode == graphic1, @"should be");
	
	/* check the indexes inside */
	STAssertTrue( [rootProxy.indexesOfFilteredContent count]==1, @"%i", [rootProxy.indexesOfFilteredContent count] );
	STAssertTrue( [rootProxy.indexesOfFilteredContent firstIndex]==0, @"%i", [rootProxy.indexesOfFilteredContent firstIndex] );

	/* check that observations have been set */
	STAssertTrue( [rootProxy isObservingChildren]==NO, @"%i", [rootProxy isObservingChildren] );
	STAssertTrue( [child1 isObservingChildren]==NO, @"%i", [child1 isObservingChildren] );

	/* when this breaks cause we have added selection: change notificationsReceivedCount to graphics_notificationsReceivedCount and selection_notificationsReceivedCount */
	STAssertTrue( [child1 debug_arrayNotificationsReceivedCount]==0, @"%i", [child1 debug_arrayNotificationsReceivedCount] );
	
	/* How many notifications were received? */
	STAssertTrue(_changedProxy==rootProxy, @"eh?");
	STAssertTrue([_removedContent count]==2, @"eh?");
	STAssertTrue([[_removedContent objectAtIndex:0] originalNode]==ng2, @"eh?");
	STAssertTrue([[_removedContent objectAtIndex:1] originalNode]==graphic2, @"eh?");
	
	[_graphicsProvider unRegisterAUser:self];
	[rootProxy stopObservingOriginalNode];
}


- (void)testModelChangedNodesInsideSelection_to {
	//- (void)modelWillChange:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue from:(id)oldValue
	//- (void)modelChanged:(NodeProxy *)proxy nodesInsideSelection_to:(id)newValue
    
   [self addTestNodes];
	
	// update -- this would normally be called when we setModel
//	[_graphicsProvider makeFilteredTreeUpToDate:_graphicsProvider.rootNodeProxy]; 
	
	[_graphicsProvider registerAUser:self];

	//-- root¬ (3)
	//-- -- ng1¬	(4)
	//-- -- -- audio1		-- select this
	//-- -- -- graphic1
	//-- -- -- ng2¬	(4)		-- select this
	//-- -- -- -- audio2
	//-- -- -- -- ng3
	//-- -- -- -- graphic3
	//-- -- -- -- graphic4
	//-- -- -- graphic2		-- select this
	//-- -- ng4
	//-- -- graphic5

	/* selection indexes in filter will be (1,2) not (2,3) as audio1 isnt in the filtered set */
    NSMutableIndexSet *newSelectionIndexes = [NSMutableIndexSet indexSetWithIndex:0];
    [newSelectionIndexes addIndexesInRange:NSMakeRange(2,2)];
	[NodeClassFilterTests resetObservers];
	STAssertTrue(selectionDidChange==NO, @"Ddoh");
	STAssertTrue(selectionChangeCount==0, @"Ddoh %i", selectionChangeCount);

	SHNode *ng1 = (SHNode *)[_model.rootNodeGroup nodeAtIndex:0];
	STAssertTrue([[ng1.name value] isEqualToString:@"ng1"], @"%@", [ng1.name value]);
	NodeProxy *ng1Proxy = [_graphicsProvider nodeProxyForNode:ng1];
	STAssertTrue([ng1Proxy.filteredContent count]==3, @"eh %i", [ng1Proxy.filteredContent count]);
	
	[_model setCurrentNodeGroup:ng1]; //doWeNeedToObserveEachProxy
    [_graphicsProvider modelChanged:ng1Proxy nodesInsideSelection_to:newSelectionIndexes from:[NSIndexSet indexSet]];

    NSIndexSet *filteredSelection = ng1Proxy.filteredContentSelectionIndexes;
    STAssertTrue([filteredSelection count]==2, @"%i", [filteredSelection count]);
    STAssertTrue([filteredSelection containsIndex:1], @"NO");
    STAssertTrue([filteredSelection containsIndex:2], @"NO");

	//Im not sure if we need nodeProxy to trigger these notifications or we use our custom notifications
	// STAssertTrue(selectionDidChange==YES, @"Ddoh");
	//STAssertTrue(selectionChangeCount==1, @"Ddoh %i", selectionChangeCount);
	/* How many notifications were received? */
	STAssertTrue(_changedProxy==ng1Proxy, @"eh?");
	STAssertTrue([_changedSelectionIndexes count]==2, @"eh? %i", [_changedSelectionIndexes count]);
	STAssertTrue([_changedSelectionIndexes containsIndex:1], @"eh?");
	STAssertTrue([_changedSelectionIndexes containsIndex:2], @"eh?");
	
	/*
	 * Coverage tweaks
	*/
	// test Funnybit that i dont know what it does - if( oldValueNullOrNil==NO && newValueNullOrNil==NO && [oldSelectionIndexes count]>0 )
	//-- root¬ (3)
	//-- -- ng1¬	(4)
	//-- -- -- audio1		-- select this
	//-- -- -- graphic1
	//-- -- -- ng2¬	(4)		-- select this
	//-- -- -- -- audio2
	//-- -- -- -- ng3
	//-- -- -- -- graphic3
	//-- -- -- -- graphic4
	//-- -- -- graphic2		-- select this
	//-- -- ng4
	//-- -- graphic5
	NSArray *content = ng1Proxy.filteredContent;
	NodeProxy *ng2Proxy = (NodeProxy *)[content objectAtIndex:1];
	NSArray *ng2Content = [ng2Proxy filteredContent];
	STAssertTrue([ng2Content count]==3, @"eh %i", [ng2Content count]);
	// first off make sure we start with a selection
	NSMutableIndexSet *oldSelectionIndexes2 = [NSMutableIndexSet indexSetWithIndex:0];
    [oldSelectionIndexes2 addIndexesInRange:NSMakeRange(1,2)];
	
	// doWeNeedToObserveEachProxy Experimental obnly observing current node
	[_model setCurrentNodeGroup:ng2Proxy.originalNode]; //doWeNeedToObserveEachProxy
	
	[ng2Proxy changeSelectionIndexes:oldSelectionIndexes2]; // in nodeproxy indexes
    STAssertTrue([ng2Proxy.filteredContentSelectionIndexes count]==3, @"%i", [ng2Proxy.filteredContentSelectionIndexes count]);
	// ng3, graphic3, graphic4
	
	// now change the selection - this should deselect 2 of the nodes leaving one selected
    NSMutableIndexSet *oldSelectionIndexes3 = [NSMutableIndexSet indexSetWithIndex:1];	// in SHParentIndexes
    [oldSelectionIndexes3 addIndexesInRange:NSMakeRange(2,2)];							// in SHParentIndexes
    NSMutableIndexSet *newSelectionIndexes2 = [NSMutableIndexSet indexSetWithIndex:1];	// in SHParentIndexes
	
	[_graphicsProvider modelWillChange:ng2Proxy nodesInsideSelection_to:newSelectionIndexes2 from:oldSelectionIndexes3];
	[_graphicsProvider modelChanged:ng2Proxy nodesInsideSelection_to:newSelectionIndexes2 from:oldSelectionIndexes3];

	NSIndexSet *ng2filteredSelection = ng2Proxy.filteredContentSelectionIndexes;
    STAssertTrue([ng2filteredSelection count]==1, @"%i", [filteredSelection count]);
    STAssertTrue([filteredSelection containsIndex:1], @"NO");
	STAssertTrue(_changedProxy==ng2Proxy, @"eh?");
	STAssertTrue([_changedSelectionIndexes count]==1, @"eh? %i", [_changedSelectionIndexes count]);
	STAssertTrue([_changedSelectionIndexes containsIndex:0], @"we selected 1 in SHParentIndexes which should be 0 in nodeproxy indexes");
	
	[_graphicsProvider unRegisterAUser:self];
//doWeNeedToObserveEachProxy    [rootProxy stopObservingOriginalNode];
}

- (void)testModelInsertedNodesInsideSelectionAtIndexes {
	// - (void)modelWillInsert:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
    //- (void)modelInserted:(NodeProxy *)proxy nodesInsideSelection:(id)newValue atIndexes:(NSIndexSet *)changeIndexes;
    
	NodeProxy *rootProxy = [self addTestNodes];

	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSet];
	NSIndexSet *indexes = [NSIndexSet indexSet];
	
	STAssertThrows( [_graphicsProvider modelWillInsert:rootProxy nodesInsideSelection:indexes atIndexes: newSelectionIndexes] , @"Not supported");
	STAssertThrows( [_graphicsProvider modelInserted:rootProxy nodesInsideSelection:indexes atIndexes: newSelectionIndexes] , @"Not supported");
    
	[rootProxy stopObservingOriginalNode];
}
    
- (void)testModelReplacedNodesInsideSelectionWith {
	// - (void)modelWillReplace:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes
    //- (void)modelReplaced:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue with:atIndexes:(NSIndexSet *)changeIndexes;

	NodeProxy *rootProxy = [self addTestNodes];

	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSet];
	NSIndexSet *indexes = [NSIndexSet indexSet];
	
	STAssertThrows( [_graphicsProvider modelWillReplace:rootProxy nodesInsideSelection:indexes with:newSelectionIndexes atIndexes:indexes], @"Not supported" );
	STAssertThrows( [_graphicsProvider modelReplaced:rootProxy nodesInsideSelection:indexes with:newSelectionIndexes atIndexes:indexes], @"Not supported" );

	[rootProxy stopObservingOriginalNode];
}

- (void)testModelRemovedNodesInsideSelectionAtIndexes {
	// - (void)modelWillRemove:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes
    //- (void)modelRemoved:(NodeProxy *)proxy nodesInsideSelection:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes;
    
	NodeProxy *rootProxy = [self addTestNodes];

	NSIndexSet *newSelectionIndexes = [NSIndexSet indexSet];
	NSIndexSet *indexes = [NSIndexSet indexSet];
	
	STAssertThrows( [_graphicsProvider modelWillRemove:rootProxy nodesInsideSelection:indexes atIndexes: newSelectionIndexes], @"Not supported" );
	STAssertThrows( [_graphicsProvider modelRemoved:rootProxy nodesInsideSelection:indexes atIndexes: newSelectionIndexes], @"Not supported" );
    
	[rootProxy stopObservingOriginalNode];
}

// ng1 ¬
//	-- audio1
//	-- graphic1
//	-- ng2 ¬	
//		-- audio2
//		-- ng3
//	-- graphic2
- (void)testNodeProxyForNode {
	// - (NodeProxy *)nodeProxyForNode:(id)value;

	SHNode *ng1 = [SHNode makeChildWithName:@"n1"], *ng2 = [SHNode makeChildWithName:@"n1"], *ng3 = [SHNode makeChildWithName:@"n1"];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:1];

	NodeProxy *rootProxy = [_graphicsProvider rootNodeProxy];

	NodeProxy *ng1P = [_graphicsProvider nodeProxyForNode:ng1];
	NodeProxy *ng2P = [_graphicsProvider nodeProxyForNode:ng2];
	NodeProxy *ng3P = [_graphicsProvider nodeProxyForNode:ng3];

	STAssertNotNil(ng1P, @"eh?");
	STAssertNotNil(ng2P, @"eh?");
	STAssertNotNil(ng3P, @"eh?");

	NodeProxy *graphic1P = [_graphicsProvider nodeProxyForNode:graphic1];
	NodeProxy *graphic2P = [_graphicsProvider nodeProxyForNode:graphic2];

	STAssertNotNil(graphic1P, @"eh?");
	STAssertNotNil(graphic2P, @"eh?");
	
	STAssertNil([_graphicsProvider nodeProxyForNode:audio1], @"eh?");
	STAssertNil([_graphicsProvider nodeProxyForNode:audio2], @"eh?");
	
	STAssertTrue( [rootProxy containsObjectIdenticalTo:ng1P], @"Must do");
	STAssertTrue( [rootProxy containsObjectIdenticalTo:ng2P], @"Must do");
	STAssertTrue( [rootProxy containsObjectIdenticalTo:ng3P], @"Must do");

	STAssertTrue( [rootProxy containsObjectIdenticalTo:graphic1P], @"Must do");
	STAssertTrue( [rootProxy containsObjectIdenticalTo:graphic2P], @"Must do");
}

- (void)testCurrentNode {
	
	SHNode *ng1 = [SHNode makeChildWithName:@"ng1"], *ng2 = [SHNode makeChildWithName:@"ng2"], *ng3 = [SHNode makeChildWithName:@"ng3"];
    MockProducer *graphic1 = [[MockProducer new] autorelease], *graphic2 = [[MockProducer new] autorelease];
    MockConsumer *audio1 = [[MockConsumer new] autorelease], *audio2 = [[MockConsumer new] autorelease];
    [ng1 addChild:audio1 undoManager:nil];
    [ng1 addChild:graphic1 undoManager:nil];
    [ng2 addChild:audio2 undoManager:nil];
    [ng2 addChild:ng3 undoManager:nil];
    [ng1 addChild:ng2 undoManager:nil];
    [ng1 addChild:graphic2 undoManager:nil];
	[_model NEW_addChild:ng1 toNode:_model.rootNodeGroup atIndex:1];
	
	[_model setCurrentNodeGroup:ng1];
	STAssertTrue( _graphicsProvider.currentNodeProxy.originalNode==ng1, @"valid");
	
	[_model setCurrentNodeGroup:graphic1];
	STAssertTrue( _graphicsProvider.currentNodeProxy.originalNode==ng1, @"should not have been valid");

	[_model setCurrentNodeGroup:audio1];
	STAssertTrue( _graphicsProvider.currentNodeProxy.originalNode==ng1, @"should not have been valid");
	
	[_model setCurrentNodeGroup:ng2];
	STAssertTrue( _graphicsProvider.currentNodeProxy.originalNode==ng2, @"valid");
}

- (void)testAddStuffToModel {
	
	// root ¬
	//	-- group
	//		-- graphic
	//	-- graphic1
	//	-- audio1
	//	-- group1 ¬
	//		-- audio2
	//		-- graphic2
	MockProducer *graphic1 = [[MockProducer new] autorelease];
	MockConsumer *audio1 = [[MockConsumer new] autorelease];
	SHNode *ng1 = [SHNode makeChildWithName:@"n1"];
	
//	[_graphicsProvider makeFilteredTreeUpToDate:_graphicsProvider.rootNodeProxy]; 
	NSMutableArray *filteredContent1 = _graphicsProvider.rootNodeProxy.filteredContent;
	STAssertTrue([filteredContent1 count]==1, @"filteredContent count is %i", [filteredContent1 count]);
	
	_model.currentNodeGroup = _model.rootNodeGroup;
	[_model insertGraphics:[NSArray arrayWithObjects:graphic1, audio1, ng1, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,3)]];

	MockProducer *graphic2 = [[MockProducer new] autorelease];
	MockConsumer *audio2 = [[MockConsumer new] autorelease];
	
	_model.currentNodeGroup = ng1;
	[_model NEW_addChild:graphic2 toNode:ng1];
	[_model NEW_addChild:audio2 toNode:ng1];
	
	//-- filter should have
	//	-- group
	//		-- graphic
	//	-- graphic
	//	-- group ¬
	//		-- graphic
	NSMutableArray *filteredContent2 = _graphicsProvider.rootNodeProxy.filteredContent;
	STAssertTrue([filteredContent2 count]==3, @"filteredContent count is %i", [filteredContent2 count]);

	STAssertTrue([[[filteredContent2 objectAtIndex:0] filteredContent] count]==1, @"filteredContent count is %i", [[[filteredContent2 objectAtIndex:0] filteredContent] count] );
	STAssertTrue([[[filteredContent2 objectAtIndex:1] filteredContent] count]==0, @"filteredContent count is %i", [[[filteredContent2 objectAtIndex:1] filteredContent] count] );
	STAssertTrue([[[filteredContent2 objectAtIndex:2] filteredContent] count]==1, @"filteredContent count is %i", [[[filteredContent2 objectAtIndex:2] filteredContent] count] );
	
	// when we insert will we pick up on sub-children?
	SHNode *ng2 = [SHNode makeChildWithName:@"n1"];
	MockProducer *graphic3 = [[MockProducer new] autorelease];
	[ng2 addChild:graphic3 undoManager:nil];
	_model.currentNodeGroup = _model.rootNodeGroup;
	[_model NEW_addChild:ng2 atIndex:0];

	NSMutableArray *filteredContent3 = _graphicsProvider.rootNodeProxy.filteredContent;
	NodeProxy *insertedNode = [filteredContent3 objectAtIndex:0];
	STAssertTrue(insertedNode.originalNode==ng2, @"Messed up");
	STAssertTrue([[insertedNode filteredContent] count]==1, @"filteredContent count is %i", [[insertedNode filteredContent] count] );
    
	MockProducer *graphic4 = [[MockProducer new] autorelease];
	MockProducer *graphic5 = [[MockProducer new] autorelease];
	
	[_model setCurrentNodeGroup:ng2]; //doWeNeedToObserveEachProxy
	[ng2 addItemsOfSingleType:[NSArray arrayWithObjects:graphic4, graphic5, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] undoManager:nil];
	NSMutableArray *filteredContent4 = insertedNode.filteredContent;
	STAssertTrue([filteredContent4 count]==3, @"filteredContent count is %i", [filteredContent4 count] );		
}


- (void)testSwapModel {
	
	SHNodeGraphModel *newModel = [SHNodeGraphModel makeEmptyModel];
	
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
    
	[NodeClassFilterTests resetObservers];
	[newModel insertGraphics:[NSArray arrayWithObjects: newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];    
    
    [_graphicsProvider cleanUpFilter];
    [_graphicsProvider setModel: newModel];
    
	NSIndexSet *currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
	STAssertTrue([currentFilteredContent count]==3, @"i am crying %i", [currentFilteredContent count]);
	STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:1], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:2], @"i would like a beer");
	
    [_graphicsProvider cleanUpFilter];
    [_graphicsProvider setModel: _model];
}

// * need to insert some in funny places and check that the indexes are correct */
- (void)testMoreComplicatedInsert {
	
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
	
	[NodeClassFilterTests resetObservers];
	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
	
	NSIndexSet *currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
	STAssertTrue([currentFilteredContent count]==4, @"i am crying %i", [currentFilteredContent count]);
	STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:2], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:4], @"i would like a beer");
	
	/* Aiming for this :-
	 * newGraphic1, newGraphic4, noneGraphic1, noneGraphic4, newGraphic2, noneGraphic2, noneGraphic5, newGraphic5, newGraphic3, noneGraphic3
	 */
	MockProducer *newGraphic4 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic5 = [[[MockProducer alloc] init] autorelease];
	MockConsumer *noneGraphic4 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic5 = [[[MockConsumer alloc] init] autorelease];
	NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSetWithIndex: 1];
	[newIndexes addIndex: 3];
	[newIndexes addIndex: 6];
	[newIndexes addIndex: 7];
    // indexs are 0, 2, 4
	[_model insertGraphics: [NSArray arrayWithObjects: newGraphic4, noneGraphic4, noneGraphic5, newGraphic5, nil] atIndexes: newIndexes];

	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:0]==newGraphic1, @"0 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:1]==newGraphic4, @"1 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:2]==noneGraphic1, @"2 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:3]==noneGraphic4, @"3 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:4]==newGraphic2, @"4 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:5]==noneGraphic2, @"5 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:6]==noneGraphic5, @"6 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:7]==newGraphic5, @"7 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:8]==newGraphic3, @"8 strawberry flavoured Horse cock");
	STAssertTrue( [_model.currentNodeGroup.nodesInside objectAtIndex:9]==noneGraphic3, @"9 strawberry flavoured Horse cock");
	
	//    1, 3, 6, 7 becomes 1, 3, 6, 7
    
	/* which should give us the filtered content of this..
	 * newGraphic1, newGraphic4, newGraphic2, newGraphic5, newGraphic3
	 */
	currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
	STAssertTrue([currentFilteredContent count]==6, @"i am crying %i", [currentFilteredContent count]);
	STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:1], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:4], @"i would like a beer %@", currentFilteredContent);
	STAssertTrue([currentFilteredContent containsIndex:7], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:8], @"i would like a beer");
}

- (void)testRemoveIndexToIndexesOfFilteredContent {
	
    MockProducer *real_graphic_1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *real_graphic_2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *real_graphic_3 = [[[MockProducer alloc] init] autorelease];
	MockProducer *real_graphic_4 = [[[MockProducer alloc] init] autorelease];
	MockProducer *real_graphic_5 = [[[MockProducer alloc] init] autorelease];
	
    MockConsumer *placeholder_1 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *placeholder_2 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *placeholder_3 = [[[MockConsumer alloc] init] autorelease];
    
    [_model insertGraphics:[NSArray arrayWithObjects: real_graphic_1, placeholder_1, real_graphic_2, placeholder_2, real_graphic_3, real_graphic_4, placeholder_3, real_graphic_5, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 8)]];    
	NSIndexSet *currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
	// real_graphic_1, --placeholder_1--, real_graphic_2, --placeholder_2--, --real_graphic_3--, real_graphic_4, placeholder_3, real_graphic_5, -- setupGraphic--
	// 0, 2, 4, 5, 7
	STAssertTrue([currentFilteredContent count]==6, @"insert gone wrong %i", [currentFilteredContent count]);
	
	[NodeClassFilterTests resetObservers];
    NSMutableIndexSet *removeIndexes = [NSMutableIndexSet indexSetWithIndex:1];
    [removeIndexes addIndex:3];
    [removeIndexes addIndex:4];
	
    [NodeClassFilterTests resetObservers];
    [_model removeGraphicsAtIndexes: removeIndexes];
	// real_graphic_1, real_graphic_2, real_graphic_4, placeholder_3, real_graphic_5, -- setupGraphic--

    currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
	STAssertTrue([currentFilteredContent count]==5, @"removal gone wrong %i", [currentFilteredContent count]);
	STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:1], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:2], @"i would like a beer");
	STAssertTrue([currentFilteredContent containsIndex:4], @"i would like a beer");
	
    [NodeClassFilterTests resetObservers];
    [_model removeGraphicAtIndex:1];
    // real_graphic_1, real_graphic_4, placeholder_3, real_graphic_5, -- setupGraphic--
	
    currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
    STAssertTrue([currentFilteredContent count]==4, @"i am crying %i", [currentFilteredContent count]);
    STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
    STAssertTrue([currentFilteredContent containsIndex:1], @"i would like a beer");
    STAssertTrue([currentFilteredContent containsIndex:3], @"i would like a beer");
    
    [NodeClassFilterTests resetObservers];
    [_model removeGraphicAtIndex:2];
    // real_graphic_1, real_graphic_4, real_graphic_5, -- setupGraphic--
	
    currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
    STAssertTrue([currentFilteredContent count]==4, @"i am crying %i", [currentFilteredContent count]);
    STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
    STAssertTrue([currentFilteredContent containsIndex:1], @"i would like a beer");
    STAssertTrue([currentFilteredContent containsIndex:2], @"i would like a beer");
}

- (void)testRecieveNotificationWhenAddingToModel2 {
	
	/* filter is set for SKTGraphics */
	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
	
	[NodeClassFilterTests resetObservers];
	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
	
	/* we should be able to observe a change to the filtered indexes */
	
	NSMutableIndexSet *indexesOfFilteredContent = [_graphicsProvider.currentNodeProxy indexesOfFilteredContent];
	STAssertTrue([indexesOfFilteredContent count]==4, @"filter isn't working! %i", [indexesOfFilteredContent count]);
	STAssertTrue([indexesOfFilteredContent containsIndex:0], @"ddarn it");
	STAssertTrue([indexesOfFilteredContent containsIndex:2], @"ddarn it");
	STAssertTrue([indexesOfFilteredContent containsIndex:4], @"ddarn it");
	
	
	//-- A MUCH TRICKIER CASE - INSERT AN OBJECT AT AN INDEX WHERE THERE IS ALREADY AN INDEX
	[NodeClassFilterTests resetObservers];
	MockProducer *newGraphic4 = [[[MockProducer alloc] init] autorelease];
	
	//-- index 4 in model should make this the third MockProducer in the filtered content
	//-- newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, NEWGRAPHIC4, newGraphic3, noneGraphic3
	[_model NEW_addChild:newGraphic4 atIndex:4];  
	
	//-- test the indexes are correct
	indexesOfFilteredContent = [_graphicsProvider.currentNodeProxy indexesOfFilteredContent];
	STAssertTrue([indexesOfFilteredContent count]==5, @"filter isn't working! %i", [indexesOfFilteredContent count]);
	STAssertTrue([indexesOfFilteredContent containsIndex:0], @"ddarn it");
	STAssertTrue([indexesOfFilteredContent containsIndex:2], @"ddarn it");
	STAssertTrue([indexesOfFilteredContent containsIndex:4], @"ddarn it");
	STAssertTrue([indexesOfFilteredContent containsIndex:5], @"ddarn it");
	
	//-- verify that filtered content doesn't update when we add an object that should be ignorned
	[NodeClassFilterTests resetObservers];
	MockConsumer *noneGraphic4 = [[[MockConsumer alloc] init] autorelease];
	[_model NEW_addChild:noneGraphic4 atIndex:0];
	STAssertFalse(filteredContentDidChange, @"should not get notification here!");
	STAssertTrue(filteredContentChangeCount==0, @"received incorrect number of notifications %i", filteredContentChangeCount);
	NSArray *filteredContent = [_graphicsProvider.currentNodeProxy filteredContent];
	STAssertTrue([filteredContent count]==5, @"filter isn't working! %i", [filteredContent count]);
	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
}

//- (void)test_InsertFilteredContentAtIndexes_triggersKVO {
//	// - (void)insertFilteredContent:(NSArray *)graphics atIndexes:(NSIndexSet *)indexes {
//	
//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//	
//    [NodeClassFilterTests resetObservers];
//	[_graphicsProvider insertFilteredContent:[NSArray arrayWithObjects: newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
//    
//	STAssertTrue(filteredContentDidChange, @"didnt get notification");
//	STAssertTrue(filteredContentChangeCount==1, @"received incorrect number of notifications");
//}

//- (void)testRecieveNotificationWhenAddingToModel {
//	
//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//	
//	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
//	
//	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
//	
//	/* generate the initial array */
//	//	[_graphicsProvider forceRegenerateFilteredContent];
//	NSArray *filteredContent = [_graphicsProvider filteredContent];
//	STAssertTrue([filteredContent count]==3, @"filter isn't working! %i", [filteredContent count]);
//	STAssertTrue([filteredContent objectAtIndex:0]==newGraphic1, @"ddarn it");
//	STAssertTrue([filteredContent objectAtIndex:1]==newGraphic2, @"ddarn it");
//	STAssertTrue([filteredContent objectAtIndex:2]==newGraphic3, @"ddarn it");
//	
//	//-- test for notifications when we add an object of the filtered type to the model
//	[NodeClassFilterTests resetObservers];
//	MockProducer *newGraphic4 = [[[MockProducer alloc] init] autorelease];
//	[_model NEW_addChild:newGraphic4 atIndex:4]; //-- index 4 in model should make this the third MockProducer in the filtered content
//	
//	STAssertTrue(filteredContentDidChange, @"didnt get notification");
//	STAssertTrue(filteredContentChangeCount==1, @"received incorrect number of notifications");
//	
//	//-- test the index is correct
//	filteredContent = [_graphicsProvider filteredContent];
//	STAssertTrue([filteredContent count]==4, @"filter isn't working!");
//	STAssertTrue([filteredContent objectAtIndex:1]==newGraphic2, @"ddarn it");
//	STAssertTrue([filteredContent objectAtIndex:2]==newGraphic4, @"ddarn it");
//	STAssertTrue([filteredContent objectAtIndex:3]==newGraphic3, @"ddarn it");
//	
//	//-- verify that filtered content doesn't update when we add an object that should be ignorned
//	[NodeClassFilterTests resetObservers];
//	MockConsumer *noneGraphic4 = [[[MockConsumer alloc] init] autorelease];
//	[_model NEW_addChild:(MockProducer *)noneGraphic4 atIndex:0];
//	STAssertFalse(filteredContentDidChange, @"should not get notification here!");
//	STAssertTrue(filteredContentChangeCount==0, @"received incorrect number of notifications %i", filteredContentChangeCount);
//	filteredContent = [_graphicsProvider filteredContent];
//	STAssertTrue([filteredContent count]==4, @"filter isn't working!");
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
//}


//- (void)testRecieveNotificationWhenRemovingFromModel {
//	
//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//	
//	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
//	
//	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
//	STAssertTrue( _graphicsProvider->_addedObjectCount == 3, @"How many did we add? %i", _graphicsProvider->_addedObjectCount);
//	
//	
//	/* generate the initial array */
//	//	[_graphicsProvider forceRegenerateFilteredContent];
//	NSArray *filteredContent = [_graphicsProvider filteredContent];
//	STAssertTrue([filteredContent count]==3, @"filter isn't working!");
//	
//	//-- test for notifications when we remove an object of the filtered type to the model
//	[NodeClassFilterTests resetObservers];
//	
//	// newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3,
//	NSIndexSet *currentFilteredContent = _graphicsProvider.currentNodeProxy.indexesOfFilteredContent;
//	STAssertTrue([currentFilteredContent count]==3, @"i am crying");
//	STAssertTrue([currentFilteredContent containsIndex:0], @"i would like a beer");
//	STAssertTrue([currentFilteredContent containsIndex:2], @"i would like a beer");
//	STAssertTrue([currentFilteredContent containsIndex:4], @"i would like a beer");
//	
//	[_model removeGraphicAtIndex:2];
//	STAssertTrue( _graphicsProvider->_removedObjectCount == 1, @"How many did we remove %i?", _graphicsProvider->_removedObjectCount);
//	
//	STAssertTrue(filteredContentDidChange, @"didnt get notification");
//	STAssertTrue(filteredContentChangeCount==1, @"received incorrect number of notifications");
//	
//	//-- test the index is correct
//	filteredContent = [_graphicsProvider filteredContent];
//	STAssertTrue([filteredContent count]==2, @"filter isn't working! %i", [filteredContent count]);
//	STAssertTrue([filteredContent objectAtIndex:0]==newGraphic1, @"ddarn it");
//	STAssertTrue([filteredContent objectAtIndex:1]==newGraphic3, @"ddarn it");
//	
//	//-- verify that filtered content doesn't update when we remove an object that should be filtered out
//	[NodeClassFilterTests resetObservers];
//	[_model removeGraphicAtIndex:1];
//	STAssertFalse(filteredContentDidChange, @"should not get notification here!");
//	STAssertTrue(filteredContentChangeCount==0, @"received incorrect number of notifications %i", filteredContentChangeCount);
//	filteredContent = [_graphicsProvider filteredContent];
//	STAssertTrue([filteredContent count]==2, @"filter isn't working!");
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
//}

#pragma mark TEST Model Mirrors Filtered Tree

//- (void)testAddIndexToIndexesOfFilteredContent {
//// - (void)addIndexToIndexesOfFilteredContent:(NSUInteger)value
//// - (void)removeIndexFromIndexesOfFilteredContent:(NSUInteger)value
//// - (void)addIndexesToIndexesOfFilteredContent:(NSIndexSet *)value
//// - (void)removeIndexesFromIndexesOfFilteredContent:(NSIndexSet *)value
//	for(int i=0; i<11; i++){
//		MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//		[_model NEW_addChild:newGraphic1 atIndex:i]; 
//	}
//	
//	[NodeClassFilterTests resetObservers];
//	[_graphicsProvider addIndexToIndexesOfFilteredContent:0];
//    
//	[NodeClassFilterTests resetObservers];
//	[_graphicsProvider removeIndexFromIndexesOfFilteredContent:0];
//
//	[NodeClassFilterTests resetObservers];
//	[_graphicsProvider addIndexesToIndexesOfFilteredContent:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,10)]];
//
//	[NodeClassFilterTests resetObservers];
//	[_graphicsProvider removeIndexesFromIndexesOfFilteredContent:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,10)]];
//}

//- (void)testSomeArrayInsertionAssumprtions {
//        
//	NSString *place_1 = @"place_1";
//	NSString *place_2 = @"place_2";
//	NSString *place_3 = @"place_3";
//	NSString *place_4 = @"place_4";
//	NSString *insert_1 = @"insert_1";
//	NSString *insert_2 = @"insert_2";
//    NSMutableArray *array = [NSMutableArray arrayWithObjects: place_1, place_2, place_3, place_4, nil];
//    
//    /* noneGraphic1, noneGraphic2, noneGraphic3, noneGraphic4 */
//    NSArray *insertObjects = [NSArray arrayWithObjects: insert_1, insert_2, nil];
//    NSMutableIndexSet *insertIndexes = [NSMutableIndexSet indexSetWithIndex:1];
//    [insertIndexes addIndex:3];
//    [array insertObjects:insertObjects atIndexes: insertIndexes];
//}


#pragma mark OLD STUFF

- (void)testsSetClassFilter {
	// - (void)setClassFilter:(NSString *)value
	[_graphicsProvider setClassFilter:@"NodeClassFilterTests"];
	STAssertTrue(_graphicsProvider.filterType==[NodeClassFilterTests class], @"set options should set the class");
}

- (void)testSetOptions {
	// - (void)setOptions:(NSDictionary *)opts
	
	[_graphicsProvider setOptions:[NSDictionary dictionaryWithObject:@"NodeClassFilterTests" forKey:@"Class"]];
	STAssertTrue(_graphicsProvider.filterType==[NodeClassFilterTests class], @"set options should set the class");
}


	//-- verify selection stuff -- arrrrggg

//- (void)testSelectionStuff {
//
//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//
//	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
//
//	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
//	[_model changeNodeSelectionTo:[NSIndexSet indexSet]];
//	[NodeClassFilterTests resetObservers];
//	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndex:2]];
//	
//	STAssertTrue(selectionDidChange, @"didnt get notification");
//	STAssertTrue(selectionChangeCount==1, @"received incorrect number of notifications");
//
//	[_model changeNodeSelectionTo:[NSIndexSet indexSet]];
//	[NodeClassFilterTests resetObservers];
//	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndex:1]];
//	STAssertFalse(selectionDidChange, @"didnt get notification");
////	STAssertTrue(selectionChangeCount==0, @"received incorrect number of notifications");
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
//}

//- (void)test_syncSelectionIndexes {
//	//- (void)_syncSelectionIndexes
//
//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
//	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,1)]];	
//	[_graphicsProvider _syncSelectionIndexes];
//	STAssertFalse([_graphicsProvider isSelected:newGraphic1], @"doh");
//	STAssertTrue([_graphicsProvider isSelected:newGraphic2], @"doh");
//	STAssertFalse([_graphicsProvider isSelected:newGraphic3], @"doh");
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
//}

//- (void)testIsSelected {
//	//- (BOOL)isSelected:(id)value
//	
//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, newGraphic2, newGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,3)]];
//	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,1)]];
//	STAssertFalse([_graphicsProvider isSelected:newGraphic1], @"doh");
//	STAssertTrue([_graphicsProvider isSelected:newGraphic2], @"doh");
//	STAssertFalse([_graphicsProvider isSelected:newGraphic3], @"doh");
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
//}

//- (void)testRegisterAUser {
//// - (void)registerAUser:(id)user
////- (void)unRegisterAUser:(id)user
//
//    StubFilterUser *stubUser = [[[StubFilterUser alloc] init] autorelease];
//    logInfo(@"Created stub user %@", stubUser);
//    /* CANT GET OCMOCK TO WORK IN THIS CASE 
//    BOOL expectedValue = YES; // you need to asign expectedValue to a variable or it doesn't work !(?)
//	NSString *description = @"mockUser";
//    [[[mockUser stub] andReturnValue:OCMOCK_VALUE(expectedValue)] respondsToSelector:NSSelectorFromString(@"descriptionWithLocale")];
//	[[[mockUser stub] andReturnValue:OCMOCK_VALUE(description)] description];
//	[[[mockUser stub] andReturnValue:OCMOCK_VALUE(description)] descriptionWithLocale:OCMOCK_ANY];
//    */
//    [_graphicsProvider registerAUser:stubUser];
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==1, @"eh?");
//	
//	[stubUser resetChangeCounts];
//    MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//    [_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, nil] atIndexes:[NSIndexSet indexSetWithIndex:0]];
//	STAssertTrue( stubUser->filteredContentChanged == YES, @"doh");
//	STAssertTrue( stubUser->_filteredContentCount==1, @"doh - %i", stubUser->_filteredContentCount);
//	
//	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndex:0]];
//	STAssertTrue( stubUser->filteredContentSelectionIndexesChanged == YES, @"doh");
//	STAssertTrue( stubUser->_selectionChangeCount==1, @"doh - %i", stubUser->_selectionChangeCount);
//
//	[_graphicsProvider unRegisterAUser:stubUser];
//	STAssertTrue( [_graphicsProvider.registeredUsers count]==0, @"eh?");
//	
//	logInfo(@"COMPLETED TEST");
//}

//- (void)testFindInsertionPoint {
//
//	NSMutableIndexSet *insertIndexes = [NSMutableIndexSet indexSetWithIndexesInRange: NSMakeRange(0, 5)]; // 0, 1, 2, 3, 4
//	// 0, 1, 2, ^3, 4, 5
//	int indexToInsert = 3;
//	int positionToFind = 4;
//	
//	NSRange testRange = NSMakeRange(0, indexToInsert+1);
//	// NSMutableIndexSet *testSet = [NSMutableIndexSet indexSetWithIndexesInRange: testRange];
//	int result = [insertIndexes countOfIndexesInRange: testRange];
//	STAssertTrue(result==positionToFind, @"erms %i", result);
//	
//	[insertIndexes removeIndexesInRange: testRange];
//	logInfo(@"insertIndexes - %@", insertIndexes);
//}

//- (void)testSelectedContent {
// - (NSArray *)selectedContent;

//	MockProducer *newGraphic1 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic2 = [[[MockProducer alloc] init] autorelease];
//	MockProducer *newGraphic3 = [[[MockProducer alloc] init] autorelease];
//	
//	MockConsumer *noneGraphic1 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic2 = [[[MockConsumer alloc] init] autorelease];
//	MockConsumer *noneGraphic3 = [[[MockConsumer alloc] init] autorelease];
//	
////	[_graphicsProvider makeFilteredTreeUpToDate:_graphicsProvider.rootNodeProxy]; 
//
//	[_model insertGraphics:[NSArray arrayWithObjects:newGraphic1, noneGraphic1, newGraphic2, noneGraphic2, newGraphic3, noneGraphic3, nil] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 6)]];
//	[NodeClassFilterTests resetObservers];
//	[_model changeNodeSelectionTo:[NSIndexSet indexSetWithIndex:2]];
//	NSMutableIndexSet *allSelectedIndexes = [_graphicsProvider.currentNodeProxy indexesOfFilteredContent];
//	 
//	STAssertTrue([allSelectedIndexes count]==1, @"ee %i", [allSelectedIndexes count]);
//	STAssertTrue([_graphicsProvider.currentNodeProxy.originalNode nodeAtIndex:[allSelectedIndexes firstIndex]]==newGraphic2, @"ee");
//}

@end
