//
//  BKUserInterfaceController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BKUserInterfaceProtocols.h"


@interface BKUserInterfaceController : NSObject <BKUserInterfaceControllerProtocol> {
    id <BKMenuControllerProtocol> fMainMenuController;
    id <BKMenuControllerProtocol> fDockMenuController;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

- (id <BKMenuControllerProtocol>)mainMenuController;
- (id <BKMenuControllerProtocol>)dockMenuController;

#pragma mark extensions

- (void)initMainMenuExtension:(NSMenu *)menu;
- (void)initDockMenuExtension:(NSMenu *)menu;
    
@end