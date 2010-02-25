//
//  BKRuleEditorView.m
//  SmartFolder
//
//  Created by Jesse Grosjean on 9/13/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKRuleEditorView.h"


@implementation BKRuleEditorView

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (BOOL)isFlipped {
	return YES;
}

- (float)updateLayoutReturningChangeInHeight {
	NSRect startFrame = [self frame];
	
	NSEnumerator *enumerator = [[[[self subviews] copy] autorelease] objectEnumerator];
	NSView *each;
	
	float yOffset = 0;
	
	while (each = [enumerator nextObject]) {
		[each setFrameOrigin:NSMakePoint(0, yOffset)];
		yOffset += [each frame].size.height;
	}
	
	NSRect endFrame = startFrame;
	endFrame.size.height = yOffset;
	float changeInHeight = endFrame.size.height - startFrame.size.height;
		
	[self setFrameSize:endFrame.size];
	[self setFrameOrigin:NSMakePoint(endFrame.origin.x, endFrame.origin.y - changeInHeight)];
	
	return changeInHeight;
}

@end
