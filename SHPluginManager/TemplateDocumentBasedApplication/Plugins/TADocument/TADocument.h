//
//  TADocument.h
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 12/6/04.
//  Copyright Hog Bay Software 2004 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKDocumentsProtocols.h"
#import "TADocumentProtocols.h"


@interface TADocument : NSPersistentDocument <TADocumentProtocol> {
}

@end