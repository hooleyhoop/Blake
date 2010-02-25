//
//  SHNode.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 09/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "Nodegraph_defs.h"
#import "SHNode.h"

//!Alert-putback!#import "SHNodePrivateMethods.h"
//!Alert-putback!#import "SHNodeAttributeMethods.h"
//!Alert-putback!#import "SHNodeGraphModel.h"
#import "SHOutputAttribute.h"
#import "SHInputAttribute.h"
#import "SHInterConnector.h"
//!Alert-putback!#import "SHConnectlet.h"
//!Alert-putback!#import "SHConnectableNode.h"
//!Alert-putback!#import "SHNodeSelectingMethods.h"
//!Alert-putback!#import "SHConnectableNode.h"
//!Alert-putback!#import "SH_Path.h"
#import "SHCustomMutableArray.h"
//!Alert-putback!#import <SHShared/NSCharacterSet_Extensions.h>
//!Alert-putback!#import <SHShared/SHOrderedDictionary.h>
#import <ProtoNodeGraph/SHParent_Selection.h>
#import <ProtoNodeGraph/SHParent.h>
#import <ProtoNodeGraph/SHChildContainer.h>

//!Alert-putback!BOOL indexPathArraysAreEqual( NSArray* indexPathArray, NSArray* anotherArray )
//!Alert-putback!{
//!Alert-putback!	int i, c = [indexPathArray count];
//!Alert-putback!	if(c == [anotherArray count]){
//!Alert-putback!		for(i=0;i<c;i++){
//!Alert-putback!			if([(NSString *)[indexPathArray objectAtIndex:i] isEqualToString: (NSString *)[anotherArray objectAtIndex:i]] == NO)
//!Alert-putback!				return NO;
//!Alert-putback!		}
//!Alert-putback!		return YES;
//!Alert-putback!	}
//!Alert-putback!	return NO;
//!Alert-putback!}


@implementation SHNode

//!Alert-putback!@synthesize evaluationInProgress=_evaluationInProgress;
//!Alert-putback!@synthesize absolutePath=_absolutePath;
@synthesize allowsSubpatches=_allowsSubpatches;
@synthesize allChildren=_allChildren;


/* Defined in child */
//!Alert-putback!@dynamic temporaryID;
//!Alert-putback!@dynamic parentSHNode;
//!Alert-putback!@dynamic nodeGraphModel;
//!Alert-putback!@dynamic operatorPrivateMember;

#pragma mark -
#pragma mark class methods
+ (void)sortChildrenByType:(NSArray *)children :(NSMutableSet **)nodesSetPtr :(NSMutableSet **)inputsSetPtr :(NSMutableSet **)outputsSetPtr :(NSMutableSet **)icSetPtr {

	for( id child in children )
	{
		if([child isKindOfClass:[SHNode class]]){
			if(*nodesSetPtr==nil)
				*nodesSetPtr = [NSMutableSet set];
			[*nodesSetPtr addObject:child];
			
		} else if([child isKindOfClass:[SHOutputAttribute class]]){
			if(*outputsSetPtr==nil)
				*outputsSetPtr = [NSMutableSet set];
			[*outputsSetPtr addObject:child];
			
		} else if([child isKindOfClass:[SHInputAttribute class]]){
			if(*inputsSetPtr==nil)
				*inputsSetPtr = [NSMutableSet set];
			[*inputsSetPtr addObject:child];
			
		} else if([child isKindOfClass:[SHInterConnector class]]){
			if(*icSetPtr==nil)
				*icSetPtr = [NSMutableSet set];
			[*icSetPtr addObject:child];
		} else {
			[NSException raise:@"Inknown Type - cant sort" format:@"%@", child];
		}
	}
}

//!Alert-putback!+ (NSString *)pathWhereResides{ return @"/SHBasic";}

//!Alert-putback!+ (id)newNode {
//!Alert-putback!	return [[[self alloc] init] autorelease];
//!Alert-putback!}

/* KVO for allChildren should be triggered when.. */
//!Alert-putback!#ifdef USE_AUTO_BINDING
//!Alert-putback!+ (NSSet *)keyPathsForValuesAffectingAllChildren {
//!Alert-putback!
//!Alert-putback!    return [NSSet setWithObjects:
//!Alert-putback!		@"nodesInside.array", 
//!Alert-putback!		@"inputs.array",
//!Alert-putback!		@"outputs.array",
//!Alert-putback!		@"shInterConnectorsInside.array", 
//!Alert-putback!		nil];
//!Alert-putback!}
//!Alert-putback!#endif

#pragma mark init methods
- (id)init {
	self=[super init];
	if( self )
	{
		_allowsSubpatches = YES;



//!Alert-putback!		_previousFrameKey = 0;

//!Alert-putback!		_evaluationInProgress = NO;
		
	////15/05/06		_auxiliaryData		= [[NSMutableDictionary dictionaryWithCapacity:1] retain];
//		self.lastSelectedChild = nil;
//		_selectedFlag = NO;
//		_selectedChildNodesAndAttributes = nil;
//		_absolutePath=nil;
//		_enabled = YES;
//		_locked = NO;
	}
	return self;
}

- (void)dealloc {
	/* Important - we might have to remove each object. For now just inform each object that it will be deleted so they can break retain cycles */
//!Alert-putback!	[_allChildren makeObjectsPerformSelector:@selector(isAboutToBeDeletedFromParentSHNode)];
	[_allChildren release];

	
//!Alert-putback!	[_absolutePath release];
	
//	NSAssert1([_childContainer.shInterConnectorsInside retainCount]==1, @"doh - retain count fucked %i", [_childContainer.shInterConnectorsInside retainCount]);
//!Alert-putback!	[_childContainer.shInterConnectorsInside release];

//    [_auxiliaryData release];
//	[_selectedChildNodesAndAttributes release];
//	self.lastSelectedChild = nil;
//	[_selectedChildNodesAndAttributes release];
//	_selectedChildNodesAndAttributes = nil;
//	_name = nil;

//    _auxiliaryData = nil;
	[super dealloc];
}

#pragma mark NSCopyopying, hash, isEqual
//!Alert-putback!- (id)copyWithZone:(NSZone *)zone
//!Alert-putback!{
//!Alert-putback!	almost certainly wrong! we need to super copy

//!Alert-putback!super?
	/** DONT DUPLICATE operatorPrivateMember CHILDREN **/
	
	/* Taking care to preserve order */
//!Alert-putback!	int i, count = [_childContainer.nodesInside count];
//!Alert-putback!	for(i=0; i<count;i++)
//!Alert-putback!	{
//!Alert-putback!		SHNode* childNode = [_childContainer nodeAtIndex:i];
//!Alert-putback!		BOOL isPrivateChild = childNode.operatorPrivateMember;
		
//!Alert-putback!		if(isPrivateChild)
//!Alert-putback!		{
//!Alert-putback!			// we can ignore ?
//!Alert-putback!		} else {
//!Alert-putback!			SHNode* dupChildNode = [[childNode copy] autorelease];
//!Alert-putback!			[copy addChild:dupChildNode autoRename:YES];
//!Alert-putback!		}
//!Alert-putback!	}
	
//!Alert-putback!	count = [_childContainer.inputs count];
//!Alert-putback!	for(i=0; i<count; i++)
//!Alert-putback!	{
//!Alert-putback!		SHInputAttribute* childInput = [_childContainer inputAtIndex:i];
//!Alert-putback!		BOOL isPrivateChild = childInput.operatorPrivateMember;

//!Alert-putback!		if(isPrivateChild)
//!Alert-putback!		{
			// set the value
//!Alert-putback!			SHInputAttribute* dupChildInput = (SHInputAttribute*)[copy inputAttributeAtIndex:i];
//!Alert-putback!			[dupChildInput publicSetValue: [childInput value]];
			
//!Alert-putback!		} else {
//!Alert-putback!			SHInputAttribute* dupChildInput = [[childInput copy] autorelease];
//!Alert-putback!			[copy addChild:dupChildInput autoRename:YES];
//!Alert-putback!		}
//!Alert-putback!	}
	
//!Alert-putback!	count = [_childContainer.outputs count];
//!Alert-putback!	for(i=0; i<count;i++)
//!Alert-putback!	{
//!Alert-putback!		SHOutputAttribute* childOutput = [_childContainer outputAtIndex:i];
//!Alert-putback!		BOOL isPrivateChild = childOutput.operatorPrivateMember;

//!Alert-putback!		if(isPrivateChild)
//!Alert-putback!		{
//!Alert-putback!			id val = [childOutput value];
//!Alert-putback!			SHOutputAttribute* dupChildOutput = (SHOutputAttribute*)[copy outputAttributeAtIndex:i];

//			if([val isUnset]){
//				
//			} else {
//!Alert-putback!				[dupChildOutput publicSetValue: val];
//			}

//!Alert-putback!		} else {
//!Alert-putback!			SHOutputAttribute* dupChildOutput = [[childOutput copy] autorelease];
//!Alert-putback!			[copy addChild:dupChildOutput autoRename:YES];
//!Alert-putback!		}
//!Alert-putback!	}
	
//!Alert-putback!	count = [_childContainer.shInterConnectorsInside count];
//!Alert-putback!	for(i=0;i<count;i++)
//!Alert-putback!	{
//!Alert-putback!		SHAttribute *inatt, *outatt, *newInAtt, *newOutAtt;
//!Alert-putback!		
		// convoluted way to find out which inputs are connected.. ie.. node 1 > output 0 to node 2 > input3
//!Alert-putback!		id con = [_childContainer connectorAtIndex:i];
//!Alert-putback!		inatt = [[con inSHConnectlet] parentAttribute];
//!Alert-putback!		outatt = [[con outSHConnectlet] parentAttribute];
//!Alert-putback!		NSArray* indexesToInNode = [self indexPathToNode:inatt];
//!Alert-putback!		NSArray* indexesToOutNode = [self indexPathToNode:outatt];
		
		// in
//!Alert-putback!		if([indexesToInNode count]==1)
//!Alert-putback!		{
//!Alert-putback!			NSString* singleItemInPath = [indexesToInNode objectAtIndex:0];
//!Alert-putback!			newInAtt = [copy objectForIndexString: singleItemInPath];
//!Alert-putback!		} else {
//!Alert-putback!			NSString* firstItemPath = [indexesToInNode objectAtIndex:0];
//!Alert-putback!			NSString* secondItemPath = [indexesToInNode objectAtIndex:1];
//!Alert-putback!			id parentTemp = [copy objectForIndexString: firstItemPath];
//!Alert-putback!			newInAtt = [parentTemp objectForIndexString: secondItemPath];
//!Alert-putback!		}
		
		// out
//!Alert-putback!		if([indexesToOutNode count]==1){
//!Alert-putback!			NSString* singleItemInPath = [indexesToOutNode objectAtIndex:0];
//!Alert-putback!			newOutAtt = [copy objectForIndexString: singleItemInPath];
//!Alert-putback!		} else {
//!Alert-putback!			NSString* firstItemPath = [indexesToOutNode objectAtIndex:0];
//!Alert-putback!			NSString* secondItemPath = [indexesToOutNode objectAtIndex:1];
//!Alert-putback!			id parentTemp = [copy objectForIndexString: firstItemPath];
//!Alert-putback!			newInAtt = [parentTemp objectForIndexString: secondItemPath];
//!Alert-putback!		}
		
//!Alert-putback!		SHInterConnector* int1 = [copy connectOutletOfAttribute:newOutAtt toInletOfAttribute:newInAtt];
//!Alert-putback!		NSAssert(int1!=nil, @"SHNode ERROR.. Failed to connect attrubutes in copy");
//!Alert-putback!	}
//!Alert-putback!	copy.operatorPrivateMember = _operatorPrivateMember;
//!Alert-putback!    return copy;
//!Alert-putback!}


//!Alert-putback!- (BOOL)isEquivalentTo:(id)anObject
//!Alert-putback!{
//!Alert-putback!	if([self class]==[anObject class])
//!Alert-putback!	{
//!Alert-putback!		int numberOfNodesInside1 = [_childContainer.nodesInside count];
//!Alert-putback!		int numberOfNodesInside2 = [[anObject nodesInside] count];
//!Alert-putback!		int inputsInside1 = [_childContainer.inputs count];
//!Alert-putback!		int inputsInside2 = [[anObject inputs] count];
//!Alert-putback!		int outputsInside1 = [_childContainer.outputs count];
//!Alert-putback!		int outputsInside2 = [[anObject outputs] count];
//!Alert-putback!		int connectorsInside1 = [_childContainer.shInterConnectorsInside count];
//!Alert-putback!		int connectorsInside2 = [[anObject shInterConnectorsInside] count];
		
//!Alert-putback!		if(numberOfNodesInside1==numberOfNodesInside2 && connectorsInside1==connectorsInside2 && inputsInside1==inputsInside2 && outputsInside1==outputsInside2)
//!Alert-putback!		{	
//!Alert-putback!			NSEnumerator *enumerator2 = [[anObject nodesInside] objectEnumerator];
//!Alert-putback!			id node;

//!Alert-putback!			for (node in _childContainer.nodesInside) {
//!Alert-putback!				if(![node isEquivalentTo:[enumerator2 nextObject]])
//!Alert-putback!					return NO;
//!Alert-putback!			}
			
//!Alert-putback!			enumerator2 = [[anObject inputs] objectEnumerator];
//!Alert-putback!			for (node in _childContainer.inputs) {
//!Alert-putback!				if(![node isEquivalentTo:[enumerator2 nextObject]])
//!Alert-putback!					return NO;
//!Alert-putback!			}

//!Alert-putback!			enumerator2 = [[anObject outputs] objectEnumerator];
//!Alert-putback!			for(node in _childContainer.outputs) {
//!Alert-putback!				if(![node isEquivalentTo:[enumerator2 nextObject]])
//!Alert-putback!					return NO;
//!Alert-putback!			}
			
//!Alert-putback!			enumerator2 = [[anObject shInterConnectorsInside] objectEnumerator];

//!Alert-putback!			id ic1, ic2;
//!Alert-putback!			SHAttribute *inatt1, *outatt1, *inatt2, *outatt2;
//!Alert-putback!			for (ic1 in _childContainer.shInterConnectorsInside) 
//!Alert-putback!			{
//!Alert-putback!				ic2 = [enumerator2 nextObject];
				// ic1 connects index[2, 4] to [3]
//!Alert-putback!				inatt1 = [[ic1 inSHConnectlet] parentAttribute];
//!Alert-putback!				outatt1 = [[ic1 outSHConnectlet] parentAttribute];
//!Alert-putback!				NSArray* indexesToInNode1 = [self indexPathToNode:inatt1];
//!Alert-putback!				NSArray* indexesToOutNode1 = [self indexPathToNode:outatt1];
//!Alert-putback!				inatt2 = [[ic2 inSHConnectlet] parentAttribute];
//!Alert-putback!				outatt2 = [[ic2 outSHConnectlet] parentAttribute];
//!Alert-putback!				NSArray* indexesToInNode2 = [anObject indexPathToNode:inatt2];
//!Alert-putback!				NSArray* indexesToOutNode2 = [anObject indexPathToNode:outatt2];
//!Alert-putback!				BOOL f1 = indexPathArraysAreEqual(indexesToInNode1,indexesToInNode2);
//!Alert-putback!				BOOL f2 = indexPathArraysAreEqual(indexesToOutNode1,indexesToOutNode2);
//!Alert-putback!				if(f1==NO || f2==NO)
//!Alert-putback!					return NO;
//!Alert-putback!			}			
			
//!Alert-putback!			return YES;
//!Alert-putback!		}
//!Alert-putback!	}
//!Alert-putback!	return NO;	
//!Alert-putback!}

#pragma mark -
#pragma mark WITH UNDO methods

#pragma mark -
#pragma mark DOESN'T NEED UNDO methods

#pragma mark -
#pragma mark NEED TO ADD UNDO methods


#pragma mark -
#pragma mark SUPER *NEW* action methods
//!Alert-putback!- (NSArray *)nodesAndAttributesInside {

//!Alert-putback!	NSMutableArray* nodesAndAttributesInside = [NSMutableArray arrayWithArray:[_childContainer.nodesInside array]];
//!Alert-putback!	[nodesAndAttributesInside addObjectsFromArray:[_childContainer.inputs array]];
//!Alert-putback!	[nodesAndAttributesInside addObjectsFromArray:[_childContainer.outputs array]];
//!Alert-putback!	return nodesAndAttributesInside;
//!Alert-putback!}

//!Alert-putback!- (NSArray *)positionsOfChildren:(NSArray *)children
//!Alert-putback!{
//!Alert-putback!	NSMutableArray* positions = [NSMutableArray array];
//!Alert-putback!	id child;
//!Alert-putback!	for(child in children){
//!Alert-putback!		int ind = [self indexOfChild:child];
//!Alert-putback!		[positions addObject:[NSNumber numberWithInt:ind]];
//!Alert-putback!	}
//!Alert-putback!	return positions;
//!Alert-putback!}

- (id)childAtIndex:(NSUInteger)mindex {

	NSUInteger correctedIndex;
	NSUInteger nodeCount = [_childContainer.nodesInside count];
	NSUInteger previousCorrectedTotal = 0;
	NSUInteger correctedTotal = nodeCount;

	if(mindex < correctedTotal){
		correctedIndex = mindex - previousCorrectedTotal;
		return [_childContainer nodeAtIndex:correctedIndex];
	}
	
	NSUInteger inputCount = [_childContainer.inputs count];
	previousCorrectedTotal = correctedTotal;
	correctedTotal = correctedTotal + inputCount;

	if(mindex < correctedTotal){
		correctedIndex = mindex - previousCorrectedTotal;
		return [_childContainer inputAtIndex:correctedIndex];
	}
	
	NSUInteger outputCount = [_childContainer.outputs count];
	previousCorrectedTotal = correctedTotal;
	correctedTotal = correctedTotal + outputCount;

	if(mindex < correctedTotal){
		correctedIndex = mindex - previousCorrectedTotal;
		return [_childContainer outputAtIndex:correctedIndex];
	}
	
	NSUInteger connectortCount = [_childContainer.shInterConnectorsInside count];
	previousCorrectedTotal = correctedTotal;
	correctedTotal = correctedTotal + connectortCount;

	if(mindex < correctedTotal ){
		correctedIndex = mindex - previousCorrectedTotal;
		return [_childContainer connectorAtIndex:correctedIndex];
	}
	[NSException raise:@"Cant find object at index" format:@"%i", mindex];
	return [NSNull null];	// COV_NF_LINE
}

#pragma mark -


//- (void) moveNodeUpInExecutionOrder:(id)aNode
//{
//	// -- possible error - _nodesAndAttributesInside deprecated.
//
////	int currIndex = [_nodesAndAttributesInside indexOfObject:aNode];
////	if(currIndex!=0 && currIndex!=NSNotFound ){
////		[_nodesAndAttributesInside removeObjectAtIndex:currIndex];
////		[_nodesAndAttributesInside insertObject:aNode atIndex:currIndex-1];		
////		[self setNodesAndAttributesInside:_nodesAndAttributesInside];	// refreshes the bindings! Dont even need to MutableCopy it
////	}
//}


//- (void)moveNodeDownInExecutionOrder:(id)aNode
//{
//	// -- possible error - _nodesAndAttributesInside deprecated.
//
////	int currIndex = [_nodesAndAttributesInside indexOfObject:aNode];
////	if(currIndex<[_nodesAndAttributesInside count]-1 && currIndex!=NSNotFound ){
////		[_nodesAndAttributesInside removeObjectAtIndex:currIndex];
////		[_nodesAndAttributesInside insertObject:aNode atIndex:currIndex+1];
////		[self setNodesAndAttributesInside:_nodesAndAttributesInside];	// refreshes the bindings! Dont even need to MutableCopy it
////	}
//}

/* NB! Any object that observes these notifications needs to remove itself from notification centre before the child is released - 
	Sounds like a whole pile of shit waiting to happen - Do we really need it? 
*/
#pragma mark notification methods

//- (void)postSHNodeAdded_Notification:(id)aNode
//{
//	//logInfo(@"SHNode.m: About to post a notification that a node has been added to %@", self );
//	NSDictionary *d = [NSDictionary dictionaryWithObject:aNode forKey:@"theNode"];
//	NSNotification *n = [NSNotification notificationWithName:@"SHNodeAdded" object:self userInfo:d];	
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ]; // could post when idle
//}
//
//- (void)postSHNodeDeleted_Notification:(id)aNode
//{
//	NSDictionary *d = [NSDictionary dictionaryWithObject:aNode forKey:@"theNode"];
//	NSNotification *n = [NSNotification notificationWithName:@"SHNodeDeleted" object:self userInfo:d];
//	//[[NSNotificationCenter defaultCenter] postNotification: n ];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle:NSPostASAP ]; // could post when idle
//}
//
//- (void)postNodeGuiMayNeedRebuilding_Notification
//{
//	// logInfo(@"SHNode.m: postNodeGuiMayNeedRebuildingNotification");
//	// NSDictionary *d = [NSDictionary dictionaryWithObject:self forKey:@"theNode"];
//	NSNotification *n = [NSNotification notificationWithName:@"nodeGuiMayNeedRebuilding" object:self userInfo:nil];
//	[[NSNotificationQueue defaultQueue] enqueueNotification:n postingStyle: NSPostASAP ]; // could post when idle
//}


#pragma mark accessor methods


//!Alert-putback!- (SH_Path *)absolutePath {
//!Alert-putback!
//!Alert-putback!	SH_Path* parentPath;
//!Alert-putback!	if(_parentSHNode==nil)
//!Alert-putback!	{
//!Alert-putback!		parentPath = [SH_Path rootPath];
//!Alert-putback!	} else {
//!Alert-putback!		parentPath = [_parentSHNode absolutePath];
//!Alert-putback!	}
//!Alert-putback!	NSAssert(_name != nil, @"SHNode.m: name is nil");
//!Alert-putback!	[self setAbsolutePath: [parentPath append:_name]];
//!Alert-putback!	return _absolutePath;
//!Alert-putback!}

- (BOOL)dirtyBit  {
	// we are dirty if any of our contents are dirty
	for( id op in _childContainer.outputs )
	{
		if([op dirtyBit]==YES)
			return YES;
	}
	for( id op in _childContainer.inputs )
	{
		if([op dirtyBit]==YES)
			return YES;
	}
	for( id op in _childContainer.nodesInside ) 
	{
		if([op dirtyBit]==YES)
			return YES;
	}
	return NO;
}

//- (void)setNodesAndAttributesInside:(SHOrderedDictionary *)aNodesAndConnectletsInside
//{
//    if (_nodesAndAttributesInside != aNodesAndConnectletsInside) {
//        [aNodesAndConnectletsInside retain];
//        [_nodesAndAttributesInside release];
//        _nodesAndAttributesInside = aNodesAndConnectletsInside;
//    }
//}

//- (SHOrderedDictionary *)nodesAndAttributesInside {
//    if (!_nodesAndAttributesInside)
//        _nodesAndAttributesInside = [[SHOrderedDictionary dictionary] retain];
//    return [[_nodesAndAttributesInside retain] autorelease];
//}


//!Alert-putback!- (NSString *)description
//!Alert-putback!{
//!Alert-putback!	NSString* thisSummary = [NSString stringWithFormat:@"%@ - <%p>. %@ Contents: %i nodes, %i inputs, %i outputs \n", [self class], self, _name, [_childContainer.nodesInside count], [_childContainer.inputs count], [_childContainer.outputs count]];

//!Alert-putback!	id child;
//!Alert-putback!	int count = 0;
//!Alert-putback!	NSString* childrenSummary=@"";
//!Alert-putback!	for(child in _childContainer.nodesInside)
//!Alert-putback!	{
//!Alert-putback!		NSString* childSummary = [child description];
//!Alert-putback!		if(childSummary){
//!Alert-putback!			childSummary = [NSString stringWithFormat:@"childNNode %i: %@", count, childSummary];
//!Alert-putback!			childrenSummary = [childrenSummary stringByAppendingString:childSummary];
//!Alert-putback!			count++;
//!Alert-putback!		}
//!Alert-putback!	}
//!Alert-putback!	if(count && childrenSummary){
//!Alert-putback!		NSAssert(childrenSummary!=nil, @"er, nil string");
//!Alert-putback!		thisSummary = [thisSummary stringByAppendingString:childrenSummary];
//!Alert-putback!	}
//!Alert-putback!	return thisSummary;
//!Alert-putback!}

// a root node is depth==0
- (NSUInteger)depth {
	
	int depth=0;
	NSObject<ChildAndParentProtocol> *aNode = self;
	while((aNode=[aNode parentSHNode])){
		depth++;
	}
	return depth;
}

//- (BOOL)respondsToSelector:(SEL)aSelector {
//	logInfo(@"Do we respond to %@ ?", NSStringFromSelector(aSelector));
//	return [super respondsToSelector:aSelector];
//}

- (BOOL)addChild:(NSObject<SHNodeLikeProtocol> *)aNode undoManager:(NSUndoManager *)um {
	return [self addChild:aNode autoRename:YES undoManager:um];
}

- (BOOL)addChild:(NSObject<SHNodeLikeProtocol> *)aNode autoRename:(BOOL)renameFlag undoManager:(NSUndoManager *)um {
	return [self addChild:aNode atIndex:-1 autoRename:renameFlag undoManager:um];
}

- (SHCustomMutableArray *)allChildren {

	if(!_allChildren){
		_allChildren = [[SHCustomMutableArray alloc] init];
		[_allChildren setNode:self];
	}
	return _allChildren;
}

/* TODO: what is the logic is using NSObject<SHNodeLikeProtocol> * ? Only nodes, inputs, outputs and connectors can be added to the container! */
- (BOOL)addChild:(NSObject<SHNodeLikeProtocol> *)aNode atIndex:(NSInteger)ind autoRename:(BOOL)renameFlag undoManager:(NSUndoManager *)um {

	/* Do we need all this old shit ? */
	if( [aNode parentSHNode]==nil )
	{
		// is it a root node?
		if([aNode conformsToProtocol:@protocol(SHParentLikeProtocol)] && [self isNodeParentOfMe:(id)aNode])
			return NO;
		
//!Alert-putback!		int UID;
//!Alert-putback!		if( aNode.temporaryID<1 ){
//!Alert-putback!			UID = [SHNodeGraphModel getNewUniqueID];
//!Alert-putback!			aNode.temporaryID = UID;
//!Alert-putback!		} else {
//!Alert-putback!			UID = aNode.temporaryID;
//!Alert-putback!		}
//!Alert-putback!		// make sure we have a valid name
//!Alert-putback!		NSString *nameString = [aNode name];
//!Alert-putback!		if(nameString==nil){
//!Alert-putback!			// make up a unique name
//!Alert-putback!			nameString = [NSString stringWithFormat:@"%@%i", [(NSObject*)aNode className], 1 ];
//!Alert-putback!			if([self isNameUsedByChild:nameString])
//!Alert-putback!				nameString = [self nextUniqueChildNameBasedOn:nameString];
//!Alert-putback!			[(id<SHNodeLikeProtocol>)aNode setName:nameString];
//!Alert-putback!		}
//!Alert-putback!		/*	we are only going to add nodes with unique names for the time being..
//!Alert-putback!		 at a later date we may want options to replace, rename, cancel, etc. */
//!Alert-putback!		if([self isNameUsedByChild: nameString])
//!Alert-putback!		{
//!Alert-putback!			if(renameFlag){
//!Alert-putback!				nameString = [self nextUniqueChildNameBasedOn:nameString];
//!Alert-putback!				[(id<SHNodeLikeProtocol>)aNode setName:nameString];
//!Alert-putback!			} else {
//!Alert-putback!				NSException* myException = [NSException exceptionWithName:@"NonUniqueName" reason:[NSString stringWithFormat:@"node doesn't have a unique name - %@", nameString] userInfo:nil];
//!Alert-putback!				[myException raise];
//!Alert-putback!			}
//!Alert-putback!		}
//!Alert-putback!		if(ind==-1)
//!Alert-putback!			[self _addSHChild:aNode withKey:nameString];
//!Alert-putback!		else 
//!Alert-putback!			[self _addSHChild:aNode atIndex:ind withKey:nameString];
		/* 
			Temp New Version 
		 */
		[self addChild:(id)aNode atIndex:ind undoManager:um];
		[self clearSelectionNoUndo]; /* Not Undoable */
		return YES;
	}
	return NO;
}

// recursively find children we can pass on a message to
- (NSArray *)nearestChildNodesSupportingProtocol:(Protocol *)value {
	
	NSMutableArray *nearestChildren = [NSMutableArray array];
	for( id eachChild in [[self nodesInside] array] ){
		if([eachChild conformsToProtocol:value])
			[nearestChildren addObject:eachChild];
		else if( [eachChild conformsToProtocol:@protocol(ChildAndParentProtocol)] ){
			// -- check it's children
			NSArray *nearestChildrensChildren = [eachChild nearestChildNodesSupportingProtocol:value];
			[nearestChildren addObjectsFromArray:nearestChildrensChildren];
		}
	}
	return nearestChildren;
}

- (NSObject<ChildAndParentProtocol> *)nearestParentSupportingProtocol:(Protocol *)value {
	
	id parent=_parentSHNode;
	while(parent){
		if([parent conformsToProtocol:value])
			break;
		parent = [parent parentSHNode];
	}
	return parent;
}

@end
