//
//  MIOPMLExport.m
//  Mori
//
//  Created by Jesse Grosjean on 10/10/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "MIOPMLExport.h"


@implementation MIOPMLExport

- (NSArray *)supportedUTIs {
	NSString *uti = (NSString *) UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, CFSTR("opml"), nil);
	return [NSArray arrayWithObject:[uti autorelease]];
}

- (NSString *)descriptionForUTI:(NSString *)uti {
	return BKLocalizedString(@"OPML file", @"");
}

- (NSXMLElement *)outlineElementForEntry:(id <MIEntryProtocol>)entry {
	NSXMLElement *element = [[[NSXMLElement alloc] initWithName:@"outline"] autorelease];
	NSEnumerator *enumerator = [entry childEnumerator:nil];
	id each;
	
	while (each = [enumerator nextObject]) {
		[element addChild:[self outlineElementForEntry:each]];
	}

	[element addAttribute:[NSXMLNode attributeWithName:@"text" stringValue:[[entry entryData] title]]];

	if ([[entry entryData] hasText]) {
		NSString *noteString = [[[[entry entryData] textStorage] string] stringByEscapingEntities];
		NSXMLNode *noteAttribute = [[NSXMLNode alloc] initWithKind:NSXMLAttributeKind options:NSXMLNodePreserveCharacterReferences];
		
		[noteAttribute setName:@"_note"];
		[noteAttribute setStringValue:noteString resolvingEntities:YES];
// XXX not sure how to handle newlines in _note attribute. Is it valide to leave them, or must they be escaped with
// &#10. And if they must be escaped what's the proper way to do that? In anycase right now we have a bug. On reimport
// of an OPML file we lose all newlines in the _note.
		
//		if ([noteString rangeOfString:@"\n"].location != NSNotFound) {
//			NSMutableString *mutableNoteString = [[noteAttribute stringValue] mutableCopy];
//			[mutableNoteString replaceOccurrencesOfString:@"\n" withString:@"&#10;" options:0 range:NSMakeRange(0, [mutableNoteString length])];
//			[noteAttribute setStringValue:mutableNoteString resolvingEntities:YES];
//			[mutableNoteString release];
//		}

		[element addAttribute:noteAttribute];
		
		[noteAttribute release];
	}
	
	return element;
}

- (BOOL)exportEntries:(NSArray *)entries url:(NSURL *)url uti:(NSString *)type error:(NSError **)error {
	NSXMLDocument *opmlDocument = [[[NSXMLDocument alloc] init] autorelease];
	[opmlDocument setCharacterEncoding:@"UTF-8"];
	[opmlDocument setVersion:@"1.0"];
	[opmlDocument setStandalone:YES];
	[opmlDocument setDocumentContentKind:NSXMLDocumentXMLKind];

	NSXMLElement *opmlElement = [[[NSXMLElement alloc] initWithName:@"opml"] autorelease];
	[opmlElement addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"1.0"]];
	[opmlDocument setRootElement:opmlElement];

	NSXMLElement *headElement = [[[NSXMLElement alloc] initWithName:@"head"] autorelease];
	[headElement addChild:[NSXMLElement elementWithName:@"title" stringValue:[[url path] lastPathComponent]]];
	[opmlElement addChild:headElement];
	
	NSXMLElement *body = [[[NSXMLElement alloc] initWithName:@"body"] autorelease];
	[opmlElement addChild:body];
	
	NSEnumerator *enumerator = [entries objectEnumerator];
	id each;
	
	while (each = [enumerator nextObject]) {
		[body addChild:[self outlineElementForEntry:each]];
	}
	
	return [[opmlDocument XMLDataWithOptions:NSXMLNodeCompactEmptyElement | NSXMLNodePrettyPrint] writeToURL:url options:nil error:error];
}

@end
