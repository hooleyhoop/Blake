//
//  SHNot.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 20/12/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHNot.h"
#import "SHOutputAttribute.h"
#import "SHInputAttribute.h"
#import "SHAbstractDataType.h"

static Class output1Class;
static BOOL initError = YES;

@implementation SHNot

#pragma mark -
#pragma mark class methods
+ (NSString *)pathWhereResides{ return @"/SHBasic/Math";}


+ (void)initialize {
    
    static BOOL isInitialized = NO;
    if(!isInitialized)
    {
        output1Class = NSClassFromString( @"SHMutableBool" );
        if(output1Class)
            initError = NO;
    } else {
        [NSException raise:NSInvalidArgumentException format:@"what is going on with these multiple initializes?"];
    }
}

#pragma mark init methods
- (id)init
{	
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


- (void)dealloc {
    [super dealloc];
}


- (void)initInputs
{	
	// makes a default SHNumber attribute
	operand1 = [SHInputAttribute attributeWithType:@"SHMutableBool"];
	[self addPrivateChild: operand1];

	// Change the default name that is assigned when added to node group
	[operand1 setName: @"input1"];
}

- (void)initOutputs
{
	operand2 = [SHOutputAttribute attributeWithType:@"SHMutableBool"];
	[self addPrivateChild: operand2];
	
	[operand2 setName: @"output"];	
}

#pragma mark action methods

- (BOOL)execute:(id)fp8 head:()np time:(double)timeKey arguments:(id)fp20
{
	if(_evaluationInProgress==NO)
	{
		_evaluationInProgress = YES;
		NSError* error;
		id valObj1 = (id)[operand1 upToDateEvaluatedValue:timeKey head:np error:&error];
		
		if( [valObj1 isUnset]==NO )
		{
			/* temporary! operator should assume about internal to object - object should have an add method */
			float val1 = [valObj1 boolValue];
			float result = !val1;
			id resultWrapper = [[(id)[output1Class alloc] initWithBool:result] autorelease];
			[operand2 setValue: resultWrapper];

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
