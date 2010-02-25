//
//  BlakeNodeListWindowController.h
//  Pharm
//
//  Created by Steve Hooley on 16/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <SHShared/SHWindowController.h>

@class FilteringArrayController;
@class BlakeNodeListViewController, BlakeDocument;

/*
 * The window controller is responsible for freeing all top-level objects in the nib file it loads.
 * For documents with multiple windows or panels, your document must create separate instances of NSWindowController (or of custom subclasses of NSWindowController), one for each window or panel
*/
@interface BlakeNodeListWindowController : SHWindowController {

	IBOutlet BlakeNodeListViewController	*viewController;
	IBOutlet FilteringArrayController		*filteringArrayController;
	IBOutlet NSWindow						*duplicateWindowReferenceForDebugging;
	BlakeDocument							*duplicateDocReferenceForDebugging;
}

#pragma mark -
#pragma mark class methods

#pragma mark init methods
- (void)initBindings;
- (void)unBind;

#pragma mark action methods
- (BOOL)backSpacePressed;

#pragma mark accessor methods

// Unarchived connections From Nib
@property(assign, readwrite, nonatomic) FilteringArrayController	*filteringArrayController;
@property(assign, readwrite, nonatomic) BlakeNodeListViewController	*viewController;
@property(assign, readwrite, nonatomic) NSWindow					*duplicateWindowReferenceForDebugging;
@property(assign, readwrite, nonatomic) BlakeDocument				*duplicateDocReferenceForDebugging;

@end
