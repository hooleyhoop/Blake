//
//  NSWindowController_Extras.m
//  SHShared
//
//  Created by steve hooley on 08/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "NSWindowController_Extras.h"


@implementation NSWindowController (NSWindowController_Extras)


- (BOOL)isWindowShown {

    return [[self window] isVisible];
}

- (void)showOrHideWindow {

    // Simple.
    NSWindow *window = [self window];
    if ([window isVisible]) {
		[window orderOut:self];
    } else {
		[self showWindow:self];
    }

}


@end
