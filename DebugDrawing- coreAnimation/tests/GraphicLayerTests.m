//
//  GraphicLayerTests.m
//  DebugDrawing
//
//  Created by steve hooley on 16/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


#import "GraphicLayer.h"
#import "Graphic.h"


@interface GraphicLayerTests : SenTestCase {
	
	OCMockObject *_mockNode;
	GraphicLayer *_graphicLayer;
}

@end


@implementation GraphicLayerTests

- (void)setUp {
	
	_mockNode = [[OCMockObject mockForClass:[Graphic class]] retain];
	[[[_mockNode stub] andReturn:[NodeName makeNameWithString:@"chicken"]] name];
	[[[_mockNode stub] andReturn:[NSNull null]] actionForLayer:OCMOCK_ANY forKey:OCMOCK_ANY];
	_graphicLayer = [[GraphicLayer layer] retain];
	_graphicLayer.delegate = _mockNode;
}

- (void)tearDown {

	[_graphicLayer release];
	[_mockNode release];
}

- (void)testUpdateGeometryRect {
	//- (void)updateGeometryRect
	
	CGRect gRect = CGRectMake(0,0,10,10);
	[[[_mockNode expect] andReturnValue:OCMOCK_VALUE(gRect)] geometryRect];
	
	STAssertFalse( nearlyEqualCGRects( _graphicLayer.bounds, gRect), @"Fuck" );

	[_graphicLayer updateGeometryRect];
	
	STAssertTrue( nearlyEqualCGRects( _graphicLayer.bounds, gRect), @"Fuck" );

	[_mockNode verify];
}

- (void)testUpdateMatrix {
	//- (void)updateMatrix

	CGAffineTransform transformMatrix = CGAffineTransformMakeTranslation( 1.0f, 20.0f );
	[[[_mockNode expect] andReturnValue:OCMOCK_VALUE(transformMatrix)] transformMatrix];
	
	STAssertFalse( CGAffineTransformEqualToTransform(_graphicLayer.affineTransform, transformMatrix), @"doh" );

	[_graphicLayer updateMatrix];
	STAssertTrue( CGAffineTransformEqualToTransform(_graphicLayer.affineTransform, transformMatrix), @"doh" );
}

- (void)testWasAdded {
//- (void)wasAdded
//- (void)wasRemoved

	[[[_mockNode stub] andReturnValue:OCMOCK_VALUE(expectedPositiveValue)] conformsToProtocol:OCMOCK_ANY];
	[[_mockNode expect] enforceConsistentState];
	[[_mockNode expect] addObserver:_graphicLayer forKeyPath:@"transformMatrix" options:0 context:@"GraphicLayer"];
	[[_mockNode expect] addObserver:_graphicLayer forKeyPath:@"geometryRect" options:0 context:@"GraphicLayer"];
	
	CGAffineTransform transformMatrix = CGAffineTransformMakeTranslation( 1.0f, 20.0f );
	[[[_mockNode expect] andReturnValue:OCMOCK_VALUE(transformMatrix)] transformMatrix];
	CGRect gRect = CGRectMake(0,0,10,10);
	[[[_mockNode expect] andReturnValue:OCMOCK_VALUE( gRect )] geometryRect];
	[_graphicLayer wasAdded];
	
	[_mockNode verify];
	
	[[_mockNode expect] removeObserver:_graphicLayer forKeyPath:@"transformMatrix"];
	[[_mockNode expect] removeObserver:_graphicLayer forKeyPath:@"geometryRect"];
	[_graphicLayer wasRemoved];
	
	[_mockNode verify];
}

- (void)testObserveDelegateProperties {
	
	STAssertThrows( [_graphicLayer observeValueForKeyPath:@"rabbit" ofObject:_mockNode change:nil context:@"GraphicLayer"], @"doh" );

	CGAffineTransform transformMatrix = CGAffineTransformMakeTranslation( 1.0f, 20.0f );
	[[[_mockNode expect] andReturnValue:OCMOCK_VALUE(transformMatrix)] transformMatrix];
	[_graphicLayer observeValueForKeyPath:@"transformMatrix" ofObject:_mockNode change:nil context:@"GraphicLayer"];
	[_mockNode verify];
	
	CGRect gRect = CGRectMake(0,0,10,10);
	[[[_mockNode expect] andReturnValue:OCMOCK_VALUE(gRect)] geometryRect];

	[_graphicLayer observeValueForKeyPath:@"geometryRect" ofObject:_mockNode change:nil context:@"GraphicLayer"];
	[_mockNode verify];
}

@end
