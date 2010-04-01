//
//  AbtractModelFilter.m
//  BlakeLoader
//
//  Created by steve hooley on 01/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "AbtractModelFilter.h"
#import "NodeProxy.h"
#import <SHNodeGraph/SHNodeGraph.h>

@implementation AbtractModelFilter

#pragma mark -
#pragma mark property accessors
@synthesize model						= _model;
@synthesize registeredUsers				= _registeredUsers;
@synthesize rootNodeProxy = _rootNodeProxy, currentNodeProxy=_currentNodeProxy;

#pragma mark -
#pragma mark class methods
+ (NSString *)observationCntx {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}

+ (NSArray *)modelKeyPathsToObserve {
	return nil;
}

/* When the model changes, what would you like to get called? */
+ (SEL)selectorForWillChangeKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}
+ (SEL)selectorForChangedKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForWillInsertKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}
+ (SEL)selectorForInsertedKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForWillReplaceKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}
+ (SEL)selectorForReplacedKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}

+ (SEL)selectorForWillRemoveKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}
+ (SEL)selectorForRemovedKeyPath:(NSString *)keyPath {
	[NSException raise:@"Abstract method!" format:@"Abstract method!"];
	return nil; // COV_NF_LINE
}

+ (Class)nodeProxyClass {
	return [NodeProxy class];
}
#pragma mark init methods
	
- (id)init {
    
	self = [super init];
	if( self )
	{
		_registeredUsers = [[NSMutableArray array] retain];
		_wasCleaned = NO;
	}
	return self;
}

- (void)dealloc {
    
	if(_wasCleaned==NO){
		NSAssert(_wasCleaned==YES, @"clean up content filter before releasing");
	}
	NSAssert2([_registeredUsers count]==0, @"! unregister filter users before releasing! %i - %@", [_registeredUsers count], [_registeredUsers lastObject]);
    [_registeredUsers release];
    [super dealloc];
}

#pragma mark action methods
- (void)setOptions:(NSDictionary *)opts {
}

- (void)cleanUpFilter {

	NSAssert(_model!=nil, @"unnessasary clean up");
	[self stopObservingModel];
	self.currentNodeProxy = nil;
	[_rootNodeProxy release];
	_rootNodeProxy = nil;
	_model = nil;
    _wasCleaned = YES;
}

- (void)registerAUser:(id<SHContentProviderUserProtocol>)user {
    
    NSAssert1([_registeredUsers containsObject:user]==NO, @"cant register twice - %@", user);
    [_registeredUsers addObject:user];
    [user setFilter: self];
}

- (void)unRegisterAUser:(id<SHContentProviderUserProtocol>)user {
    
    NSAssert([_registeredUsers containsObject:user]==YES, @"can't remove phantom object");
    [user setFilter: nil];
    [_registeredUsers removeObjectIdenticalTo: user];
}

- (BOOL)hasUsers {
    return [_registeredUsers count]>0;
}

- (void)setModel:(SHNodeGraphModel *)value {
	
	NSParameterAssert(value!=nil);
	NSAssert(_model==nil, @"Filter cannot be reused with a different model");
	_model = value;
	_rootNodeProxy = [[[[self class] nodeProxyClass] makeNodeProxyWithFilter:self] retain];
	[_rootNodeProxy setOriginalNode: _model.rootNodeGroup];
	
	SHNode *currentNode = _model.currentNodeGroup;
	NSAssert(currentNode, @"need it");
	
	NodeProxy *proxyForCurrentNode = [_rootNodeProxy nodeProxyForNode:currentNode];
	NSAssert(proxyForCurrentNode, @"need it");
	
	
	self.currentNodeProxy = proxyForCurrentNode;

	// V2 way
	//-- fill in children of root proxy
	//V2
//doWeNeedToObserveEachProxy [_rootNodeProxy startObservingOriginalNode];
	
	//-- defer this
	//[self makeFilteredTreeUpToDate: _rootNodeProxy];
	// _rootNodeProxy.filteredTreeNeedsMaking = YES;

	[self startObservingModel];
}

- (void)startObservingModel {
	
	// we need -NSKeyValueObservingOptionPrior to send coalesced notifications BEFORE currentNode changes
	[_model addObserver:self forKeyPath:@"currentNodeGroup" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionPrior) context:@"AbstractModelFilter"]; // Are these options needed? ( | NSKeyValueObservingOptionOld )
}

- (void)stopObservingModel {
	
	NSAssert(_model!=nil, @"oops - need to stop at a different time");
	[_model removeObserver:self forKeyPath:@"currentNodeGroup"];
	[_rootNodeProxy stopObservingOriginalNode];
}

- (void)willBeginMultipleEdit {}
- (void)didEndMultipleEdit {}

- (BOOL)objectPassesFilter:(id)value {
	return YES;
}

// V1 used the NSKeyValueObservingOptionInitial property to make sure a whole tree was added when we added just one root node
// Unfortunately this had a funny side effect of notifications being received out of order
/*
	Super implementation just goes thru all nodes and calls objectPassesFilter
	so you must overide if you want inputs, outputs, etc
*/
- (void)makeFilteredTreeUpToDate:(NodeProxy *)value {
	
	NSAssert(value.filteredTreeNeedsMaking==YES, @"Node proxy doesnt need updating?");
	
	// to make sure this method isn't called recursively we must do this at the front rather than at the end
	value.filteredTreeNeedsMaking = NO;
	
	NSArray *newNodesInside = (NSArray *)value.originalNode.nodesInside;
	
	NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSet];
	NSMutableArray *matchedObjects = [NSMutableArray array];
	
	NSUInteger gindex=0;
	for( id addedObject in newNodesInside )
	{
		if([self objectPassesFilter:addedObject])
		{
			// check we haven't aleady dont this
			NSAssert([value nodeProxyForNode:addedObject]==nil, @"-makeFilteredTreeUpToDate: about to add a node that the proxy already has..");
			
			[newIndexes addIndex: gindex];
			NodeProxy *makeNodeProxy = [NodeProxy makeNodeProxyWithFilter:self object:addedObject];
			
			// -- defer this
			// [self makeFilteredTreeUpToDate:makeNodeProxy];
			// makeNodeProxy.filteredTreeNeedsMaking = YES;
			
			[matchedObjects addObject: makeNodeProxy]; /* make a proxy here, observe the content if it is a group */
			
			// V2 - important that we DO NOT use NSKeyValueObservingOptionInitial 
			//doWeNeedToObserveEachProxy if([makeNodeProxy.originalNode allowsSubpatches])
			//doWeNeedToObserveEachProxy [makeNodeProxy startObservingOriginalNode];
		}
		gindex++;
	}
	
	/* add the Proxies of the children that we observed were added - tree is up-to-date! */
	value.indexesOfFilteredContent = newIndexes;
	value.filteredContent = matchedObjects;
}

#pragma mark notification methods
- (void)currentNodeGroupWillChange {
	
}

- (void)currentNodeGroupDidChange:(id)newValue {
	
	// must trigger kvo
	BOOL objectPassesFilter = [self objectPassesFilter:newValue];
	if(objectPassesFilter) {
		NodeProxy *newProxy = [self nodeProxyForNode:newValue];
		NSAssert(newProxy, @"eh?");
		self.currentNodeProxy = newProxy;
	} else {
		self.currentNodeProxy = nil;
	}
	NSAssert( objectPassesFilter ? _currentNodeProxy!=nil : _currentNodeProxy==nil, @"should only be nil if model's currentNode is nil" );
}

/* 
	Observe changes to the models CurrentNode and keep our currentNodeProxy in sync
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
	
	NSNumber *isPrior = [change objectForKey:NSKeyValueChangeNotificationIsPriorKey];
	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
	id changeKind = [change objectForKey:NSKeyValueChangeKindKey];

	if( [context isEqualToString:@"AbstractModelFilter"] )
	{
		if([keyPath isEqualToString:@"currentNodeGroup"])
		{
			if(isPrior){
				[self currentNodeGroupWillChange];
			} else {
				switch ([changeKind intValue]) 
				{
					case NSKeyValueChangeSetting:
						[self currentNodeGroupDidChange:newValue];
						break;
					case NSKeyValueChangeRemoval:
					case NSKeyValueChangeReplacement:
					case NSKeyValueChangeInsertion:
					default:
						[NSException raise:@"current node changed?" format:@"current node changed?"];
				}	
			}
		}
	} else {
		[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:context];
	}
}

// COV_NF_START
- (void)modelObject:(NodeProxy *)proxy willChangeTo:(id)newValue from:(id)oldValue forKeyPath:(NSString *)keyPath {

	SEL sel = [[self class] selectorForWillChangeKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, newValue, oldValue );	// to return an object simply do -  id p = (f)( self, sel, newValue );
}

- (void)modelObject:(NodeProxy *)proxy changedTo:(id)newValue from:(id)oldValue forKeyPath:(NSString *)keyPath {

	SEL sel = [[self class] selectorForChangedKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, newValue, oldValue );	// to return an object simply do -  id p = (f)( self, sel, newValue );
}

- (void)modelObject:(NodeProxy *)proxy willInsert:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath {

	SEL sel = [[self class] selectorForWillInsertKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, newValue, changeIndexes );
}

- (void)modelObject:(NodeProxy *)proxy inserted:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath {
	
	SEL sel = [[self class] selectorForInsertedKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, newValue, changeIndexes );
}

- (void)modelObject:(NodeProxy *)proxy willReplace:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath {
	
	SEL sel = [[self class] selectorForWillReplaceKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, oldValue, newValue, changeIndexes );
}

- (void)modelObject:(NodeProxy *)proxy replaced:(id)oldValue with:(id)newValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath {
	
	SEL sel = [[self class] selectorForReplacedKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, oldValue, newValue, changeIndexes );
}

- (void)modelObject:(NodeProxy *)proxy willRemove:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath {

	SEL sel = [[self class] selectorForWillRemoveKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, oldValue, changeIndexes );
}

- (void)modelObject:(NodeProxy *)proxy removed:(id)oldValue atIndexes:(NSIndexSet *)changeIndexes forKeyPath:(NSString *)keyPath {
	
	SEL sel = [[self class] selectorForRemovedKeyPath:keyPath];
	IMP f = [self methodForSelector:sel];
	(f)( self, sel, proxy, oldValue, changeIndexes );
}
// COV_NF_END

- (NodeProxy *)nodeProxyForNode:(id)value {
	return [_rootNodeProxy nodeProxyForNode:value];
}

- (void)setCurrentNodeProxy:(NodeProxy *)nodeProxy {
	
	//doWeNeedToObserveEachProxy
	if([_currentNodeProxy.originalNode allowsSubpatches]){
		[_currentNodeProxy stopObservingOriginalNode];
	}
	_currentNodeProxy = nodeProxy;

	//doWeNeedToObserveEachProxy
	/*	This is experimental - not sure why we need to observe each node - if it turns out that we do then REMOVE this
	 and reaneable lines marked //doWeNeedToObserveEachProxy
	 */
	if([_currentNodeProxy.originalNode allowsSubpatches]){
		[_currentNodeProxy startObservingOriginalNode];
		
	}
	/* send our custom notification */
	
}

@end
