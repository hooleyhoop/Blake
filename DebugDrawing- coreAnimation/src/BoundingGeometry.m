//
//  BoundingGeometry.m
//  DebugDrawing
//
//  Created by steve hooley on 10/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "BoundingGeometry.h"
//#import "MathUtilities.h"

@implementation BoundingGeometry

@synthesize geometryRect=_geometryRect;
@synthesize geometryOrigin=_geometryOrigin;
@synthesize geomDidChange=_geomDidChange;

- (id)init {
	
	self = [super init];
	if(self){
		_geometryRect = CGRectZero;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)setGeometryRect:(CGRect)val {
    
	/* the separate origin stuff is so that when drawing and editing lines and curves you dont always need to 
		move the entire line so that it's bottom left point is at the origin. Seemed like a good idea at the time
		put the downside is that the xForm is now dependant on the geometry bounds, and not just scale, position, rotation.
		This is a pain and not worth it so I am trying it the moe conventfional way with All geometry bounded at the 
		origin. The cruft of the old way will remain until i am fairly certain.
	 */

	NSParameterAssert( G3DCompareFloat(val.origin.x, .0f, 0.001f)==0 && G3DCompareFloat(val.origin.y, .0f, 0.001f)==0 );
	
	if(!CGRectEqualToRect(_geometryRect, val) ){
		_geometryOrigin = val.origin;
		_geometryRect = val;
		_geomDidChange = YES;
	}
}

@end
