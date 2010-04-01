//
//  BKLicenseController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/28/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKConfigurationProtocols.h"


@class BKLicense;

@interface BKLicenseController : NSObject {

}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

- (BKLicense *)license;
- (BOOL)valid;

#pragma mark actions

- (IBAction)upgradeDonation:(id)sender;
- (IBAction)buyNow:(id)sender;

@end
