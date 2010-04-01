//
//  SKTGraphicViewController.h
//  BlakeLoader
//
//  Created by steve hooley on 12/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

@class SKTGraphicView, SKTGraphicViewModel, SKTGraphicsProvidor, SKTGraphic, SKTWindowController, SKTTool;
@class BlakeDocument, SHTableView;
@class SKTDragReorderArrayController;

@interface SKTGraphicViewController : SHooleyObject {

@public
	
    BlakeDocument									*_document;
	SKTGraphicViewModel                             *_sketchViewModel;
	IBOutlet SKTGraphicView                         *_sketchView;
	IBOutlet SHTableView							*_sketchLayerTable;
	IBOutlet SKTDragReorderArrayController			*_debugTableArrayController;
	BOOL											_isSetup;
}
@property (assign, nonatomic) BlakeDocument         *document;
@property (assign, nonatomic) SKTDragReorderArrayController    *debugTableArrayController;
@property (assign, nonatomic) SHTableView			*sketchLayerTable;
@property (assign, nonatomic) SKTGraphicView		*sketchView;
@property (retain, nonatomic) SKTGraphicViewModel   *sketchViewModel;

- (void)setUpGraphicViewController;
- (void)unSetupViewController;

- (void)mouseDownInSketchView:(NSEvent *)event;

- (void)groupSelection;
- (void)ungroupSelection;

- (void)addGraphic:(SKTGraphic *)aGraphic atIndex:(NSUInteger)index;
- (void)removeGraphicsAtIndexes:(NSIndexSet *)indexes;

//- (SKTGraphicViewModel *)sktSceneItems;
//- (NSIndexSet *)sktSceneSelectionIndexes;
//- (void)changeSktSceneSelectionIndexes:(NSIndexSet *)indexes;
//- (NSArray *)selectedSktSceneItems;

//- (NSUInteger)arrangedContentCount;
//- (id)objectInArrangedContentAtIndex:(NSUInteger)index;

- (SKTTool *)activeTool;

@end
