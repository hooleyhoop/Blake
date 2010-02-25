//
//  BBLogger.m
//  BBUtilities
//
//  Created by Jonathan del Strother on 16/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

#import "BBLogger.h"
#import "LogController.h"

// BBDetailedLogWithVA and BBDetailedLog can be merged once BBLog is gone
void BBDetailedLogWithVA(BBLogErrorLevel level, int lineNumber, const char* fileName, const char* methodName, NSString* message, va_list args)
{
	// NSLog manages to work without a pre-existing autorelease pool in place, so we probably ought to too.
	// (Actually, NSLog doesn't use autoreleased objects at all, but we're doing quite a big more than NSLog)
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	static BOOL tryingToLoadLogger = NO;
	// It's possible to get stuck in an endless loop, if in the process of instantiating our logcontroller something gets logged.
	// Check that we're not in the middle of loading before trying to instantiate our logger.  If we are, logger will still be nil, and the message will just go to stderr
	static id logger = nil;
	if (!logger && !tryingToLoadLogger) {
		tryingToLoadLogger = YES;
		logger = [LogController sharedLogger];
		tryingToLoadLogger = NO;
	}
	
	switch(level){
		case BB_LOG_INFO:
			message = [NSString stringWithFormat:@"Info: %@", message];
			break;
		case BB_LOG_WARNING:
			message = [NSString stringWithFormat:@"Warning: %@", message];
			break;
		case BB_LOG_ERROR:
			message = [NSString stringWithFormat:@"ERROR: %@", message];
			break;
		case BB_LOG_COUNT:
			break;
	}
	
	NSString* formattedMessage = [[NSString alloc] initWithFormat:message arguments:args];
	NSString* fileBaseName = [[[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding] pathComponents] lastObject];
//DO we need this?	NSString* location = [NSString stringWithFormat:@"%@: %d %s", fileBaseName, lineNumber, methodName];
//DO we need this?	NSString* path = [NSString stringWithFormat:@"%s", fileName];

//DO we need this?	[logger addLogMessage:formattedMessage location:location path:path lineNumber:lineNumber errorLevel:level];
	
	BOOL noisyLogging = NO;
	#ifdef DEBUG
	   noisyLogging = YES;
	#endif
	if (noisyLogging || level>=BB_LOG_WARNING || tryingToLoadLogger) {
	   fprintf(stderr, "%s:%d - %s\n", [fileBaseName cStringUsingEncoding:NSASCIIStringEncoding], lineNumber, [formattedMessage cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	[formattedMessage release];
	[pool release];
}

void BBDetailedLog(BBLogErrorLevel level, int lineNumber, const char* fileName, const char* methodName, NSString* message, ...)
{
    va_list args;
    va_start(args, message); 
    BBDetailedLogWithVA(level, lineNumber, fileName, methodName, message, args);
    va_end(args);
 
}

//void BBLog(NSString* message,...) {
//	va_list args;
//    va_start(args, message); 
//    BBDetailedLogWithVA(BB_LOG_ERROR, 0, "unknown", "unknown", message, args);
//    va_end(args);
//}

// static void (*OriginalNSLog)(NSString*,...) = NULL;
//void NewNSLog(NSString* message,...) {
//	va_list args;
//    va_start(args, message);
//	BOOL showMessage = YES;
//	if ([message isEqualToString:@"*** Message from %@:\n%@"]) {		// Messages from Quartz Javascript patches are really tiresome.  Silence them.
//		static BOOL firstQCMessage = YES;
//		if (firstQCMessage) {
//			firstQCMessage = NO;
//			BBDetailedLogWithVA(BB_LOG_ERROR, 0, "A friendly warning", "", @"A QC composition is being noisy - please fix it, now.  The following is the last message you'll get from QC.", NULL);
//		} else {
//			showMessage = NO;
//		}
//	}
//	
//	if (showMessage) {
//		BBDetailedLogWithVA(BB_LOG_INFO, 0, "NSLog message", "", message, args);		// Print NSLog messages to our own custom log controller
//	}
//
//	// NSLogv(message, args);		-- skip the original nslogv implementation for now.  BBDetailedLogWithVA will print to stderr anyway.
//    va_end(args);
//}

//void redirectNSLog() {
//	mach_override_ptr((void*)NSLog, NewNSLog, (void**)&OriginalNSLog);
//}