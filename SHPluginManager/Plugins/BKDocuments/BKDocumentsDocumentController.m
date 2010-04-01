//
//  BKDocumentsDocumentController.m
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKDocumentsDocumentController.h"


@implementation BKDocumentsDocumentController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
		logAssert(sharedInstance == [NSDocumentController sharedDocumentController], @"BKDocumentsDocumentController must be set as standard document controller.");
    }
    return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeMainNotification:) name:NSWindowDidBecomeMainNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillCloseNotification:) name:NSWindowWillCloseNotification object:nil];
	}
	return self;
}

//- (void)_openRecentDocument:(id)fp8 {
//	NSBeep();
//	[super _openRecentDocument:fp8];
//}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {
	if ([menuItem action] == @selector(_openRecentDocument:)) {
		// XXX _openRecentDocument: fails to work in full screen mode, so for now disable those menu items. Try again in leopard.
		SystemUIMode mode;
		SystemUIOptions options;

		GetSystemUIMode(&mode, &options);
		
		if (mode == kUIModeAllHidden && options == kUIOptionAutoShowMenuBar) {
			return NO;
		}
	}
	return [super validateMenuItem:menuItem];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignMainNotification object:nil];
	[super dealloc];
}

- (void)windowDidBecomeMainNotification:(NSNotification *)notification {
	NSWindow *window = [notification object];
	NSWindowController *windowController = [window windowController];
	NSDocument *document = [windowController document];
	
	if (document) {
		[NSApp setCurrentDocument:document];
		[NSApp setCurrentDocumentWindowController:windowController];
		[NSApp setCurrentDocumentWindow:window];
	}
}

- (void)windowWillCloseNotification:(NSNotification *)notification {
	NSWindow *window = [notification object];

	if (window == [NSApp currentDocumentWindow]) {
		[NSApp setCurrentDocument:nil];
		[NSApp setCurrentDocumentWindowController:nil];
		[NSApp setCurrentDocumentWindow:nil];
	}
}

#pragma mark loading plugins

- (NSArray *)documentTypeExtensions {
	NSMutableArray *results = [NSMutableArray array];
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSEnumerator *enumerator = [[pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentType" protocol:@protocol(BKDocumentTypeProtocol)] objectEnumerator];
    BKExtension *each;
	
    while (each = [enumerator nextObject]) {
		id <BKDocumentTypeProtocol> extension = [each extensionInstance];
		[results addObject:extension];
	}
	
	return results;
}

- (id <BKDocumentTypeProtocol>)documentTypeExtensionSupportingType:(NSString *)typeName {
	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
	id <BKDocumentTypeProtocol> each;
	
	while (each = [enumerator nextObject]) {
		if ([[each supportedTypes] containsObject:typeName]) {
			return each;
		}
	}
	
	return nil;
}

#pragma mark opening documents

- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError {
	id document = [super openDocumentWithContentsOfURL:absoluteURL display:displayDocument error:outError];
	
	if (!document) {
		NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
		id <BKDocumentTypeProtocol> each;
		
		while (each = [enumerator nextObject]) {
			if (!document) {
				// allow document types one last change to open document or to modify error message.
				document = [each failedToOpenDocumentWithContentsOfURL:absoluteURL display:displayDocument error:outError];
			}
		}
	}
	
	return document;
}

- (IBAction)newDocument:(id)sender {

	NSError *error;
	id newDocument = [self openUntitledDocumentAndDisplay:YES error:&error];
	
	if (newDocument != [NSNull null]) {
		if (!newDocument) {
			if (error) {
				[self presentError:error];
			}
		} else {
			[self addDocument:newDocument];
		}		
	}	
}

- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError {
	id <BKDocumentTypeProtocol> documentTypeExtension = [self documentTypeExtensionSupportingType:[self defaultType]];
	
	if (documentTypeExtension) {
		id document = [documentTypeExtension openUntitledDocumentAndDisplay:displayDocument error:outError];
		if (document) {
			return document;
		}
	}

	return [super openUntitledDocumentAndDisplay:displayDocument error:outError];
}

- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError {
	id <BKDocumentTypeProtocol> documentTypeExtension = [self documentTypeExtensionSupportingType:typeName];
	
	if (documentTypeExtension) {
		id document = [documentTypeExtension makeUntitledDocumentOfType:typeName error:outError];
		if (document) {
			return document;
		}
	}

	return [super makeUntitledDocumentOfType:typeName error:outError];
}

- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	id <BKDocumentTypeProtocol> documentTypeExtension = [self documentTypeExtensionSupportingType:typeName];
	
	if (documentTypeExtension) {
		id document = [documentTypeExtension makeDocumentWithContentsOfURL:absoluteURL ofType:typeName error:outError];
		if (document) {
			return document;
		}
	}
	
	return [super makeDocumentWithContentsOfURL:absoluteURL ofType:typeName error:outError];
}

- (int)runModalOpenPanel:(NSOpenPanel *)openPanel forTypes:(NSArray *)extensions {
	return [super runModalOpenPanel:openPanel forTypes:extensions];
}

#pragma mark support for dynamically-enabled document types

- (NSString *)defaultType {
	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
	id <BKDocumentTypeProtocol> each;
	
	while (each = [enumerator nextObject]) {
		NSString *defaultType = [each defaultType];
		if (defaultType) {
			return defaultType;
		}
	}
	
	NSString *result = [super defaultType];
	return result;
}

- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError {
	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
	id <BKDocumentTypeProtocol> each;
	
	if (outError) *outError = nil;
	
	while (each = [enumerator nextObject]) {
		NSString *result = [each typeForContentsOfURL:inAbsoluteURL error:outError];
		if (result) {
			return result;
		} else if (outError && *outError != nil) {
			return nil;
		}
	}
	
	NSString *result = [super typeForContentsOfURL:inAbsoluteURL error:outError];
	return result;
}

- (NSArray *)documentClassNames {
	NSMutableArray *result = [NSMutableArray array];
	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
	id <BKDocumentTypeProtocol> each;
	
	while (each = [enumerator nextObject]) {
		[result addObjectsFromArray:[each documentClassNames]];
	}
	
	[result addObjectsFromArray:[super documentClassNames]];

	return result;
}

- (Class)documentClassForType:(NSString *)documentTypeName {
	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
	id <BKDocumentTypeProtocol> each;
	
	while (each = [enumerator nextObject]) {
		Class result = [each documentClassForType:documentTypeName];
		if (result) {
			return result;
		}
	}
	
	return [super documentClassForType:documentTypeName];
}

- (NSString *)displayNameForType:(NSString *)documentTypeName {
	NSString *result = [super displayNameForType:documentTypeName];
	return result;
}

- (NSArray *)fileExtensionsFromType:(NSString *)documentTypeName {
	NSArray *result = [super fileExtensionsFromType:documentTypeName];
	return result;
}

- (NSString *)typeFromFileExtension:(NSString *)fileExtensionOrHFSFileType {
	NSString *result = [super typeFromFileExtension:fileExtensionOrHFSFileType];
	return result;
}

@end
