//
//  BKSoftwareUpdatePreferencePaneExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKSoftwareUpdatePreferencePaneExtension.h"
#import "BKSoftwareUpdateController.h"


@implementation BKSoftwareUpdatePreferencePaneExtension

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark awakeFromNib-like methods

- (void)awakeFromNib {
    NSString *customMessage = [NSString stringWithFormat:[messageTextField stringValue], [[NSProcessInfo processInfo] processName]];
    [messageTextField setStringValue:customMessage];
}

#pragma mark accessors

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKSoftwareUpdatePreferencePane" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
    }
    return view;
}

#pragma mark actions

- (IBAction)checkForUpdates:(id)sender {
    [[BKSoftwareUpdateController sharedInstance] checkForUpdates];
}

#pragma mark preference pane data source

- (NSString *)preferencePaneIdentifier {
	return @"BKSoftwareUpdatePreferencePane";
}

- (NSString *)preferencePaneTitle {
    return BKLocalizedString(@"Software Update", nil);    
}

- (NSString *)preferencePaneLabel {
    return BKLocalizedString(@"Software Update", nil);
}

- (NSView *)preferencePaneView {
	return [self view];
}

- (void)willDisplayPreferencePane {
}

- (NSString *)preferencePaneTooltip {
    NSString *tooltipFormat = BKLocalizedString(@"Open %@ Preference Pane", nil);
    return [NSString stringWithFormat:tooltipFormat, [self preferencePaneTitle]];
}

- (NSImage *)preferencePaneImage {
    NSImage *preferencePaneImage = [NSImage imageNamed:[self preferencePaneIdentifier] class:[self class]];
    logAssert(preferencePaneImage != nil, @"nil preference pane image");
    return preferencePaneImage;
}

- (float)preferencePaneOrderWeight {
	return 0;
}

@end
