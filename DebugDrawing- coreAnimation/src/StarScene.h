//
//  StarScene.h
//  DebugDrawing
//
//  Created by steve hooley on 25/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import <SHNodeGraph/SHContentProvidorProtocol.h>
#import "Graphic.h"
#import "StarSceneUserProtocol.h"

@class SHNodeGraphModel, NodeClassFilter;

@interface StarScene : _ROOT_OBJECT_ <SHContentProviderUserProtocol> {

	SHNodeGraphModel	*_model;
	NodeClassFilter		*_filter;
	
	BOOL _willRemoveContentDebug, _willInsertContentDebug, _willChangeContentDebug, _willchangeSelectionDebug;
}

@property (assign) SHNodeGraphModel *model;
@property (assign) NodeClassFilter *filter;


- (void)selectItemAtIndex:(NSUInteger)ind;
- (void)deselectItemAtIndex:(NSUInteger)ind;

/*-- This is what we hook up the arrayController to, therefor we need to make this kvo-able
 *-- when the arrayController tries to set the selectionIndexes we redirect it towards the model rather than
 *-- to the NodeProxy's selectionIndexes (NodeProxy's selectionIndexes are observing the model - so we need them to be set that way)
 *
 *-- We have to observe filter.currentNodeProxy and trigger changes in currentFilteredContent & currentFilteredContentSelectionIndexes when it changes
 */
- (NSArray *)currentFilteredContent;
- (void)setCurrentFilteredContent:(NSArray *)value;

// you can set the selection with this, but not the filered content
- (NSIndexSet *)currentFilteredContentSelectionIndexes;
- (void)setCurrentFilteredContentSelectionIndexes:(NSIndexSet *)value;

- (NSArray *)selectedItems;

- (NodeProxy *)rootProxy;
- (NodeProxy *)currentProxy;

/* we always draw the root content */
- (NSArray *)stars;

//- (NSUInteger)indexOfProxy:(NodeProxy *)proxy;
- (NSUInteger)indexOfOriginalObjectIdenticalTo:(id)value;

#pragma mark Needs Moving
//june09+ (CGRect)drawingBoundsForNodeProxy:(NodeProxy *)value;


@end
