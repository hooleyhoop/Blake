//
//  BKLicenseController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/28/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKLicenseController.h"
#import "BKLicense.h"


@implementation BKLicenseController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark accessors

- (BKLicense *)license {
	BKLicense *license = [BKLicense licenseNamed:[[NSApp delegate] applicationLicenseName]];
	[license setPublicKey:[[NSApp delegate] applicationPublicKey]];
	return license;
}

- (BOOL)valid {
	return [[self license] isValid];
}

#pragma mark actions

- (IBAction)upgradeDonation:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationUpgradeDonationURLString]]];
}

- (IBAction)buyNow:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationBuyNowURLString]]];
}

@end
