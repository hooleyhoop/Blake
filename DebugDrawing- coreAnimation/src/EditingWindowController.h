//
//  EditingWindowController.h
//  DebugDrawing
//
//  Created by shooley on 13/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

@class EditingViewController, CALayerStarView, ToolBarController, DomainContext;
@class ZoomPopupController;

@interface EditingWindowController : SHWindowController {

	ToolBarController		*_toolBarController;
	EditingViewController	*_editingViewController;
	CALayerStarView			*_editingView;
	
	ZoomPopupController		*_zoomPopupCntrlr;
}

@property (assign) CALayerStarView *editingView;
@property (readonly, assign) ToolBarController *toolBarController;
@property (readonly) EditingViewController *editingViewController;

- (void)addToolBar;
- (void)addToolsToToolBar:(NSArray *)someTools;

- (void)setDomainContext:(DomainContext *)cntx;
- (DomainContext *)domainContext;

// window controls
- (void)doZoomPopUp:(NSPopUpButton *)value;
- (IBAction)homeView:(id)sender;
- (IBAction)setZoomToListValue:(id)sender;

@end
