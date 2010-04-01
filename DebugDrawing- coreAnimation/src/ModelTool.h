//
//  ModelTool.h
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//
#import "Tool.h"

@class DomainContext;

@interface ModelTool : Tool {

	DomainContext		*_domain;

}

- (id)initWithDomainContext:(DomainContext *)dc;

- (SHNode *)nodeUnderPoint:(NSPoint)pt;

@end
