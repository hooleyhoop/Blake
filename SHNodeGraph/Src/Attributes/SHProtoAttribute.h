//
//  SHProtoAttribute.h
//  SHNodeGraph
//
//  Created by Steven Hooley on 2/25/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "SHChild.h"
#import "SHNodeLikeProtocol.h"
#import "SHValueProtocol.h"

@class SHInterConnector, SHOutlet, SHInlet;

@interface SHProtoAttribute : SHChild <SHNodeLikeProtocol, NSCoding, NSCopying> {

	// N.B.	_value is immutable
@public
	NSObject<SHValueProtocol>		*_value;

	// every Attribute has an outlet and inlet - see diagram 'connectlets.pdf'
	// On an inputAttribute _theOutlet effectively acts as an outputAttribute but isn't to avoid infinite loops
	// On an outputAttribute _theInlet effectively acts as an inputAttribute but isn't to avoid infinite loops
	SHOutlet*					_theOutlet;
	SHInlet*					_theInlet;
	
	BOOL						_isInletConnected, _isOutletConnected;
	
	Class						_dataClass;
	SEL							_selectorToUse;
	
	BOOL						_dirtyBit;
	NSInteger					_dirtyRecursionID;
	
	// used in loops to test if we have been here before
	double						_evalRecursionID;

}

@property(readonly, nonatomic) SHOutlet *theOutlet;
@property(readonly, nonatomic) SHInlet *theInlet;

+ (id)attributeWithType:(NSString *)aDataTypeName;

- (BOOL)connectOutletToInletOf:(SHProtoAttribute *)inAttr withConnector:(SHInterConnector *)aConnector;

- (BOOL)removeInterConnector:(SHInterConnector *)aConnector;

- (BOOL)isInletConnected;
- (void)setIsInletConnected:(BOOL)flag;

- (BOOL)isOutletConnected;
- (void)setIsOutletConnected:(BOOL)flag;

- (NSString *)willAsk;
- (BOOL)setSelectorToUseWhenAnswering:(NSString *)aSelectorName;

- (void)setDirtyBit:(BOOL)flag uid:(int)uid;
- (void)setDirtyBelow:(int)uid;

- (NSObject<SHValueProtocol> *)value;
- (void)setValue:(NSObject<SHValueProtocol> *)a_value;		// always the correct type

- (NSMutableArray *)allConnectedInterConnectors;

- (void)setDataType:(NSString *)aClassName;
- (void)setDataType:(NSString *)aClassName withValue:(id)arg;

- (BOOL)dirtyBit;

- (void)publicSetValue:(id)aValue;

/* Views DO NOT know about dataTypes */
- (id)displayValue;	// like description, but not always an NSString

@end
