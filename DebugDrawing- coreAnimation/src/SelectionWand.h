//
//  SelectionWand.h
//  DebugDrawing
//
//  Created by shooley on 12/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "ModelTool.h"

@class SelectingSceneManipulation;

@interface SelectionWand : ModelTool {
	
	// The bounds of the marquee selection, if marquee selection is being done right now, NSZeroRect otherwise.
	CGRect						_marqueeSelectionBounds;
	
	SelectingSceneManipulation	*_selectionHelper;
	NSIndexSet					*_initialSelection;
}

@property (readwrite) CGRect marqueeSelectionBounds;
@property (readonly) NSIndexSet *initialSelection;

+ (CGRect)marqueeSelectionBoundsFromPoint:(NSPoint)point1 toPoint:(NSPoint)point2;

- (id)initWithDomainContext:(DomainContext *)dc selectionHelper:(SelectingSceneManipulation *)value;

- (void)didClickOnGraphic:(SHNode *)graphic modifyingExistingSelection:(BOOL)isModifyingSelection;
- (void)mouseDownInEmptySpaceModifyingExistingSelection:(BOOL)isModifyingSelection;

- (void)beginModifyingSelectionWithMarquee;
- (void)endModifyingSelectionWithMarquee;

- (void)setMarqueeSelectionBounds:(CGRect)newMarqueeBounds;

@end
