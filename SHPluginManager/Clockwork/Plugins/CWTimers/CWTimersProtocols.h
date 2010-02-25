//
//  CWTimersProtocols.h
//  Clockwork
//
//  Created by Jesse Grosjean on 2/28/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKScriptsProtocols.h"


typedef enum _CWTimerMode {
    CWStopwatchMode = 0,
    CWAlarmMode = 1,
} CWTimerMode;

enum {
    SECS_IN_MINUTE = 60,
    SECS_IN_HOUR = (SECS_IN_MINUTE * 60),
    SECS_IN_DAY = (SECS_IN_HOUR * 24),
	SECS_IN_WEEK = (SECS_IN_DAY * 7)
};

@protocol CWAlarmActionProtocol;
@protocol CWAlarmRepeatRuleProtocol;

#pragma mark -

@protocol CWTimerProtocol <NSObject, NSCoding, NSCopying>

#pragma mark accessors

- (NSNumber *)uniqueID;
- (NSString *)name;
- (void)setName:(NSString *)aName;
- (CWTimerMode)mode;
- (void)setMode:(CWTimerMode)aMode;
- (BOOL)showSubseconds;
- (void)setShowSubseconds:(BOOL)showSubseconds;
- (NSTimeInterval)stepInterval;
- (void)setStepInterval:(NSTimeInterval)aStepInterval;
- (BOOL)running;
- (void)setRunning:(BOOL)aIsRunning;
- (NSCalendarDate *)startDate;
- (void)setStartDate:(NSCalendarDate *)aStartDate;
- (NSCalendarDate *)alarmDate;
- (void)setAlarmDate:(NSCalendarDate *)anAlarmDate;

#pragma mark display times

- (int)days;
- (void)setDays:(int)aDays;
- (int)hours;
- (void)setHours:(int)aHours;
- (int)minutes;
- (void)setMinutes:(int)aMinutes;
- (int)seconds;
- (void)setSeconds:(int)aSeconds;
- (NSTimeInterval)subseconds;
- (void)setSubsecond:(NSTimeInterval)aSubseconds;
- (NSTimeInterval)displayTime;
- (void)setDisplayTime:(NSTimeInterval)aTimeInterval;

#pragma mark repeat rules

- (NSString *)repeatRuleName;
- (void)setRepeatRuleName:(NSString *)name;
- (id <CWAlarmRepeatRuleProtocol>)alarmRepeatRule;
- (void)setAlarmRepeatRule:(id <CWAlarmRepeatRuleProtocol>)alarmRepeatRule;

#pragma mark alarm actions

- (unsigned)countOfAlarmActions;
- (unsigned)indexOfObjectInAlarmActions:(id <CWAlarmActionProtocol>)alarmAction;
- (id <CWAlarmActionProtocol>)objectInAlarmActionsAtIndex:(unsigned)index;
- (void)insertObject:(id <CWAlarmActionProtocol>)alarmAction inAlarmActionsAtIndex:(unsigned)index;
- (void)removeObjectFromAlarmActionsAtIndex:(unsigned)index;

- (id <CWAlarmActionProtocol>)alarmActionWithName:(NSString *)name;
- (void)addAlarmActionWithName:(NSString *)name;
- (void)removeAlarmActionWithName:(NSString *)name;

#pragma mark behaviors

- (void)start;
- (void)stop;
- (void)clear;
- (void)step;

@end

#define CWTimerWillStartNotification @"CWTimerWillStartNotification"
#define CWTimerDidStartNotification @"CWTimerDidStartNotification"
#define CWTimerWillStopNotification @"CWTimerWillStopNotification"
#define CWTimerDidStopNotification @"CWTimerDidStopNotification"
#define CWTimerAlarmNotification @"CWTimerAlarmNotification"

#define CWTimerSecondsChangedNotification @"CWTimerSecondsChangedNotification"
#define CWTimerMinutesChangedNotification @"CWTimerMinutesChangedNotification"
#define CWTimerHoursChangedNotification @"CWTimerHoursChangedNotification"
#define CWTimerDaysChangedNotification @"CWTimerDaysChangedNotification"
#define CWTimerDaysChangedNotification @"CWTimerDaysChangedNotification"
#define CWTimerDisplayTimeChangedNotification @"CWTimerDisplayTimeChangedNotification"

#define CWTimerNameChangedNotification @"CWTimerNameChangedNotification"
#define CWTimerModeChangedNotification @"CWTimerModeChangedNotification"
#define CWTimerStepIntervalChangedNotification @"CWTimerStepIntervalChangedNotification"
#define CWTimerRunningChangedNotification @"CWTimerRunningChangedNotification"
#define CWTimerStartDateChangedNotification @"CWTimerStartDateChangedNotification"
#define CWTimerAlarmDateChangedNotification @"CWTimerAlarmDateChangedNotification"

#pragma mark -

@protocol CWAlertProtocol <NSObject, NSCoding, NSCopying>

#pragma mark accessors

- (NSNumber *)uniqueID;
- (NSString *)name;
- (void)setName:(NSString *)aName;
- (BOOL)repeatBeep;
- (void)setRepeatBeep:(BOOL)shouldRepeatBeep;
- (NSCalendarDate *)startDate;
- (void)setStartDate:(NSCalendarDate *)aStartDate;
- (NSCalendarDate *)reminderDate;
- (void)setReminderDate:(NSCalendarDate *)aReminderDate;
- (BOOL)isOverdue;
- (NSString *)nameStringFormat;
- (void)setNameStringFormat:(NSString *)aNameStringFormat;

#pragma mark behaviors

- (void)step;

@end

#define CWAlertNameChangedNotification @"CWAlertNameChangedNotification"
#define CWAlertStartDateChangedNotification @"CWAlertStartDateChangedNotification"
#define CWAlertReminderDateChangedNotification @"CWAlertReminderDateChangedNotification"
#define CWAlertNameStringFormatChangedNotification @"CWAlertNameStringFormatChangedNotification"
#define CWAlertOverdueStepNotification @"CWAlertOverdueStepNotification"

#pragma mark -

@protocol CWAlarmRepeatRuleProtocol <NSObject, NSCoding, NSCopying>
+ (void)declareRepeatRules:(NSApplication *)application;
- (NSString *)name;
- (void)scheduleNextAlarmDate:(id <CWTimerProtocol>)timer alarmDate:(NSCalendarDate *)alarmDate;
@end

#pragma mark -

@protocol CWAlarmActionProtocol <NSObject, NSCoding, NSCopying>
+ (void)declareAlarmActions:(NSApplication *)application;
- (NSString *)name;
- (void)alarmStarted:(id <CWTimerProtocol>)timer;
- (void)alarmStopped:(id <CWTimerProtocol>)timer;
- (void)alarmFinished:(id <CWTimerProtocol>)timer alarmDate:(NSCalendarDate *)alarmDate;
@end

#pragma mark -

@protocol CWTimerClockProtocol <NSObject>

- (NSCalendarDate *)synchDate;
- (NSTimeInterval)stepInterval;
- (void)setStepInterval:(NSTimeInterval)aStepInterval;
- (void)start;
- (void)stop;

@end

#define CWTimerClockWillStepNotification @"CWTimerClockWillStepNotification"
#define CWTimerClockDidStepNotification @"CWTimerClockDidStepNotification"

#pragma mark -

@interface NSApplication (CWTimersApplicationAdditions)

- (BOOL)saveData;

#pragma mark conversions

- (NSTimeInterval)convertToSeconds:(int)days hours:(int)hours minutes:(int)minutes seconds:(int)seconds subseconds:(NSTimeInterval)subseconds;
- (void)convertFromSeconds:(NSTimeInterval)seconds days:(int *)inDays hours:(int *)inHours minutes:(int *)inMinutes seconds:(int *)inSeconds subseconds:(NSTimeInterval *)inSubseconds;

#pragma mark timer clock

- (id <CWTimerClockProtocol>)timerClock;

#pragma mark timers

- (id <CWTimerProtocol>)selectedTimer;
- (void)setSelectedTimer:(id <CWTimerProtocol>)aTimer;

- (id <CWTimerProtocol>)createNewTimer;
- (unsigned)countOfTimers;
- (unsigned)indexOfObjectInTimers:(id <CWTimerProtocol>)timer;
- (id)objectInTimersAtIndex:(unsigned)index;
- (void)insertObject:(id <CWTimerProtocol>)timer inTimersAtIndex:(unsigned)index;
- (void)removeObjectFromTimersAtIndex:(unsigned)index;
- (void)insertInTimers:(id <CWTimerProtocol>)timer;
- (id)valueInTimersWithUniqueID:(NSNumber *)uniqueID;

#pragma mark alerts

- (unsigned)countOfAlerts;
- (unsigned)indexOfObjectInAlerts:(id <CWAlertProtocol>)alert;
- (id <CWAlertProtocol>)objectInAlertsAtIndex:(unsigned)index;
- (void)insertObject:(id <CWAlertProtocol>)alert inAlertsAtIndex:(unsigned)index;
- (void)removeObjectFromAlertsAtIndex:(unsigned)index;
- (void)insertInAlerts:(id <CWAlertProtocol>)alert;
- (id <CWAlertProtocol>)valueInAlertsWithUniqueID:(NSNumber *)uniqueID;

#pragma mark repeat rules

- (void)declareRepeatRule:(id <CWAlarmRepeatRuleProtocol>)repeatRule;
- (id <CWAlarmRepeatRuleProtocol>)repeatRuleWithName:(NSString *)ruleName;
- (NSArray *)repeatRuleNames;

#pragma mark alarm actions

- (void)declareAlarmAction:(id <CWAlarmActionProtocol>)alarmAction;
- (id <CWAlarmActionProtocol>)alarmActionWithName:(NSString *)actionName;
- (NSArray *)alarmActionsNames;

@end

#define CWApplicationSelectedTimerWillChange @"CWApplicationSelectedTimerWillChange"
#define CWApplicationSelectedTimerDidChange @"CWApplicationSelectedTimerDidChange"
#define CWApplicationTimerAdded @"CWApplicationTimerAdded"
#define CWApplicationTimerRemoved @"CWApplicationTimerRemoved"
#define CWApplicationAlertAdded @"CWApplicationAlertAdded"
#define CWApplicationAlertRemoved @"CWApplicationAlertRemoved"
