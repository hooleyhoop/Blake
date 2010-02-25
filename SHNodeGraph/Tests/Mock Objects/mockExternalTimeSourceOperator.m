//
//  mockExternalTimeSourceOperator.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 27/08/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "mockExternalTimeSourceOperator.h"
#import "SHAttribute.h"
#import "SHInputAttribute.h"
#import <SHShared/BBLogger.h>


/*
 *
*/
@implementation mockExternalTimeSourceOperator

- (id)init {
	
	if( (self=[super init])!=nil )
	{
		[self initInputs];
	} 
	return self;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {
	
    [super dealloc];
}


// ===========================================================
// - initInputs:
// ===========================================================
- (void)initInputs
{	
	// makes a default SHNumber attribute
	operand1 = [[[SHInputAttribute alloc] init] autorelease];
	[self addPrivateChild: operand1];
		
	// Change the default name that is assigned when added to node group
	[operand1 setName:@"input1"];

	[operand1 setDataType:@"SHNumber"];	
}


#pragma mark action methods
// ===========================================================
// - evaluate:
// ===========================================================
- (BOOL)execute:(id)fp8 head:()np time:(double)timeKey arguments:(id)fp20
{
	if(_evaluationInProgress==NO)// && [self dirtyBit] )
	{
		_evaluationInProgress = YES;
//		float val1 = [(id)[operand1 upToDateEvaluatedValue:uid] floatValue];		// SHNumber
//		float val2 = [(id)[operand2 upToDateEvaluatedValue:uid] floatValue];
//		float result = val1+val2;
//		id resultWrapper = [[(id)[output1Class alloc]initWithFloat:result] autorelease];
//		[operand3 setValue: resultWrapper];
		//		logInfo(@"SHPlusOperator.m: Evaluate.. result is.. %@", resultWrapper );
		//		_dirtyBit = NO;
		_evaluationInProgress = NO;
	} else {
		logWarning(@"SHPlusOperator.m: Wont Evaluate - dirty bit not set" );
	}
	return YES;
}

#pragma mark accessor methods
- (BOOL) isLeaf{ return NO; }


@end
