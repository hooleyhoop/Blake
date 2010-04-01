//
//  BlakeNodeListView.m
//  BlakeLoader2
//
//  Created by steve hooley on 09/12/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "BlakeNodeListView.h"


@implementation BlakeNodeListView
#pragma mark -
#pragma mark SHDocumentViewExtensionProtocol
- (void)installViewMenuItem {
	// AXUIElementGetPid NSButton
}

- (void)showWindow:(id)sender {
	
}

- (NSString *)windowControllerClassName {
	return @"BlakeNodeListWindowController";
}

#pragma mark -
@end
