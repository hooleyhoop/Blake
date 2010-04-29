//
//  ApplescriptUtils.m
//  SHShared
//
//  Created by steve hooley on 04/02/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "ApplescriptUtils.h"
#import <Carbon/Carbon.h>

static NSMutableDictionary *_applescriptFileCache;

@implementation ApplescriptUtils

+ (void)initialize {

	static BOOL isInitialized = NO;
    if( !isInitialized ) {
        isInitialized = YES;	
			
		if(!_applescriptFileCache)
			_applescriptFileCache = [[NSMutableDictionary alloc] init];
	}
}

void LoadScriptingAdditions(void) {

    OSErr err;
    AppleEvent e, r;
    ProcessSerialNumber selfPSN = { 0, kCurrentProcess };
	
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_2
    void (*f)();
    CFBundleRef b;
	
    /* First, call the routine that installs the kASAppleScriptSuite /
	 kGetAEUTApple event handler in your applications Apple event dispatch
	 table.  This part is only required if your application is running in
	 Mac OS X 10.0 or 10.1.  It is not necessary and will silently fail
	 anywhere else (such as when running in Classic or Mac OS 9). */
	
    b = CFBundleGetBundleWithIdentifier(CFSTR("com.apple.openscripting"));
    if (b != NULL) {
        f = (void (*)()) CFBundleGetFunctionPointerForName(b, CFSTR("OSAInstallStandardHandlers"));
        if (f != NULL) (*f)();
    }
#endif
	
    /* Second, send ourselves a kASAppleScriptSuite / kGetAEUT
	 Apple event.  This will load the scripting additions into our
	 application's system Apple event dispatch table - it will also
	 refresh the table so it is synchronized with the contents of
	 the scripting additions folder. */
	
    err = AEBuildAppleEvent(kASAppleScriptSuite, kGetAEUT,
							typeProcessSerialNumber, &selfPSN, sizeof(selfPSN),
							kAutoGenerateReturnID, kAnyTransactionID, &e, NULL, "");
    if (err == noErr) {
        AESend(&e, &r, kAEWaitReply, kAENormalPriority, kAEDefaultTimeout, NULL, NULL);
        AEDisposeDesc(&e);
        AEDisposeDesc(&r);
    }
}

+ (NSAppleScript *)applescript:(NSString *)scriptName {
	
	NSAppleScript *appleScript = [_applescriptFileCache objectForKey:scriptName];
	if(appleScript)
		return appleScript;

    // load the script from a resource by fetching its URL from within our bundle
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"SendFinderMessage" ofType:@"applescript"];
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:scriptName ofType:@"scpt"];
	if(!path) {
		NSString *execuablePth = [[NSBundle mainBundle] executablePath];
		NSString *filePath = [[execuablePth stringByAppendingPathComponent:@"scriptName"] stringByAppendingPathExtension:@"scpt"];
		BOOL fileInSameDirTest = [[NSFileManager defaultManager] fileExistsAtPath: filePath];
		if(!fileInSameDirTest)
			[NSException raise:@"Cant find applescript" format:@"%@", scriptName];
		
		path = filePath;
	}
	
	
	NSURL *url = [NSURL fileURLWithPath:path];
	if(!url)
		[NSException raise:@"Cant find applescript" format:@"%@", url];
	
	NSDictionary *errors = [NSDictionary dictionary];
	appleScript = [[[NSAppleScript alloc] initWithContentsOfURL:url error:&errors] autorelease];
	if(!appleScript){
		// what is in errors?
		[NSException raise:@"Could not make NSAppleScript" format:@"%@, %@", url, errors];
	}
	NSAssert( [appleScript isCompiled], @"why not compiled?" );
	
	[_applescriptFileCache setObject:appleScript forKey:scriptName];
	
	return appleScript;
}

+ (NSAppleEventDescriptor *)eventForApplescriptMethod:(NSString *)methodName arguments:(NSAppleEventDescriptor *)paramList {
	
	// create the AppleEvent target
	ProcessSerialNumber psn = {0, kCurrentProcess};
	NSAppleEventDescriptor* target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber bytes:&psn length:sizeof(ProcessSerialNumber)];
	// create an NSAppleEventDescriptor with the script's method name to call,
	// this is used for the script statement: "on show_message(user_message)"
	// Note that the routine name must be in lower case.
	NSAppleEventDescriptor* handler = [NSAppleEventDescriptor descriptorWithString: [methodName lowercaseString]];
	
	// create the event for an AppleScript subroutine,
	// set the method name and the list of parameters
	NSAppleEventDescriptor* event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite eventID:kASSubroutineEvent targetDescriptor:target returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID];
	[event setParamDescriptor:handler forKeyword:keyASSubroutineName];
	if(paramList)
		[event setParamDescriptor:paramList forKeyword:keyDirectObject];	
	return event;
}

+ (NSAppleEventDescriptor *)parameters:(NSString *)firstArg, ... {
	
	NSParameterAssert([firstArg isKindOfClass: NSClassFromString(@"NSString")]);
	NSAppleEventDescriptor *parameters = nil;
	
	NSString *eachObject;
	va_list argumentList;
	if( firstArg!=nil )					// The first argument isn't part of the varargs list,
	{										// so we'll handle it separately.
		parameters = [NSAppleEventDescriptor listDescriptor];
		NSAppleEventDescriptor *firstParameter = [NSAppleEventDescriptor descriptorWithString:firstArg];
		[parameters insertDescriptor:firstParameter atIndex:1];
		
		NSUInteger argIndex = 1;
		va_start(argumentList, firstArg);					// Start scanning for arguments after firstString.
		while( (eachObject=va_arg( argumentList, NSString* )) )	// As many times as we can get an argument of type "id"
		{
			NSAssert([eachObject isKindOfClass: NSClassFromString(@"NSString")], @"Only for string arguments at the moment");
			
			NSAppleEventDescriptor *nextParameter = [NSAppleEventDescriptor descriptorWithString:eachObject];
			[parameters insertDescriptor:nextParameter atIndex:(argIndex+1)];
			argIndex++;
		}
		va_end(argumentList);
	}
	return parameters;	
}

+ (NSString *)executeScript:(NSString *)scriptFileName method:(NSString *)scriptMethodName params:(NSAppleEventDescriptor *)parameters {
	
	NSString *returnVal = nil;
	NSDictionary *errors = [NSDictionary dictionary];
	
	NSAppleScript *appleScript = [ApplescriptUtils applescript:scriptFileName];
	NSAssert1( appleScript, @"could not find script %@", scriptFileName);
	
	NSAppleEventDescriptor* event = [ApplescriptUtils eventForApplescriptMethod:scriptMethodName arguments:parameters];
	
	// call the event in AppleScript
	NSAppleEventDescriptor *resultEvent = [appleScript executeAppleEvent:event error:&errors];
	if( !resultEvent ) {
		// report any errors from 'errors'
		[NSException raise:@"Error in applescript" format:@"%@ - %@", scriptFileName, scriptMethodName];
	}
	
	// successful execution
	if( kAENullEvent!=[resultEvent descriptorType] )
	{
		// script returned an AppleScript result
		if( cAEList == [resultEvent descriptorType] ) {
			// result is a list of other descriptors
			logError(@"result is a list of other descriptors");
		} else {
			DescType desc = [resultEvent descriptorType];
			NSData *data = [resultEvent data];
			returnVal = [resultEvent stringValue];
			logInfo(@"%@ Script returned - %@, %@", scriptMethodName, resultEvent, returnVal );
		}
	}
	return returnVal;
}

@end
