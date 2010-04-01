//
//  BKDocumentsProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKDocumentsProtocols.h"


@implementation BKPluginRegistry (BKDocumentProtocols)

+ (void)performDocumentMakeWindowControllersOnDocumentLifecycleExtensionPoint:(NSDocument *)document {
	BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
	NSArray *documentLifecyleExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentLifecycle" protocol:@protocol(BKDocumentLifecycleProtocol)];
	NSEnumerator *enumerator = [documentLifecyleExtensions objectEnumerator];
	BKExtension *each;
	
	while (each = [enumerator nextObject]) {
		[[each extensionInstance] documentMakeWindowControllers:document];
	}
}

+ (void)performDocumentWillReadOnDocumentLifecycleExtensionPoint:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName {
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSArray *documentLifecyleExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentLifecycle" protocol:@protocol(BKDocumentLifecycleProtocol)];
	NSEnumerator *enumerator = [documentLifecyleExtensions objectEnumerator];
    BKExtension *each;
	
    while (each = [enumerator nextObject]) {
		[[each extensionInstance] documentWillRead:document fromURL:absoluteURL ofType:typeName];
	}
}

+ (void)performDocumentDidReadOnDocumentLifecycleExtensionPoint:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName success:(BOOL)success {
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSArray *documentLifecyleExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentLifecycle" protocol:@protocol(BKDocumentLifecycleProtocol)];
	NSEnumerator *enumerator = [documentLifecyleExtensions objectEnumerator];
    BKExtension *each;
	
    while (each = [enumerator nextObject]) {
		[[each extensionInstance] documentDidRead:document fromURL:absoluteURL ofType:typeName success:success];
	}
}

+ (void)performDocumentWillSaveOnDocumentLifecycleExtensionPoint:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL {
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSArray *documentLifecyleExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentLifecycle" protocol:@protocol(BKDocumentLifecycleProtocol)];
	NSEnumerator *enumerator = [documentLifecyleExtensions objectEnumerator];
    BKExtension *each;
	
    while (each = [enumerator nextObject]) {
		[[each extensionInstance] documentWillSave:document writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL];
	}
}

+ (void)performDocumentDidSaveOnDocumentLifecycleExtensionPoint:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL success:(BOOL)success {
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSArray *documentLifecyleExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentLifecycle" protocol:@protocol(BKDocumentLifecycleProtocol)];
	NSEnumerator *enumerator = [documentLifecyleExtensions objectEnumerator];
    BKExtension *each;
	
    while (each = [enumerator nextObject]) {
		[[each extensionInstance] documentDidSave:document writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL success:success];
	}
}

@end

@implementation NSApplication (BKDocumentProtocols)

static NSDocument *currentDocument = nil;

- (NSDocument *)currentDocument {
	return currentDocument;
}

- (void)setCurrentDocument:(NSDocument *)newCurrentDocument {
	currentDocument = newCurrentDocument;
}

static NSWindowController *currentDocumentWindowController = nil;

- (NSWindowController *)currentDocumentWindowController {
	return currentDocumentWindowController;
}

- (void)setCurrentDocumentWindowController:(NSWindowController *)newCurrentDocumentWindowController {
	currentDocumentWindowController = newCurrentDocumentWindowController;
}

static NSWindow *currentDocumentWindow = nil;

- (NSWindow *)currentDocumentWindow {
	return currentDocumentWindow;
}

- (void)setCurrentDocumentWindow:(NSWindow *)newCurrentDocumentWindow {
	currentDocumentWindow = newCurrentDocumentWindow;
}

@end