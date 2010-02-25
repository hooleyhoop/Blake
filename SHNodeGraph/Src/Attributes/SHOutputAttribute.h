//
//  SHOutputAttribute.h
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//
#import <ProtoNodeGraph/SHProtoOutputAttribute.h>

@class SHOutlet, SHInterConnector, SHNode, SHInputAttribute;

/*
 * A Special Node that acts as an outputPropert to operators and scripts
 *
*/
@interface SHOutputAttribute : SHProtoOutputAttribute {

	NSMutableArray	*_nodesIAmAffectedBy;
}

#pragma mark -
#pragma mark class methods

#pragma mark init methods

#pragma mark action methods


#pragma mark accessor methods
//- (NSArray *)willAnswer;
 
// works like being connected with an interconnector, but only
// inside of an operator
- (void)setIsAffectedBy:(SHInputAttribute *)inAtt;
 
- (NSMutableArray *)nodesIAmAffectedBy;



@end