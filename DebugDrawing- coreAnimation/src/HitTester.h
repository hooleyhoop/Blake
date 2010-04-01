//
//  HitTester.h
//  DebugDrawing
//
//  Created by Steven Hooley on 7/12/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "iAmTransformableProtocol.h"

@class StarScene, SHNode, Graphic, HitTestContext, Tool;

@interface HitTester : _ROOT_OBJECT_ {

	StarScene *_scene;
}

#pragma mark Class Methods
+ (BOOL)roughHitTestDrawingBoundsOf:(NSObject<iAmDrawableProtocol> *)each withContext:(HitTestContext *)hitTestCntxt;

#pragma mark Init Methods
- (id)initWithScene:(StarScene *)aScene;

#pragma mark Action Methods
- (NSIndexSet *)indexesOfGraphicsIntersectingRect:(const CGRect)rect;

- (SHNode *)nodeUnderPoint:(const NSPoint)pt;

- (void)hitTestTool:(NSObject<iAmDrawableProtocol> *)aTool atPoint:(NSPoint)pt pixelColours:(unsigned char *)cols;

@end
