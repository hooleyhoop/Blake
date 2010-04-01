//
//  BKConfigurationController.h
//  Blocks
//
//  Created by Jesse Grosjean on 2/3/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKFoundationProtocols.h"
#import "BKConfigurationProtocols.h"


@interface BKConfigurationController : NSObject <BKConfigurationControllerProtocol> {

}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

//- (BKConfigurationLoggingLevel)loggingLevel;
//- (void)setLoggingLevel:(BKConfigurationLoggingLevel)level;
- (NSDate *)lastRunDate;
- (NSNumber *)lastRunVersion;
- (NSNumber *)currentRunVersion;

#pragma mark actions

- (IBAction)showUserGuide:(id)sender;
- (IBAction)visitWebPage:(id)sender;
- (IBAction)visitUserForums:(id)sender;
- (IBAction)recoverLostLicense:(id)sender;
- (IBAction)pluginsAndScripts:(id)sender;
- (IBAction)showReleaseNotes:(id)sender;
- (IBAction)requestNewFeatureOrReportBug:(id)sender;

@end

APPKIT_EXTERN NSString *BKConfigurationLoggingLevelKey;
APPKIT_EXTERN NSString *BKConfigurationLastRunDateKey;
APPKIT_EXTERN NSString *BKConfigurationLastRunVersionKey;