//
//  Text.m
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Text.h"


@implementation Text

+ (NSLayoutManager *)sharedLayoutManager {
	
    // Return a layout manager that can be used for any drawing.
    static NSLayoutManager *layoutManager = nil;
    if (!layoutManager) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:NSMakeSize(1.0e7f, 1.0e7f)];
		layoutManager = [[NSLayoutManager alloc] init];
		[textContainer setWidthTracksTextView:NO];
        [textContainer setHeightTracksTextView:NO];
        [layoutManager addTextContainer:textContainer];
        [textContainer release];
    }
    return layoutManager;
}

//! Need to add this 		_allowsSubpatches = NO;

- (void)dealloc {
	
    [_contents setDelegate:nil];
    [_contents release];
    [super dealloc];	
}

/* Recalculate computed values. Only ever called from private evaluate once per frame */
- (BOOL)execute:(id)fp8 head:(id)np time:(double)timeKey arguments:(id)fp20
{	
	return YES;
}

- (void)enforceConsistentState {
	
    [self recalculateDrawingBounds];
}

- (void)recalculateDrawingBounds {
	
	if(_drawingBoundsDidChange==YES)
	{
		_drawingBoundsDidChange = NO; // need to do this first, altho seems dodgy
		
		/* This clearly shows that this is a shit way to do the selection */
		NSRect currentSelectedBounds = self.drawingBounds; // we need to do this to get the decorators current bounds
		_drawingBounds = [self transformedGeometryRectBoundingBox];
		
		// add on our differences between drawing bounds and geometry here, eg stroke width, etc.
		
		[self setDirtyRect:NSUnionRect(self.drawingBounds, currentSelectedBounds)]; // again make sure we use the decorator's drawing bounds
	}
}

- (void)_customDrawing {
	
	NSTextStorage *contents = [self contents]; 
	if( [contents length]>0 )
	{
	    // Get a layout manager, size its text container, and use it to draw text. -glyphRangeForTextContainer: forces layout and tells us how much of text fits in the container.
	    NSLayoutManager *layoutManager = [[self class] sharedLayoutManager];
	    NSTextContainer *textContainer = [[layoutManager textContainers] objectAtIndex:0];
	    [textContainer setContainerSize:_geometryRect.size];
	    [contents addLayoutManager:layoutManager];
		NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
	    if( glyphRange.length>0 )
		{
			[layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:_geometryRect.origin];
			[layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:_geometryRect.origin];
	    }
	    [contents removeLayoutManager:layoutManager];		
	}
}

- (NSTextStorage *)contents {
	
    // Never return nil.
    if (!_contents) {
		_contents = [[NSTextStorage alloc] init];
		[_contents.mutableString setString:@"steven steven steven steven steven steven steven steven"];
		// We need to be notified whenever the text storage changes.
		[_contents setDelegate:self];
    }
    return _contents;
}

@end
