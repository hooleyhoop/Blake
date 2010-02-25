//
//  GraphicLayer.m
//  DebugDrawing
//
//  Created by steve hooley on 16/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "GraphicLayer.h"
#import "Graphic.h"
//#import "MathUtilities.h"
#import "iAmTransformableProtocol.h"

@implementation GraphicLayer

//@synthesize boundsBorder = _boundsBorder;

- (void)wasAdded {
	
    // Do the messy conversion from NSAffineTransform -- CGAffineTransform -- CATransform3D
	id delegate = [self delegate];
	NSAssert( delegate, @"Must set a delegate for layer");

	// jeez - what position is the layer for a group node in?
	if([delegate conformsToProtocol:@protocol(iAmTransformableProtocol)])
	{
		NSObject <iAmTransformableProtocol>* transforableDelegate = delegate;
        [transforableDelegate enforceConsistentState];
        
//TODO: -- HMM. this doesn't cover all cases where we will need to redraw. ie setLineWidth will cause drawing bounds to change…
        [transforableDelegate addObserver:self forKeyPath:@"transformMatrix" options:0 context: @"GraphicLayer"];
        [transforableDelegate addObserver:self forKeyPath:@"geometryRect" options:0 context: @"GraphicLayer"];
		
		[self updateMatrix];
		[self updateGeometryRect];
	} else {
		NSLog(@"not observing %@", delegate);
	}
	[super wasAdded];
}

- (void)wasRemoved {
    
    // Do the messy conversion from NSAffineTransform -- CGAffineTransform -- CATransform3D
	id delegate = [self delegate];
	NSAssert( delegate, @"Must set a delegate for layer");

	if([delegate conformsToProtocol:@protocol(iAmTransformableProtocol)])
	{
		NSObject <iAmTransformableProtocol>* transforableDelegate = delegate;

        [transforableDelegate removeObserver:self forKeyPath:@"transformMatrix"];
        [transforableDelegate removeObserver:self forKeyPath:@"geometryRect"];
	}
	[super wasRemoved];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"GraphicLayer"] )
	{
        if ([keyPath isEqualToString:@"transformMatrix"])
        {
			[self updateMatrix];
			return;
		} else if ([keyPath isEqualToString:@"geometryRect"]) {
			[self updateGeometryRect];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

- (void)updateMatrix {
	
	// 2d?
	Graphic *delegateGraphic = [self delegate];
	NSAssert(delegateGraphic, @"doh - no delegate on layer");

	CGAffineTransform transformMatrix = [delegateGraphic transformMatrix];
	[self setAffineTransform: transformMatrix];

	// 3d?
    // CATransform3D dXform = CATransform3DMakeAffineTransform(cgaf);
	// [self setTransform: dXform];
}

/* This doesnt really work for line width case! */
- (void)updateGeometryRect {
	
	Graphic *delegateGraphic = [self delegate];
    CGRect geom = [delegateGraphic geometryRect];
	NSAssert(G3DCompareFloat(geom.origin.x,0.0f,0.001f)==0, @"bounds must be zero based");
	NSAssert(G3DCompareFloat(geom.origin.y,0.0f,0.001f)==0, @"bounds must be zero based");

	/* This is from toolLayer refactor - boundsBorder is zero for graphics, dont know why it is needed at all 
		Maybe for selection marquee? Is layer still placed correctly if we make it larger?
	 */
//	geom = CGRectInset( geom, -_boundsBorder, -_boundsBorder ); // add a border for good measure? - This makes me nervous!

	// resize the layer
//fromToolLayer	if(bnds.size.width>1.0f && bnds.size.height>1.0f)
//fromToolLayer		{
	
	if( nearlyEqualCGRects( self.bounds, geom )==NO )
	{
		[self setBounds:geom];
	
		/*	If we allow non-zero bounds (i think we won't) we need to do
			something like this. Frankly i don't know what this does
		CATransform3D currentTransform = [self transform];
		CGPoint origin = geom.origin;
		_xTransform = origin.x -_xTransform;
		_yTransform = origin.y - _yTransform;
		
		// translate the layer
		currentTransform = CATransform3DTranslate( currentTransform, _xTransform, _yTransform, 0 );
		[self setTransform: currentTransform];
		*/
		
		[self setNeedsDisplay];
	//fromToolLayer	}
	}
} 

@end
