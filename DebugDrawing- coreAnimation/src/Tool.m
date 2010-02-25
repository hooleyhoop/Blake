//
//  Tool.m
//  DebugDrawing
//
//  Created by steve hooley on 21/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Tool.h"
#import "ToolBarController.h"
#import "StarScene.h"
#import "Graphic.h"
#import "HitTestContext.h"
#import "CALayerStarView.h"
//#import "MathUtilities.h"
#import "DomainContext.h"
//#import "MiscUtilities.h"


/*
 *
*/
@implementation Tool

#pragma mark Instance methods
- (id)init {
	
	self = [super init];
	if ( self ) {
	}
	return self;
}

- (void)dealloc {
	
	[super dealloc];
}


/* Draw for hit test! Important that we draw in the reverse order! */
//- (void)drawStarsinView:(CALayerStarView *)starView {
//
////	-- get the current nodes
////	-- draw the last one from the root
////	-- draw the others in reverse order
//	NSArray *clckableCont = starView.starScene.currentFilteredContent;
//	if([clckableCont count])
//	{
//		NSArray *drawingNodesBeforeCurredntNode = [StarScene drawableParentsOf:[clckableCont lastObject]];
//		if([drawingNodesBeforeCurredntNode count])
//			NSAssert(NO, @"we have to do the right stuff! and setup the transforms for these items");
//		[self reverseDrawStars:clckableCont inView:starView];
//	}
//}

//- (void)reverseDrawStars:(NSArray *)starProxies inView:(CALayerStarView *)starView {
//
//	SHNode *currentNode = starView.starScene.currentNodeGroup;
//	NSAssert(currentNode!=nil, @"we can not be here and not have a current node");
//
//	for(NodeProxy *eachStarProxy in [starProxies reverseObjectEnumerator])
//	{
//		Graphic *original = (Graphic *)eachStarProxy.originalNode;
//		if([original respondsToSelector:@selector(drawWithHint:)])
//		{
//			[original drawWithHint: SKTGraphicHitTest];
//			
//			/* check the hit test cntx */
//			SH_Path *path =  [currentNode relativePathToChild:original];
//			[_hitTestCntxt checkAndResetWithKey: path];
//			
//		} else if([eachStarProxy hasChildren]){
//			[self reverseDrawStars: eachStarProxy.filteredContent inView:starView];
//		}
//	}
//}

//september09 - (BOOL)identifierMatches:(NSString *)value {
//september09	return [[self identifier] isEqualToString: value];
//september09}


- (NSString *)identifier { return @"TOOL_ABSTRACT"; }

#pragma mark Mousey Stuff
//- (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
//	
//	_mouseDownPt = pt;
//	
//	// -- we will do the hit testing for you in mousedown
//	_mouseDownObject = [_domain nodeUnderPoint:pt];
//}

//- (void)mouseUpAtPoint:(NSPoint)pt {
//
//	_mouseDownObject = nil;
//	_mouseDownPt = NSZeroPoint;
//}

@end
