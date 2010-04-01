//
//  ContentLayerManager.h
//  DebugDrawing
//
//  Created by steve hooley on 29/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class AbstractLayer, SHNode;

@interface ContentLayerManager : _ROOT_OBJECT_ {

	// keep a flat reference to each child layer - might be suitable to us MapTable but can't get it to work
	AbstractLayer		*_containerLayer;
	NSMutableDictionary *_layerLookUp;
}

- (id)initWithContainerLayerClass:(Class)layerClass name:(NSString *)layerName parentLayer:(AbstractLayer *)parentLayer;

- (void)insertSublayer:(AbstractLayer *)subLayer atIndex:(NSUInteger)ind inParentLayer:(AbstractLayer *)parentLayer;
- (void)removeSubLayerFromParent:(AbstractLayer *)subLayer;
- (void)moveLayer:(AbstractLayer *)existingLayer toIndex:(NSUInteger)ind;

- (AbstractLayer *)lookupLayerForKey:(id)key;
- (void)addLayerToLookup:(AbstractLayer *)value withKey:(id)key;
- (void)removeLayerFromLookup:(AbstractLayer *)value withKey:(id)key;

- (AbstractLayer *)containerLayer_temporary;
- (BOOL)isEmpty;

@end
