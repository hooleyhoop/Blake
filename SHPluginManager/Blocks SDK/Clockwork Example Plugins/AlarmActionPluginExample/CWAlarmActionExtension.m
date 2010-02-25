//
//  CWAlarmActionExtension.m
//  Blocks SDK
//
//  Created by Jesse Grosjean on 5/27/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "CWAlarmActionExtension.h"


@implementation CWAlarmActionExtension

+ (void)declareAlarmActions:(NSApplication *)application {
	[[NSApplication sharedApplication] declareAlarmAction:[[[CWAlarmActionExtension alloc] init] autorelease]];
}

- (NSString *)name {
	return NSLocalizedString(@"Alarm Action Plugin Example", nil);	
}

- (void)alarmStarted:(id <CWTimerProtocol>)timer {
	NSLog(@"timer started");
}

- (void)alarmStopped:(id <CWTimerProtocol>)timer {
	NSLog(@"timer stopped");	
}

- (void)alarmFinished:(id <CWTimerProtocol>)timer alarmDate:(NSCalendarDate *)alarmDate {
	NSLog(@"timer alarm");	
}

@end