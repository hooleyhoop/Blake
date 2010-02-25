//
//  SelectingSceneManipulation.m
//  DebugDrawing
//
//  Created by steve hooley on 06/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SelectingSceneManipulation.h"
#import "StarScene.h"
#import "SceneUtilities.h"

@implementation SelectingSceneManipulation

- (id)initWithScene:(StarScene *)value {
	
	NSParameterAssert(value);

	self=[super init];
	if(self){
		_scene = [value retain];
	}
	return self;
}

- (void)dealloc {

	[_scene release];
	[super dealloc];
}

- (void)toggleSelectionOfItem:(NodeProxy *)proxyItem shouldModifyCurrent:(BOOL)modifyCurrentSelection {
	
	NSParameterAssert(proxyItem);
	NSAssert(_scene, @"need a scene to do selection");
	NSAssert( [[_scene currentFilteredContent] containsObjectIdenticalTo:proxyItem], @"doh - cant select that one" );
	
    NSUInteger clickedGraphicIndex;
	BOOL clickedGraphicIsSelected;

	[SceneUtilities infoForProxy:proxyItem fromScene:_scene index:&clickedGraphicIndex isSelected: &clickedGraphicIsSelected];

	if( modifyCurrentSelection ) 
	{
		if ( clickedGraphicIsSelected ) 
		{
			// Remove the graphic from the selection.
			[_scene deselectItemAtIndex:clickedGraphicIndex];
		} else {
			// Add the graphic to the selection.
			[_scene selectItemAtIndex:clickedGraphicIndex];
		}
	} else {
		// If the graphic wasn't selected before then it is now, and none of the rest are.
		if( clickedGraphicIsSelected==NO ) 
		{
			[_scene setCurrentFilteredContentSelectionIndexes:[NSIndexSet indexSetWithIndex:clickedGraphicIndex]];
		}
	}
}

- (void)clearSelection {
	
	NSIndexSet *emptySet = [NSIndexSet indexSet]; // causes a change notification too?
	[_scene setCurrentFilteredContentSelectionIndexes:emptySet];
}

- (void)modifyInitialSelection:(NSIndexSet *)initialSelection withMarqueedIndexes:(NSIndexSet *)indexesOfGraphicsInRubberBand {

	NSParameterAssert(initialSelection);
	NSParameterAssert(indexesOfGraphicsInRubberBand);
	NSAssert(_scene, @"need a scene to do selection");
	
	NSMutableIndexSet *newSelectionIndexes = [[initialSelection mutableCopy] autorelease];
	
	for( NSUInteger indx = [indexesOfGraphicsInRubberBand firstIndex]; indx != NSNotFound; indx = [indexesOfGraphicsInRubberBand indexGreaterThanIndex:indx] )
	{
		if ([newSelectionIndexes containsIndex:indx] ) {
//			[newSelectionIndexes removeIndex:indx];
		} else
			[newSelectionIndexes addIndex:indx];
	}
	[_scene setCurrentFilteredContentSelectionIndexes:newSelectionIndexes];
}


@end
