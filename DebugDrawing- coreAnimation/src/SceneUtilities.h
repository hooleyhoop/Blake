//
//  SceneUtilities.h
//  DebugDrawing
//
//  Created by steve hooley on 10/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@class StarScene, NodeProxy;

@interface SceneUtilities : _ROOT_OBJECT_ {

}

+ (BOOL)isMoveable:(NodeProxy *)np;

+ (NSArray *)justMovableItemsFrom:(NSArray *)selGraphics;
+ (NSArray *)identifyTargetObjectsFromScene:(StarScene *)scn;

+ (void)infoForProxy:(NodeProxy *)np fromScene:(StarScene *)scene index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected;
+ (void)infoForProxy:(NodeProxy *)np fromScene:(StarScene *)scene index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected isMovable:(BOOL *)outIsMovable;

@end
