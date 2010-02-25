//
//  MIOPMLImport.m
//  Mori
//
//  Created by Jesse Grosjean on 8/27/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "MIOPMLImport.h"


@implementation MIOPMLImport

- (NSArray *)supportedPathExtensions {
	return [NSArray arrayWithObject:@"opml"];
}

- (NSArray *)supportedUTIs {
	NSString *uti = (NSString *) UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, CFSTR("opml"), nil);
	return [NSArray arrayWithObject:[uti autorelease]];
}

- (id <MIEntryProtocol>)entryForOutlineElement:(NSXMLElement *)element document:(id <MIDocumentProtocol>)document {
	NSUndoManager *undoManager = [[document selfAsPersistentDocument] undoManager];
	id <MIEntryProtocol> entry = [NSObject insertNewEntryInDocument:document];
	NSEnumerator *enumerator = [[element children] objectEnumerator];
	id each;
	
	while (each = [enumerator nextObject]) {
		id <MIEntryProtocol> eachChildEntry = [self entryForOutlineElement:each document:document];
		[undoManager disableUndoRegistration];
		[entry addOrderedChild:eachChildEntry];
		[undoManager enableUndoRegistration];
	}

	id <MIEntryDataProtocol> entryData = [entry entryData];
	
	[undoManager disableUndoRegistration];
	[entryData setTitle:[[element attributeForName:@"text"] stringValue]];
	[[entryData textStorageUndoManager] disableUndoRegistration];
	[entryData setTextStorageContent:[[element attributeForName:@"_note"] stringValue]];
	[[entryData textStorageUndoManager] enableUndoRegistration];
	[undoManager enableUndoRegistration];
		
	return entry;
}

- (NSArray *)importURL:(NSURL *)url document:(id <MIDocumentProtocol>)document error:(NSError **)error {
	[[NSApp BKStatusMessageProtocols_statusMessageController] updateInformativeText:[url path]];
	
	NSXMLDocument *xmlDocument = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodePreserveWhitespace | NSXMLNodePreserveEntities error:error] autorelease];
	NSXMLElement *body = [[[xmlDocument rootElement] elementsForName:@"body"] lastObject];
	NSArray *outlines = [body elementsForName:@"outline"];
	NSEnumerator *enumerator = [outlines objectEnumerator];
	id each;

	id <MIEntryProtocol> opmlFile = [NSObject insertNewEntryInDocument:document withAttributesFromURL:url];
	
	while (each = [enumerator nextObject]) {
		[opmlFile addOrderedChild:[self entryForOutlineElement:each document:document]];
	}

	return [NSArray arrayWithObject:opmlFile];
}

@end
