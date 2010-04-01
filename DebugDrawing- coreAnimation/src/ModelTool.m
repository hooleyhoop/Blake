//
//  ModelTool.m
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ModelTool.h"


@implementation ModelTool

- (id)initWithDomainContext:(DomainContext *)dc {
	
	self = [super init];
	if ( self ) {
		_domain = dc;
	}
	return self;
}

- (SHNode *)nodeUnderPoint:(NSPoint)pt {
	
	return [_domain nodeUnderPoint:pt];
}

- (NSString *)identifier { return @"MODELTOOL_ABSTRACT"; }

@end
