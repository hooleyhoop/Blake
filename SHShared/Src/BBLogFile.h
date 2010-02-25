//
//  BBLogFile.h
//  BBUtilities
//
//  Created by Jonathan del Strother on 18/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

// Writes our log files to disk, handles log rotation & initialization
@interface BBLogFile : _ROOT_OBJECT_ {
	NSFileHandle* logFileHandle;
	NSString* basename;
}
+(NSArray*)crashLogFilePaths;		// Perhaps not strictly relevant to this class, but this returns all our crash reports
+(id)applicationLogFile;		// BBLogFile initalized for the current application name (from NSBundle mainBundle)
-(id)initWithBaseName:(NSString*) base;	// Base name for the log file (eg 'MCreate')
-(void)write:(NSString*)string;
-(void)close;				// Closes & flushes the log file.  Any future attempts to write are going to fail miserably.
-(NSString*)path;			// Return the full log file path (eg /Users/jon/Library/Logs/BestBefore/MCreate.log)
-(NSArray*)archivedPaths;	// Previous log files are kept and rotated (eg MCreate.0.log, MCreate.1.log...).  This returns an array of all relevant log files paths
@end
