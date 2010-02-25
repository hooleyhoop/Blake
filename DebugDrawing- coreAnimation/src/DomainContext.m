//
//  DomainContext.m
//  DebugDrawing
//
//  Created by shooley on 12/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "DomainContext.h"
#import "StarScene.h"
#import "SelectionWand.h"
#import "EditingToolProtocol.h"
#import "HitTester.h"
#import "TestUtilities.h"
#import "AppControl.h"
#import "SelectingSceneManipulation.h"

@implementation DomainContext

@synthesize modelTools=_modelTools;
@synthesize model=_model;
@synthesize starScene=_starScene;

- (id)init {

	self = [super init];
	if(self){

		_model = [[SHNodeGraphModel makeEmptyModel] retain];
		_starScene = [[StarScene alloc] init];
		[_starScene setModel:_model];

		// SOME EXTRAS for Editing
		_sceneSelectingExtras = [[SelectingSceneManipulation alloc] initWithScene:_starScene];

		// handle mouse clicks
		_hitTestTester = [[HitTester alloc] initWithScene:_starScene];
		
		//TODO: move to a toolbox class
		SelectionWand *selectionWand = [[[SelectionWand alloc] initWithDomainContext:self selectionHelper:_sceneSelectingExtras] autorelease];
		
		_modelTools = [[NSArray arrayWithObjects:
													selectionWand,
													nil] retain];
		
		[TestUtilities addSomeDefaultItemsToModel: _model];

#warning!		!sheeeett! here.. need to work on evaluate and enforceGraphConsistentState.
		/* we dont want the view to begin when the graph is in an inconsistent state */
//oct09		[_model enforceGraphConsistentState];
		
// Best if the domain doesnt do any low level stuff! Remember!
//TODO: When we have got a good MCV layering start cleaning up the domain


	}
	return self;
}

- (void)dealloc {

	_starScene.model = nil;
	[_starScene release];
	[_model release];
	
	[_hitTestTester release];
	[_modelTools release];
	[_sceneSelectingExtras release];
	[super dealloc];
}

- (void)cleanup {

}

- (SHNode *)nodeUnderPoint:(NSPoint)pt {

	return [_hitTestTester nodeUnderPoint:pt];
}

- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(CGRect)rect {

	return [_hitTestTester indexesOfGraphicsIntersectingRect:rect];
}

- (NodeProxy *)nodeProxyForNode:(id)value {

	NSParameterAssert(value);
	
	NodeProxy *clickedGraphicProxy = [_starScene.currentProxy nodeProxyForNode:value];
	NSAssert( clickedGraphicProxy!=nil, @"eh?");
	
	return clickedGraphicProxy;
}

- (NSIndexSet *)currentFilteredContentSelectionIndexes {

	return [_starScene currentFilteredContentSelectionIndexes];
}

- (NSRect)allCurrentBounds {
	[NSException raise:@"what the hell" format:@"dick wad"];
	return NSZeroRect;
}

@end
