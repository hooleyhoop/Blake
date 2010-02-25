//
//  BKStatusMessageController.h
//  Blocks
//
//  Created by Jesse Grosjean on 10/29/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKStatusMessageProtocols.h"


@interface BKStatusMessageController : NSWindowController <BKStatusMessageControllerProtocol> {
	IBOutlet NSImageView *icon;
	IBOutlet NSTextField *messageText;
	IBOutlet NSProgressIndicator *progressIndicator;
	IBOutlet NSTextField *informativeText;
	
	int statusMessageCount;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark status messages

- (void)beginStatusMessage:(NSString *)newMessageText informativeText:(NSString *)newInformativeText;
- (void)updateMessageText:(NSString *)newMessageText;
- (void)updatePercentComplete:(double)newPercentComplete;
- (void)updateInformativeText:(NSString *)newInformativeText;
- (void)endStatusMessage;
- (void)updateDisplay;

@end
