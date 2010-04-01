//
//  ContentLayerManagerTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 7/5/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "ContentLayerManager.h"
#import "AbstractLayer.h"

@interface ContentLayerManagerTests : SenTestCase {
	
	AbstractLayer *_rootLayer;
	ContentLayerManager *_layerManager;
}

@end


@implementation ContentLayerManagerTests

- (void)setUp {
	_rootLayer = [[AbstractLayer layer] retain];
	_layerManager = [[ContentLayerManager alloc] initWithContainerLayerClass:[AbstractLayer class] name:@"myContentWrapper" parentLayer:_rootLayer];
	STAssertNotNil([_layerManager containerLayer_temporary], @"setup failed");
}

- (void)tearDown {
	[_rootLayer release];
	[_layerManager release];
}

- (void)testInsertSublayerAtIndexInParentLayer {
//- (void)insertSublayer:(AbstractLayer *)subLayer atIndex:(NSUInteger)ind inParentLayer:(AbstractLayer *)parentLayer
//- (void)removeSubLayerFromParent:(AbstractLayer *)subLayer
// - (AbstractLayer *)lookupLayerForKey:(id)key

	AbstractLayer *newLayer1 = [AbstractLayer layer];
	newLayer1.delegate = newLayer1;
	
	// add
	STAssertThrows([_layerManager insertSublayer:newLayer1 atIndex:11 inParentLayer:[_layerManager containerLayer_temporary]], @"bad index");
	STAssertNoThrow([_layerManager insertSublayer:newLayer1 atIndex:0 inParentLayer:[_layerManager containerLayer_temporary]], @"unknown error");
	STAssertThrows([_layerManager insertSublayer:newLayer1 atIndex:0 inParentLayer:[_layerManager containerLayer_temporary]], @"cant add twice");
	
	STAssertTrue([_layerManager lookupLayerForKey:newLayer1]==newLayer1, @"failed to lookup layer using delegate as key");

	// remove
	STAssertNoThrow([_layerManager removeSubLayerFromParent:newLayer1], @"unknown error");
	STAssertThrows([_layerManager removeSubLayerFromParent:newLayer1], @"unknown error");
	
	STAssertFalse([_layerManager lookupLayerForKey:newLayer1]==newLayer1, @"failed to lookup layer using delegate as key");
}

- (void)testMoveLayerToIndex {
//- (void)moveLayer:(AbstractLayer *)existingLayer toIndex:(NSUInteger)ind;

	AbstractLayer *newLayer1 = [AbstractLayer layer];
	newLayer1.delegate = newLayer1;

	AbstractLayer *newLayer2 = [AbstractLayer layer];
	newLayer2.delegate = newLayer2;

	STAssertNoThrow([_layerManager insertSublayer:newLayer1 atIndex:0 inParentLayer:[_layerManager containerLayer_temporary]], @"unknown error");
	STAssertNoThrow([_layerManager insertSublayer:newLayer2 atIndex:1 inParentLayer:[_layerManager containerLayer_temporary]], @"unknown error");
	
	STAssertThrows([_layerManager moveLayer:newLayer1 toIndex:0], @"should already be at that index");
	STAssertThrows([_layerManager moveLayer:newLayer1 toIndex:3], @"index should be out of bounds");
	
	STAssertNoThrow([_layerManager moveLayer:newLayer1 toIndex:1], @"index should be out of bounds");
	
	STAssertTrue([[[_layerManager containerLayer_temporary] sublayers] objectAtIndex:0]==newLayer2, @"move failed");
	STAssertTrue([[[_layerManager containerLayer_temporary] sublayers] objectAtIndex:1]==newLayer1, @"move failed");
}

@end
