//
//  SHNodeGraphModel_sketchAmmends.m
//  SHNodeGraph
//
//  Created by steve hooley on 02/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SHNodeGraphModel_sketchAmmends.h"
#import "SHNodeSelectingMethods.h"
#import "SKTGraphic.h"
#import "SHContentProvidorProtocol.h"
#import "AbtractModelFilter.h"
#import <SHShared/BBLogger.h>

@implementation  SHNodeGraphModel (SHNodeGraphModel_sketchAmmends)


// There's no need for a -setGraphics: method right now, because [thisDocument mutableArrayValueForKey:@"graphics"] will happily return a mutable collection proxy
// that invokes our insertion and removal methods when necessary.
// A pitfall to watch out for is that -setValue:forKey: is _not_ bright enough to invoke our insertion and removal methods when you would think it should.
// If we ever catch anyone sending this object -setValue:forKey: messages for "graphics" then we have to add -setGraphics:. 
// When we do, there's another pitfall to watch out for: if -setGraphics: is implemented in terms of -insertGraphics:atIndexes: and -removeGraphicsAtIndexes:, or vice versa, 
// then KVO autonotification will cause observers to get redundant, incorrect, notifications (because all of the methods involved have KVC-compliant names).

//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
//	
//	BOOL automatic = NO;
//	
//    if ([theKey isEqualToString:@"selectionIndexes"]) {
//        automatic=NO;
//    } else {
//        automatic=[super automaticallyNotifiesObserversForKey:theKey];
//    }
//    return automatic;
//}

#pragma mark -
#pragma mark action methods


- (void)insertGraphic:(SHNode *)graphic atIndex:(NSUInteger)gindex {
	
	NSParameterAssert(graphic!=nil);
	NSParameterAssert(gindex<([[self graphics] count]+1));
	[self NEW_addChild:graphic toNode:_rootNodeGroup atIndex:gindex];
}


- (void)setIndexOfChild:(id)child to:(int)i {
	
	NSAssert( [_rootNodeGroup indexOfChild: child]!=NSNotFound, @"Cant find node");
	[_rootNodeGroup setIndexOfChild:child to:i];
}

- (void)setSelectedObjects:(NSArray *)value {
	
	NSParameterAssert(value!=nil);
	[_rootNodeGroup setSelectedChildren:value];
}

- (NSArray *)selectedObjects {
	
	return [_rootNodeGroup selectedChildNodes];
}

- (BOOL)isSelected:(id)value {
	
	NSParameterAssert([[self graphics] containsObject:value]==true);
	NSArray *selectedObjects = [self selectedObjects];
	int ind = [selectedObjects indexOfObjectIdenticalTo: value];
	if(ind!=NSNotFound)
		return YES;
	return NO;
}

- (void)setSelectionIndexes:(NSMutableIndexSet *)value {
	
	[_rootNodeGroup setSelectedNodesInsideIndexes:value];
}

#pragma mark Indexed Accessors
/* Indexed Accessors */
/* this automatically triggers array did change notication */
/* KVO methods for graphics */
- (id)objectInGraphicsAtIndex:(unsigned int)gindex {
    return [[self graphics] objectAtIndex: gindex];
}

- (void)removeObjectFromGraphicsAtIndex:(unsigned int)gindex {
	
	[_rootNodeGroup deleteChild: [_rootNodeGroup nodeAtIndex:gindex]];
}

- (SHOrderedDictionary *)graphics {
	return [_rootNodeGroup nodesInside];
}

- (NSMutableIndexSet *)selectionIndexes {
	return [[_rootNodeGroup nodesInside] selection];
}

@end
