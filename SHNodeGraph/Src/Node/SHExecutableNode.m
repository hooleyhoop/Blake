//
//  SHExecutableNodeGroup.m
//  Pharm
//
//  Created by Steve Hooley on 12/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHExecutableNode.h"
#import <ProtoNodeGraph/SHChildContainer.h>

/*
 *
*/
@implementation SHNode (SHExecutableNode) 

#pragma mark -
#pragma mark class methods
+ (int)executionMode {
// 0 - call evaluate when asked and when dirty - most once per frame	// PROCESSOR
// 1 - call evaluate when asked - most once per frame					// PROVIDER
// 2 - call once per frame												// CONSUMER
	return PROCESSOR;
}


#pragma mark init methods
// ===========================================================
// - initWithParentNodeGroup:
// ===========================================================
//- (id)initWithParentNodeGroup:(SHNodeGroup*)aNG
//{
//	//	logInfo(@"SHExecutableNode.m: initializing ok");		
//	if(self=[super initWithParentNodeGroup:aNG])
//	{
//		_advanceTimeInvocations = nil;
//	} else {
//		logInfo(@"SHExecutableNode.m: ERROR i didnt think this ever happend");
//	}
//	return self;
//}

//=========================================================== 
// dealloc
//=========================================================== 
//- (void) dealloc {
//	[_advanceTimeInvocations release];
//    _advanceTimeInvocations = nil;
//    [super dealloc];
//}

#pragma mark action methods


/* evaluate is only called by output attributes at the moment when they
are dirty and need an upto-date value - so this could easily be changed */

/*	This can be called by an output node needing a new value, by a parent node executing
	its children, or the scheduler executing the root */
- (BOOL)evaluateOncePerFrame:(id)fp8 head:(id)np time:(CGFloat)timeKey arguments:(id)fp20
{
	BOOL result = NO;
	
	if( G3DCompareFloat(timeKey, _previousFrameKey, 0.001f)!=0 )
	{
		_previousFrameKey=timeKey;
		Class thisClass = [self class];
		switch([thisClass executionMode])
		{
			// When executing a node which time do we want to pass in ?
			case PROCESSOR:
				if([self dirtyBit]){
					result = [self execute:fp8 head:np time:timeKey arguments:fp20];
					[self enforceConsistentState];
				}
				break;
				
			case PROVIDER:
				result = [self execute:fp8 head:np time:timeKey arguments:fp20];
				[self enforceConsistentState];
				break;
				
			case CONSUMER:
				result = [self execute:fp8 head:np time:timeKey arguments:fp20];
				[self enforceConsistentState];
				break;
		}
	}
	return result;
}


/* This is only ever called from evaluateOncePerFrame */
- (BOOL)execute:(id)fp8 head:(id)np time:(CGFloat)timeKey arguments:(id)fp20
{
	BOOL result = NO;
	// we only want to evalute renderable nodes and node groups that contain renderable nodes
	
	// This is where the execution of your patch happens.
	// Everything in this method gets executed once
	// per 'clock cycle', which is available in fp12 (time).
	
	// fp8 is the QCOpenGLContext*.  Don't forget to set
	// it before you start drawing.  
	
	// Read/Write any ports in here too.
	
	// an attribute can only be dirty if it is connected. evaluating the node must cause its attributes to not be dirty any more
	if( _evaluationInProgress==NO)
	{
		_evaluationInProgress=YES;
		int i;
		
		// This doesnt seem to be the optimal way - evaluate will be called on some
		// nodes many times unless we sort them in to an order first. This wouldnt work if we have feedback loops though
		NSArray* allValues = [_childContainer.nodesInside allValues];
		if([allValues count]>0)
		{
			for( id node in allValues ){

				// logInfo(@"SHExecutableNode.m: evaluate! node %@", node);
				
				/* evaluate render nodes */
				// Render all consumers.. and all PROCESSORS that are dirty
				// When executing a node - which time do we want to pass in? 
				if([[node class] executionMode]==CONSUMER){
					result = [node evaluateOncePerFrame:fp8 head:np time:timeKey arguments:fp20];
					//TODO: this result is meaningless! we overite it and only return the last one!

				} else if([[node class] executionMode]==PROCESSOR && [node dirtyBit]==YES){
					result = [node evaluateOncePerFrame:fp8 head:np time:timeKey arguments:fp20];
				}
			}
		} else {
			// nothing to do!
			result = YES;
		}
		_evaluationInProgress = NO;
	} else {
		logWarning(@"SHExecutableNode.m: ERROR: Already in Eval Loop!!!");
	} 
	return result;
}

/* like an end of run loop thing */
- (void)enforceConsistentState {
	
	// use to apply transforms etc.. bodge at the mo
}


		// find all nodes with no output
//sh		NSEnumerator *enumerator = [theNodesInScript objectEnumerator];
//sh		GenericNode* anode;

//sh		while (anode = [enumerator nextObject]) 
//sh		{
			// go through all node flagging which ones need to be recomputed due to user interacting
//sh			if( [anode hasBeenChanged] == YES )
//sh			{
//sh				[anode setHasBeenChangedDownStream];
//sh			}
//sh			
//sh			// find all nodes with no outputs (this is where we begin evaluation)
//sh			if( [anode hasValidOutput] == NO )
//sh			{
//sh				[nodesWithNoOutput addObject:anode];
//sh			}
//sh		}
		
		// call eval on these nodes
//sh		int i;
//sh		for( i=0; i<[nodesWithNoOutput count]; i++ )
//sh		{
//sh			id result = [[nodesWithNoOutput objectAtIndex:i] valueAtFrame:aFrame];
//sh			logInfo(@"SHScript.m: **RESULT: %@", [result description] );
//sh		}
		
//sh		[self finnishedScript];
//sh		[nodesWithNoOutput removeAllObjects];
//			_dirtyBit = NO;



#pragma mark accessor methods
/* - (BOOL)isEvaluating { return _isEvaluating; }
*/
// ===========================================================
// - setIsEvaluating:
// ===========================================================
/* - (void) setIsEvaluating: (BOOL) flag {
_isEvaluating = flag;
} */





@end
