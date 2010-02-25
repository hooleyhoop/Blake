//
//  CustomMouseDragSelectionEventLoop.h
//  DebugDrawing
//
//  Created by steve hooley on 05/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface CustomMouseDragSelectionEventLoop : _ROOT_OBJECT_ {

	NSWindow *_window;
	NSEvent *_windowEvent;
	NSPoint _eventPt;
}

@property (retain) NSEvent *windowEvent;

+ (id)eventLoopWithWindow:(NSWindow *)wind;
- (id)initWitWindow:(NSWindow *)wind;

- (void)loopWithCallbackObject:(id)ob method:(SEL)callback data:(NSDictionary *)callbackData;

- (NSPoint)eventPt;

@end
