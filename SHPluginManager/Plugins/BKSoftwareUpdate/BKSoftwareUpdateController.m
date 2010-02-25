//
//  BKSoftwareUpdateController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/10/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKSoftwareUpdateController.h"
#import "BKConfigurationProtocols.h"


@interface BKSoftwareUpdateController (Private)
- (void)downloadNewVersion;
- (void)couldNotTellStatusAlert;
- (void)noUpdateAlert;
- (void)newVersionAlert;
- (void)beginDownloadPadFile;
@end

@implementation BKSoftwareUpdateController

#pragma mark class methods

+ (void)initialize {
	if (self == [BKSoftwareUpdateController class]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate distantPast], BKSoftwareUpdateLastUpdateKey, [NSNumber numberWithInt:BKCheckForUpdatesDaily], BKSoftwareUpdateFrequencyKey, nil];
		[defaults registerDefaults:defaultValues];
	}
}

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark init

- (id)init {
    if (self = [super initWithWindowNibName:@"BKSoftwareUpdateNewVersionWindow"]) {
        fIsManualCheck = YES;
    }
    return self;
}

#pragma mark awakeFromNib-like methods

- (void)windowDidLoad {
    [[self window] center];
	[[self window] makeKeyAndOrderFront:self];
	[[releaseNotesWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hogbaysoftware.com/files/releases/%@ReleaseNotes.html", [[NSProcessInfo processInfo] processName]]]]];
	[releaseNotesWebView setPolicyDelegate:self];
}

#pragma mark accessors

- (BKCheckForUpdatesFrequency)updateFrequency {
    return [[NSUserDefaults standardUserDefaults] integerForKey:BKSoftwareUpdateFrequencyKey];
}

- (void)setUpdateFrequency:(BKCheckForUpdatesFrequency)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:BKSoftwareUpdateFrequencyKey];
}

- (NSDate *)lastCheck {
    return [[NSUserDefaults standardUserDefaults] objectForKey:BKSoftwareUpdateLastUpdateKey];
}

- (NSDate *)nextCheck {
    NSDate *lastCheck = [self lastCheck];
    NSDate *now = [NSDate date];
    NSTimeInterval difference = [now timeIntervalSinceDate:lastCheck];
    
    logAssert(lastCheck != nil, @"last check not set");
    
    switch ([self updateFrequency]) {
        case BKCheckForUpdatesManually:
			return nil;
            
        case BKCheckForUpdatesDaily:
			return [NSDate date];
            
        case BKCheckForUpdatesWeekly:
			return [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24 * 7) - difference];
            
        case BKCheckForUpdatesMonthly:
			return [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24 * 30) - difference];
    }
    
    return nil;
}

- (NSURL *)padURL {
    NSMutableString *softwareUpdateURL = [NSMutableString stringWithString:[[NSApp delegate] applicationSoftwareUpdateURLString]];

    [softwareUpdateURL replaceOccurrencesOfString:@" " 
				       withString:@"&" 
					  options:NSLiteralSearch 
					    range:NSMakeRange(0, [softwareUpdateURL length])];
    
    return [NSURL URLWithString:softwareUpdateURL];
}

- (NSURL *)downloadURL {
    return [NSURL URLWithString:[[NSApp delegate] applicationDownloadURLString]];
}

#pragma mark actions

- (void)windowWillClose:(NSNotification *)notification {
}

- (IBAction)close:(id)sender {
	[[self window] orderOut:nil];
}

- (IBAction)visitDownloadPage:(id)sender {
	[[self window] orderOut:nil];
	[self downloadNewVersion];		
}

#pragma mark behaviors

- (void)checkForUpdates {
    logInfo((@"checking for updates"));
    fIsManualCheck = YES;
	[self beginDownloadPadFile];
}

- (void)checkForUpdateIfNeeded {
    fIsManualCheck = NO;
    switch ([self updateFrequency]) {
        case BKCheckForUpdatesManually:
            break;
            
        case BKCheckForUpdatesDaily:
			[self beginDownloadPadFile];
            break;
            
        case BKCheckForUpdatesWeekly:
        case BKCheckForUpdatesMonthly:
			if ([[self nextCheck] compare:[NSDate date]] == NSOrderedAscending) {
				[self beginDownloadPadFile];
			}
			break;
    }
}

- (void)downloadNewVersion {
    [[NSWorkspace sharedWorkspace] openURL:[self downloadURL]];
}

- (void)couldNotTellStatusAlert {
    NSRunInformationalAlertPanel(BKLocalizedString(@"Could Not Tell", nil),
				 BKLocalizedString(@"Sorry, could not determine the latest version. Could not connect or the Hog Bay Software web site is having a problem. Please try again later.", nil),
				 BKLocalizedString(@"OK", nil), nil, nil);
}

- (void)noUpdateAlert {
    NSRunInformationalAlertPanel(BKLocalizedString(@"No Update Available", nil),
				 BKLocalizedString(@"You already have the latest version.", nil),
				 BKLocalizedString(@"OK", nil), nil, nil);
}

- (void)newVersionAlert {
	[[self window] orderFront:self];
//    if (NSRunInformationalAlertPanel(BKLocalizedString(@"New Version", nil),
//				     BKLocalizedString(@"A new version is available. Would you like to visit the download page now?", nil),
//				     BKLocalizedString(@"Visit Download Page", nil),
//				     BKLocalizedString(@"Cancel", nil), nil) == NSOKButton) {
//      [self downloadNewVersion];		
//    }		
}

- (void)beginDownloadPadFile {
    [[self padURL] loadResourceDataNotifyingClient:self usingCache:NO];
}

#pragma mark url client methods

- (void)URLResourceDidFinishLoading:(NSURL *)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *thisVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSData *data = [sender resourceDataUsingCache:YES];
	NSString *temporaryFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"uk.co.stevehooley.BKSoftwareUpdate.downloadVersionFile"];
	
	[fileManager removeFileAtPath:temporaryFile handler:nil];
    [data writeToFile:temporaryFile atomically:NO];
	NSDictionary *webVersionPlist = [NSDictionary dictionaryWithContentsOfFile:temporaryFile];
    [fileManager removeFileAtPath:temporaryFile handler:nil];
    
    NSDecimalNumber *thisVersionNumber = [NSDecimalNumber decimalNumberWithString:thisVersion];
    NSDecimalNumber *currentVersionNumber = webVersionPlist ? [NSDecimalNumber decimalNumberWithString:[webVersionPlist objectForKey:@"CFBundleVersion"]] : nil;
    
    if (!webVersionPlist) {
		logDebug((@"failed to download pad file"));
        if (fIsManualCheck) {
			[self couldNotTellStatusAlert];
		}
    } else if ([thisVersionNumber floatValue] < [currentVersionNumber floatValue]) {
		logDebug((@"update availible"));
        [defaults setObject:[NSDate date] forKey:BKSoftwareUpdateLastUpdateKey];
		[self newVersionAlert];
    } else {
		logDebug((@"no update availible"));
        [defaults setObject:[NSDate date] forKey:BKSoftwareUpdateLastUpdateKey];
        if (fIsManualCheck) {
			[self noUpdateAlert];
		}
    }
}

- (void)URL:(NSURL *)sender resourceDidFailLoadingWithReason:(NSString *)reason {
    logDebug(([@"failed to download pad file" stringByAppendingString:reason]));
    
    if (fIsManualCheck) {
		[self couldNotTellStatusAlert];
    }
}

#pragma mark WebView WebPolicyDelegate informal protocol

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
	[listener ignore];
	[[NSWorkspace sharedWorkspace] openURL:[request URL]];
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
	[listener ignore];
	[[NSWorkspace sharedWorkspace] openURL:[request URL]];
}

@end

#pragma mark defaults keys

NSString* BKSoftwareUpdateLastUpdateKey = @"BKSoftwareUpdateLastUpdateKey";
NSString* BKSoftwareUpdateFrequencyKey = @"BKSoftwareUpdateFrequencyKey";