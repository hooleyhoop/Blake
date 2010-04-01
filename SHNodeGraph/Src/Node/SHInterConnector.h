//
//  SHInterConnector.h
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChild.h"
#import "SHNodeLikeProtocol.h"

@class SHInlet, SHOutlet, SHProtoAttribute;
@interface SHInterConnector : SHChild <SHNodeLikeProtocol, NSCoding> {

	SHInlet *_inSHConnectlet;
	SHOutlet *_outSHConnectlet;
}

@property(assign, readwrite, nonatomic) SHInlet *inSHConnectlet;
@property(assign, readwrite, nonatomic) SHOutlet *outSHConnectlet;

- (void)resetNodeSHConnectlets;

- (SHProtoAttribute *)outOfAtt;
- (SHProtoAttribute *)intoAtt;

#pragma mark -
#pragma mark class methods
+ (SHInterConnector *)interConnector;

#pragma mark action methods

#pragma mark notification methods
- (void)hasBeenAddedToParentSHNode;
- (void)isAboutToBeDeletedFromParentSHNode;

#pragma mark accessor methods
/* return some information about which nodes this connection does connect, so we can remember after we have been dissconected */
/* an array with the paths to the attributes relative from the interconnectors parent */
- (NSArray *)currentConnectionInfo;
- (NSArray *)indexPathsForConnectlets;

// - (NSArray *)getConnectionData;
- (BOOL)isConnected;

@end
