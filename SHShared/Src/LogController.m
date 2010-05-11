//
//  LogController.m
//  BBUtilities
//
//  Created by Jonathan del Strother on 10/10/2007
//  Copyright 2007 Best Before. All rights reserved.
//

#import "LogController.h"
//#import "LogEmailController.h"
//#import "BBLogFile.h"
#import "NSString_Extras.h"
//#import <Carbon/Carbon.h>

static LogController *sharedInstance;
// static NSString* LogWindowVisible = @"LogWindowVisible";

//@interface LogLevelToColorTransformer : NSValueTransformer {}
//@end
//@interface TimeStampToDescriptionTransformer : NSValueTransformer {}
//@end



//void openFileAtLineNum(NSString* filePath, int lineNum) {
//	// Use applescript (joy!) to open the file in xcode at a given line number.
//	NSDictionary* error = nil;
//	NSString* scriptPath = [[NSBundle bundleWithIdentifier:@"tv.bestbefore.BBUtilities"] pathForResource:@"Opener" ofType:@"scpt"];
//	if (!scriptPath) {
//		logError(@"couldn't find script");
//		return;
//	}
//	NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath] error:&error];
//	if (error) {
//		logError([error description]);
//        [script release];
//		return;
//	}
//	
//	if (![script isCompiled])
//		logWarning(@"script isn't compiled, will be slow");
//
//	// We have to construct an AppleEvent descriptor to contain the arguments for our handler call.  Remember that this list is 1, rather than 0, based.
//	NSAppleEventDescriptor *list = [[NSAppleEventDescriptor alloc] initListDescriptor];
//	int cindex=0;
//	[list insertDescriptor:[NSAppleEventDescriptor descriptorWithString:filePath] atIndex:(++cindex)];
//	[list insertDescriptor:[NSAppleEventDescriptor descriptorWithInt32:lineNum] atIndex:(cindex)];
//	NSAppleEventDescriptor *arguments = [[NSAppleEventDescriptor alloc] initListDescriptor];
//	[arguments insertDescriptor: list atIndex: 1];
//
//	// create the AppleEvent target
//	ProcessSerialNumber psn = { 0, kCurrentProcess };
//	NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber bytes:&psn length:sizeof(ProcessSerialNumber)];
//	// create an NSAppleEventDescriptor with the method name
//	// note that the name must be lowercase (even if it is uppercase in AppleScript)
//	NSAppleEventDescriptor *handler = [NSAppleEventDescriptor descriptorWithString:@"openfile"];
//	// create the event for an AppleScript subroutine, setting the method name and the list of parameters
//	NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite eventID:kASSubroutineEvent targetDescriptor:target returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID];
//	[event setParamDescriptor:handler forKeyword:keyASSubroutineName];
//	[event setParamDescriptor:arguments forKeyword:keyDirectObject];
//	// at last, call the event in AppleScript
//	[script executeAppleEvent:event error:&error];
//	
//	// Check for errors in running the handler
//	if (error) {
//		logError([error description]);
//	}
//	
//	[arguments release];
//	[list release];
//	[script release];
//}

@interface LogController (private)
//-(void)loadNib;
-(void)flushLogs;
-(void)applySearchFilter;
-(void)insertControllerObjects:(id)object;
@end

@implementation LogController

+ (void)initialize {
    
    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        isInitialized = YES;
		
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], @"showLogInformation",
				[NSNumber numberWithBool:YES], @"showLogWarnings",
				[NSNumber numberWithBool:YES], @"showLogErrors", nil];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults registerDefaults:appDefaults];
		
//        LogLevelToColorTransformer* logTransformer = [[[LogLevelToColorTransformer alloc] init] autorelease];
//        [NSValueTransformer setValueTransformer:logTransformer forName:@"LogLevelToColorTransformer"];
//        TimeStampToDescriptionTransformer* timeTransformer = [[[TimeStampToDescriptionTransformer alloc] init] autorelease];
//        [NSValueTransformer setValueTransformer:timeTransformer forName:@"TimeStampToDescriptionTransformer"];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"what is going on with these multiple initializes?"];
    }
}

+ (id)sharedLogger {
	if(sharedInstance==nil)
		sharedInstance = [[LogController alloc] initSingleton]; 
    return sharedInstance;
}

+ (void)killSharedLogController {
	[sharedInstance release];
	sharedInstance = nil;
}

- (id)initSingleton {
	// Remember not to use any logInfo, logError etc messages until after this returns
	
    if( (self=[super init])!=nil )
	{
        bufferedLogs = [[NSMutableArray alloc] init];
        arrayControllerLogBuffer = [[NSMutableArray alloc] init];

	// We want to insert ourselves into the menu and load our nib, but can't do that until the menu exists...
//	if ([NSApp mainMenu])
//		[self loadNib];
//	else
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNib) name:NSApplicationDidFinishLaunchingNotification object:nil];

//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:NSApp];
	
//	redirectNSLog();
	}
    return self;
}

- (void)dealloc {
	[super dealloc];
}

//-(void)loadNib
//{
//    // Hook ourselves into the Window menu, if we have a "Show Log Viewer" item in there.
//    NSMenu* windowMenu = [[[NSApp mainMenu] itemWithTitle:@"Window"] submenu];
//    NSMenuItem* menuItem = [windowMenu itemWithTitle:@"Show Log Viewer"];
//    [menuItem setAction:@selector(showLogWindow:)];
//    [menuItem setTarget:self];
//    
//    NSNib* nib = [[NSNib alloc] initWithNibNamed:@"Logger" bundle:[NSBundle bundleWithIdentifier:@"tv.bestbefore.BBUtilities"]];
//    if( !nib )
//        NSLog(@"Error loading nib for Logger!");
//    [nib instantiateNibWithOwner:self topLevelObjects:nil];
//    [nib release];
//    
//	[messagesController setSelectsInsertedObjects:NO];
//	[messagesController setClearsFilterPredicateOnInsertion:NO];
//	
//	// Set up a timer that periodically updates the array controller content:
//	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(flushLogs) userInfo:nil repeats:YES];
//	
//	[logWindow setRepresentedFilename:[[BBLogFile applicationLogFile] path]];
//	
//	// Reopen the log window if it was open last time:
//	if ([[[NSUserDefaults standardUserDefaults] objectForKey:LogWindowVisible] boolValue])
//		[self showLogWindow:self];
//	
//	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.showLogInformation" options:0 context:NULL];
//	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.showLogWarnings" options:0 context:NULL];
//	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.showLogErrors" options:0 context:NULL];
//	[self applySearchFilter];
//}

-(void)applicationWillTerminate:(NSNotification*)notification {

	@synchronized(self) {
		[self flushLogs];
//		[[BBLogFile applicationLogFile] close];
	}
	// Make a note of whether the log window is visible, so we can auto-reopen on startup.
//	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[logWindow isVisible]] forKey:LogWindowVisible];
}

//-(IBAction)searchFieldDidChange:(id)sender
//{
//	[self applySearchFilter];
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// We're observing the showLogInformation/Warnings/Errors values.  Update the NSArrayController with a new search predicate
    if([keyPath isEqualToString:@"values.showLogInformation"] || [keyPath isEqualToString:@"values.showLogWarnings"] || [keyPath isEqualToString:@"values.showLogErrors"]){
        [self applySearchFilter];
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];   
    }
}

//-(void)applySearchFilter
//{
//	NSMutableArray* conditions = [NSMutableArray array];
//	if ([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"showLogInformation"] boolValue])
//		[conditions addObject:[NSString stringWithFormat:@"logLevel == %d", BB_LOG_INFO]];
//	if ([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"showLogWarnings"] boolValue])
//		[conditions addObject:[NSString stringWithFormat:@"logLevel == %d", BB_LOG_WARNING]];	
//	if ([[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"showLogErrors"] boolValue])
//		[conditions addObject:[NSString stringWithFormat:@"logLevel == %d", BB_LOG_ERROR]];
//	
//	NSPredicate *logLevelPredicate, *searchPredicate, *totalPredicate;
//	
//	if ([conditions count]==0)
//		logLevelPredicate = [NSPredicate predicateWithValue:NO];	// When no log levels are checked, we don't want to show anything.
//	else
//		logLevelPredicate = [NSPredicate predicateWithFormat:[conditions componentsJoinedByString:@" OR "]];
//	
//	if ([[searchField stringValue] length] > 0) {
//		searchPredicate = [NSPredicate predicateWithFormat:@"location CONTAINS[cd] %@ or message CONTAINS[cd] %@", [searchField stringValue], [searchField stringValue]];
//		totalPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(%@) AND (%@)", [logLevelPredicate predicateFormat], [searchPredicate predicateFormat]]];
//	} else {
//		totalPredicate = logLevelPredicate;
//	}
//	
//	[messagesController setFilterPredicate:totalPredicate];	
//}

// Create a new log object from the supplied parameters, and insert it into our collection
// 'location' is a pretty location for display - eg -[AppController foobar].
// 'path' should be a full absolute posix path
-(void)addLogMessage:(NSString*)message location:(NSString*)location path:(NSString*)path lineNumber:(int)lineNumber errorLevel:(BBLogErrorLevel)errorLevel {
	@synchronized(self) {
		// We want to keep track of how many lines are in the log message, so we can change the row height appropriately.
		NSInteger lineCount = 1 + [message occurrencesOfString:@"\n"];
		NSNumber* timestamp = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
		NSDictionary* newLogObject = [NSDictionary dictionaryWithObjectsAndKeys:timestamp, @"timestamp", location, @"location", path, @"filePath", message, @"message",
																				[NSNumber numberWithLong:lineCount], @"lineCount",
																				[NSNumber numberWithInt:lineNumber], @"lineNumber",
																				[NSNumber numberWithInt:errorLevel], @"logLevel", nil];
		[bufferedLogs addObject:newLogObject];
	}
}


// Convert the log object into a string suitable for dumping to file
-(NSString*)formatLogForFile:(NSDictionary *)logMsg
{
//	static TimeStampToDescriptionTransformer* timeStampFormatter = nil;
//	if (!timeStampFormatter)
//		timeStampFormatter = [[TimeStampToDescriptionTransformer alloc] init];
	
//	return [NSString stringWithFormat:@"%@ \t| %@ \t| %@:%d\n", [timeStampFormatter transformedValue:[logMsg objectForKey:@"timestamp"]],
//																[logMsg objectForKey:@"message"],
//																[[[logMsg objectForKey:@"filePath"] pathComponents] lastObject],
//																[[logMsg objectForKey:@"lineNumber"] intValue]];
	
	return nil;
}

// We don't insert logs into the array controller as they come in, since it tends to lock up the main thread during high frequency logging.
// This method gets called periodically to flush our buffer into the array controller
// Should only be performed on the main thread (NSArrayController itself appears to be thread safe, but it prompts view refreshes from the current thread too)
-(void)flushLogs {
	@synchronized(self) {
		// We want to scan for duplicate messages and flatten them down into a single message
		// If we were feeling particularly keen, we could flatten them with the existing log content, but I can't be bothered
		// (as it is, we're likely to have logs in arraycontroller that are repeated in our buffer, but not caught as repeats)
		NSMutableArray* squashedLogs = [NSMutableArray array];
		NSDictionary* previousLog = nil;
		NSDictionary* repeatMarker = nil;
		int repeatCount = 0;
		NSMutableString* logFileOutput = [NSMutableString string];
		id logMsg;
		for(logMsg in bufferedLogs) {
			if ([[previousLog objectForKey:@"message"] isEqualToString:[logMsg objectForKey:@"message"]] &&
				[[previousLog objectForKey:@"filePath"] isEqualToString:[logMsg objectForKey:@"filePath"]] &&
				[[previousLog objectForKey:@"lineNumber"] isEqual:[logMsg objectForKey:@"lineNumber"]]) {
				// Looks like we're spewing out duplicates.  Add/update our repeat marker:
				repeatCount++;
				if (!repeatMarker) {
					repeatMarker = [logMsg mutableCopy];
					[squashedLogs addObject:repeatMarker];					
				}
				[repeatMarker setValue:[NSString stringWithFormat:@"(last message repeated %d times)", repeatCount] forKey:@"message"];				
			} else {
				previousLog = logMsg;
				// We have a new log message.  That invalidates our previous repeatMarker.  Dump it to file, release it, and continue
				if (repeatMarker) {
					[logFileOutput appendString:[self formatLogForFile:repeatMarker]];
					[repeatMarker release]; repeatMarker = nil;
					repeatCount = 0;
				}
				[squashedLogs addObject: logMsg];
				
				[logFileOutput appendString:[self formatLogForFile: logMsg]];
			}
		}
		
		if (repeatMarker) {  // If we were halfway through a repeat sequence when we finished squashing, we'll still have a repeat marker to dump to file:
			[logFileOutput appendString:[self formatLogForFile:repeatMarker ]];
			[repeatMarker release];
		}
		
		// Finally, we're ready to insert our nicely formatted log array.
		// However, updating NSArrayController content is relatively expensive.  Don't do it unless the log window is on screen:
//		if ([logWindow isVisible]) {
//			NSArray* pendingLogs = [arrayControllerLogBuffer arrayByAddingObjectsFromArray:squashedLogs];
//			[self insertControllerObjects:pendingLogs];
//			[arrayControllerLogBuffer removeAllObjects];
//		} else {
			[arrayControllerLogBuffer addObjectsFromArray:squashedLogs];	// When offscreen, store our logs for when we come onscreen again
//		}
		// And we don't need our buffered objects anymore
		[bufferedLogs removeAllObjects];
		
//		[[BBLogFile applicationLogFile] write:logFileOutput];
		
	}
}


//-(void)insertControllerObjects:(id)objects {
//	// So instead, we have to save the selection, get the content, add the new object to that content, then set the entire controller content again.
//	NSArray* originalSelection = [messagesController selectedObjects];
//	NSArray* newContent = [[messagesController content] arrayByAddingObjectsFromArray:objects];
//	[messagesController setContent:newContent];
//	[messagesController setSelectedObjects:originalSelection];
//}

//-(IBAction)showLogWindow:(id)sender {
//    [logWindow makeKeyAndOrderFront:self];
//}

//- (IBAction)clearLog:(id )sender {
//	@synchronized (self) {
//		[messagesController setContent:[NSArray array]];
//	}
//}

//- (IBAction)emailLogs:(id)sender {
//	[emailController launchForWindow:logWindow];
//}

// Annoyingly, you can't bind cell tooltips.  Delegate method for them, instead.
// Note that this is flakey as hell - adding new rows to the table will reset the tooltip timer, so you may never get a tooltip displayed if you're adding rows every second.
// (Oddly, the tooltips work fine when the window isn't the foreground window...)
//-(NSString *)tableView:(NSTableView *)tv toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect	tableColumn:(NSTableColumn *)tc row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
//	return [[[messagesController arrangedObjects] objectAtIndex:row] valueForKey:@"location"];
//}

//- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
//	// We hijack the edit action to open our source file, if it exists
//	NSString* filePath = [[[messagesController arrangedObjects] objectAtIndex:rowIndex] valueForKey:@"filePath"];
//	int lineNum = [[[[messagesController arrangedObjects] objectAtIndex:rowIndex] valueForKey:@"lineNumber"] intValue];
//	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//		openFileAtLineNum(filePath, lineNum);
//	}
//	return NO;
//}

// Vary our row height based on the number of newlines in the log message
//- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)rowIndex {
//	NSInteger numLines = [[[[messagesController arrangedObjects] objectAtIndex:rowIndex] valueForKey:@"lineCount"] intValue];
//	return [tableView rowHeight]*numLines;
//}

@end


//@implementation LogLevelToColorTransformer
//
//+ (Class)transformedValueClass
//{
//    return [NSColor class];
//}
//
//+ (BOOL)allowsReverseTransformation
//{
//    return NO;
//}
//
//- (NSColor*)transformedValue:(NSNumber*)logLevelNumber
//{
//	NSAssert([logLevelNumber intValue]<BB_LOG_COUNT, @"Something's gone very wrong with log color transforms");
//	
//	static NSColor* colors[BB_LOG_COUNT];
//	if (colors[0]==NULL) {
//		colors[BB_LOG_INFO] = [[NSColor grayColor] retain];
//		colors[BB_LOG_WARNING] = [[NSColor blackColor] retain];
//		colors[BB_LOG_ERROR] = [[NSColor redColor] retain];
//	}
//	return colors[[logLevelNumber intValue]];
//}
//
//@end

//@implementation TimeStampToDescriptionTransformer
//
//+ (Class)transformedValueClass
//{
//    return [NSString class];
//}
//
//+ (BOOL)allowsReverseTransformation
//{
//    return NO;
//}
//
//- (NSString*)transformedValue:(NSNumber*)timeStamp
//{
//	// NSDate's descriptionWithCalendarFormat is spectacularly slow.  Use our own custom version
//	static NSTimeInterval midnight = 0;
//	if (midnight == 0) {
//		midnight = [[NSDate dateWithString:	[[NSDate date] descriptionWithCalendarFormat: @"%Y-%m-%d 00:00:00 +0000"
//																				timeZone:nil
//																				  locale:nil]] timeIntervalSinceReferenceDate];
//		midnight -= [[NSTimeZone localTimeZone] secondsFromGMT];	// The reference date timestamp is gmt-relative
//	}
//	
//	NSTimeInterval timestampInterval = [timeStamp doubleValue]-midnight;
//	int milliseconds = (long long)(timestampInterval*1000) % 1000;
//	long long intervalSeconds = timestampInterval;
//	int seconds = intervalSeconds%60;
//	long long intervalMinutes = intervalSeconds/60;
//	int minutes = intervalMinutes%60;
//	long long intervalHours = intervalMinutes/60;
//	int hours = intervalHours%24;
//	return [NSString stringWithFormat:@"%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds];
//}
//
//@end
