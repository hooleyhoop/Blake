//
//  SHEmptyGroupOperator.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 15/11/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SHEmptyGroupOperator.h"


@implementation SHEmptyGroupOperator


#pragma mark -
#pragma mark init methods


// overriden
// ===========================================================
// - initInputs:
// ===========================================================
- (void)initInputs
{	
}


// overriden
// ===========================================================
// - initOutputs:
// ===========================================================
- (void)initOutputs
{
}

#pragma mark action methods
// overriden
// ===========================================================
// - evaluate:
// ===========================================================
//- (void)evaluate
//{
	// loop through all outputs and get val to cause the chain to update
//	int i, count = [_orderedOutputs count];
//	SHOutputAttribute* output;
//	for(i=0;i<count;i++){
//		output = [_orderedOutputs objectAtIndex:i];
//		[output value];
//	}
//}

#pragma mark accessor methods
- (BOOL) isLeaf{
	return NO;
}

@end
