//
//  SHMainWindowDelegate.m
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

#import "SHMainWindowDelegate.h"
#import "SHMainWindow.h"

@implementation SHMainWindowDelegate


//=========================================================== 
// init
//=========================================================== 
- (id)init:(SHMainWindow*)SHMainWindowArg
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


//=========================================================== 
// windowDidResize
//=========================================================== 
- (void) windowDidResize:(NSNotification *)aNotification
{
	// NSLog(@"SHMainWindowDelegate.m: Window did resize");
    [_theWindow layOutAtNewSize];
}


@end
