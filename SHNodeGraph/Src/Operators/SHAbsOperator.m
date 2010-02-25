//
//  SHAbsOperator.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 __HOOLEY__. All rights reserved.
//

#import "SHAbsOperator.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHAbstractDataType.h"

#import <FScript/Number.h>

// global variables with scope limited to this file
static Class output1Class;
static BOOL initError = YES;

@implementation SHAbsOperator


#pragma mark -
#pragma mark class methods
+ (NSString *)pathWhereResides{ return @"/SHBasic/Math";}

+ (void)initialize {

    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        output1Class = NSClassFromString( @"SHNumber" );
        if(output1Class)
            initError = NO;
    } else {
        [NSException raise:NSInvalidArgumentException format:@"what is going on with these multiple initializes?"];
    }
}

#pragma mark init methods
// ===========================================================
// - init:
// ===========================================================
- (id)init
{	
	//logInfo(@"SHAbsOperator.m: initing ok");
	if(!initError){
		if( (self=[super init])!=nil )
		{
			[self initInputs];
			[self initOutputs];
			
			// similar to connecting with an interconnector but doesnt need to check
			// for compatible selectors and stuff
			//id in1	= (SHInputAttribute*)[self inputAttributeWithName:@"input1"];
			//id in2	= (SHInputAttribute*)[self inputAttributeWithName:@"input2"];
			//id out1 = [self outputAttributeWithName:@"output"];
			[operand1 affects:operand2];
			
		} 
		return self;
	}
	return nil;
}

//=========================================================== 
// dealloc
//=========================================================== 
- (void) dealloc {

    [super dealloc];
}

// overriden
// ===========================================================
// - initInputs:
// ===========================================================
- (void)initInputs
{	
	// makes a default SHNumber attribute
	operand1 = [[[SHInputAttribute alloc] init]autorelease];
	[self addPrivateChild: operand1];
	
	// logInfo(@"SHAbsOperator.m: Added inputs, number of inputs is %i", [self numberOfInputs] );
	
	// Change the default name that is assigned when added to node group
	[operand1 setName: @"input1"];
	[operand1 setDataType:@"SHNumber"];
//	[operand1 setValue:[NSString stringWithString:@"huh!"]];	// cant use constanst string
	
}


// overriden
// ===========================================================
// - initOutputs:
// ===========================================================
- (void) initOutputs
{
	// default SHNumber
	operand2 = [[[SHOutputAttribute alloc] init]autorelease]; // retain count 1
	[self addPrivateChild: operand2];
	
	[operand2 setName: @"output"];
	[operand2 setDataType: @"SHNumber"];
//	[operand3 setValue:[NSString stringWithString:@"huh!"]];	// cant use constanst string

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
	
		// this could possible be a choice of any NSNumber method that takes no arguments and returns an NSNumber
		NSError* error=nil;
		
		id valObj1 = (id)[operand1 upToDateEvaluatedValue:timeKey head:np error:&error];
		if([valObj1 isUnset]==NO)
		{
			float val1 = [valObj1 floatValue];		// SHNumber
			id resultWrapper = [[(id)[output1Class alloc]initWithFloat:fabs(val1)]autorelease];
			[operand2 setValue: resultWrapper];
		// this could possible be a choice of any NSNumber method that takes no arguments and returns an NSNumber
		
//		logInfo(@"SHAbsOperator.m: Evaluate.. result is.. %@", resultWrapper );
//		_dirtyBit = NO;
		}
		_evaluationInProgress = NO;
	} else {
		logWarning(@"SHAbsOperator.m: Wont Evaluate - dirty bit not set" );
	}
	return YES;
}

#pragma mark accessor methods
- (BOOL)isLeaf{ return YES; }

@end
