//
//  XForm.m
//  DebugDrawing
//
//  Created by Steven Hooley on 7/7/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "XForm.h"
//#import "MathUtilities.h"

@interface XForm ()

// an overide so we can set it and trigger notifications
@property (readwrite) CGAffineTransform unCompensatedTransformMatrix;
@property (readwrite) BOOL needsRecalculating;

@end


/*
 *
*/
@implementation XForm


@synthesize scale=_scale, anchorPt=_anchorPt, position=_position;
@synthesize rotation=_rotationDegress;
//june09@synthesize originCompensatedTransformMatrix=_originCompensatedTransformMatrix;
@dynamic unCompensatedTransformMatrix;
@synthesize reverseMatrix=_reverseMatrix;
@synthesize needsRecalculating=_needsRecalculating;

#pragma mark Class Methods
/* From parent to child return the resulting xForm 
	 -- Use if you have
	 -- xForm1
	 --- xForm2
	 ---- xForm3
 and you want to convert a point from xForm1 space to its position in xForm3 space -- or maybe the other way round --

 */
+ (CGAffineTransform)resultantAffineXForm:(NSArray *)xForms {
	
	NSParameterAssert([xForms count]);
	
	CGAffineTransform resultantAffXForm = CGAffineTransformIdentity;
	for( XForm *each in [xForms reverseObjectEnumerator] ){
		CGAffineTransform affXForm1 = each.unCompensatedTransformMatrix;
		resultantAffXForm = CGAffineTransformConcat( resultantAffXForm,  affXForm1);
	}
	return resultantAffXForm;
}

/* From parent to child return the resulting xForm 
	-- Use if you have
	-- xForm1
	--- xForm2
	---- xForm3
 and you want to convert a point from xForm3 space (say xForm3's origin (0,0) ) to its position in xForm1 you would use this -- or the other way round, can't remember
 */
+ (CGAffineTransform)resultantReverseAffineXForm:(NSArray *)xForms {

	NSParameterAssert([xForms count]);

	CGAffineTransform resultantAffXForm = CGAffineTransformIdentity;
	for( XForm *each in xForms ){
		CGAffineTransform affXForm1 = each.reverseMatrix;
		resultantAffXForm = CGAffineTransformConcat( resultantAffXForm, affXForm1 );
	}
	return resultantAffXForm;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	
    if( [theKey isEqualToString:@"needsRecalculating"] )
        return NO;
	else
		[NSException raise:@"what else is there?" format:@""];
	return [super automaticallyNotifiesObserversForKey:theKey];
}

#pragma mark Init Methods
- (id)init {
	
	self = [super init];
	if(self){
		_scale = 1.0f;
		_rotationDegress = 0.0f;
		_anchorPt = CGPointMake(0.f, 0.f);
		_position = CGPointMake(0.f, 0.f);
		_needsRecalculating = YES;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark action methods
/* like an end of run loop thing - we may want to get a patch uptodate but not have it do it's evaluateOncePerFrame 
 eg. when we are dragging a tool, so in a way evaluateOncePerFrame is broken into two parts - enabling us to only call
 the finalize bit if we need to do so
 */
- (void)enforceConsistentState {
//- (void)enforceConsistentState:(BoundingGeometry *)geom {
	
	/* Again with the two transforms! */
	if(_needsRecalculating==YES) {
		
		// temporarily disabling this - doesn't seem right
//		[self _recalcOriginCompensatedTransformMatrix:geom];
		[self _recalcUnCompensatedTransformMatrix];
		_needsRecalculating = NO;
		
		// this is lazily made when needed
		_reverseMatrixNeedsRecalculating = YES;
	}
}

- (CGAffineTransform)_offsetMatrix:(CGPoint)anchorOffset {
	
	/* Translate the anchor point to the origin */
	CGFloat anchorOffx = -_anchorPt.x + anchorOffset.x;
	CGFloat anchorOffy = -_anchorPt.y + anchorOffset.y;
	CGAffineTransform anchorTransform = CGAffineTransformMakeTranslation( anchorOffx, anchorOffy );
	CGAffineTransform scaleTransform = CGAffineTransformMakeScale( _scale, _scale );
	CGAffineTransform positionTransform = CGAffineTransformMakeTranslation( _position.x, _position.y );
	CGAffineTransform rotateTransform = CGAffineTransformMakeRotation( DEGREES_TO_RADIANSF(_rotationDegress) );
	
	//-- concat the transforms
	CGAffineTransform finalXForm = CGAffineTransformConcat( anchorTransform, rotateTransform );
	finalXForm = CGAffineTransformConcat( finalXForm, scaleTransform );
	finalXForm = CGAffineTransformConcat( finalXForm, positionTransform );
	
    return finalXForm;
}


/* i really thought this would be the inverse of our xForm - but it doesn't seem to be */
- (void)_recalcReverseTransformMatrix {
	
	NSAssert(_needsRecalculating==NO, @"cant recalc _reverseMatrixNeedsRecalculating if xform is invalid - well, i could but something has gone wrong");
	NSAssert(_reverseMatrixNeedsRecalculating==YES, @"_reverseMatrixNeedsRecalculating doesnt need recalculating");
	
	CGAffineTransform rotateTransform = CGAffineTransformMakeRotation( DEGREES_TO_RADIANSF(-_rotationDegress) );
	CGAffineTransform anchorTransform = CGAffineTransformMakeTranslation( _anchorPt.x, _anchorPt.y );
	CGAffineTransform scaleTransform = CGAffineTransformMakeScale( 1.0f/_scale, 1.0f/_scale );
	CGAffineTransform positionTransform = CGAffineTransformMakeTranslation( -_position.x, -_position.y );
	
	//-- concat the transforms
	CGAffineTransform finalXForm = CGAffineTransformConcat( positionTransform, scaleTransform );
	finalXForm = CGAffineTransformConcat( finalXForm, rotateTransform );
	finalXForm = CGAffineTransformConcat( finalXForm, anchorTransform );
	
	_reverseMatrix = finalXForm;
	_reverseMatrixNeedsRecalculating = NO;
}

// should only be done once per cycle
//june09- (void)_recalcOriginCompensatedTransformMatrix:(BoundingGeometry *)geom {
//june09    self.originCompensatedTransformMatrix = [self _offsetMatrix:geom.geometryOrigin];
//june09}

- (void)_recalcUnCompensatedTransformMatrix {
    self.unCompensatedTransformMatrix = [self _offsetMatrix:CGPointZero];
}

#pragma mark accessor methods
- (void)setScale:(CGFloat)val {
    
	if( G3DCompareFloat( val, _scale, 0.001f )!=0 ){
		_scale = val;
		self.needsRecalculating = YES;
	}
}

- (void)setPosition:(CGPoint)val {
    
	if(!CGPointEqualToPoint(val, _position)){
		_position =val;
		self.needsRecalculating = YES;
	}
}

/* anchor point is relative to lower left point of bounds */
- (void)setAnchorPt:(CGPoint)val {
	
	if(!CGPointEqualToPoint(val, _anchorPt)){
		_anchorPt = val;
		self.needsRecalculating = YES;
	}
}

- (void)setRotation:(CGFloat)val {
	
	if( G3DCompareFloat(val, _rotationDegress, 0.001f)!=0 ){
		_rotationDegress = val;
		self.needsRecalculating = YES;
	}
}

- (void)setNeedsRecalculating:(BOOL)value {
	
	if(value!=_needsRecalculating){
		[self willChangeValueForKey:@"needsRecalculating"];
		_needsRecalculating = value;
		[self didChangeValueForKey:@"needsRecalculating"];
	}
}

- (CGAffineTransform)reverseMatrix {

	if(_reverseMatrixNeedsRecalculating)
		[self _recalcReverseTransformMatrix];
	return _reverseMatrix;
}

#pragma mark Surely These are useless?
// formerly - localPtToWorldSpace
- (CGPoint)localPtToParentSpace:(CGPoint)p1 {

	NSAssert(_needsRecalculating==NO, @"oops");
	
	/* Our transform compensates for bounds origin not being (0,0) but this doesnt affect coordinate transforms so we must UN-COMPENSATE! */
    return CGPointApplyAffineTransform( p1, _unCompensatedTransformMatrix );
}

// opposite transform to normal
// formerly - worldPtToLocalSpace
- (CGPoint)parentSpacePtToLocalSpace:(CGPoint)p1 {
    return CGPointApplyAffineTransform( p1, self.reverseMatrix );
}

- (CGAffineTransform)unCompensatedTransformMatrix {

	NSAssert(_needsRecalculating==NO, @"affineTransform hasn't been updated");
	return _unCompensatedTransformMatrix;
}

- (void)setUnCompensatedTransformMatrix:(CGAffineTransform)value {

	_unCompensatedTransformMatrix = value;
}

@end
