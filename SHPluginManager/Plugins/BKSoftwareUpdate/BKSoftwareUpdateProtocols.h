//
//  BKSoftwareUpdateProtocols.h
//  Blocks
//
//  Created by Jesse Grosjean on 2/3/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//


typedef enum {
    BKCheckForUpdatesManually = 1,
    BKCheckForUpdatesDaily = 2,
    BKCheckForUpdatesWeekly = 3,
    BKCheckForUpdatesMonthly = 4,
} BKCheckForUpdatesFrequency;

@protocol BKSoftwareUpdateControllerProtocol <NSObject>

- (BKCheckForUpdatesFrequency)updateFrequency;
- (void)setUpdateFrequency:(BKCheckForUpdatesFrequency)type;
- (NSDate *)lastCheck;
- (NSDate *)nextCheck;
- (void)checkForUpdates;

@end

@interface NSApplication (BKSoftwareUpdateControllerAccess)
- (id <BKSoftwareUpdateControllerProtocol>)BKSoftwareUpdateProtocols_softwareUpdateController; // exposed this way for applescript support
@end
