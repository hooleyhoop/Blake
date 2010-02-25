//
//  AllChildProxy.m
//  SHNodeGraph
//
//  Created by steve hooley on 04/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "AllChildProxy.h"


@implementation AllChildProxy

@synthesize icWasRemovedHint=_icWasRemovedHint;

- (void)interConnectorsWereRemoved {
	
	// could just rebuild the ic bit?
	_filteredTreeNeedsMaking = YES;
	_icWasRemovedHint = YES;
}

- (void)removeICsNoLongerInNode {
	
	NSUInteger countOfNodes = [[_originalNode nodesInside] count];
	NSUInteger countOfInputs = [[_originalNode inputs] count];
	NSUInteger countOfOutputs = [[_originalNode outputs] count];
	
	NSUInteger firstIndexOfICs = countOfNodes+countOfInputs+countOfOutputs;
	NSArray *justICProxies = [_filteredContent subarrayWithRange:NSMakeRange(firstIndexOfICs, [_filteredContent count]-firstIndexOfICs)];
	NSMutableIndexSet *indexesOfIcProxiesToDelete = [NSMutableIndexSet indexSet];

	for( AllChildProxy *each in justICProxies ){
		if(![_originalNode isChild:each.originalNode])
			[indexesOfIcProxiesToDelete addIndex:firstIndexOfICs];
		firstIndexOfICs++;
	}
	[self removeIndexesFromIndexesOfFilteredContent: indexesOfIcProxiesToDelete];
	[self removeFilteredContentAtIndexes: indexesOfIcProxiesToDelete];

	_icWasRemovedHint = NO;
}

- (NSArray *)nodeProxies {
	
	NSUInteger countOfNodes = [[_originalNode nodesInside] count];
	NSArray *justNodeProxies = [_filteredContent subarrayWithRange:NSMakeRange(0, countOfNodes)];
	return justNodeProxies;
}

- (NSArray *)inputProxies {
	
	NSUInteger countOfNodes = [[_originalNode nodesInside] count];
	NSUInteger countOfInputs = [[_originalNode inputs] count];
	NSArray *justInputProxies = [_filteredContent subarrayWithRange:NSMakeRange(countOfNodes, countOfInputs)];
	return justInputProxies;
}

- (NSArray *)outputProxies {
	
	NSUInteger countOfNodes = [[_originalNode nodesInside] count];
	NSUInteger countOfInputs = [[_originalNode inputs] count];
	NSUInteger countOfOutputs = [[_originalNode outputs] count];
	NSArray *justOutputProxies = [_filteredContent subarrayWithRange:NSMakeRange(countOfNodes+countOfInputs, countOfOutputs)];
	return justOutputProxies;
}

- (NSArray *)icProxies {
	
	NSUInteger countOfNodes = [[_originalNode nodesInside] count];
	NSUInteger countOfInputs = [[_originalNode inputs] count];
	NSUInteger countOfOutputs = [[_originalNode outputs] count];
	NSUInteger countOfICs = [[_originalNode shInterConnectorsInside] count];
	NSArray *justICputProxies = [_filteredContent subarrayWithRange:NSMakeRange(countOfNodes+countOfInputs+countOfOutputs, countOfICs)];
	return justICputProxies;
}

@end
