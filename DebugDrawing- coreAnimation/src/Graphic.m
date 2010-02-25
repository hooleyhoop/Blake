//
//  Graphic.m
//  DebugDrawing
//
//  Created by steve hooley on 24/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Graphic.h"
#import "XForm.h"
#import "BoundingGeometry.h"
#import "LayerFamiliar.h"
#import "ConcatenatedMatrixObserver.h"

@interface Graphic ()

- (void)turnOnConcatenatedMatrixObserving;
- (void)turnOffConcatenatedMatrixObserving;

@end


/*
 *
*/
@implementation Graphic

#pragma mark -

#ifdef DEBUG
//june09@synthesize DEBUG_drawingDestination;
#else
#warning SHould it?
#endif

@synthesize concatenatedMatrixObserver = _concatenatedMatrixObserver;

//june09@synthesize xformDidChange=_xformDidChange, drawingBoundsDidChange=_drawingBoundsDidChange;
//june09@dynamic transformMatrix;
//june09@synthesize xForm=_xForm;
// @synthesize geometryOrigin;

#pragma mark Class Methods
+ (int)executionMode {
	// 0 - call evaluate when asked and when dirty - most once per frame	// PROCESSOR
	// 1 - call evaluate when asked - most once per frame					// PROVIDER
	// 2 - call once per frame												// CONSUMER
	return CONSUMER;
}

#pragma mark Init Methods
- (id)init {
		
	self = [super init];
	if(self){
		
		_layerFamiliar = [[LayerFamiliar alloc] init];

//june09		_dirtyRect = NSZeroRect;
//june09        _drawingBoundsDidChange = YES;

		// You must call enforceConsistentState from sublass init
		
	}
	return self;
}

- (void)dealloc {

	[_layerFamiliar release];
	[super dealloc];
}

#pragma mark Action Methods
/* like an end of run loop thing - we may want to get a patch uptodate but not have it do it's evaluateOncePerFrame 
 eg. when we are dragging a tool, so in a way evaluateOncePerFrame is broken into two parts - enabling us to only call
 the finalize bit if we need to do so
 */
- (void)enforceConsistentState {
	
	[_layerFamiliar enforceConsistentState];
}

// -- dont apply the matrix here, we need to test bounds and draw as
// -- seperate operations and dont want to apply the matrix twice
- (void)_debugHitTestDrawing:(CGContextRef)cntx {

	//TODO: wrong colourspace
	CGContextSetRGBFillColor( cntx, 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect( cntx, _layerFamiliar.geometryRect );
}

/* Return the geometry rect multiplied by the contexts affineXform */
- (CGRect)didDrawAt:(CGContextRef)cntx {
	return 	[_layerFamiliar didDrawAt:cntx];
}

- (void)_setupDrawing:(CGContextRef)cntx {
	
	[_layerFamiliar applyMatrixToContext:cntx];
}

- (void)_tearDownDrawing:(CGContextRef)cntx {
	[_layerFamiliar restoreContext:cntx];
}

#pragma mark ConcatenatedMatrix Stuff
- (void)turnOnConcatenatedMatrixObserving {

	if(!_concatenatedMatrixObserver)
	{
		_concatenatedMatrixObserver = [[ConcatenatedMatrixObserver alloc] initWithCallback:self];
		[_concatenatedMatrixObserver beginObservingConcatenatedMatrix];

		id nearestParentSupportingProtocol = [self nearestParentSupportingProtocol:@protocol(ConcatenatedMatrixObserverCallBackProtocol)];
		[nearestParentSupportingProtocol turnOnConcatenatedMatrixObserving];
	}
}

- (void)turnOffConcatenatedMatrixObserving {

	if(_concatenatedMatrixObserver)
	{
		// 	-- shit we dont always want to turn off for the parent! Check to see if we got any children still observing
		NSArray *childrenStillObserving = [self childrenToTellConcatenatedMatrixIsDirty];
		if( [childrenStillObserving count]==0 ){
			[_concatenatedMatrixObserver endObservingConcatenatedMatrix];
			[_concatenatedMatrixObserver release]; 
			_concatenatedMatrixObserver = nil;
			
			id nearestParentSupportingProtocol = [self nearestParentSupportingProtocol:@protocol(ConcatenatedMatrixObserverCallBackProtocol)];
			[nearestParentSupportingProtocol turnOffConcatenatedMatrixObserving];
		}
	}
}

#pragma mark ConcatenatedMatrixObserverCallBackProtocol Callbacks

// Seriously - what the fuck?
- (NSArray *)childrenToTellConcatenatedMatrixIsDirty {
	
	if(_concatenatedMatrixObserver)
	{
		NSArray *allChildrenToTell = [self nearestChildNodesSupportingProtocol:@protocol(ConcatenatedMatrixObserverCallBackProtocol)];
		//-- only those children with a _concatenatedMatrixObserver
		NSMutableArray *filteredItems = [allChildrenToTell itemsThatResultOfSelectorIsNotNIL:@selector(concatenatedMatrixObserver)];
		return filteredItems;
	}
	return nil;
}

#pragma mark Notifications
- (void)isAboutToBeDeletedFromParentSHNode {
}

- (void)hasBeenAddedToParentSHNode {

	// force dirty drawing
	[self enforceConsistentState];

	[super hasBeenAddedToParentSHNode];
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
	
	if( [keyPath isEqualToString:@"transformMatrix"] || [keyPath isEqualToString:@"geometryRect"] ) {
		[_layerFamiliar addObserver:observer forKeyPath:keyPath options:options context:context];
		return;
	} else if( [keyPath isEqualToString:@"concatenatedMatrixNeedsRecalculating"] )
	{
		//TODO: 
		//whoops!. only one observer allowed at the minute => TEST THIS!
		[self turnOnConcatenatedMatrixObserving];
		[_concatenatedMatrixObserver addObserver:observer forKeyPath:@"concatenatedMatrixNeedsRecalculating" options:options context:context];
		return;
	}
	[NSException raise:@"what else is there?" format:@""];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
	
	if( [keyPath isEqualToString:@"transformMatrix"] || [keyPath isEqualToString:@"geometryRect"] ) {
		[_layerFamiliar removeObserver:observer forKeyPath:keyPath];
		return;
	} else if( [keyPath isEqualToString:@"concatenatedMatrixNeedsRecalculating"] ){
		[_concatenatedMatrixObserver removeObserver:observer forKeyPath:@"concatenatedMatrixNeedsRecalculating"];
		[self turnOffConcatenatedMatrixObserving];
		return;
	}
	[NSException raise:@"what else is there?" format:@""];
}

#pragma mark accessors
- (CGRect)geometryRect {
	return [_layerFamiliar geometryRect];
}

- (void)setGeometryRect:(CGRect)val {
	[_layerFamiliar setGeometryRect:val];
}

// This needs to return the compensated matric to work correctly - but..
// i am trying to find a different way to offset the layers bounds without
// polluting the matrix
- (CGAffineTransform)transformMatrix {
    return [_layerFamiliar transformMatrix];
}

- (CGAffineTransform)concatenatedMatrix {
	
	NSAssert( _concatenatedMatrixObserver, @"we must observe before we can access concatenatedMatrix");
	
	if([self _concatenatedMatrixIsDirty]){
		CGAffineTransform resultMat;
		CGAffineTransform thisMat = [self.xForm unCompensatedTransformMatrix];
		id nearestParentSupportingProtocol = [self nearestParentSupportingProtocol:@protocol(ConcatenatedMatrixObserverCallBackProtocol)];
		if(nearestParentSupportingProtocol){
			CGAffineTransform previousMat = [nearestParentSupportingProtocol concatenatedMatrix];
			resultMat = CGAffineTransformConcat(previousMat, thisMat);
		} else {
			resultMat = thisMat;
		}
		[_concatenatedMatrixObserver setConcatenatedMatrix:resultMat];
		
	}
	return [_concatenatedMatrixObserver concatenatedMatrix];
}

- (BOOL)_concatenatedMatrixIsDirty {

	NSAssert( _concatenatedMatrixObserver, @"we must observe before we can access concatenatedMatrix");
    return [_concatenatedMatrixObserver concatenatedMatrixNeedsRecalculating];
}

- (CGFloat)scale {
	return _layerFamiliar.scale;
}

- (void)setScale:(CGFloat)val {
    _layerFamiliar.scale = val;
}

- (CGPoint)position {
    return _layerFamiliar.position;
}

- (void)setPosition:(CGPoint)val {
	_layerFamiliar.position =val;
}

- (CGPoint)anchorPt {
    return _layerFamiliar.anchorPt;
}

/* anchor point is relative to lower left point of bounds */
- (void)setAnchorPt:(CGPoint)val {
	_layerFamiliar.anchorPt = val;
}

- (CGFloat)rotation {
	return [_layerFamiliar rotation];
}

- (void)setRotation:(CGFloat)val {
	[_layerFamiliar setRotation:val];
}

- (XForm *)xForm {
	return [_layerFamiliar xForm];
}

// anti clockwise pts of the geometry rect from bottom left
//june09- (void)transformedGeometryRectPoints:(CGPoint *)ptArray {
//june09	[_layerFamiliar transformedGeometryRectPoints:ptArray];
//june09}

//june09- (NSRect)transformedGeometryRectBoundingBox {
//june09	return [_layerFamiliar transformedGeometryRectBoundingBox];
//june09}

//june09- (CGPoint)convertPoint:(CGPoint)p1 toGraphic:(Graphic *)node {
	
	// node must be a prent of self
//june09	NSArray *rev3 = [node reverseNodeChainToNode:self];
//june09	CGAffineTransform finalXForm = CGAffineTransformIdentity;
//june09	for(NSUInteger i=[rev3 count]; i>0; i--){
//june09		SHNode *n = [rev3 objectAtIndex:i-1];
//june09		if([n respondsToSelector:@selector(xForm)]){
//june09			XForm *hmmmXForm = [(id)n xForm];
//june09			// which matric do we need?
//june09			finalXForm = CGAffineTransformConcat( finalXForm, hmmmXForm.unCompensatedTransformMatrix );
//june09		}
//june09	}
//june09	return CGPointApplyAffineTransform( p1, finalXForm );
//june09}

#pragma mark Delegate Methods
// Disable Animations
// transform
// onOrderIn
// onDraw
// contents
// onOrderOut
// sublayers
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
	//	logInfo(@"action for key %@", key);
	return (id<CAAction>)[NSNull null];
}

/* we may draw well outside of the geometry bounds, eg if a rect has a stroke - we must still mark this area as dirty */
//june09- (NSRect)drawingBounds {

//june09    NSAssert(_drawingBoundsDidChange==NO, @"This drawing bounds is invalid");
//june09    return _drawingBounds;
//june09}


//june09- (void)addDirtyRectObserver:(id<DirtyRectObserverProtocol>)value {
//june09	if(dirtyRectObservers==nil)
//june09		dirtyRectObservers = [[NSMutableArray array] retain];
//june09	/* check that this isnt a reorder */
//june09	if([dirtyRectObservers indexOfObjectIdenticalTo:value]==NSNotFound )
//june09		[dirtyRectObservers addObject:value];
//june09}

//june09- (void)removeDirtyRectObserver:(id<DirtyRectObserverProtocol>)value {
//june09	NSAssert([dirtyRectObservers indexOfObjectIdenticalTo:value]!=NSNotFound, @"dont have object");
//june09	[dirtyRectObservers removeObject:value];
//june09}

//june09- (NSRect)dirtyRect {
//june09	return _dirtyRect;
//june09}

//june09- (void)setDirtyRect:(NSRect)value {

//june09	_dirtyRect = value;
//	for(id<DirtyRectObserverProtocol> each in dirtyRectObservers){
//		[each graphic:self becameDirtyInRect:_dirtyRect];
//	}
//june09}

//june09- (void)resetDirtyRect {
//june09	_dirtyRect = NSZeroRect;
//june09}

/* Hmm, bit complicated how to interpret this - with scale, rotation and everything */
//june09- (void)setPhysicalBounds:(NSRect)val {
	
	// anti clockwise pts of the geometry rect from bottom left
//june09	CGPoint p1 = val.origin;
//june09	CGPoint p2 = CGPointMake( p1.x+val.size.width, p1.y );
//june09	CGPoint p3 = CGPointMake( p2.x, p2.y+val.size.height );

//june09	p1 = [self parentSpacePtToLocalSpace:p1];
//june09	p3 = [self parentSpacePtToLocalSpace:p3];

//june09	NSRect transformedBounds = NSMakeRect( p1.x, p1.y, p3.x-p1.x, p3.y-p1.y );
//june09	[self setGeometryRect: transformedBounds ];
//june09}


//june09- (void)setTransformMatrix:(NSAffineTransform *)atm {
//june09	[_xForm setTransformMatrix:atm];
//june09}


//june09- (void)recalculateDrawingBounds {

//june09	NSAssert(_drawingBoundsDidChange==YES, @"No Need to call!");
//june09	_drawingBoundsDidChange = NO;
//june09}

//june09+ (CGRect)enclosingRectOfAnchorPts:(NSArray *)graphics {

//june09	CGRect anchorBounds = CGRectZero;
//june09   if( [graphics count]>0 )
//june09	{
//june09		for( Graphic *graphic in graphics){
//june09			CGPoint anchorPt = [graphic position];
//june09			if(CGRectIsEmpty(anchorBounds))
//june09					anchorBounds = CGRectMake(anchorPt.x, anchorPt.y,1.0f,1.0f);
//june09				else
//june09					anchorBounds = CGRectUnion(anchorBounds, CGRectMake(anchorPt.x, anchorPt.y,1.0f,1.0f) );
//june09		}
//june09	}
//june09    return anchorBounds;
//june09}

- (void)translateByX:(CGFloat)x byY:(CGFloat)y {
//june09	[self setPosition: CGPointMake(_position.x+x, _position.y+y)];
}

//june09- (void)moveEdge:(int)edge byX:(CGFloat)xamount byY:(CGFloat)yamount {
//june09    NSAffineTransform *rotateTransform = [NSAffineTransform transform];
//june09    [rotateTransform rotateByDegrees:-_rotationDegress];
//june09	NSAffineTransform *scaleTransform = [NSAffineTransform transform];
//june09	[scaleTransform scaleXBy:1.0/_scale yBy:1.0/_scale];
//june09    NSAffineTransform *finalTXForm = [NSAffineTransform transform];
//june09	[finalTXForm appendTransform:scaleTransform];
//june09	[finalTXForm appendTransform:rotateTransform];
//june09    CGPoint newPos = [finalTXForm transformPoint:CGPointMake(xamount, yamount)];	
//june09	xamount = newPos.x;
//june09	yamount = newPos.y;

//june09	NSRect movedBounds = NSMakeRect(_geometryOrigin.x, _geometryOrigin.y, _geometryRect.size.width, _geometryRect.size.height);
//june09	if(edge==SKTGraphicLeftEdge){
//june09		movedBounds.origin.x = _geometryOrigin.x+xamount;
//june09		movedBounds.size.width = movedBounds.size.width-xamount;
//june09	}
//june09	else if(edge==SKTGraphicRightEdge){
//june09		movedBounds.size.width = movedBounds.size.width+xamount;
//june09	}
//june09	else if(edge==SKTGraphicTopEdge){
//june09		movedBounds.size.height = movedBounds.size.height+yamount;	
//june09	}
//june09	else if(edge==SKTGraphicBottomEdge){
//june09		movedBounds.origin.y = _geometryOrigin.y+yamount;
//june09		movedBounds.size.height = movedBounds.size.height-yamount;	
//june09	}
//june09	[self setGeometryRect:movedBounds]; 
//june09}

//june09- (void)moveAnchorByWorldAmountX:(CGFloat)x byY:(CGFloat)y {
//june09    NSAffineTransform *rotateTransform = [NSAffineTransform transform];
//june09    [rotateTransform rotateByDegrees:-_rotationDegress];

//-- concat the transforms
//june09   NSAffineTransform *finalTXForm = [NSAffineTransform transform];
//june09	[finalTXForm appendTransform:rotateTransform];

//-- apply the transform
//june09    CGPoint newPos = [finalTXForm transformPoint:CGPointMake(x, y)];	
//june09	[self setAnchorPt: CGPointMake(_anchorPt.x+newPos.x, _anchorPt.y+newPos.y)];
//june09}

#pragma mark USELESS!
//- (CGPoint)localPtToParentSpace:(CGPoint)value {
//    return [_layerFamiliar localPtToParentSpace:value];
//}

// opposite transform to normal
//- (CGPoint)parentSpacePtToLocalSpace:(CGPoint)value {
//    return [_layerFamiliar parentSpacePtToLocalSpace:value];
//}

@end
