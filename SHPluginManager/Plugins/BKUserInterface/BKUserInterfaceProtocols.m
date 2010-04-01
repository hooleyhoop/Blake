//
//  BKUserInterfaceProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKUserInterfaceProtocols.h"
#import "BKMenuController.h"
#import "BKToolbarController.h"
#import "BKUserInterfaceController.h"


@implementation NSObject (BKUserInterfaceControllerFactory)

+ (id <BKMenuControllerProtocol>)BKUserInterface_createMenuController:(NSMenu *)menu view:(NSView *)view event:(NSEvent *)event extensionPoint:(NSString *)extensionPoint {
	return [[[BKMenuController alloc] initWithMenu:menu view:view event:event extensionPoint:extensionPoint] autorelease];
}

+ (id <BKToolbarControllerProtocol>)BKUserInterface_createToolbarController:(NSWindow *)window toolbar:(NSToolbar *)toolbar extensionPoint:(NSString *)extensionPoint {
	return [[[BKToolbarController alloc] initWithWindow:window toolbar:toolbar extensionPoint:extensionPoint] autorelease];
}

@end

@implementation NSApplication (BKUserInterfaceControllerProtocolAccess)

- (id <BKUserInterfaceControllerProtocol>)BKUserInterfaceProtocols_userInterfaceController {
	return [BKUserInterfaceController sharedInstance];
}

@end