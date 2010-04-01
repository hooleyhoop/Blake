//
//  SHProtoInputAttribute.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHProtoInputAttribute.h"


@implementation SHProtoInputAttribute

@synthesize nodesIAffect;

- (id)init {

	self=[super init];
	if(self) {
		nodesIAffect = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	
	[nodesIAffect release];
    [super dealloc];
}

- (void)setDirtyBelow:(int)uid {
	
	// RIGHT
	// All the nodes in the tree below must be marked as dirty, just because you
	// get to a dirty section, doesnt mean there couldnt be a clean bit below that..
	
	// traverse, mark as dirty
	if(uid!=_dirtyRecursionID)
	{
		_dirtyRecursionID=uid;
		
		for( SHProtoAttribute *outAtt in nodesIAffect )
		{
//TODO: Test This
			[outAtt setDirtyBit:YES uid:uid];
			[outAtt setDirtyBelow:uid];
		}
		[super setDirtyBelow:uid];
	}
}

@end
