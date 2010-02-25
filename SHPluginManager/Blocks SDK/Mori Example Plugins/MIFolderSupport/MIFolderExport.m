//
//  MIFolderExport.m
//  Mori
//
//  Created by Jesse Grosjean on 10/10/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "MIFolderExport.h"


@implementation MIFolderExport

- (NSArray *)supportedUTIs {
	return [NSArray arrayWithObjects:
		@"public.folder-public.plain-text", 
		@"public.folder-public.rtf",
		@"public.folder-com.apple.rtfd", 
		@"public.folder-public.html", 
		@"public.folder-com.microsoft.word.doc", 
		@"public.folder-com.microsoft.word.xml",
		@"public.folder-com.apple.webarchive",
		nil];
}

- (NSString *)descriptionForUTI:(NSString *)uti {
	if ([uti isEqualToString:@"public.folder-public.plain-text"]) {
		return BKLocalizedString(@"Plain Text (.txt)", @"");

	} else if ([uti isEqualToString:@"public.folder-public.rtf"]) {
		return BKLocalizedString(@"Rich Text Format (.rtf)", @"");
		
	} else if ([uti isEqualToString:@"public.folder-com.apple.rtfd"]) {
		return BKLocalizedString(@"Rich Text Format with Attachments (.rtfd)", @"");
	
	} else if ([uti isEqualToString:@"public.folder-public.html"]) {
		return BKLocalizedString(@"HTML Format (.html)", @"");
	
	} else if ([uti isEqualToString:@"public.folder-com.microsoft.word.doc"]) {
		return BKLocalizedString(@"Microsoft Word Format (.doc)", @"");
	
	} else if ([uti isEqualToString:@"public.folder-com.microsoft.word.xml"]) {
		return BKLocalizedString(@"Microsoft Word XML Format (.xml)", @"");
	
	} else if ([uti isEqualToString:@"public.folder-com.apple.webarchive"]) {
		return BKLocalizedString(@"Web Kit Format (.webarchive)", @"");
	}
	return nil;
}

- (BOOL)writeTextStorage:(NSTextStorage *)textStorage path:(NSString *)path documentAttributes:(NSMutableDictionary *)documentAttributes fileAttributes:(NSDictionary *)fileAttributes {
	BOOL result = NO;
	
	if ([[documentAttributes objectForKey:NSDocumentTypeDocumentAttribute] isEqualToString:NSRTFDTextDocumentType]) {
		NSFileWrapper *fileWrapper = [textStorage RTFDFileWrapperFromRange:NSMakeRange(0, [textStorage length]) documentAttributes:nil];
		result = [fileWrapper writeToFile:path atomically:NO updateFilenames:NO];
	} else {
		NSData *data = [textStorage dataFromRange:NSMakeRange(0, [textStorage length]) documentAttributes:documentAttributes error:nil];
		result = [data writeToFile:path atomically:NO];
	}
	
	if (result) {
		[[NSFileManager defaultManager] changeFileAttributes:fileAttributes atPath:path];
	}
	
	return result;
}

- (BOOL)exportEntry:(id <MIEntryProtocol>)entry url:(NSURL *)url documentAttributes:(NSMutableDictionary *)documentAttributes {
    NSFileManager *fileManager = [NSFileManager defaultManager];
	id <MIEntryDataProtocol> entryData = [entry entryData];
	NSString *pathExtension = [documentAttributes objectForKey:@"pathExtension"];
    NSString *title = [entryData title];
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[entryData creationDate], NSFileCreationDate, [entryData modificationDate], NSFileModificationDate, nil];
	NSString *exportPath = nil;
		
    if ([entry countOfOrderedChildren] == 0) {
		title = [title stringByAppendingPathExtension:pathExtension];
		exportPath = [fileManager uniqueFilePathForDirectory:[url path] preferedName:title];
		
		if (![self writeTextStorage:[entryData textStorage] path:exportPath documentAttributes:documentAttributes fileAttributes:fileAttributes]) {
			return NO;
		}
	} else {
		NSString *folderPath = [fileManager uniqueFilePathForDirectory:[url path] preferedName:title];

		if (![fileManager createDirectoryAtPath:folderPath attributes:fileAttributes]) 
			return NO;

		title = [title stringByAppendingPathExtension:pathExtension];
		exportPath = [fileManager uniqueFilePathForDirectory:folderPath preferedName:title];
		
		if (![self writeTextStorage:[entryData textStorage] path:exportPath documentAttributes:documentAttributes fileAttributes:fileAttributes]) {
			return NO;
		}
		
		NSEnumerator *enumerator = [entry childEnumerator:nil];
		id each;
		
		while ((each = [enumerator nextObject])) {
			if (![self exportEntry:each url:[NSURL fileURLWithPath:folderPath] documentAttributes:documentAttributes]) {
				return NO;
			}
		}
	}
	
    return YES;
}

- (BOOL)exportEntries:(NSArray *)entries url:(NSURL *)url uti:(NSString *)type error:(NSError **)error {
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSMutableDictionary *documentAttributes = [NSMutableDictionary dictionary];
		
	if ([type isEqualToString:@"public.folder-public.plain-text"]) {
		[documentAttributes setObject:NSPlainTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"txt" forKey:@"pathExtension"];
	} else if ([type isEqualToString:@"public.folder-public.rtf"]) {
		[documentAttributes setObject:NSRTFTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"rtf" forKey:@"pathExtension"];
	} else if ([type isEqualToString:@"public.folder-com.apple.rtfd"]) {
		[documentAttributes setObject:NSRTFDTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"rtfd" forKey:@"pathExtension"];
	} else if ([type isEqualToString:@"public.folder-public.html"]) {
		[documentAttributes setObject:NSHTMLTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"html" forKey:@"pathExtension"];
	} else if ([type isEqualToString:@"public.folder-com.microsoft.word.doc"]) {
		[documentAttributes setObject:NSDocFormatTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"doc" forKey:@"pathExtension"];
	} else if ([type isEqualToString:@"public.folder-com.microsoft.word.xml"]) {
		[documentAttributes setObject:NSWordMLTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"xml" forKey:@"pathExtension"];
	} else if ([type isEqualToString:@"public.folder-com.apple.webarchive"]) {
		[documentAttributes setObject:NSWebArchiveTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
		[documentAttributes setObject:@"webarchive" forKey:@"pathExtension"];
	}

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
    if ([fileManager fileExistsAtPath:[url path]]) {
		if (![fileManager removeFileAtPath:[url path] handler:nil]) {
			return NO;
		}
    }
    
    if (![fileManager createDirectoryAtPath:[url path] attributes:nil]) {
		return NO;
    }
	
    NSEnumerator *enumerator = [entries objectEnumerator];
    id each;
	
    while (each = [enumerator nextObject]) {
		if (![self exportEntry:each url:url documentAttributes:documentAttributes]) {
			return NO;
		}
	}
	
    [pool release];
    
    return YES;
}

@end
