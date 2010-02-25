//
//  BKLicenseDocument.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKLicenseDocument.h"
#import "BKLicense.h"


@implementation BKLicenseDocument

- (NSString *)windowNibName {
    return @"BKLicenseDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
	[self close];
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	NSString *filename = [absoluteURL path];
	NSString *licenseName = [[NSApp delegate] applicationLicenseName];
	NSData *publicKey = [[NSApp delegate] applicationPublicKey];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *supportFolder = [fileManager processesApplicationSupportFolder];
	NSString *licensePath = [supportFolder stringByAppendingPathComponent:licenseName];
	
	if (![BKLicense isLicenseValidAtPath:filename publicKey:publicKey]) {
		NSString *message = BKLocalizedString(@"The license file is invalid.", nil);
		NSRunAlertPanel(BKLocalizedString(@"Invalid license file", nil),
						[NSString stringWithFormat:message, filename, nil],
						BKLocalizedString(@"OK", nil),
						nil,
						nil);
		
		logWarn(([NSString stringWithFormat:@"failed to install invalid license %@", filename]));
		return YES;
	}
	
	if ([BKLicense isLicenseValidAtPath:licensePath publicKey:publicKey]) {
		int choice = NSRunInformationalAlertPanel(BKLocalizedString(@"Replace existing license?", nil), 
												  BKLocalizedString(@"You already have a valid license installed. Would you like to replace this existing license?", nil), 
												  BKLocalizedString(@"OK", nil),
												  BKLocalizedString(@"Cancel", nil),
												  nil);
		if (choice != NSAlertDefaultReturn) {
			return YES;
		}
		
		if (![fileManager removeFileAtPath:licensePath handler:nil]) {
			logError(([NSString stringWithFormat:@"failed to remove old license %@", licensePath]));
			return YES;
		}
		
		logInfo(([NSString stringWithFormat:@"will replace license %@ with license %@", licensePath, filename]));
	}
	
	if (![fileManager copyPath:filename toPath:licensePath handler:nil]) {
		NSString *message = BKLocalizedString(@"Failed to copy license to install location. Make sure that you have proper permissions.", nil);
		NSRunAlertPanel(BKLocalizedString(@"Failed to copy license file", nil),
						[NSString stringWithFormat:message, filename, licenseName, nil],
						BKLocalizedString(@"OK", nil),
						nil,
						nil);
		
		logError(([NSString stringWithFormat:@"failed to copy %@ to %@", filename, licensePath]));
		return YES;
	}
	
	if (![BKLicense isLicenseValidAtPath:licensePath publicKey:publicKey]) {
		NSRunAlertPanel(BKLocalizedString(@"Failed to install license", nil),
						BKLocalizedString(@"Something went wrong during the license process. Please report this problem.", nil),
						BKLocalizedString(@"OK", nil),
						nil,
						nil);
		logError(([NSString stringWithFormat:@"failed to installed license at %@", licensePath]));
		return YES;
	}
	
	[BKLicense uncacheLicenseNamed:licenseName];

	NSRunInformationalAlertPanel(BKLocalizedString(@"Thank you!", nil), 
								 BKLocalizedString(@"You have successfully installed your license. Thanks for your support.", nil), 
								 BKLocalizedString(@"OK", nil), 
								 nil, 
								 nil);
	[BKLicense dontShowDonateWindowForLicenseNamed:licenseName];
	
	logInfo(([NSString stringWithFormat:@"successfully installed license at %@", licensePath]));
	
    return YES;
}

@end
