//
//  SHInterConnector.m
//  SHNodeGraph
//
//  Created by steve hooley on 27/02/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "SHInterConnector.h"
#import "SHProtoAttribute.h"
#import "SHConnectlet.h"
#import "SH_Path.h"
#import "NodeName.h"

@implementation SHInterConnector

@synthesize inSHConnectlet=_inSHConnectlet;
@synthesize outSHConnectlet=_outSHConnectlet;

#pragma mark -
#pragma mark class methods
+ (SHInterConnector *)interConnector {
	return [[[SHInterConnector alloc] init] autorelease];
}

#pragma mark init methods
- (id)initBase {
	self=[super initBase];
	if(self){
	}
	return self;
}

- (id)init {
	self=[super init];
	if( self ) {
		//	self.enabled = YES;
		[self changeNameWithStringTo:@"InterConnector" fromParent:nil undoManager:nil];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
    self = [super initWithCoder:coder];
	if(self){
		BOOL isConnected = [coder decodeBoolForKey:@"isConnected"];
		if(isConnected){
			_inSHConnectlet = [coder decodeObjectForKey:@"inSHConnectlet"];
			_outSHConnectlet = [coder decodeObjectForKey:@"outSHConnectlet"];
			NSAssert(_inSHConnectlet!=nil, @"Didn't we encode the in connectlet?");
			NSAssert(_outSHConnectlet!=nil, @"Didn't we encode the out connectlet?");
		}
    }
	return self;
}

- (void)dealloc {
	
	_inSHConnectlet = nil;
	_outSHConnectlet = nil;
    [super dealloc];
}

// deep copy
// - (id)copyWithZone:(NSZone *)zone {
//	SHInterConnector* copy = [super copyWithZone:zone];
// Jesus! There is no point just making some new connectlets!
//	BOOL isConnected = [self isConnected];
//	if(isConnected){
//		copy->_inSHConnectlet = [[_inSHConnectlet copy] autorelease];
//		copy->_outSHConnectlet = [[_outSHConnectlet copy] autorelease];
//	}
//	return copy;
//}

- (void)encodeWithCoder:(NSCoder *)coder {

	[super encodeWithCoder:coder];
	BOOL isConnected = [self isConnected];
	if( isConnected ){
		NSAssert(_outSHConnectlet, @"Ic cant just be connected at osne end!");
		[coder encodeConditionalObject:_inSHConnectlet forKey:@"inSHConnectlet"];
		[coder encodeConditionalObject:_outSHConnectlet forKey:@"outSHConnectlet"];
		isConnected = YES;
	}
	[coder encodeBool:isConnected forKey:@"isConnected"];
}

// this works for ics and archived conection info so dont test for == classes
- (BOOL)isEquivalentTo:(id)anObject {

	NSParameterAssert(anObject);
	NSParameterAssert(anObject!=self);
	// not going to call super because it checks for equal classes and this is set up to test an archive and an ic
	// if([super isEquivalentTo:anObject]==NO)
	//	return NO;

	if([anObject isKindOfClass:[self class]])
	{
		if([self isConnected]!=[anObject isConnected] )
			return NO;
		if([self isConnected]){
			NSArray *indexPath1 = [self indexPathsForConnectlets];
			NSArray *indexPath2 = [anObject indexPathsForConnectlets];
			if([indexPath1 isEqual:indexPath2])
				return YES;
		} else {
			// all unconnected ics are equivalent
			return YES;
		}
	}
	/* is anObject archived data about a connection made with - currentConnectionInfo */
	else if([anObject isKindOfClass:[NSArray class]])
	{
		// using indexPathsForConnectlets
		NSArray *indexPath1 = [self indexPathsForConnectlets];
		NSArray *indexPath2 = anObject;
		if([indexPath1 isEqual:indexPath2])
			return YES;
		
		// using currentConnectionInfo
//		id ob1 = [anObject objectAtIndex:0];
//		id ob2 = [anObject objectAtIndex:1];
//		if([ob1 isKindOfClass:[SH_Path class]] && [ob2 isKindOfClass:[SH_Path class]]){
//			
//			SH_Path *inPath = [_parentSHNode relativePathToChild: [_inSHConnectlet parentAttribute]];
//			SH_Path *outPath = [_parentSHNode relativePathToChild: [_outSHConnectlet parentAttribute]];
//			if([inPath isEquivalentTo:ob1] && [outPath isEquivalentTo:ob2])
//				return YES;
//			else
//				return NO;
//		}
	}
	return NO;
}

#pragma mark action methods
- (void)resetNodeSHConnectlets {

	// reset the node outlets at each end of this connector
	[_inSHConnectlet removeAnSHInterConnector:self];
	[_outSHConnectlet removeAnSHInterConnector:self];
	self.inSHConnectlet=nil;
	self.outSHConnectlet=nil;
}

#pragma mark notification methods
- (void)hasBeenAddedToParentSHNode {
	[super hasBeenAddedToParentSHNode];
}

- (void)isAboutToBeDeletedFromParentSHNode {
	[super isAboutToBeDeletedFromParentSHNode];
}

#pragma mark accessor methods
- (SHProtoAttribute *)outOfAtt {
	return [_outSHConnectlet parentAttribute];
}

- (SHProtoAttribute *)intoAtt {
	return [_inSHConnectlet parentAttribute];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ : InterConnector - %@", [super description], _name.value ];
}

/* an array with the paths to the attributes relative from the interconnectors parent @"nodeGroup5/circle/input1" */
- (NSArray *)currentConnectionInfo {

	NSAssert([self isConnected], @"Must be connected!");

 	SH_Path *inPath = [_parentSHNode relativePathToChild: [_inSHConnectlet parentAttribute]];
	SH_Path *outPath = [_parentSHNode relativePathToChild: [_outSHConnectlet parentAttribute]];
	NSAssert(inPath!=nil, @"currentConnectionInfo cant be correct");
	NSAssert(outPath!=nil, @"currentConnectionInfo cant be correct");
	return [NSArray arrayWithObjects:inPath, outPath, nil];
}

/* Use this for archiving ics or currentConnectionInfo? 
	currentConnectionInfo is based on the names of the nodes so.. hmm not sure
 */
- (NSArray *)indexPathsForConnectlets {

	NSAssert([self isConnected], @"Must be connected!");
	NSAssert(_parentSHNode!=nil, @"If we are connected surely we must have a parent?");

	SHProtoAttribute *inAtt = [_inSHConnectlet parentAttribute];
	NSAssert(inAtt, @"cant hve a connectlet without a parent");
	NSArray *inIndexPath = [_parentSHNode indexPathToNode: inAtt];
	
	SHProtoAttribute *outAtt = [_outSHConnectlet parentAttribute];
	NSAssert(outAtt, @"cant hve a connectlet without a parent");

	NSArray *outIndexPath = [_parentSHNode indexPathToNode: outAtt];
	return [NSArray arrayWithObjects:outIndexPath, inIndexPath, nil];
}

//-(NSArray *)getConnectionData
//{
//sh	NSNumber *theInConnectlet	= [[NSNumber numberWithInt:[inConnectlet index]]retain];
//sh	NSNumber *theInNode			= [[NSNumber numberWithInt:[[inConnectlet parentNode] uniqueID]]retain];
//sh	NSNumber *theOutConnectlet	= [[NSNumber numberWithInt:[outConnectlet index]]retain];
//sh	NSNumber *theOutNode		= [[NSNumber numberWithInt:[[outConnectlet parentNode] uniqueID]]retain];
//sh	return [NSArray arrayWithObjects:theInConnectlet, theInNode, theOutConnectlet, theOutNode, nil];
//}

- (BOOL)isConnected {
	
	if(_inSHConnectlet){
		NSAssert(_outSHConnectlet, @"Ic cant just be connected at osne end!");
		return YES;
	}
	return NO;
}

@end
