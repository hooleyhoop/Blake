//
//  TATemplateApplicationDelegate.m
//  TemplateApplication
//
//  Created by Jesse Grosjean on 12/17/04.
//  Copyright 2004 Hog Bay Software. All rights reserved.
//

#import "TATemplateApplicationDelegate.h"


@implementation TATemplateApplicationDelegate

- (void)awakeFromNib {
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return NO;
}

- (NSData *)applicationPublicKey {
	return [@"" dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)applicationLicenseName {
    return @"TemplateApplication License.templateapplicationlicense";
}

- (NSString *)applicationUserGuideURLString {
	return @"http://www.hogbaysoftware.com/beta/book/templateapplicationguide";
}

- (NSString *)applicationWebPageURLString {
	return @"http://www.hogbaysoftware.com/beta/product/templateapplication";
}

- (NSString *)applicationUserForumsURLString {
	return @"http://www.hogbaysoftware.com/beta/forum";
}

- (NSString *)applicationRecoverLostLicenseURLString {
	return @"http://www.hogbaysoftware.com/beta/support";
}

- (NSString *)applicationPluginsAndScriptsURLString {
	return @"http://www.hogbaysoftware.com/beta/contributions/templateapplication";
}

- (NSString *)applicationReleaseNotesURLString {
	return @"http://www.hogbaysoftware.com/beta/product/templateapplication/releasenotes";
}

- (NSString *)applicationReportNewBugURLString {
	return @"http://www.hogbaysoftware.com/beta/node/add/project_issue/templateapplication/bug";
}

- (NSString *)applicationRequestNewFeatureURLString {
	return @"http://www.hogbaysoftware.com/beta/node/add/project_issue/templateapplication/feature";
}

- (NSString *)applicationDownloadURLString {
	return @"http://www.hogbaysoftware.com/beta/files/releases/TemplateApplication.dmg";
}

- (NSString *)applicationSoftwareUpdateURLString {
	return @"http://www.hogbaysoftware.com/beta/files/releases/TemplateApplication.plist";
}

- (NSString *)applicationCrashReportURLString {
	return @"http://www.hogbaysoftware.com/cgi-bin/crashreporter.pl";
}

- (NSString *)applicationUpgradeDonationURLString {
	return @"http://www.hogbaysoftware.com/beta/product";
}

- (NSString *)applicationBuyNowURLString {
	return @"http://www.hogbaysoftware.com/beta/product";
}

@end
