//
//  GraphLayersControllerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 15/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "GraphLayersController.h"
#import "LayerTreeManipulation.h"
#import "ContentLayerManager.h"
#import "StarSceneUserProtocol.h"
#import "NodeContainerLayer.h"
#import "Graphic.h"

@interface GraphLayersControllerTests : SenTestCase {
	
	OCMockObject			*_mockManipulator;
	OCMockObject			*_lyrManager;
	OCMockObject			*_mockContentLayer;
	GraphLayersController	*_grphLyrContrl;
}

@end


@implementation GraphLayersControllerTests

- (void)setUp {
	
	_mockManipulator = [MOCK(LayerTreeManipulation) retain];
	_lyrManager = [MOCK(ContentLayerManager) retain];
	_grphLyrContrl = [[GraphLayersController alloc] initWithContentManager:(id)_lyrManager manipulator:(id)_mockManipulator];
	
	_mockContentLayer = [MOCK(NodeContainerLayer) retain];
}

- (void)tearDown {
	
	[_grphLyrContrl release];
	[_lyrManager release];
	[_mockManipulator release];
	[_mockContentLayer release];
}

- (void)testCreateNewStarLayerForProxyOnParentLayerAtIndex {
	// - (void)_createNewStarLayerForProxy:(NodeProxy *)aGraphic onParentLayer:(AbstractLayer *)layer atIndex:(NSUInteger)ind
	
	OCMockObject *mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	[[_mockManipulator expect] recursive_newChildLayerForProxy:(id)mockRootProxy onParentLayer:(id)_mockContentLayer atIndex:0 withLayerManager:(id)_lyrManager];
	
	[_grphLyrContrl _createNewStarLayerForProxy:(id)mockRootProxy onParentLayer:(id)_mockContentLayer atIndex:0];
	
	[_mockManipulator verify];
}

- (void)testRemoveStarFromLayer {
	// - (void)removeStar:(NodeProxy *)aGraphic fromLayer:(AbstractLayer *)layer
	
	OCMockObject *n1 = MOCK(Graphic);
	OCMockObject *sub1 = MOCK(Graphic);
	OCMockObject *sub2 = MOCK(Graphic);
	
	[[[n1 expect] andReturnBOOLValue:YES] allowsSubpatches];
	[[[sub1 expect] andReturnBOOLValue:NO] allowsSubpatches];
	[[[sub2 expect] andReturnBOOLValue:NO] allowsSubpatches];
	
	OCMockObject *mockRootProxy = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *subProx1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *subProx2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	
	[[[mockRootProxy expect] andReturn:n1] originalNode];
	[[[subProx1 expect] andReturn:sub1] originalNode];
	[[[subProx2 expect] andReturn:sub2] originalNode];
	
	OCMockObject *mockLayer1 = MOCK(AbstractLayer);
	OCMockObject *mockLayer2 = MOCK(AbstractLayer);
	OCMockObject *mockLayer3 = MOCK(AbstractLayer);
	[[[_lyrManager expect] andReturn:mockLayer1] lookupLayerForKey:n1];
	[[[_lyrManager expect] andReturn:mockLayer2] lookupLayerForKey:sub1];
	[[[_lyrManager expect] andReturn:mockLayer3] lookupLayerForKey:sub2];

	NSArray *subChildren = [NSArray arrayWithObjects:subProx1, subProx2, nil];
	[[[mockRootProxy expect] andReturn:subChildren] filteredContent];

	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer1];
	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer2];
	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer3];

	[_grphLyrContrl removeStar:(id)mockRootProxy fromLayer:(id)_mockContentLayer];

	[mockRootProxy verify];
	[n1 verify];
	[_lyrManager verify];
	[subProx1 verify];
	[subProx2 verify];
	[sub1 verify];
	[sub2 verify];
}

- (void)testMoveStarLayerToIndex {
	// - (void)moveStarLayer:(AbstractLayer *)existingLayer toIndex:(NSUInteger)ind

	OCMockObject *mockLayer1 = MOCK(AbstractLayer);
	[[_lyrManager expect] moveLayer:(id)mockLayer1 toIndex:55];

	[_grphLyrContrl moveStarLayer:(id)mockLayer1 toIndex:55];
	
	[_lyrManager verify];
}

@end
