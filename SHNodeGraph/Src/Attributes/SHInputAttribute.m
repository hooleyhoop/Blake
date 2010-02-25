//
//  SHInputAttribute.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//
#import "SHInputAttribute.h"
#import "SHConnectlet.h"
#import "SHInterConnector.h"
#import "SHOutputAttribute.h"
#import "SHAbstractDataType.h"


/*
 *
*/
@implementation SHInputAttribute

#pragma mark -
#pragma mark class methods
	
#pragma mark init methods
- (id)init {

	self=[super init];
	if( self ) {
//dec09		shouldRestoreState = YES;
		[self changeNameWithStringTo:@"input" fromParent:nil undoManager:nil];
		// this is where we add the attribute link (which on an input attribute is an outlet)
		// trying a new way of doing this.. instead of actually adding the outlet as an attribute
		// we just fake the attribute accessor methods to return the outslet
		// [self initOutputs];
	}
	return self;
}

- (void)dealloc {

    [super dealloc];
}

//- (id)retain {
//	return [super retain];
//}
//
//- (void)release {
//	[super release];
//}

#pragma mark action methods
- (void)publicSetValue:(id)aValue {

	/* inputAttributes can be set with arrays - experimental */
	if([aValue respondsToSelector:@selector(objectEnumerator:)]) // assume is a collection
	{
//		id enum1 = [aValue objectEnumerator];
		// needs an array of values not just a single instance
	} else {
		[super publicSetValue:aValue];
	}
}


- (BOOL)isAttributeDownstream:(SHProtoAttribute *)anAtt {

//oct09	BOOL result = [super isAttributeDownstream:anAtt];
//oct09	if(result==NO)
//oct09	{
//oct09		id at;
//oct09		for( at in [self nodesIAffect] )
//oct09		{
//oct09			if( at==anAtt )
//oct09			{
//oct09				result= YES;
//oct09			} else {
//oct09				BOOL nextResult = [at isAttributeDownstream: anAtt];
//oct09				if(nextResult)
//oct09					result= YES;
//oct09			}
//oct09		}
//oct09	}
//oct09	return result;
	return YES;
}


#pragma mark accessor methods
//dec09 @synthesize shouldRestoreState;

// similar to connecting with an interconnector but doesnt need to check
// for compatible selectors and stuff
- (void)affects:(SHOutputAttribute *)outAtt {
	
	NSParameterAssert( [nodesIAffect indexOfObjectIdenticalTo:outAtt]==NSNotFound );
//	if( [nodesIAffect indexOfObjectIdenticalTo:outAtt]==NSNotFound )
//	{
//	if( (self!=outAtt) )
//	{
		[outAtt setIsAffectedBy:self];
		[nodesIAffect addObject:outAtt];	// causes a retain cycle
//	}
//	}
}

- (NSObject<SHValueProtocol> *)upToDateEvaluatedValue:(double)timeKey head:(SHProtoAttribute *)np error:(NSError **)error
{
	if(np==nil)
		np=self;
	
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
			//-- return the previous value?
		//	if(previousValue!=nil)
//				return previousValue; // need to performselector
		}
		
		NSError *err = [NSError errorWithDomain:@"InfiniteLoop" code:1 userInfo:nil];
		if(error)
			*error = err;
		else
			[NSException raise:@"ERROR with error" format:@""];

//oct09		return [super upToDateEvaluatedValue:timeKey head:np error:nil];
	}
	
	// update our value
	if(_dirtyBit)
	{	
		// 2. we need to go up the chain and get the value from the connected outlet
		NSArray* ics = [_theInlet shInterConnectors];
		int i, count = [ics count];
		SHConnectlet* outlet;
		//logInfo(@"SHInputAttribute.m: getting value from linked input %i!!!!", count);

		/* What is the logic behind setting the value for each connected interconnector - could this ever serve any purpose? */
		NSAssert(count==1, @"we cant have more than 1 input at the moment");
		for( SHInterConnector *ic in ics )
		{
			outlet = (SHConnectlet *)[ic outSHConnectlet];
			SHProtoAttribute* connectedAttribute = [outlet parentAttribute];
			NSAssert(connectedAttribute!=self, @"SHInputAttribute.m: ERROR. looks like we are getting the wrong inlet from the interconnector");
			
			/* er.. some nodes (eg the pureData nodes) dont make a new output value when they are
			recalculated, instead they act like their value are mutable for performance reasons 
			(dont want to be calling malloc and free). This messes a lot of things up.. sometimes
			the input is dirty even tho it still points to the same (mutable)value as the connected output.
			In this case this will cause an infinite loop. */
			
//oct09			id upstreamVal = [connectedAttribute upToDateEvaluatedValue:timeKey head:np error:error];
						
			/* It might not be the same value but it may be equivalent and this will still mark
			the whole chain as dirty unnesasarily. Unfortunately ui dont want to test equivalence
			as for some objects (like images) this could be a major operation */
			// logInfo(@"self value is %@ - error is", [self value]);
			
			NSError* err = *error; // this is wrong!
			
			/* did we hit the edge of a loop? In that case we want to store the current value to return at the end, then set the new value */
			if( err!=nil )
			{
				// the error happened here - we dont want to return it all the way up the chain..
				*error = nil;

			//	error=nil;
			//	err=nil;
				// we hit the edge
//oct09				id currentVal = [super upToDateEvaluatedValue:timeKey head:np error:error];
				
				// is new value unset?
//oct09				if([upstreamVal isUnset]){
					// we need to introduce the concept of 'unset' values so that we dont have all these '0''s going round the feedback loops
					logInfo(@"This is worthless");
					// returnedFeedback = NO;

//oct09				}

				// unless our value is unset, then as we have a set value upstream, return that one
//oct09				if(upstreamVal!=nil && [upstreamVal isUnset]==NO)
				{
					// upstreamValue is fine
					id selfValue = [self value];
//oct09					NSAssert(currentVal==selfValue, @"i dont remember what the difference is!");
					if([selfValue isUnset]==NO)
					{
						// current value is fine
	//					NSAssert(nextTimeSliceValue==nil, @"this shouldnot happen");
						// nextTimeSliceValue = [upstreamVal retain];
						/* The value hasnt changed but we were marked as dirty so we should act like we have changed */
						//[self setValue: _value]; //wont do anything but will notify KVC
						// _dirtyBit = NO;
						// [self setDirtyBelow:random()];
						// rtVal = [[currentVal retain] autorelease]; // need to call perform selectorToUSe !!

					} else {
					}
//oct09				} else {
//oct09					if( [upstreamVal isUnset] && [currentVal isUnset])
						logInfo(@"This is ok");
//oct09					else
						logInfo(@"This isnt - do we ever get here?");

				}
			}// else {
			
			// we didnt hit the edge - act normal	
//oct09				if(upstreamVal!=[self value] && [upstreamVal isUnset]==NO ) // you might want to set nil.. so use the NSError instead to check for fault
				{				
	//				logInfo(@"SHInputAttribute.m: currentValue: %@,  new value: %@ from connectedAttribute", self->_value, upstreamVal);
	//				callCount++;
	//				if(callCount > 150)
	//				{
	//					logInfo(@"SHInputAttribute.m: woah");
	//					return nil;
	//				}
					// NSAssert(val != self->_value, @"SHInputAttribute.m: ERROR. value is the same");
//oct09					[self setValue: upstreamVal];
//oct09				} else {
					
					/* The value hasnt changed but we were marked as dirty so we should act like we have changed */
					//[self setValue: _value]; //wont do anything but will notify KVC
					_dirtyBit = NO;
					[self setDirtyBelow:random()];
				}
			
//			}

			
			
			// just because we have set a new value, we are now marked as clean
			// however, in feedback loops there can be nodes behind us that are still dirty
			if([connectedAttribute dirtyBit]==YES)
				_dirtyBit = YES;
			
		}
//09/05/2006	}// else {
		//	logInfo(@"SHInputAttribute.m: value not dirty!!!!");
	} else {
		logInfo(@"Debug Info : %p Not dirty", self);
	}
//oct09	id rtVal = [super upToDateEvaluatedValue:timeKey head:np error:error]; // performs _selectorToUse; 
//oct09	return rtVal;
	return nil;
}


- (void)isAboutToBeDeletedFromParentSHNode {
	
	[nodesIAffect removeAllObjects];
	// think this is a good way to break retain cycles
	[super isAboutToBeDeletedFromParentSHNode];
}

//=========================================================== 
// - _dirtyBit
//=========================================================== 
//- (BOOL) dirtyBit {
//	// This is overidden because
//	// An InAttribute can only be dirty if it's outlet is connected
//	// & 
//	// An OutAttribute can only be dirty if it's inlet is connected
////	if([_theOutlet isConnected] || [nodesIAffect count]>0)
//	   return _dirtyBit;
////	return NO;
//}




@end