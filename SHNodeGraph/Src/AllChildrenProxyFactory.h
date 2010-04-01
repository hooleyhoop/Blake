//
//  AllChildrenProxyFactory.h
//  SHNodeGraph
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//


@class AllChildrenFilter;

@interface AllChildrenProxyFactory : _ROOT_OBJECT_ {

}

- (NSMutableArray *)proxysForObjects:(NSArray *)graphObjects inFilter:(AllChildrenFilter *)filter;

@end
