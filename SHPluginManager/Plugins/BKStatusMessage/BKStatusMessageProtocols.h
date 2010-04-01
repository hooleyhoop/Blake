//
//  BKStatusMessageProtocols.h
//  Blocks
//
//  Created by Jesse Grosjean on 10/29/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol BKStatusMessageControllerProtocol <NSObject>

- (void)beginStatusMessage:(NSString *)newMessageText informativeText:(NSString *)newInformativeText;
- (void)updateMessageText:(NSString *)newMessageText;
- (void)updatePercentComplete:(double)newPercentComplete;
- (void)updateInformativeText:(NSString *)newInformativeText;
- (void)endStatusMessage;

@end

@interface NSApplication (BKStatusMessageControllerProtocolAccess)
- (id <BKStatusMessageControllerProtocol>)BKStatusMessageProtocols_statusMessageController; // exposed this way for applescript support
@end