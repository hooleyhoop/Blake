//
//  EditingViewController.h
//  DebugDrawing
//
//  Created by shooley on 13/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

@class SceneDisplay, WidgetDisplay, DomainContext, ToolBarController, ZoomController, DomainContext;
@protocol Widget_protocol;


@interface EditingViewController : NSViewController {

	ToolBarController						*_inputController;

	SceneDisplay							*_sceneRenderer;
	WidgetDisplay							*_widgetRenderer;
	
	ZoomController							*_contentZoomController;
	DomainContext							*_domainContext;
}

@property (readonly) SceneDisplay *sceneRenderer;
@property (readwrite, assign) ToolBarController *inputController;

//TODO: replace with view did load or something when in document
- (void)setupWithDomainContext:(DomainContext *)cntx;
- (void)unSetupWithDomainContext:(DomainContext *)cntx;

- (void)addWidget:(NSObject<Widget_protocol> *)value;
- (void)removeWidget:(NSObject<Widget_protocol> *)value;

- (void)graphDidUpdate;

- (void)viewBecameFirstResponder;
- (void)viewResignedFirstResponder;

// given a pt from an NSEvent in this view translate and scale it by current offsets
- (NSPoint)eventPtToViewPoint:(NSPoint)pt;
- (CGPoint)eventPointToContentPoint:(NSPoint)pt;
- (CGPoint)viewPointToScenePoint:(NSPoint)pt;

- (CGAffineTransform)zoomMatrix;
- (void)panByX:(CGFloat)xVal y:(CGFloat)yVal;
- (void)zoomFrom:(NSPoint)pt1 to:(NSPoint)pt2;

- (void)observeZoomMatrix:(id)observer withContext:(void *)context;
- (void)removeZoomMatrixObserver:(NSObject *)observer;

- (void)observeZoomValue:(id)observer withContext:(void *)context;
- (void)removeZoomValueObserver:(NSObject *)observer;

- (void)viewDidResize;

- (DomainContext *)domainContext;

- (void)resetZoomSettings;
- (void)setZoomValue:(CGFloat)value;

- (void)fitAll;

@end
