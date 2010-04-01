//
//  SKTGraphicViewModel.h
//  BlakeLoader
//
//  Created by steve hooley on 19/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//


#import <SketchGraph/SHContentProviderUserProtocol.h>

@class BlakeDocument, SHNodeGraphModel, SKTGraphicsProvidor;

@interface SKTGraphicViewModel : SHooleyObject <SHContentProviderUserProtocol> {

	SHNodeGraphModel				*_sketchModel;
    SKTGraphicsProvidor				*_filter;

    // The grid that is drawn in the view and used to constrain graphics as they're created and moved. 
	// In Sketch this is just a cache of a value that canonically lives in the SKTWindowController to 
	// which this view's grid property is bound 
	// (see SKTWindowController's comments for an explanation of why the grid lives there).

    BOOL							_isInUse, _sketchModelDidChange, _isSetup;
    int								_changeCount;

	/* Apart from a few stinking problems with KVO we dont need this storage, (we just need the notifications that the graphics property has changed) the problems remain, however… */
	// Actually, this can probably be our Scene / Octree -- it is not just a list of graphics as come from the filter - we swap in and out decorators
	NSMutableArray					*_sktSceneItems;
	NSMutableIndexSet				*_sktSceneSelectionIndexes;
}

// -- im guessing we dont want to retain the sketchmodel
@property (readwrite, assign, nonatomic) SHNodeGraphModel *sketchModel;
@property (readwrite, assign, nonatomic) SKTGraphicsProvidor *filter;

- (void)setUpSketchViewModel;
- (void)cleanUpSketchViewModel;

- (void)changeSktSceneSelectionIndexes:(NSIndexSet *)indexes;
- (NSArray *)selectedSktSceneItems;

- (NSMutableArray *)sktSceneItems;

- (NSMutableIndexSet *)sktSceneSelectionIndexes;

#pragma mark -- indexed accessors
- (unsigned int)countOfSktSceneItems;
- (id)objectInSktSceneItemsAtIndex:(unsigned int)index;

@end
