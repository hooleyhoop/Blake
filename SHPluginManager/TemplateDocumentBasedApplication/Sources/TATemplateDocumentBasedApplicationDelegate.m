//
//  TATemplateDocumentBasedApplicationDelegate.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 12/17/04.
//  Copyright 2004 Hog Bay Software. All rights reserved.
//

#import "TATemplateDocumentBasedApplicationDelegate.h"


@implementation TATemplateDocumentBasedApplicationDelegate

- (void)awakeFromNib {
}

- (NSData *)applicationPublicKey {
	return [@"" dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)applicationLicenseName {
    return @"TemplateDocumentBasedApplication License.templatedocumentbasedapplicationlicense";
}

- (NSString *)applicationUserGuideURLString {
	return @"http://www.hogbaysoftware.com/beta/book/templatedocumentbasedapplicationguide";
}

- (NSString *)applicationWebPageURLString {
	return @"http://www.hogbaysoftware.com/beta/product/templatedocumentbasedapplication";
}

- (NSString *)applicationUserForumsURLString {
	return @"http://www.hogbaysoftware.com/beta/forum";
}

- (NSString *)applicationRecoverLostLicenseURLString {
	return @"http://www.hogbaysoftware.com/beta/support";
}

- (NSString *)applicationPluginsAndScriptsURLString {
	return @"http://www.hogbaysoftware.com/beta/contributions/templatedocumentbasedapplication";
}

- (NSString *)applicationReleaseNotesURLString {
	return @"http://www.hogbaysoftware.com/beta/product/templatedocumentbasedapplication/releasenotes";
}

- (NSString *)applicationReportNewBugURLString {
	return @"http://www.hogbaysoftware.com/beta/node/add/project_issue/templatedocumentbasedapplication/bug";
}

- (NSString *)applicationRequestNewFeatureURLString {
	return @"http://www.hogbaysoftware.com/beta/node/add/project_issue/templatedocumentbasedapplication/feature";
}

- (NSString *)applicationDownloadURLString {
	return @"http://www.hogbaysoftware.com/beta/files/releases/TemplateDocumentBasedApplication.dmg";
}

- (NSString *)applicationSoftwareUpdateURLString {
	return @"http://www.hogbaysoftware.com/beta/files/releases/TemplateDocumentBasedApplication.plist";
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
