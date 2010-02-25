//
//  BKSoftwareUpdatePreferencePaneExtension.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BKApplicationProtocols.h"
#import "BKPreferencesProtocols.h"


@interface BKSoftwareUpdatePreferencePaneExtension : NSObject <BKPreferencePaneProtocol> {
    IBOutlet NSView *view;
    IBOutlet NSTextField *messageTextField;
}

#pragma mark accessors

- (NSView *)view;

#pragma mark actions

- (IBAction)checkForUpdates:(id)sender;

@end
