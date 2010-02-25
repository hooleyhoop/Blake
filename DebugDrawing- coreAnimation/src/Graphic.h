//
//  Graphic.h
//  DebugDrawing
//
//  Created by steve hooley on 24/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "DrawDestination_protocol.h"
#import "DirtyRectObserverProtocol.h"
#import "iAmTransformableProtocol.h"
#import "ConcatenatedMatrixObserverCallBackProtocol.h"

enum SKTGraphicDrawingMode {
    SKTGraphicNormalFill = 1,
    SKTGraphicWireframe = 2,
    SKTGraphicHitTest = 3,
    SKTGraphicEditingText = 4,
};


enum GraphicEdges {
    SKTGraphicTopEdge = 1,
    SKTGraphicLeftEdge = 2,
    SKTGraphicRightEdge = 3,
    SKTGraphicBottomEdge = 4,
};

@class XForm, BoundingGeometry, LayerFamiliar, ConcatenatedMatrixObserver;

@interface Graphic : SHNode <iAmGraphicNodeProtocol, ConcatenatedMatrixObserverCallBackProtocol> {

	LayerFamiliar					*_layerFamiliar;
	ConcatenatedMatrixObserver		*_concatenatedMatrixObserver;
	
	
#ifdef DEBUG
//june09	id <DrawDestination_protocol>	DEBUG_drawingDestination;
#endif
}

#ifdef DEBUG
 //june09   @property (assign, readwrite) id <DrawDestination_protocol> DEBUG_drawingDestination;
#else
	#warning DEBUG IS OFF!
#endif

@property (readonly) ConcatenatedMatrixObserver *concatenatedMatrixObserver;

//june09@property (retain) NSAffineTransform *transformMatrix;
//june09@property (assign) BOOL xformDidChange, drawingBoundsDidChange;
//june09@property (assign) CGPoint geometryOrigin;


// called after -evaluateWithTime. Like end of run loop thing
- (void)enforceConsistentState;

// Return the total drawing bounds of all of the graphics in the array.
//june09+ (CGRect)enclosingRectOfAnchorPts:(NSArray *)graphics;

- (void)translateByX:(CGFloat)x byY:(CGFloat)y;

//june09- (void)moveAnchorByWorldAmountX:(CGFloat)x byY:(CGFloat)y;
//june09- (void)moveEdge:(int)edge byX:(CGFloat)xamount byY:(CGFloat)yamount;

/* Well behaved graphics only care that they draw to the current destination, not what that destination is */
//- (void)drawWithHint:(enum SKTGraphicDrawingMode)mode;

/* The drawing routines */
- (void)_setupDrawing:(CGContextRef)cntx;

//june09- (void)_customDrawing;
- (CGRect)didDrawAt:(CGContextRef)cntx;
- (void)_debugHitTestDrawing:(CGContextRef)cntx;

- (void)_tearDownDrawing:(CGContextRef)cntx;



//june09- (void)addDirtyRectObserver:(id<DirtyRectObserverProtocol>)value;
//june09- (void)removeDirtyRectObserver:(id<DirtyRectObserverProtocol>)value;

- (CGFloat)scale;
- (void)setScale:(CGFloat)val;
- (CGPoint)position;
- (void)setPosition:(CGPoint)val;
- (CGPoint)anchorPt;
- (void)setAnchorPt:(CGPoint)val;
- (CGFloat)rotation;
- (void)setRotation:(CGFloat)val;

/* you can not set the drawing bounds, but it is ok for the drawing bounds to be different than the physical bounds
	eg, you might have a handle or something, but you dont want that to be taken into account when you call setPhysicalBounds */
//june09- (NSRect)drawingBounds;

/* The geometry rest is in local coords - not world space */
- (CGRect)geometryRect;
- (void)setGeometryRect:(CGRect)val;

//june09- (void)transformedGeometryRectPoints:(CGPoint *)ptArray;
//june09- (NSRect)transformedGeometryRectBoundingBox;

- (XForm *)xForm;

//june09- (void)setPhysicalBounds:(NSRect)val;
//june09- (CGAffineTransform)unCompensated_transformMatrix;

//june09- (NSRect)dirtyRect;
//june09- (void)setDirtyRect:(NSRect)value;
//june09- (void)resetDirtyRect;

- (void)turnOnConcatenatedMatrixObserving;
- (void)turnOffConcatenatedMatrixObserving;

//june09- (void)recalcTransformMatrix;
- (CGAffineTransform)transformMatrix;
//june09- (void)setTransformMatrix:(NSAffineTransform *)atm;

- (CGAffineTransform)concatenatedMatrix;
- (BOOL)_concatenatedMatrixIsDirty;

//june09- (void)recalculateDrawingBounds;

//june09- (CGPoint)convertPoint:(CGPoint)p1 toGraphic:(Graphic *)node;

#pragma mark Delegate Methods
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key;

#pragma mark USELESS!
//- (CGPoint)parentSpacePtToLocalSpace:(CGPoint)value __attribute__((deprecated));
//- (CGPoint)localPtToParentSpace:(CGPoint)value __attribute__((deprecated));

@end
