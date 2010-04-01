//
//  NodeProxy.m
//  SHNodeGraph
//
//  Created by steve hooley on 02/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "NodeProxy.h"
#import "AbtractModelFilter.h"
#import <SHNodeGraph/SHNode.h>
#import <SHShared/SHShared.h>
#import <ProtoNodeGraph/SHParent_Selection.h>
#import <ProtoNodeGraph/NodeName.h>

@implementation NodeProxy

#pragma mark -
#pragma mark property accessors
@synthesize filteredContent				= _filteredContent;
@synthesize indexesOfFilteredContent	= _indexesOfFilteredContent;
@synthesize filteredContentSelectionIndexes = _filteredContentSelectionIndexes;

@synthesize originalNode				= _originalNode;
@synthesize isObservingChildren			= _isObservingChildren;
@synthesize filteredTreeNeedsMaking		= _filteredTreeNeedsMaking;

@synthesize debug_selectionNotificationsReceivedCount=_debug_selectionNotificationsReceivedCount, debug_arrayNotificationsReceivedCount=_debug_arrayNotificationsReceivedCount;


#pragma mark -

#pragma mark class methods
+ (id)makeNodeProxyWithFilter:(AbtractModelFilter *)filter {	
	return [[[self alloc] initWithFilter:filter] autorelease];
}

+ (id)makeNodeProxyWithFilter:(AbtractModelFilter *)filter object:(SHChild *)value {
	
	NodeProxy *proxy = [[[self alloc] initWithFilter:filter] autorelease];
	proxy.originalNode = (id)value;
	return proxy;
}

#pragma mark init methods
- (id)initWithFilter:(AbtractModelFilter *)filter {
    
	self = [super init];
	if( self )
	{
		_filter = filter;
		_filteredContent = [[NSMutableArray array] retain];
		_indexesOfFilteredContent = [[NSMutableIndexSet indexSet] retain];
		_filteredContentSelectionIndexes = [[NSMutableIndexSet indexSet] retain];
		_isObservingChildren = NO;
		_debug_selectionNotificationsReceivedCount = 0;
		_debug_arrayNotificationsReceivedCount = 0;
	}
	return self;
}

- (id)init {
	[NSException raise:@"WHOOSE A wanker?" format:@"-- --"];
	return nil; // COV_NF_LINE
}

- (void)dealloc {

	_filter= nil;
	[_filteredContent release];
	[_indexesOfFilteredContent release];
	[_filteredContentSelectionIndexes release];

	[super dealloc];
}

#pragma mark Proxy Methods
- (id)forwardingTargetForSelector:(SEL)sel {
	return _originalNode;
}

#pragma mark action methods

/* This is where version 1 will recursively add all children */
- (void)startObservingOriginalNode {
	
	NSAssert(_isObservingChildren==NO, @"Dont even think of doing this twice - dont need starting!");
	NSAssert(self==_filter.currentNodeProxy, @"we are restricted to observing changes to the current node.");
	
	for( NSString *keyPath in [[_filter class] modelKeyPathsToObserve] )
		[self setUpObservationOf:_originalNode withObserver:self forKeyPath:keyPath];
	
	_isObservingChildren = YES;
}

- (void)stopObservingOriginalNode {
	
	if(_isObservingChildren)
	{
		// should we iterate backwards?
		for( NSString *keyPath in [[_filter class] modelKeyPathsToObserve] ){
			[self takeDownObservationOf:_originalNode withObserver:self forKeyPath:keyPath];
		}
		_isObservingChildren = NO;
	}
	//-- go deep
	for( NodeProxy *np in _filteredContent ){
		[np stopObservingOriginalNode];
	}
}

// Every time we do this we trigger a notificaion because of the initial setting!
- (void)setUpObservationOf:(id)objectToObserve withObserver:(id)observer forKeyPath:(NSString *)kp {
	
	[objectToObserve addObserver:observer forKeyPath:kp options:( NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:[[_filter class] observationCntx]];
}

- (void)takeDownObservationOf:(id)objectToObserve withObserver:(id)observer forKeyPath:(NSString *)kp {
	[objectToObserve removeObserver:observer forKeyPath:kp];
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

	if([keyPath isEqualToString:@"filteredContent"] || [keyPath isEqualToString:@"indexesOfFilteredContent"] || [keyPath isEqualToString:@"filteredContentSelectionIndexes"])	{
	// Hmm, this is curious..	
	//	[NSException raise:@"dont observe proxy's content!" format:@""];
	// what is the point exactly if we can't bind to it?
	// StarScene has a lot of code to track graphics.. must every user of a filter duplicate the same effort?
		[super addObserver:observer forKeyPath:keyPath options:options context:context];
		return;
	
	} else if( [keyPath isEqualToString:@"debugNameString"] || [keyPath isEqualToString:@"name.value"] ){
		[super addObserver:observer forKeyPath:keyPath options:options context:context];
		return;
	}
	[NSException raise:@"dont think we should be observing that!" format:@"%@", keyPath];
}

#pragma mark notification methods
/* Observe changes to the models contents and selection */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
	//TODO: If we get here and we are not upto date we are screwed! -- Need to test this. Can't remember what i meant by this.
	
	/*	surely this is going to be wrong? -- hmm
		What i think this means is that there is no 'Initial' notification.
		We must have already called -makeFilteredTreeUptoDate or asked for the content (which will cause -makeFilteredTreeUptoDate to be called)
	 */
	NSNumber *isPrior = [change objectForKey:NSKeyValueChangeNotificationIsPriorKey];
	// receiving twice as many notifications due to the isPrior - need to make sure we dont do some things twice
	if(_filteredTreeNeedsMaking==YES){
		// we will only do it when NOT prior but must discount the prior notification as well
		if(isPrior==nil)
			[_filter makeFilteredTreeUpToDate:self];
		// Im not sure why i felt this was important.
		// we called -makeFilteredTreeUptoDate, right? we dont need the 'initial' notification
		// return;
	}

	// debugging
	if(isPrior==nil){
		// these only apply to nodeClassFilter - get rid of?
		if([keyPath isEqualToString:@"childContainer.nodesInside.selection"])
			_debug_selectionNotificationsReceivedCount++;
		else if([keyPath isEqualToString:@"childContainer.nodesInside.array"])
			_debug_arrayNotificationsReceivedCount++;	
	}

	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];

	id changeIndexes = [change objectForKey:NSKeyValueChangeIndexesKey]; //  NSKeyValueChangeInsertion, NSKeyValueChangeRemoval, or NSKeyValueChangeReplacement, 
	if( [context isEqualToString:[[_filter class] observationCntx]] )
	{
		switch ([changeKind intValue]) 
		{
			case NSKeyValueChangeInsertion:
				if(isPrior){
					[_filter modelObject:self willInsert:newValue atIndexes:changeIndexes forKeyPath:keyPath];
				}else {
					NSAssert( oldValueNullOrNil, @"what would this be for an insertion?");
					NSAssert( newValueNullOrNil==NO, @"need this for an insertion");
					NSAssert( changeIndexes!=nil, @"need this for an insertion?");
					[_filter modelObject:self inserted:newValue atIndexes:changeIndexes forKeyPath:keyPath];
				}
				break;
			case NSKeyValueChangeReplacement:
				if(isPrior){
					[_filter modelObject:self willReplace:oldValue with:newValue atIndexes:changeIndexes forKeyPath:keyPath];
				}else {
					NSAssert( oldValueNullOrNil==NO, @"must have replaced something");
					NSAssert( newValueNullOrNil==NO, @"need this for a replacement");
					NSAssert( changeIndexes!=nil, @"need this for a replacement");
					[_filter modelObject:self replaced:oldValue with:newValue atIndexes:changeIndexes forKeyPath:keyPath];
				}
				break;
			case NSKeyValueChangeSetting:
				if(isPrior){
					[_filter modelObject:self willChangeTo:newValue from:oldValue forKeyPath:keyPath];
				}else {
					[_filter modelObject:self changedTo:newValue from:oldValue forKeyPath:keyPath];
				}
				break;
			case NSKeyValueChangeRemoval:
				if(isPrior){
					[_filter modelObject:self willRemove:oldValue atIndexes:changeIndexes forKeyPath:keyPath];
				}else {
					NSAssert( oldValueNullOrNil==NO, @"need this for a removal");
					NSAssert( newValueNullOrNil==YES, @"what would this be for a removal?");
					NSAssert( changeIndexes!=nil, @"need this for an removal");
					[_filter modelObject:self removed:oldValue atIndexes:changeIndexes forKeyPath:keyPath];
				}
				break;
			default:
				[NSException raise:@"filtered content changed - how?" format:@"filtered content changed - how?"];
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:context];
	}
}

// nodes
- (void)addIndexesToIndexesOfFilteredContent:(NSIndexSet *)value {
	
	NSParameterAssert(value && [value count]);
	[_indexesOfFilteredContent addIndexes:value];
}

- (void)insertFilteredContent:(NSArray *)graphics atIndexes:(NSIndexSet *)indexes {
	
	NSParameterAssert(graphics!=nil);
	NSParameterAssert([graphics count]>0);
	NSParameterAssert([indexes count]==[graphics count]);
	NSParameterAssert([indexes lastIndex]<([_filteredContent count]+[graphics count]));
	[_filteredContent insertObjects:graphics atIndexes:indexes];
}

- (void)removeIndexesFromIndexesOfFilteredContent:(NSIndexSet *)value {

	NSParameterAssert([_indexesOfFilteredContent containsIndexes:value]);
	[_indexesOfFilteredContent removeIndexes:value];
}

- (void)removeFilteredContentAtIndexes:(NSIndexSet *)indexes {
	
	NSParameterAssert([[_filteredContent objectsAtIndexes: indexes] count]==[indexes count]);
	[_filteredContent removeObjectsAtIndexes: indexes];
}

// selection
- (void)removeIndexesFromSelection:(id)value {
	
	NSParameterAssert(value!=nil);
	NSParameterAssert([_filteredContentSelectionIndexes containsIndexes:value]);

	NSUInteger gindex = [value lastIndex];
	NSAssert2(gindex<[_filteredContent count], @"hoo %i of %i", gindex, [_filteredContent count]);
	NSAssert(gindex!=NSNotFound, @"cant addObjectToSelection we dont contain");

//!Alert-putback!	[self willChangeValueForKey:@"filteredContentSelectionIndexes"];
	[_filteredContentSelectionIndexes removeIndexes:value];
//!Alert-putback!	[self didChangeValueForKey:@"filteredContentSelectionIndexes"];

	// NSLog(@"%p Removed indexes from Selection %@", self, value);
	NSAssert([_filteredContentSelectionIndexes containsIndexes:value]==false, @"removeObjectFromSelection failed");
}

- (void)addIndexesToSelection:(NSIndexSet *)value {
	
	NSParameterAssert(value!=nil);

	NSUInteger gindex = [value lastIndex];
	NSUInteger sanityCheck = [_filteredContent count];
	NSAssert2( gindex<sanityCheck, @"boo %i, %i", gindex, sanityCheck );
	NSAssert(gindex!=NSNotFound, @"cant addObjectToSelection we dont contain");

//!Alert-putback! I am very confused about notifications at the moment. Are we using kvo or our own notification thing in the filter?
//!Alert-putback!	[self willChangeValueForKey:@"filteredContentSelectionIndexes"];
	[_filteredContentSelectionIndexes addIndexes:value];
//!Alert-putback!	[self didChangeValueForKey:@"filteredContentSelectionIndexes"];

	NSAssert([_filteredContentSelectionIndexes containsIndexes:value]==true, @"addObjectToSelection failed");
}

- (NSUInteger)indexOfOriginalObjectIdenticalTo:(id)value {

	NSUInteger i=0;
	for(  NodeProxy *ob in self.filteredContent ){
		if(ob.originalNode==value){
			return i;
		}
		i++;
	}
	return NSNotFound;
}

#pragma mark Accessor methods
- (void)setOriginalNode:(SHNode *)value {
	_originalNode = value;
	_filteredTreeNeedsMaking = YES;
}

- (NSMutableArray *)filteredContent {

	// lazily update the proxy tree when needed
	if(_filteredTreeNeedsMaking)
		[_filter makeFilteredTreeUpToDate:self];
	return _filteredContent;
}

- (NSMutableIndexSet *)indexesOfFilteredContent {
	// lazily update the proxy tree when needed
	if(_filteredTreeNeedsMaking)
		[_filter makeFilteredTreeUpToDate:self];
	return _indexesOfFilteredContent;
}

- (NSMutableIndexSet *)filteredContentSelectionIndexes {
	// lazily update the proxy tree when needed
	if(_filteredTreeNeedsMaking)
		[_filter makeFilteredTreeUpToDate:self];
	return _filteredContentSelectionIndexes;
}

- (void)setFilteredContentSelectionIndexes:(NSMutableIndexSet *)value {
	[NSException raise:@"when does this happen?" format:@""];
}

#pragma mark Indexed Accessor methods
- (NSUInteger)countOfFilteredContent {
    return [_filteredContent count];
}

- (id)objectInFilteredContentAtIndex:(NSUInteger)theIndex {
	NSParameterAssert([_filteredContent count]>theIndex);
	return [_filteredContent objectAtIndex:theIndex];
}

- (id)objectsInFilteredContentAtIndexes:(NSIndexSet *)theIndexes {
	return [_filteredContent objectsAtIndexes: theIndexes];
}

- (void)getFilteredContent:(id *)objsPtr range:(NSRange)range {
	
//!Alert-putback!    [_filteredContent getObjects:objsPtr range:range];
	[NSException raise:@"put back" format:@""];
}

- (void)insertObject:(id)obj inFilteredContentAtIndex:(NSUInteger)theIndex {

//!Alert-putback!	NSParameterAssert([_filteredContent containsObject:obj]==NO);
//!Alert-putback!    [_filteredContent insertObject:obj atIndex:theIndex];
	[NSException raise:@"put back" format:@""];
}

- (BOOL)hasChildren {
	
	return [self.filteredContent count]>0 ? YES : NO;
}

- (NodeProxy *)nodeProxyForNode:(id)value {

	if( _originalNode==value )
		return self;
	else {
		
		// lazily create the tree
		if(_filteredTreeNeedsMaking)
			[_filter makeFilteredTreeUpToDate:self];
		
		for( NodeProxy *each in _filteredContent ){
			NodeProxy *np = [each nodeProxyForNode:value];
			if(np!=nil)
				return np;
		}
	}
	return nil;
}

- (BOOL)containsObjectIdenticalTo:(NodeProxy *)value {
	
	if( self==value )
		return YES;
	else {
		for( NodeProxy *each in _filteredContent ){
			BOOL contains = [each containsObjectIdenticalTo:value];
			if(contains==YES)
				return YES;
			}
		}
	return NO;
}

/* Why isn't this method called -setSelectionIndexes:? Mostly to encourage a naming convention that's useful for a few reasons:
 
 NSObject's default implementation of key-value binding (KVB) uses key-value coding (KVC) to invoke methods like 
 -set<BindingName>: on the bound object when the bound-to property changes, to make it simple to support binding in
 the simple case of a view property that affects the way a view is drawn but whose value isn't directly manipulated by the user. 
 If NSObject's default implementation of KVB were good enough to use for this "selectionIndexes" property maybe 
 we _would_ implement a -setSelectionIndexes: method instead of stuffing so much code in -observeValueForKeyPath:ofObject:change:context: 
 down below (but it's not, because it doesn't provide a way to get at the old and new selection indexes when they change).
 So, this method isn't here to take advantage of NSObject's default implementation of KVB. It's here to centralize the 
 bindings work that must be done when the user changes the selection (check out all of the places it's invoked down below).
 Hopefully the different verb in this method name is a good reminder of the distinction.
 
 A person who assumes that a -set... method always succeeds, and always sets the exact value that was passed in 
 (or throws an exception for invalid values to signal the need for some debugging), isn't assuming anything unreasonable.
 Setters that invalidate that assumption make a class' interface unnecessarily unpredictable and hard to program against.
 Sometimes they require people to write code that sets a value and then gets it right back again to keep multiple copies
 of the value synchronized, in case the setting didn't "take." So, avoid that. When validation is appropriate don't put
 it in your setter. Instead, implement a separate validation method. Follow the naming pattern established by KVC's -validateValue:forKey:error: when applicable. 
 Now, _this_ method can't guarantee that, when it's invoked, an immediately subsequent invocation of -selectionIndexes will return the passed-in value. 
 It's supposed to set the value of a property in the bound-to object using KVC, but only after asking the bound-to object to validate the value.
 So, again, -setSelectionIndexes: wouldn't be a very good name for it.
 
 */
- (void)changeSelectionIndexes:(NSIndexSet *)indexes {
    
    // After all of that talk, this method isn't invoking -validateValue:forKeyPath:error:. It will, once we come up with an example of invalid selection indexes for this case. 
    
    // It will also someday take any value transformer specified as a binding option into account, so you have an example of how to do that.
	
    // Set the selection index set in the bound-to object (an array controller, in Sketch's case). The bound-to object is responsible for being KVO-compliant enough 
	// that all observers of the bound-to property get notified of the setting. Trying to set the selection indexes of a graphic view whose selection indexes aren't
	// bound to anything is a programming error.
  //  [_model setValue:indexes forKeyPath:@"selectionIndexes"];

	NSArray *proxiesOfObjectsToSelect = [self.filteredContent objectsAtIndexes:indexes];
	NSMutableArray *realNodes = [NSMutableArray arrayWithCapacity:[proxiesOfObjectsToSelect count]];
	for( NodeProxy *each in proxiesOfObjectsToSelect ){
		[realNodes addObject:each.originalNode];
	}
	[_originalNode setSelectedChildren:realNodes];

}

- (NSString *)debugNameString {
	
	NSString *debugNameString = [NSString stringWithFormat:@"%@ - %@", NSStringFromClass([_originalNode class]), [self name].value];
	return debugNameString;
}

- (NodeName *)name {
	return [_originalNode name];
}

//- (NodeProxy *)parent {
//	return _parent;
//}

@end
