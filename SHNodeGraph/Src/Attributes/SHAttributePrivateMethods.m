//
//  SHAttributePrivateMEthods.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 25/05/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHAttributePrivateMethods.h"


@implementation SHAttribute (SHAttributePrivateMethods)


// ===========================================================
// - setOperatorPrivateMember
// ===========================================================
//- (void) setOperatorPrivateMember:(BOOL)flag {
//    operatorPrivateMember = flag;
//}


// ===========================================================
// - initInputs: // for an output Attribute
// ===========================================================
//- (void)initInputs
//{	
//	// here we just add a connectlet - not an attribute, as we dont want an infinite loop where
//	// each attribute has another attribute!!
//
//	// Here connectlets masquerade as attributes to avoid infinite loops
//	// you cant ADD an input without a unique key…
//	[self addPseudoChildInputAttribute: _theInlet withKey:@"input"];
//}

// ===========================================================
// - initOutputs: // for an input Attribute
// ===========================================================
//- (void)initOutputs
//{
//	// Here connectlets masquerade as attributes to avoid infinite loops
//	[self addPseudoChildOutputAttribute: _theOutlet withKey:@"output"];
//}

// ===========================================================
// - addChildInputAttribute: withKey:
// ===========================================================
//- (void)addChildInputAttribute: (id<SHAttributeProtocol>)value withKey:(NSString*) key
//{
//	if(_inputs==nil)
//		_inputs	= [[NSMutableDictionary alloc] initWithCapacity:1 ];
//	if(_orderedInputs==nil)
//		_orderedInputs = [[NSMutableArray alloc] initWithCapacity:1 ];
//	if(_nodesAndAttributesInside==nil)
//		_nodesAndAttributesInside = [[NSMutableArray alloc] initWithCapacity:1 ];
//	
//	id existingObject = [_inputs objectForKey:key];
//	
//	// logInfo(@"SHNode.m: adding inputputAttribute %@ named %@", value, aName );
//	if(existingObject==nil)
//	{
//		[_inputs setObject:value forKey: key ];
//		[_orderedInputs addObject:value];
//		[_nodesAndAttributesInside addObject:value];
//
//		// We need to add this method to attributes 
//		if([(NSObject*)value respondsToSelector:@selector(setParentAttribute:)]) {
//			[(id)value setParentAttribute:self];
//		}
//		
//		// [self setIsLeaf:NO];
//	} else {
//		logInfo(@"SHNode.m: WARNING inputputAttribute %@ named %@ already exists.",  key );
//	}
//	[self postNodeGuiMayNeedRebuildingNotification];
//}

// ===========================================================
// - addChildOutputAttribute: withKey:
// ===========================================================
//- (void)addChildOutputAttribute: (id<SHAttributeProtocol>)value withKey:(NSString*) key
//{
//	if(_inputs==nil)
//		_outputs = [[NSMutableDictionary alloc] initWithCapacity:1 ];
//	if(_orderedInputs==nil)
//		_orderedOutputs = [[NSMutableArray alloc] initWithCapacity:1 ];
//	if(_nodesAndAttributesInside==nil)
//		_nodesAndAttributesInside = [[NSMutableArray alloc] initWithCapacity:1 ];
//	
//	id existingObject = [_outputs objectForKey: key];
//	if(existingObject==nil){
//		// logInfo(@"SHNode.m: adding outputAttribute %@ named %@", value, key );
//		[_outputs setObject:value forKey: key ];
//		[_orderedOutputs addObject:value];
//		[_nodesAndAttributesInside addObject:value];
//
//		// We need to add this method to attributes 
//		if([(NSObject*)value respondsToSelector:@selector(setParentAttribute:)]) {
//			[(id)value setParentAttribute:self];
//		}
//		// [self setIsLeaf:NO];
//	} else {
//		logInfo(@"SHNode.m: WARNING outputAttribute %@ named %@ already exists.",  key );
//	}
//	[self postNodeGuiMayNeedRebuildingNotification];
//}
@end
