//
//  SHConnectableNode.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 19/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

#import "SHNode.h"

@class SHInterConnector, SHProtoAttribute;

/*
 *
*/
@interface SHNode (SHConnectableNode) 

#pragma mark -
#pragma mark action methods
- (SHInterConnector *)connectAttributeAtRelativePath:(SH_Path *)p1 toAttributeAtRelativePath:(SH_Path *)p2 undoManager:(NSUndoManager *)um;
- (SHInterConnector *)connectOutletOfAttribute:(SHProtoAttribute *)att1 toInletOfAttribute:(SHProtoAttribute *)att1 undoManager:(NSUndoManager *)um;

// - (SHInterConnector*) connectOutputAttributeNamed:(NSString*)out_attName ofNodeNamed:(NSString*)anode toInputAtttributeNamed:(NSString*)in_attName ofNodeNamed:(NSString*)anotherNode;
// - (SHInterConnector*) connectOutputAttribute:(GLint)out_attUID ofNode:(GLint)anode toInputAtttribute:(GLint)in_attUID ofNode:(GLint)anotherNode;

- (NSArray *)interConnectorsDependantOnChildren:(NSArray *)children;

#pragma mark accessor methods
//- (id)interConnectorWithKey:(NSString *)key;
//- (SHOrderedDictionary *)SHInterConnectorsInside;
- (int)indexOfInterConnector:(SHInterConnector *)aConnector; // may return NSNotFound

#pragma mark notification methods
//- (void)postSHInterConnectorAdded_Notification:(id)interCon;
//- (void)postSHInterConnectorDeleted_Notification:(id)interCon;

@end
