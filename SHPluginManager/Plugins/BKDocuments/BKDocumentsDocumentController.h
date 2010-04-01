//
//  BKDocumentsDocumentController.h
//  Blocks
//
//  Created by Jesse Grosjean on 5/31/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKDocumentsProtocols.h"


@interface BKDocumentsDocumentController : NSDocumentController {

}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark loading plugins

- (NSArray *)documentTypeExtensions;
- (id <BKDocumentTypeProtocol>)documentTypeExtensionSupportingType:(NSString *)typeName;

@end
