//
//  SHWindow.m
//  SHShared
//
//  Created by steve hooley on 31/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHWindow.h"

@implementation SHWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
	
	if( (self=[super initWithContentRect: contentRect styleMask: windowStyle backing: bufferingType defer: deferCreation])!=nil){
		[self setLevel:NSNormalWindowLevel];

		// You should always set optimizedDrawing to YES when there are no overlapping subviews within the receiver. The default is NO.
		[self useOptimizedDrawing: YES];
		[self setReleasedWhenClosed:YES];
		[self setOneShot:YES];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

// send events up the responder chain
- (void)sendEvent:(NSEvent *)anEvent {

//    if ([anEvent type]==NSKeyDown) {
//		NSLog(@"sendEvent: blah lah");
 //   } else {
        [super sendEvent: anEvent];
//    }
}

// more complex than send event, first up the responder chain, then to other viewControllers in other
// responder chains, also to window delegates and NSApp delegate which aren't NSResponders
//- (BOOL)sendAction:(SEL)anAction to:(id)aTarget from:(id)sender {
//
//	return [super sendAction:anAction to:aTarget from:sender];
//}

@end
