//
//  SHRootNodeListTableView.h
//  Pharm
//
//  Created by Steve Hooley on 30/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//
#import <SHSharedUI/SHTableView.h>

@class BlakeNodeListWindowController;

/*
 * NSTableView
 */
@interface SHRootNodeListTableView : SHTableView {

	BlakeNodeListWindowController			*_controller;
	NSMutableString							*mStringToFind;
	NSDate									*_lastClickTime;
}

@property (readwrite, assign, nonatomic) IBOutlet BlakeNodeListWindowController *controller;
@property (readwrite, retain, nonatomic) NSDate *lastClickTime;

#pragma mark -
#pragma mark action methods
- (BOOL)backSpacePressed;

#pragma mark accessor methods
- (NSArrayController *)arrayController;

@end
