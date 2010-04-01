//
//  CustomMouseDragSelectionEventLoop.m
//  DebugDrawing
//
//  Created by steve hooley on 05/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "CustomMouseDragSelectionEventLoop.h"


@implementation CustomMouseDragSelectionEventLoop

@synthesize windowEvent = _windowEvent;

+ (id)eventLoopWithWindow:(NSWindow *)wind {
	
	return [[[CustomMouseDragSelectionEventLoop alloc] initWitWindow:wind] autorelease];
}

- (id)initWitWindow:(NSWindow *)wind {
	
	self = [super init];
	if(self){
		_window = [wind retain];
	}
	return self;
}

- (void)dealloc {

	[_window release];
	[super dealloc];
}

- (void)loopWithCallbackObject:(id)ob method:(SEL)callback data:(NSDictionary *)callbackData {
	
	NSAssert( _window, @"need a window to loop" );
	
	BOOL dragActive = YES;

	NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
	while (dragActive) 
	{
		self.windowEvent = [_window nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)
									  untilDate:[NSDate distantFuture]
										 inMode:NSEventTrackingRunLoopMode
										dequeue:YES];	
	
		if(!_windowEvent)
			continue;
	
		_eventPt = [_windowEvent locationInWindow];
		switch ([_windowEvent type]) {
	
			case NSLeftMouseDragged:
				[ob performSelector:callback withObject:callbackData];
				break;
				
			case NSLeftMouseUp:
				dragActive = NO;
				break;
				
			default:
				break;
		}
	}
	[myPool release];
}

- (NSPoint)eventPt {

	NSAssert( _windowEvent, @"need to be in the loop to get an mouse event" );
	return _eventPt;
}

@end
