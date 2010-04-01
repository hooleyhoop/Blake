//
//  SceneDisplay.m
//  DebugDrawing
//
//  Created by steve hooley on 23/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SceneDisplay.h"
#import "StarScene.h"
#import "CALayerStarView.h"
#import "AbstractLayer.h"
#import "StarLayer.h"
#import "ContentLayerManager.h"
#import "ColourUtilities.h"
#import "LayerTreeManipulation.h"
#import "GraphLayersController.h"
#import "SelectedLayersController.h"


@interface SceneDisplay (privateMethods)
- (void)_buildInitiallayerGraphFromScene;
- (void)removeAllLayers;
@end


@implementation SceneDisplay

@synthesize starScene=_starScene;
@synthesize targetView=_targetView;
@synthesize contentLayerManager=_contentLayerManager;

// TODO: -- this seesms wrong! Too many null layers
//-- viewLayer
//-- -- content container layer
//-- -- -- rootNode layer
//-- -- -- -- Graphic1 layer
//-- -- -- -- Graphic2 layer
//-- -- -- -- Graphic3 layer
//-- -- -- -- Node1 layer
//-- -- -- -- -- Graphic4 layer
//--
//-- -- select container layer
//-- -- -- selectd1
//-- -- -- selectd2
//-- -- tool container layer
//-- -- -- current tool layer
- (id)initWithContentLayerManager:(ContentLayerManager *)value1 selectedContentLayerManager:(ContentLayerManager *)value2 layerTreeManipulator:(LayerTreeManipulation *)value4 {

	self = [super init];
	if(self){

	    /* all graphics are drawn into contentLayer */
		_contentLayerManager = [value1 retain];
		_selectedContentManager = [value2 retain];
		_layerManipulator = [value4 retain];
		
		_graphLayersController = [[GraphLayersController alloc] initWithContentManager:_contentLayerManager manipulator:_layerManipulator];
		_selectedLayersController = [[SelectedLayersController alloc] initWithContentManager:_selectedContentManager manipulator:_layerManipulator];
	}
	return self;
}

- (void)dealloc {

	[_graphLayersController release];
	[_selectedLayersController release];
	
	[_contentLayerManager release];
	[_selectedContentManager release];
	[_layerManipulator release];
	_starScene = nil;
	[super dealloc];
}

// ! One shot at the moment
- (void)setStarScene:(StarScene *)value {

	NSAssert( ((_starScene==nil) && (value!=nil)) || ((_starScene!=nil) && (value==nil)), @"fuck up - invalid starScene");

    if( value!=nil ){
		_starScene = value;

		// add all the layers
		[self _buildInitiallayerGraphFromScene];

		// keep in sync
		[_starScene addObserver:self forKeyPath:@"currentProxy" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
		[_starScene addObserver:self forKeyPath:@"currentFilteredContent" options:NSKeyValueObservingOptionOld context:@"SceneDisplay"];
		[_starScene addObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes" options:0 context:@"SceneDisplay"];
    } else {
		[_starScene removeObserver:self forKeyPath:@"currentProxy"];
		[_starScene removeObserver:self forKeyPath:@"currentFilteredContent"];
		[_starScene removeObserver:self forKeyPath:@"currentFilteredContentSelectionIndexes"];
		
		// -- tell it to remove all layers
		[self removeAllLayers];
		_starScene = nil;
	}

	NSAssert( ((_starScene==nil) && (value==nil)) || ((_starScene!=nil) && (value!=nil)), @"fuck up");
}

- (void)_buildInitiallayerGraphFromScene {

	// TODO: - do we need a root layer?
	
	NodeProxy *rootProxy = _starScene.rootProxy;
	[_graphLayersController _createNewStarLayerForProxy:rootProxy onParentLayer:[_contentLayerManager containerLayer_temporary] atIndex:0];

	// TODO: -- Should scene be a node? The Root node?
}

- (void)removeAllLayers {
	
	NSAssert([_contentLayerManager containerLayer_temporary]!=nil, @"eh?");
	NodeProxy *rootKey = _starScene.rootProxy;
	NSAssert(rootKey!=nil, @"Doh");
    [_graphLayersController removeStar:rootKey fromLayer:[_contentLayerManager containerLayer_temporary]];
}

- (void)graphDidUpdate {
	
	[_selectedLayersController enforceConsistentState];
}

#pragma mark notifications

/* The only thing in scene that you can observe is currentProxy */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {

	NSParameterAssert( observedObject==_starScene );
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
	NSNumber *isPrior = [change objectForKey:NSKeyValueChangeNotificationIsPriorKey];
	NSAssert(isPrior==nil, @"something i don't know?");
	
	NSAssert([context isEqualToString:@"SceneDisplay"], @"something i don't know?");

	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//		BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
//	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
//		BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	id changeIndexesArray = [change objectForKey:NSKeyValueChangeIndexesKey]; //  NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, or NSKeyValueChangeReplacement, 		
		
        if( [keyPath isEqualToString:@"currentFilteredContentSelectionIndexes"] )
        {
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeSetting:
					// see above - we may have just moved to a new currentNode and not 'actually' changed anything as far as we are concerned
					// [NSException raise:@"NO" format:@""];
					return;
				case NSKeyValueChangeInsertion:
					[NSException raise:@"NO" format:@""];
					break;
				case NSKeyValueChangeRemoval:
					[NSException raise:@"NO" format:@""];
					break;
				case NSKeyValueChangeReplacement:
					// logInfo(@"Replace selection");
					break;
				default:
					[NSException raise:@"unknown changeKind" format:@""];
			}
			// this is the terrible hack where i have filled the changedIndexes with my own data
			NSMutableIndexSet *changeIndexes = [changeIndexesArray objectAtIndex:0];
			NSMutableIndexSet *newSelectedItemsThatPassFilter = [changeIndexesArray objectAtIndex:1];
			NSMutableIndexSet *deselectedObjectsThatPassFilter = [changeIndexesArray objectAtIndex:2];
			NSAssert( changeIndexes, @"something gone-a-wrong" );
			[self nodeProxy:_starScene.currentProxy changedSelectionTo:changeIndexes byDeselecting:deselectedObjectsThatPassFilter andSelecting:newSelectedItemsThatPassFilter];
			
		} else if( [keyPath isEqualToString:@"currentProxy"] )
		{
			NSAssert( oldValue, @"need an old value");
			NSAssert( oldValue!=_starScene.currentProxy, @"new value must be different than old value");
			[self currentNodeProxyChangedFrom:oldValue to:_starScene.currentProxy];

		} else if( [keyPath isEqualToString:@"currentFilteredContent"] )
		{
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeSetting:
					// Fuck we may have just changed current node
					// content will change when we move up or down currentNodeGroup
					// [self nodeProxy:_starScene.currentProxy changedContent:];
					return;
				case NSKeyValueChangeInsertion:
					[NSException raise:@"NO" format:@""];
					break;
				case NSKeyValueChangeRemoval:
					NSAssert( oldValue, @"need an old value");
					[self nodeProxy:_starScene.currentProxy removedContent:oldValue];
					return;
				case NSKeyValueChangeReplacement:
					// logInfo(@"Replace selection");
					break;
				default:
					[NSException raise:@"unknown changeKind" format:@""];
			}
			[NSException raise:@"here!" format:@"no"];
		} else {
			[NSException raise:@"unknown keypath" format:@""];
		}
}

/* DIY Notifications from Scene */
- (void)nodeProxy:(NodeProxy *)value changedContent:(NSArray *)values {

	NSParameterAssert(value);
	NSParameterAssert(values);

	// This is slighly complicated. Because we are observing initial conditions we will receive a changedContent notification for child layers
	// before we have even created a layer for this node. Ignore these notifications.
	// When we add the layer we will recursively add all children.
	// We may not need the 'Initial' setting in 'setUpObservationOf:'
	AbstractLayer *parentLayer = [_contentLayerManager lookupLayerForKey:value.originalNode];

	NSAssert( parentLayer!=nil, @"i can't remember why this would happen");
	
	// !remove existing content first!
	NSAssert( [[parentLayer sublayers] count]==0, @"oops! we already have some old layers that we need to remove!");

	//iterate thru each child creating a layer - _createNewStarLayerForProxy is recursive and will go deep
	NSArray *filteredCnt = [value filteredContent];
	for(NodeProxy *each in values){
		int indexToInsert = [filteredCnt indexOfObjectIdenticalTo:each];
		NSAssert( indexToInsert!=NSNotFound, @"eh? - mismatch between filteredContent and changedContent" );
		[_graphLayersController _createNewStarLayerForProxy:each onParentLayer:parentLayer atIndex:indexToInsert];
	}
}

/* When a Node is reordered you do not receive a 'remove' notification - just an 'insert' with a new index */
- (void)nodeProxy:(NodeProxy *)value insertedContent:(NSArray *)values {

	NSParameterAssert(value);
	NSParameterAssert(values);
	NSAssert(_starScene!=nil, @"need to set scene");

	AbstractLayer *parentLayer = [_contentLayerManager lookupLayerForKey:value.originalNode];
	NSAssert(parentLayer!=nil, @"something gone wrong.");
	NSArray *filteredCnt = [value filteredContent];

	for(NodeProxy *each in values){
		int indexToInsert = [filteredCnt indexOfObjectIdenticalTo:each];
		NSAssert(indexToInsert!=NSNotFound, @"eh?");
		id originalNode = each.originalNode;
		AbstractLayer *existingLayer = [_contentLayerManager lookupLayerForKey:originalNode];
		if(existingLayer){
			NSAssert(existingLayer.superlayer==parentLayer, @"oh come on!");
			[_graphLayersController moveStarLayer:existingLayer toIndex:indexToInsert];
		} else {
			[_graphLayersController _createNewStarLayerForProxy:each onParentLayer:parentLayer atIndex:indexToInsert];
		}
	}
}

- (void)nodeProxy:(NodeProxy *)value removedContent:(NSArray *)values {

	NSParameterAssert(value);
	NSParameterAssert(values);
	NSAssert(_starScene!=nil, @"need to set scene");
	NSAssert( [_selectedContentManager isEmpty], @"There shouldn't be selection layers at this point");
	
	if([values count]>0)
	{
		AbstractLayer *parentLayer = [_contentLayerManager lookupLayerForKey:value.originalNode];
		/* we may well have already removed this layer with our recursive action! Messy ! */
		NSAssert(parentLayer, @" Does this ever happen? it may be ok if it does");
		for(NodeProxy *each in values){
			[_graphLayersController removeStar:each fromLayer:parentLayer];
		}
	}
}


// NB! there is no 'initial' state set - assumes initisl current node is root
- (void)currentNodeProxyChangedFrom:(NodeProxy *)oldValue to:(NodeProxy *)newValue {
	
	NSAssert(_starScene!=nil, @"need to set scene");

	logInfo(@"<<<<<<<<< from %@? --- to %@ >>>>>>>>>>>", oldValue, newValue);
    NSAssert([[[_selectedContentManager containerLayer_temporary] sublayers] count]==0, @"we shouyldnt have any selected layers at this point");
    NSAssert([_selectedContentManager isEmpty], @"we shouyldnt have any selected layers at this point");
	
    SHNode *currentNode = [_starScene.model currentNodeGroup];
    SHNode *rootNode = [_starScene.model rootNodeGroup];
	NSAssert((id)currentNode==(id)([newValue originalNode]), @"errr");
    
    // if we are in a sub node
    //-- draw 50% black over view to knock everything back
    /* when we are in root node we just draw normally */
   if(currentNode!=rootNode)
   {
		/* Fill a transluscent black over the entire screen */
//june09		if(blackTransparentLayer==nil)
//june09		{
//june09			blackTransparentLayer = [self blackTransparentLayer]; // bit of a mess - this method already assigns blackTransparentLayer
//june09		}
	
    } else {
		// NSAssert(blackTransparentLayer!=nil, @"eh?");
//june09		[blackTransparentLayer wasRemoved];
//june09        [CATransaction begin];
//june09        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//june09			[blackTransparentLayer removeFromSuperlayer];
 //june09       [CATransaction commit];

//june09		blackTransparentLayer = nil;
	}
}

#pragma mark SELECTION layers

/* what exactly does the selected layer tree involve ? all children? just selected nodes? selected nodes and their children? */
- (void)nodeProxy:(NodeProxy *)value changedSelectionTo:(NSIndexSet *)values byDeselecting:(NSIndexSet *)oldValues andSelecting:(NSIndexSet *)newValues {
	
	NSParameterAssert( value );
	NSParameterAssert( values);
	NSParameterAssert( oldValues );
	NSParameterAssert( newValues );
	NSAssert( _starScene!=nil, @"need to set scene" );
	
	NSUInteger countOfSelectedLayers = [_selectedLayersController selectedCount];
	NSAssert1( countOfSelectedLayers-[oldValues count]+[newValues count]==[values count], @"what? %i", countOfSelectedLayers );

	//-- add new nodes at correct indexes
	if([newValues count]>0){
		NSArray *proxiesToAdd = [value objectsInFilteredContentAtIndexes:newValues];
		[_selectedLayersController addNewSelectedLayersToRoot:proxiesToAdd theirIndexesInFilteredContent:newValues allIndexesOfSelectedNodes:values];
    }
	
	if([oldValues count]>0){
		NSArray *proxiesToRemove = [value objectsInFilteredContentAtIndexes:oldValues];
		[_selectedLayersController removeProxiesFromSelection:proxiesToRemove];
	}
}

#pragma mark accessors
//june09- (ContentLayerManager *)selectedContentManager {

    /* we will need to add this at the correct index */
//june09	if(blackTransparentLayer){
//june09		[self.layer insertSublayer:layer above:blackTransparentLayer];
//june09	} else {
//june09		[self.layer insertSublayer:layer above:contentLayer];
//june09	}

//june09	return _selectedContentManager;
//june09}

@end
