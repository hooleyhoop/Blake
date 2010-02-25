//
//  SHPanel.m
//  SHShared
//
//  Created by steve hooley on 31/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHPanel.h"

@implementation SHPanel

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
	
	if( (self=[super initWithContentRect: contentRect styleMask: windowStyle backing: bufferingType defer: deferCreation])!=nil){
		[self setLevel:NSFloatingWindowLevel];

		// You should always set optimizedDrawing to YES when there are no overlapping subviews within the receiver. The default is NO.
		//-- dont think a panel can use optimized drawing
		[self useOptimizedDrawing: YES];
		
		//-- dont think a panel can be oneShot??
		[self setOneShot:YES];
		[self setReleasedWhenClosed:YES];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

@end
