//
//  SHAbsOperator.h
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHAbstractOperator.h"
@class SHInputAttribute, SHOutputAttribute;


@interface SHAbsOperator : SHAbstractOperator {
	// adds two input properties and puts result in output property
	SHInputAttribute			*operand1;
	SHOutputAttribute			*operand2;
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
