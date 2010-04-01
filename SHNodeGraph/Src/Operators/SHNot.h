//
//  SHNot.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 20/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHAbstractOperator.h"
@class SHInputAttribute, SHOutputAttribute;


@interface SHNot : SHAbstractOperator {

	SHInputAttribute			*operand1;
	SHOutputAttribute			*operand2;

}

- (void)initInputs;
- (void)initOutputs;

@end
