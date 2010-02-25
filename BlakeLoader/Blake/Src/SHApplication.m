//
//  SHApplication.m
//  Blake
//
//  Created by Steve Hooley on 22/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHApplication.h"
#import <objc/message.h>

/*
 * Be Careful not to overide NSApplications initialization routines - 
*/
@implementation SHApplication

#pragma mark -
- (void)dealloc {

	[super dealloc];
}

- (NSUndoManager *)undoManager {
	
	NSException *ex = [NSException exceptionWithName:@"Just checking that we never get here.." reason:@"we should always use document's undoManager" userInfo:nil];
	@throw ex;
	return nil;
}

- (void)orderFrontStandardAboutPanel:(id)sender {

	if(_aboutPanelClass){
		id abController = [_aboutPanelClass performSelector:@selector(sharedBlakeAboutBoxController)];
		objc_msgSend( abController, @selector(show));
	} else {
		[super orderFrontStandardAboutPanel: sender];
	}
}

- (void)setAboutPanelClass:(Class)aClass {

	_aboutPanelClass = aClass;
}

@end
