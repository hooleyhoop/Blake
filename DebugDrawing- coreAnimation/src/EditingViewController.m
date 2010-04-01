//
//  EditingViewController.m
//  DebugDrawing
//
//  Created by shooley on 13/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "EditingViewController.h"
#import "CALayerStarView.h"
#import "LayerCreation.h"
#import "LayerTreeManipulation.h"
#import "SelectedLayerContainer.h"
#import "NodeContainerLayer.h"
#import "ToolLayerContainer.h"
#import "ContentLayerManager.h"
#import "SceneDisplay.h"
#import "WidgetDisplay.h"
#import "DomainContext.h"
#import "ToolBarController.h"
#import "StarScene.h"
#import "ZoomController.h"

/*
 *
*/
@implementation EditingViewController

@synthesize sceneRenderer=_sceneRenderer;
@synthesize inputController = _inputController;

- (id)init {

	self = [super init];
	if(self){
		_contentZoomController = [[ZoomController alloc] init];
	}
	return self;
}

- (void)dealloc {
	
	// Important - this will dismantle the layer tree
	_sceneRenderer.targetView = nil;
	_sceneRenderer.starScene = nil;
	
	_widgetRenderer.targetView = nil;
	
	[_sceneRenderer release];
	[_widgetRenderer release];

	[_contentZoomController release];

	[_domainContext release];

	[super dealloc];
}

- (void)setupWithDomainContext:(DomainContext *)cntx {

	NSParameterAssert( cntx );
	NSAssert(_domainContext==nil, @"doh");
	NSAssert(self.view, @"need a view");

	_domainContext = [cntx retain];

	/* Setup CALayerView */
	[(CALayerStarView *)self.view setupCALayerStuff];

	ContentLayerManager *contentLayerManager = [[[ContentLayerManager alloc] initWithContainerLayerClass:[NodeContainerLayer class] name:@"content" parentLayer:(id)self.view.layer] autorelease];

	/* The selection layers and the tool layers cannot appear 'zoomed' so we cant use this matrix */
	ContentLayerManager *selectedContentManager = [[[ContentLayerManager alloc] initWithContainerLayerClass:[SelectedLayerContainer class] name:@"Selected Items" parentLayer:(id)self.view.layer] autorelease];
	ContentLayerManager *toolLayerManager = [[[ContentLayerManager alloc] initWithContainerLayerClass:[ToolLayerContainer class] name:@"tools" parentLayer:(id)self.view.layer] autorelease];
	LayerCreation *defaultLayerCreator = [[[LayerCreation alloc] init] autorelease];
	LayerTreeManipulation *layerTreeHelper = [[[LayerTreeManipulation alloc] initWithLayerCreator:defaultLayerCreator starView:(CALayerStarView *)self.view] autorelease];

	// scene rendrer observes the scene
	_sceneRenderer = [[SceneDisplay alloc] initWithContentLayerManager:contentLayerManager selectedContentLayerManager:selectedContentManager layerTreeManipulator:layerTreeHelper];
	[_sceneRenderer setStarScene: [cntx starScene]];

	_widgetRenderer = [[WidgetDisplay alloc] initWithContentLayerManager:toolLayerManager layerCreator:defaultLayerCreator];
	
	// handle zoom
	
	[_contentZoomController addObserver:self forKeyPath:@"zoomMatrix" options:0 context: @"EditingViewController"];
	[self viewDidResize];
}

- (void)unSetupWithDomainContext:(DomainContext *)cntx {

	[_contentZoomController removeObserver:self forKeyPath:@"zoomMatrix"];
}

- (void)graphDidUpdate {
	
	// bit hacky for now..
	[_sceneRenderer graphDidUpdate];
	[_widgetRenderer graphDidUpdate];
}

- (void)observeZoomMatrix:(id)observer withContext:(void *)context {
	
	NSParameterAssert(observer);
	NSParameterAssert(context);
	NSAssert(_contentZoomController, @"_contentZoomController not ready");

	[_contentZoomController addObserver:observer forKeyPath:@"zoomMatrix" options:0 context:context];
}

- (void)removeZoomMatrixObserver:(NSObject *)observer {
	
	NSParameterAssert(observer);
	NSAssert(_contentZoomController, @"_contentZoomController not ready");

	[_contentZoomController removeObserver:observer forKeyPath:@"zoomMatrix"];
}

- (void)observeZoomValue:(id)observer withContext:(void *)context {
	
	NSParameterAssert(observer);
	NSParameterAssert(context);
	NSAssert(_contentZoomController, @"_contentZoomController not ready");

	[_contentZoomController addObserver:observer forKeyPath:@"zoomValue" options:0 context:context];
}

- (void)removeZoomValueObserver:(NSObject *)observer {
	
	NSParameterAssert(observer);
	NSAssert(_contentZoomController, @"_contentZoomController not ready");

	[_contentZoomController removeObserver:observer forKeyPath:@"zoomValue"];
}



- (void)viewDidResize {
	
	NSRect viewFrame = self.view.frame;
	CGFloat midX = NSMidX(viewFrame);
	CGFloat midY = NSMidY(viewFrame);
	[_contentZoomController setCentrePt:CGPointMake(midX, midY)];
}

- (void)loadView {
	/* we have to manually set the view due to sowme fuckup */
}

#pragma mark notifications
//TODO: This seems unnecasary now
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"EditingViewController"] )
	{
        if ([keyPath isEqualToString:@"zoomMatrix"])
        {
			CGAffineTransform transformMatrix = [self zoomMatrix];
			CALayer *contentLayer = [_sceneRenderer.contentLayerManager containerLayer_temporary];
			
			// NB: we dont want to move the content layer around - it fills the view
			[contentLayer setAffineTransform: transformMatrix];
			
			// We just want to draw the child layers at an offset
			//[contentLayer setSublayerTransform:CATransform3DMakeAffineTransform(transformMatrix)];

			//[contentLayer setNeedsDisplay];
			return;
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

#pragma mark accessors
- (void)viewBecameFirstResponder {	

	[_inputController applyKeysDown];
}

- (void)viewResignedFirstResponder {

	[_inputController unApplyKeysDown];
}

/*
 * Yah, like.. move this somewhere the fduck else
*/
- (void)flagsChanged:(NSEvent *)event {
	
	NSUInteger flags = [event modifierFlags];
	unsigned short keyCode = [event keyCode];

	// CAPS-LOCK
    if( keyCode==0x39 )
    {
//        if (flags & NSAlphaShiftKeyMask)
//            NSLog(@"capsLock on");
//        else
//            NSLog(@"capsLock off");
		
	// left SHIFT
    } else if( keyCode==0x38 ) 
	{
        if (flags & NSShiftKeyMask)
            [_inputController shift:YES];
        else
            [_inputController shift:NO];
		
	// left ALT
	} else if( keyCode==0x3A )
	{
        if (flags & NSAlternateKeyMask)
            [_inputController alt:YES];
        else
            [_inputController alt:NO];
	}
	
//	0x33 // delete
//	0x37 // command
//	0x31 // space
//	0x24 // return
//	0x30 // tab
//	0x3A // option
//	0x3B // control
//	0x3C// right shift
//	kVK_RightOption              = 0x3D,
//	kVK_RightControl             = 0x3E,

	[super flagsChanged:event];
}

- (void)mouseDown:(NSEvent *)event {
	
	// forward mouse events to the current tool
	[_inputController _mouseDownEvent:event inStarView:(CALayerStarView *)self.view];	
}

- (void)addWidget:(NSObject<Widget_protocol> *)value {

	NSParameterAssert(value);
	[_widgetRenderer addWidget:value];
}

- (void)removeWidget:(NSObject<Widget_protocol> *)value {

	NSParameterAssert(value);
	[_widgetRenderer removeWidget:value];
}

- (void)setInputController:(ToolBarController *)value {

	NSParameterAssert(value);
	_inputController = value;
}

- (NSPoint)eventPtToViewPoint:(NSPoint)pt {
	
	NSAssert(self.view, @"need a view to convert pt value");

	NSPoint viewPt = [self.view convertPoint:pt fromView:nil];
	viewPt = [self.view convertPointToBase:viewPt];
	return viewPt;
}

- (CGPoint)eventPointToContentPoint:(NSPoint)pt {
	
	NSPoint viewPt = [self eventPtToViewPoint:pt];
//	NodeContainerLayer *containerLayer = (NodeContainerLayer *)[[_sceneRenderer contentLayerManager] containerLayer_temporary];
//	NSAssert(containerLayer, @"need a containerLayer to convert pt value");
//	CGPoint contentLayer_point = [containerLayer.superlayer convertPoint:NSPointToCGPoint(viewPt) toLayer:containerLayer];	
	CGPoint altPt = [_contentZoomController inversePt:viewPt];
	return altPt;
}

- (CGPoint)viewPointToScenePoint:(NSPoint)pt {
	
	CGPoint altPt = [_contentZoomController inversePt:pt];
	return altPt;
}

- (CGAffineTransform)zoomMatrix {
	return _contentZoomController.zoomMatrix;
}

- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal {
	[_contentZoomController panByX:xVal y:yVal];
}

- (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2 {
	
	// -- amount needs to be away from or toward cenre point
//	CGFloat scaleAmountToIncrease = (pt2.x-midX)/(pt1.x-midX);
	CGFloat scaleAmountToIncrease = pt2.x/pt1.x;
	[_contentZoomController zoomByX:scaleAmountToIncrease y:0];
}

- (void)setZoomValue:(CGFloat)value {
	[_contentZoomController setZoomValue:value];
}

- (void)resetZoomSettings {
	[_contentZoomController resetZoomSettings];
}

- (DomainContext *)domainContext {
	
	NSAssert(_domainContext, @"have we been setup yet?");
	return _domainContext;
}

- (void)fitAll {

	NSRect allBounds = [_domainContext allCurrentBounds];
	
//	-- calculate zoom
//	-- calculate offset
//	-- set values
}

@end
