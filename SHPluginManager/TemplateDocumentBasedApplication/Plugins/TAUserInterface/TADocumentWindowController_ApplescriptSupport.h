//
//  TADocumentWindowController_ApplescriptSupport.h
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 11/17/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TADocumentWindowController.h"


@interface TADocumentWindowController (ApplescriptSupport)

#pragma mark properties

- (NSNumber *)uniqueID;
- (NSString *)name;

@end

@interface NSApplication (TADocumentWindowControllerApplescriptSupport)

#pragma mark elements

- (NSArray *)documentViewers;

@end

@interface NSDocument (TADocumentWindowControllerApplescriptSupport)

#pragma mark properties

- (NSArray *)selection;

#pragma mark elements

- (NSArray *)documentViewers;

@end