//
//  TADocument.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 12/6/04.
//  Copyright Hog Bay Software 2004 . All rights reserved.
//

#import "TADocument.h"


@implementation TADocument

#pragma mark init methods

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

#pragma mark awakeFromNib-like methods

- (void)makeWindowControllers {
	[BKPluginRegistry performDocumentMakeWindowControllersOnDocumentLifecycleExtensionPoint:self];
}

#pragma mark accessors

- (NSPersistentDocument *)selfAsPersistentDocument {
	return self;
}

#pragma mark load / save

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)error {
	[BKPluginRegistry performDocumentWillReadOnDocumentLifecycleExtensionPoint:self fromURL:absoluteURL ofType:typeName];
	BOOL success = [super readFromURL:absoluteURL ofType:typeName error:error];
	[BKPluginRegistry performDocumentDidReadOnDocumentLifecycleExtensionPoint:self fromURL:absoluteURL ofType:typeName success:success];
	return success;
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)error {
	[BKPluginRegistry performDocumentWillSaveOnDocumentLifecycleExtensionPoint:self writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL];
	BOOL success = [super writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:error];
	[BKPluginRegistry performDocumentDidSaveOnDocumentLifecycleExtensionPoint:self writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL success:success];
	return success;
}

@end
