//
//  NSDocumentController_Extensions.h
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//
#import <Appkit/NSDocument.h>
#import <Appkit/NSDocumentController.h>


@interface NSDocumentController (NSDocumentController_Extensions)

#pragma mark action plugins
- (void)tryToCloseDoc:(NSDocument *)aDoc;
- (void)closeAll;

#pragma mark accessor plugins
- (NSDocument *)frontDocument;

@end
