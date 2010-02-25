//
//  XMLSavingInterConnector.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 04/09/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHInterConnector.h"

@interface SHInterConnector (XMLSavingInterConnector) 

- (NSXMLElement *)xmlRepresentation;


@end
