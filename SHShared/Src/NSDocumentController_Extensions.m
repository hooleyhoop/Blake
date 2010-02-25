//
//  NSDocumentController_Extensions.m
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSDocumentController_Extensions.h"
#import <Appkit/NSApplication.h>
#import <Appkit/NSWindowController.h>
#import <Appkit/NSApplicationScripting.h>

@implementation NSDocumentController (NSDocumentController_Extensions)

/* Im not sure this is correct..? You cant close a doc by calling document close tho.. as when the last window closes that will call close */
- (void)tryToCloseDoc:(NSDocument *)aDoc {
    
	NSParameterAssert(aDoc);

    NSArray *allDocs = [self documents];
	NSAssert([allDocs containsObject:aDoc], @"Trying to close a doc we are not managing");

	// - closing all windows should close the doc?
	NSArray *windowControllers = [aDoc windowControllers];
	if( [windowControllers count] )
		for( NSWindowController *aWC in windowControllers )
			[aWC close];
	else
		[aDoc close];
}

- (void)closeAll {
    
	NSArray* allDocs = [self documents];
	NSMutableArray *allDocWindows = [NSMutableArray array];
	for( NSDocument *eachDoc in allDocs ){
		NSArray* allWindwControllers = [eachDoc windowControllers];
		for( NSWindowController *winControl in allWindwControllers ) {
			NSWindow *docWin = [winControl window];
			if(docWin)
				[allDocWindows addObject:docWin];
		}
	}
	// -- close all windowz
	[[NSApplication sharedApplication] makeWindowsPerform:@selector(close) inOrder:NO];	
	
	// close all docs
	[self closeAllDocumentsWithDelegate:self didCloseAllSelector:@selector(documentController:didCloseAll:contextInfo:) contextInfo:nil];

	// clean up any delayed perform selectors
	for( NSWindow *win in allDocWindows ){
        //hm		[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget: win];
	}
}

- (NSDocument *)frontDocument {
    
	NSDocument *frontDocument = nil;
	
	// orderedDocuments of course refers to window order. Not creation order or anything else.
	// ThereFor this will have unspecified results if windows are not visible
	NSArray *orderedDocs = [NSApp orderedDocuments];
	if([orderedDocs count]>0)
		frontDocument = [orderedDocs objectAtIndex:0];
	return frontDocument;
}

@end
