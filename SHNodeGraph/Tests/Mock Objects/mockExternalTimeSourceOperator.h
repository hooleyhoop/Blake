//
//  mockExternalTimeSourceOperator.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 27/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNode.h"

/*
 *
*/
@interface mockExternalTimeSourceOperator : SHNode <SHExternalTimeSourceProtocol> {
	
	SHInputAttribute			*operand1;
}

#pragma mark -
#pragma mark class methods

#pragma mark init methods
- (void)initInputs;

#pragma mark action methods

- (BOOL)execute:(id)fp8 head:()np time:(double)timeKey arguments:(id)fp20;

#pragma mark accessor methods

@end
