//
//  SHPlusOperator.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 __HOOLEY__. All rights reserved.
//

#import "SHPlusOperator.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHAbstractDataType.h"
#import "SHNodeAttributeMethods.h"

static Class output1Class;
static BOOL initError = YES;

@implementation SHPlusOperator

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
- (id)init
{	
	//logInfo(@"SHPlusOperator.m: initing ok");
	if(!initError)
	{
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
- (void)dealloc {

//	[operand1 release];// = nil;
//	[operand2 release];// = nil;
    [super dealloc];
}

- (void)initInputs {
	
	NSAssert(operand1==nil, @"eh?");
	NSAssert(operand2==nil, @"eh?");
	
	operand1 = [SHInputAttribute attributeWithType: @"SHNumber"]; // #warning -- not cleaned upToDateEvaluatedValue
	operand2 = [SHInputAttribute attributeWithType: @"SHNumber"];
	[self addPrivateChild: operand1];
	[self addPrivateChild: operand2];
	
	NSAssert1( [self numberOfInputs]==2, @"what happened to the number of inputs? %i", [self numberOfInputs] );
	
	/* leave them with their default names 
		[operand1 setName: @"input1"];
		[operand2 setName: @"input2"];
	 */
}

- (void)initOutputs {
	
	NSAssert(operand3==nil, @"eh?");

	operand3 = [SHOutputAttribute attributeWithType: @"SHNumber"];
	[self addPrivateChild: operand3];
	
	[operand3 setName: @"output"];
	
	NSAssert1( [self numberOfOutputs]==1, @"what happened to the number of outputs? %i", [self numberOfOutputs] );
}

#pragma mark action methods
- (BOOL)execute:(id)fp8 head:()np time:(double)timeKey arguments:(id)fp20
{
	if(_evaluationInProgress==NO)
	{
		_evaluationInProgress = YES;
		NSError* error=nil;
		id valObj1 = (id)[operand1 upToDateEvaluatedValue:timeKey head:np error:&error];
		id valObj2 = (id)[operand2 upToDateEvaluatedValue:timeKey head:np error:&error];
		
		if( [valObj1 isUnset]==NO && [valObj2 isUnset]==NO )
		{
			/* temporary! operator should assume about internal to object - object should have an add method */
			float val1 = [valObj1 floatValue];		// SHNumber
			float val2 = [valObj2 floatValue];
			float result = val1+val2;
			id resultWrapper = [[(id)[output1Class alloc] initWithFloat:result] autorelease];
			[operand3 setValue: resultWrapper];
		
			logInfo(@"SHPlusOperator.m: Evaluating.. %f + %f = %f", val1, val2, result );

		} else {
			logError(@"trying to add some hookey values");
		}
		_evaluationInProgress = NO;

	} else {
		logWarning(@"SHPlusOperator.m: Wont Evaluate - dirty bit not set" );
	}
	return YES;
}

#pragma mark accessor methods
- (BOOL)isLeaf{ return YES; }

@end
