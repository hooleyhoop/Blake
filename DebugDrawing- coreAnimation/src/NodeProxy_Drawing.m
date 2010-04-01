//
//  NodeProxy_Drawing.m
//  DebugDrawing
//
//  Created by steve hooley on 22/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "NodeProxy_Drawing.h"


@implementation NodeProxy (NodeProxy_Drawing)

//- (NSRect)physicalBounds {
//	
//	NSRect physicalBounds = NSZeroRect;
//	if([_originalNode respondsToSelector:@selector(physicalBounds)]){
//		physicalBounds = [_originalNode physicalBounds];
//	}
//	else {
//		for(NodeProxy *eachChild in _filteredContent){
//			physicalBounds = NSUnionRect( physicalBounds, eachChild.physicalBounds);
//		}
//	}
//	return physicalBounds;
//}

/* Bounds is either originalNode bounds OR the sum of all children bnds */
//- (NSRect)drawingBounds {
//
//	NSRect drawingBounds = NSZeroRect;
//	if([_originalNode respondsToSelector:@selector(drawingBounds)]){
//		drawingBounds = [_originalNode drawingBounds];
//	}
//	else {
//		for(NodeProxy *eachChild in _filteredContent){
//			drawingBounds = NSUnionRect( drawingBounds, eachChild.drawingBounds);
//		}
//	}
//	return drawingBounds;
//}


@end
