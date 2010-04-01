//
//  SelectedItem.m
//  DebugDrawing
//
//  Created by steve hooley on 22/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SelectedItem.h"
#import "StarScene.h"
#import "Graphic.h"
#import "AppControl.h"


@implementation SelectedItem

@synthesize originalNodeProxy;

+ (id)newSelectedItemWith:(NodeProxy *)value {
	
	return [[[SelectedItem alloc] initWithNodeProxy:value] autorelease];
}

- (id)initWithNodeProxy:(NodeProxy *)value {

	self = [super init];
	if(self){
		originalNodeProxy = [value retain];
	}
	return self;
}

- (void)dealloc {
	
	[originalNodeProxy release];
	originalNodeProxy = nil;
	[super dealloc];
}

- (void)willBeSwappedOutOfScene:(StarScene *)scene {

	NSLog(@"%@ swapped out of scene", [self debugNameString]);
	// -- need to make sure all drawing bounds are correct
	[StarScene recalcDrawingBoundsForNodeProxy:originalNodeProxy];
	
	[scene graphic:(id)originalNodeProxy becameDirtyInRect:NSInsetRect([self drawingBounds],-10,-10)]; 
}

- (void)wasSwappedIntoScene:(StarScene *)scene {

	NSLog(@"%@ swapped into scene", [self debugNameString]);

	// -- need to make sure all drawing bounds are correct
	[StarScene recalcDrawingBoundsForNodeProxy:originalNodeProxy];
	
	[scene graphic:(id)originalNodeProxy becameDirtyInRect:NSInsetRect([self drawingBounds],-10,-10)];
}


/* Hmm */

//- (NSRect)boundsOfEdge:(int)edge {
//
//	NSInteger edgeSize = 4;
//	CGFloat halfEdgeSize = edgeSize/2.0;
//	NSRect bounds = [self drawingBounds];
//	
//	if(edge==SKTGraphicLeftEdge)
//		return NSMakeRect( NSMinX(bounds)-halfEdgeSize, NSMinY(bounds), edgeSize, bounds.size.height );
//	else if(edge==SKTGraphicRightEdge)
//		return NSMakeRect( NSMaxX(bounds)-halfEdgeSize, NSMinY(bounds)-halfEdgeSize, edgeSize, bounds.size.height );
//	else if(edge==SKTGraphicTopEdge)
//		return NSMakeRect( NSMinX(bounds), NSMaxY(bounds)-halfEdgeSize, bounds.size.width , edgeSize );
//	else if(edge==SKTGraphicBottomEdge)
//		return NSMakeRect( NSMinX(bounds), NSMinY(bounds)-halfEdgeSize, bounds.size.width, edgeSize);
//	return NSZeroRect;
//}

//- (NSInteger)edgeUnderPoint:(NSPoint)point {
//
//    NSInteger handle = SKTGraphicNoHandle;
//	
//	NSRect leftEdge = [self boundsOfEdge:SKTGraphicLeftEdge];
//	NSRect bottomEdge = [self boundsOfEdge:SKTGraphicBottomEdge];
//	NSRect rightEdge = [self boundsOfEdge:SKTGraphicRightEdge];
//	NSRect topEdge = [self boundsOfEdge:SKTGraphicTopEdge];
//
//	if( NSPointInRect(point, leftEdge) ) {
//		handle = SKTGraphicLeftEdge;
//    } else if( NSPointInRect(point, rightEdge) ) {
//		handle = SKTGraphicRightEdge;
//    } else if( NSPointInRect(point, topEdge) ) {
//		handle = SKTGraphicTopEdge;
//    } else if( NSPointInRect(point, bottomEdge) ) {
//		handle = SKTGraphicBottomEdge;
//    }
//    return handle;
//}

- (id)forwardingTargetForSelector:(SEL)sel;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	
	// NSLog(@"method sig for selector %@", NSStringFromSelector(aSelector));
	if ([originalNodeProxy respondsToSelector: aSelector])
	{
		// yes, return the delegate's method signature
		return [originalNodeProxy methodSignatureForSelector: aSelector];
	} else {
		// no, return whatever NSObject would return
		return [super methodSignatureForSelector: aSelector];
	}	
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	
	// NSLog(@"Forwarding invocation from %@ to %@", self, originalNodeProxy);	
	[anInvocation invokeWithTarget:originalNodeProxy];
}

// can we use something like this to forward the observer stuff?
//resolveInstanceMethod
//_addObserver:forProperty:options:context:
//_shouldAddObservationForwardersForKey:
//keyPathsForValuesAffectingValueForKey:

//- (NSRect)physicalBounds {
//	return [SelectedItem calculatedPhysicalBoundsOfNodeProxy:originalNodeProxy];
//}
//
///* This might be the actual physical bounds of a graphic or the total physical bounds of a groups children */
//+ (NSRect)calculatedPhysicalBoundsOfNodeProxy:(NodeProxy *)nProxy {
//	
//	NSRect physicalBounds = NSZeroRect;
////	[self setDirtyRect:NSUnionRect(self.drawingBounds, currentSelectedBounds)];
//	return physicalBounds;
//}

//- (NSPoint)anchorPosition {
//
//    if ([originalNodeProxy.originalNode respondsToSelector: @selector(anchorPosition)])
//        return [(id)originalNodeProxy.originalNode anchorPosition];
//    return NSMakePoint(MAXFLOAT, MAXFLOAT);
//}

- (NSRect)transformedGeometryRectBoundingBox {

	if ([originalNodeProxy.originalNode respondsToSelector: @selector(transformedGeometryRectBoundingBox)])
        return [(id)originalNodeProxy.originalNode transformedGeometryRectBoundingBox];
    return NSZeroRect;
}

- (NSPoint)anchorPt {
	if ([originalNodeProxy.originalNode respondsToSelector: @selector(anchorPt)])
        return [(id)originalNodeProxy.originalNode anchorPt];
    return NSMakePoint(MAXFLOAT, MAXFLOAT);
}

- (void)setAnchorPt:(NSPoint)val {
	if ([originalNodeProxy.originalNode respondsToSelector: @selector(setAnchorPt:)])
		[(id)originalNodeProxy.originalNode setAnchorPt:val];
}

- (CGFloat)scale {
	if ([originalNodeProxy.originalNode respondsToSelector: @selector(scale)])
        return [(Graphic *)((id)originalNodeProxy.originalNode) scale];
    return 0;
}
- (void)setScale:(CGFloat)value {
	if ([originalNodeProxy.originalNode respondsToSelector: @selector(setScale:)])
		[(id)originalNodeProxy.originalNode setScale:value];
}

- (NSPoint)position {
	if ([originalNodeProxy.originalNode respondsToSelector: @selector(position)])
        return [(Graphic *)((id)originalNodeProxy.originalNode) position];
    return NSMakePoint(MAXFLOAT, MAXFLOAT);
}


- (NSRect)drawingBounds {
	NSRect enlargedDrawingBnds = NSInsetRect([StarScene drawingBoundsForNodeProxy:originalNodeProxy], 0.0f, 0.0f);
	return enlargedDrawingBnds;
}

- (NSString *)debugNameString {
	return [originalNodeProxy debugNameString];
}

- (id)valueForUndefinedKey:(NSString *)key {
	
	id tryThis = [originalNodeProxy valueForKey:key];
	if(tryThis==nil)
		[NSException raise:@"WHOOSE A MONKEY FUCKER???????????????????????????????????????????????????????????????" format:@"-- --"];
	return tryThis;
}

@end
