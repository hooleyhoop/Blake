//
//  MITextFileImport.m
//  Mori
//
//  Created by Jesse Grosjean on 7/19/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "MITextFileImport.h"


@implementation MITextFileImport

- (NSArray *)supportedPathExtensions {
	return [NSAttributedString textFileTypes];
}

- (NSArray *)supportedUTIs {
	return [NSArray arrayWithObjects:@"public.plain-text", @"public.rtf", @"com.apple.rtfd", @"com.microsoft.word.doc", nil];
}

- (NSArray *)importURL:(NSURL *)url document:(id <MIDocumentProtocol>)document error:(NSError **)error {
	[[NSApp BKStatusMessageProtocols_statusMessageController] updateInformativeText:[url path]];
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:url options:nil documentAttributes:nil error:error];
	id <MIEntryProtocol> entry = [NSObject insertNewEntryInDocument:document withAttributesFromURL:url];
	id <MIEntryDataProtocol> entryData = [entry entryData];
	NSUndoManager *undoManager = [[document selfAsPersistentDocument] undoManager];
	NSUndoManager *textUndoManager = [entryData textStorageUndoManager];
	
	[undoManager disableUndoRegistration];
	[entryData setContentType:@"com.apple.rtfd"];
	[textUndoManager disableUndoRegistration];
	[entryData setTextStorageContent:attributedString];
	[textUndoManager enableUndoRegistration];
	[undoManager enableUndoRegistration];
	[attributedString release];
	
	return [NSArray arrayWithObject:entry];
}

@end
