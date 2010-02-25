//
//  SHProtoOutputAttribute.m
//  SHNodeGraph
//
//  Created by steve hooley on 26/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHProtoOutputAttribute.h"

@implementation SHProtoOutputAttribute

- (void)setDirtyBelow:(int)uid {
	if(uid!=_dirtyRecursionID)
	{
		_dirtyRecursionID=uid;
		[super setDirtyBelow:uid];
	}
}

@end
