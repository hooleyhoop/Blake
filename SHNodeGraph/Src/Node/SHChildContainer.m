//
//  SHChildContainer.m
//  SHNodeGraph
//
//  Created by steve hooley on 25/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHChildContainer.h"
#import "SHChild.h"
#import "NodeName.h"
#import "SHParent.h"
#import "SHProtoAttribute.h"
#import "SHProtoInputAttribute.h"
#import "SHProtoOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHConnectlet.h"

@implementation SHChildContainer

@synthesize nodesInside=_nodesInside; // keypath becomes nodesInside.array
@synthesize inputs=_inputs;
@synthesize outputs=_outputs;
@synthesize shInterConnectorsInside=_shInterConnectorsInside;

- (id)initBase {
	self=[super initBase];
	return self;
}

- (id)init {
	
	self=[self initWithNodes:[SHOrderedDictionary dictionary]
					  inputs:[SHOrderedDictionary dictionary]
					 outputs:[SHOrderedDictionary dictionary]
						 ics:[SHOrderedDictionary dictionary]
	];
	return self;
}

- (id)initWithNodes:(SHOrderedDictionary *)nodes inputs:(SHOrderedDictionary *)inputs outputs:(SHOrderedDictionary *)outputs ics:(SHOrderedDictionary *)ics {
	
	if(((nodes!=inputs)&&(outputs!=ics)&&(inputs!=outputs))==NO)
		[NSException raise:@"Dick head" format:@""];
		
	self=[super init];
	if(self) {
		_nodesInside = [nodes retain];
        _outputs = [outputs retain];
		_inputs = [inputs retain];
		_shInterConnectorsInside = [ics retain];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
	/* careful not to call [super initWithCoder:] here as it will call [self init] */
    self = [super init];
	if(self) {
		_nodesInside =	[[coder decodeObjectForKey:@"nodesInside"] retain];
		_outputs =		[[coder decodeObjectForKey:@"outputs"] retain];
		_inputs =		[[coder decodeObjectForKey:@"inputs"] retain];
		_shInterConnectorsInside = [[coder decodeObjectForKey:@"shInterConnectorsInside"] retain];
	}
    return self;
}

- (void)dealloc {
	
	[_nodesInside release];
	[_inputs release];
	[_outputs release];
	[_shInterConnectorsInside release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder {
	
	[coder encodeObject:_nodesInside forKey:@"nodesInside"];
	[coder encodeObject:_inputs forKey:@"inputs"];
	[coder encodeObject:_outputs forKey:@"outputs"];
	[coder encodeObject:_shInterConnectorsInside forKey:@"shInterConnectorsInside"];
}

- (BOOL)isEqualToContainer:(SHChildContainer *)value {
	
	NSParameterAssert(value);

//-- are the nodes equal in number and kind?
//-- are the inputs equal in number and kind?
//-- are the outputs equal in number and kind?
//-- are the connectors equal in number and kind?
//	
//-- are the input and output data types the same?
//	
//-- do the connectors connect relative inputs and outputs?
//	
//input.3 -> output.0
//input.3 -> node.2.input.3
//node.2.output.2 -> node.1.input.3
//	
//what about nodes going out and in? i think they are in the parent
//	
//are the unconnected input values the same?
//are the uncconected output values the same?
//what about 'outputsIAffect' ?
	
 	NSParameterAssert(value!=nil);
 	NSParameterAssert([value isKindOfClass:[self class]]);
	
	BOOL test1 = [_nodesInside isEqualToOrderedDict:[value nodesInside]];
	if(!test1)
		return NO;
	
	BOOL test2 = [_inputs isEqualToOrderedDict:[value inputs]];
	if(!test2)
		return NO;
	
	BOOL test3 = [_outputs isEqualToOrderedDict:[value outputs]];
	if(!test3)
		return NO;

	//-- the interconnectors won't be equal but we must be able to test something
	BOOL test4 = [_shInterConnectorsInside isEqualToOrderedDict:[value shInterConnectorsInside]];
	if(!test4)
		return NO;

	return YES;
}

#pragma mark ** WITH UNDO ** methods

- (void)_addNode:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um {

	NSParameterAssert(value);
	NSParameterAssert(key);
	NSParameterAssert([key isKindOfClass:[NSString class]]);

	[_nodesInside setObject:value atIndex:ind forKey:key];
	if(![um isUndoing])
		[um setActionName:@"add node"];
	[[um prepareWithInvocationTarget:self] _removeNode:value withKey:key undoManager:um];
}

- (void)_addInput:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um {

	NSParameterAssert(value);
	NSParameterAssert([key isKindOfClass:[NSString class]]);

	[_inputs setObject:value atIndex:ind forKey:key];
	if(![um isUndoing])
		[um setActionName:@"add input"];
	[[um prepareWithInvocationTarget:self] _removeInput:value withKey:key undoManager:um];
}

- (void)_addOutput:(SHChild *)value atIndex:(int)ind withKey:(NSString *)key undoManager:(NSUndoManager *)um {

	NSParameterAssert(value);
	NSParameterAssert(key);
	NSParameterAssert([key isKindOfClass:[NSString class]]);

	[_outputs setObject:value atIndex:ind forKey:key];
	if(![um isUndoing])
		[um setActionName:@"add output"];
	[[um prepareWithInvocationTarget:self] _removeOutput:value withKey:key undoManager:um];
}

- (void)_removeNode:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um {

	NSParameterAssert(value);
	NSParameterAssert(key);
	NSParameterAssert([key isKindOfClass:[NSString class]]);

	NSUInteger currentIndex = [_nodesInside indexOfObjectIdenticalTo:value];
	NSAssert(currentIndex!=NSNotFound, @"Fuck - indexOfObjectIdenticalTo not found");
	[_nodesInside removeObject:value];
	if(![um isUndoing])
		[um setActionName:@"remove node"];
	[[um prepareWithInvocationTarget:self] _addNode:value atIndex:currentIndex withKey:key undoManager:um];
}

- (void)_removeInput:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um {

	NSParameterAssert(value);
	NSParameterAssert(key);
	NSParameterAssert([key isKindOfClass:[NSString class]]);

	NSUInteger currentIndex = [_inputs indexOfObjectIdenticalTo:value];
	NSAssert(currentIndex!=NSNotFound, @"Fuck - indexOfObjectIdenticalTo not found");
	[_inputs removeObject:value];
	if(![um isUndoing])
		[um setActionName:@"remove input"];
	[[um prepareWithInvocationTarget:self] _addInput:value atIndex:currentIndex withKey:key undoManager:um];
}

- (void)_removeOutput:(SHChild *)value withKey:(NSString *)key undoManager:(NSUndoManager *)um {
	
	NSParameterAssert(value);
	NSParameterAssert(key);
	NSParameterAssert([key isKindOfClass:[NSString class]]);

	NSUInteger currentIndex = [_outputs indexOfObjectIdenticalTo:value];
	NSAssert(currentIndex!=NSNotFound, @"Fuck - indexOfObjectIdenticalTo not found");
	[_outputs removeObject:value];
	if(![um isUndoing])
		[um setActionName:@"remove output"];
	[[um prepareWithInvocationTarget:self] _addOutput:value atIndex:currentIndex withKey:key undoManager:um];
}

/* indexes can be nil */
- (void)_addOutputs:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um {
	
	NSParameterAssert([values count]);
	NSParameterAssert([[keys objectAtIndex:0] isKindOfClass:[NSString class]]);
	[_outputs setObjects:values atIndexes:indexes forKeys:keys];

	if(![um isUndoing])
		[um setActionName:@"add Outputs"];
	[[um prepareWithInvocationTarget:self] _removeOutputs:values undoManager:um];
}

/* indexes can be nil */
- (void)_addInputs:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um {

	NSParameterAssert([values count]);
	NSParameterAssert([[keys objectAtIndex:0] isKindOfClass:[NSString class]]);
	[_inputs setObjects:values atIndexes:indexes forKeys:keys];
	
	if(![um isUndoing])
		[um setActionName:@"add Inputs"];
	[[um prepareWithInvocationTarget:self] _removeInputs:values undoManager:um];
}

/* indexes can be nil */
- (void)_addNodes:(NSArray *)values atIndexes:(NSIndexSet *)indexes withKeys:(NSArray *)keys undoManager:(NSUndoManager *)um {

	NSParameterAssert([values count]);
	NSParameterAssert([[keys objectAtIndex:0] isKindOfClass:[NSString class]]);
	[_nodesInside setObjects:values atIndexes:indexes forKeys:keys];
	
	if(![um isUndoing])
		[um setActionName:@"add Nodes"];
	[[um prepareWithInvocationTarget:self] _removeNodes:values undoManager:um];
}

- (void)_addInterConnector:(SHInterConnector *)anInterConnector between:(SHProtoAttribute *)outAttr and:(SHProtoAttribute *)inAttr undoManager:(NSUndoManager *)um {
	
	NSParameterAssert(anInterConnector);
	NSParameterAssert(outAttr);
	NSParameterAssert(inAttr);

	if([self isChild:anInterConnector])
		[NSException raise:@"already got this interconnector as a child" format:@"Dick"];

    int i = [_shInterConnectorsInside count];
	
	// Is this really a bug?
	if([outAttr connectOutletToInletOf:inAttr withConnector:anInterConnector]==NO)
		[NSException raise:@"cant connect" format:@"cant connect"];

	[_shInterConnectorsInside setObject:anInterConnector atIndex:i forKey:[anInterConnector name].value];

	[um beginUndoGrouping];
	if(![um isUndoing])
		[um setActionName:@"add connection"];
	[[um prepareWithInvocationTarget:self] _removeInterConnector:anInterConnector undoManager:um];
	[um endUndoGrouping];
}

- (void)_addInterconnectors:(NSArray *)values between:(NSArray *)outAtts and:(NSArray *)inAtts undoManager:(NSUndoManager *)um {

	NSParameterAssert([values count]);
    NSParameterAssert( [values count]==[outAtts count] );
    NSParameterAssert( [values count]==[inAtts count] );
	for( SHChild *each in values ){
		if([self isChild:each]==YES)
			[NSException raise:@"already got this interconnector as a child" format:@"Dick"];
	}	

	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[values count]];
	
	NSUInteger i=0;
    for( SHInterConnector *ic in values )
	{
        SHProtoAttribute *att1 = [outAtts objectAtIndex:i];
        SHProtoAttribute *att2 = [inAtts objectAtIndex:i];
		NSAssert([ic isKindOfClass:[SHInterConnector class]], @"doh");
		NSAssert([att1 isKindOfClass:[SHProtoAttribute class]], @"doh");
		NSAssert([att2 isKindOfClass:[SHProtoAttribute class]], @"doh");

		NodeName *name = [ic name];
		NSAssert(name!=nil, @"eh? - No name!");

		// Is this really a bug?
        if([att1 connectOutletToInletOf:att2 withConnector:ic]==NO)
			[NSException raise:@"cant connect" format:@"cant connect"];
		
		NSAssert([keys indexOfObject:name.value]==NSNotFound, @"shit - haven't prepared the names very well!");
		[keys addObject:name.value];
		i++;
    }
	
	NSIndexSet *indexesToAdd = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange( [_shInterConnectorsInside count], [values count])];
	[_shInterConnectorsInside setObjects:values atIndexes:indexesToAdd forKeys:keys];	

	if(![um isUndoing])
		[um setActionName:@"add connections"];
	[[um prepareWithInvocationTarget:self] _removeInterConnectors:values undoManager:um];
}

- (void)_removeNodes:(NSArray *)nodes undoManager:(NSUndoManager *)um {

	NSParameterAssert([nodes count]);

	NSMutableIndexSet *inds = [NSMutableIndexSet indexSet];
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[_nodesInside count]];
	for( SHChild *node in nodes )
	{
		NSUInteger currInd = [_nodesInside indexOfObjectIdenticalTo:node];
		NSAssert(currInd!=NSNotFound, @"Fuck - indexOfObjectIdenticalTo not found");
		[inds addIndex:currInd];
		[keys addObject:[node name].value];
	}
	[_nodesInside removeObjectsAtIndexes:inds];

	if(![um isUndoing])
		[um setActionName:@"remove nodes"];
	[[um prepareWithInvocationTarget:self] _addNodes:nodes atIndexes:inds withKeys:keys undoManager:um];
}

- (void)_removeInputs:(NSArray *)inputs undoManager:(NSUndoManager *)um {
	
	NSParameterAssert([inputs count]);

	NSMutableIndexSet *inds = [NSMutableIndexSet indexSet];
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[inputs count]];
	for( SHChild *input in inputs ){
		NSUInteger currInd = [_inputs indexOfObjectIdenticalTo:input];
		NSAssert(currInd!=NSNotFound, @"Fuck - indexOfObjectIdenticalTo not found");
		[inds addIndex:currInd];
		[keys addObject:[input name].value];
	}
	[_inputs removeObjectsAtIndexes:inds];

	if(![um isUndoing])
		[um setActionName:@"remove inputs"];
	[[um prepareWithInvocationTarget:self] _addInputs:inputs atIndexes:inds withKeys:keys undoManager:um];
}

- (void)_removeOutputs:(NSArray *)outputs undoManager:(NSUndoManager *)um {

	NSParameterAssert([outputs count]);

	NSMutableIndexSet *inds = [NSMutableIndexSet indexSet];
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:[outputs count]];
	for( SHChild *output in outputs )
	{
		NSUInteger currInd = [_outputs indexOfObjectIdenticalTo:output];
		NSAssert(currInd!=NSNotFound, @"Fuck - index indexOfObjectIdenticalTo");
		[inds addIndex:currInd];
		[keys addObject:[output name].value];
	}
	[_outputs removeObjectsAtIndexes:inds];

	if(![um isUndoing])
		[um setActionName:@"remove outputs"];
	[[um prepareWithInvocationTarget:self] _addOutputs:outputs atIndexes:inds withKeys:keys undoManager:um];
}

- (void)_removeInterConnector:(SHInterConnector *)connectorToDelete undoManager:(NSUndoManager *)um {
	
	NSParameterAssert(connectorToDelete);

	//-- get the connector
	//-- disconnect the attributes
	if([_shInterConnectorsInside containsObject:connectorToDelete]==NO)
		[NSException raise:@"Dont contain this interconnector" format:@"Dick"];
	
	SHConnectlet* inConnectlet = (SHConnectlet *)[connectorToDelete inSHConnectlet];
	SHConnectlet* outConnectlet = (SHConnectlet *)[connectorToDelete outSHConnectlet];
	SHProtoAttribute* inA = [inConnectlet parentAttribute];
	SHProtoAttribute* outAttr = [outConnectlet parentAttribute];
	[outAttr removeInterConnector:connectorToDelete]; // copies the data so both attributes have duplicate values
	
	[_shInterConnectorsInside removeObject:connectorToDelete];

	[um beginUndoGrouping];
	if(![um isUndoing])
		[um setActionName:@"remove connection"];
	[[um prepareWithInvocationTarget:self] _addInterConnector:connectorToDelete between:outAttr and:inA undoManager:um];
	[um endUndoGrouping];
}

- (void)_removeInterConnectors:(NSArray *)connectorsToDelete undoManager:(NSUndoManager *)um {
	
	NSParameterAssert([connectorsToDelete count]);

	NSMutableArray *allOuts = [NSMutableArray arrayWithCapacity:[connectorsToDelete count]];
	NSMutableArray *allIns = [NSMutableArray arrayWithCapacity:[connectorsToDelete count]];
	NSMutableIndexSet *indexesOfICs = [NSMutableIndexSet indexSet];
    for( SHInterConnector *ic in connectorsToDelete )
	{
		//-- disconnect the attributes
		[indexesOfICs addIndex:[_shInterConnectorsInside indexOfObjectIdenticalTo:ic]];
		SHConnectlet* inConnectlet = (SHConnectlet *)[ic inSHConnectlet];
		SHConnectlet* outConnectlet = (SHConnectlet *)[ic outSHConnectlet];
		SHProtoAttribute* inA = [inConnectlet parentAttribute];
		SHProtoAttribute* outAttr = [outConnectlet parentAttribute];
		NSAssert(outAttr!=nil, @"oops");
		NSAssert(inA!=nil, @"oops");
        [allOuts addObject:outAttr];
        [allIns addObject:inA];
		
		[outAttr removeInterConnector:ic]; // copies the data so both attributes have duplicate values
    }
	
	// remove from ordered dict
	[_shInterConnectorsInside removeObjectsAtIndexes:indexesOfICs];

	if(![um isUndoing])
		[um setActionName:@"remove connections"];
	[[um prepareWithInvocationTarget:self] _addInterconnectors:connectorsToDelete between:allOuts and:allIns undoManager:um];
}

- (SHOrderedDictionary *)_targetStorageForObject:(SHChild *)anOb {

	NSParameterAssert(anOb);
	if([anOb isKindOfClass:[SHParent class]] ) {
		return _nodesInside;
	} else if([anOb isKindOfClass:[SHProtoInputAttribute class]]){
		return _inputs;
	} else if([anOb isKindOfClass:[SHProtoOutputAttribute class]]){
		return _outputs;
	} else if([anOb isKindOfClass:[SHInterConnector class]]){
		return _shInterConnectorsInside;
	}
	/* This is not an exception - it is ok to use this to determine if an object is a child */
	return nil;
}

- (BOOL)isChild:(id)value {
	
	NSParameterAssert(value);
	NSUInteger indexOfChild = [self indexOfChild:value];
	BOOL isFound = indexOfChild!=NSNotFound;
	return isFound;
}

- (NSUInteger)indexOfChild:(id)child {
	
	NSParameterAssert(child);
	SHOrderedDictionary* targetArray = [self _targetStorageForObject:child];
	if(targetArray==nil)
		return NSNotFound;
	return [targetArray indexOfObjectIdenticalTo:child];	// may return NSNotFound
}

- (void)setIndexOfChild:(id)child to:(NSUInteger)index undoManager:(NSUndoManager *)um {
	
	NSParameterAssert(child);
	NSParameterAssert(index!=NSNotFound);
	SHOrderedDictionary* targetArray = [self _targetStorageForObject:child];
	NSAssert(targetArray, @"doh");
	int currentIndex = [targetArray indexOfObjectIdenticalTo:child];
	if(currentIndex!=NSNotFound){
		[targetArray setObjects:child indexTo:index];
		if(![um isUndoing])
			[um setActionName:@"set index"];
		[[um prepareWithInvocationTarget:self] setIndexOfChild:child to:currentIndex undoManager:um];
	}
}

- (void)moveObjects:(NSArray *)children toIndexes:(NSIndexSet *)indexes undoManager:(NSUndoManager *)um {
	
	NSParameterAssert( [children count] );
	SHOrderedDictionary *targetArray = [self _targetStorageForObject:[children lastObject]];
	NSIndexSet *currentIndexes = [targetArray indexesOfObjects:children];
	if([indexes isEqualToIndexSet:currentIndexes] )
		return;
	
	[targetArray moveObjects:children toIndexes:indexes];
	if(![um isUndoing])
		[um setActionName:@"set index"];
	[[um prepareWithInvocationTarget:self] moveObjects:children toIndexes:currentIndexes undoManager:um];
}

// table index stuff
- (void)moveChildren:(NSArray *)children toInsertionIndex:(NSUInteger)index undoManager:(NSUndoManager *)um {
	
	NSParameterAssert( [children count] );
	SHOrderedDictionary *targetArray = [self _targetStorageForObject:[children lastObject]];
	NSIndexSet *currentIndexes = [targetArray indexesOfObjects:children];

	NSIndexSet *currentIndexesLessThanInsertionPt = [currentIndexes indexesLessThan:index];
	NSIndexSet *currentIndexesGreaterThanEqualInsertionPt = [currentIndexes indexesGreaterThanOrEqualTo:index];
	NSAssert([currentIndexesLessThanInsertionPt count]+[currentIndexesGreaterThanEqualInsertionPt count]==[currentIndexes count], @"my indexset dividing has gone wrong");
	
	NSIndexSet *newIndexesLessThanSplit = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index-[currentIndexesLessThanInsertionPt count], [currentIndexesLessThanInsertionPt count])];
	NSIndexSet *newIndexesGreaterThanSplit = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, [currentIndexesGreaterThanEqualInsertionPt count])];
	NSMutableIndexSet *combined = [NSMutableIndexSet indexSet];
	[combined addIndexes:newIndexesLessThanSplit];
	[combined addIndexes:newIndexesGreaterThanSplit];
	NSAssert([combined count]==[children count], @"number of indexes has got out of whack somewhere");
	[self moveObjects:children toIndexes:combined undoManager:um];
}

- (SHChild<SHNodeLikeProtocol> *)childWithKey:(NSString *)aName  {
	
	NSParameterAssert(aName);
	NSParameterAssert([aName isKindOfClass:[NSString class]]);

	id node = [_nodesInside objectForKey: aName];
	if(node!=nil)
		return node;
	node =  [_inputs objectForKey: aName];
	if(node!=nil)
		return node;
	node =  [_outputs objectForKey: aName];
	if(node!=nil)
		return node;
	node =  [_shInterConnectorsInside objectForKey: aName];
	if(node!=nil)
		return node;
	return nil;
}

- (unsigned int)countOfChildren {
	
	unsigned count = 0;
	count = [_nodesInside count];
	count = count + [_inputs count];
	count = count + [_outputs count];
	count = count + [_shInterConnectorsInside count];
	return count;
}

- (BOOL)isEmpty {
	
	if([_nodesInside count])
		return NO;
	if([_outputs count])
		return NO;
	if([_inputs count])
		return NO;
	return YES;
}

- (SHInterConnector *)interConnectorFor:(SHProtoAttribute *)inAtt1 and:(SHProtoAttribute *)inAtt2 {
	
	NSParameterAssert(inAtt1!=inAtt2);
	NSMutableArray *allCons = [inAtt1 allConnectedInterConnectors];

	for( SHInterConnector *ic in allCons )
	{
		if([_shInterConnectorsInside containsObject:ic]){
			SHProtoAttribute *outAtt = [ic.outSHConnectlet parentAttribute];
			if(outAtt==inAtt2)
				return ic;
			SHProtoAttribute *wrongAtt = [ic.inSHConnectlet parentAttribute];
			if(wrongAtt==inAtt2)
				return ic;
		}
	}
	return nil;
}

- (SHChild *)nodeAtIndex:(NSUInteger)mindex {
	return [_nodesInside objectAtIndex:mindex];
}

- (SHChild *)inputAtIndex:(NSUInteger)mindex {
	return [_inputs objectAtIndex: mindex];
}

- (SHChild *)outputAtIndex:(NSUInteger)mindex {
	return [_outputs objectAtIndex: mindex];
}

- (SHChild *)connectorAtIndex:(NSUInteger)mindex {
	return [_shInterConnectorsInside objectAtIndex: mindex];
}


@end
