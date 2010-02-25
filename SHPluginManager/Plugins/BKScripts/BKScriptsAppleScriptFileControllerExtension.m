//
//  BKScriptsAppleScriptFileControllerExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKScriptsAppleScriptFileControllerExtension.h"


@implementation BKScriptsAppleScriptFileControllerExtension

- (id)init {
	if (self = [super init]) {
		fileNamesToApplescriptObjects = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[fileNamesToApplescriptObjects release];
	[super dealloc];
}

- (NSImage *)scriptToolbarImage {
	return [NSImage imageNamed:@"ScriptToolbar" class:[self class]];
}

- (BOOL)acceptsScriptFile:(NSString *)filePath {
	return [[filePath pathExtension] caseInsensitiveCompare:@"scpt"] == NSOrderedSame;
}

- (void)editScriptFile:(NSString *)filePath {
	[[NSWorkspace sharedWorkspace] openFile:filePath];
}

- (void)runScriptFile:(NSString *)filePath {
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/osascript" arguments:[NSArray arrayWithObject:filePath]];
	
	// XXX the below code is the cocoa way to execute scripts, but it doesn't seem to work with some scripts such as one's 
	// that use "System Events". I think the problem is that System Events needs access to the applications run loop to work
	// but since the script is being run from the run loop thread it never gets that, and so the script has timeout errors. The
	// fix is to run NSAppleScript from a separate thread, but that's not supported as of OS X 10.4.
	/*
	NSAppleScript *appleScript = [self appleScriptObjectForPath:filePath];
	NSDictionary *errors = nil;
	NSAppleEventDescriptor *result = [appleScript executeAndReturnError:&errors];
	
	if (!result) {
		logError(([errors description]));
	} else {
		logDebug(([result description]));
	}
	*/
}

- (NSAppleScript *)appleScriptObjectForPath:(NSString *)filePath {
	NSAppleScript *appleScript = [fileNamesToApplescriptObjects objectForKey:filePath];
	
	if (!appleScript) {
		NSDictionary *errorInfo = nil;
		
		appleScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&errorInfo];

		if (!appleScript) {
			logError(([errorInfo description]));
		} else {
			[fileNamesToApplescriptObjects setObject:appleScript forKey:filePath];
		}
		
		[appleScript release];
	}
	
	return appleScript;
}

- (BOOL)scriptFile:(NSString *)filePath respondsToCommand:(NSString *)command {
	return [[self appleScriptObjectForPath:filePath] respondsToEvent:command];
}

- (BOOL)scriptFile:(NSString *)filePath performCommand:(NSString *)command withArguments:(NSArray *)arguments result:(id *)result error:(NSDictionary **)errorInfo {
	NSAppleScript *appleScript = [self appleScriptObjectForPath:filePath];
	id aResult = [appleScript callHandler:command withArguments:arguments errorInfo:errorInfo];
	
	if (!aResult) {
		if (result) *result = nil;
		return NO;
	} else {
		if (result) *result = aResult;
		return YES;
	}
}

@end
