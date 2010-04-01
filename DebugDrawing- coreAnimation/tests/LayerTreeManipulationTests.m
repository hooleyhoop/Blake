//
//  LayerTreeManipulationTests.m
//  DebugDrawing
//
//  Created by steve hooley on 14/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "LayerTreeManipulation.h"
#import "StarSceneUserProtocol.h"
#import "LayerCreation.h"
#import "ContentLayerManager.h"
#import "Graphic.h"

#import "CALayerStarView.h"

@interface LayerTreeManipulationTests : SenTestCase {
	
	OCMockObject *_mockLayerCreator;
	OCMockObject *_mockLayerView;
	LayerTreeManipulation *_layerTreeManipulator;
}

@end


@implementation LayerTreeManipulationTests

- (void)setUp {
	
	_mockLayerCreator = [[OCMockObject mockForClass:[LayerCreation class]] retain];
	_mockLayerView = [[OCMockObject mockForClass:[CALayerStarView class]] retain];
	_layerTreeManipulator = [[LayerTreeManipulation alloc] initWithLayerCreator:(id)_mockLayerCreator starView:(id)_mockLayerView];
}

- (void)tearDown {

	[_layerTreeManipulator release];
	[_mockLayerCreator release];
	[_mockLayerView release];
}

- (void)testRecursive_newChildLayerForProxyOnParentLayerAtIndexWithLayerManager {
	//- (void)recursive_newChildLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager;
	
	OCMockObject *mockLayer = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *mockContentLayermanager = [OCMockObject mockForClass:[ContentLayerManager class]];
	
	OCMockObject *mockRootProxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
	OCMockObject *mockNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockRootProxy stub] andReturn:mockNode] originalNode];

	OCMockObject *mockChildProxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
	OCMockObject *mockChildNode = [OCMockObject mockForClass:[SHNode class]];
	[[[mockChildProxy stub] andReturn:mockChildNode] originalNode];
	
	Class testClass = [Graphic class];
	[[[mockNode stub] andReturnValue:OCMOCK_VALUE(expectedNegativeValue)] isKindOfClass:testClass];
	[[[mockNode stub] andReturnValue:OCMOCK_VALUE(expectedPositiveValue)] allowsSubpatches];
	
	[[[mockChildNode stub] andReturnValue:OCMOCK_VALUE(expectedNegativeValue)] isKindOfClass:testClass];
	[[[mockChildNode stub] andReturnValue:OCMOCK_VALUE(expectedNegativeValue)] allowsSubpatches];
	
	[[[mockRootProxy expect] andReturn:[NSArray arrayWithObject:mockChildProxy]] filteredContent];
	
	[[[_mockLayerCreator stub] andReturn:mockLayer] makeChildLayerForNode:OCMOCK_ANY];
	[[[mockContentLayermanager stub] andReturn:nil] lookupLayerForKey:OCMOCK_ANY];
	[[mockContentLayermanager stub] insertSublayer:(id)mockLayer atIndex:0 inParentLayer:(id)mockLayer];
	
	[_layerTreeManipulator recursive_newChildLayerForProxy:(id)mockRootProxy onParentLayer:(id)mockLayer atIndex:0 withLayerManager:(id)mockContentLayermanager];
}

//- (void)testRecursive_newChildSelectedLayerForProxyOnParentLayerAtIndexWithLayerManager {
//	//- (void)recursive_newChildSelectedLayerForProxy:(NodeProxy *)proxy onParentLayer:(SelectedLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager;
//	
//	OCMockObject *mockLayer = [OCMockObject mockForClass:[CALayer class]];
//	OCMockObject *mockContentLayermanager = [OCMockObject mockForClass:[ContentLayerManager class]];
//
//	OCMockObject *mockRootProxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
//	OCMockObject *mockNode = [OCMockObject mockForClass:[SHNode class]];
//	[[[mockRootProxy stub] andReturn:mockNode] originalNode];
//
//	OCMockObject *mockChildProxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
//	OCMockObject *mockChildNode = [OCMockObject mockForClass:[SHNode class]];
//	[[[mockChildProxy stub] andReturn:mockChildNode] originalNode];
//
//	Class testClass = [Graphic class];
//	[[[mockNode stub] andReturnValue:OCMOCK_VALUE(expectedNegativeValue)] isKindOfClass:testClass];
//	[[[mockNode stub] andReturnValue:OCMOCK_VALUE(expectedPositiveValue)] allowsSubpatches];
//	
//	[[[mockChildNode stub] andReturnValue:OCMOCK_VALUE(expectedNegativeValue)] isKindOfClass:testClass];
//	[[[mockChildNode stub] andReturnValue:OCMOCK_VALUE(expectedNegativeValue)] allowsSubpatches];
//	
//	[[[mockRootProxy expect] andReturn:[NSArray arrayWithObject:mockChildProxy]] filteredContent];
//
//	[[[_mockLayerCreator stub] andReturn:mockLayer] makeSelectedLayerForNode:OCMOCK_ANY];
//	[[[mockContentLayermanager stub] andReturn:nil] lookupLayerForKey:OCMOCK_ANY];
//	[[mockContentLayermanager stub] insertSublayer:(id)mockLayer atIndex:0 inParentLayer:(id)mockLayer];
//
//	[_layerTreeManipulator recursive_newChildSelectedLayerForProxy:(id)mockRootProxy onParentLayer:(id)mockLayer atIndex:0 withLayerManager:(id)mockContentLayermanager];
//}

//- (void)testMakeSelectedLayersFromToWithLayerManager {
//	//- (void)makeSelectedLayersFrom:(NodeProxy *)proxy1 to:(NodeProxy *)proxy2 withLayerManager:(ContentLayerManager *)layerManager
//	
//	OCMockObject *mockRootProxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
//	OCMockObject *mockChild1Proxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
//	OCMockObject *mockChild2Proxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
//	OCMockObject *mockContentLayermanager = [OCMockObject mockForClass:[ContentLayerManager class]];
//
//	/* a mini node graph */
//	SHNode *rootNode = [SHNode makeChildWithName:@"root"];
//	SHNode *childNode1 = [SHNode makeChildWithName:@"child1"];
//	SHNode *childNode2 = [SHNode makeChildWithName:@"child2"];
//
//	[rootNode addChild:childNode1 undoManager:nil];
//	[childNode1 addChild:childNode2 undoManager:nil];
//
//	[[[mockRootProxy stub] andReturn:rootNode] originalNode];
//	[[[mockChild1Proxy stub] andReturn:childNode1] originalNode];
//	[[[mockChild2Proxy stub] andReturn:childNode2] originalNode];
//
//	// just try with one layer
//	OCMockObject *selectionLayerHolder = [OCMockObject mockForClass:[CALayer class]];
//	OCMockObject *rootLayer = [OCMockObject mockForClass:[CALayer class]];
//	OCMockObject *child1Layer = [OCMockObject mockForClass:[CALayer class]];
//	OCMockObject *child2Layer = [OCMockObject mockForClass:[CALayer class]];
//
//	[[[mockContentLayermanager stub] andReturn:selectionLayerHolder] containerLayer_temporary];
//	[[[_mockLayerCreator stub] andReturn:rootLayer] makeSelectedLayerForNode:rootNode];
//	[[[_mockLayerCreator stub] andReturn:child1Layer] makeSelectedLayerForNode:childNode1];
//	[[[_mockLayerCreator stub] andReturn:child2Layer] makeSelectedLayerForNode:childNode2];
//
//	[[mockContentLayermanager expect] insertSublayer:(id)rootLayer atIndex:0 inParentLayer:(id)selectionLayerHolder];
//		[_layerTreeManipulator makeSelectedLayersUptoAndIncluding:(id)rootNode withLayerManager:(id)mockContentLayermanager];
//	[mockContentLayermanager verify];
//	
//	// try with two layers
//	[[[mockContentLayermanager expect] andReturn:nil] lookupLayerForKey:rootNode];
//	[[[mockContentLayermanager expect] andReturn:rootLayer] lookupLayerForKey:rootNode];
//	[[mockContentLayermanager expect] insertSublayer:(id)rootLayer atIndex:0 inParentLayer:(id)selectionLayerHolder];
//	[[mockContentLayermanager expect] insertSublayer:(id)child1Layer atIndex:0 inParentLayer:(id)rootLayer];
//		[_layerTreeManipulator makeSelectedLayersUptoAndIncluding:(id)childNode1 withLayerManager:(id)mockContentLayermanager];
//	[mockContentLayermanager verify];
//
//	// try with 2 layers, root allready exists
//	[[[mockContentLayermanager expect] andReturn:rootLayer] lookupLayerForKey:rootNode];
//	[[mockContentLayermanager expect] insertSublayer:(id)child1Layer atIndex:0 inParentLayer:(id)rootLayer];
//		[_layerTreeManipulator makeSelectedLayersUptoAndIncluding:(id)childNode1 withLayerManager:(id)mockContentLayermanager];
//	[mockContentLayermanager verify];
//	
//	// try with 3 layers
//	[[[mockContentLayermanager expect] andReturn:nil] lookupLayerForKey:rootNode];
//	[[[mockContentLayermanager expect] andReturn:rootLayer] lookupLayerForKey:rootNode];
//	[[[mockContentLayermanager expect] andReturn:nil] lookupLayerForKey:childNode1];
//	[[[mockContentLayermanager expect] andReturn:child1Layer] lookupLayerForKey:childNode1];
//
//	[[mockContentLayermanager expect] insertSublayer:(id)rootLayer atIndex:0 inParentLayer:(id)selectionLayerHolder];
//	[[mockContentLayermanager expect] insertSublayer:(id)child1Layer atIndex:0 inParentLayer:(id)rootLayer];
//	[[mockContentLayermanager expect] insertSublayer:(id)child2Layer atIndex:0 inParentLayer:(id)child1Layer];
//		[_layerTreeManipulator makeSelectedLayersUptoAndIncluding:(id)childNode2 withLayerManager:(id)mockContentLayermanager];
//	[mockContentLayermanager verify];
//}

- (void)testRemoveEmptyLayerAndEmptyLayersAboveWithLayerManager {
	//- (void)removeEmptyLayerAndEmptyLayersAbove:(AbstractLayer *)emptyLayer withLayerManager:(ContentLayerManager *)layerManager
	
	OCMockObject *mockContentLayermanager = [OCMockObject mockForClass:[ContentLayerManager class]];

	OCMockObject *selectionLayerHolder = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *rootLayer = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *child1Layer = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *child2Layer = [OCMockObject mockForClass:[CALayer class]];
	
	[[[mockContentLayermanager stub] andReturn:selectionLayerHolder] containerLayer_temporary];

	[[[child1Layer stub] andReturn:[NSArray array]] sublayers];
	[[[child2Layer stub] andReturn:[NSArray array]] sublayers];
	[[[rootLayer stub] andReturn:[NSArray array]] sublayers];
	[[[selectionLayerHolder stub] andReturn:[NSArray array]] sublayers];

	[[[rootLayer stub] andReturn:selectionLayerHolder] superlayer];
	[[[child1Layer stub] andReturn:rootLayer] superlayer];
	[[[child2Layer stub] andReturn:child1Layer] superlayer];
	
	[[mockContentLayermanager expect] removeSubLayerFromParent:(id)child2Layer];
	[[mockContentLayermanager expect] removeSubLayerFromParent:(id)child1Layer];
	[[mockContentLayermanager expect] removeSubLayerFromParent:(id)rootLayer];
	
	[_layerTreeManipulator removeEmptyLayerAndEmptyLayersAbove:(id)child2Layer withLayerManager:(id)mockContentLayermanager];
	
	[mockContentLayermanager verify];
}

- (void)testRecursive_newRootSelectedLayerForProxyOnParentLayerAtIndexWithLayerManager {
	//- (AbstractLayer *)recursive_newRootSelectedLayerForProxy:(NodeProxy *)proxy onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind withLayerManager:(ContentLayerManager *)layerManager {
	
	OCMockObject *mockRootProxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
	OCMockObject *mockChild1Proxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
	OCMockObject *mockChild2Proxy = [OCMockObject mockForProtocol:@protocol(ProxyLikeProtocol)];
	OCMockObject *mockContentLayermanager = [OCMockObject mockForClass:[ContentLayerManager class]];

	/* a mini node graph */
	SHNode *rootNode = [SHNode makeChildWithName:@"root"];
	SHNode *childNode1 = [SHNode makeChildWithName:@"child1"];
	SHNode *childNode2 = [SHNode makeChildWithName:@"child2"];
	
	[rootNode addChild:childNode1 undoManager:nil];
	[childNode1 addChild:childNode2 undoManager:nil];
	
	[[[mockRootProxy stub] andReturn:rootNode] originalNode];
	[[[mockChild1Proxy stub] andReturn:childNode1] originalNode];
	[[[mockChild2Proxy stub] andReturn:childNode2] originalNode];
	
	// just try with one layer
	OCMockObject *selectionLayerHolder = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *rootLayer = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *child1Layer = [OCMockObject mockForClass:[CALayer class]];
	OCMockObject *child2Layer = [OCMockObject mockForClass:[CALayer class]];
	
	[[[mockContentLayermanager stub] andReturn:nil] lookupLayerForKey:OCMOCK_ANY];
	[[[_mockLayerCreator stub] andReturn:rootLayer] makeRootSelectedLayerForNode:OCMOCK_ANY inView:(id)_mockLayerView];
	[[mockContentLayermanager expect] insertSublayer:OCMOCK_ANY atIndex:0 inParentLayer:OCMOCK_ANY];
	[[mockContentLayermanager expect] insertSublayer:OCMOCK_ANY atIndex:0 inParentLayer:OCMOCK_ANY];
	[[mockContentLayermanager expect] insertSublayer:OCMOCK_ANY atIndex:1 inParentLayer:OCMOCK_ANY];
	
	[[[mockRootProxy expect] andReturn:[NSArray arrayWithObjects:mockChild1Proxy, mockChild2Proxy, nil]] filteredContent];
	[[[mockChild1Proxy expect] andReturn:nil] filteredContent];
	[[[mockChild2Proxy expect] andReturn:nil] filteredContent];

	AbstractLayer *newLayer = [_layerTreeManipulator recursive_newRootSelectedLayerForProxy:(id)mockRootProxy onParentLayer:(id)selectionLayerHolder atIndex:0 withLayerManager:(id)mockContentLayermanager];

	
}



@end
