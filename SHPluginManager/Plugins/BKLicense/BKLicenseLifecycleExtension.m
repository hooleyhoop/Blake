//
//  BKLicenseLifecycleExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 2/2/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKLicenseLifecycleExtension.h"
#import "BKConfigurationProtocols.h"
#import "BKUserInterfaceProtocols.h"
#import "BKLicenseController.h"
#import "BKLicense.h"


@implementation BKLicenseLifecycleExtension

- (void)applicationLaunching {
}

- (void)applicationWillFinishLaunching {
}

- (void)applicationDidFinishLaunching {
	NSString *name = [[NSProcessInfo processInfo] processName];
	
    if (![[BKLicenseController sharedInstance] valid]) {
		NSString *title = [NSString stringWithFormat:BKLocalizedString(@"Thank you for trying %@", nil), name];
		NSString *message = [NSString stringWithFormat:BKLocalizedString(@"Buying a license allows me to create more software for your Mac. I'm happy to answer any questions that you have in our user forums. Thanks, Jesse Grosjean", nil), name];
		
        int choice = NSRunAlertPanel(title,
                                     message,
                                     BKLocalizedString(@"Buy Now", nil),
                                     BKLocalizedString(@"Later", nil),
                                     BKLocalizedString(@"Recover Lost License", nil));
        if (choice == NSAlertDefaultReturn) {
			[[BKLicenseController sharedInstance] buyNow:nil];
        } else if (choice == NSAlertAlternateReturn) {
			// later
        } else {
			[[NSApp BKConfigurationProtocols_configurationController] recoverLostLicense:nil];
        }
    } else {
		if ([BKLicense showsDonateWindowForLicenseNamed:[[NSApp delegate] applicationLicenseName]]) {
			int choice = NSRunAlertPanel([NSString stringWithFormat:BKLocalizedString(@"Welcome to this new version of %@", nil), name],
										 BKLocalizedString(@"Upgrades are free for registered users, but I ask for donations when you find the new features useful. This system makes the upgrade process simpler for both of us and allows you to determine your level of support. Thanks, Jesse Grosjean", nil),
										 BKLocalizedString(@"Make Donation", nil),
										 BKLocalizedString(@"Don't Show Again", nil),
										 BKLocalizedString(@"Release Notes", nil));
			
			if (choice == NSAlertDefaultReturn) {
				[[BKLicenseController sharedInstance] upgradeDonation:nil];
			} else if (choice == NSAlertAlternateReturn) {
				[BKLicense dontShowDonateWindowForLicenseNamed:[[NSApp delegate] applicationLicenseName]];
			} else {
				[[NSApp BKConfigurationProtocols_configurationController] showReleaseNotes:nil];
			}
		}
	}
	
	NSMenuItem *aboutMenuItem = [[[NSApp BKUserInterfaceProtocols_userInterfaceController] mainMenuController] menuItemForMenuItemPath:@"/Application/AboutItem"];
	
	if ([aboutMenuItem target] == NSApp) {
		[aboutMenuItem setTarget:self];
	} else {
		logWarn((@"Failed to connect license info to about panel, about target not NSApp"));
	}
}

- (void)applicationWillTerminate {
}

- (void)orderFrontStandardAboutPanel:(id)sender {
	NSMutableDictionary *optionsDictionary = [NSMutableDictionary dictionary];
	NSMutableAttributedString *credits = [[[NSMutableAttributedString alloc] init] autorelease];
	BKLicense *license = [[BKLicenseController sharedInstance] license];
	if ([license isValid]) {
		[credits replaceCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithFormat:@"%@\n%@ %@", [[license licenseName] stringByDeletingPathExtension], [license firstName], [license lastName]]];
	} else {
		[credits replaceCharactersInRange:NSMakeRange(0, 0) withString:BKLocalizedString(@"Unlicensed Copy", nil)];
	}
	
	[optionsDictionary setObject:credits forKey:@"Credits"];
	
	[NSApp orderFrontStandardAboutPanelWithOptions:optionsDictionary];
}

@end
