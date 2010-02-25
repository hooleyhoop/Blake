//
//  SHMultiplyOperator.h
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHAbstractOperator.h"

@class SHInputAttribute, SHOutputAttribute;
/*
 *
*/
@interface SHMultiplyOperator : SHAbstractOperator {

	SHInputAttribute			*operand1;
	SHInputAttribute			*operand2;
	SHOutputAttribute			*operand3;
}

#pragma mark -
#pragma mark class methods

#pragma mark init methods
- (void)initInputs;
- (void)initOutputs;

#pragma mark action methods
- (BOOL)execute:(id)fp8 head:()np time:(double)timeKey arguments:(id)fp20;

#pragma mark accessor methods


@end
