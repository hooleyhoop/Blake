/*
 *  TAUserInterfaceProtocols.h
 *  TemplateDocumentBasedApplication
 *
 *  Created by Jesse Grosjean on 11/17/05.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#include <Cocoa/Cocoa.h>

@protocol TADocumentWindowControllerProtocol <NSObject>

- (NSWindowController *)selfAsWindowController;

@end