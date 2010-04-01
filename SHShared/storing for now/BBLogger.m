//
//  BBLogger.m
//  BBUtilities
//
//  Created by Jonathan del Strother on 16/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

#import "BBLogger.h"
#import "LogController.h"
// #import "mach_override.h"
#import <asl.h>
#import <pthread.h>
#import <Foundation/NSDebug.h>

static pthread_key_t aslLogHandle;
static pthread_once_t key_once = PTHREAD_ONCE_INIT;
static void make_key() {
    (void) pthread_key_create(&aslLogHandle, NULL);
}

void logToASL(BBLogErrorLevel level, const char* file, int lineNumber, const char* message) {
	// asl_log needs a per-thread client.  Set one up with pthreads.  (TODO : Is the display link a pthread?)
	pthread_once(&key_once, make_key);
	void * aslClient;
	if ((aslClient = pthread_getspecific(aslLogHandle)) == NULL) {
		aslClient = asl_open(NULL, "tv.bestbefore.BBUtilities", ASL_OPT_STDERR);
		(void) pthread_setspecific(aslLogHandle, aslClient);
    }
	
	int aslLevel;
	switch (level) {
		case BB_LOG_INFO:
			aslLevel = ASL_LEVEL_INFO;
			break;
		case BB_LOG_WARNING:
			aslLevel = ASL_LEVEL_WARNING;
			break;
		case BB_LOG_ERROR:
			aslLevel = ASL_LEVEL_ERR;
			break;
		default:
			[NSException raise:@"Crazy log error" format:@"Didn't expect logging level %d", level];
	}
	
	asl_log(aslClient, NULL, aslLevel, "%s:%d - %s", file, lineNumber, message);
}




// BBDetailedLogWithVA and BBDetailedLog can be merged once BBLog is gone
void BBDetailedLogWithVA(BBLogErrorLevel level, int lineNumber, const char* fileName, const char* methodName, NSString* message, va_list args) {
	// NSLog manages to work without a pre-existing autorelease pool in place, so we probably ought to too.
	// (Actually, NSLog doesn't use autoreleased objects at all, but we're doing quite a bit more than NSLog)
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
	
	NSString* formattedMessage = [[NSString alloc] initWithFormat:message arguments:args];
	NSString* fileBaseName = [[[NSString stringWithCString:fileName encoding:NSUTF8StringEncoding] pathComponents] lastObject];
	NSString* location = [NSString stringWithFormat:@"%@: %d %s", fileBaseName, lineNumber, methodName];
	NSString* path = [NSString stringWithFormat:@"%s", fileName];

	[logger addLogMessage:formattedMessage location:location path:path lineNumber:lineNumber errorLevel:level];
	
	if (NSDebugEnabled || level>=BB_LOG_WARNING || tryingToLoadLogger) {
		logToASL(level, [fileBaseName cStringUsingEncoding:NSASCIIStringEncoding], lineNumber, [formattedMessage cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	[formattedMessage release];
	[pool release];
}

void BBDetailedLog(BBLogErrorLevel level, int lineNumber, const char* fileName, const char* methodName, NSString* message,...) {
    va_list args;
    va_start(args, message); 
    BBDetailedLogWithVA(level, lineNumber, fileName, methodName, message, args);
    va_end(args);
 
}

void BBLog(NSString* message,...) {
	va_list args;
    va_start(args, message); 
    BBDetailedLogWithVA(BB_LOG_ERROR, 0, "unknown", "unknown", message, args);
    va_end(args);
}

static void (*OriginalNSLog)(NSString*,...) = NULL;
void NewNSLog(NSString* message,...) {
	va_list args;
    va_start(args, message);
	BBDetailedLogWithVA(BB_LOG_INFO, 0, "NSLog message", "", message, args);		// Print NSLog messages to our own custom log controller
	// NSLogv(message, args);		-- skip the original nslogv implementation for now.  BBDetailedLogWithVA will print to asl_log anyway.
    va_end(args);
}

void redirectNSLog() {
//steve	mach_override_ptr((void*)NSLog, NewNSLog, (void**)&OriginalNSLog);
}