//
//  MIHBN35Import.h
//  Mori
//
//  Created by Jesse Grosjean on 7/19/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MIDocumentProtocols.h"


@interface MIHBN35Import : NSObject <MIEntryImportProtocol> {
	NSMutableDictionary *userDefinedColumnKeys;
}

@end
