//
//  SHMainWindowDelegate.m
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

#import "SHAuxWindowDelegate.h"
#import "SHAuxWindow.h"
#import "SHViewport.h"
#import <SHShared/BBLogger.h>

@implementation SHAuxWindowDelegate


//
//
- (id)init:(SHAuxWindow*)SHMainWindowArg
{
    if ((self = [super init]) != nil)
    {
        _theWindow = SHMainWindowArg;
    }
    return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
    _theWindow = nil;
    [super dealloc];
}

// ===========================================================
// - windowDidResize
// ===========================================================
- (void) windowDidResize:(NSNotification *)aNotification
{
	// NSLog(@"SHMainWindowDelegate.m: Window did resize");
    [_theWindow layOutAtNewSize];
}


// ===========================================================
// - windowWillClose
// ===========================================================
- (void)windowWillClose:(NSNotification *)aNotification
{
	logInfo(@"SHAuxWindowDelegate.m: Window will close");
    [[_theWindow viewport] willCloseWindow];
}


@end
