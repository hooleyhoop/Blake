//
//  AllChildrenProxyFactory.m
//  SHNodeGraph
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "AllChildrenProxyFactory.h"
#import "AllChildProxy.h"
#import "SHChild.h"
#import "AllChildrenFilter.h"

@implementation AllChildrenProxyFactory

- (NSMutableArray *)proxysForObjects:(NSArray *)graphObjects inFilter:(AllChildrenFilter *)filter {
	
	NSMutableArray *itemsThatPassTests = [NSMutableArray array];
	for( SHChild *each in graphObjects ){
		AllChildProxy *newProxy = [AllChildProxy makeNodeProxyWithFilter:filter object:each];
		[itemsThatPassTests addObject:newProxy];
	}
	return itemsThatPassTests;
}


@end
