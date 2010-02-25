/*
 *  TADocumentProtocols.h
 *  TemplateDocumentBasedApplication
 *
 *  Created by Jesse Grosjean on 11/17/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>


@protocol TADocumentProtocol <NSObject>

- (NSPersistentDocument *)selfAsPersistentDocument;

@end
