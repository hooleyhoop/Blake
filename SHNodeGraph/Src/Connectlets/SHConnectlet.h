//
//  Connectlet.h
//  InterfaceTest
//
//  Created by Steve on Sun Jul 04 2004.
//  Copyright (c) 2004 HooleyHoop. All rights reserved.
//

@class SHInterConnector, SHProtoAttribute, SHNode;


/*
 * SHConnectlet: VIRTUAL
 * Use SHInlet or SHOutlet
 * Each input/output property has one kind of SHConnectlet
 * So that it can be connected to other properties.
*/
@interface SHConnectlet : _ROOT_OBJECT_ <NSCoding>
{

//	// here. These need to know more about themselves!
//	BOOL _isInlet, i_sOutlet;
//	
//	
//	// connectlet has a name so you can see what the value does when you roll over it
	NSMutableArray					*_shInterConnectors;		// an array so that you can have multiple interconnectors from 1 connectlet
//	// int							_index;						// inlet 1, 2, 3, etc.
//	// NSString*					_name;
//	NSMutableDictionary*			_auxiliaryData;	
	SHProtoAttribute*				_parentAttribute;
//	
//	BOOL							_isAttributeConnnectlet;	// Is either an AttributeConnnectlet or an attributeLink
																// The difference is to do with how they find their absolute position
}

@property (readonly, nonatomic) NSArray						*shInterConnectors;
@property (assign, readwrite, nonatomic) SHProtoAttribute	*parentAttribute;

#pragma mark -
#pragma mark init methods
- (id)initWithAttribute:(SHProtoAttribute *)parentAttribute;

#pragma mark awakeFromNib-like methods

#pragma mark action methods
- (BOOL)addAnSHInterConnector:(SHInterConnector *)anSHInterConnector; 
- (BOOL)removeAnSHInterConnector:(SHInterConnector *)anSHInterConnector;

//- (void) isAboutToBeDeletedFromParentSHNodeGroup;

#pragma mark accessor methods
//- (void) setSHInterConnectors: (NSMutableArray *) anSHInterConnectors;
//- (SHInterConnector*) SHInterConnectorAtIndex: (int)index;

- (NSUInteger)numberOfConnections;

//// - (id<SHValueProtocol>) getValue; // VIRTUAL overide in inlet and outlet
//
//- (NSMutableDictionary *) auxiliaryData;
//- (void) setAuxiliaryData: (NSMutableDictionary *) anAuxiliaryData;

//- (BOOL)isAttributeConnnectlet;
////- (void)setIsAttributeConnnectlet:(BOOL) flag;

//- (id) hostNode;	// see attached picture. If the connectlet is an attributeLink its parentAttribute
//						// is the same as its hostNode.
//						// If it is an AttributeConnnectlet it hostnode is it's parentAttribute's parentNodeGroup
//
//

//- (BOOL)isInlet;
////- (void) setIsInlet: (BOOL) flag;
//- (BOOL) isOutlet;
////- (void) setIsOutlet: (BOOL) flag;
//
//
//// hm, these are virtual methods making sure i conform to SHAttributeProtocol
////- (void) setDataType:(NSString*)aClassName;
////- (NSString*) dataType;
//
//- (id) getAuxObjectForKey:(NSString*)aKey;
//- (void) setAuxObject:(id)anObject forKey:(NSString*)aKey;
//
//// - (NSString *) name;
//// - (void) setName: (NSString *) aName;
//
//// - (NSArray *) respondsTo;
//// - (void) setRespondsTo: (NSArray *) aRespondsTo;
//
//// - (BOOL) respondToSameSelector: (SHConnectlet*) anotherSHConnectlet;
//
//// - (int)index;
//// - (void)setIndex:(int)anIndex;
//
//-(BOOL) isConnected;

@end


