//
//  BKStatusMessageController.m
//  Blocks
//
//  Created by Jesse Grosjean on 10/29/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKStatusMessageController.h"


@implementation BKStatusMessageController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark init methods

- (id)init {
    if (self = [super initWithWindowNibName:@"BKStatusMessage"]) {
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
	[super dealloc];
}

#pragma mark awake from nib like methods

- (void)awakeFromNib {
	[icon setImage:[NSApp applicationIconImage]];
	[progressIndicator setUsesThreadedAnimation:YES];
}

#pragma mark status messages

- (void)beginStatusMessage:(NSString *)newMessageText informativeText:(NSString *)newInformativeText {
	statusMessageCount++;
	
	if (statusMessageCount == 1) {
		[[self window] center];
		[[self window] setTitle:[[NSProcessInfo processInfo] processName]];
		[[self window] setLevel:NSFloatingWindowLevel];
		[progressIndicator setIndeterminate:YES];
		[progressIndicator setDoubleValue:100];
		[progressIndicator startAnimation:nil];
		[self showWindow:nil];
		[[self window] makeKeyWindow];
		[[self window] displayIfNeeded];
	}
	
	[messageText setObjectValue:newMessageText];
	[informativeText setObjectValue:newInformativeText];
	[self updateDisplay];
}

- (void)updateMessageText:(NSString *)newMessageText {
	[messageText setObjectValue:newMessageText];
	[self updateDisplay];
}

- (void)updatePercentComplete:(double)newPercentComplete {
	if (newPercentComplete < 0) {
		[progressIndicator setIndeterminate:YES];
		[progressIndicator setDoubleValue:100];
	} else {
		[progressIndicator setIndeterminate:NO];
		[progressIndicator setDoubleValue:newPercentComplete];
	}
	[self updateDisplay];
}

- (void)updateInformativeText:(NSString *)newInformativeText {
	[informativeText setObjectValue:newInformativeText];
	[self updateDisplay];
}

- (void)endStatusMessage {
	statusMessageCount--;
	
	if (statusMessageCount == 0) {
		[[self window] orderOut:nil];
		[messageText setObjectValue:nil];
		[informativeText setObjectValue:nil];
		[progressIndicator stopAnimation:nil];
		[progressIndicator setDoubleValue:0];
	}
}

- (void)updateDisplay {
	[informativeText displayIfNeeded];
	[progressIndicator displayIfNeeded];
	[messageText displayIfNeeded];
}

@end
