//
//  LogController.h
//  BBUtilities
//
//  Created by Jonathan del Strother on 10/10/2007
//  Copyright 2007 Best Before. All rights reserved.
//


@class BBLogFile, LogEmailController;
@interface LogController : NSObject {
	
//	IBOutlet NSWindow			*logWindow;
//  IBOutlet NSArrayController	*messagesController;
//  IBOutlet LogEmailController	*emailController;
//  IBOutlet NSSearchField		*searchField;
	NSString					*lastLog;
	NSMutableArray				*bufferedLogs;
	NSMutableArray				*arrayControllerLogBuffer;
}

+ (id)sharedLogger;
+ (void)killSharedLogController;

- (id)initSingleton;

// - (IBAction)showLogWindow:(id)sender;
// - (IBAction)searchFieldDidChange:(id)sender;
// - (IBAction)clearLog:(id)sender;
// - (IBAction)emailLogs:(id)sender;

- (void)addLogMessage:(NSString*)message location:(NSString*)location path:(NSString*)path lineNumber:(int)lineNumber errorLevel:(BBLogErrorLevel)errorLevel;

@end