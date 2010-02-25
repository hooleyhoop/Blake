//
//  MIHBN35Import.m
//  Mori
//
//  Created by Jesse Grosjean on 7/19/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "MIHBN35Import.h"


@interface MIHBN35Import (MIPrivate)

- (id <MIEntryProtocol>)loadRecursivePlistRepresentation:(NSDictionary *)nodePlist parent:(id <MIEntryProtocol>)parent loadedEntryDatas:(NSMutableDictionary *)loadedEntryDatas oldIDsToNewIDs:(NSMutableDictionary *)oldIDsToNewIDs importFile:(NSString *)importFile document:(id <MIDocumentProtocol>)document;
- (id <MIEntryDataProtocol>)loadEntryDataForID:(NSNumber *)entryDataID importFile:(NSString *)importFile document:(id <MIDocumentProtocol>)document;
	
@end

@implementation MIHBN35Import

- (NSArray *)supportedPathExtensions {
	return [NSArray arrayWithObject:@"hbnk35"];
}

- (NSArray *)supportedUTIs {
	NSString *uti = (NSString *) UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, CFSTR("hbnk35"), nil);
	return [NSArray arrayWithObject:[uti autorelease]];
}

- (NSArray *)importURL:(NSURL *)url document:(id <MIDocumentProtocol>)document error:(NSError **)error {
	NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[url path] stringByAppendingPathComponent:@"uk.co.Hooley.notebook.index.plist"]];
	NSDictionary *rootPlist = [plist objectForKey:@"nodes"];
	NSMutableDictionary *loadedEntryDatas = [NSMutableDictionary dictionary];
	NSMutableDictionary *oldIDsToNewIDs = [NSMutableDictionary dictionary];
	NSMutableArray *loadedEntries = [NSMutableArray array];
	
	userDefinedColumnKeys = [[NSMutableDictionary alloc] init];

	NSEnumerator *attributeEnumerator = [[plist objectForKey:@"attributes"] objectEnumerator];
	NSDictionary *each;
	
	while (each = [attributeEnumerator nextObject]) {
		if ([[each valueForKey:@"deletable"] boolValue]) { // just user defined columns
			id attributeDescription = [NSObject insertNewAttributeDescriptionInDocument:document key:[each valueForKey:@"key"] dataType:NSStringAttributeType summaryType:MIAttributeNoneSummaryType isUserDefined:YES error:nil];
			if (attributeDescription) {
				[userDefinedColumnKeys setObject:attributeDescription forKey:[each valueForKey:@"key"]];
			}
		}
	}
	
	[loadedEntries addObject:[self loadRecursivePlistRepresentation:rootPlist parent:nil loadedEntryDatas:loadedEntryDatas oldIDsToNewIDs:oldIDsToNewIDs importFile:[url path] document:document]];
		
//	NSEnumerator *entryDataEnumerator = [loadedEntryDatas objectEnumerator];
//	id <MIEntryDataProtocol>eachEntryData;
//	
//	while (eachEntryData = [entryDataEnumerator nextObject]) {
//		[eachEntryData awakeFromCopy:oldIDsToNewIDs];
//	}
	
	[userDefinedColumnKeys release];
	userDefinedColumnKeys = nil;
	
	return loadedEntries;
}

- (id <MIEntryProtocol>)loadRecursivePlistRepresentation:(NSDictionary *)nodePlist parent:(id <MIEntryProtocol>)parent loadedEntryDatas:(NSMutableDictionary *)loadedEntryDatas oldIDsToNewIDs:(NSMutableDictionary *)oldIDsToNewIDs importFile:(NSString *)importFile document:(id <MIDocumentProtocol>)document {
	NSNumber *oldEntryID = [nodePlist objectForKey:@"id"];
	NSNumber *oldEntryDataID = [nodePlist objectForKey:@"sharedNodeData"];

	id <MIEntryDataProtocol>entryData = [loadedEntryDatas objectForKey:oldEntryDataID];
	
	if (!entryData) {
		entryData = [self loadEntryDataForID:oldEntryDataID importFile:importFile document:document];
		[loadedEntryDatas setObject:entryData forKey:oldEntryDataID];
		[oldIDsToNewIDs setObject:[[[[entryData selfAsManagedObject] objectID] URIRepresentation] absoluteString] forKey:oldEntryDataID];
	}

	id <MIEntryProtocol>entry = [NSObject insertNewEntryInDocument:document withEntryData:entryData];
	[oldIDsToNewIDs setObject:[[[[entry selfAsManagedObject] objectID] URIRepresentation] absoluteString] forKey:oldEntryID];
	NSArray *orderedChildrenPlist = [nodePlist objectForKey:@"subnodes"];

	if (!parent) {
		[[entry entryData] setContentType:@"public.folder"];
	} else if ([[[parent entryData] contentType] isEqualToString:@"com.apple.rtfd"]) {
		[[entry entryData] setContentType:@"com.apple.rtfd"];
	}
	
	if (orderedChildrenPlist) {
		NSMutableArray *orderedChildren = [NSMutableArray arrayWithCapacity:[orderedChildrenPlist count]];
		NSEnumerator *enumerator = [orderedChildrenPlist objectEnumerator];
		NSDictionary *eachChildPlist;
		id <MIEntryProtocol>eachChild;
		
		while (eachChildPlist = [enumerator nextObject]) {
			eachChild = [self loadRecursivePlistRepresentation:eachChildPlist parent:entry loadedEntryDatas:loadedEntryDatas oldIDsToNewIDs:oldIDsToNewIDs importFile:importFile document:document];
			[orderedChildren addObject:eachChild];
		}

		[entry privateInsertOrderedChildren:orderedChildren indexes:nil]; // so that no aliased entries are created since we are handling that manually.
	}
		
	return entry;
}

- (id <MIEntryDataProtocol>)loadEntryDataForID:(NSNumber *)entryDataID importFile:(NSString *)importFile document:(id <MIDocumentProtocol>)document {
	NSUndoManager *undoManager = [[document selfAsPersistentDocument] undoManager];
	id <MIEntryDataProtocol>entryData = [NSEntityDescription insertNewObjectForEntityForName:@"EntryData" inManagedObjectContext:[[document selfAsPersistentDocument] managedObjectContext]];
	NSString *sharedNodeDataPlistFile = [NSString stringWithFormat:@"%@/uk.co.Hooley.notebook.resources/%i/properties.plist", importFile, [entryDataID intValue], nil];
	NSString *sharedNodeDataNoteFile = [NSString stringWithFormat:@"%@/uk.co.Hooley.notebook.resources/%i/note.rtfd", importFile, [entryDataID intValue], nil];
	
	// attributes
	NSDictionary *sharedNodeDataPlist = [[NSDictionary alloc] initWithContentsOfFile:sharedNodeDataPlistFile];
	NSDictionary *sharedNodeDataAttributesPlist = [sharedNodeDataPlist objectForKey:@"attributes"];

	[undoManager disableUndoRegistration];
	
	if ([sharedNodeDataAttributesPlist objectForKey:@"folder"]) {
		[entryData setContentType:@"public.folder"];
	} else {
		[entryData setContentType:@"com.apple.rtfd"];
	}
	
	[entryData setTitle:[sharedNodeDataAttributesPlist objectForKey:@"name"]];
	[entryData setCreationDate:[sharedNodeDataAttributesPlist objectForKey:@"created"]];
	[entryData setState:[sharedNodeDataAttributesPlist objectForKey:@"status"]];
	[entryData setStarRating:[sharedNodeDataAttributesPlist objectForKey:@"rating"]];
	[entryData setLabel:[sharedNodeDataAttributesPlist objectForKey:@"label"]];
	
	// note
	NSAttributedString *note = [[NSAttributedString alloc] initWithURL:[NSURL fileURLWithPath:sharedNodeDataNoteFile] documentAttributes:nil];
	
	if (note) {
		[[entryData textStorageUndoManager] disableUndoRegistration];
		[entryData setTextStorageContent:note];
		[[entryData textStorageUndoManager] enableUndoRegistration];
		[note release];
	}
	
	NSEnumerator *enumerator = [userDefinedColumnKeys keyEnumerator];
	NSString *each;
	
	while (each = [enumerator nextObject]) {
		NSString *value = [sharedNodeDataAttributesPlist objectForKey:each];
		if (value) {
			[entryData setValue:value forAttributeDescription:[userDefinedColumnKeys objectForKey:each]];
		}
	}
	
	// set modification date last
	[entryData setModificationDate:[sharedNodeDataAttributesPlist objectForKey:@"modified"]];
	
	[undoManager enableUndoRegistration];
		
	[sharedNodeDataPlist release];
		
	return entryData;
}

@end
