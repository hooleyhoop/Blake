//
//  DomainContext.h
//  DebugDrawing
//
//  Created by shooley on 12/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

@class HitTester, StarScene, SHNodeGraphModel, SHNode, SelectingSceneManipulation;
@protocol EditingToolProtocol;

@interface DomainContext : _ROOT_OBJECT_ {

	SHNodeGraphModel				*_model;
	StarScene						*_starScene;
	
	// Stuff for editing version
	SelectingSceneManipulation		*_sceneSelectingExtras;
	HitTester						*_hitTestTester;
	NSArray							*_modelTools;

}

@property (readonly) NSArray *modelTools;
@property (readonly) StarScene *starScene;
@property (readonly) SHNodeGraphModel *model;

- (void)cleanup;

- (SHNode *)nodeUnderPoint:(NSPoint)pt;
- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(CGRect)rect;

- (NodeProxy *)nodeProxyForNode:(id)value;
- (NSIndexSet *)currentFilteredContentSelectionIndexes;

- (NSRect)allCurrentBounds;

@end
