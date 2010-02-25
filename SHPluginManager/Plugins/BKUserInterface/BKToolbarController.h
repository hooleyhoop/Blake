//
//  BKToolbarController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKUserInterfaceProtocols.h"


@interface BKToolbarController : NSObject <BKToolbarControllerProtocol> {
	NSWindow *fWindow;
    NSToolbar *fToolbar;
    NSString *fExtensionPoint;
	NSMutableArray *fAllowedItemIdentifiers;
	NSMutableArray *fDefaultItemIdentifiers;
	NSMutableArray *fSelectableItemIdentifiers;
}

#pragma mark init

- (id)initWithWindow:(NSWindow *)window toolbar:(NSToolbar *)toolbar extensionPoint:(NSString *)extensionPoint;

#pragma mark accessors

- (NSWindow *)window;
- (NSToolbar *)toolbar;
- (NSString *)extensionPoint;
- (NSString *)allToolbarsExtensionPoint;

#pragma mark managing extensions

- (void)declareAllowedToolbarItemIdentifier:(NSString *)itemIdentifier selectable:(BOOL)selectable;
- (void)declareDefaultToolbarItemIdentifier:(NSString *)itemIdentifier insertPath:(NSString *)path;
- (void)declareDefaultGroupItemIdentifier:(NSString *)itemIdentifier groupPath:(NSString *)path;
- (void)loadToolbarContributers;

@end
