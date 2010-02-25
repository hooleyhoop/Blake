//
//  BlakeGlobalCommandController.m
//  Pharm
//
//  Created by Steve Hooley on 15/07/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "BlakeGlobalCommandController.h"
#import "BlakeDocument.h"
#import "BlakeDocumentController.h"
#import "HighLevelBlakeDocumentActions.h"
#import "SHApplication_Extras.h"

#pragma mark -

static BlakeGlobalCommandController *sharedGlobalCommandController=nil;

@interface BlakeGlobalCommandController ()

- (BOOL)pasteboardHasData;

@end

#pragma mark -

@implementation BlakeGlobalCommandController

#pragma mark -
#pragma mark class methods
+ (BlakeGlobalCommandController *)sharedGlobalCommandController {
	
	if(!sharedGlobalCommandController)
		sharedGlobalCommandController = [[BlakeGlobalCommandController alloc] init];
	return sharedGlobalCommandController;
}
+ (void)cleanUpSharedGlobalCommandController {
	
	[sharedGlobalCommandController release];
	sharedGlobalCommandController = nil;
}

#pragma mark init methods
- (id)init {
	
	self = [super init];
	if( self ) {
		// I do this so we dont reference these singletons all over the place which is difficult to test
		_documentController = [BlakeDocumentController sharedDocumentController];
		_sharedApp = [NSApplication sharedApplication];
	}
	return self;
}

- (void)dealloc {
    
    [super dealloc];
}

#pragma mark action methods

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {

	NSString *fileName = [filenames lastObject];
	[self application:sender openFile:fileName];
}

// bind paste to this
- (BOOL)pasteboardHasData {
    
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObject:NSStringPboardType];
    NSString *bestType = [pb availableTypeFromArray:types];
    return (bestType != nil);
}

/* Used When you drop a file on the dock icon  or double click a doc */
- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
	
	NSAssert(_documentController, @"need a _documentController");
	
	NSError *error;
	NSURL *fileURL = [NSURL fileURLWithPath:filename];
	id doc = [_documentController openDocumentWithContentsOfURL:fileURL display:YES error:&error];
	if(!doc)
		if(error)
			logError(@"got an error opening document");
	return( doc!=nil);
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {

	NSAssert(_documentController, @"need a _documentController");

	NSUInteger currentDocs = [[_documentController documents] count];
	if( currentDocs==0 )
		return YES;
	return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {

	NSAssert( _documentController, @"need a _documentController");

	//	if (flag) {
	//		NSWindow *mainWindow = [[SSEMainWindowController mainWindowController] window];
	//		if (mainWindow && [mainWindow isMiniaturized])
	//			[mainWindow deminiaturize:nil];
	//	} else {
	//		[self showMainWindow:nil];
	//	}	

	NSUInteger currentDocs = [[_documentController documents] count];
	if( currentDocs!= 0 )
		return YES;
	return NO;
}


@end
