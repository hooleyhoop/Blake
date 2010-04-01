//
//  BKPluginDocument.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKPluginDocument.h"


@implementation BKPluginDocument

- (NSString *)windowNibName {
    return @"BKPluginDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
	[self close];
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	NSString *filename = [absoluteURL path];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *pluginFolder = [[fileManager processesApplicationSupportFolder] stringByAppendingPathComponent:@"PlugIns"];
	
	if (![fileManager fileExistsAtPath:pluginFolder]) {
		if (![fileManager createDirectoryAtPath:pluginFolder attributes:nil]) {
			NSRunAlertPanel(BKLocalizedString(@"Failed to create plugins folder", nil),
							BKLocalizedString(@"Something went wrong during the plugin install process. Please report this problem.", nil),
							BKLocalizedString(@"OK", nil),
							nil,
							nil);
			logError(([NSString stringWithFormat:@"failed to create plugin folder for path: %@", pluginFolder]));
			return YES;
		}
	}
	
	NSString *pluginPath = [pluginFolder stringByAppendingPathComponent:[filename lastPathComponent]];
	
	if (![fileManager copyPath:filename toPath:pluginPath handler:nil]) {
		NSRunAlertPanel(BKLocalizedString(@"Failed to copy plugin into plugins folder", nil),
						BKLocalizedString(@"Make sure that a plugin with the same name doesn't already exist in the plugins folder.", nil),
						BKLocalizedString(@"OK", nil),
						nil,
						nil);
		logError(([NSString stringWithFormat:@"failed to copy plugin from path: %@ to path: %@", filename, pluginPath]));
		return YES;
	}
	
	NSRunInformationalAlertPanel(BKLocalizedString(@"The plugin has been installed", nil),
								 BKLocalizedString(@"This application must be restarted to load and activate the plugin.", nil), 
								 BKLocalizedString(@"OK", nil),
								 nil,
								 nil);
	
	[self setFileName:filename];
	[self setFileType:typeName];
	
	return YES;
}

@end
