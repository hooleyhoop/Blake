//
//  SHChild.m
//  SHNodeGraph
//
//  Created by steve hooley on 22/04/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SHChild.h"
#import "NodeName.h"

@implementation SHChild

@synthesize parentSHNode=_parentSHNode;
@synthesize nodeGraphModel=_nodeGraphModel;
@synthesize operatorPrivateMember = _operatorPrivateMember;
@synthesize name = _name;

#pragma mark init methods

+ (id)makeChildWithName:(NSString *)nameStr {

	NSParameterAssert(nameStr);

	SHChild *chld = [[[[self class] alloc] init] autorelease];
	[chld changeNameWithStringTo:nameStr fromParent:nil undoManager:nil];
	return chld;
}

/* called from HooleyObject init */
- (id)initBase {
	self=[super initBase];
	if(self){
	}
	return self;
}

- (id)init {
	
	self=[super init];
	if(self){
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
	/* careful - dont call [super initWithCoder:coder] here as it will call [self init] and we dont want to call initWithCoder and init - we have baseIsnit for that */
    self = [super init];
	if(self){
		_nodeGraphModel = [coder decodeObjectForKey:@"nodeGraphModel"];
		_parentSHNode = [coder decodeObjectForKey:@"parentSHNode"];
		_name = [[coder decodeObjectForKey:@"name"] retain];
		_operatorPrivateMember = [coder decodeBoolForKey:@"operatorPrivateMember"];
    }
	return self;
}

- (void)dealloc {

	[_name release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	
	SHChild *copy = [[[self class] alloc] initBase];
	[copy setOperatorPrivateMember: _operatorPrivateMember];
	
	if(_name)
		[copy changeNameTo:_name fromParent:nil undoManager:nil];

	/*	When you copy an object you are not 'Duplicating it in the same graph' - that would be a copy & paste. 
		Therefore, dont copy graph or parent.
		Parent has to be set to new copied parent.
	 */
	// copy->_nodeGraphModel	= self->_nodeGraphModel;
	// copy->_parentSHNode		= self->_parentSHNode;

	return copy;
}

- (void)encodeWithCoder:(NSCoder *)coder {

	NSParameterAssert(coder);

    [coder encodeObject:_name forKey:@"name"];
    [coder encodeBool:_operatorPrivateMember forKey:@"operatorPrivateMember"];
	
	/* encodeConditionalObject will encode a reference to the object if the object has been encoded with encodeObject elsewhere */
    [coder encodeConditionalObject:_parentSHNode forKey:@"parentSHNode"];
    [coder encodeConditionalObject:_nodeGraphModel forKey:@"nodeGraphModel"];
}

- (BOOL)isEquivalentTo:(id)anObject {

	NSParameterAssert(anObject);

	if([super isEquivalentTo:anObject]==NO)
		return NO;

	if(![_name isEqualToNodeName:[(SHChild *)anObject name]])
		return NO;
	
	if(_operatorPrivateMember!=[anObject operatorPrivateMember])
		return NO;
	
	// If we tested the nodegraph or the parent in this equivalence test then a
	// perfect copy of the node would fail equivalence. Is that what we want?
	// ie.  n1 -			n2 -
	//			|_i1			|_i2
	//			
	// in a copy of n1 >> input i2 could never be equivalent to input i1, but i think that is what we mean by equivalence
	//	if(_nodeGraphModel!=[anObject nodeGraphModel])
	//		return NO;
	
	return YES;
}

#pragma mark action methods

- (BOOL)isNodeParentOfMe:(NSObject<SHParentLikeProtocol> *)aNode {

	NSParameterAssert(aNode);
	if(_parentSHNode!=nil && aNode!=nil)
	{
		if(_parentSHNode==aNode)
			return YES;
		else
			return [_parentSHNode isNodeParentOfMe:aNode];
	}
	return NO;
}

- (void)_privateChangeName:(NodeName *)nm undoManager:(NSUndoManager *)um {
	
	NSParameterAssert([nm isKindOfClass:[NodeName class]]);
	if([nm.value isEqualToString:_name.value]==NO)
	{
		/* Experimental UndoSupport - Wont undo the 1st change from nil to ***something*** */
		if(_name!=nil) {
			if(![um isUndoing])
				[um setActionName:@"set Name"];
			/* we need to trigger kvo for "name" when we undo */
			[(SHChild *)[um prepareWithInvocationTarget:self] _privateChangeName:_name undoManager:um];
		}		
		[_name release];
		_name = [nm retain];
	}
}

- (BOOL)changeNameWithStringTo:(NSString *)aNameStr fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um {

	NSParameterAssert([aNameStr isKindOfClass:[NSString class]]);
	NodeName *newName = [NodeName makeNameWithString:aNameStr];
	if(!newName)
		return NO;
	return [self changeNameTo:newName fromParent:parent undoManager:um];
}

/* This must only be called from the parent, the parent must check that the name is unique before calling */
- (BOOL)changeNameTo:(NodeName *)aName fromParent:(NSObject<SHParentLikeProtocol> *)parent undoManager:(NSUndoManager *)um {
	
	NSParameterAssert( aName );
	NSParameterAssert( parent==nil ? _parentSHNode==nil : _parentSHNode!=nil );		// you must supply a parent if we have a parent
	NSParameterAssert( parent!=nil ? _parentSHNode==parent : _parentSHNode==nil );	// if you dont have a parent dont send one
	if( parent && [_parentSHNode isNameUsedByChild:aName.value] ){
		[NSException raise:@"Name isn't unique" format:@"Name isn't unique - you must check first"];
	}
	[self _privateChangeName:aName undoManager:um];
	return YES;
}

#pragma mark notification methods
- (void)isAboutToBeDeletedFromParentSHNode {
	NSAssert(_parentSHNode!=nil, @"why did we receive isAboutToBeDeletedFromParentSHNode?");
}

- (void)hasBeenAddedToParentSHNode {
	NSAssert(_parentSHNode!=nil, @"why did we receive hasBeenAddedToParentSHNode? when _parentSHNode is nil");
}

#pragma mark accessor methods
- (SHChild *)rootNode {
	
	SHChild *root=nil;
	if(_parentSHNode!=nil)
		root = [_parentSHNode rootNode];
	else {
		root = self;
	}
	return root;
}

- (NSObject<GraphLikeProtocol> *)nodeGraphModel {
	
	NSObject<GraphLikeProtocol> *ngm = _nodeGraphModel;
	if(ngm==nil){
		SHChild *root = [self rootNode];
		if(root!=nil && root!=(id)self)
			ngm = [root nodeGraphModel];
	}
	return ngm;
}

@end
