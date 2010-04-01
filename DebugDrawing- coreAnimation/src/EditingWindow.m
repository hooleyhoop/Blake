//
//  EditingWindow.m
//  DebugDrawing
//
//  Created by steve hooley on 18/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "EditingWindow.h"


@implementation EditingWindow

//+ (id)alloc {
//	return [super alloc];
//}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {

	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	if(self){
		[self useOptimizedDrawing:YES];
		[self setPreferredBackingLocation: NSWindowBackingLocationVideoMemory];
	}
	return self;
}

//- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
//	
//	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
//	if(self){
//		[self useOptimizedDrawing:YES];
//		[self setPreferredBackingLocation: NSWindowBackingLocationVideoMemory];
//	}
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//
//	self = [super initWithCoder:aDecoder];
//	if(self){
//		[self useOptimizedDrawing:YES];
//		[self setPreferredBackingLocation: NSWindowBackingLocationVideoMemory];
//	}
//	return self;
//}

//- (void)dealloc {
//
//	[super dealloc];
//}



@end
