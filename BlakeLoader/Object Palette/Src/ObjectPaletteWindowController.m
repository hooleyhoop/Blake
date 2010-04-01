//
//  ObjectPaletteWindowController.m
//  BlakeLoader2
//
//  Created by steve hooley on 26/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "ObjectPaletteWindowController.h"
#import "ObjectBrowserViewController.h"


@implementation ObjectPaletteWindowController

+ (NSString *)nibName {
	return @"ObjectBrowserWindow";
}

- (void)dealloc {

	[self unBind];
	[_browserViewController release];
	[super dealloc];
}

- (void)initBindings {
	
	// This can easily be called twice so its best to protect
	if(!_isBound) {
		NSAssert(_browserViewController!=nil, @"eek");
		[_browserViewController setupViews];
		_isBound = YES;
	}
}

- (void)unBind {
	
	if(_isBound) {
		NSAssert(_browserViewController!=nil, @"eek");
		[_browserViewController tearDownViews];
		_isBound = NO;
	}
}

- (void)windowDidLoad {

	// Make table view controller
	// add views to the left side of the split view
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	_browserViewController = [[ObjectBrowserViewController alloc] initWithNibName:@"BrowserView" bundle:thisBundle];

	NSView *browserView = _browserViewController.view;
	NSAssert(browserView!=nil, @"wha? where is browserView?");
	NSAssert(_contentView!=nil, @"wha? where is contentView?");
	
	/* Er, this is a real NSBrowser bug - it cannot touch the side of the window! */
	[browserView setFrame: NSInsetRect([_contentView bounds], 3, 3)];
	[browserView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[_contentView addSubview:browserView];

	// patch the detail view into the responder chain
//TODO:	use insert above from shared

	NSResponder * aNextResponder = [self nextResponder];
	[self setNextResponder:_browserViewController];
	[_browserViewController setNextResponder:aNextResponder];

	[self initBindings];
}



@end
