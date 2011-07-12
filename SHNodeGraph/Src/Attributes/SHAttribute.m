//
//  SHAttribute.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHAttribute.h"
#import "SHInputAttribute.h"
#import "SHConnectlet.h"
//#import <SHShared/SHMutableValueProtocol.h>
#import "SHAttributePrivateMethods.h"
#import "SHInterConnector.h"
#import "SH_Path.h"
//#import "SHNodeAttributeMethods.h"
//#import "SHConnectableNode.h"
#import "SHInlet.h"
#import "SHOutlet.h"

//static NSString* DEFAULTDATATYPE = @"SHNumber";

/*
 *
*/
@implementation SHAttribute

// This is a global? That would be way wrong....
// NSLock* stateLock;

#pragma mark class methods
//+ (id)makeAttribute {
//	return [[[self alloc] init] autorelease];
//}

#pragma mark init methods
- (id)init
{
	if( (self=[super init])!=nil )
	{

//		_absolutePath=nil;

		//15/05/06		_auxiliaryData		= [[NSMutableDictionary dictionaryWithCapacity:1] retain];
//		_enabled = YES;
//		_locked = NO;
		
//		_inletState = SHAttributeState_Normal; 
//		_outletState = SHAttributeState_Normal;


		[self setName:@"attribute"];
		
		_dataClass = nil;
		_evalRecursionID = -1;
		// [self setDataType:DEFAULTDATATYPE];
		_dataClass = nil;
		// stateLock = [[NSLock alloc] init];
//		nextTimeSliceValue = nil;
//		previousValue=nil;
	}
	return self;
}

- (void)dealloc {	
    [super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual

#pragma mark action methods
- (void)hasBeenAddedToParentSHNode {
	[super hasBeenAddedToParentSHNode];
}

- (void)isAboutToBeDeletedFromParentSHNode {
	[super isAboutToBeDeletedFromParentSHNode];
}


//TODO: see http://www.penzba.co.uk/Writings/TheTeleportingTurtle.html
// for a better way to see if there is a loop

// we overide this in inputAttribute attributes to check nodes i affect as well
- (BOOL)isAttributeDownstream:(SHAttribute *)anAtt {
   
	// DO a recursive test
	for( SHInterConnector *inter in [_theOutlet shInterConnectors] )
	{
		if( inter.outSHConnectlet != nil )
		{
			/* one of these will be ourselves */
			SHInlet* inlet = inter.inSHConnectlet;
//			SHOutlet* outlet = [inter outSHConnectlet];
			SHAttribute* nextNodeDown1= [inlet parentAttribute];
//			SHAttribute* nextNodeDown2= [outlet parentAttribute];
//			BOOL inletIsAttribteConnectlet = [inlet isAttributeConnnectlet];
//			BOOL outletIsAttribteConnectlet = [outlet isAttributeConnnectlet];
//			SHAttribute* nextNodeDown = nextNodeDown1;
//			if(inletIsAttribteConnectlet==YES) // inlet's attribute will be an input
//				nextNodeDown = nextNodeDown2;
//			else if(outletIsAttribteConnectlet==NO) // outlet's attribute will be an input
//				nextNodeDown = nextNodeDown1;
//				
			NSAssert(nextNodeDown1!=self, @"eek, wrong one");
			
			if( nextNodeDown1==anAtt )
			{
				return YES;
			} else {
				BOOL nextResult = [nextNodeDown1 isAttributeDownstream: anAtt];
				if(nextResult) 
					return YES;
			}
		}
	}
	return NO;
}

/*	Do we really need all the shit that this involves? Any window or custom view that observes this must cancel its observation
	before the object is released
*/
#pragma mark notification methods
//- (void)postNodeGuiMayNeedRebuilding_Notification {
//
//	// logInfo(@"SHProto_Node.m: postNodeGuiMayNeedRebuildingNotification");
//	// NSDictionary *d = [NSDictionary dictionaryWithObject:self forKey:@"theNode"];
//	NSNotification *n = [NSNotification notificationWithName:@"nodeGuiMayNeedRebuilding" object:self userInfo:nil];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ]; // could post when idle
//}

#pragma mark accessor methods

@dynamic temporaryID;
@dynamic parentSHNode;
@dynamic nodeGraphModel;
@dynamic operatorPrivateMember;

//- (SH_Path *)absolutePath {
//
//	SH_Path* parentPath;
//	if(_parentSHNode==nil)
//	{
//		return nil;
//	} else {
//		parentPath = [_parentSHNode absolutePath];
//	}
//	NSAssert(_name != nil, @"SHNode.m: name is nil");
//	[self setAbsolutePath: [parentPath append:_name]];
//	return _absolutePath;
//}
//
//- (void)setAbsolutePath:(SH_Path *)anAbsolutePath {
//    if (_absolutePath != anAbsolutePath) {
//        [_absolutePath release];
//        _absolutePath = [anAbsolutePath retain];
//    }
//}

//- (BOOL)isLeaf { return YES; }

- (NSObject<SHValueProtocol> *)upToDateEvaluatedValue:(double)timeKey head:(SHAttribute *)np error:(NSError **)error {

	// [stateLock lock];
	
	// logInfo(@"SHAttribute.m: value!!!!");
	// we dont check for isDirty here as this method can not be called directly -
	// only via subclass method
	NSAssert(_selectorToUse!=nil, @"SHAttribute.m: ERROR. no selector to use");
	//09/05/2006	logInfo(@"AHAttribute.m: %@ about to perform selector %@ on %@", _name, NSStringFromSelector(_selectorToUse), _value);
	// id val = [_value performSelector:_selectorToUse];
	
	id val =  objc_msgSend(_value, _selectorToUse];

	// NSString* debugHelperValue = [_value displayObject];
	// NSAssert(val!=nil, @"SHAttribute.m: ERROR. no value returned from selectorToUse for dataType");
	//  [stateLock unlock];
	
	return val;
}




//- (void)setPreviousValue:(NSObject<SHValueProtocol> *)a_value
//{
//    if(previousValue!=a_value) {		
//        [previousValue release];
//        previousValue = [a_value retain];
//	}
//}


- (void)valueWasUpdatedManually {
	
	/* Presuming this breaks a lot of stuff like feedback and previous values etc! */
	[self setDirtyBelow:random()];
}



//- (NSNumber*) isInletConnectedAsNumber {
//   // logInfo(@"in -isConnectedFlag, WEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE %i", _isInletConnected );
//	return [NSNumber numberWithBool:_isInletConnected];
//}



//- (NSNumber*) isOutletConnectedAsNumber {
//   // logInfo(@"in -isConnectedFlag, WEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE %i", _isInletConnected );
//	return [NSNumber numberWithBool:_isOutletConnected];
//}

- (NSString *)dataType {
	return NSStringFromClass([_value class]);
}

- (BOOL)isInFeedbackLoop {
	return [self isAttributeDownstream:self];
}

- (NSString *)description {

	NSString* as=[_value description];
	NSString* nameAndValue = [NSString stringWithFormat:@"%@ - %@", _name, as];
//	NSAssert(as!=nil, @"er, nil string");
	NSString* descriptionString = [[super description] stringByAppendingString: nameAndValue];
	return descriptionString;
}



@end