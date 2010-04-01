//
//  MoreMathUtilities.h
//  DebugDrawing
//
//  Created by steve hooley on 08/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

@interface MoreMathUtilities : _ROOT_OBJECT_ {

}

#pragma mark Test Equality

/* Dont forget about good stuff like CGRectIsEmpty, CGRectIsNull, CGRectIsInfinite */
 
#pragma mark Matrix Stuff
CGPoint convertPtToChildSpace( CGPoint pt, NSArray *xForms );
CGPoint convertPtFromChildSpace( CGPoint pt, NSArray *xForms );

@end
