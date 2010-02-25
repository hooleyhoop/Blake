//
//  XMLSavingNode.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 01/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHNode.h"


@interface SHNode (XMLSavingNode)

+ (SHNode *)newNodeWithXMLElement:(NSXMLElement *)value;

- (NSXMLElement *)xmlRepresentation;

@end
