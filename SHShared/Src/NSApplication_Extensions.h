//
//  NSApplication_Extensions.h
//  SHShared
//
//  Created by steve hooley on 12/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <Appkit/NSApplication.h>


@interface NSApplication (NSApplication_Extensions)

- (NSArray *)openDocs;
- (NSWindow *)myMainWindow;

- (void)setAboutPanelClass:(Class)aClass;


- (BOOL)altKeyDown;

/* For unitTests */
- (void)oneShotOverideAltKeyDown;

@end
