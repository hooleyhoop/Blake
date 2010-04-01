//
//  BKCrashReporterController.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKCrashReporterController.h"
#import "BKPluginRegistry.h"


@implementation BKCrashReporterController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma dealloc

- (id)init {
    if (self = [super initWithWindowNibName:@"BKCrashReporterWindow"]) {
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma awake from nib like methods

- (void)awakeFromNib {
	[statusMessageTextField setStringValue:@""];
	[[self window] setLevel:NSFloatingWindowLevel];
}

#pragma mark accessors

- (NSURL *)crashReportURL {
	return [NSURL URLWithString:[[NSApp delegate] applicationCrashReportURLString]];
}

- (NSString *)crashPath {
    return [[NSString stringWithFormat:@"~/Library/Logs/CrashReporter/%@.crash.log", [[NSProcessInfo processInfo] processName]] stringByExpandingTildeInPath];
}

- (NSString *)exceptionPath {
    return [[NSString stringWithFormat:@"~/Library/Logs/CrashReporter/%@.exception.log", [[NSProcessInfo processInfo] processName]] stringByExpandingTildeInPath];
}

- (void)setStatusMessage:(NSString *)message {
    if ([message length]) {
		[statusProgressIndicator startAnimation:nil];
    } else {
		[statusProgressIndicator stopAnimation:nil];
    }
    
    [statusMessageTextField setStringValue:message];
    [statusMessageTextField display];
}

#pragma mark actions

- (IBAction)check:(id)sender {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *crashPath = [self crashPath];
	NSString *exceptionPath = [self exceptionPath];
	
	if ([fileManager fileExistsAtPath:crashPath] || [fileManager fileExistsAtPath:exceptionPath]) {
		NSWindow *window = [self window];
		NSMutableString *crashReport = [NSMutableString string];
		NSString *processName = [[NSProcessInfo processInfo] processName];
		
		[statusProgressIndicator setUsesThreadedAnimation:YES];
		
		[window setTitle:[NSString stringWithFormat:[window title], processName]];
		[titleTextField setStringValue:[NSString stringWithFormat:[titleTextField stringValue], processName]];
		
		[window center];
		[window orderFront:self];
		
		if ([fileManager fileExistsAtPath:crashPath]) {
			NSString *crashLog = [NSString stringWithContentsOfFile:crashPath];
			if ([crashLog length] > 0) {
				[crashReport appendString:crashLog];
			}
			[fileManager removeFileAtPath:crashPath handler:nil];
		}
		
		if ([fileManager fileExistsAtPath:[self exceptionPath]]) {
			NSString *exceptionLog = [NSString stringWithContentsOfFile:exceptionPath];
			if ([exceptionLog length] > 0) {
				[crashReport appendString:exceptionLog];
			}
			[fileManager removeFileAtPath:exceptionPath handler:nil];
		}
		
		NSTextStorage *textStorage = [crashLogTextView textStorage];
		
		[textStorage beginEditing];
		[textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:crashReport];
		[textStorage endEditing];
	}
}

- (IBAction)sendReport:(id)sender {
    NSMutableDictionary *crashReport = [NSMutableDictionary dictionary];
    
    [crashReport setObject:[emailTextField stringValue] forKey:@"email"];
    [crashReport setObject:[[problemDescriptionTextView textStorage] string] forKey:@"description"];
    [crashReport setObject:[[crashLogTextView textStorage] string] forKey:@"log"];
    
    NSMutableString *reportString = [[[NSMutableString alloc] init] autorelease];
    NSEnumerator *enumerator = [[crashReport allKeys] objectEnumerator];
    NSString *key;
	
    while(key = [enumerator nextObject]) {
		if ([reportString length] != 0) [reportString appendString:@"&"];
		[reportString appendFormat:@"%@=%@", key, [[crashReport objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSData *data = nil;
	
    while(!data || [data length] == 0) {
		NSError *error;
		NSURLResponse *reply;
		NSMutableURLRequest *request;
		
		request = [NSMutableURLRequest requestWithURL:[self crashReportURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
		[request addValue:[[NSProcessInfo processInfo] processName] forHTTPHeaderField:[NSString stringWithFormat:@"%@-Bug-Report", [[NSProcessInfo processInfo] processName]]];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:[reportString dataUsingEncoding:NSUTF8StringEncoding]];
		
		[self setStatusMessage:BKLocalizedString(@"Sending Report...", nil)];
		data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reply error:&error];
		[self setStatusMessage:@""];
		
		if (!data || [data length] == 0) {
			if (NSRunAlertPanel(BKLocalizedString(@"Unable to send crash report", nil),
								[error localizedDescription],
								BKLocalizedString(@"Try Again", nil), 
								BKLocalizedString(@"Cancel", nil),
								nil) == NSAlertAlternateReturn) {
				break;
			}
		} else {
			NSRunAlertPanel(BKLocalizedString(@"Thank You", nil),
							BKLocalizedString(@"The crash report has been sent.", nil),
							BKLocalizedString(@"OK", nil), 
							nil,
							nil);
		}
    }
	
	[self close];
}

- (IBAction)ignore:(id)sender {
	[self close];
}

@end
