/*
 *  SHAppProtocol.h
 *  SHShared
 *
 *  Created by steve hooley on 12/02/2008.
 *  Copyright 2008 HooleyHoop. All rights reserved.
 *
 */

@protocol SHAppProtocol <NSObject>

//- (NSDocument *)currentDocument;
//- (void)setCurrentDocument:(NSDocument *)value;
//- (NSWindowController *)currentDocumentWindowController;
//- (void)setCurrentDocumentWindowController:(NSWindowController *)value;
//- (NSWindow *)currentDocumentWindow;
//- (void)setCurrentDocumentWindow:(NSWindow *)value;

@required
- (void)setAboutPanelClass:(Class)aClass;

@end
