//
//  SelectedLayersControllerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 15/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SelectedLayersController.h"
#import "LayerTreeManipulation.h"
#import "ContentLayerManager.h"
#import "StarSceneUserProtocol.h"
#import "AbstractLayer.h"
#import "Graphic.h"
#import "RootSelectedLayer.h"
#import "SelectedLayerContainer.h"

@interface SelectedLayersControllerTests : SenTestCase {
	
	OCMockObject				*_mockManipulator;
	OCMockObject				*_lyrManager;
	SelectedLayersController	*_layersCntrlr;
	
	OCMockObject				*_mockSelectionLayer;
}

@end

@implementation SelectedLayersControllerTests

- (void)setUp {

	// - (id)initWithContentManager:(ContentLayerManager *)value manipulator:(LayerTreeManipulation *)manip

	_mockManipulator = [MOCK(LayerTreeManipulation) retain];
	_lyrManager = [MOCK(ContentLayerManager) retain];
	_layersCntrlr = [[SelectedLayersController alloc] initWithContentManager:(id)_lyrManager manipulator:(id)_mockManipulator];
	
	_mockSelectionLayer = [MOCK(SelectedLayerContainer) retain];
}

- (void)tearDown {
	
	[_layersCntrlr release];
	[_lyrManager release];
	[_mockManipulator release];
	[_mockSelectionLayer release];
}

- (void)testAddNewSelectedLayersToRootTheirIndexesInFilteredContentallIndexesOfSelectedNodes {
	// - (void)addNewSelectedLayersToRoot:(NSArray *)newlySelectedProxies theirIndexesInFilteredContent:(NSIndexSet *)newIndexes allIndexesOfSelectedNodes:(NSIndexSet *)allIndexes
	
	[[[_lyrManager expect] andReturn:_mockSelectionLayer] containerLayer_temporary];
	
	OCMockObject *prox1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *prox2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *prox3 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	NSArray *selectedProxies = [NSArray arrayWithObjects:prox1, prox2, prox3, nil];
	
	NSMutableIndexSet *theirIndexes = [NSMutableIndexSet indexSetWithIndex:1];
	[theirIndexes addIndexesInRange:NSMakeRange(3, 2)];
	
	NSMutableIndexSet *selectedIndexes = [NSMutableIndexSet indexSetWithIndex:1];
	[selectedIndexes addIndexesInRange:NSMakeRange(2, 3)];

	[[[_mockManipulator expect] andReturn:nil] recursive_newRootSelectedLayerForProxy:(id)prox1 onParentLayer:(id)_mockSelectionLayer atIndex:0 withLayerManager:(id)_lyrManager];
	[[[_mockManipulator expect] andReturn:nil] recursive_newRootSelectedLayerForProxy:(id)prox2 onParentLayer:(id)_mockSelectionLayer atIndex:2 withLayerManager:(id)_lyrManager];
	[[[_mockManipulator expect] andReturn:nil] recursive_newRootSelectedLayerForProxy:(id)prox3 onParentLayer:(id)_mockSelectionLayer atIndex:3 withLayerManager:(id)_lyrManager];

	[_layersCntrlr addNewSelectedLayersToRoot:selectedProxies theirIndexesInFilteredContent:theirIndexes allIndexesOfSelectedNodes:selectedIndexes];
	
	[_lyrManager verify];
	[_mockManipulator verify];
}

- (void)testRemoveProxiesFromSelection {
	// - (void)removeProxiesFromSelection:(NSArray *)proxies
	
	OCMockObject *n1 = MOCK(Graphic);
	OCMockObject *n2 = MOCK(Graphic);
	OCMockObject *n3 = MOCK(Graphic);
	OCMockObject *sub1 = MOCK(Graphic);
	OCMockObject *sub2 = MOCK(Graphic);

	[[[n1 expect] andReturnBOOLValue:NO] allowsSubpatches];
	[[[n2 expect] andReturnBOOLValue:NO] allowsSubpatches];
	[[[n3 expect] andReturnBOOLValue:YES] allowsSubpatches];
	[[[sub1 expect] andReturnBOOLValue:NO] allowsSubpatches];
	[[[sub2 expect] andReturnBOOLValue:NO] allowsSubpatches];

	OCMockObject *prox1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *prox2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *prox3 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *subProx1 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	OCMockObject *subProx2 = MOCKFORPROTOCOL(ProxyLikeProtocol);
	NSArray *selectedProxies = [NSArray arrayWithObjects:prox1, prox2, prox3, nil];	
	NSArray *subChildren = [NSArray arrayWithObjects:subProx1, subProx2, nil];
	[[[prox3 expect] andReturn:subChildren] filteredContent];
	
	[[[prox1 expect] andReturn:n1] originalNode];
	[[[prox2 expect] andReturn:n2] originalNode];
	[[[prox3 expect] andReturn:n3] originalNode];
	[[[subProx1 expect] andReturn:sub1] originalNode];
	[[[subProx2 expect] andReturn:sub2] originalNode];

	OCMockObject *mockLayer1 = MOCK(AbstractLayer);
	OCMockObject *mockLayer2 = MOCK(AbstractLayer);
	OCMockObject *mockLayer3 = MOCK(AbstractLayer);
	OCMockObject *mockLayer4 = MOCK(AbstractLayer);
	OCMockObject *mockLayer5 = MOCK(AbstractLayer);

	[[[_lyrManager expect] andReturn:mockLayer1] lookupLayerForKey:n1];
	[[[_lyrManager expect] andReturn:mockLayer2] lookupLayerForKey:n2];
	[[[_lyrManager expect] andReturn:mockLayer3] lookupLayerForKey:n3];
	[[[_lyrManager expect] andReturn:mockLayer4] lookupLayerForKey:sub1];
	[[[_lyrManager expect] andReturn:mockLayer5] lookupLayerForKey:sub2];

	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer1];
	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer2];
	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer3];
	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer4];
	[[_lyrManager expect] removeSubLayerFromParent:(id)mockLayer5];

	[_layersCntrlr removeProxiesFromSelection:selectedProxies];

	[n1 verify];
	[n2 verify];
	[n3 verify];
	[sub1 verify];
	[sub2 verify];
	[prox1 verify];
	[prox2 verify];
	[prox3 verify];
	[subProx1 verify];
	[subProx2 verify];
	[_lyrManager verify];
}

- (void)testEnforceConsistentState {
	// - (void)enforceConsistentState
	
	OCMockObject *mockSubLayer1 = MOCK(RootSelectedLayer);
	OCMockObject *mockSubLayer2 = MOCK(RootSelectedLayer);
	NSArray *mockSubLayers = [NSArray arrayWithObjects:mockSubLayer1, mockSubLayer2, nil];
	[[mockSubLayer1 expect] enforceConsistentState];
	[[mockSubLayer2 expect] enforceConsistentState];

	[[[_lyrManager expect] andReturn:_mockSelectionLayer] containerLayer_temporary];
	[[[_mockSelectionLayer expect] andReturn:mockSubLayers] sublayers];
	
	[_layersCntrlr enforceConsistentState];
	
	[_lyrManager verify];
	[_mockSelectionLayer verify];
	[mockSubLayer1 verify];
	[mockSubLayer2 verify];
}

- (void)testSelectedCount {
	// - (NSUInteger)selectedCount

	OCMockObject *mockSubLayer1 = MOCK(RootSelectedLayer);
	OCMockObject *mockSubLayer2 = MOCK(RootSelectedLayer);
	NSArray *mockSubLayers = [NSArray arrayWithObjects:mockSubLayer1, mockSubLayer2, nil];
	
	[[[_lyrManager expect] andReturn:_mockSelectionLayer] containerLayer_temporary];
	[[[_mockSelectionLayer expect] andReturn:mockSubLayers] sublayers];
	
	NSUInteger countOfSelection = [_layersCntrlr selectedCount];
	STAssertTrue(countOfSelection==2, @"doh %i", countOfSelection);
	
	[_lyrManager verify];
	[_mockSelectionLayer verify];
}
	
- (void)testRootSelectedLayers {
	// - (NSArray *)rootSelectedLayers

	OCMockObject *mockSubLayer1 = MOCK(RootSelectedLayer);
	OCMockObject *mockSubLayer2 = MOCK(RootSelectedLayer);
	NSArray *mockSubLayers = [NSArray arrayWithObjects:mockSubLayer1, mockSubLayer2, nil];
	
	[[[_lyrManager expect] andReturn:_mockSelectionLayer] containerLayer_temporary];
	[[[_mockSelectionLayer expect] andReturn:mockSubLayers] sublayers];
	
	NSArray *selection = [_layersCntrlr rootSelectedLayers];
	STAssertTrue([selection count]==2, @"hmm");
	STAssertEqualObjects([selection objectAtIndex:0], mockSubLayer1, @"hmm");
	STAssertEqualObjects([selection objectAtIndex:1], mockSubLayer2, @"hmm");

	[_lyrManager verify];
	[_mockSelectionLayer verify];
}
	
@end
