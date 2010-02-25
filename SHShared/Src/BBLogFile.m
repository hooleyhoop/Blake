//
//  BBLogFile.m
//  BBUtilities
//
//  Created by Jonathan del Strother on 18/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

#import "BBLogFile.h"
#import "NSBundle+Extras.h"
//#import "NSFileManager_Extras.h"

static id logExtensions[] = {@"log", @"0.log", @"1.log", @"2.log", @"3.log", @"4.log", @"5.log", @"6.log", @"7.log", @"8.log", @"9.log"};
static int logCount = 11;

@interface BBLogFile(private)
-(NSString*)logPrefix;
@end

@implementation BBLogFile

+(NSString*)logDir {
	return [@"~/Library/Logs/BestBefore" stringByExpandingTildeInPath];
}
+(NSString*)applicationLogName {
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
}

+(id)applicationLogFile {
	static BBLogFile* applicationLogFile = nil;
	@synchronized(self) {
		if (!applicationLogFile)
			applicationLogFile = [[self alloc] initWithBaseName:[self applicationLogName]];
	}
	return applicationLogFile;
}

+(NSArray*)crashLogFilePaths {

	NSString* crashDir = [@"~/Library/Logs/CrashReporter/" stringByExpandingTildeInPath];
	NSArray* crashes = [[NSFileManager defaultManager] directoryContentsAtPath:crashDir];
	NSMutableArray* ourCrashes = [NSMutableArray array];

	for( id crashh in crashes ) {
		// Scan through all the crash files, picking out the ones that start with our app name
		if ([crashh rangeOfString:[self applicationLogName]].location==0)
			[ourCrashes addObject:[crashDir stringByAppendingPathComponent: crashh]];
	}
	return [[ourCrashes copy] autorelease];
}

-(id) init {
	[self doesNotRecognizeSelector:_cmd];
	[self release];
	return nil;
}
- (id) initWithBaseName:(NSString*) base {
	if ( (self = [super init]) ) {
		basename = [base copy];
		// We store logs in ~/Library/Logs/BestBefore, and keep the last 10 log files for the app.
		// We need to prepare this directory & rotate any existing log files in it.
		NSError* errorInfo=nil;
		NSFileManager* mgr = [NSFileManager defaultManager];
		if (![mgr createDirectoryAtPath:[BBLogFile logDir] withIntermediateDirectories:YES attributes:nil error:&errorInfo]) {
			fprintf(stderr, "Couldn't create dir : %s\n", [[errorInfo localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
		} else {
			// Rotate out existing log files (Player.log -> Player.0.log -> Player.1.log -> ... -> Player.9.log)
			NSString* oldestLogFile = [[self logPrefix] stringByAppendingPathExtension:logExtensions[logCount-1]];
			if ([mgr fileExistsAtPath:oldestLogFile] && ![mgr removeFileAtPath:oldestLogFile handler:nil])
				fprintf(stderr, "Couldn't drop oldest log file\n");
			for(int i=logCount-2; i>=0; i--) {
				NSString* fromFile = [[self logPrefix] stringByAppendingPathExtension:logExtensions[i]];
				NSString* toFile = [[self logPrefix] stringByAppendingPathExtension:logExtensions[i+1]];
				if ([mgr fileExistsAtPath:fromFile] && ![mgr movePath:fromFile toPath:toFile handler:nil]) {
					fprintf(stderr, "Couldn't rotate log file %s to %s\n", [fromFile fileSystemRepresentation], [toFile fileSystemRepresentation]);
					break;
				}
			}
			
			NSString* logFile = [self path];
			[mgr createFileAtPath:logFile contents:nil attributes:nil];
			
			[NSException raise:@"is this used?" format:@""];
			
			logFileHandle = [[NSFileHandle fileHandleForWritingAtPath:logFile] retain];		// TODO : We probably ought to rotate our own log files when they get really big during program executation.  Likely to happen if we're ever running a 24 hour show...
			
			if (!logFileHandle)
				fprintf(stderr, "Couldn't create output file handle at %s", [logFile fileSystemRepresentation]);
			
			// Add a log file header containing useful info : 
			NSString* header = [NSString stringWithFormat:@"%@\n", [NSDate date]];
			header = [header stringByAppendingFormat:@"%@\n", [[NSBundle mainBundle] nameAndVersionString]];
			NSBundle* framework = nil;
			
			if ( (framework=[NSBundle bundleWithIdentifier:@"tv.bestbefore.BBUtilities"]) )
				header = [header stringByAppendingFormat:@"- %@\n", [framework nameAndVersionString]];
			
			if ( (framework=[NSBundle bundleWithIdentifier:@"tv.bestbefore.BBExtras"]) )
				header = [header stringByAppendingFormat:@"- %@\n", [framework nameAndVersionString]];
			
			if ( (framework=[NSBundle bundleWithIdentifier:@"tv.bestbefore.BBView"]) )
				header = [header stringByAppendingFormat:@"- %@\n", [framework nameAndVersionString]];
			
			header = [header stringByAppendingString:@"==========================\n"];
			
			[logFileHandle writeData:[header dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	return self;
}

-(void)dealloc {
	[logFileHandle closeFile];
	[logFileHandle release];
	[basename release];
	[super dealloc];
}


// Return the current log file name (eg /Users/jon/Library/Logs/BestBefore/MCreate.log)
-(NSString*)path {
	return [[self logPrefix] stringByAppendingPathExtension:@"log"];
}

// Returns an array of all previous and current log file paths
-(NSArray*)archivedPaths {
	NSMutableArray* logs = [NSMutableArray array];
	
	for(int i=0; i<logCount; i++) {
		NSString* logFile = [[self logPrefix] stringByAppendingPathExtension:logExtensions[i]];
		if ([[NSFileManager defaultManager] fileExistsAtPath:logFile])
			[logs addObject:logFile];		
	}
	return [[logs copy] autorelease];
}



// Returns the full file path, minus the extension (eg /Users/jon/Library/Logs/BestBefore/MCreate)
-(NSString*)logPrefix {
	return [[BBLogFile logDir] stringByAppendingPathComponent:basename];
}


-(void)write:(NSString*)string
{
	[logFileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}
-(void)close {
	[logFileHandle closeFile];
}

@end
