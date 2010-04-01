//
//  LogControllerTests.m
//  SHShared
//
//  Created by Steven Hooley on 4/25/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//


@interface LogControllerTests : SenTestCase {
	
}

@end


@implementation LogControllerTests

- (void)testBasicCoverage {
	
	logInfo(@"doh");
	logWarning(@"doh");
	logError(@"doh");
	NSLog(@"Doh");
}
//+ (void)initialize
//+ (id)sharedLogger
//+ (void)killSharedLogController
//- (id)initSingleton
//- (void)applicationWillTerminate:(NSNotification*)notification
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//- (void)addLogMessage:(NSString*)message location:(NSString*)location path:(NSString*)path lineNumber:(int)lineNumber errorLevel:(BBLogErrorLevel)errorLevel
//- (NSString*)formatLogForFile:(NSDictionary *)logMsg
//- (void)flushLogs
	
@end
