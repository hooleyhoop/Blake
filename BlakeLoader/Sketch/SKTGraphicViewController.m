//
//  SKTGraphicViewController.m
//  BlakeLoader
//
//  Created by steve hooley on 12/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTGraphicViewController.h"
#import "BlakeDocument.h"
#import "SKTToolPaletteController.h"
#import "SKTTool.h"
#import "SKTGraphicViewModel.h"
#import "SKTGraphicView.h"
#import "SKTWindowController.h"
#import "SKTDragReorderArrayController.h"
#import "SKTUserAdaptor.h"
#import "SKT_NodeGraphModel.h"



@implementation SKTGraphicViewController

@synthesize sketchViewModel=_sketchViewModel;
@synthesize document=_document;
@synthesize debugTableArrayController = _debugTableArrayController;
@synthesize sketchLayerTable = _sketchLayerTable;
@synthesize sketchView = _sketchView;

#pragma mark -
#pragma mark init methods
- (id)init {
	
    if ((self = [super init]) != nil)
    {
		SKTGraphicViewModel *vm = [[[SKTGraphicViewModel alloc] init] autorelease];
		[vm setUpSketchViewModel];
		self.sketchViewModel = vm;
        _isSetup = NO;
    }
	return self;
}

- (void)dealloc {

	self.sketchViewModel = nil;
	
	[super dealloc];
}


#pragma mark -
#pragma mark tested methods
- (void)setDocument:(BlakeDocument *)value {
    
	if(_isSetup==NO)
		[self setUpGraphicViewController];
	NSAssert(_isSetup, @"Surely it is impossible that graphic view controller isn't seup at this point");
    _document = value;
    if(_document!=nil)
        if([_document nodeGraphModel]==nil){
            NSException *ex = [NSException exceptionWithName:@"Should not get here? why is model fucked?" reason:@"should not get here - document without a model" userInfo:nil];
            @throw ex;
        }
    [_sketchViewModel setSketchModel: [_document nodeGraphModel]];
}

#pragma mark -
#pragma mark untested methods
- (void)awakeFromNib {
	
	NSAssert( _sketchView!=nil, @"Nib unarchived incorrectly");
	NSAssert( _sketchLayerTable!=nil, @"Nib unarchived incorrectly");
	NSAssert( _debugTableArrayController!=nil, @"Nib unarchived incorrectly");
}

- (void)setUpGraphicViewController {
	
	NSAssert( _isSetup==NO, @"already setup");
	NSAssert(_sketchViewModel!=nil, @"model cannot be nil at this point");
	NSAssert(_sketchView!=nil, @"sketchview cannot be nil at this point");

	[_sketchViewModel addObserver:_sketchView forKeyPath:@"sktSceneItems" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewController"];
	[_sketchViewModel addObserver:_sketchView forKeyPath:@"sktSceneSelectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewController"];
	
	
/* Now setting up the binding in the nib */
//	NSString *graphicsKeyPath = @"graphics";
//	NSDictionary *opts = [NSDictionary dictionaryWithObjectsAndKeys:
//			[NSNumber numberWithBool:YES],
//			NSRaisesForNotApplicableKeysBindingOption,
//			@"NULL",
//			NSNullPlaceholderBindingOption,
//			@"NOT APPLICABLE",
//			NSNotApplicablePlaceholderBindingOption,
//			nil];
//	[_debugTableArrayController bind:NSContentArrayBinding toObject:_sketchViewModel withKeyPath: graphics options:opts];

    _isSetup = YES;
}

/* Err.. if you never set a document then this will never get called either, causing leaks - beware in tests */
- (void)unSetupViewController {
	
	NSAssert( _isSetup==YES, @"we didnt setup first");
	
	/* It is vitally important that we kill the arrayController properly */
	// unhook the arraycontroller here..
//JOOST	[_debugTableArrayController unbind:NSContentArrayBinding];
//JOOST	[_debugTableArrayController unbind:@"selectionIndexes"];
	
//JOOST	[_sketchLayerTable setDelegate:nil];
//JOOST	[_sketchLayerTable setDataSource:nil];

//	[_sketchLayerTable unbind:NSContentArrayBinding]; wha?
	
 //JOOST   [_sketchLayerTable removeFromSuperview];
    
	[_sketchView stopObservingGraphics:[ _sketchViewModel sktSceneItems]];
	
	[_sketchViewModel removeObserver:_sketchView forKeyPath:@"sktSceneItems"];
	[_sketchViewModel removeObserver:_sketchView forKeyPath:@"sktSceneSelectionIndexes"];
	
    [_sketchViewModel cleanUpSketchViewModel];

	_isSetup=NO;
}

- (SKTTool *)activeTool {
	
	SKTToolPaletteController *tpc = ((SKTWindowController *)([[_sketchView window] windowController])).sketchToolPaletteConroller;
	NSAssert(tpc!=nil, @"must have a tool palette conrtoller");
	SKTTool *activeTool = [tpc activeTool];
	NSAssert(activeTool!=nil, @"must have an active tool");
	return activeTool;
}

- (void)mouseDownInSketchView:(NSEvent *)event {
}

- (void)groupSelection {
	[_sketchViewModel.sketchModel skt_groupSelection];
}

- (void)ungroupSelection {
	[_sketchViewModel.sketchModel skt_ungroupSelection];
}

- (void)addGraphic:(SKTGraphic *)aGraphic atIndex:(NSUInteger)index {
	
	[_sketchViewModel.sketchModel insertGraphic:aGraphic atIndex:index];
}

- (void)removeGraphicsAtIndexes:(NSIndexSet *)indexes {

	NSAssert( [[_sketchViewModel sktSceneSelectionIndexes] count]==0, @"Play the game, deselect first");
    [_sketchViewModel.sketchModel removeGraphicsAtIndexes:indexes];
}

/* This is the key method for the view */
//- (SKTGraphicViewModel *)graphics {
//	return _sketchViewModel;
//}

//- (NSUInteger)arrangedContentCount {
//	return [_sketchViewModel countOfSktSceneItems];
//}

//- (NSIndexSet *)sktSceneSelectionIndexes {
//	return [_sketchViewModel sktSceneSelectionIndexes];
//}

//- (void)changeSktSceneSelectionIndexes:(NSIndexSet *)indexes {
//	[_sketchViewModel changeSktSceneSelectionIndexes:indexes];
//}

//- (NSArray *)selectedSktSceneItems {
//	return [_sketchViewModel selectedSktSceneItems];
//}

//- (id)objectInArrangedContentAtIndex:(NSUInteger)index {
//	return [_sketchViewModel objectInSktSceneItemsAtIndex: index];
//}

@end
