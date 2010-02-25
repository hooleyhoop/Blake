//
//  StarView.m
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "StarView.h"
#import "Graphic.h"
#import "Star.h"
#import "StarGroup.h"
#import "StarScene.h"
#import "Widget_protocol.h"
#import "SelectedItem.h"
#import "CALayerStarView.h"

@implementation StarView

- (id)initWithFrame:(NSRect)frame {
	
    self = [super initWithFrame:frame];
    if (self) {		
		/* Todo */
		
		// add a currentItem to the model, how do we bring it to the front?
		
		// z-order questions
		// make sure rendering soesnt fuck up order… do we even want an order? maybe we should zsort? would be good if it was animatable…
		
    }
    return self;
}

- (void)dealloc {
	
	[super dealloc];
}

// Draw opaque objects front to back with depth testing enabled
// Draw transparent objects back to front

// blend front to back?
// glBlendFuncSeparateEXT(GL_DST_ALPHA,GL_ONE,GL_DST_ALPHA,GL_ZERO)
// OR
// glBlendFuncSeparateEXT(GL_DST_ALPHA,GL_ONE,GL_ZERO,GL_SRC_ALPHA)
- (void)drawStars:(NSArray *)starProxies drawingBnds:(NSRect)rect clipRects:(const NSRect *)rects clipRectsCount:(NSUInteger)clipRectCount cntxt:(NSGraphicsContext *)cntx {

	NSAssert([_starScene currentNodeGroup], @"model should always have a current node");
	
	// draw each five pointed star 3
	for(NodeProxy *eachStarProxy in starProxies)
	{
		Graphic *original = (Graphic *)eachStarProxy.originalNode;
		
		if([original respondsToSelector:@selector(drawWithHint:)])
		{
			if(original->_drawingBoundsDidChange==YES)
			{
				NSLog(@"ERROR >> TEmporary! Graphic not ready to DRaw");
				return;
			}
			
			NSRect graphicDrawingBounds = [original drawingBounds];
			// NB - this has not in anyway been profiled so i cant be at all sure that it is better than i niave approach (eek!)
			if( NSIntersectsRect( graphicDrawingBounds, rect ) )
			{
				// Then test per dirty rect
				// for( int dirtyRectIndex=0; dirtyRectIndex<clipRectCount; dirtyRectIndex++ )
				//{
				//	NSRect dirtyRect = rects[dirtyRectIndex];
				//	if( NSIntersectsRect( dirtyRect, graphicDrawingBounds ) )
				//	{
						// [cntx saveGraphicsState];
						// NSRectClip( dirtyRect );

						// surely we need --
						//-- original setupDrawing
						
					[original drawWithHint:SKTGraphicNormalFill];
						//-- if hasChildren
						//--	draw children
						
						//-- original restoreGraphicsState
						// [cntx restoreGraphicsState];

				//	}
				// }
			}

		} else if([eachStarProxy hasChildren]){
			[self drawStars: eachStarProxy.filteredContent drawingBnds:rect clipRects:rects clipRectsCount:clipRectCount cntxt:cntx];
		}
	}
}

- (void)drawWidgetsInClipRects:(const NSRect *)rects clipRectsCount:(NSUInteger)clipRectCount cntxt:(NSGraphicsContext *)cntx {

	for(id<Widget_protocol> widge in widgets)
	{
		[widge drawInStarView:self];
	}
}

// glVertexPointer, glColorPointer, glDrawArrays, glDrawElements
// rather than glBegin/glEnd
- (void)drawRect:(NSRect)rect {

	NSAssert(starScene!=nil, @"view needs a scene to draw");
		
	NSGraphicsContext *currentContext = [NSGraphicsContext currentContext];

	const NSRect *rects;
	int dirtyRectCount;
	[self getRectsBeingDrawn:&rects count:&dirtyRectCount];
	[[NSColor knobColor] set];

//	for( int dirtyRectIndex=0; dirtyRectIndex<dirtyRectCount; dirtyRectIndex++ )
//	{
//		NSRect dirtyRect = rects[dirtyRectIndex];
		// NSEraseRect( dirtyRect );
	NSRectFill(rect);
//	}

	NSRectClip(rect);

	[self drawStars: starScene.stars drawingBnds:rect clipRects:rects clipRectsCount:dirtyRectCount cntxt:currentContext];
	
    // if we are in a sub node
    //-- draw 50% black over view to knock everything back
	SHNode *currentNode = [starScene.model currentNodeGroup];
	SHNode *rootNode = [starScene.model rootNodeGroup];

	/* when we are in root node we just draw normally */
    if(currentNode!=rootNode)
	{
		/* If we are not in root node we want to hi-lite the current node */
		NodeProxy *cnp = starScene.filter.currentNodeProxy;
		NSAssert(cnp!=nil, @"This should be set");

		/* Fill a transluscent black over the entire screen */
		// [currentContext saveGraphicsState];
		// NSRectClip([self frame]);
		[[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
		NSRectFillUsingOperation([self frame], NSCompositeSourceOver);
		// [currentContext restoreGraphicsState];
	
		//-- draw the current subnode again
		[self drawStars:cnp.filteredContent drawingBnds:rect clipRects:rects clipRectsCount:dirtyRectCount cntxt:currentContext];
	}
	
	// -- we want to draw the selected items wireframe on top!
	NSArray *selectedItesms = [starScene selectedItems];
	if([selectedItesms count])
	{
		NSArray *drawingNodesBeforeCurredntNode = [StarScene drawableParentsOf:[selectedItesms lastObject]];
		//-- we have to setup the correct transformation matrix for the selected items
		if([drawingNodesBeforeCurredntNode count])
			NSAssert(NO, @"we have to do the right stuff! and setup the transforms for these items");
//		for(NodeProxy *item in [drawingNodesBeforeCurredntNode reverseObjectEnumerator] ){
//			NSAssert([item isKindOfClass:[NodeProxy class]], @"fucked up");
//			[item.originalNode _setupDrawing];
//		}

		[[NSColor yellowColor] set];
		for(SelectedItem *eachSelected in selectedItesms){
			// -- drawing bounds isnt rotated, arse wipe
			// -- i guess we really need the objects to draw their own wireframes?
			NSFrameRect([eachSelected drawingBounds]);    //	[self setDirtyRect:NSUnionRect(self.drawingBounds, currentSelectedBounds)];
		}
		// and now we must pop the transformation
//		for(NodeProxy *item in drawingNodesBeforeCurredntNode){
//			[item.originalNode _tearDownDrawing];
//		}
	}

	//-- draw tool sprites
	[self drawWidgetsInClipRects:rects clipRectsCount:dirtyRectCount cntxt:currentContext];
	
	[starScene drewScene];
}

/* we need to work out the correct path for mouse messages */
- (void)mouseDown:(NSEvent *)event {
	
	NSPoint mouseLocation = [self convertPoint:[event locationInWindow] fromView:nil];	
	[_mouseInputAdaptor _mouseDownEvent:event atPoint:mouseLocation inStarView:self];
}

- (void)setNeedsDisplayInRects:(NSArray *)rects
{
	NSEnumerator *rectEnum = [rects objectEnumerator];
	NSValue *currRectValue;
	while((currRectValue = [rectEnum nextObject]))
	{
		[self setNeedsDisplayInRect:[currRectValue rectValue]];
	}
}



@end
