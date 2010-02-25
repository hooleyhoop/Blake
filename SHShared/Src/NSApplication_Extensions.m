//
//  NSApplication_Extensions.m
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSApplication_Extensions.h"
#import "SHDocument.h"
#import "BBLogger.h"

#import <AppKit/NSApplicationScripting.h>
#import <AppKit/NSWindow.h>

@implementation NSApplication (NSApplication_Extensions)

- (NSArray *)openDocs {
	
	NSArray *allDocs = [self orderedDocuments];
	NSMutableArray *openDocs = [NSMutableArray array];

	for( SHDocument *doc in allDocs ){
		if([doc isClosed]==NO)
			[openDocs addObject:doc];
	}
	return openDocs;
}

- (NSWindow *)myMainWindow {

	NSWindow *mainWindow=nil;
    NSArray *allWindows = [self orderedWindows];
    for( NSWindow *aWindow in allWindows ){
        if([aWindow canBecomeMainWindow]){
            mainWindow = aWindow;
            break;
        }
    }
	return mainWindow;
}

- (void)setAboutPanelClass:(Class)aClass {
	
}

static BOOL debugAltKeyOveride = NO;
- (BOOL)altKeyDown {
	
	/* For unitTests - we can pretend the alt key is down */
	if(debugAltKeyOveride){
		debugAltKeyOveride = NO;
		return YES;
	}
	
	BOOL alt_pressed = NO;
	CGEventRef event = CGEventCreate(NULL /*default event source*/);
	CGEventFlags mods = CGEventGetFlags(event);
	if (mods & kCGEventFlagMaskAlternate)
		alt_pressed = YES;
	CFRelease(event);
	return alt_pressed;
}

- (void)oneShotOverideAltKeyDown {
	debugAltKeyOveride = YES;
}
@end
