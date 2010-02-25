//
//  EditingWindowController.m
//  DebugDrawing
//
//  Created by shooley on 13/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "EditingWindowController.h"
#import "EditingViewController.h"
#import "CALayerStarView.h"
#import "ToolBarController.h"
#import "DomainContext.h"
#import "ZoomPopupController.h"

@implementation EditingWindowController

@synthesize editingView=_editingView;
@synthesize toolBarController=_toolBarController;
@synthesize editingViewController=_editingViewController;

#pragma mark -
#pragma mark class methods
+ (NSString *)nibName {
	return @"SketchNib";
}

#pragma mark init methods
- (id)initWithWindowNibName:(NSString *)windowNibName {

	self = [super initWithWindowNibName:windowNibName];
	if(self){
		NSLog(@"created window controller");
	}
	return self;
}

//TODO: is this ever called?
- (void)dealloc {
	
	[_editingViewController removeZoomValueObserver:_zoomPopupCntrlr];
	[_zoomPopupCntrlr release];
	
	[_editingViewController release];
	
	[_toolBarController cleanUp]; 
	[_toolBarController release];

	[super dealloc];
}

// Window Controller should be automatically insrted into the responder chain
- (void)windowDidLoad {
	
	NSAssert( _editingViewController==nil, @"called twice?");
	[super windowDidLoad];
	
	// This is all bodged because we dont have a document and the nibs are wrong
	_editingViewController = [[EditingViewController alloc] init];
	[_editingViewController setView:_editingView];
	[_editingView setViewController:_editingViewController];
}

- (void)windowWillClose:(NSNotification *)notification {

	NSLog(@"hmm");
}
	

- (void)windowDidBecomeMain:(NSNotification *)notification {

	NSLog(@"hmm");
}

- (void)addToolBar {
		
	NSAssert( _toolBarController==nil, @"hmm");
	NSAssert( _editingViewController!=nil, @"we need a editingViewController at this point");

	_toolBarController = [[ToolBarController alloc] initWithWindow:self.window targetViewController:_editingViewController]; 	
	[_editingViewController setInputController:_toolBarController];
}

- (void)addToolsToToolBar:(NSArray *)someTools {
	
	NSParameterAssert(someTools);
	NSAssert(_toolBarController, @"no _toolBarController!");

	[_toolBarController addTools:someTools];
}

- (void)setDomainContext:(DomainContext *)cntx {
	
	NSAssert( _editingViewController!=nil, @"hmm");
	[_editingViewController setupWithDomainContext:cntx];
}

- (DomainContext *)domainContext {

	NSAssert( _editingViewController!=nil, @"hmm");
	return [_editingViewController domainContext];
}

- (void)doZoomPopUp:(NSPopUpButton *)value {

	//-- observe zoom value / keep in sync
	_zoomPopupCntrlr = [[ZoomPopupController alloc] initWithButton:value];
	
	NSAssert( _editingViewController!=nil, @"hmm");
	[_editingViewController observeZoomValue:_zoomPopupCntrlr withContext:@"ZoomPopupController"];
}

- (IBAction)homeView:(id)sender {

	[_editingViewController resetZoomSettings];
}

- (IBAction)setZoomToListValue:(id)sender {
	
	//-- set zoom
	//is it fit all?
	if([sender indexOfSelectedItem]<2) {
		[_editingViewController fitAll];
	
	} else {
		CGFloat zoomValue = [_zoomPopupCntrlr valueForLabel:[sender titleOfSelectedItem]];
		_zoomPopupCntrlr.disabledObservations = YES;
		[_editingViewController setZoomValue:zoomValue];
		_zoomPopupCntrlr.disabledObservations = NO;
	}
}
@end
