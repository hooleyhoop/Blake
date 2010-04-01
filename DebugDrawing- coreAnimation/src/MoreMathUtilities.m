//
//  MoreMathUtilities.m
//  DebugDrawing
//
//  Created by steve hooley on 08/07/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "MoreMathUtilities.h"
#import "XForm.h"

@implementation MoreMathUtilities


#pragma mark Matrix Stuff
CGPoint convertPtToChildSpace( CGPoint pt, NSArray *xForms ) {
	CGAffineTransform resultantAffXForm = [XForm resultantReverseAffineXForm:xForms];
    return CGPointApplyAffineTransform( pt, resultantAffXForm );
}

CGPoint convertPtFromChildSpace( CGPoint pt, NSArray *xForms ) {
	CGAffineTransform resultantAffXForm = [XForm resultantAffineXForm:xForms];
    return CGPointApplyAffineTransform( pt, resultantAffXForm );
}



@end
