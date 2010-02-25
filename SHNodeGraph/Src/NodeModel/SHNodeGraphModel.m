//
//  SHNodeGraphModel.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNodeGraphModel.h"
#import "SHNode.h"
#import "SHConnectableNode.h"
#import <ProtoNodeGraph/SHChildContainer.h>
#import <ProtoNodeGraph/SHParent_Selection.h>
#import "SHContentProvidorProtocol.h"
#import "SHContentProvidorProtocol.h"
#import "SHNodeSelectingMethods.h"

//!Alert-putback!#import "SHFScriptNodeGraphLoader.h"
//!Alert-putback!#import "NodeGraphLoaderProtocol.h"
//!Alert-putback!#import "SHNodeGraphScheduler.h"
//!Alert-putback!#import "SHNodeSelectingMethods.h"
//!Alert-putback!#import "XMLSavingNode.h"
//!Alert-putback!#import <SHShared/SHSwizzler.h>

#pragma mark -
@interface SHNodeGraphModel (PrivateMethods)

// + (int)uniqueIDTracker;
// + (void)setUniqueIDTracker:(int)anUniqueIDTracker;

@end


#pragma mark -
@implementation SHNodeGraphModel (PrivateMethods)

// + (int)uniqueIDTracker { return uniqueIDTracker; }

// + (void)setUniqueIDTracker:(int)anUniqueIDTracker {
//	uniqueIDTracker = anUniqueIDTracker;
//}

@end

#pragma mark -
@implementation SHNodeGraphModel

@synthesize rootNodeGroup = _rootNodeGroup;
@synthesize currentNodeGroup = _currentNodeGroup;
@synthesize undoManager=_undoManager;
@synthesize contentFilters = _contentFilters;

#pragma mark -
#pragma mark class methods

+ (id)makeEmptyModel {
	return [[[SHNodeGraphModel alloc] initEmptyModel] autorelease];
}

#pragma mark init methods
- (id)initEmptyModel {

	self = [self init];
	if(self)
	{	
		_rootNodeGroup = [[SHNode makeChildWithName:@"root"] retain];
		_rootNodeGroup.nodeGraphModel = self;
		_currentNodeGroup = _rootNodeGroup;
		
//!Alert-putback!		int UID = [SHNodeGraphModel getNewUniqueID];
//!Alert-putback!		newRoot.temporaryID = UID;
	}
	return self;
}

- (id)init {

	self = [super init];
	if(self)
	{
		_undoManager = [[NSUndoManager alloc] init];
//!Alert-putback!		self.savingAndLoadingDelegate = [SHFScriptNodeGraphLoader nodeGraphLoader];
//!Alert-putback!		self.scheduler = [SHNodeGraphScheduler scheduler];
//!Alert-putback!		NSAssert(_scheduler!=nil, @"scheduler init failed");
//!Alert-putback!		NSAssert(_savingAndLoadingDelegate!=nil, @"savingAndLoadingDelegate init failed");
//!Alert-putback!		

		_contentFilters = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc  {

	[_contentFilters release];
    [_rootNodeGroup release];

//!Alert-putback!	[_scheduler release];
//!Alert-putback!    [_savingAndLoadingDelegate release];
	[self replaceUndomanager:nil];
	
	[super dealloc];
}

#pragma mark Filter Methods
/*
 * it would be good if in the future we could make a single filter class
 * that could be set to filter different types of node - therfore you
 * could add it multiple times - all this will need to be reworked though… 
 */
- (void)registerContentFilter:(Class)filterClass andUser:(id <SHContentProviderUserProtocol>)user options:(NSDictionary *)optValues {
    
    NSParameterAssert(filterClass!=nil);
    NSParameterAssert(user!=nil);
	
    id <SHContentProvidorProtocol>aContentFilter = nil;
    NSArray *filters = [_contentFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", filterClass]];
    if([filters count]==0)
    {
        aContentFilter = [[[filterClass alloc] init] autorelease];
		if(optValues)
			[aContentFilter setOptions:optValues];
		
        [_contentFilters addObject:aContentFilter];
        //-- filter doesnt retain us
        [aContentFilter setModel:self];
    } else {
        NSAssert([filters count]==1, @"should not be more than 1 instance of a particular filter");
        aContentFilter = [filters lastObject];
    }
    [aContentFilter registerAUser:user];
}

- (void)unregisterContentFilter:(Class)filterClass andUser:(id <SHContentProviderUserProtocol>)user options:(NSDictionary *)optValues {
	
    NSParameterAssert(filterClass!=nil);
    NSParameterAssert(user!=nil);
    NSArray *filters = [_contentFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", filterClass]];
    NSAssert([filters count]==1, @"cant unregister filter");
    AbtractModelFilter *aContentFilter = [filters lastObject];
    [aContentFilter unRegisterAUser:user];
    if([aContentFilter hasUsers]==NO){
        [aContentFilter cleanUpFilter];
        [_contentFilters removeObjectIdenticalTo: aContentFilter];
    } else {
		logWarning(@"Filter had multiplke users.. Removing a a USER but not cleaning up");
	}
}

#pragma mark SUPER *NEW* action methods

//NotReady- (void)NEW_addChildren:(NSArray *)children toNode:(SHNode *)targetNode atIndexes:(NSIndexSet *)indexes {
//NotReady
//NotReady	if(targetNode!=_rootNodeGroup && [targetNode isNodeParentOfMe:_rootNodeGroup]==NO){
//NotReady		logError(@"why are we asking this document too do this when this node isnt a child?");
//NotReady		NSException* myException = [NSException exceptionWithName:@"WrongDoc" reason:@"child is not in this doc!" userInfo:nil];
//NotReady		@throw myException;
//NotReady	}
//NotReady	// inputs have a order outputs have an order, nodes have an order, interconnectors have an order - 	
//NotReady	// There is no sense of an order of all children
//NotReady	BOOL success = [targetNode addChildNodes:children atIndexes:indexes autoRename:YES];
//NotReady	if(!success){
//NotReady		logError(@"ERROR - failed to add Node");
//NotReady	}
//NotReady}

- (void)NEW_addChild:(id)newchild atIndex:(NSInteger)nindex {
	[self NEW_addChild:newchild toNode:_currentNodeGroup atIndex:nindex];
}

- (void)NEW_addChild:(id)newchild toNode:(SHNode *)targetNode atIndex:(NSInteger)nindex {
	
	NSParameterAssert( newchild!=nil );
	NSParameterAssert( [targetNode isKindOfClass:[SHNode class]] );
	NSAssert(targetNode==_currentNodeGroup, @"if we stick with this v2 stuff obviously we can change the interface but lets just get it working for now");

	if(targetNode!=_rootNodeGroup && [targetNode isNodeParentOfMe:_rootNodeGroup]==NO){
		logError(@"why are we asking this document too do this when this node isnt a child?");
		[NSException raise:@"WrongDoc" format:@"child is not in this doc!"];
	}
	// inputs have an order, outputs have an order, nodes have an order, interconnectors have an order - 	
	// There is no sense of an order of all children
	BOOL success = [targetNode addChild:newchild atIndex:nindex autoRename:YES undoManager:_undoManager];
	NSAssert(success, @"ERROR - failed to add Node");
}

- (void)NEW_addChild:(id)newchild toNode:(SHNode *)targetNode {
	
	NSParameterAssert( newchild!=nil );
	NSParameterAssert( [targetNode isKindOfClass:[SHNode class]] );
	NSAssert(targetNode==_currentNodeGroup, @"if we stick with this v2 stuff obviously we can change the interface but lets just get it working for now");

	if(targetNode!=_rootNodeGroup && [targetNode isNodeParentOfMe:_rootNodeGroup]==NO){
		logError(@"why are we asking this document too do this when this node isnt a child?");
		[NSException raise:@"WrongDoc" format:@"child is not in this doc!"];
	}
	BOOL success = [targetNode addChild:newchild autoRename:YES undoManager:_undoManager];
	NSAssert(success, @"ERROR - failed to add Node");
}

// just add the undoManager into the mix
- (SHInterConnector *)connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att2 {
	return [_currentNodeGroup connectOutletOfAttribute:att1 toInletOfAttribute:att2 undoManager:_undoManager];
}

- (void)insertGraphics:(NSArray *)graphics atIndexes:(NSIndexSet *)indexes {
	
	NSParameterAssert(graphics!=nil);
	NSParameterAssert([graphics count]>0);
	NSAssert(_currentNodeGroup!=nil, @"not ready to insert into _rootNodeGroup");
	int countOfCurrentObjects = [[_currentNodeGroup->_childContainer _targetStorageForObject:[graphics lastObject]] count];
	NSParameterAssert([indexes lastIndex]<(countOfCurrentObjects + [graphics count]));
	[_currentNodeGroup addItemsOfSingleType:graphics atIndexes:indexes undoManager:_undoManager];
}

- (void)_addChildrenToSelection:(NSArray *)arrayValue inNode:(SHNode *)node {
	
	NSParameterAssert(node);
	[node addChildrenToSelection:arrayValue];
}

- (void)_removeChildrenFromSelection:(NSArray *)arrayValue inNode:(SHNode *)node {
	
	NSParameterAssert(node);
	[node removeChildrenFromSelection:arrayValue];
}

- (void)addChildrenToCurrentSelection:(NSArray *)arrayValue {
	
	NSParameterAssert([arrayValue count]);
	[self _addChildrenToSelection:arrayValue inNode:_currentNodeGroup];
}

- (void)removeChildrenFromCurrentSelection:(NSArray *)arrayValue {

	NSParameterAssert([arrayValue count]);
	[self _removeChildrenFromSelection:arrayValue inNode:_currentNodeGroup];
}

- (void)willBeginMultipleEdit {
	[_contentFilters makeObjectsPerformSelector:@selector(willBeginMultipleEdit)];
}
- (void)didEndMultipleEdit {
	[_contentFilters makeObjectsPerformSelector:@selector(didEndMultipleEdit)];
}

- (void)deleteChildren:(NSArray *)arrayValue fromNode:(SHNode *)targetNode {

	[self willBeginMultipleEdit];
	
	NSAssert(targetNode==_currentNodeGroup, @"if we stick with this v2 stuff obviously we can change the interface but lets just get it working for now");
	[targetNode deleteChildren:arrayValue undoManager:_undoManager];
	
	[self didEndMultipleEdit];
}

//!Alert-putback!- (BOOL)isEquivalentTo:(SHNodeGraphModel *)value {
//!Alert-putback!	BOOL isSame = NO;
//!Alert-putback!	if([_rootNodeGroup class]==[[value rootNodeGroup] class])
//!Alert-putback!		isSame = [_rootNodeGroup isEquivalentTo:[value rootNodeGroup]];
//!Alert-putback!	return isSame;
//!Alert-putback!}

- (void)removeGraphicsAtIndexes:(NSIndexSet *)indexes {
	
	NSParameterAssert([indexes count]>0);
	NSParameterAssert([indexes lastIndex]<[_currentNodeGroup.nodesInside count]);
	
    // Do the actual removal. - do we sneed to use an indexed accessor?
	NSArray *allNodes = [_currentNodeGroup.nodesInside array];
	NSArray *nodesToDelete = [allNodes objectsAtIndexes:indexes];
	
    [self deleteChildren:nodesToDelete fromNode:_currentNodeGroup];
}

- (void)removeGraphicAtIndex:(NSUInteger)gindex {
	
	NSParameterAssert(gindex<[_currentNodeGroup.nodesInside count]);
	[_currentNodeGroup deleteChild:[_currentNodeGroup nodeAtIndex:gindex] undoManager:_undoManager];
}

/* Reorder a child node */
- (void)add:(int)amountToMove toIndexOfChild:(id)aChild {
	
	NSParameterAssert(aChild!=nil);
	NSObject<ChildAndParentProtocol> *prnt = [aChild parentSHNode];
	NSAssert(prnt!=nil, @"Must have a parent to move up and down in");
	NSAssert(prnt==_currentNodeGroup, @"if we stick with this v2 stuff obviously we can change the interface but lets just get it working for now");
	int currentIndex = [prnt indexOfChild:aChild];
	int newIndex = currentIndex + amountToMove;
	[prnt setIndexOfChild:aChild to:newIndex undoManager:_undoManager];
}

// like dragging rows in a tableview
- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)value {
	[_currentNodeGroup moveChildren:children toInsertionIndex:value undoManager:_undoManager];
}


- (void)changeNodeSelectionTo:(NSIndexSet *)value {
	
	NSParameterAssert(value!=nil);
	NSParameterAssert([value lastIndex]==NSNotFound || [value lastIndex]<[[_currentNodeGroup nodesInside] count]);
	[_currentNodeGroup setSelectedNodesInsideIndexes:[[value mutableCopy] autorelease]];
}

#pragma mark action methods


//- (SHNode *)newFirstLevelNode {
//	return [self newFirstLevelNodeWithName:@"empty group"];
//}
//
//
//- (SHNode *)newEmptyNodeInCurrentNode {
//	return [self makeEmptyNodeInCurrentNodeWithName:@"empty group"];
//}
//

//- (SHNode *)newFirstLevelNodeWithName:(NSString *)aName
//{
//	Class nodeClass	= NSClassFromString( @"SHNode" );
//	id aNode = [[[nodeClass alloc] init] autorelease];
//	BOOL flag = [self isfirstLevelNodeNameTaken:aName];
//	if(flag)
//		aName=[self nextUniqueRootNameBasedOn:aName];
//	[(SHNode*)aNode setName:aName];
//	// logInfo(@"new retain count is %i",[aNode retainCount] );
//	[self addNodeToFirstLevel:aNode];
//	return aNode;
//}


- (SHNode *)makeEmptyNodeInCurrentNodeWithName:(NSString *)aName {

	SHNode *aNode=[SHNode makeChildWithName:aName];
	[self NEW_addChild:aNode toNode:_currentNodeGroup];
	return aNode;
}


//!Alert-putback!- (SHNode *)makeEmptyNodeInNode:(SHNode *)parentNode withName:(NSString *)aName {
//!Alert-putback!	SHNode *aNode=[SHNode newNode];
//!Alert-putback!	[aNode setName:aName];
//!Alert-putback!	[self NEW_addChild:aNode toNode:parentNode];
//!Alert-putback!	return aNode;
//!Alert-putback!}

//- (void)addNodeToFirstLevel:(SHNode *)aNode
//{
////	logInfo(@"retain count is %i",[aNode retainCount] );
//	NSString* aName = [aNode name];
//	if(aName==nil){
//		logInfo(@"SHNodeGraphModel.m: Error: trying to insert a root node with nil name");
//		NSString* newName = @"empty group";
////t		BOOL flag = [self isfirstLevelNodeNameTaken:newName];
////t		if(flag)
////t			newName = [self nextUniqueRootNameBasedOn:newName];
//		[aNode setName:newName];
//		aName = [aNode name]; /* in theory the node can not have a nil name now */
//	}
//	
//	if(![aNode isKindOfClass:[SHNode class]]){
//		NSException* myException = [NSException exceptionWithName:@"WrongTypeOfNodeException" reason:@"Wrong Type Of Node" userInfo:nil];
//		[myException raise];
//	}
//	if(aNode==nil){
//		NSException* myException = [NSException exceptionWithName:@"CantInsertNilNode" reason:@"Cant Insert Nil Node As Root" userInfo:nil];
//		[myException raise];
//	}	
////e	[aNode setTemporaryID: [SHNodeGraphModel getNewUniqueID] ];	
//	
//	// logInfo(@"SHNodeGraphModel.m: addRootNode %@ for key %@",aNode,aName );
//	// Branch NSString* UIDasARString = [NSString stringWithFormat:@"%i", [aNode temporaryID] ];
//
//	// if a previous root node exists with this name we replace it
////	SHNode* existingNode = [_rootNodeGroup childWithKey:aName];
////	if(existingNode!=nil){
////		NSString *newName = [_rootNodeGroup nextUniqueChildNameBasedOn:aName];
////		[aNode setName:newName];
////	//	[_rootNodeGroup deleteChildNode:existingNode];
////		logInfo(@"SHNodeGraphModel.m: CONFLICT! allready one with that name so removing it" );
////	}
//	[_rootNodeGroup addChild:aNode forKey:aName autoRename:YES];
//
//	// important - nodes get their temporary ids when they are added to a nodegroup.
//	// As root nodes don't live inside a node group we must asign them a uid manually
//	// [self setCurrentNodeGroup:aNode];
//}
//
//
//- (void)addNodeToCurrentNode:(id<SHNodeLikeProtocol>)aNode
//{
//	NSString* aName = [aNode name];
//	[_currentNodeGroup addChild:aNode forKey:aName autoRename:YES];
//}
//
//- (BOOL)closeFirstLevelNode:(SHNode *)aNode
//{
//	return [_rootNodeGroup deleteChildNode:aNode];
//}
//
//- (void)deleteAllSelectedFromCurrentNodeGroup 
//{
//	[_currentNodeGroup deleteSelectedChildren];
//	[_currentNodeGroup deleteSelectedInterConnectors];
//} 


- (void)moveUpAlevelToParentNodeGroup {

	NSObject<ChildAndParentProtocol> *parentNodeGroup = [_currentNodeGroup parentSHNode];
	if( parentNodeGroup!=nil && [parentNodeGroup isKindOfClass:[SHNode class]])
	{
		SHNode *temp = (SHNode *)parentNodeGroup;
		[_currentNodeGroup clearSelectionNoUndo];	// forget the selection status - makes it easier for the views	/* Not Undoable */
		[self setCurrentNodeGroup: temp];
	} else {
		logError(@"SHNodeGraphModel.m: CANT MOVE UP A LEVEL, PARENT NODE GROUP IS %@", parentNodeGroup);
	}
}

- (void)moveDownALevelIntoNodeGroup:(SHNode *)aNodeGroup {

	if([_currentNodeGroup isChild:aNodeGroup]==YES)
	{
		if(aNodeGroup!=nil && [aNodeGroup isKindOfClass:[SHNode class]] && [aNodeGroup allowsSubpatches])
		{
			[_currentNodeGroup clearSelectionNoUndo];	// forget the selection status - makes it easier for the views	/* Not Undoable */

			[self setCurrentNodeGroup: aNodeGroup];
		}
	}
}

//- (void)selectNodeAtPath:(NSString *)thePathOfANode
//{
//	NSArray* pathComponents = [thePathOfANode pathComponents];
//	int count = [pathComponents count];
//	id nodeToSelect = [_currentNodeGroup childWithKey:[pathComponents objectAtIndex:count-1]];	// objectAtIndex:0 == '/'
//	if(nodeToSelect!=nil)
//	{
//		id parent = [nodeToSelect parentSHNode];
//		[parent unSelectAllChildNodes];
//		[parent addChildToSelection:nodeToSelect];
//	}	
//}

//- (NSXMLDocument *)xmlRepresentation
//{
//	NSXMLElement *rootxml = [_rootNodeGroup xmlRepresentation];
//	NSXMLDocument *xmlDoc = [[NSXMLDocument alloc] initWithRootElement:rootxml];
//	[xmlDoc setVersion:@"1.0"];
//	[xmlDoc setCharacterEncoding:@"UTF-8"];
//	[rootxml addChild:[NSXMLNode commentWithStringValue:@"Hello world!"]];
//	return xmlDoc;
//}

- (BOOL)saveNode:(SHNode *)aNode toFile:(NSString *)file {

	if(aNode==nil)
		aNode = _rootNodeGroup;
	NSAssert(_savingAndLoadingDelegate, @"cant save without a delegate");
	BOOL result = [_savingAndLoadingDelegate saveNode:aNode toFile:file];
	return result;
}

- (SHNode *)loadNodeFromFile:(NSString *)file {

	SHNode *result = [_savingAndLoadingDelegate loadNodeFromFile:file];
	return result;
}

//!Alert-putback!- (NSXMLElement *)fScriptWrapperFromChildren:(NSArray *)childrenToCopy fromNode:(SHNode *)parentNode {
//!Alert-putback!
//!Alert-putback!	NSXMLElement* result = [_savingAndLoadingDelegate scriptWrapperFromChildren:childrenToCopy fromNode:parentNode];
//!Alert-putback!	return result;
//!Alert-putback!}

//!Alert-putback!- (BOOL)unArchiveChildrenFromFScriptWrapper:(NSXMLElement *)copiedStuffWrapper intoNode:(SHNode *)parentNode {
//!Alert-putback!
//!Alert-putback!	BOOL result = [_savingAndLoadingDelegate unArchiveChildrenFromScriptWrapper:copiedStuffWrapper intoNode:parentNode];
//!Alert-putback!	return result;
//!Alert-putback!}

#pragma mark accessor methods

//!Alert-putback!@synthesize savingAndLoadingDelegate=_savingAndLoadingDelegate;
//!Alert-putback!@synthesize scheduler=_scheduler;

- (void)setCurrentNodeGroup:(SHNode *)aNodeGroup {

	if( _currentNodeGroup!=aNodeGroup) 
	{
		if([SHNodeGraphModel isValidCurrentNode:aNodeGroup]==NO){
			logInfo(@"Not setting current node");
			return;
		}
		id oldCurrentNode = _currentNodeGroup;
		_currentNodeGroup = aNodeGroup;
		if(oldCurrentNode){
			[_undoManager beginUndoGrouping];
				if(![_undoManager isUndoing])
					[_undoManager setActionName:@"set current level"];
				[[_undoManager prepareWithInvocationTarget:self] setCurrentNodeGroup:oldCurrentNode];
			[_undoManager endUndoGrouping];
		}
	} else {
		logWarning(@"SHNodeGraphModel.m: Cant set currentNode. That Node is already current ()", [aNodeGroup name]);
	}
}

- (void)setRootNodeGroup:(SHNode *)aNode {

	if (_rootNodeGroup != aNode) {
		[_rootNodeGroup release];
		_rootNodeGroup = [aNode retain];
		_rootNodeGroup.nodeGraphModel = self;
		[self setCurrentNodeGroup:_rootNodeGroup];
	}
}

- (NSArray *)allChildrenFromCurrentNode {
	return [self allChildrenFromNode:_currentNodeGroup];
}

- (NSArray *)allChildrenFromNode:(SHNode *)aNode {
	
	NSArray *immutableArray = [NSArray arrayWithArray:(NSArray *)[aNode allChildren]];
	return immutableArray;
}

//!Alert-putback!- (NSArray *)allSelectedChildrenFromNode:(SHNode *)aNode {
//!Alert-putback!	return [aNode selectedChildren];
//!Alert-putback!}

- (NSArray *)_allSelectedChildrenFromNode:(SHNode *)value {
	return [value selectedChildren];
}

- (NSArray *)allSelectedChildrenFromCurrentNode {

	return [self _allSelectedChildrenFromNode: _currentNodeGroup];
}

//- (SHNode*)firstLevelNodeWithKey:(NSString*)aName
//{
//	return [_rootNodeGroup childWithKey:aName];
//}

//- (void)setCurrentNodeGroupToNodeAtPath:(NSString *)thePathOfANode
//{
//	NSArray* pathComponents = [thePathOfANode pathComponents];
//	int count = [pathComponents count];
//	int i;
//	// [0] = /
//	// [1] = root
//		
//	// set the current node to be the parent of the double clicked node
//	SHNode* parentNode = (SHNode*)[self rootNodeGroup];
//	if(parentNode!=nil && [[parentNode name] isEqualToString:[pathComponents objectAtIndex:1]])
//	{
//		// logInfo(@"SHNodeGraphModel.m: count of children in root is: %i", [parentNode countOfChildren] );
//
//		for(i=2;i<count;i++)
//		{
//			parentNode = (SHNode*)[parentNode childWithKey:[pathComponents objectAtIndex:i]];	// objectAtIndex:0 == '/'
//			if(parentNode==nil)
//			{
//				logInfo(@"SHNodeGraphModel.m: ERROR! No Child Node Named %@ in node %@", [pathComponents objectAtIndex:i],[pathComponents objectAtIndex:i-1]);
//				return;
//			}
//		}
//		[self setCurrentNodeGroup:parentNode];
//		// logInfo(@"SHNodeGraphModel.m: setting current node to %@", parentNode);
//
//	} else {
//		logInfo(@"SHNodeGraphModel.m: ERROR! No Root Node Named %@", [pathComponents objectAtIndex:1]);
//		return;
//	}
//	// select the double clicked node
////	NSString* nodeToSelectName = [pathComponents objectAtIndex:count-1];
////	SHNode* childNode = (SHNode*)[parentNode childWithKey:nodeToSelectName];
////	[parentNode unSelectAllChildren];
////	[(SHSelectableProto_Node*)childNode select];
//}


//- (BOOL)isfirstLevelNodeNameTaken:(NSString*)rootName
//{
//	if([self firstLevelNodeWithKey:rootName]==nil)
//		return NO;
//	return YES;
//}

//- (NSString*)nextUniqueRootNameBasedOn:(NSString*)rootName
//{
//	int i=1;
//	while([self isfirstLevelNodeNameTaken:rootName]) {
//		// is there already a number at the end of the string?
//		rootName = [rootName stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]];
//		// logInfo(@"SHNode.m: setName bailing as node name not unique");
//		rootName = [NSString stringWithFormat:@"%@%i", rootName, i ];
//		i++;
//	}
//	return rootName;
//}

- (BOOL)weHaveSelectedNodesOrAttributesOrICs {

	return [_currentNodeGroup hasSelection];
}

+ (BOOL)isValidCurrentNode:(id)value {
	
	if([value respondsToSelector:@selector(allowsSubpatches)]==FALSE)
		return NO;
	return [value allowsSubpatches];
}

- (BOOL)currentNodeGroupIsValid {

	return [SHNodeGraphModel isValidCurrentNode:_currentNodeGroup];
}

- (void)replaceUndomanager:(NSUndoManager *)value {
	
	if(value!=_undoManager) {
		[_undoManager removeAllActions];
		[_undoManager release];
		_undoManager = [value retain];
	}
}

#pragma mark notification methods
// notifications are bullshit - do not use - user must remove itself from nc before node is removed
//- (void)postSHNodeMadeCurrent_Notification:(id)aNode
//{
//	NSDictionary* d = nil;
//	if(aNode==nil){
//		d = nil;
//	} else {
//		d = [NSDictionary dictionaryWithObject:aNode forKey:@"theNode"];
//	}
//	NSNotification *n = [NSNotification notificationWithName:@"SHNodeMadeCurrent" object:self userInfo:d];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ]; // could post when idle
//}

//- (BOOL) isRootNode:(SHNode*)aNode 
//{
//	NSEnumerator *enumerator1 = [_rootNodeGroups objectEnumerator];
//	id node;
//	while ((node = [enumerator1 nextObject])) 
//	{
//		if(node==aNode)
//			return YES;
//	}
//	return NO;
//}



@end
