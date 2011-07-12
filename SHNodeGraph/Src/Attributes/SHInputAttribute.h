//
//  SHInputAttribute.h
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//
#import "SHProtoInputAttribute.h"

@class SHInlet, SHNode, SHOutputAttribute;


/*
 * A Special Node that acts as an inputProperty to operators and scripts	
 *
*/
@interface SHInputAttribute : SHProtoInputAttribute { //!Alert-putback!<SHAttributeProtocol> {
// inlets are references to SHOutProperty values unless
// they aren't connected

// all properties are visible to the script and
// can be connected
//dec09	BOOL				shouldRestoreState;
}

#pragma mark -
#pragma mark class methods

#pragma mark accessor methods
//dec09 @property(readwrite, nonatomic) BOOL shouldRestoreState;

//// similar to connecting with an interconnector but doesnt need to check
//// for compatible selectors and stuff
- (void)affects:(SHOutputAttribute *)outAtt;


@end

