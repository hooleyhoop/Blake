//
//  BKDocumentsProtocols.h
//  Blocks
//
//  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
//  Copyright ÇYEARÈ ÇORGANIZATIONNAMEÈ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>


@protocol BKDocumentLifecycleProtocol <NSObject>

- (void)documentMakeWindowControllers:(NSDocument *)document;
- (void)documentWillRead:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName;
- (void)documentDidRead:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName success:(BOOL)success;
- (void)documentWillSave:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL;
- (void)documentDidSave:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL success:(BOOL)success;

@end

@protocol BKDocumentTypeProtocol <NSObject>

- (NSArray *)supportedTypes;
- (NSString *)defaultType;
- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError;
- (NSArray *)documentClassNames;
- (Class)documentClassForType:(NSString *)typeName;
- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError;
- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError;
- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;
- (id)failedToOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError;

@end

@interface BKPluginRegistry (BKDocumentProtocols)

+ (void)performDocumentMakeWindowControllersOnDocumentLifecycleExtensionPoint:(NSDocument *)document;
+ (void)performDocumentWillReadOnDocumentLifecycleExtensionPoint:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName;
+ (void)performDocumentDidReadOnDocumentLifecycleExtensionPoint:(NSDocument *)document fromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName success:(BOOL)success;
+ (void)performDocumentWillSaveOnDocumentLifecycleExtensionPoint:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL;
+ (void)performDocumentDidSaveOnDocumentLifecycleExtensionPoint:(NSDocument *)document writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL success:(BOOL)success;

@end

@interface NSApplication (BKDocumentProtocols)

- (NSDocument *)currentDocument;
- (void)setCurrentDocument:(NSDocument *)newCurrentDocument;
- (NSWindowController *)currentDocumentWindowController;
- (void)setCurrentDocumentWindowController:(NSWindowController *)newCurrentDocumentWindowController;
- (NSWindow *)currentDocumentWindow;
- (void)setCurrentDocumentWindow:(NSWindow *)newCurrentDocumentWindow;

@end
