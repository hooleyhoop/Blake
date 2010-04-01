//
//  AppControl.h
//  DebugDrawing
//
//  Created by steve hooley on 14/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class CALayerStarView, Graphic, NodeProxy;
@class DomainContext, EditingWindowController, EditingWindow;

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface AppControl : _ROOT_OBJECT_ {
#else
@interface AppControl : _ROOT_OBJECT_ <NSApplicationDelegate> {
#endif

	IBOutlet NSArrayController	*arrayController;
	IBOutlet NSTableView		*layersView;
	IBOutlet NSPopUpButton		*zoomListButton;

	NSTimer						*screenRefreshTimer;
		
	/* CALayer Stuff */
	IBOutlet CALayerStarView	*layerStarView;

	/* New Domain Level */
	DomainContext				*_domainCntxt;
	EditingWindowController		*_editWindowController;
	IBOutlet EditingWindow		*_editingWindow;
	
	NSArray						*_viewTools;
}

@property (readwrite, assign) EditingWindow *editingWindow;
@property (readonly) DomainContext *domainCntxt;

- (void)forceUpdateInHijackedEventLoop;
- (void)graphDidUpdate;

#pragma mark Temp GUI stuff
- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)moveUp:(id)sender;
- (IBAction)moveDown:(id)sender;

- (IBAction)deleteSelected:(id)sender;

- (IBAction)homeView:(id)sender;
- (IBAction)setZoomToListValue:(id)sender;

@end
