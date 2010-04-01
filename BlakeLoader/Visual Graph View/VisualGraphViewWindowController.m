//
//  VisualGraphViewWindowController.m
//  BlakeLoader2
//
//  Created by steve hooley on 04/12/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "VisualGraphViewWindowController.h"

@implementation VisualGraphViewWindowController

+ (NSString *)nibName {
	return @"GraphViewMainWindow";
}

- (void)initBindings {
	
	// This can easily be called twice so its best to protect
	if(!_isBound) {
//		NSAssert(_outlineView1ViewController!=nil, @"eek");
//		[_outlineView1ViewController setupOutlineView1];
		_isBound = YES;
	}
}

- (void)unBind {
	
	if(_isBound) {
//		NSAssert(_outlineView1ViewController!=nil, @"eek");
//		NSAssert([self document]!=nil, @"eek");
//		[_outlineView1ViewController tearDownOutlineView1];
		_isBound = NO;
	}
}

- (void)setDocument:(NSDocument *)document {
	
	if (!document) {
		[self unBind];
    }
	[super setDocument:document];
}

- (void)windowDidLoad
{
	// Make table view controller
	// add views to the left side of the split view
//	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
//	_outlineView1ViewController = [[OutlineView1Controller alloc] initWithNibName:@"OutlineView" bundle:thisBundle];
//	_outlineView1ViewController.docWindowController = self;
//	
//	// get the left view from the split view
//	NSView * aSplitViewLeftView = [[oMainSplitView subviews] objectAtIndex:0];
//	// get the table view from its view controller
//	NSView * aTableView = [_outlineView1ViewController view];
//	// position the table view
//	[aTableView setFrame:[aSplitViewLeftView bounds]];
//	// set its autoresizing mask
//	[aTableView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
//	// add table view to the left subview of the split view
//	[aSplitViewLeftView addSubview:aTableView];
//	
//	// Make detail view controller
//	// add views to the right side of the split view
//	mDetailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:thisBundle];
//	mDetailViewController.docWindowController = self;
//	
//	// get the left view from the split view
//	NSView * aSplitViewRightView = [[oMainSplitView subviews] objectAtIndex:1];
//	// get the table view from its view controller
//	NSView * aDetailView = [mDetailViewController view];
//	// position the table view
//	[aDetailView setFrame:[aSplitViewRightView bounds]];
//	// set its autoresizing mask
//	[aDetailView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
//	// add table view to the left subview of the split view
//	[aSplitViewRightView addSubview:aDetailView];
//	
//	// patch the detail view into the responder chain
//	NSResponder * aNextResponder = [self nextResponder];
//	[self setNextResponder:mDetailViewController];
//	[mDetailViewController setNextResponder:aNextResponder];
//	
//	
//	// Note: the controller is being added to the chain after the window controller
//	// to see the difference in behavior between this approach and adding the controller
//	// into the chain after its view, comment out the block of code above and uncomment the following:
//	
//	/*
//	 NSResponder * aNextResponder = [aDetailView nextResponder];
//	 [aDetailView setNextResponder:mDetailViewController];
//	 [mDetailViewController setNextResponder:aNextResponder];
//	 */
//	
//	[self initBindings];
}


- (void)dealloc
{
//	[_outlineView1ViewController release];
//	[mDetailViewController release];
	[super dealloc];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
	return [NSString stringWithFormat:@"%@ - TreeView", displayName];
}

@end
