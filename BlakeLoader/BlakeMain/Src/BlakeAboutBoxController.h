//
//  BlakeAboutBoxController.h
//  BlakeLoader
//
//  Created by steve hooley on 26/02/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

@class BBNibManager;

@interface BlakeAboutBoxController : _ROOT_OBJECT_ {

	BBNibManager		*nibManager;
	IBOutlet NSWindow	*aboutPanel;
}


+ (id)sharedBlakeAboutBoxController;
+ (void)disposeSharedAboutBoxController;

- (void)show;

@property (retain, nonatomic) BBNibManager *nibManager;
@property (assign, nonatomic) NSWindow *aboutPanel;

@end
