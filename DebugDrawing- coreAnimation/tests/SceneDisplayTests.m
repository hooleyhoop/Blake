//
//  SceneDisplayTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 6/28/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//
#import "SceneDisplay.h"
#import "StarSceneUserProtocol.h"
#import "StarScene.h"
#import "Graphic.h"
#import "CALayerStarView.h"
#import "AbstractLayer.h"
#import "ContentLayerManager.h"

#import "LayerCreation.h"
#import "LayerTreeManipulation.h"
#import "SwappedInIvar.h"
#import "GraphLayersController.h"
#import "SelectedLayersController.h"

@interface SceneDisplayTests : SenTestCase {
	
	SceneDisplay *_sceneDisplay;
	
	OCMockObject *_mockContentLayermanager, *_mockSelectedLayermanager;
	OCMockObject *_mockRootLayer;
	OCMockObject *_mockContentLayer, *_mockSelectionLayer;
	OCMockObject *_mockLayerMaker;
	OCMockObject *_mockLayerManipulator;
	
	OCMockObject *_mock_graphLayersController;
	OCMockObject *_mock_selectedLayersController;
	SwappedInIvar *_swapIn1, *_swapIn2;
}

@end

@implementation SceneDisplayTests

//
//-- we need:
//
//	a Model
//	a scene
//	a sceneDisplay
//	a view
//	some drawable objects
//
//quite complex interactions
//
//if we add a drawable object to the model, the scene via filter, notifies the sceneDisplay, which adds a layer to the view 


- (void)setUp {
	
	_mockContentLayermanager = [MOCK(ContentLayerManager) retain];
	_mockSelectedLayermanager = [MOCK(ContentLayerManager) retain];
	
	_mockRootLayer = [MOCK(AbstractLayer) retain];
	_mockContentLayer = [MOCK(AbstractLayer) retain];
	_mockSelectionLayer = [MOCK(AbstractLayer) retain];
	_mockLayerMaker = [MOCK(LayerCreation) retain];
	_mockLayerManipulator = [MOCK(LayerTreeManipulation) retain];
	
	[[[_mockContentLayermanager stub] andReturn:_mockContentLayer] containerLayer_temporary];
	[[[_mockSelectedLayermanager stub] andReturn:_mockSelectionLayer] containerLayer_temporary];
	
	[[[_mockLayerMaker stub] andReturn:_mockContentLayer] makeChildLayerForNode:OCMOCK_ANY];
	
	_sceneDisplay = [[SceneDisplay alloc] initWithContentLayerManager:(id)_mockContentLayermanager selectedContentLayerManager:(id)_mockSelectedLayermanager layerTreeManipulator:(id)_mockLayerManipulator];
	STAssertNotNil(_sceneDisplay, @"Ahem");
	
	_mock_graphLayersController = [MOCK(GraphLayersController) retain];
	_mock_selectedLayersController = [MOCK(SelectedLayersController) retain];

	_swapIn1 = [[SwappedInIvar swapFor:_sceneDisplay :"_graphLayersController" :_mock_graphLayersController] retain];
	_swapIn2 = [[SwappedInIvar swapFor:_sceneDisplay :"_selectedLayersController" :_mock_selectedLayersController] retain];
}

- (void)tearDown {

	[_swapIn1 putBackOriginal];
	[_swapIn2 putBackOriginal];
	
	[_mock_graphLayersController release];
	[_mock_selectedLayersController release];
	[_swapIn1 release];
	[_swapIn2 release];
	
	[_sceneDisplay release];
	[_mockContentLayermanager release];
	[_mockSelectedLayermanager release];
	[_mockRootLayer release];
	[_mockContentLayer release];
	[_mockSelectionLayer release];
	[_mockLayerMaker release];
	[_mockLayerManipulator release];
}

- (void)testSetStarScene {
	// - (void)setStarScene:(StarScene *)value;

	// mock some children inside the root node
	id mockChild1Proxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChild2Proxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChild3Proxy = MOCKFORPROTOCOL(ProxyLikeProtocol);

	/* Surely we add a layer for Node? */
	NSArray *mockFilteredContent = [NSArray arrayWithObjects: mockChild1Proxy, mockChild2Proxy, mockChild3Proxy, nil];

	// mock the scene
	id mockScene = MOCK(StarScene);

	id mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockRootNode = MOCK(SHNode);

	[[[mockScene stub] andReturn:mockRootProxy] rootProxy];

	NSUInteger expectedIndex = 0;
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockRootProxy onParentLayer:OCMOCK_ANY atIndex:0];

	[[mockScene expect] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene expect] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene expect] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	
	// build the scene
	[_sceneDisplay setStarScene:mockScene];
	STAssertTrue(_sceneDisplay.starScene==mockScene, @"doh");
	
	[_mockLayerMaker verify];
	[_mockContentLayermanager verify];
	[_mock_graphLayersController verify];
	
	// try setting to nil, will dismantle the layer tree
	[[mockScene expect] removeObserver:_sceneDisplay forKeyPath:@"currentProxy"];
	[[mockScene expect] removeObserver:_sceneDisplay forKeyPath:@"currentFilteredContent"];
	[[mockScene expect] removeObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes"];

    [[_mock_graphLayersController expect] removeStar:mockRootProxy fromLayer:(id)_mockContentLayer];

	[_sceneDisplay setStarScene:nil];
	
	[mockScene verify];
	[_mock_graphLayersController verify];
}

- (void)testRemoveAllLayers {
	// - (void)removeAllLayers
	
	id mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockScene = MOCK(StarScene);
	[[[mockScene stub] andReturn:mockRootProxy] rootProxy];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	[[[_mockContentLayermanager stub] andReturn:_mockContentLayer] containerLayer_temporary];

	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockRootProxy onParentLayer:OCMOCK_ANY atIndex:0];

	[_sceneDisplay setStarScene:mockScene];

    [[_mock_graphLayersController expect] removeStar:mockRootProxy fromLayer:(id)_mockContentLayer];
	
	[_sceneDisplay removeAllLayers];

	[_mock_graphLayersController verify];
}

- (void)testGraphDidUpdate {
	// - (void)graphDidUpdate
	
	[[_mock_selectedLayersController expect] enforceConsistentState];
	[_sceneDisplay graphDidUpdate];
	[_mock_selectedLayersController verify];
}
		
- (void)testNodeProxyChangedContent {
	// - (void)nodeProxy:(NodeProxy *)value changedContent:(NSArray *)values
	
	//mock the current proxy
	id mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *child1 = MOCK(SHNode);
	[[[mockRootProxy stub] andReturn:child1] originalNode];

	id mockChildProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy3 = MOCKFORPROTOCOL(ProxyLikeProtocol);

	NSArray *newContent = [NSArray arrayWithObjects:
						   mockChildProxy1,
						   mockChildProxy2,
						   mockChildProxy3,
						   nil];
	
	[[[_mockContentLayermanager expect] andReturn:_mockContentLayer] lookupLayerForKey: child1];
	[[[_mockContentLayer stub] andReturn:nil] sublayers];
	
	[[[mockRootProxy expect] andReturn:newContent] filteredContent];
	
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockChildProxy1 onParentLayer:(id)_mockContentLayer atIndex:0];
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockChildProxy2 onParentLayer:(id)_mockContentLayer atIndex:1];
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockChildProxy3 onParentLayer:(id)_mockContentLayer atIndex:2];

	[_sceneDisplay nodeProxy:mockRootProxy changedContent:newContent];
	
	[mockRootProxy verify];
	[_mockContentLayermanager verify];
	[_mockLayerMaker verify];
	[_mockLayerManipulator verify];
	[_mock_graphLayersController verify];
}

- (void)testNodeProxyInsertedContent {
	// - (void)nodeProxy:(NodeProxy *)value insertedContent:(NSArray *)values
	
	id mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *child1 = MOCK(SHNode);
	[[[mockRootProxy stub] andReturn:child1] originalNode];

	id mockChildProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy3 = MOCKFORPROTOCOL(ProxyLikeProtocol);

	NSArray *newContent = [NSArray arrayWithObjects:
						   mockChildProxy1,
						   mockChildProxy2,
						   mockChildProxy3,
						   nil];
		OCMockObject *innerChild1 = MOCK(Graphic);
		OCMockObject *innerChild2 = MOCK(Graphic);
		OCMockObject *innerChild3 = MOCK(Graphic);
		[[[mockChildProxy1 stub] andReturn:innerChild1] originalNode];
		[[[mockChildProxy2 stub] andReturn:innerChild2] originalNode];
		[[[mockChildProxy3 stub] andReturn:innerChild3] originalNode];
	
	// build the scene
	id mockScene = MOCK(StarScene);
	[[[mockScene stub] andReturn:mockRootProxy] rootProxy];
	
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockRootProxy onParentLayer:OCMOCK_ANY atIndex:0];
	[[[_mockContentLayermanager expect] andReturn:_mockContentLayer] lookupLayerForKey: child1];

	/* lets do it first time thru without an existing layer - new layer will be created */
	[[[_mockContentLayermanager expect] andReturn:nil] lookupLayerForKey: innerChild1];
	[[[_mockContentLayermanager expect] andReturn:nil] lookupLayerForKey: innerChild2];
	[[[_mockContentLayermanager expect] andReturn:nil] lookupLayerForKey: innerChild3];

	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockChildProxy1 onParentLayer:(id)_mockContentLayer atIndex:0];
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockChildProxy2 onParentLayer:(id)_mockContentLayer atIndex:1];
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockChildProxy3 onParentLayer:(id)_mockContentLayer atIndex:2];
	
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	
	[_sceneDisplay setStarScene:mockScene];
	
	[[[mockRootProxy stub] andReturn:newContent] filteredContent];

	// blah blah
	[_sceneDisplay nodeProxy:mockRootProxy insertedContent:newContent];
	
	[_mockLayerManipulator verify];
	[mockRootProxy verify];
	[mockScene verify];
	[_mock_graphLayersController verify];
	[_mockContentLayermanager verify];
	
	/* lets do it a second time and layer should get moved */
	[[[_mockContentLayermanager expect] andReturn:_mockContentLayer] lookupLayerForKey: child1];
	[[[_mockContentLayermanager expect] andReturn:_mockContentLayer] lookupLayerForKey: innerChild1];
	[[[_mockContentLayermanager expect] andReturn:_mockContentLayer] lookupLayerForKey: innerChild2];
	[[[_mockContentLayermanager expect] andReturn:_mockContentLayer] lookupLayerForKey: innerChild3];	
	
	[[[_mockContentLayer stub] andReturn:_mockContentLayer] superlayer];
	
	[[_mock_graphLayersController expect] moveStarLayer:(id)_mockContentLayer toIndex:0];
	[[_mock_graphLayersController expect] moveStarLayer:(id)_mockContentLayer toIndex:1];
	[[_mock_graphLayersController expect] moveStarLayer:(id)_mockContentLayer toIndex:2];	

	//blah blah
	[_sceneDisplay nodeProxy:mockRootProxy insertedContent:newContent];
	
	[_mockLayerManipulator verify];
	[mockRootProxy verify];
	[mockScene verify];
	[_mock_graphLayersController verify];
	[_mockContentLayermanager verify];
}

- (void)testNodeProxyRemovedContent {
	// - (void)nodeProxy:(NodeProxy *)value removedContent:(NSArray *)values
	
	// Set the scene
	id mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);

	id mockChildProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy3 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	
	NSArray *newContent = [NSArray arrayWithObjects:
						   mockChildProxy1,
						   mockChildProxy2,
						   mockChildProxy3,
						   nil];
	
	id mockScene = MOCK(StarScene);
	[[[mockScene stub] andReturn:mockRootProxy] rootProxy];

	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockRootProxy onParentLayer:OCMOCK_ANY atIndex:0];
	
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	
	[_sceneDisplay setStarScene:mockScene];

	// Remove the content
	OCMockObject *child1 = MOCK(SHNode);
	[[[mockRootProxy stub] andReturn:child1] originalNode];
	[[[_mockContentLayermanager stub] andReturn:_mockContentLayer] lookupLayerForKey: child1];

	OCMockObject *innerChild1 = MOCK(Graphic);
	OCMockObject *innerChild2 = MOCK(Graphic);
	OCMockObject *innerChild3 = MOCK(Graphic);
	[[[mockChildProxy1 stub] andReturn:innerChild1] originalNode];
	[[[mockChildProxy2 stub] andReturn:innerChild2] originalNode];
	[[[mockChildProxy3 stub] andReturn:innerChild3] originalNode];
		
	[[[innerChild1 stub] andReturnBOOLValue:NO] allowsSubpatches];
	[[[innerChild2 stub] andReturnBOOLValue:NO] allowsSubpatches];
	[[[innerChild3 stub] andReturnBOOLValue:NO] allowsSubpatches];
	
	[[_mock_graphLayersController expect] removeStar:(id)mockChildProxy1 fromLayer:(id)_mockContentLayer];
	[[_mock_graphLayersController expect] removeStar:(id)mockChildProxy2 fromLayer:(id)_mockContentLayer];
	[[_mock_graphLayersController expect] removeStar:(id)mockChildProxy3 fromLayer:(id)_mockContentLayer];

	[[[_mockSelectedLayermanager stub] andReturnBOOLValue:YES] isEmpty];
	[_sceneDisplay nodeProxy:mockRootProxy removedContent:newContent];
	
	[_mockContentLayermanager verify];
	[_mock_graphLayersController verify];
	[mockScene verify];
	[mockChildProxy1 verify];
}

- (void)testCurrentNodeProxyChangedFromTo {
	// - (void)currentNodeProxyChangedFrom:(NodeProxy *)oldValue to:(NodeProxy *)newValue

	//set up
	[[_mock_graphLayersController stub] _createNewStarLayerForProxy:OCMOCK_ANY onParentLayer:OCMOCK_ANY atIndex:0];
	
	id mockRootProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockRootProxy2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *innerChild1 = MOCK(Graphic);
	OCMockObject *innerChild2 = MOCK(Graphic);
	
	[[[mockRootProxy1 stub] andReturn:innerChild1] originalNode];
	[[[mockRootProxy2 stub] andReturn:innerChild2] originalNode];
	
	id mockScene = MOCK(StarScene);
	[[[mockScene stub] andReturn:mockRootProxy1] rootProxy];
	
	id mockModel = MOCK(SHNodeGraphModel);
	[[[mockModel stub] andReturn:innerChild2] currentNodeGroup];
	[[[mockModel stub] andReturn:innerChild1] rootNodeGroup];
	
	[[[mockScene stub] andReturn:mockModel] model];

	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	
	[_sceneDisplay setStarScene:mockScene];

	NSUInteger expectedLayerCount = 0;
	[[[_mockContentLayermanager stub] andReturnBOOLValue:YES] isEmpty];
	[[[_mockSelectedLayermanager stub] andReturnBOOLValue:YES] isEmpty];

	[[[_mockSelectionLayer stub] andReturn:[NSArray array]] sublayers];
	
	[_sceneDisplay currentNodeProxyChangedFrom:mockRootProxy1 to:mockRootProxy2];
	
	[_mockLayerManipulator verify];
	[_mockSelectionLayer verify];
	[_mockContentLayermanager verify];
	[_mockSelectedLayermanager verify];
	[mockModel verify];
	[mockScene verify];
}

- (void)testNodeProxyChangedSelectionToByDeselectingAndSelecting {
	// - (void)nodeProxy:(NodeProxy *)value changedSelectionTo:(NSIndexSet *)values byDeselecting:(NSIndexSet *)oldValues andSelecting:(NSIndexSet *)newValues
	
	//set up	
	[[_mock_graphLayersController stub] _createNewStarLayerForProxy:OCMOCK_ANY onParentLayer:OCMOCK_ANY atIndex:0];
	[[[_mock_selectedLayersController stub] andReturnUIntValue:1] selectedCount];

	// set star scene
	id mockRootProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *child1 = MOCK(Graphic);
	[[[mockRootProxy1 stub] andReturn:child1] originalNode];
	
	id mockScene = MOCK(StarScene);
	[[[mockScene stub] andReturn:mockRootProxy1] rootProxy];

	id mockModel = MOCK(SHNodeGraphModel);
	[[[mockModel stub] andReturn:child1] rootNodeGroup];
	
	[[[mockScene stub] andReturn:mockModel] model];
	
	[[_mockLayerManipulator expect] recursive_newChildLayerForProxy:mockRootProxy1 onParentLayer:(id)_mockRootLayer atIndex:0 withLayerManager:(id)_mockContentLayermanager];
	
	// make 2 levels of content
	id mockChildProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockChildProxy3 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *innerChild1 = MOCK(Graphic);
	OCMockObject *innerChild2 = MOCK(Graphic);
	OCMockObject *innerChild3 = MOCK(Graphic);
	[[[mockChildProxy1 stub] andReturn:innerChild1] originalNode];
	[[[mockChildProxy2 stub] andReturn:innerChild2] originalNode];
	[[[mockChildProxy3 stub] andReturn:innerChild3] originalNode];
	
	NSArray *rootContent = [NSArray arrayWithObjects:
						   mockChildProxy1,
						   mockChildProxy2,
						   mockChildProxy3,
						   nil];
	
	[[[mockRootProxy1 stub] andReturn:rootContent] filteredContent];

	// second level of content
	id mockInnerChildProxy1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockInnerChildProxy2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	id mockInnerChildProxy3 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *deepChild1 = MOCK(Graphic);
	OCMockObject *deepChild2 = MOCK(Graphic);
	OCMockObject *deepChild3 = MOCK(Graphic);
	[[[mockInnerChildProxy1 stub] andReturn:deepChild1] originalNode];
	[[[mockInnerChildProxy2 stub] andReturn:deepChild2] originalNode];
	[[[mockInnerChildProxy3 stub] andReturn:deepChild3] originalNode];
	
	NSArray *innerChild1Content = [NSArray arrayWithObjects:
							mockInnerChildProxy1,
							mockInnerChildProxy2,
							mockInnerChildProxy3,
							nil];

	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	
	[_sceneDisplay setStarScene:mockScene];

	// change the selection
	[[[mockScene stub] andReturn:mockInnerChildProxy1] currentProxy];
	[[[mockChildProxy1 stub] andReturn:innerChild1Content] filteredContent];
	[[[mockScene stub] andReturn:innerChild1Content] currentFilteredContent];

	// what is this crazy debug stuff
	NSUInteger expectedDepth = 1;

	NSIndexSet *newSelection = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
	NSIndexSet *oldValues = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,1)];
	NSIndexSet *newValues = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)];
	
	id mockProxiesToAddToSelection = [NSArray arrayWithObjects:[NSNull null],[NSNull null], nil];
	id mockProxiesToRemoveFromSelection = [NSArray arrayWithObjects:[NSNull null], nil];
	[[[mockChildProxy1 expect] andReturn:mockProxiesToAddToSelection] objectsInFilteredContentAtIndexes:newValues];
	[[[mockChildProxy1 expect] andReturn:mockProxiesToRemoveFromSelection] objectsInFilteredContentAtIndexes:oldValues];

	[[_mock_selectedLayersController expect] addNewSelectedLayersToRoot:mockProxiesToAddToSelection theirIndexesInFilteredContent:newValues allIndexesOfSelectedNodes:newSelection];
	[[_mock_selectedLayersController expect] removeProxiesFromSelection:mockProxiesToRemoveFromSelection];

	[_sceneDisplay nodeProxy:mockChildProxy1 changedSelectionTo:newSelection byDeselecting:oldValues andSelecting:newValues];
	
	[_mock_selectedLayersController verify];
	[mockChildProxy1 verify];
	[deepChild1 verify];
	[deepChild3 verify];
	[_mockContentLayer verify];
	[_mockSelectedLayermanager verify];
}

- (void)testObserveValueForKeyPathOfObjectChangeContext {
	//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext
	
	id mockScene = MOCK(StarScene);
	id mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	[[[mockScene stub] andReturn:mockRootProxy] rootProxy];	
	[[[mockScene stub] andReturn:mockRootProxy] currentProxy];
	
	[[_mock_graphLayersController expect] _createNewStarLayerForProxy:mockRootProxy onParentLayer:OCMOCK_ANY atIndex:0];

	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
	[[mockScene stub] addObserver:_sceneDisplay forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
	[_sceneDisplay setStarScene:mockScene];

	STAssertThrows([_sceneDisplay observeValueForKeyPath:nil ofObject:nil change:nil context:@"SceneDisplay"], @"Bullshit");
	
	NSDictionary *changeDict = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInt:NSKeyValueChangeReplacement], NSKeyValueChangeKindKey, 
								[NSArray arrayWithObjects:[NSIndexSet indexSet], [NSIndexSet indexSet], [NSIndexSet indexSet], nil], NSKeyValueChangeIndexesKey,
								nil];
	
	[[[_mockSelectedLayermanager expect] andReturnBOOLValue:YES] isEmpty];
	[[[_mockSelectionLayer stub] andReturn:[NSArray array]] sublayers];
	[[[_mock_selectedLayersController stub] andReturnUIntValue:0] selectedCount];

	STAssertNoThrow([_sceneDisplay observeValueForKeyPath:@"currentFilteredContentSelectionIndexes" ofObject:mockScene change:changeDict context:@"SceneDisplay"], @"Bullshit");
}

- (void)testSomeAccessors {

	_sceneDisplay.targetView = (id)self;
	STAssertTrue((id)_sceneDisplay.targetView==(id)self, @"doh");
}

@end
