//
//  BKCrashReporterController.h
//  Blocks
//
//  Created by Jesse Grosjean on 5/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKConfigurationProtocols.h"


@interface BKCrashReporterController : NSWindowController {
    IBOutlet NSTextField *titleTextField;
    IBOutlet NSTextField *subTitleTextField;
    IBOutlet NSTextField *emailTextField;
    IBOutlet NSTextField *statusMessageTextField;
    IBOutlet NSTextView *problemDescriptionTextView;
    IBOutlet NSTextView *crashLogTextView;
    IBOutlet NSButton *sendReportButton;
    IBOutlet NSProgressIndicator *statusProgressIndicator;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

- (NSURL *)crashReportURL;
- (NSString *)crashPath;
- (NSString *)exceptionPath;
- (void)setStatusMessage:(NSString *)message;

#pragma mark actions

- (IBAction)check:(id)sender;
- (IBAction)sendReport:(id)sender;
- (IBAction)ignore:(id)sender;

@end
