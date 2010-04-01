//
//  ContentLayerManager.m
//  DebugDrawing
//
//  Created by steve hooley on 29/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ContentLayerManager.h"
#import "AbstractLayer.h"
#import "ColourUtilities.h"


@implementation ContentLayerManager

- (id)initWithContainerLayerClass:(Class)layerClass name:(NSString *)layerName parentLayer:(AbstractLayer *)parentLayer {

	// NSAssert([layerClass isKindOfClass:[CALayer class]], @"needs to be a subclass of CALayer");
	NSParameterAssert(layerName);
	NSParameterAssert(parentLayer);

	self = [super init];
	if(self){

		_layerLookUp = [[NSMutableDictionary alloc] init];

		_containerLayer = [layerClass layer];
		_containerLayer.name = layerName;

		// move this into the layer
		_containerLayer.delegate = _containerLayer;
//		_containerLayer.opacity = 1.0f;
//		_containerLayer.backgroundColor = [ColourUtilities white];
//		CGColorRef bCol = [ColourUtilities newColorRef:0.0 :1.0 :1.0 :1.0];
//		_containerLayer.borderColor = bCol;
//		_containerLayer.borderWidth = 2.0;
//		[_containerLayer setAnchorPoint:CGPointMake(0,0)];
//        [_containerLayer setBounds: parentLayer.bounds];
//		_containerLayer.masksToBounds = YES;
//		_containerLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;

		// So, the container layer always fills the view, right?
		// From what i can gather you can have a layer with zero width & height
		// that doesn't clip to it's bounds and it will just act like a transform - container layers could act that way instead
		
//		[_containerLayer addConstraint:  [CAConstraint constraintWithAttribute: kCAConstraintMinX
//									relativeTo: @"superlayer"
//									 attribute: kCAConstraintMinX
//										  ]];
//		
//		[_containerLayer addConstraint: [CAConstraint constraintWithAttribute: kCAConstraintMinY
//									relativeTo: @"superlayer"
//									 attribute: kCAConstraintMinY
//										 ]];
//
//		[_containerLayer addConstraint:  [CAConstraint constraintWithAttribute: kCAConstraintMaxX
//																	relativeTo: @"superlayer"
//																	 attribute: kCAConstraintMaxX
//										  ]];
//		
//		[_containerLayer addConstraint: [CAConstraint constraintWithAttribute: kCAConstraintMaxY
//																   relativeTo: @"superlayer"
//																	attribute: kCAConstraintMaxY
//										 ]];

		
		/* This will add _containerLayer to our layer lookup, it doesn't need to be - but is it a problem? */
		[self insertSublayer:_containerLayer atIndex:[parentLayer.sublayers count] inParentLayer:parentLayer];
		[_containerLayer wasAdded];
//		[parentLayer setNeedsLayout];
		
		_containerLayer.hidden = YES;
	}
	return self;
}

- (void)dealloc {

	// remove layers?

	[_layerLookUp release];
	[super dealloc];
}

- (void)insertSublayer:(AbstractLayer *)subLayer atIndex:(NSUInteger)ind inParentLayer:(AbstractLayer *)parentLayer {
	
	NSParameterAssert(subLayer);
	NSParameterAssert(parentLayer);
	NSAssert([[parentLayer sublayers] count]>=ind, @"Invalid index");

	if(_containerLayer.hidden==YES)
		_containerLayer.hidden=NO;

	[subLayer wasAdded];

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		[parentLayer insertSublayer:subLayer atIndex:ind];
	[CATransaction commit];
	[self addLayerToLookup:subLayer withKey:subLayer.delegate];
	
	[subLayer setNeedsDisplay];
}

- (void)removeSubLayerFromParent:(AbstractLayer *)subLayer {

	NSParameterAssert(subLayer.superlayer);
	[subLayer wasRemoved];

	[CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		[subLayer removeFromSuperlayer];
    [CATransaction commit];
	[self removeLayerFromLookup:subLayer withKey:subLayer.delegate];
	
	// hide if empty?
	if([_containerLayer.sublayers count]==0){
		_containerLayer.hidden = YES;
	}
}

- (void)moveLayer:(AbstractLayer *)existingLayer toIndex:(NSUInteger)ind {
	
	NSParameterAssert(existingLayer);
	
	CALayer *superlayer = existingLayer.superlayer;
	NSArray *sublayers = [[[superlayer sublayers] copy] autorelease];
	NSUInteger numberOfLayers = [sublayers count];
	NSAssert([sublayers indexOfObjectIdenticalTo:existingLayer]!=ind, @"layer is already at that index");
	NSAssert(numberOfLayers>ind, @"index out of bounds");

	[existingLayer retain];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		[existingLayer removeFromSuperlayer];
		[superlayer insertSublayer:existingLayer atIndex:ind]; 
	[CATransaction commit];
	
	[existingLayer release];
	NSArray *newsublayers = [[[superlayer sublayers] copy] autorelease];
	NSUInteger newNumberOfLayers = [newsublayers count];
	NSAssert(numberOfLayers==newNumberOfLayers, @"layer count shouldnt change");
}

#pragma mark Lookup Stuff
- (AbstractLayer *)lookupLayerForKey:(id)key {
	
	NSParameterAssert(key);
	NSParameterAssert(_layerLookUp);
	return [_layerLookUp objectForKey:[NSValue valueWithPointer:key]];
}

- (void)addLayerToLookup:(AbstractLayer *)value withKey:(id)key {
	
	NSParameterAssert(value);
	NSParameterAssert(key);
	NSParameterAssert(_layerLookUp);
	
	NSValue *ptrKey = [NSValue valueWithPointer:key];
	NSArray *sanityCheck = [_layerLookUp allKeysForObject:ptrKey];
	NSAssert1([sanityCheck count]==0, @"something has gone wrong! - allready got layer %@", value);
	NSAssert( [_layerLookUp objectForKey:ptrKey]==nil, @"doh! cant add same key to layerstore twice!");
	[_layerLookUp setObject:value forKey:ptrKey];
}

- (void)removeLayerFromLookup:(AbstractLayer *)value withKey:(id)key {
    
	NSParameterAssert(value);
	NSParameterAssert(key);

	NSArray *sanityCheck = [_layerLookUp allKeysForObject:value];
	NSAssert([sanityCheck count]==1, @"something has gone wrong! - out of sync");
	NSValue *ptrKey = [NSValue valueWithPointer:key];
	[_layerLookUp removeObjectForKey:ptrKey];
}

#pragma mark Accessor methods
- (AbstractLayer *)containerLayer_temporary {
	return _containerLayer;
}

- (NSUInteger)_debug_layerLookUpCount {
	return [_layerLookUp count];
}

/* when are we empty? when we have just one layer which is the root */
- (BOOL)isEmpty {
	return [self _debug_layerLookUpCount]==1;
}

@end
