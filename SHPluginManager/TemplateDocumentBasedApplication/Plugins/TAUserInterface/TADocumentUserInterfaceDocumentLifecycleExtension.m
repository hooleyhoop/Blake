//
//  TADocumentUserInterfaceDocumentLifecycleExtension.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 11/17/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TADocumentUserInterfaceDocumentLifecycleExtension.h"
#import "TADocumentWindowController.h"


@implementation TADocumentUserInterfaceDocumentLifecycleExtension

- (void)documentMakeWindowControllers:(NSDocument *)document {
	if ([document conformsToProtocol:@protocol(TADocumentProtocol)]) {
		TADocumentWindowController *windowController = [[[TADocumentWindowController alloc] init] autorelease];
		[document addWindowController:windowController];
	}
}

- (void)documentWillRead:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName {
	
}

- (void)documentDidRead:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName success:(BOOL)success {
	
}

- (void)documentWillSave:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL {
	
}

- (void)documentDidSave:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL success:(BOOL)success {
	
}

@end
