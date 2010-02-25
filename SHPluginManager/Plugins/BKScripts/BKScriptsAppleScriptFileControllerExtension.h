//
//  BKScriptsAppleScriptFileControllerExtension.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKApplicationProtocols.h"
#import "BKScriptsProtocols.h"


@interface BKScriptsAppleScriptFileControllerExtension : NSObject <BKScriptsFileControllerProtocol> {
	NSMutableDictionary *fileNamesToApplescriptObjects;
}

- (NSAppleScript *)appleScriptObjectForPath:(NSString *)filePath;

@end
