//
//  BlakeDocumentController.m
//  Pharm
//
//  Created by Steve Hooley on 16/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//
#import "defs.h"
#import "BlakeDocumentController.h"
#import "SHApplication.h"
#import "BlakeDocument.h"
#import "BlakeController.h"
#import <SHPluginManager/SHPluginManager.h>

/*
 *  One of these per App
*/
@implementation BlakeDocumentController

@synthesize customDocClass;
@synthesize isSetup = _isSetup;

#pragma mark -
#pragma mark class methods
+ (id)sharedDocumentController  {

    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
		NSAssert(sharedInstance==[BlakeDocumentController sharedDocumentController], @"BlakeDocumentController must be set as standard document controller.");
    }
    return sharedInstance;
}

#pragma mark init classes
- (id)init {

	self = [super init];
	if( self ) {
		_isSetup = NO;
	}
	return self;
}

/* We are a singleton to manage all documents */
- (void)dealloc {
	
	//	logInfo(@"Deallocating BlakeDocumentController");
	NSAssert(_isSetup==YES, @"destroying BlakeDocumentController wasn't setup properly");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignMainNotification object:nil];

	[super dealloc];
}

- (void)setupObserving {
	
	NSAssert(_isSetup==NO, @"DONT SETUP Twice!");

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeMainNotification:) name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillCloseNotification:) name:NSWindowWillCloseNotification object:nil];
	_isSetup = YES;
}

// use validateUserInterfaceItem
//- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem 
//{
//	logInfo(@"BlakeDocumentController.m: validateMenuItem");

//	if ([menuItem action] == @selector(_openRecentDocument:)) {
//		// XXX _openRecentDocument: fails to work in full screen mode, so for now disable those menu items. Try again in leopard.
//		SystemUIMode mode;
//		SystemUIOptions options;
//		
//		GetSystemUIMode(&mode, &options);
//		
//		if (mode == kUIModeAllHidden && options == kUIOptionAutoShowMenuBar) {
//			return NO;
//		}
//	}
//	return [super validateMenuItem:menuItem];	
//}



//#pragma mark menu item methods
/* Used by _openRecentDocument, clearRecentDocuments */
//- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem {
//	logInfo(@"validateUserInterfaceItem %@", anItem);
//	return [super validateUserInterfaceItem:anItem];
//}

#pragma mark File Menu methods

//TODO: surely there is a defaudlt implementation of close document?
// ACCCCCCTTTTUUUALLLLYY it goes to - (void)performClose:(id)sender in window you dolt
//jan10- (IBAction)closeDocument:(id)sender {
//jan10	
//jan10	[_documentController closeDocument];
//jan10	}
//jan10	this dont look like an avtion method!
//jan10	- (void)closeDocument {
//jan10		[_documentController tryToCloseDoc:frontDoc];
//jan10	}
//jan10	canCloseDocument {
//jan10		NSArray *allDocs = [_sharedApp openDocs];
//jan10		validItem = ([allDocs count]>0);
//jan10	}

#pragma mark notification methods
- (void)windowDidBecomeMainNotification:(NSNotification *)notification {
	
//	logInfo(@"BlakeDocumentController.m: windowDidBecomeMainNotification");

//	NSWindow *window = [notification object];
//	BlakeNodeListWindowController *windowController = [window windowController];
//	BlakeDocument *document = [windowController document];
	
//	if (document && document!=[NSApp currentDocument]) {
//		[NSApp setCurrentDocument:(NSDocument *)document];
//		[NSApp setCurrentDocumentWindowController:(NSWindowController *)windowController];
//		[NSApp setCurrentDocumentWindow:window];
//	}
}

- (void)windowWillCloseNotification:(NSNotification *)notification 
{
//	logInfo(@"BlakeDocumentController.m: windowWillCloseNotification");

//	NSWindow *window = [notification object];
	
//	if (window == [NSApp currentDocumentWindow]) {
//		[NSApp setCurrentDocument:nil];
//		[NSApp setCurrentDocumentWindowController:nil];
//		[NSApp setCurrentDocumentWindow:nil];
//	}
}

// #pragma mark loading plugins

//- (NSArray *)documentTypeExtensions 
//{
//	logInfo(@"BlakeDocumentController.m: documentTypeExtensions");
//	NSMutableArray *results = [NSMutableArray array];
//    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
//    NSEnumerator *enumerator = [[pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKDocuments.documentType" protocol:@protocol(BKDocumentTypeProtocol)] objectEnumerator];
//    BBExtension *each;
//	
//    while (each = [enumerator nextObject]) {
//		id <BKDocumentTypeProtocol> extension = [each extensionInstance];
//		[results addObject:extension];
//	}
//	return results;
//}

//- (id)documentTypeExtensionSupportingType:(NSString *)typeName 
//{
//	logInfo(@"BlakeDocumentController.m: documentTypeExtensionSupportingType %@", typeName);
//
//	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
//	id each;
//	
//	while (each = [enumerator nextObject]) {
//from BLOCKS		if ([[each supportedTypes] containsObject:typeName]) {
//from BLOCKS			return each;
//from BLOCKS		}
//	}
//	return nil;
//}

#pragma mark opening & closing documents

//- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError
//{
//	logInfo(@"BlakeDocumentController.m: openDocumentWithContentsOfURL");
//	id document = [super openDocumentWithContentsOfURL:absoluteURL display:displayDocument error:outError];
	
//	if (!document) {
//		NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
//		id <BKDocumentTypeProtocol> each;
//		
//		while (each = [enumerator nextObject]) {
//			if (!document) {
//				// allow document types one last change to open document or to modify error message.
//				document = [each failedToOpenDocumentWithContentsOfURL:absoluteURL display:displayDocument error:outError];
//			}
//		}
//	}
//	return document;
//}


//- (IBAction)newDocument:(id)sender
//{
//	logInfo(@"BlakeDocumentController.m: newDocument");
//	NSError *error;
//	id newDocument = [self openUntitledDocumentAndDisplay:YES error:&error];
//	if (newDocument != [NSNull null]) {
//		if (!newDocument) {
//			if (error) {
//				[self presentError:error];
//			}
//		} else {
//			[self addDocument:newDocument];
//		}		
//	}	
//}


// use super is fine
//- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError 
//{
//	logInfo(@"BlakeDocumentController.m: openUntitledDocumentAndDisplay");
//	id <BKDocumentTypeProtocol> documentTypeExtension = [self documentTypeExtensionSupportingType:[self defaultType]];
//	if (documentTypeExtension) {
//		id document = [documentTypeExtension openUntitledDocumentAndDisplay:displayDocument error:outError];
//		if (document) {
//			return document;
//		}
//	}
//	return [super openUntitledDocumentAndDisplay:displayDocument error:outError];
//}

// use super is fine
// - (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError 
// {
//	logInfo(@"BlakeDocumentController.m: makeUntitledDocumentOfType");
//	id <BKDocumentTypeProtocol> documentTypeExtension = [self documentTypeExtensionSupportingType:typeName];
//	
//	if (documentTypeExtension) {
//		id document = [documentTypeExtension makeUntitledDocumentOfType:typeName error:outError];
//		if (document) {
//			return document;
//		}
//	}
//	
//	return [super makeUntitledDocumentOfType:typeName error:outError];
// }

//- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError **)outError {
//
//
////	[NSApp activateIgnoringOtherApps:YES];
////	[NSApp arrangeInFront:self];
////	[NSApp unhide: self];
////	[NSThread sleepForTimeInterval:10];
//	
////	id currentDoc = [self currentDocument];
//	id newDoc = [super openUntitledDocumentAndDisplay:displayDocument error:outError];
////	id winController = [[newDoc windowControllers] lastObject];
//
////	NSWindow *currentWin = [winController window];
////	NSAssert(currentWin!=nil, @"need a window for the tests to work..");
////	[currentWin makeKeyAndOrderFront:self]; 
//
////	if([BlakeController blakeController].didFinishLaunching)
////	{
////		if([currentWin isKeyWindow]){
////			logInfo(@"wwwwwwwwwwwwwwwworked");
////		} else {
////			logInfo(@"NO NO NO NO did not work");
////		}
////		NSAssert1([currentWin isKeyWindow], @"Will only be the current document if it's window is key, %@", currentWin);	
////		NSWindow *keyWindow = [NSApp keyWindow];
////		NSAssert1(keyWindow==currentWin, @"current document boils down to NSWindowController document %@", keyWindow);
////		currentDoc = [self currentDocument];
////		NSAssert(currentDoc!=nil, @"what is happening here?");
////		NSAssert(newDoc==currentDoc, @"wha? How do i set the current doc?");
//		// [NSApp setCurrentDocument:newDoc];
////	}
//	return newDoc;
//}

- (id)makeUntitledDocumentOfType:(NSString *)typeName error:(NSError **)outError {

	BlakeDocument *doc = (BlakeDocument *)[super makeUntitledDocumentOfType:typeName error:outError];
	doc.shDocumentController = self;
	return doc;
}

- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError  {
	
	NSAssert(_isSetup==YES, @"making BlakeDocumentController wasn't setup properly");

	// make sure it is a doc that it is added to recent items
	NSString *fPath = [absoluteURL path];
	NSString* pathExtension = [fPath pathExtension];
	if([pathExtension isEqualToString:documentExtension])
	{
		id newDoc = [super makeDocumentWithContentsOfURL:absoluteURL ofType:typeName error:outError];
		[self noteNewRecentDocumentURL: absoluteURL];
		return newDoc;
	}
	return nil;
	
//TODO: Read apple mailing lists about bundle bit and setting up your plist
	//	Yes.  You can use the MoreFilesX sample code and do this:
	//		FSChangeFinderFlags (&theFsRef, true, kHasBundle);
}

//- (int)runModalOpenPanel:(NSOpenPanel *)openPanel forTypes:(NSArray *)extensions 
//{
//	logInfo(@"BlakeDocumentController.m: runModalOpenPanel");
//	return [super runModalOpenPanel:openPanel forTypes:extensions];
//}

//- (void)removeDocument:(NSDocument *)document {
//	[super removeDocument: document];
//}

#pragma mark support for dynamically-enabled document types

- (NSString *)defaultType {
	return @"BlakeDocument";
}

/* Use a custom document class for debbuging. */
- (Class)documentClassForType:(NSString *)typeName {

	Class docClass;
	if(customDocClass){
		docClass = customDocClass;
		self.customDocClass = nil;
	} else if([typeName isEqualToString:@"BlakeDocument"]){
		return NSClassFromString(@"BlakeDocument");
	} else {
		docClass = [super documentClassForType:typeName];
	}
	return docClass;
}

- (NSString *)typeFromFileExtension:(NSString *)fileNameExtensionOrHFSFileType {
	
	if(customDocClass){
		return @"Custom";
	}
	return [super typeFromFileExtension:fileNameExtensionOrHFSFileType];
}

- (NSArray *)windowControllerClasses {
	
	NSMutableArray *documentViews = [NSMutableArray array];

	NSString *OVERIDECLASS = (NSString *)[[SHGlobalVars globals] objectForKey:@"DOCUMENT_WINDOW_EXTENSIONCLASS"];
	if(OVERIDECLASS){
		[documentViews addObject:OVERIDECLASS];
	} else {

		// get the highest priority window controller
		BBPluginRegistry *pluginRegistery = [BBPluginRegistry sharedInstance];
		NSArray *viewPlugins = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BlakeMain.documentView" protocol:@protocol(SHDocumentViewExtensionProtocol)]; 
		logWarning(@"we got %i plugins", [viewPlugins count]);
		for( BBExtension *each in viewPlugins ) {
			NSObject <SHDocumentViewExtensionProtocol> *extension = [each extensionInstance];
			[documentViews addObject:[extension windowControllerClassName]];
		}
	}
	
	return documentViews;
}

// use super is fine
//- (NSString *)defaultType 
//{
//	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
//	id <BKDocumentTypeProtocol> each;
//	
//	while (each = [enumerator nextObject]) {
//		NSString *defaultType = [each defaultType];
//		if (defaultType) {
//			return defaultType;
//		}
//	}
//	
//	NSString *result = [super defaultType];
//	logInfo(@"BlakeDocumentController.m: defaultType.. %@", result);
//	return result;
//}

//- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError
//{
//	logInfo(@"BlakeDocumentController.m: typeForContentsOfURL %@", inAbsoluteURL);
//	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
//	id <BKDocumentTypeProtocol> each;
//	
//	if (outError) *outError = nil;
//	
//	while (each = [enumerator nextObject]) {
//		NSString *result = [each typeForContentsOfURL:inAbsoluteURL error:outError];
//		if (result) {
//			return result;
//		} else if (outError && *outError != nil) {
//			return nil;
//		}
//	}
//	
//	NSString *result = [super typeForContentsOfURL:inAbsoluteURL error:outError];
//	return result;
//}

//- (NSArray *)documentClassNames
//{
//	logInfo(@"BlakeDocumentController.m: documentClassNames");
//	NSMutableArray *result = [NSMutableArray array];
//	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
//	id <BKDocumentTypeProtocol> each;
//	
//	while (each = [enumerator nextObject]) {
//		[result addObjectsFromArray:[each documentClassNames]];
//	}
//	
//	[result addObjectsFromArray:[super documentClassNames]];
//	
//	return result;
// }

	
// use super is fine
//- (Class)documentClassForType:(NSString *)documentTypeName 
//{
//	NSEnumerator *enumerator = [[self documentTypeExtensions] objectEnumerator];
//	id <BKDocumentTypeProtocol> each;
//	
//	while (each = [enumerator nextObject]) {
//		Class result = [each documentClassForType:documentTypeName];
//		if (result) {
//			return result;
//		}
//	}
//	
//	Class docClass = [super documentClassForType:documentTypeName];
//	logInfo(@"BlakeDocumentController.m: documentClassForType %@", NSStringFromClass(docClass));
//	return docClass;
//}

//- (NSString *)displayNameForType:(NSString *)documentTypeName 
//{
//	logInfo(@"BlakeDocumentController.m: displayNameForType");
//	NSString *result = [super displayNameForType:documentTypeName];
//	return result;
//}
//
//- (NSArray *)fileExtensionsFromType:(NSString *)documentTypeName 
//{
//	logInfo(@"BlakeDocumentController.m: fileExtensionsFromType");
//	NSArray *result = [super fileExtensionsFromType:documentTypeName];
//	return result;
//}
//
//- (NSString *)typeFromFileExtension:(NSString *)fileExtensionOrHFSFileType
//{
//	logInfo(@"BlakeDocumentController.m: typeFromFileExtension");
//	NSString *result = [super typeFromFileExtension:fileExtensionOrHFSFileType];
//	return result;
//}

- (SHNodeGraphModel *)frontDoc_graph {
	return nil;
}

- (SHNode *)frontDoc_currentNode {
	return nil;
}



@end
