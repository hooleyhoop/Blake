//
//  BlakeAboutBoxController.m
//  BlakeLoader
//
//  Created by steve hooley on 26/02/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "BlakeAboutBoxController.h"

static BlakeAboutBoxController *sharedBlakeAboutBoxController;

@implementation BlakeAboutBoxController

+ (id)sharedBlakeAboutBoxController {

	if(sharedBlakeAboutBoxController==nil)
		sharedBlakeAboutBoxController = [[BlakeAboutBoxController alloc] init];
	return sharedBlakeAboutBoxController;
}

+ (void)disposeSharedAboutBoxController {
	
	[sharedBlakeAboutBoxController release];
	sharedBlakeAboutBoxController = nil;
}

- (id)init {

	if( (self = [super init])!=nil ) {
		aboutPanel = nil;
	}
    return self;	
}

- (void)dealloc {
	/* er, this wont get called with this dodgy singleton stuff as it is */
	self.nibManager = nil;
    [super dealloc];
}

/* awake from nib is called on the file's owner! */
- (void)awakeFromNib {

	[aboutPanel setAlphaValue:0.0f];
	[aboutPanel update];
	[aboutPanel makeKeyAndOrderFront:self];
	[aboutPanel center];
	[aboutPanel setAlphaValue:1.0f];
}

- (void)show {
	if(aboutPanel==nil)
		self.nibManager = [BBNibManager instantiateNib:@"BlakeAboutBox" withOwner:self];
	NSAssert(aboutPanel!=nil, @"aboutPanel");
}

@synthesize nibManager, aboutPanel;

@end
