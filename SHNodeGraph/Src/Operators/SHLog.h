//
//  SHLog.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 20/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHAbstractOperator.h"
@class SHInputAttribute, SHOutputAttribute;

@interface SHLog : SHAbstractOperator {

	SHInputAttribute	*operand1;
}

#pragma mark -
#pragma mark init methods
- (void)initInputs;

@end
