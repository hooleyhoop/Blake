//
//  BoundingGeometry.h
//  DebugDrawing
//
//  Created by steve hooley on 10/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface BoundingGeometry : _ROOT_OBJECT_ {

	// maybe move geometry to another class
	// something going on here.. we save _geometryRect as zero bounded and save the real origin in _geometryOrigin
	// why the fuck??
	
	// I think we always make the CALayer's bounds from ZERO
	// but our origin can be anywhere
	CGPoint _geometryOrigin;
	CGRect _geometryRect;
	BOOL _geomDidChange;
}

@property (assign) CGRect geometryRect;
@property (assign) CGPoint geometryOrigin;
@property (assign) BOOL geomDidChange;

@end
