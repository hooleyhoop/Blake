//
//  BKConfigurationProtocols.h
//  Blocks
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum {
    BKConfigurationLoggingOff = 99,
    BKConfigurationLoggingFatal = 50,
    BKConfigurationLoggingError = 40,
    BKConfigurationLoggingWarn = 30,
    BKConfigurationLoggingInfo = 20,
    BKConfigurationLoggingDebug = 10,
    BKConfigurationLoggingAll = 0,
} BKConfigurationLoggingLevel;

@protocol BKConfigurationControllerProtocol <NSObject>

- (BKConfigurationLoggingLevel)loggingLevel;
- (void)setLoggingLevel:(BKConfigurationLoggingLevel)level;
- (NSDate *)lastRunDate;
- (NSNumber *)lastRunVersion;
- (NSNumber *)currentRunVersion;
- (IBAction)showUserGuide:(id)sender;
- (IBAction)visitWebPage:(id)sender;
- (IBAction)visitUserForums:(id)sender;
- (IBAction)recoverLostLicense:(id)sender;
- (IBAction)showReleaseNotes:(id)sender;
- (IBAction)pluginsAndScripts:(id)sender;
- (IBAction)requestNewFeatureOrReportBug:(id)sender;

@end

@protocol BKConfigurationDelegateProtocol <NSObject>

- (NSData *)applicationPublicKey;
- (NSString *)applicationLicenseName;
- (NSString *)applicationUserGuideURLString;
- (NSString *)applicationWebPageURLString;
- (NSString *)applicationUserForumsURLString;
- (NSString *)applicationRecoverLostLicenseURLString;
- (NSString *)applicationPluginsAndScriptsURLString;
- (NSString *)applicationReleaseNotesURLString;
- (NSString *)applicationRequestsAndBugsURLString;
- (NSString *)applicationDownloadURLString;
- (NSString *)applicationSoftwareUpdateURLString;
- (NSString *)applicationCrashReportURLString;
- (NSString *)applicationUpgradeDonationURLString;
- (NSString *)applicationBuyNowURLString;

@end

@interface NSApplication (BKConfigurationControllerProtocolAccess)
- (id <BKConfigurationControllerProtocol>)BKConfigurationProtocols_configurationController; // exposed this way for applescript support
@end
