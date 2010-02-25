//
//  MIFolderExport.h
//  Mori
//
//  Created by Jesse Grosjean on 10/10/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "MIDocumentProtocols.h"


@interface MIFolderExport : NSObject <MIEntryExportProtocol> {

}

- (NSArray *)supportedUTIs;
- (BOOL)exportEntries:(NSArray *)entries url:(NSURL *)url uti:(NSString *)type error:(NSError **)error;

@end
