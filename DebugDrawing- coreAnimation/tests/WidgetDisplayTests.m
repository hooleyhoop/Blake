//
//  WidgetDisplayTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 6/28/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "WidgetDisplay.h"
#import "ContentLayerManager.h"
#import "LayerCreation.h"
#import "AbstractLayer.h"

@interface WidgetDisplayTests : SenTestCase {
	
	OCMockObject *_mockContentLayermanager;
	OCMockObject *_mockLayerCreator;
	WidgetDisplay *_widgeRenderer;
}

@end

@implementation WidgetDisplayTests

- (void)setUp {

	_mockContentLayermanager = [[OCMockObject mockForClass:[ContentLayerManager class]] retain];
	_mockLayerCreator = [[OCMockObject mockForClass:[LayerCreation class]] retain];

	_widgeRenderer = [[WidgetDisplay alloc] initWithContentLayerManager:(id)_mockContentLayermanager layerCreator:(id)_mockLayerCreator];
}

- (void)tearDown {

	[_widgeRenderer release];
	[_mockContentLayermanager retain];
	[_mockLayerCreator release];
}
	
- (void)testAddWidget {
	// - (void)addWidget:(id<Widget_protocol>)value
	// - (void)removeWidget:(id<Widget_protocol>)value
	
	OCMockObject *mockWidget = [OCMockObject mockForProtocol:@protocol(Widget_protocol)];

	// add a layer
	[[[_mockContentLayermanager expect] andReturn:nil] lookupLayerForKey:mockWidget];
	
	OCMockObject *mockToolLayer = [OCMockObject mockForClass:[AbstractLayer class]];
	[[[_mockLayerCreator expect] andReturn:mockToolLayer] makeWidgetLayerForTool:(id)mockWidget];
	
	NSUInteger expectLayerIndex = 0; 
	[[_mockContentLayermanager expect] insertSublayer:OCMOCK_ANY atIndex:expectLayerIndex inParentLayer:OCMOCK_ANY];
	[[[_mockContentLayermanager stub] andReturn:mockToolLayer] containerLayer_temporary];
	
	[_widgeRenderer addWidget:(id)mockWidget];
	
	// remove a layer
	[[[_mockContentLayermanager expect] andReturn:mockToolLayer] lookupLayerForKey:mockWidget];
	[[_mockContentLayermanager stub] removeSubLayerFromParent:(id)mockToolLayer];
	[[mockToolLayer expect] setDelegate:nil];
	
	[_widgeRenderer removeWidget:(id)mockWidget];
}
	
- (void)testGraphDidUpdate {
	//- (void)graphDidUpdate
}

@end
