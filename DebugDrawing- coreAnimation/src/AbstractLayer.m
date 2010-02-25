//
//  AbstractLayer.m
//  DebugDrawing
//
//  Created by steve hooley on 16/12/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "AbstractLayer.h"


@implementation AbstractLayer

- (void)wasAdded {
}

- (void)wasRemoved {
}


/* Hmm what could we use this for? 
	-- can run an action when a property changes, eg -name, -backgroundColor, -delegate
 */
+ (id<CAAction>)defaultActionForKey:(NSString *)aKey {
	return nil;
}

- (NSDictionary *)animations {
	[NSException raise:@"is this needed?" format:@"doh"];
	return nil; // COV_NF_LINE
}

// The layer would have to be it's own delegate for this to work
// If you want to execute actions you can add them to the style dictionary
// called for - hidden
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key {
	return (id<CAAction>)[NSNull null];
}

- (NSString *)description {

	// delegate may be a node or maybe another layer
	id delegateName = [self.delegate name];
	if([delegateName respondsToSelector:@selector(value)])
		delegateName = [delegateName value];
	NSString *thisSummary = [NSString stringWithFormat:@"%@ - %@\n", [super description], delegateName];
	return thisSummary;
}
@end
