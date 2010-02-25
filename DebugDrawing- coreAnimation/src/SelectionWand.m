//
//  SelectionWand.m
//  DebugDrawing
//
//  Created by shooley on 12/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "SelectionWand.h"
#import "LayerFamiliar.h"
#import "SelectingSceneManipulation.h"
#import "Graphic.h"
#import "CALayerStarView.h"
//#import "MathUtilities.h"
#import "DomainContext.h"
#import "StarScene.h"

/* 
 *
*/
@implementation SelectionWand

@synthesize marqueeSelectionBounds = _marqueeSelectionBounds;
@synthesize initialSelection = _initialSelection;

#pragma mark -
#pragma mark Class methods
+ (CGRect)marqueeSelectionBoundsFromPoint:(NSPoint)point1 toPoint:(NSPoint)point2 {
	
	CGRect smallestRect = smallestRectEnclosingPoints( NSPointToCGPoint(point1), NSPointToCGPoint(point2) );
	if(smallestRect.size.width<2.0f)
		smallestRect.size.width=2.0f;
	if(smallestRect.size.height<2.0f)
		smallestRect.size.height=2.0f;
	return smallestRect;
}

#pragma mark Init methods
- (id)initWithDomainContext:(DomainContext *)dc selectionHelper:(SelectingSceneManipulation *)value {
	
	NSParameterAssert(dc);

	self = [super initWithDomainContext:dc];
	if( self ) {
		_selectionHelper = [value retain];
		_marqueeSelectionBounds = CGRectZero;
	}
	return self;
}

- (void)dealloc {

	[_selectionHelper release];
	[super dealloc];
}

#pragma mark Action Methods
- (void)didClickOnGraphic:(SHNode *)graphic modifyingExistingSelection:(BOOL)isModifyingSelection {
	
	NSParameterAssert(graphic);
	
	NodeProxy *clickedGraphicProxy = [_domain nodeProxyForNode:graphic];
	NSAssert( clickedGraphicProxy!=nil, @"eh?");
	
	// The user clicked on a graphic's contents. Update the selection.
	[_selectionHelper toggleSelectionOfItem:clickedGraphicProxy shouldModifyCurrent:isModifyingSelection];	
}

// The user clicked somewhere other than on a graphic. Clear the selection, unless the user is holding down the shift key.
- (void)mouseDownInEmptySpaceModifyingExistingSelection:(BOOL)isModifyingSelection {
	
	if ( isModifyingSelection==NO ) {
		[_selectionHelper clearSelection];
	}
}

- (void)_modifyInitialSelectionBasedOnMarqueeBounds:(CGRect)marquee {
	
	// Either select or deselect all of the graphics that intersect the selection rectangle.
	NSIndexSet *indexesOfGraphicsInRubberBand = [_domain indexesOfGraphicsIntersectingRect:marquee];
	[_selectionHelper modifyInitialSelection:_initialSelection withMarqueedIndexes:indexesOfGraphicsInRubberBand];
}

- (void)setMarqueeSelectionBounds:(CGRect)newMarqueeBounds {
	
	if ( !CGRectEqualToRect( newMarqueeBounds, _marqueeSelectionBounds ) )
	{
		_marqueeSelectionBounds = newMarqueeBounds;
		
		if(_initialSelection)
			[self _modifyInitialSelectionBasedOnMarqueeBounds:_marqueeSelectionBounds];
	}
}

- (void)beginModifyingSelectionWithMarquee {
	
	NSAssert( !_initialSelection, @"gmm" );
	_initialSelection = [[[_domain currentFilteredContentSelectionIndexes] copy] autorelease];
	NSAssert( _initialSelection, @"need even an empty set");
}

- (void)endModifyingSelectionWithMarquee {
	
	NSAssert(_initialSelection, @"gmm");
	_initialSelection = nil;
}

#pragma mark Accessor methods
- (NSString *)identifier { return @"SKTSelectTool"; }

@end
