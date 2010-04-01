//
//  StarScene_Additions.h
//  DebugDrawing
//
//  Created by steve hooley on 26/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "StarScene.h"
#import "Graphic.h"

@class SHNodeGraphModel, NodeClassFilter, SelectedItem, CALayerStarView;

@interface StarScene_Additions : StarScene <DirtyRectObserverProtocol> {

	//	NSMutableArray		*dirtyRects;
	
	//june09	NSIndexSet			*selectedItemIndexes;
	//june09	NSMutableArray		*selectedItems;
}


@property (retain) NSIndexSet *selectedItemIndexes;
@property (retain) NSMutableArray *selectedItems;

#pragma mark Class methods
//june09+ (NSRect)drawingBoundsOfGraphics:(NSArray *)graphics;
//june09+ (void)recalcDrawingBoundsForNodeProxy:(NodeProxy *)value;
//june09+ (NSArray *)drawableParentsOf:(NodeProxy *)value;

#pragma mark Action methods
- (void)addGraphic:(SHNode *)graphic;

//- (void)coalesceDirtyRects;
// hit test will give you the path of a graphic…
- (NodeProxy *)graphicFromPath:(SH_Path *)relativePath index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected isMovable:(BOOL *)outIsMoveable;

// - (NodeProxy *)edgeUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle;
// - (NodeProxy *)graphicUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle;

#pragma mark Notification methods
- (void)temp_proxy:(NodeProxy *)value changedContent:(NSArray *)values;
- (void)temp_proxy:(NodeProxy *)value insertedContent:(NSArray *)values;
- (void)temp_proxy:(NodeProxy *)value removedContent:(NSArray *)values;
- (void)temp_proxy:(NodeProxy *)value changedSelection:(NSMutableIndexSet *)values;

//- (void)drewScene;

#pragma mark Accessor methods
//- (NSArray *)dirtyRects;

- (SHNode *)currentNodeGroup;






@end
