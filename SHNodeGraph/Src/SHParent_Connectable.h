//
//  SHParent_Connectable.h
//  SHNodeGraph
//
//  Created by steve hooley on 09/04/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHParent.h"

@interface SHParent (SHParent_Connectable)

- (NSMutableArray *)allConnectionsToChild:(id)aChild;

- (SHInterConnector *)interConnectorFor:(SHProtoAttribute *)inAtt1 and:(SHProtoAttribute *)inAtt2;

@end
