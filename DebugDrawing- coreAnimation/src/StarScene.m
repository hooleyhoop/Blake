//
//  StarScene.m
//  DebugDrawing
//
//  Created by steve hooley on 25/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "StarScene.h"


@implementation StarScene

@synthesize model=_model;
@synthesize filter=_filter;

// Danger!
/* weird! if you register for currentFilteredContent, currentFilteredContentSelectionIndexes and currentProxy you will register for currentNodeProxy 3 times! */
//+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
//	
//	NSSet* set = [super keyPathsForValuesAffectingValueForKey:key];
//	if( [key isEqualToString:@"currentFilteredContent"] || [key isEqualToString:@"currentFilteredContentSelectionIndexes"] || [key isEqualToString:@"currentProxy"]) {
//		set = [set setByAddingObjectsFromSet:[NSSet setWithObject: @"filter.currentProxy"]];
//	}
//	return set;
//}


+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
	
	if( [key isEqualToString:@"currentProxy"] || [key isEqualToString:@"currentFilteredContent"] || [key isEqualToString:@"currentFilteredContentSelectionIndexes"] )
		return NO;
	else
		[NSException raise:@"what else is there?" format:@""];

	return [super automaticallyNotifiesObserversForKey:key]; // COV_NF_LINE
}

#pragma mark set-up

/* Must set model to nil inbetween (to clean up the old model) if you want to swap models */
- (void)setModel:(SHNodeGraphModel *)value {
	
	if(_model!=value){
		/* Setting a new model - old one must be nil */
		if(value!=nil){
			NSAssert(_model==nil, @"eek");
			// this will call setFilter
			[value registerContentFilter:[NodeClassFilter class] andUser:self options:[NSDictionary dictionaryWithObject:@"Graphic" forKey:@"Class"]];
		}
		/* setting model to nil - clean up a bit? */
		else {
			NSAssert(_model!=nil, @"eek");
			[self setCurrentFilteredContentSelectionIndexes:[NSIndexSet indexSet]];
			[_model unregisterContentFilter:[NodeClassFilter class] andUser:self options:[NSDictionary dictionaryWithObject:@"Graphic" forKey:@"Class"]];
		}
		_model = value;
	}
}

/* Callback from when we register for filter in setModel */
- (void)setFilter:(NodeClassFilter *)value {
	
	if(value==nil){
		NSAssert(_filter!=nil, @"are we unsetting the filter or what?");
		
		// we need the proxy, not the original, so we observe the filter - not the model
		[_filter removeObserver:self forKeyPath:@"currentNodeProxy"];
		
		// what is this shit?
//june09		NSIndexSet *allIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_filter.rootNodeProxy.filteredContent count])];
//june09		[self temp_proxy:_filter.rootNodeProxy removedContent:_filter.rootNodeProxy.filteredContent atIndexes:_filter.rootNodeProxy]; // add our DIY observing
	} else {
		
#warning! test this rubbish!

		NSAssert(_filter==nil, @"are we setting the filter or what?"); 
		[value addObserver:self forKeyPath:@"currentNodeProxy" options:(NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: @"StarScene"]; // Do we need these options?
		/* NB - it is up to us to grab the root NodeProxy and parse it's children to get us up to date */

//june09		NSIndexSet *allIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_filter.rootNodeProxy.filteredContent count])];
//june09		[self temp_proxy:value.rootNodeProxy changedContent:value.rootNodeProxy.filteredContent atIndexes:allIndexes]; // add our DIY observing
	}
	_filter = value;
}

#pragma mark Actions
- (void)selectItemAtIndex:(NSUInteger)ind {
	
	//june09	NSMutableIndexSet *newIndexes = nil;
	//june09	if(selectedItemIndexes){
	//june09		newIndexes = [[selectedItemIndexes mutableCopy] autorelease];
	//june09		[newIndexes addIndex:ind];
	//june09	} else
	//june09		newIndexes = [NSIndexSet indexSetWithIndex:ind];
	
	NSIndexSet *newIndexes = [self currentFilteredContentSelectionIndexes];
	NSMutableIndexSet *newIndexesMutable = [[newIndexes mutableCopy] autorelease];
	[newIndexesMutable addIndex:ind];
	[self setCurrentFilteredContentSelectionIndexes:newIndexesMutable];
}

- (void)deselectItemAtIndex:(NSUInteger)ind {
	
	//june09	NSParameterAssert([selectedItemIndexes containsIndex:ind]);
	//june09	NSMutableIndexSet *newIndexes = [[selectedItemIndexes mutableCopy] autorelease];
	//june09	[newIndexes removeIndex:ind];
	
	NSIndexSet *currentSelection = [self currentFilteredContentSelectionIndexes];
	NSMutableIndexSet *currentSelectionMutable = [[currentSelection mutableCopy] autorelease];
	[currentSelectionMutable removeIndex:ind];
	[self setCurrentFilteredContentSelectionIndexes:currentSelectionMutable];
}

#pragma mark Notifications

/* The filter auotmatically hooks you up to receive currentNode changed notifications */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSParameterAssert(vcontext);
	NSString *context = (NSString *)vcontext;
	NSAssert(  [context isEqualToString:@"StarScene"], @"fuck" );
	
	NSNumber *changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	NSNumber *isPrior = [change objectForKey:NSKeyValueChangeNotificationIsPriorKey];

	if( [keyPath isEqualToString:@"currentNodeProxy"] )
	{
		switch ([changeKind intValue]) 
		{
			/*	This is like my DIY keyPathsForValuesAffectingValueForKey - 
				keyPathsForValuesAffectingValueForKey seems to be pretty fucked - you cant observe currentNode & filteredContent if they both trigger the same notification
				The fabulous KVO option NSKeyValueObservingOptionPrior lets you receive a notification before and after the change, allowing the correct use of
				manually calling -willChangeValueForKey: & -didChangeValueForKey:
			 */
			case NSKeyValueChangeSetting:
				if(isPrior){
					[self willChangeValueForKey:@"currentProxy"];
					[self willChangeValueForKey:@"currentFilteredContent"];
					[self willChangeValueForKey:@"currentFilteredContentSelectionIndexes"];
				} else {
					[self didChangeValueForKey:@"currentProxy"];
					[self didChangeValueForKey:@"currentFilteredContent"];
					[self didChangeValueForKey:@"currentFilteredContentSelectionIndexes"];
				}
				break;
			default:
				[NSException raise:@"what the fuck?" format:@""];
				break;
		}

			// we need a way to mark the whole screen as dirty 
			//			StarView *view = [(AppControl *)([[NSApplication sharedApplication] delegate]) starView];
			//			[view setNeedsDisplayInRect:NSMakeRect(0,0,800,600)];
				
//june09            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//june09            id newValue = [change objectForKey:NSKeyValueChangeNewKey];
//june09            [_registeredObserver currentNodeProxyChangedFrom:oldValue to:newValue];

			return;
	}

	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

#pragma mark SHContentProviderUserProtocol
// basically calls - graphicWasAddedToScene
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	NSParameterAssert(proxy!=nil);
	NSParameterAssert(values!=nil);
	NSAssert(_willChangeContentDebug==NO, @"-willChangeContent following -willChangeContent?");
	[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"currentFilteredContent"];
	_willChangeContentDebug = YES;
}

// not sure this is ever called?
- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	NSParameterAssert(proxy!=nil);
	NSParameterAssert(values!=nil);
	
	// check that this call was paired with a -willChange
	NSAssert( _willChangeContentDebug==YES, @"-didChangeContent without -willChangeContent?");
	
	// DIY Notification thing
//june09	[_registeredObserver nodeProxy:value changedContent:values];
		
//june09	for(NodeProxy *each in values)
//june09	{
//june09		SHNode *originalNode = each.originalNode;
//june09		if([originalNode isKindOfClass:[Graphic class]]){
//june09			[self graphicWasAddedToScene:(Graphic *)originalNode];
//june09		} 
		// go deep?
//june09		if([originalNode allowsSubpatches]) {
//june09			[self temp_proxy:each changedContent:each.filteredContent];
//june09		}
//june09	}
	
	// trigger our manual notification
	[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"currentFilteredContent"];
	_willChangeContentDebug = NO;
}

/*
 * as well as the obvious case, we also receive this when a node is reordered (no 'remove' notifiaction is sent before hand tho) 
 * In other words - we May ALREADY contain these objects but at a different index
 */
- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {

	NSParameterAssert(proxy!=nil);
//do we need this?	NSParameterAssert(proxiesForsuccessFullObjects!=nil);
	NSAssert(_willInsertContentDebug==NO, @"-willInsertContentDebug following -willInsertContentDebug?");
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"currentFilteredContent"];
	_willInsertContentDebug = YES;
}

- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {

	NSParameterAssert(proxy!=nil);
	NSParameterAssert(proxiesForsuccessFullObjects!=nil);

	// check that this call was paired with a -willChange
	NSAssert(_willInsertContentDebug==YES, @"-didInsertContent without -willInsertContent?");

	// DIY Notification thing	
//june09	[_registeredObserver nodeProxy:value insertedContent:values];
	
//june09	for(NodeProxy *each in values)
//june09	{
//june09		SHNode *originalNode = each.originalNode;
//june09		if([originalNode isKindOfClass:[Graphic class]])
//june09			[self graphicWasAddedToScene:(Graphic *)originalNode];
		// go deep? - no, all items are inserted
//june09	}
	
	// trigger our manual notification
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"currentFilteredContent"];
	_willInsertContentDebug = NO;
}

// this will store the current value - so the correct one is passed into the observation.
// That is why we have to split up the willChange and didChange. willChange MUST happen before the
// value at the index has ACTUALLY been removed or whatever is currently at the index AFTER removal
// would be the object passed to the notification
- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	NSParameterAssert(proxy!=nil);
	NSParameterAssert(values!=nil);
	NSAssert(_willRemoveContentDebug==NO, @"-_willRemoveContentDebug following -_willRemoveContentDebug?");
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"currentFilteredContent"];
	_willRemoveContentDebug = YES;
}

- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {

	NSParameterAssert(proxy!=nil);
	NSParameterAssert(values!=nil);
	
	// check that this call was paired with a -willChange
	NSAssert(_willRemoveContentDebug==YES, @"-didRemoveContent without -willRemoveContent?");

	// DIY Notification thing	
//june09	[_registeredObserver nodeProxy:value removedContent:values];	
	
//june09	for(NodeProxy *each in values)
//june09	{
//june09		SHNode *originalNode = each.originalNode;
//june09		if([originalNode isKindOfClass:[Graphic class]])
//june09			[self graphicWasRemovedFromScene:(Graphic *)originalNode];
		// go deep? YES
//june09		if([originalNode allowsSubpatches]) {
//june09			[self temp_proxy:each removedContent:each.filteredContent];
//june09		}
//june09	}
	
	// trigger our manual notification
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"currentFilteredContent"];
	_willRemoveContentDebug = NO;
}

/* Selection */
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)notUsed {
	
	NSParameterAssert( proxy!=nil );
	NSAssert( _willchangeSelectionDebug==NO, @"-willchangeSelection following -willchangeSelection?" );

	// VERY IMPORTANT
	// altho notUsed is, just that - you need to pass something into willChange: valuesAtIndexes: in order for
	// the changeIndexes to not be nil. Just passsing the value into didChange: isn't enough.
	[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:notUsed forKey:@"currentFilteredContentSelectionIndexes"];
	_willchangeSelectionDebug = YES;
}

- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {
	
	NSParameterAssert(proxy!=nil);
	NSParameterAssert(indexesOfSelectedObjectsThatPassFilter!=nil);
	
	// check that this call was paired with a -willChange
	NSAssert(_willchangeSelectionDebug==YES, @"-didChangeSelection without -willChangeSelection?");
	
	// -- some part of the screen just became dirty..	
	if( proxy.originalNode==_model.currentNodeGroup ){
		
	// trigger our manual notification
	[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexesOfSelectedObjectsThatPassFilter forKey:@"currentFilteredContentSelectionIndexes"];		
	_willchangeSelectionDebug = NO;
		
	} else {
		if([indexesOfSelectedObjectsThatPassFilter count]==0){
			// Because of the 'Initial' option when we set up the bindings we get this alot
			NSAssert([[proxy filteredContentSelectionIndexes] count]==0, @"we should only get changes to nothing!");
		} else {
			[NSException raise:@"We should never change the selection of a Node that is not current" format:@"-- --"];
		}
	}
}

#pragma mark We are observable for these properties - layer list uses them - why bother with our own custom notifiacations?
- (NSArray *)currentFilteredContent {

	NSAssert(_filter.currentNodeProxy!=nil, @"There should always be a currentNode?");
	return _filter.currentNodeProxy.filteredContent;
}

- (void)setCurrentFilteredContent:(NSArray *)value {

	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
}

- (NSIndexSet *)currentFilteredContentSelectionIndexes {

	//-- could this just as well be selectedItemIndexes? NO! currentFilteredContentSelectionIndexes is the only one that is up to date when we change currentNode
	NSIndexSet *selectionInd = _filter.currentNodeProxy.filteredContentSelectionIndexes;		
	return selectionInd;
}

- (void)setCurrentFilteredContentSelectionIndexes:(NSIndexSet *)value {

	if([value isEqualToIndexSet:[self currentFilteredContentSelectionIndexes]]==NO) {
		[_filter.currentNodeProxy changeSelectionIndexes:value];
	}
}

- (NSArray *)selectedItems {
	return [[self currentFilteredContent] objectsAtIndexes:[self currentFilteredContentSelectionIndexes]];
}

- (NodeProxy *)rootProxy {

	return _filter.rootNodeProxy;
}

- (NodeProxy *)currentProxy {

	return _filter.currentNodeProxy;
}

/* we always draws the root content */
- (NSArray *)stars {

	return _filter.rootNodeProxy.filteredContent;
}

//- (NSUInteger)indexOfProxy:(NodeProxy *)proxy {
//	
//}

- (NSUInteger)indexOfOriginalObjectIdenticalTo:(id)value {
	
	NSUInteger val = [_filter.currentNodeProxy indexOfOriginalObjectIdenticalTo:value];
	return val;
}

#pragma mark Need Moving


// NodeProxy doesn't know anything of bounds.. scene does
// these could be c functions
//june09+ (CGRect)drawingBoundsForNodeProxy:(NodeProxy *)value {
//june09	CGRect drawingBounds = CGRectZero;
//june09	if([value.originalNode respondsToSelector:@selector(drawingBounds)]){
//june09		drawingBounds = [(Graphic *)value.originalNode drawingBounds];
//june09	}
//june09	else {
//june09		for(NodeProxy *eachChild in value.filteredContent){
//june09			drawingBounds = NSUnionRect( drawingBounds, [StarScene drawingBoundsForNodeProxy:eachChild]);
//june09		}
//june09	}
//june09	return drawingBounds;
//june09}



@end
