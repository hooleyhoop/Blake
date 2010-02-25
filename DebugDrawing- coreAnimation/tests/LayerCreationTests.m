//
//  LayerCreationTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 7/5/09.
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


@interface LayerCreationTests : SenTestCase {
	
	LayerCreation *_layerCreator;
}

@end

@implementation LayerCreationTests


- (void)setUp {
	
	_layerCreator = [[LayerCreation alloc] init];
}

- (void)tearDown {
	
	[_layerCreator release];
}

- (void)testMakeRootSelectedLayerForNodeInView {
	// - (AbstractLayer *)makeRootSelectedLayerForNode:(SHNode *)node inView:(CALayerStarView *)starView
	
	OCMockObject *mockLayerView = [OCMockObject mockForClass:[CALayerStarView class]];

	Class testClass1 = [Graphic class];
	OCMockObject *mockNode1 = [OCMockObject mockForClass:testClass1];
	CGRect expectedGeom = CGRectMake(0,0,10,10);
	[[[mockNode1 stub] andReturnValue:OCMOCK_VALUE(expectedGeom)] geometryRect];
	[[[mockNode1 stub] andReturnBOOLValue:YES] isKindOfClass:testClass1];
	[[[mockNode1 stub] andReturn:[NodeName makeNameWithString:@"graphic1"]] name];

	AbstractLayer *newLayer1 = [_layerCreator makeRootSelectedLayerForNode:(id)mockNode1 inView:(id)mockLayerView];
	STAssertTrue( newLayer1.name==@"graphic1", @"failed to set name");
	STAssertTrue( newLayer1.delegate==mockNode1, @"failed to set delegate");

	Class testClass2 = [SHNode class];
	OCMockObject *mockNode2 = [OCMockObject mockForClass:testClass2];
	[[[mockNode2 stub] andReturn:[NodeName makeNameWithString:@"node1"]] name];
	[[[mockNode2 stub] andReturnBOOLValue:NO] isKindOfClass:testClass1];

	AbstractLayer *newLayer2 = [_layerCreator makeRootSelectedLayerForNode:(id)mockNode2 inView:(id)mockLayerView];
	STAssertTrue( newLayer2.name==@"node1", @"failed to set name");
	STAssertTrue( newLayer2.delegate==mockNode2, @"failed to set delegate");
}

- (void)testNewChildLayerForNode {
	//- (AbstractLayer *)makeChildLayerForNode:(SHNode *)node;
	
	Class testClass1 = [Graphic class];
	OCMockObject *mockNode1 = [OCMockObject mockForClass:testClass1];
	CGRect expectedGeom = CGRectMake(0,0,10,10);
	
	[[[mockNode1 stub] andReturnBOOLValue:YES] isKindOfClass:testClass1];
	[[[mockNode1 stub] andReturnValue:OCMOCK_VALUE(expectedGeom)] geometryRect];
	[[[mockNode1 stub] andReturn:[NodeName makeNameWithString:@"graphic1"]] name];

	AbstractLayer *newLayer1 = [_layerCreator makeChildLayerForNode:(id)mockNode1];
	
	STAssertTrue( newLayer1.name==@"graphic1", @"failed to set name");
	STAssertTrue( newLayer1.masksToBounds==NO, @"failed to set masksToBounds");
	STAssertTrue( newLayer1.delegate==mockNode1, @"failed to set delegate");
	STAssertTrue( CGRectEqualToRect( newLayer1.bounds, expectedGeom), @"failed to set delegate");
	
	// try something that isnt a graphic.. what do we want to happen in these cases?
	Class testClass2 = [SHNode class];
	OCMockObject *mockNode2 = [OCMockObject mockForClass:testClass2];
	[[[mockNode2 stub] andReturn:[NodeName makeNameWithString:@"node1"]] name];
	[[[mockNode2 stub] andReturnBOOLValue:NO] isKindOfClass:testClass1];
	AbstractLayer *newLayer2 = [_layerCreator makeChildLayerForNode:(id)mockNode2];
	
	STAssertTrue( newLayer2.name==@"node1", @"failed to set name");
	STAssertTrue( newLayer2.masksToBounds==NO, @"failed to set masksToBounds");
	STAssertTrue( newLayer2.delegate==mockNode2, @"failed to set delegate");
}

//- (void)testNewSelectedLayerForNode {
//	//- (AbstractLayer *)makeSelectedLayerForNode:(SHNode *)node;
//	
//	Class testClass = [Graphic class];
//	OCMockObject *mockNode = [OCMockObject mockForClass:testClass];
//	CGRect expectedGeom = CGRectMake(0,0,10,10);
//
//	[[[mockNode stub] andReturnValue:OCMOCK_VALUE(expectedPositiveValue)] isKindOfClass:testClass];
//	[[[mockNode stub] andReturnValue:OCMOCK_VALUE(expectedGeom)] geometryRect];
//	[[[mockNode stub] andReturn:[NodeName makeNameWithString:@"graphic1"]] name];
//
//	AbstractLayer *newLayer = [_layerCreator makeSelectedLayerForNode:(id)mockNode];
//	
//	STAssertTrue(newLayer.name==@"graphic1", @"failed to set name");
//	STAssertTrue(newLayer.masksToBounds==NO, @"failed to set masksToBounds");
//	STAssertTrue(newLayer.delegate==mockNode, @"failed to set delegate");
//	
//	STAssertTrue( CGRectEqualToRect( newLayer.bounds, expectedGeom), @"failed to set delegate");
//}

- (void)testNewWidgetLayerForTool {
	// - (AbstractLayer *)makeWidgetLayerForTool:(NSObject<Widget_protocol> *)tool
	
	OCMockObject *mockTool = [OCMockObject mockForProtocol:@protocol(Widget_protocol)];
	AbstractLayer *newLayer = [_layerCreator makeWidgetLayerForTool:(id)mockTool];

	STAssertTrue(newLayer.delegate==mockTool, @"failed to set delegate");
}

@end
