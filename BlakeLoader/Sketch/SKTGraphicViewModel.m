//
//  SKTGraphicViewModel.m
//  BlakeLoader
//
//  Created by steve hooley on 19/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTGraphicViewModel.h"
#import "SKTTool.h"
#import "BlakeDocument.h"
#import "SKTDecorator.h"
#import "SKTDecorator_Selected.h"


@interface SKTGraphicViewModel (PrivateMethods)
	- (void)_filterSetSktSceneItems:(NSMutableArray *)value;
	- (void)_filteredSelectionIndexesChangedTo:(NSMutableIndexSet *)value;
	- (void)_filterRemovedItemsAtIndexes:(NSIndexSet *)indexes;
	- (void)_filterInsertedItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;
@end

/*
 *
*/
@implementation SKTGraphicViewModel

@synthesize sketchModel = _sketchModel;
@synthesize filter = _filter;

#pragma mark -
#pragma mark class methods
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    
    BOOL automatic = NO;
    if( [theKey isEqualToString:@"sketchModel"] ) {
        automatic=NO;
	} else if( [theKey isEqualToString:@"sktSceneSelectionIndexes"] ) { 
		automatic=NO;
	} else if( [theKey isEqualToString:@"sktSceneItems"] ) { 
		automatic=NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

#pragma mark init methods
- (id)init {

    if ((self = [super init]) != nil)
    {
        _isInUse = NO;
        _isSetup = NO;
        _sketchModelDidChange = NO;
        _changeCount = 0;
    } else {
        logError(@"Why would this happen");
    }
	return self;
}

- (void)dealloc {

    if(_isInUse==YES)
        logError(@"where are you?");
    NSAssert(_isInUse==NO, @"Clean UP graphicViewModel before releasing");
	
	[super dealloc];
}

#pragma mark action methods

- (void)setUpSketchViewModel {
    
#warning Did this really not work cause it was init? Do we need to move all observancis from init?
	NSAssert(_isSetup==NO, @"How? ba");
	[self addObserver:self forKeyPath:@"sketchModel" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTGraphicViewModel"];
    _isSetup = YES;
}

- (void)cleanUpSketchViewModel {

	[self _filteredSelectionIndexesChangedTo:nil];
	[self _filterSetSktSceneItems:nil];
	
	//-- we unregisterContentFilter when we observe the model has been changed to nil

    self.sketchModel = nil;

    _isInUse = NO;
	[self removeObserver:self forKeyPath:@"sketchModel"];
    _isSetup = NO;
}

- (void)resetChangeCount {
    _changeCount = 0;
}

//- (void)bind:(NSString *)binding toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
//
//	[super bind:binding toObject:observableController withKeyPath:keyPath options:options];
//}
//
//- (void)unbind:(NSString *)binding {
//
//	[super unbind:binding];
//}
//
//- (id)retain {
//	return [super retain];
//}
//- (void)release {
//	[super release];
//}

#pragma mark notification methods

/* A simple bit of forwarding :) - translate the keyPaths */
//- (void)addObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
//	
//	if([keyPath isEqualToString:@"graphics"]){
//		[_filter addObserver: anObserver forKeyPath:@"filteredContent" options: options context: context];
//	} else if([keyPath isEqualToString:@"selectionIndexes"]){
//		[_filter addObserver: anObserver forKeyPath: @"filteredContentSelectionIndexes" options: options context: context];
//	} else {
//		[super addObserver:anObserver forKeyPath:keyPath options:options context:context];
//	}
//}

/* A simple bit of forwarding :) */
//- (void)removeObserver:(NSObject *)anObserver forKeyPath:(NSString *)keyPath {
//	
//	if([keyPath isEqualToString:@"graphics"]){
//		[_filter removeObserver: anObserver forKeyPath: @"filteredContent"];
//	} else if([keyPath isEqualToString:@"selectionIndexes"]){
//		[_filter removeObserver: anObserver forKeyPath: @"filteredContentSelectionIndexes"];
//	} else {
//		[super removeObserver:anObserver forKeyPath:keyPath];
//	}
//}

/* Observe changes to the models contents and selection */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {

	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	BOOL oldValueIsNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey];
	
    if( [context isEqualToString:@"SKTGraphicViewModel"] )
	{
        if ([keyPath isEqualToString:@"sketchModel"])
        {
            _changeCount++;
            if(_sketchModelDidChange==YES){
                _sketchModelDidChange = NO;
            } else {
                logWarning(@"ERROR");
                return;
            }
                // logError(@"what on earth have we observed then?");
            // -- register for filter
            NSAssert(oldValue!=newValue, @"surely not? - how can old model == new model");
            if(oldValueIsNullOrNil==_isInUse)
                logError(@"who is responsible for this madness?");
            NSAssert2(oldValueIsNullOrNil!=_isInUse, @"if we are in use where is oldSketchModel? oldisNull? - %i, isInUse? - %i", oldValueIsNullOrNil, _isInUse);
                
            // -- add an observer to filter content

            // The "old value" or "new value" in a change dictionary will be NSNull, instead of just not existing, 
            // if the corresponding option was specified at KVO registration time and the value for some key in 
            // the key path is nil. In Sketch's case there are times in an SKTGraphicView's life cycle when it's 
            // bound to the graphics of a window controller's document, and the window controller's document is nil.
            // Don't redraw the graphic view when we get notifications about that.
            // Have graphics been removed from the bound-to container?
            
            //* HOOLEY *//
            // This doesnt work for me ! old value and new value come out as nil when they dont exist - not NSNull, why?
            if( oldValueIsNullOrNil==NO )
            {
				SHNodeGraphModel *oldModel = oldValue;
                logInfo(@"%i unregistering %@", _changeCount, oldModel);
                [oldModel unregisterContentFilter:[NodeClassFilter class] andUser:self options:nil];
            }
            
            // Have graphics been added to the bound-to container?
            if( newValueNullOrNil==NO )
            {
				SHNodeGraphModel *newModel = newValue;

				/* NB! When we swap the model we must ensure that we send out notifications that graphics and selection have changed */
                _isInUse = YES;
                NSAssert2(_sketchModel==newModel, @"what is going on? %@ - %@", _sketchModel, newModel);
				
				/*	The filter set us up (as the user) to receive notifications of changes to content & selection.
					It uses NSKeyValueObservingOptionInitial so that we will receive immediate notification that graphics have been Changed.
				*/
                [_sketchModel registerContentFilter:[NodeClassFilter class] andUser:self options:nil];
            }
        } else {
            logInfo(@"Observing %@ but DOING NOTHING!", keyPath);
        }
        
	} else if( [context isEqualToString:@"NodeClassFilter"] ){
			
		/* We are getting rid of filtered content */
		if ([keyPath isEqualToString:@"filteredContent"])
		{			
			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					[self _filterInsertedItems: newValue atIndexes: changeIndexes];
					break;

				case NSKeyValueChangeReplacement:
					[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
					break;

				case NSKeyValueChangeSetting:
					[self _filterSetSktSceneItems: [[newValue mutableCopy] autorelease]];
					break;

				case NSKeyValueChangeRemoval:
					NSAssert(oldValueIsNullOrNil==NO, @"DOH!");
					[self _filterRemovedItemsAtIndexes: changeIndexes];
					break;
					
				default:
					[NSException raise:@"unpossible" format:@"unpossible"];
					break;
			}
            
        } else if ([keyPath isEqualToString:@"filteredContentSelectionIndexes"]) {

			switch ([changeKind intValue]) 
			{
				case NSKeyValueChangeInsertion:
					[NSException raise:@"WE NEVER MUTATE THE SELECTION!" format:@"UNSUPPORTED"];
					break;
					
				case NSKeyValueChangeReplacement:
					[NSException raise:@"UNSUPPORTED" format:@"UNSUPPORTED"];
					break;
					
				case NSKeyValueChangeSetting:
					[self _filteredSelectionIndexesChangedTo: [[newValue mutableCopy] autorelease]];
					break;
					
				case NSKeyValueChangeRemoval:
					NSAssert(oldValueIsNullOrNil==NO, @"DOH!");
					[NSException raise:@"WE NEVER MUTATE THE SELECTION!" format:@"UNSUPPORTED"];
					break;
					
				default:
					[NSException raise:@"unpossible" format:@"unpossible"];
					break;
			}
        }

    } else {
        
		// In overrides of -observeValueForKeyPath:ofObject:change:context: always invoke super when the observer notification isn't recognized.
        // Code in the superclass is apparently doing observation of its own.
        // NSObject's implementation of this method throws an exception. Such an exception would be indicating a programming error that should be fixed.
		[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:context];
    }
}

#pragma mark accessor methods

- (void)setSketchModel:(SHNodeGraphModel *)value {
    
    if(value!=_sketchModel){
        [self willChangeValueForKey:@"sketchModel"];
        [_sketchModel release];
        _sketchModel = [value retain];
        _sketchModelDidChange = YES;
        [self didChangeValueForKey:@"sketchModel"];
    }
}

- (void)changeSktSceneSelectionIndexes:(NSIndexSet *)indexes {

    [_filter changeSelectionIndexes:indexes];
}

- (NSArray *)selectedSktSceneItems {
	
	return [_sktSceneItems objectsAtIndexes:_sktSceneSelectionIndexes];
}

- (unsigned int)countOfSktSceneItems {
	
	return [_sktSceneItems count];
}

- (id)objectInSktSceneItemsAtIndex:(unsigned int)index {
	
	return [_sktSceneItems objectAtIndex: index];
}

- (NSMutableArray *)sktSceneItems {
	
	return _sktSceneItems;
}

- (void)_filterSetSktSceneItems:(NSMutableArray *)value {
	
	if(_sktSceneItems!=value){
		[self willChangeValueForKey:@"sktSceneItems"];
		[_sktSceneItems release];
		_sktSceneItems = [value retain];
		[self didChangeValueForKey:@"sktSceneItems"];
	}
}

- (NSMutableIndexSet *)sktSceneSelectionIndexes {
	return _sktSceneSelectionIndexes;
}

- (void)setSktSceneSelectionIndexes:(NSMutableIndexSet *)value {
	[self changeSktSceneSelectionIndexes:value];
}

- (void)_filteredSelectionIndexesChangedTo:(NSMutableIndexSet *)value {
	
	NSLog(@"FilteredSelection changed from %@ to %@", _sktSceneSelectionIndexes, value );
	if(_sktSceneSelectionIndexes!=value){
		
		// -- for each in old that isnt in new -- swap out the selected decorators --
		// IMPORTANT that we dont do it in a KVC way - the view doesnt want to get notified that a change was made
		if(_sktSceneSelectionIndexes){
			unsigned int currentIndex = [_sktSceneSelectionIndexes firstIndex];
			while( currentIndex!=NSNotFound )
			{
	//			NSMutableIndexSet *indexesOfProxyItems = [NSMutableIndexSet indexSet];
	//			NSMutableArray *originalObjects = [NSMutableArray array];
				if([value containsIndex:currentIndex]==NO) // has a selected Object become unselected?
				{
					SKTDecorator_Selected *dec = [_sktSceneItems objectAtIndex:currentIndex];
					SKTGraphic *graph = dec.originalGraphic;
					NSAssert(dec!=nil && [dec isKindOfClass:[SKTDecorator_Selected class]], @"er - cant swap out selected decorator");
					NSAssert(graph!=nil && [graph isKindOfClass:[SKTGraphic class]], @"er - cant swap out selected decorator");
					[_sktSceneItems replaceObjectAtIndex:currentIndex withObject:graph];
				}
				currentIndex = [_sktSceneSelectionIndexes indexGreaterThanIndex: currentIndex];
			}
		// would it be better to store them up and only make one call to replace?
		//	[self _notificationSend_replaceItemsAtIndexes:indexesOfProxyItems withObjects:originalObjects];
		}
		
		NSIndexSet *oldValues = [_sktSceneSelectionIndexes retain];
		
		/* make the change -- there should not be any decorators in the old items */
		// The NSKeyValueChangeOldKey entry contains the value returned by -valueForKey: at the instant that -willChangeValueForKey: is invoked (or an NSNull if -valueForKey: returns nil).
		// The NSKeyValueChangeNewKey entry contains the value returned by -valueForKey: at the instant that -didChangeValueForKey: is invoked (or an NSNull if -valueForKey: returns nil).
		[self willChangeValueForKey:@"sktSceneSelectionIndexes"];
			[_sktSceneSelectionIndexes release];
			_sktSceneSelectionIndexes = [value retain];
		[self didChangeValueForKey:@"sktSceneSelectionIndexes"];

		// -- for each in new that isnt old -- swap in the selected dcorators --
		// IMPORTANT that we dont do it in a KVC way - the view doesnt want to get notified that a change was made
		if(_sktSceneSelectionIndexes){
			unsigned int currentIndex = [_sktSceneSelectionIndexes firstIndex];
			while( currentIndex!=NSNotFound )
			{
				if([oldValues containsIndex:currentIndex]==NO) // has a selected Object become unselected?
				{
					SKTGraphic *graph = [_sktSceneItems objectAtIndex:currentIndex];
					SKTDecorator_Selected *dec = [SKTDecorator_Selected decoratorForGraphic:graph];
					NSAssert(dec!=nil && [dec isKindOfClass:[SKTDecorator_Selected class]], @"er - cant swap in selected decorator");
					NSAssert(graph!=nil && [graph isKindOfClass:[SKTGraphic class]], @"er - cant swap in selected decorator");
					[_sktSceneItems replaceObjectAtIndex:currentIndex withObject:dec];
				}
				currentIndex = [_sktSceneSelectionIndexes indexGreaterThanIndex: currentIndex];
			}
		}
		[oldValues release];
	}
}

- (void)_filterInsertedItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes {

	NSAssert(_sktSceneItems!=nil, @"cant add when we have indexes because we wil fuck up the indexes");
	NSParameterAssert(items!=nil);
	NSParameterAssert(indexes!=nil);
	NSParameterAssert([items count]>0);
	NSParameterAssert([indexes count]>0);
	NSParameterAssert([indexes lastIndex]<([_sktSceneItems count]+[items count]));
	
	NSAssert([_sktSceneSelectionIndexes count]==0, @"cant add when we have indexes because we wil fuck up the indexes");
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"sktSceneItems"];
		[_sktSceneItems insertObjects:items atIndexes:indexes];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"sktSceneItems"];
}

/* Indexed Acessor */
- (void)_filterRemovedItemsAtIndexes:(NSIndexSet *)indexes {

	logInfo(@"Oh YEAH! - removeSktSceneItemsAtIndexes");
	NSParameterAssert([indexes count]>0);
	NSParameterAssert([indexes lastIndex]<[_sktSceneItems count]);
	NSAssert(_sktSceneItems!=nil, @"cant add when we have indexes because we wil fuck up the indexes");
//	NSAssert([_sktSceneSelectionIndexes count]==0, @"cant add when we have indexes because we wil fuck up the indexes");

	// unpack any proxy/decorators we are using…
	unsigned int currentIndex = [indexes firstIndex];
	while( currentIndex!=NSNotFound )
	{
		if([[_sktSceneItems objectAtIndex:currentIndex] isKindOfClass:[SKTDecorator class]]==YES)
		{
			[NSException raise:@"Put back to normalk before you delete" format:@"Put back to normalk before you delete"];
		}
		currentIndex = [indexes indexGreaterThanIndex: currentIndex];
	}	
	
    // Do the actual removal.
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"sktSceneItems"];
    [_sktSceneItems removeObjectsAtIndexes:indexes];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"sktSceneItems"];
}

//- (void)_notificationSend_replaceItemsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects {
//	
//	[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"sktSceneItems"];
//	[_sktSceneItems replaceObjectsAtIndexes:indexes withObjects:objects];
//	[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"sktSceneItems"];
//}

@end
