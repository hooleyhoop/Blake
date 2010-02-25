//
//  SHEmptyGroupOperator.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/11/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHProtoOperator.h"

@interface SHEmptyGroupOperator : SHProtoOperator {

}

#pragma mark -
#pragma mark init methods

- (id)initWithParentNodeGroup:(SHNodeGroup*)aNG;

// overriden
- (void)initInputs;
// overriden
- (void)initOutputs;


#pragma mark action methods
// overriden
//- (void)evaluate;


#pragma mark accessor methods

@end
