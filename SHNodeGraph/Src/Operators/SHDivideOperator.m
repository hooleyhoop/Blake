//
//  SHDivideOperator.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 __HOOLEY__. All rights reserved.
//

#import "SHDivideOperator.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHAbstractDataType.h"

// global variables with scope limited to this file
static Class output1Class;
static BOOL initError = YES;


/*
 *
*/
@implementation SHDivideOperator


#pragma mark -
#pragma mark class methods
+ (NSString*) pathWhereResides{ return @"/SHBasic/Math";}

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
	//logInfo(@"SHDivideOperator.m: initing ok");
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
			[operand1 affects:operand3];
			[operand2 affects:operand3];
			
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
	operand2 = [[[SHInputAttribute alloc] init]autorelease];
	[self addPrivateChild: operand1];
	[self addPrivateChild: operand2];
	
	// logInfo(@"SHDivideOperator.m: Added inputs, number of inputs is %i", [self numberOfInputs] );
	
	// Change the default name that is assigned when added to node group
//	[operand1 setName:[NSString stringWithString:@"input1"]];
//	[operand2 setName:[NSString stringWithString:@"input2"]];
	
	[operand1 setDataType:@"SHNumber"];
	[operand2 setDataType:@"SHNumber"];
//	[operand1 setValue:[NSString stringWithString:@"huh!"]];	// cant use constanst string
	
}


// overriden
// ===========================================================
// - initOutputs:
// ===========================================================
- (void) initOutputs
{
	// default SHNumber
	operand3 = [[[SHOutputAttribute alloc] init]autorelease]; // retain count 1
	[self addPrivateChild: operand3];
	
	[operand3 setName: @"output"];
	[operand3 setDataType: @"SHNumber"];
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
		float result;
		NSError* error;

		_evaluationInProgress = YES;
		id valObj1 = (id)[operand1 upToDateEvaluatedValue:timeKey head:np error:&error];
		id valObj2 = (id)[operand2 upToDateEvaluatedValue:timeKey head:np error:&error];
		if([valObj1 isUnset]==NO && [valObj2 isUnset]==NO )
		{
			float val1 = [valObj1 floatValue];		// SHNumber
			float val2 = [valObj2 floatValue];
			/* check for divide by zero */
			if(val2==0)
				result= 0;
			else
				result = val1/val2;
			id resultWrapper = [[(id)[output1Class alloc]initWithFloat:result]autorelease];
			[operand3 setValue: resultWrapper];
	//		logInfo(@"SHDivideOperator.m: Evaluate.. result is.. %@", resultWrapper );
	//		_dirtyBit = NO;
		}
		_evaluationInProgress = NO;
	} else {
		logWarning(@"SHDivideOperator.m: Wont Evaluate - dirty bit not set" );
	}
	return YES;
}

#pragma mark accessor methods
- (BOOL) isLeaf{ return YES; }

@end
