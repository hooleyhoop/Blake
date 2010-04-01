//
//  RotateTool.m
//  DebugDrawing
//
//  Created by steve hooley on 18/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "RotateTool.h"
#import "SceneUtilities.h"
#import "CALayerStarView.h"
#import "StarScene.h"
#import "AppControl.h"
#import "CustomMouseDragSelectionEventLoop.h"
#import "HitTestContext.h"
#import "ToolBarController.h"

enum {
	Zone_none = 0,
	Zone_rotateAroundZ_circle = 1,
	Zone_rotateAroundZ_handle = 2,
};


static CGFloat handleSize = 80;

/* 
 *
*/
@implementation RotateTool

@synthesize itemToRotate = _itemToRotate;

#pragma mark -
#pragma mark Class Methods


#pragma mark Init Methods
- (id)initWithToolBarController:(ToolBarController *)value
{
	self = [super initWithToolBarController:value];
	if ( self ) {
		_identifier = @"SKRotateTool";
		_labelString = @"Rotate";
		_iconPath = [[NSBundle bundleForClass:[self class ]] pathForImageResource:@"RotateToolIcn"];
	}
	return self;
}

#pragma mark Action Methods
- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
	// There must only be one selected object that is moveable
	// we must click on it or on the rotation handle
	if( _itemToRotate!=nil )
	{		
		// Has the user clicked on a graphic or on the rotation handle?
//june09		NSPoint mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
//june09		NSInteger clickedHandle = [self handleUnderPoint:mouseLocation];
		
//june09		-- do a debugDraw at clickPoint and see what we hit
	
		// Did we click on the rotation handle or the one selected graphic?
//june09		if( _itemToRotate || clickedHandle!=Zone_none )
//june09		{
			// Yes. Let the user move all of the selected objects.
//september09			[self rotateSelectedGraphicWithEvent:event inStarView:view];
			
//june09		} else {
			// No. Just swallow mouse events until the user lets go of the mouse button.
//june09			while ([event type]!=NSLeftMouseUp)
//june09			{
//june09				event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//june09			}
//june09		}
	}
}

#pragma mark Selection Changes
- (void)updateSelection {

//september09	CALayerStarView *view = _toolBarControl.targetView;

	/* There must be one and only one moveable object selected */
//september09	NSArray *rotatable = [SceneUtilities identifyTargetObjectsFromScene:[_toolBarControl sceneUndermanipulation]];
//september09	if([rotatable count]==1)
//september09	{
//september09		id selectedObject = [rotatable objectAtIndex:0];
//september09		/* has the item to rotate changed? */
//september09		if(_itemToRotate!=selectedObject)
//september09		{
//september09			NSAssert( selectedObject!=nil ? _itemToRotate==nil : _itemToRotate!=nil, @"doh");
//september09			if(_itemToRotate)
//september09			{
//september09				[_itemToRotate.originalNode removeObserver:self forKeyPath:@"transformMatrix"];
//september09				[_itemToRotate.originalNode removeObserver:self forKeyPath:@"geometryRect"];
//september09			}
			
//september09			if(selectedObject)
//september09			{
//september09				[((NodeProxy *)selectedObject).originalNode addObserver:self forKeyPath:@"transformMatrix" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context: @"RotateTool"];
//september09				[((NodeProxy *)selectedObject).originalNode addObserver:self forKeyPath:@"geometryRect" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context: @"RotateTool"];
//september09			}
//september09			self.itemToRotate = selectedObject;
//september09		}
//september09	}
}

/*	called after each graphic has been updated 
	Jeez we are doing this alot..
*/
- (void)_updateSelectedObjectBounds {
	
	/* There must be one and only one moveable object selected */
	if(_itemToRotate) 
	{
		[self setWidgetBounds: CGRectMake(0.0f, 0.0f, handleSize*1.0f, handleSize*3.0f/2.0f )];
        
	} else {
		[self setWidgetBounds: CGRectZero];
	}
	_sizeNeedsUpdating = NO;
}


- (void)_updatePosition {

	NSAssert( _xformDidChange, @"no");
	NSAssert( _itemToRotate, @"no");

	CGPoint anchorPt = [(Graphic *)_itemToRotate.originalNode position];
	CGFloat xpos = anchorPt.x;
	CGFloat ypos = anchorPt.y;
	
	/* Translate the anchor point to the origin */
	CGFloat anchorOffx = handleSize/2.f;
	CGFloat anchorOffy = handleSize/2.f;
	
	[_layerFamiliar setAnchorPt:CGPointMake( anchorOffx, anchorOffy )];
	[_layerFamiliar setPosition: CGPointMake( xpos, ypos )];
	[_layerFamiliar setRotation: [(Graphic *)_itemToRotate.originalNode rotation]];

	_xformDidChange = NO;
}

- (void)enforceConsistentState {
	
	if(_sizeNeedsUpdating) {
		[self _updateSelectedObjectBounds];
	}
	if(_xformDidChange){
		[self _updatePosition];
	}
	[super enforceConsistentState];
}

- (NSInteger)handleUnderPoint:(NSPoint)apoint {

//september09	HitTestContext *hitTestCntxt = nil;
//september09	CALayerStarView *view = _toolBarControl.targetView;
//september09	NSInteger handleUnderPt = Zone_none;
	
	/* Keep in mind that this calayer hitTesting won't work if we manipulate the layer in 3d */
//september09	unsigned char pixelColours[4];
	
	// draw everything
//september09	[_toolBarControl hitTestTool:self atPoint:apoint pixelColours:pixelColours];	
	
	
//june09	if(hitLayer)
//september09	{
//september09		handleUnderPt = Zone_rotateAroundZ_handle;
		
		// Hit test Handles

		
	
		// when we draw in the layer we are drawing relative to the origin of the layer - so we translate to origin there. We dont do that here so if we called - drawLayer:inContext: we would need to compensate with the opposite translation - best to have the actual drawing routisnes outside of drawLayer: so we can call them directly
//september09		[self drawZAxisCircleInContext:[hitTestCntxt offScreenCntx]];
//september09		[hitTestCntxt checkAndResetWithKey: @"ZAxisCircle"];
//september09		if([hitTestCntxt countOfHitObjects]>0)
//september09		{
//september09			handleUnderPt = Zone_rotateAroundZ_circle;
//september09			goto cleanUp;
//september09		}
		
//september09		[self drawZAxisHandleInContext:[hitTestCntxt offScreenCntx]];
//september09		[hitTestCntxt checkAndResetWithKey: @"ZAxisHandle"];
//september09		if([hitTestCntxt countOfHitObjects]>0)
//september09		{
//september09			handleUnderPt = Zone_rotateAroundZ_handle;
//september09			goto cleanUp;
//september09		}
		
//september09		cleanUp:
//september09		CGContextRestoreGState([hitTestCntxt offScreenCntx]);
//september09			[hitTestCntxt cleanUpHitTesting];
//september09	}

//september09	return handleUnderPt;
}

- (void)rotateSelectedGraphicWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
    
//september09	NSAssert(_itemToRotate!=nil, @"er - shouldn't get here");
	
//september09	CustomMouseDragSelectionEventLoop *eventLoop = [CustomMouseDragSelectionEventLoop eventLoopWithWindowview.window];
//september09	[self _marqueeSelectFromStartPoint:_mouseDownPt withEventLoop:eventLoop];
}

- (void)_marqueeSelectFromStartPoint:(NSPoint)originalMouseLocation withEventLoop:(CustomMouseDragSelectionEventLoop *)eventLoop {
	
//june09	[self _showMarquee];
	
	NSPoint lastPoint = originalMouseLocation;
	Graphic *graphicToRotate = (Graphic *)_itemToRotate.originalNode;
	CGFloat startRotation = [graphicToRotate rotation];
	CGPoint centrePoint = [graphicToRotate localPtToParentSpace:graphicToRotate.anchorPt];

	// angle between moude down and y-axis from centre point
//july09	yAxis = CGPointMake( centrePoint.x+0.0, centrePoint.y+1.0 )
	
//july09	CGFloat initialAngleFromYaxis2 = [RotateTool angleBetweenTwoPts:yAxis :originalMouseLocation centre:centrePoint];	

	// Dequeue and handle mouse events until the user lets go of the mouse button.	
	while( [eventLoop shouldLoop] ) 
	{
		NSPoint currentMouseLocation = [eventLoop mousePointInView];

//		CGFloat xDist = fabs(currentMouseLocation.x - lastPoint.x);
//		CGFloat yDist = fabs(currentMouseLocation.y - lastPoint.y);
//		
//		NSLog(@"xdist %f", xDist);
//june09		if( ( xDist>=2.0) || (yDist>=2.0) ) 
//june09		{
		if( NSEqualPoints( lastPoint, currentMouseLocation)==NO )
		{
//july09			centrePoint
//july09			initialAngleFromYaxis2
//july09			startRotation
//july09			[ItemRotationManipulation rotateItem:graphicToRotate byAngleBetweenPt: andPt:currentMouseLocation];
				
			[[[NSApplication sharedApplication] delegate] forceUpdateInHijackedEventLoop];
		}
		lastPoint = currentMouseLocation;
//june09		}		

	}
	
	
	// Schedule the drawing of the place where the rubber band isn't anymore.
//june09	[self _hideMarquee];
}

#pragma mark Notification Methods
/* quite posible all tools should handle selection changes */
- (IBAction)selectToolAction:(id)sender {

	[super selectToolAction:sender];

	[_toolBarControl addWidgetToView:self];

	// -- needs to observe selection	
	[[_toolBarControl sceneUndermanipulation] addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:(NSKeyValueObservingOptionInitial) context: @"RotateTool"];

	// -- cursor

	NSAssert([_toolBarControl activeTool]==self, @"This should set the active tool");
	
	[self enforceConsistentState];
}

- (void)toolWillBecomeUnActive {
	
	// -- remove observers
	[[_toolBarControl sceneUndermanipulation] removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];
	self.itemToRotate = nil;
	
	[_toolBarControl removeWidgetFromView:self];

	// -- cursor
	
	[super toolWillBecomeUnActive];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
    if( [context isEqualToString:@"RotateTool"] )
	{
        if ([keyPath isEqualToString:@"currentFilteredContentSelectionIndexes"])
        {
			[self updateSelection];
			return;
		
		}
		else if ([keyPath isEqualToString:@"transformMatrix"]){
			_xformDidChange = YES;
			return;
			
		} else if ([keyPath isEqualToString:@"geometryRect"]){
			_sizeNeedsUpdating = YES;
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

#pragma mark Widget Protocol

#pragma mark CALayer delegate methods
// draw Anchor rect for single selected graphic
- (void)drawAnchorInContext:(CGContextRef)ctx {
	
	//Graphic *graphicToRotate = (Graphic *)(_itemToRotate.originalNode);
	//NSAssert([graphicToRotate isKindOfClass:[Graphic class]], @"must be a graphic if we selected it, no?");
	//NSPoint centrePoint = [graphicToRotate localPtToParentSpace:graphicToRotate.anchorPt];
	CGContextBeginPath(ctx);
	CGContextAddRect(ctx, CGRectMake(handleSize/2.0f-2.5f, handleSize/2.0f-2.5f, 5.0f, 5.0f));
	
	//TODO: wrong colourspace
	CGContextSetRGBFillColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
	CGContextDrawPath(ctx, kCGPathFill);
}

- (void)drawZAxisCircleInContext:(CGContextRef)ctx {

	//Graphic *graphicToRotate = (Graphic *)(_itemToRotate.originalNode);
	//NSAssert([graphicToRotate isKindOfClass:[Graphic class]], @"must be a graphic if we selected it, no?");
	//NSPoint centrePoint = [graphicToRotate localPtToParentSpace:graphicToRotate.anchorPt];
	CGContextSetRGBStrokeColor(ctx, 0.0f, 1.0f, 0.0f, 1.0f);
	CGContextStrokeEllipseInRect( ctx, CGRectMake(0, 0, handleSize, handleSize) );
}

//!what the fuck? we dont draw at rotation - we rotate the layer!!*%^&$$@ layer needs to observe rotation or something. how do we hit test?
- (void)drawZAxisHandleInContext:(CGContextRef)ctx {
	
	// draw the stem straight up
	CGContextBeginPath(ctx);
	CGContextMoveToPoint(ctx, handleSize/2.0f, handleSize/2.0f);
	CGContextAddLineToPoint(ctx, handleSize/2.0f, handleSize/2.0f+handleSize);
	
	// draw an arrow head on the top
	CGContextAddLineToPoint(ctx, handleSize/2.0f+6, handleSize/2.0f+handleSize-6);
	CGContextAddLineToPoint(ctx, handleSize/2.0f-6, handleSize/2.0f+handleSize-6);
	CGContextAddLineToPoint(ctx, handleSize/2.0f, handleSize/2.0f+handleSize);

	CGContextSetRGBStrokeColor(ctx, 1.0f, 0.0f, 0.0f, 1.0f);
	CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	// here we are translating into layer coordinates - we need to take this amount off when we hittest
//	CGContextSaveGState(ctx);
//	CGContextTranslateCTM(ctx, -self.widgetOrigin.x, -self.widgetOrigin.y);
	
	// draw Anchor rect for single selected graphic
	[self drawAnchorInContext:ctx];

	// z-axis circle
	[self drawZAxisCircleInContext:ctx];

	// z-axis handle
	[self drawZAxisHandleInContext:ctx];

//	CGContextRestoreGState(ctx);
}

@end
