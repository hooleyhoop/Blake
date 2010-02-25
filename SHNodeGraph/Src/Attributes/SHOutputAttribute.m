//
//  SHOutputAttribute.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//
#import "SHOutputAttribute.h"
#import "SHConnectlet.h"
#import "SHInterConnector.h"
#import "SHExecutableNode.h"
#import "SHAbstractDataType.h"
#import <CoreServices/CoreServices.h>

/*
 *
*/
@implementation SHOutputAttribute

#pragma mark -
#pragma mark class methods
	
	
#pragma mark init methods

- (id)init {

	self=[super init];
	if( self ) {
		_nodesIAmAffectedBy = nil;
		[self changeNameWithStringTo:@"output" fromParent:nil undoManager:nil];

//		// this is where we add the attribute link (which on an output attribute is an inlet)
//		// trying a new way of doing this.. instead of actually adding the inlet as an attribute
//		// we just fake the attribute accessor methods to return the inlet
//		// [self initInputs];
	}
	return self;
}

- (void)dealloc {
	
	[_nodesIAmAffectedBy release];
	_nodesIAmAffectedBy = nil;
    [super dealloc];
}

#pragma mark action methods


#pragma mark accessor methods
// ===========================================================
// - willAnswer:
// ===========================================================
//- (NSArray*) willAnswer
//{
//	NSAssert(_value != nil, @"ERROR SHOutputAttribute.m: _value is nil");
//	// logInfo(@"SHInputAttribute.m: _value is %@",[_value class] );
//	if( [[_value class] respondsToSelector:@selector(willAnswer)] )
//		return [[_value class] willAnswer];
//	else {
//		logInfo(@"SHOutputAttribute.m: _value DONT BE DOING THAT SELECTOR YOU DORK!" );
//	}
//	return nil;
//}


- (NSObject<SHValueProtocol> *)upToDateEvaluatedValue:(double)timeKey head:(SHProtoAttribute *)np error:(NSError **)error {
		
	if(np==nil)
		np=(SHProtoAttribute *)self;
	
	if(FloatToFixed(timeKey)!=FloatToFixed(_evalRecursionID))
	{
		_evalRecursionID = timeKey;
		
//		if(nextTimeSliceValue!=nil){
//			[self setValue: nextTimeSliceValue];
//			[nextTimeSliceValue release];
//			nextTimeSliceValue = nil;
//		}
		
	} else {
		// Experimental - we have hit the edge of a loop. 
		// for testFamous_4_6_feedback to work..
		// if this is a loop return the last value - and indicate via ERROR that it is not to be passed up the chain - 
		//	that is the object asking for it, sets this new value but returns its previous value..

		/* Experimental - refuse to set the value */
		if(np==self){
			logInfo(@"hit the feedback boundary");
			// return nextTimeSliceValue; // need to call selector to use on this	
//			if(previousValue!=nil)
//				return previousValue; // need to performselector
		}
		NSError *err = [NSError errorWithDomain:@"InfiniteLoop" code:1 userInfo:nil];
		if(error)
			*error = err;
		else 
			[NSException raise:@"Error with ERROR" format:@""];
//oct09		return [super upToDateEvaluatedValue:timeKey head:np error:nil];
	}
	
	if(_dirtyBit)
	{	
 		// ok, something upstream has changed..
 		// either..
 		// 1. we need to evaluate the parent node
		int i, count = [_nodesIAmAffectedBy count];
 		if(count>0)
 		{
 			// evaluate parent operator
 			//logInfo(@"SHOutputAttribute.m: evaluating parent node!!!!");
 			//logInfo(@"SHOutputAttribute.m: output calling evaluate in get value" );
			
			/* ask the node to evaluate - this should take care of updating our value */
//oct09 			[_parentSHNode evaluateOncePerFrame:nil head:np time:timeKey arguments:nil];

			// just because we have set a new value, we are now marked as clean
			// however, in feedback loops there can be nodes behind us that are still dirty
			for( id ob in _nodesIAmAffectedBy )
 			{
				if([ob dirtyBit]==YES){
					_dirtyBit = YES;
					break;
				}
			}
			
 		} else {
 		// 2. we need to go up the chain and get the value from the connected outlet
 			NSArray* ics = [_theInlet shInterConnectors];

 			SHConnectlet* outlet;
 
 		//	logInfo(@"SHOutputAttribute.m: There are %i connected interconnectores to atribute link", count );
 
 			for( SHInterConnector *ic in ics )
 			{
 				outlet = (SHConnectlet *)[ic outSHConnectlet];
 				SHProtoAttribute* connectedAttribute = [outlet parentAttribute];
 				NSAssert(connectedAttribute!=self, @"SHOutputAttribute.m: ERROR. looks like we are getting the wrong inlet from the interconnector");
 				// logInfo(@"SHOutputAttribute.m: output %@ getting value from %@", _name, [connectedAttribute name] );
 				
//oct09				id upstreamVal = [connectedAttribute upToDateEvaluatedValue:timeKey head:np error:error];
//clang tells me this cant happen				NSError *err = *error;
				
				/* did we hit the edge of a loop? In that case we want to store the current value to return at the end, then set the new value */
//clang tells me this cant happen				if( err!=nil )
//clang tells me this cant happen				{
					// the error happened here - we dont want to return it all the way up the chain..
//clang tells me this cant happen					*error = nil;
					error=nil;
				
					// we hit the edge
//oct09					id currentVal = [super upToDateEvaluatedValue:timeKey head:np error:error];
					
					// is new value unset?
//oct09					if([upstreamVal isUnset]){
						// we need to introduce the concept of 'unset' values so that we dont have all these '0''s going round the feedback loops
						logInfo(@"i am the unset");
//oct09					}
					

//oct09					if(upstreamVal!=nil && [upstreamVal isUnset]==NO)
					{
						id selfValue = [self value];
//oct09						NSAssert(currentVal==selfValue, @"i dont remember what the difference is!");

						if([selfValue isUnset]==NO){
					//		returnValue = currentVal;
					//		nextTimeSliceValue = [upstreamVal retain];
					//		rtVal = [[currentVal retain] autorelease]; // need to call perform selectorToUSe !!
					//		upstreamVal=nil;

						}
					}
//clang tells me this cant happen				} 
				
		
//oct09				if(upstreamVal!=[self value] && [upstreamVal isUnset]==NO )
				{
 					// NSAssert(val != self->_value, @"SHOutputAttribute.m: ERROR. value is the same");
//oct09 					[self setValue: upstreamVal]; // performs _selectorToUse
//oct09 				} else {
 				//	[self setValue: _value]; //wont do anything but will notify KVC
 					_dirtyBit = NO;
 					[self setDirtyBelow:random()];
 				}				
				// just because we have set a new value, we are now marked as clean
				// however, in feedback loops there can be nodes behind us that are still dirty
				if([connectedAttribute dirtyBit]==YES)
					_dirtyBit = YES; 				
 			}
		} 
 		//	logInfo(@"SHOutputAttribute.m: yada.....!!!!" );
 		//	logInfo(@"SHOutputAttribute.m: About to perform selector %@", NSStringFromSelector(_selectorToUse) );
 	} else {
		logWarning(@"DEBUG INFO. %@ Not dirty", self);
	}
	//	logInfo(@"SHOutputAttribute.m: %@ about to do super value", [self name] );
//oct09	id rtVal = [super upToDateEvaluatedValue:timeKey head:np error:error]; // performs _selectorToUse; 
//oct09	return rtVal;
	return nil;
}

- (void)setIsAffectedBy:(SHInputAttribute *)inAtt {
	
	if(_nodesIAmAffectedBy==nil)
		_nodesIAmAffectedBy = [[NSMutableArray alloc] initWithCapacity:1];
	[_nodesIAmAffectedBy addObject:inAtt];	// retain cycle cause we have both added each other to an array
	[self setIsInletConnected:YES];
}


- (void)isAboutToBeDeletedFromParentSHNode
{
	// think this is a good way to break retain cycles
	[_nodesIAmAffectedBy removeAllObjects];
	[super isAboutToBeDeletedFromParentSHNode];
}


- (NSMutableArray *)nodesIAmAffectedBy {
	return _nodesIAmAffectedBy;
}

//=========================================================== 
// - _dirtyBit
//=========================================================== 
//- (BOOL) dirtyBit {
//	// This is overidden because
//	// An InAttribute can only be dirty if it's outlet is connected
//	// & 
//	// An OutAttribute can only be dirty if it's inlet is connected
////	if([_theInlet isConnected])
//	   return _dirtyBit;
////	return NO;
//}
@end