//
//  SketchPanel.m
//  BlakeLoader2
//
//  Created by steve hooley on 21/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SketchPanel.h"


@implementation SketchPanel

//- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
//	
//	self = [super initWithContentRect: contentRect styleMask: windowStyle backing: bufferingType defer: deferCreation];
//	return self;
//}

- (void)awakeFromNib {

	/* QuartzGL http://developer.apple.com/qa/qa2007/qa1536.html */
	
	/* Fiddling to get the window to use optimized drawing */
	[self setPreferredBackingLocation: NSWindowBackingLocationVideoMemory];
}

//
//- (id)retain {
//	return [super retain];
//}
//
//- (void)release {
//
//	logInfo(@"Panel retainCount is %i", [self retainCount]-1);
//	[super release];
//}

//- (void)dealloc {
//
//	[super dealloc];
//}

@end
