//
//  SHLog.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 20/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHLog.h"
#import "SHInputAttribute.h"

@implementation SHLog

#pragma mark -
#pragma mark class methods
+ (NSString *)pathWhereResides{ return @"/SHBasic/Output";}

#pragma mark init methods

- (id)init {	
	if(self=[super init]) {
		[self initInputs];
	} 
	return self;
}

- (void) dealloc {
	
    [super dealloc];
}

- (void)initInputs {
	
	operand1 = [SHInputAttribute attributeWithType: @"SHMutableBool"];
	[self addPrivateChild: operand1];
		
	// Change the default name that is assigned when added to node group
	[operand1 setName: @"input1"];
}

#pragma mark action methods
- (BOOL)execute:(id)fp8 head:()np time:(double)timeKey arguments:(id)fp20
{
	/* This really needs locking? */
	if(evaluationInProgress==NO)
	{
		evaluationInProgress = YES;
		NSError* error=nil;
		id valObj1 = (id)[operand1 upToDateEvaluatedValue:timeKey head:np error:&error];
		logInfo(@"SHLog >> %@", valObj1);
		
		evaluationInProgress = NO;
		
	} else {
		logInfo(@"SHPlusOperator.m: Wont Evaluate - Already evaluating" );
	}
	return YES;
}

#pragma mark accessor methods
- (BOOL)isLeaf{ return YES; }


@end
