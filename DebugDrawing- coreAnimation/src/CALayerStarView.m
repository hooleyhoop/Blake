//
//  CALayerStarView.m
//  DebugDrawing
//
//  Created by steve hooley on 05/12/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "CALayerStarView.h"
#import "AbstractLayer.h"
#import "ColourUtilities.h"
#import "EditingViewController.h"
#import "RootViewLayer.h"

@implementation CALayerStarView

@synthesize viewController=_viewController;

// NB. In order to swizzle our classes we have to overide the method (for safety sake we dont swizzle superclass methods)
- (id)init {

	self = [super init];
	if(self){
	}
	return self;
}
- (id)initWithFrame:(NSRect)frameRect {

	self = [super initWithFrame:frameRect];
	if(self){
	}
	return self;
}

- (void)dealloc {

	[super dealloc];
}
#pragma mark -
#pragma mark notification methods
- (BOOL)becomeFirstResponder {
	
	[_viewController viewBecameFirstResponder];
	return YES;
}

- (BOOL)resignFirstResponder {
	
	[_viewController viewResignedFirstResponder];
	return YES;
}

#pragma mark blurgg
//june09- (AbstractLayer *)blackTransparentLayer {
//june09	AbstractLayer *layer = [AbstractLayer layer];
	//	layer.contents = (id)[self imageNamed:name ofType:type];
//june09	layer.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
//june09	layer.position = CGPointMake(0,0);
//june09	layer.anchorPoint = CGPointMake(0,0);
//june09	layer.delegate = layer;
//june09	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX]];
//june09	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX]];
//june09	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY]];
//june09	[layer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY]];

//june09	layer.name = @"BlackSolid";
//june09	layer.backgroundColor = [CALayerStarView black];
//june09	layer.opacity = 0.5f;
//june09    blackTransparentLayer = layer;
//june09	[self.layer insertSublayer:layer above:contentLayer];
//june09	return layer;
//june09}

#pragma mark graphics layers
- (void)setupCALayerStuff {
	
	AbstractLayer *layer = [RootViewLayer layer];
	layer.name = @"root";
	layer.backgroundColor = [ColourUtilities backgroundColour];
	
	/* important to set your layer before calling -setWantsLayer: */
	[self setLayer:layer];
	[self setWantsLayer:YES];
	[layer setNeedsDisplay];
	
	/* The object responsible for assigning frame rects to sublayers,
	 * should implement methods from the CALayoutManager informal protocol.
	 * When nil (the default value) only the autoresizing style of layout
	 * is done (unless a subclass overrides -layoutSublayers). */
    layer.layoutManager = [CAConstraintLayoutManager layoutManager];
}

#pragma mark notification
- (void)setFrameSize:(NSSize)newSize {
	
	[super setFrameSize:newSize];
	[_viewController viewDidResize];
}

#pragma mark boring accessors
- (void)setViewController:(EditingViewController *)newController {

    if( _viewController ) {
        NSResponder *controllerNextResponder = [_viewController nextResponder];
        [super setNextResponder:controllerNextResponder];
        [_viewController setNextResponder:nil];
    }
	
    _viewController = newController;
    
    if( newController ) {
        NSResponder *ownNextResponder = [self nextResponder];
        [super setNextResponder: (NSResponder *)_viewController];
        [_viewController setNextResponder:ownNextResponder];
    }
}

- (void)setNextResponder:(NSResponder *)newNextResponder {

    if (_viewController) {
        [_viewController setNextResponder:newNextResponder];
        return;
    }
    [super setNextResponder:newNextResponder];
}

- (BOOL)wantsDefaultClipping {
	return NO;
}

- (BOOL)isOpaque {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

@end
