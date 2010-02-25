//
//  MIFolderImport.m
//  Mori
//
//  Created by Jesse Grosjean on 8/28/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "MIFolderImport.h"


@implementation MIFolderImport

- (NSArray *)supportedPathExtensions {
	return [NSArray arrayWithObject:@"public.folder"];
}

- (NSArray *)supportedUTIs {
	return [NSArray arrayWithObject:@"public.folder"];
}

- (NSArray *)importURL:(NSURL *)directoryURL document:(id <MIDocumentProtocol>)document error:(NSError **)error {
	id <MIEntryProtocol> folderEntry = nil;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSUndoManager *undoManager = [[document selfAsPersistentDocument] undoManager];
	NSMutableArray *directoryContentPathURLs = [NSMutableArray array];
	NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath:[directoryURL path]];
	NSEnumerator *enumerator = [directoryContents objectEnumerator];
	id eachDirectoryPath;
	
	while (eachDirectoryPath = [enumerator nextObject]) {
		[directoryContentPathURLs addObject:[NSURL fileURLWithPath:[[directoryURL path] stringByAppendingPathComponent:eachDirectoryPath]]];
	}
	
	NSArray *importedChildren = [[NSObject sharedImportController] importURLs:directoryContentPathURLs document:document error:error];
	
	if ([importedChildren count]) {
		folderEntry = [NSObject insertNewEntryInDocument:document withAttributesFromURL:directoryURL];
		[undoManager disableUndoRegistration];
		[[folderEntry entryData] setContentType:@"public.folder"];
		[folderEntry addChildren:[NSSet setWithArray:importedChildren]];
		[undoManager enableUndoRegistration];
	}
	
	[pool release];

	if (folderEntry) {
		return [NSArray arrayWithObject:folderEntry];
	} else {
		return [NSArray array];
	}
}

@end
