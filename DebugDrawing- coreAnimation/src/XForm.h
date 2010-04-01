//
//  XForm.h
//  DebugDrawing
//
//  Created by Steven Hooley on 7/7/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

@interface XForm : _ROOT_OBJECT_ {

	// Observe this	- _scale, rotationDegress, _anchorPt, _position
//june09	CGAffineTransform _originCompensatedTransformMatrix;
	CGAffineTransform _unCompensatedTransformMatrix, _reverseMatrix;

	// Do not directly observe these properties
    CGFloat		_scale, _rotationDegress;
    CGPoint		_anchorPt, _position;
	
    BOOL		_needsRecalculating, _reverseMatrixNeedsRecalculating;
}

@property (assign) CGFloat scale, rotation;
@property (assign) CGPoint anchorPt, position;
@property (readonly) CGAffineTransform unCompensatedTransformMatrix;
@property (readonly) CGAffineTransform reverseMatrix;
// @property (readwrite) CGAffineTransform originCompensatedTransformMatrix;
@property (readonly) BOOL needsRecalculating;

+ (CGAffineTransform)resultantAffineXForm:(NSArray *)xForms;
+ (CGAffineTransform)resultantReverseAffineXForm:(NSArray *)xForms;

- (void)enforceConsistentState;

/* Temporarily disabling this */
//- (void)enforceConsistentState:(BoundingGeometry *)geom;

// why do i need both transformation matrices?

//- (void)_recalcOriginCompensatedTransformMatrix:(BoundingGeometry *)geom;
- (void)_recalcUnCompensatedTransformMatrix;

- (void)setRotation:(CGFloat)val;

#pragma mark Surely These are useless?
// which matrix to use?
- (CGPoint)localPtToParentSpace:(CGPoint)value __attribute__((deprecated));
- (CGPoint)parentSpacePtToLocalSpace:(CGPoint)value __attribute__((deprecated));


@end
