//
//  SceneUtilities.m
//  DebugDrawing
//
//  Created by steve hooley on 10/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SceneUtilities.h"
#import "StarScene.h"

@implementation SceneUtilities

+ (BOOL)isMoveable:(NodeProxy *)np {
	
	NSParameterAssert(np);
	return [np.originalNode respondsToSelector:@selector(translateByX:byY:)];
}

// what does this do?
// what does this do?
+ (void)infoForProxy:(NodeProxy *)np fromScene:(StarScene *)scene index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected {
	
	NSParameterAssert(np);
	NSParameterAssert(scene);
	NSParameterAssert(outIndex);
	NSParameterAssert(outIsSelected);
	
	SHNode *clickedGraphic = [np originalNode];
	*outIndex = [scene indexOfOriginalObjectIdenticalTo:clickedGraphic];
	*outIsSelected = [scene.currentFilteredContentSelectionIndexes containsIndex:*outIndex];
}

+ (void)infoForProxy:(NodeProxy *)np fromScene:(StarScene *)scene index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected isMovable:(BOOL *)outIsMovable {

	NSParameterAssert(np);
	NSParameterAssert(scene);
	NSParameterAssert(outIndex);
	NSParameterAssert(outIsSelected);
	NSParameterAssert(outIsMovable);
	
	[SceneUtilities infoForProxy:np fromScene:scene index:outIndex isSelected:outIsSelected];
	*outIsMovable = [SceneUtilities isMoveable:np];
}

/* Which items in the scene are currently rotatable ? */
+ (NSArray *)identifyTargetObjectsFromScene:(StarScene *)scn {
	
	NSParameterAssert(scn);

	NSArray *rotatableItems = nil;
	NSArray *selectedItems = [scn selectedItems];
	NSArray *moveAble = [SceneUtilities justMovableItemsFrom:selectedItems];
	if([moveAble count]==1)
		rotatableItems = moveAble;
	return rotatableItems;
}

+ (NSArray *)justMovableItemsFrom:(NSArray *)selGraphics {
	
	NSParameterAssert(selGraphics);

	NSMutableArray *moveAbleItems = [NSMutableArray array];
	for(NodeProxy *each in selGraphics){
		if([SceneUtilities isMoveable:each])
			[moveAbleItems addObject:each];
	}
	return moveAbleItems;
}

@end
