//
//  BlakeGlobalCommandController.h
//  Pharm
//
//  Created by Steve Hooley on 15/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

@class SHNodeGraphModel;
@class BlakeDocumentController;

/*
 * The application Delegate
 * NB. As the app delegate we are automatically in the responder chain ONLY for action events
 * The default chain is.

 The main window’s first responder and the successive responder objects up the view hierarchy
 The main window
 The main window’s delegate.
 The window's NSWindowController
 The NSDocument
 NSApp
 NSApp's delegate
 The DocumentController
 
*/
#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface BlakeGlobalCommandController : _ROOT_OBJECT_ {
#else
@interface BlakeGlobalCommandController : _ROOT_OBJECT_ <NSApplicationDelegate> {
#endif

	NSWindowController			*_graphicsInspectorController;
	BlakeDocumentController		*_documentController;
	NSApplication				*_sharedApp;
}

#pragma mark -
#pragma mark class methods
+ (BlakeGlobalCommandController *)sharedGlobalCommandController;
+ (void)cleanUpSharedGlobalCommandController;

@end


