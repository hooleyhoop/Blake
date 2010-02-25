//
//  StarGroup.m
//  DebugDrawing
//
//  Created by steve hooley on 24/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "StarGroup.h"
#import "Star.h"

@implementation StarGroup


- (id)init {

	self = [super init];
	if(self){
	}
	return self;
}

- (void)drawWithHint:(int)eh {
		
	[super drawWithHint:eh];

	NSAffineTransform *transform = [NSAffineTransform transform];

	[transform translateXBy:_position.x yBy:_position.y];
	[transform scaleXBy:_scale yBy:_scale];

	[NSGraphicsContext saveGraphicsState];
	[transform concat];

	//-- draw each item 
//	for(Star *eachStar in nodes){
//		[eachStar drawWithHint:];
//	}
	
	[NSGraphicsContext restoreGraphicsState];

	[[NSColor greenColor] set];
//	NSFrameRect(NSInsetRect(self.bounds,-1,-1));
}

//- (void)addNode:(Node *)node {
//	
//	[nodes addObject:node];
//}

- (NSRect)bounds {
	
	// union of all child bounds offset by our position
	CGFloat width = 0.0f;
	CGFloat height = 0.0f;
//	if( [nodes count]>0 ){
//		NSRect totalBoundsOfChildren = NSZeroRect;
//		for(Star *eachStar in nodes){
//			totalBoundsOfChildren = NSUnionRect(totalBoundsOfChildren, [eachStar bounds]);
//		}
//		width = totalBoundsOfChildren.size.width;
//		height = totalBoundsOfChildren.size.height;
//	}	 
	return NSMakeRect( _position.x, _position.y, width*_scale, height*_scale );
}

- (void)setPhysicalBounds:(NSRect)newBnds {
	
	CGFloat x = newBnds.origin.x;
	CGFloat y = newBnds.origin.y;	
	_position = NSMakePoint(x,y);
	
//	if( [nodes count]>0 ){
//		_scale = newBnds.size.width / self.bounds.size.width;
//		yScale = newBnds.size.height / self.bounds.size.height;
//	}
}

//- (void)setDrawingDestination:(id <DrawDestination_protocol>)value {
//	
//	[super setDrawingDestination:value];
////	[nodes makeObjectsPerformSelector:@selector(setDrawingDestination:) withObject:value];
//}
//
@end
