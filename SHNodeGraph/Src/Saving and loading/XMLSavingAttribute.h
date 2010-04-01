//
//  XMLSavingAttribute.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 04/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHAttribute.h"

@interface SHAttribute (XMLSavingAttribute)

+ (SHAttribute *)newAttributeWithXMLElement:(NSXMLElement *)value;

- (NSXMLElement *)xmlRepresentation;

@end
