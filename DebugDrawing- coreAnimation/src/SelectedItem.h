//
//  SelectedItem.h
//  DebugDrawing
//
//  Created by steve hooley on 22/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class StarScene, NodeProxy;

extern const NSInteger SKTGraphicNoHandle;

@interface SelectedItem : _ROOT_OBJECT_ {

	NodeProxy *originalNodeProxy;
}

@property (assign) NodeProxy *originalNodeProxy;

+ (id)newSelectedItemWith:(NodeProxy *)value;

- (id)initWithNodeProxy:(NodeProxy *)value;

- (void)willBeSwappedOutOfScene:(StarScene *)scene;
- (void)wasSwappedIntoScene:(StarScene *)scene;

//- (NSRect)boundsOfEdge:(NSInteger)edge;
// - (NSInteger)edgeUnderPoint:(NSPoint)point;
//- (void)moveEdge:(int)edge byX:(CGFloat)xamount byY:(CGFloat)yamount;

- (NSRect)drawingBounds;
- (NSRect)transformedGeometryRectBoundingBox;

- (NSPoint)anchorPt;
- (void)setAnchorPt:(NSPoint)val;
- (CGFloat)scale;
- (void)setScale:(CGFloat)value;
- (NSPoint)position;

- (NSString *)debugNameString;
@end
