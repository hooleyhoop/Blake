//
//  SketchExtension.h
//  BlakeLoader experimental
//
//  Created by steve hooley on 17/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <SHShared/SHSingletonViewExtensionProtocol.h>

@class SKTWindowController;
@class SHooleyObject, BlakeDocument;

/*
 * NB! We probably won't get a warning if we dont properly conform to the protocol! Bah!
*/
@interface SketchExtension : SHooleyObject <SHSingletonViewExtensionProtocol>  {

	SKTWindowController			*_sketchWindowController;
}

@property (assign, readonly, nonatomic) SKTWindowController *sketchWindowController;

#pragma mark -
#pragma mark class methods
+ (void)wipeSharedSketchExtension;

#pragma mark action methods
- (SKTWindowController *)makeWindowControllerForDocument:(NSDocument *)doc;
- (void)installWindowMenuItem;
- (void)showWindow;

#pragma mark debugging methods
- (id)debug_getDefaultDocument;
- (void)debug_setUpSketchModel:(BlakeDocument *)doc ;

@end
