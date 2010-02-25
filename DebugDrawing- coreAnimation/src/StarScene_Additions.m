//
//  StarScene_Additions.m
//  DebugDrawing
//
//  Created by steve hooley on 26/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "StarScene_Additions.h"
#import "AppControl.h"
#import "CALayerStarView.h"

@implementation StarScene_Additions

@synthesize selectedItemIndexes;
@synthesize selectedItems;

#pragma mark Class methods

// we need to force things to update when they are added, deleted, etc.
//june09+ (void)recalcDrawingBoundsForNodeProxy:(NodeProxy *)value {

//june09	if([value.originalNode respondsToSelector:@selector(drawingBounds)])
//june09	{
// could be a selected Item…?
//		if([value isKindOfClass:[SelectedItem class]])
//		{
//			NSLog(@"Hell Yeah");
//		}
//june09		((Graphic *)value.originalNode)->_drawingBoundsDidChange = YES;
//june09		[(Graphic *)value.originalNode enforceConsistentState];
//june09	}
//june09	else {
//june09		for(NodeProxy *eachChild in value.filteredContent){
//june09			[StarScene recalcDrawingBoundsForNodeProxy:eachChild];
//june09		}
//june09	}
//june09}



//june09+ (NSArray *)drawableParentsOf:(NodeProxy *)proxyItem {
//june09	
//june09	NSMutableArray *drawableParents = [NSMutableArray array];
//june09	SHNode *n = proxyItem.originalNode;
//june09	NSAssert([n isKindOfClass:[SHNode class]], @"maybe selected item doesnt like this?");
//june09	while (n.parentSHNode !=nil){
//june09		n = n.parentSHNode;
//june09		if([n respondsToSelector:@selector(drawWithHint:)])
//june09			[drawableParents addObject:n];
//june09	}
//june09	return drawableParents;
//june09}

#pragma mark Init methods
- (id)init {
	
	self=[super init];
	if(self){
		//		dirtyRects = [NSMutableArray new];
		//june09		self.selectedItems = [NSMutableArray array];
	}
	return self;
}

- (void)dealloc {
	
	//june09	self.selectedItems = nil;
	//june09	self.selectedItemIndexes = nil;
	//	[dirtyRects release];
	[super dealloc];
}

#pragma mark Action methods
//june09- (void)addGraphic:(SHNode *)graphic {
//june09	
//june09	NSParameterAssert(graphic!=nil);
//june09	[model NEW_addChild:graphic toNode:model.currentNodeGroup];
//june09}

//- (void)coalesceDirtyRects {
//
//	NSArray *currentDirtyRects = [[dirtyRects copy] autorelease];
//	int rectCount = [currentDirtyRects count];
//	for(NSValue *testRectVal in currentDirtyRects)
//	{
//		NSRect testRect = [testRectVal rectValue];
//		for(int i=0;i<rectCount;i++)
//		{
//			NSValue *testeeRectVal = [currentDirtyRects objectAtIndex:i];
//			if(testRectVal!=testeeRectVal)
//			{
//				NSRect testeeRect = [testeeRectVal rectValue];
//				if( NSIntersectsRect(testRect, testeeRect) )
//				{
//					NSRect newRect = NSUnionRect(testRect, testeeRect);
//					[dirtyRects removeObjectIdenticalTo:testRectVal];
//					[dirtyRects removeObjectIdenticalTo:testeeRectVal];
//					[dirtyRects addObject:[NSValue valueWithBytes:&newRect objCType:@encode(NSRect)]];
//					[self coalesceDirtyRects];
//					return;
//				}
//			}
//		}
//	}
//}

//- (NodeProxy *)edgeUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle {
//	
//    // We don't touch *outIndex, *outIsSelected, or *outHandle if we return nil. Those values are undefined if we don't return a match.
//	NSAssert(NO, @"ERROR - THIS WILL NOT TELL US WHICH EDGE IS UNDER POINT!");
//
//    // Search through all of the graphics, front to back, looking for one that claims that the point is on a selection handle (if it's selected) or in the contents of the graphic itself.
//	NodeProxy *graphicToReturn=nil;
//	NSArray *filteredContent = [self currentFilteredContent];
//	//    NSIndexSet *selectionIndexes = [_sketchViewController.sketchViewModel sktSceneSelectionIndexes];
//	NSUInteger graphicCount = [filteredContent count];
//	int thisIndex = graphicCount;
//    for( NodeProxy *each in [filteredContent reverseObjectEnumerator] )
//	{
//		thisIndex--;
//		// Do a quick check to weed out graphics that aren't even in the neighborhood.
//		if( NSPointInRect(point, [StarScene drawingBoundsForNodeProxy:each]) )
//		{
//			// Check the graphic's selection handles first, because they take precedence when they overlap the graphic's contents.
//			BOOL graphicIsSelected = [selectedItemIndexes containsIndex:thisIndex];
//			if( graphicIsSelected )
//			{
//				NSInteger handle = [(SelectedItem *)each edgeUnderPoint:point];
//				if( handle!=SKTGraphicNoHandle )
//				{
//					// The user clicked on a handle of a selected graphic.
//					graphicToReturn = each;
//					if( outHandle ){
//						*outHandle = handle;
//					}
//				}
//			} 
//			//			if (!graphicToReturn) {
//			//				BOOL clickedOnGraphicContents = [graphic isContentsUnderPoint:point];
//			//				if (clickedOnGraphicContents) {
//			//					// The user clicked on the contents of a graphic.
//			//					graphicToReturn = graphic;
//			//					if (outHandle) {
//			//						*outHandle = SKTGraphicNoHandle;
//			//					}
//			//				}
//			//			}
//			if( graphicToReturn!=nil )
//			{
//				// Return values and stop looking.
//				if( outIndex!=NULL ) {
//					*outIndex = thisIndex;
//				}
//				if( outIsSelected!=NULL ) {
//					*outIsSelected = graphicIsSelected;
//				}
//				break;
//			}
//		}
//	}
//    return graphicToReturn;
//}



- (NodeProxy *)graphicFromPath:(SH_Path *)relativePath index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected isMovable:(BOOL *)outIsMovable {
	
	//june09	NSArray *pathComponents = [relativePath pathComponents];
	//june09	relativePath = [pathComponents objectAtIndex:0];
	//june09	SHNode *currentNode = self.currentNodeGroup;
	//june09	SHNode *clickedGraphic = [currentNode childAtRelativePath:relativePath];
	//june09	NSArray *filteredContent = [self currentFilteredContent];
	//june09	NSArray *moveAble = [StarScene justMovableItemsFrom:filteredContent];
	//june09	int obIndex = [self indexOfOriginalObjectIdenticalTo:clickedGraphic];
	//june09	NodeProxy *np = [filteredContent objectAtIndex:obIndex];
	
	//june09	if(outIndex)
	//june09		*outIndex = obIndex;
	//june09	if(outIsSelected)
	//june09		*outIsSelected = [selectedItemIndexes containsIndex:*outIndex];
	//june09	if(outIsMovable)
	//june09		*outIsMovable = [moveAble containsObjectIdenticalTo:np];
	//june09	return np;
	return nil
}

- (NodeProxy *)graphicUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle {
	
	NSAssert(NO, @"ERROR - THIS WILL NOT TELL US WHICH GRAPHIC IS UNDER POINT!");
    // We don't touch *outIndex, *outIsSelected, or *outHandle if we return nil. Those values are undefined if we don't return a match.
	
    // Search through all of the graphics, front to back, looking for one that claims that the point is on a selection handle (if it's selected) or in the contents of the graphic itself.
	NodeProxy *graphicToReturn=nil;
	NSArray *filteredContent = [self currentFilteredContent];
	//    NSIndexSet *selectionIndexes = [_sketchViewController.sketchViewModel sktSceneSelectionIndexes];
	NSUInteger graphicCount = [filteredContent count];
	int thisIndex = graphicCount;
    for( NodeProxy *each in [filteredContent reverseObjectEnumerator] )
	{
		thisIndex--;
		//		NSAssert(graphicCount>graphIndex, @"bad index graphicUnderPoint");
		//		SKTGraphic *graphic = [_sketchViewController.sketchViewModel objectInSktSceneItemsAtIndex: graphIndex];
		// Do a quick check to weed out graphics that aren't even in the neighborhood.
		if( NSPointInRect(point, [StarScene drawingBoundsForNodeProxy:each]) )
		{
			// Check the graphic's selection handles first, because they take precedence when they overlap the graphic's contents.
			BOOL graphicIsSelected = [selectedItemIndexes containsIndex:thisIndex];
			//			if (graphicIsSelected) {
			//				NSInteger handle = [graphic handleUnderPoint:point];
			//				if (handle!=SKTGraphicNoHandle) {
			//					// The user clicked on a handle of a selected graphic.
			graphicToReturn = each;
			//					if (outHandle) {
			//						*outHandle = handle;
			//					}
			//				}
			//			} NSString
			//			if (!graphicToReturn) {
			//				BOOL clickedOnGraphicContents = [graphic isContentsUnderPoint:point];
			//				if (clickedOnGraphicContents) {
			//					// The user clicked on the contents of a graphic.
			//					graphicToReturn = graphic;
			//					if (outHandle) {
			//						*outHandle = SKTGraphicNoHandle;
			//					}
			//				}
			//			}
			if( graphicToReturn!=nil )
			{
				// Return values and stop looking.
				if( outIndex!=NULL ) {
					*outIndex = thisIndex;
				}
				if( outIsSelected!=NULL ) {
					*outIsSelected = graphicIsSelected;
				}
				break;
			}
		}
	}
    return graphicToReturn;
}


#pragma mark Notification methods
/* NB! we may already contain this graphic! (It may be being reorderd) */
- (void)graphicWasAddedToScene:(Graphic *)aNewGraphic {
	
	[aNewGraphic addDirtyRectObserver:self];
	
	/* Temporary - add a layer to the layerView */
	// [(AppControl *)([[NSApplication sharedApplication] delegate]) addStar:aNewGraphic];
}

- (void)graphicWasRemovedFromScene:(Graphic *)aGraphic {
	[aGraphic removeDirtyRectObserver:self];
	
	/* Temporary - remove a layer from the layerView */
	// [(AppControl *)([[NSApplication sharedApplication] delegate]) removeStar];
}

//- (void)graphic:(Graphic *)value becameDirtyInRect:(NSRect)dirtyRect {
//	
//	/* should we try to do some clever stuff with the rects? - NSView can coalesce them… */
//	[dirtyRects addObject:[NSValue valueWithRect:dirtyRect]];
//	
//	// if(value is selected)
//	//	 tell the translate tool that a graphic moved - this seems pretty inneficient
//}

//- (void)drewScene {
//	
//	[dirtyRects removeAllObjects];
//}


#pragma mark Accessor methods
+ (NSRect)drawingBoundsOfGraphics:(NSArray *)graphics {
	
    // The drawing bounds of an array of graphics is the union of all of their drawing bounds.
	NSRect drawingBounds = NSZeroRect;
	//june09    if( [graphics count]>0 )
	//june09	{
	//june09		for( NodeProxy *graphic in graphics ){
	//june09            drawingBounds = NSUnionRect(drawingBounds, [StarScene drawingBoundsForNodeProxy:graphic] );
	//june09		}
	//june09	}
    return drawingBounds;
}

//- (NSArray *)dirtyRects {
//	
//	return dirtyRects;
//}



- (SHNode *)currentNodeGroup {
	return model.currentNodeGroup;
}





@end
