//
//  BBLogger.h
//  BBUtilities
//
//  Created by Jonathan del Strother on 16/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//


// For text output - warnings, errors etc
// Use logInfo for "hurrah this method got called" messages, logWarning for recoverable errors, and logError for stuff that prevents the program working.
//#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum _bbLogErrorLevel {
    BB_LOG_INFO,
    BB_LOG_WARNING,
    BB_LOG_ERROR,
	BB_LOG_COUNT
} BBLogErrorLevel;

void BBDetailedLog(BBLogErrorLevel level, int lineNumber, const char* fileName, const char* methodName, NSString* message,...);

#define logInfo(message,...) BBDetailedLog(BB_LOG_INFO, __LINE__, __FILE__, __PRETTY_FUNCTION__, message, ##__VA_ARGS__)
#define logWarning(message,...) BBDetailedLog(BB_LOG_WARNING, __LINE__, __FILE__, __PRETTY_FUNCTION__, message, ##__VA_ARGS__)
#define logError(message,...) BBDetailedLog(BB_LOG_ERROR, __LINE__, __FILE__, __PRETTY_FUNCTION__, message, ##__VA_ARGS__)
#define logAssert(condition, message,...) if((condition==false)){BBDetailedLog(BB_LOG_ERROR, __LINE__, __FILE__, __PRETTY_FUNCTION__, message, ##__VA_ARGS__);}

void BBLog(NSString* message, ...) DEPRECATED_ATTRIBUTE;
	
// After calling this, NSLog messages will go to our log window & file (but also be piped to the original NSLog locations)
void redirectNSLog();


#ifdef __cplusplus
}
#endif