//
//  BKSoftwareUpdateController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/10/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Blocks/Blocks.h>
#import "BKSoftwareUpdateProtocols.h"


@interface BKSoftwareUpdateController : NSWindowController <BKSoftwareUpdateControllerProtocol> {
	IBOutlet WebView *releaseNotesWebView;

    BOOL fIsManualCheck;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

- (BKCheckForUpdatesFrequency)updateFrequency;
- (void)setUpdateFrequency:(BKCheckForUpdatesFrequency)type;
- (NSDate *)lastCheck;
- (NSDate *)nextCheck;

#pragma mark actions

- (IBAction)close:(id)sender;
- (IBAction)visitDownloadPage:(id)sender;
	
#pragma mark behaviors

- (void)checkForUpdates;
- (void)checkForUpdateIfNeeded;

@end

#pragma mark defaults keys

APPKIT_EXTERN NSString *BKSoftwareUpdateLastUpdateKey;
APPKIT_EXTERN NSString *BKSoftwareUpdateFrequencyKey;