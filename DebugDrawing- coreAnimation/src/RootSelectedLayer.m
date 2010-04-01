//
//  RootSelectedLayer.m
//  DebugDrawing
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "RootSelectedLayer.h"
#import "Graphic.h"
//#import "MathUtilities.h"
#import "iAmTransformableProtocol.h"
#import "EditingViewController.h"
#import "CALayerStarView.h"


@interface RootSelectedLayer ()

- (void)updateZoomIndependantGeom;

@end


/*
 *
*/
@implementation RootSelectedLayer

@synthesize containerView=_containerView;

- (void)wasAdded {
	
	Graphic *delegateGraphic = [self delegate];
	NSAssert(delegateGraphic, @"doh - no delegate on layer");

	if([delegateGraphic conformsToProtocol:@protocol(iAmTransformableProtocol)])
	{
		NSAssert([_containerView viewController], @"doh - no view controller");

		NSObject <iAmTransformableProtocol> *transforableDelegate = delegateGraphic;

		[[_containerView viewController] observeZoomMatrix:self withContext:@"RootSelectedLayer"];
		[transforableDelegate addObserver:self forKeyPath:@"concatenatedMatrixNeedsRecalculating" options:0 context:@"RootSelectedLayer"];
		[transforableDelegate addObserver:self forKeyPath:@"geometryRect" options:0 context: @"RootSelectedLayer"];

	//TODO: obviously there are 3 factors
	// 1: view
	// 2: All layers Xforms
	// 3: This layers geometry

		_needsRealculating = YES;
		[self enforceConsistentState];
	}
	[super wasAdded];
}

- (void)wasRemoved {

	Graphic *delegateGraphic = [self delegate];
	NSAssert(delegateGraphic, @"doh - no delegate on layer");
	
	if([delegateGraphic conformsToProtocol:@protocol(iAmTransformableProtocol)])
	{
		NSObject <iAmTransformableProtocol>* transforableDelegate = delegateGraphic;

		[[_containerView viewController] removeZoomMatrixObserver:self];
		[transforableDelegate removeObserver:self forKeyPath:@"concatenatedMatrixNeedsRecalculating"];
		[transforableDelegate removeObserver:self forKeyPath:@"geometryRect"];
	}
	[super wasRemoved];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"RootSelectedLayer"] )
	{
        if( [keyPath isEqualToString:@"zoomMatrix"] )
        {
			_needsRealculating = YES;
			return;
		} else if( [keyPath isEqualToString:@"concatenatedMatrixNeedsRecalculating"] ) {
			_needsRealculating = YES;
			return;
		} else if( [keyPath isEqualToString:@"geometryRect"] ) {
			_needsRealculating = YES;
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

/* At the moment SelectedLayers need updating after graphics are updated. Why isn't it automatic? I guess it is an optimization in that i only want it to happen once after all changes to a graphic has been made */
- (void)enforceConsistentState {
	
	if(_needsRealculating)
		[self updateZoomIndependantGeom];
	
	[self.sublayers makeObjectsPerformSelector:@selector(enforceConsistentState)];
}

- (void)updateZoomIndependantGeom {

	id delegateGraphic = [self delegate];
	NSAssert(delegateGraphic, @"doh - no delegate on layer");
	
	if([delegateGraphic conformsToProtocol:@protocol(iAmGraphicNodeProtocol)])
	{
		NSObject <iAmGraphicNodeProtocol>* transforableDelegate = delegateGraphic;

		CGAffineTransform viewMatrix = [[_containerView viewController] zoomMatrix];
		CGAffineTransform obMatrix = [delegateGraphic concatenatedMatrix];
		
		// Dont know why this apparently wrong way round shit seems to work.
		CGAffineTransform resultXForm1 = CGAffineTransformConcat( obMatrix, viewMatrix );	
		
        [transforableDelegate enforceConsistentState];

		CGRect geom = [transforableDelegate geometryRect];
		CGPoint newPt = CGPointApplyAffineTransform( geom.origin, resultXForm1 );
		CGSize newSize = CGSizeApplyAffineTransform( geom.size, resultXForm1 );
		
		[self setFrame:CGRectMake(newPt.x, newPt.y, newSize.width, newSize.height)];
		[self setNeedsDisplay];
	}
	_needsRealculating = NO;
}


- (void)drawInContext:(CGContextRef)ctx {
	
	//june09    id delegateGraphic = [self delegate];
	//june09    NSAssert(delegateGraphic!=nil, @"layer must have a delegate, probably of type Graphic - not sure why");
	//june09   if([delegateGraphic isKindOfClass:[Graphic class]])
	//june09   {
	
	//	CGFloat xScale = 2.5f;
	//	CGFloat yScale = 2.0f;
	
	CGContextSaveGState(ctx);
	
	CGContextSetLineWidth( ctx, 1.0f );
	
	// try to match the scaled view
	//		CGAffineTransform viewXForm = CGAffineTransformMakeScale( 2.5f, 2.0f );
	//		CGAffineTransform viewPositionXForm = CGAffineTransformMakeTranslation( -30.0f, -80.0f );
	//		viewXForm = CGAffineTransformConcat( viewXForm, viewPositionXForm );
	//	
	//	
	//	CGAffineTransform currentCTM = CGContextGetCTM(ctx);
	//	CGAffineTransform newCTM = CGAffineTransformConcat( viewXForm, currentCTM );
	//	
	//	CGAffineTransform idX = CGAffineTransformIdentity;
	//	
	//	currentCTM.a = 1;
	//	currentCTM.b = 0;
	//	currentCTM.c = 0;
	//	currentCTM.d = 1;
	//    currentCTM.tx = 0;
	//	currentCTM.ty = 0;
	//	
	//	CGAffineTransform currentCTMIdCheck = CGContextGetCTM(ctx);
	//
	//		CGContextConcatCTM( ctx, newCTM );
	
	
	
	CGRect bounds = CGContextGetClipBoundingBox(ctx);
	
	CGContextBeginPath(ctx);
	CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextMoveToPoint(ctx, bounds.origin.x, bounds.origin.y);
	CGContextAddLineToPoint(ctx, bounds.origin.x+bounds.size.width, bounds.origin.y+bounds.size.height );
	CGContextAddLineToPoint(ctx, bounds.origin.x+bounds.size.width, bounds.origin.y );
	CGContextAddLineToPoint(ctx, bounds.origin.x, bounds.origin.y+bounds.size.height );
	CGContextDrawPath(ctx, kCGPathStroke);
	//june09    }
	
	CGContextRestoreGState( ctx );
	
}

@end
