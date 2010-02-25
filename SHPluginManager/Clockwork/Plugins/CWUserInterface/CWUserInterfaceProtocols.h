//
//  CWUserInterfaceProtocols.h
//  Clockwork
//
//  Created by Jesse Grosjean on 5/18/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CWUserInterfaceControllerProtocol <NSObject>

- (NSWindow *)timersWindow;
- (NSWindow *)miniWindow;
- (NSWindow *)fullScreenWindow;
- (int)applicationIconTimeNumber;

@end

#define CWUserInterfaceApplicationIconWillChangeNotification @"CWUserInterfaceApplicationIconWillChangeNotification"
#define CWUserInterfaceApplicationIconDidChangeNotification @"CWUserInterfaceApplicationIconDidChangeNotification"

@interface NSApplication (CWUserInterfaceApplicationAdditions)

- (id <CWUserInterfaceControllerProtocol>)userInterfaceController;

@end