//
//  SHProtoInputAttribute.h
//  SHNodeGraph
//
//  Created by steve hooley on 26/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHProtoAttribute.h"

@interface SHProtoInputAttribute : SHProtoAttribute {

	NSMutableArray		*nodesIAffect;
}

@property(readonly, nonatomic) NSMutableArray *nodesIAffect;

@end
