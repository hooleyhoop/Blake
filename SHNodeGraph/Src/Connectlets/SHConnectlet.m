//
//  Connectlet.m
//  InterfaceTest
//
//  Created by Steve on Sun Jul 04 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

#import "SHConnectlet.h"
#import "SHInlet.h"
#import "SHProtoAttribute.h"
// #import "SHInputAttribute.h"
#import "SHInterConnector.h"

/*
 *
*/
@implementation SHConnectlet

@synthesize parentAttribute=_parentAttribute;
@synthesize shInterConnectors=_shInterConnectors;

#pragma mark -
#pragma mark init methods

- (id)initBase {
	self=[super initBase];
	return self;
}

- (id)initWithAttribute:(SHProtoAttribute *)parentAtt {
	
	self=[super init];
	if( self )
	{
		// logInfo(@"SHConnectlet.m: initing a connectlet. is attribute connectlet? %i", flag);
		_shInterConnectors = nil;
		_parentAttribute = parentAtt;	// potential retain loop here
//31/05/06		_isAttributeConnnectlet	= flag;
//		_auxiliaryData = nil;
		
//sh		[self setName:@"default. needs setting!"];
//sh		[self setParentNode: parent];
//sh		[self setIndex:connectletIndex];
//sh		respondsTo = nil;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	
    self = [super init];
	if(self) {
		_parentAttribute = [coder decodeObjectForKey:@"parentAttribute"];
		NSUInteger numberOfICs = [coder decodeIntForKey:@"numberOfICs"];
		for( NSUInteger i=0; i<numberOfICs; i++ )
		{
			NSString *key = [NSString stringWithFormat:@"shInterConnector-%i",i];
			SHInterConnector *eachIC = [coder decodeObjectForKey:key];
			NSAssert(eachIC!=nil, @"fucked up conditional encoding of ic");
			[self addAnSHInterConnector:eachIC];
		}
	}
    return self;
}

- (void)dealloc {

	[_shInterConnectors release];
//	[_auxiliaryData release];
	
//	_auxiliaryData = nil;
    _parentAttribute = nil;
    [super dealloc];
}

// deep copy
//- (id)g:(NSZone *)zone {
//	
//	SHConnectlet* copy = [super copyWithZone:zone];
//	//copy->_inSHConnectlet = [[_inSHConnectlet copy] autorelease];
//	//copy->_outSHConnectlet = [[_outSHConnectlet copy] autorelease];
//	return copy;
//}

- (void)encodeWithCoder:(NSCoder *)coder {
	
	NSUInteger i=0;
	for( SHInterConnector *eachIC in _shInterConnectors )
	{
		NSString *key = [NSString stringWithFormat:@"shInterConnector-%i",i];
		[coder encodeConditionalObject:eachIC forKey:key];
		i++;
	}
	[coder encodeInt:[_shInterConnectors count] forKey:@"numberOfICs"];
	[coder encodeConditionalObject:_parentAttribute forKey:@"parentAttribute"];
}

#pragma mark action methods
- (BOOL)addAnSHInterConnector:(SHInterConnector *)anSHInterConnector {

	NSParameterAssert(anSHInterConnector);

	if(_shInterConnectors==nil)
		_shInterConnectors = [[NSMutableArray alloc] initWithCapacity: 1];

	if( [_shInterConnectors indexOfObjectIdenticalTo: anSHInterConnector]==NSNotFound ) 
	{
		/* i have just decided that inlets will only have one connection */
		if([self isKindOfClass:[SHInlet class]] && [_shInterConnectors count]!=0){
			NSException* myException = [NSException exceptionWithName:@"inlet cant have multiple connections" reason:@"inlet cant have multiple connections" userInfo:nil];
			@throw myException;
		}
			
		[_shInterConnectors addObject: anSHInterConnector];
		
		// are we now under the influence of another?
		if( [self isKindOfClass:[SHInlet class]] )
		{	
			[_parentAttribute setIsInletConnected:YES];
		} else
		{
			[_parentAttribute setIsOutletConnected:YES];
		}
		return YES;
	}
	return NO;
}

- (BOOL)removeAnSHInterConnector:(SHInterConnector *)anSHInterConnector {

	NSParameterAssert(anSHInterConnector);
	NSAssert([_shInterConnectors indexOfObjectIdenticalTo: anSHInterConnector]!=NSNotFound, @"Must be an ic");
	
//	if(  )
//	{

//2009 This seems wrong! this should be called from parent node
//2009		[anSHInterConnector isAboutToBeDeletedFromParentSHNode];

		[_shInterConnectors removeObjectIdenticalTo: anSHInterConnector];
		
		//logInfo(@"SHConnectlet.m: removing interconnector - what is the retain count?");
		
		// are we still under the influence of an input connection?
		// if( ([_parentAttribute isKindOfClass:[SHOutputAttribute class]]) && ([[(SHOutputAttribute*)_parentAttribute nodesIAmAffectedBy] count]>0) )
		// {
		//	return YES;
		// }
		// if( (([_parentAttribute isKindOfClass:[SHInputAttribute class]]) && ([self isAttributeConnnectlet]==YES)) || ( ([_parentAttribute isKindOfClass:[SHOutputAttribute class]]) && ([self isAttributeConnnectlet]==NO) ))
		// {	
		//	if([_shInterConnectors count]==0)
		//		[_parentAttribute setIsInletConnected:NO];
		// }
		return YES;
//	}
//	return NO;
}

//- (void)isAboutToBeDeletedFromParentSHNodeGroup {
//	
//	[_shInterConnectors makeObjectsPerformSelector:@selector(resetNodeSHConnectlets)];
//}

#pragma mark accessor methods

//- (void) setSHInterConnectors: (NSMutableArray *) anSHInterConnectors {
//    if (_shInterConnectors != anSHInterConnectors) {
//        [anSHInterConnectors retain];
//        [_shInterConnectors release];
//        _shInterConnectors = anSHInterConnectors;
//    }
//}

//- (SHInterConnector*) SHInterConnectorAtIndex:(int)aindex
//{
//	if( aindex<[self numberOfConnections] ){
//		return [_shInterConnectors objectAtIndex: aindex];
//	}
//	return nil;
//}

- (NSUInteger)numberOfConnections {
	
	return [_shInterConnectors count];
}

//- (id<SHValueProtocol>) getValue
//{
	// VIRTUAL overide in inlet and outlet
//	return nil;
//}


//- (NSString*) description
//{
//	return( [NSString stringWithFormat:@"SHConnectlet.m: I have %i _shInterConnectors", [_shInterConnectors count]] );
//}

//- (NSMutableDictionary *) auxiliaryData { return _auxiliaryData; }
//- (void) setAuxiliaryData: (NSMutableDictionary *) anAuxiliaryData {
//    //logInfo(@"in -setAuxiliaryData:, old value of _auxiliaryData: %@, changed to: %@", _auxiliaryData, anAuxiliaryData);
//    if (_auxiliaryData != anAuxiliaryData) {
//        [anAuxiliaryData retain];
//        [_auxiliaryData release];
//        _auxiliaryData = anAuxiliaryData;
//    }
//}

// Virtual
//- (BOOL)isAttributeConnnectlet { return NO; }

//- (void) setIsAttributeConnnectlet: (BOOL) flag {
//	logInfo(@"SHConnectlet.m: setIsAttributeConnnectlet.. %i", flag );
 //   _isAttributeConnnectlet = flag;
//}

// see attached picture. If the connectlet is an attributeLink its _parentAttribute
// is the same as its hostNode.
// If it is an AttributeConnnectlet it hostnode is it's _parentAttribute's parentNodeGroup
//- (id) hostNode
//{
//	if([self isAttributeConnnectlet]){
//		return (SHNode*)[_parentAttribute parentSHNode];
//	} else {
//		return _parentAttribute;
//	}
//}
				
// - (BOOL)isInlet { return NO; }
//- (BOOL)isOutlet { return NO; }

// hm, these are virtual methods making sure i conform to SHAttributeProtocol
//- (void) setDataType:(NSString*)aClassName
//{
//	logInfo(@"SHConnectlet.m: ERROR! Called virtual method 'setDataType'");
//}

//- (NSString*) dataType
//{
//	logInfo(@"SHConnectlet.m: ERROR! Called virtual method 'dataType'");
//	return nil;
//}

//- (id) getAuxObjectForKey:(NSString*)aKey
//{
//	return [_auxiliaryData objectForKey:aKey];
//}

//- (void) setAuxObject:(id)anObject forKey:(NSString*)aKey
//{
//	if(_auxiliaryData==nil)
//		_auxiliaryData = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
//
//	[_auxiliaryData setObject:anObject forKey:aKey];
//}

//-(BOOL) isConnected
//{
//	if([_shInterConnectors count]>0)
//		return YES;
//	return NO;
//}

@end


