//
//  SHSelectableProto_Node.h
//  Pharm
//
//  Created by Steve Hooley on 12/10/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SHNode.h"

@interface SHProto_Node (SHSelectableProto_Node) 

#pragma mark -
#pragma mark action methods


 
 // called by a child when it is selected
- (void) removeIndexOfSelectedSHNode:(unsigned int)anIndex;

- (void) addIndexOfSelectedSHInterConnector:(unsigned int)anIndex;
- (void) removeIndexOfSelectedSHInterConnector:(unsigned int)anIndex;

- (void) updateSelectionStatusOfChildSHInterConnectors;

#pragma mark Private action methods
// makes the selected state of the nodes match the index set
- (void) updateSelectionStatusOfChildSHNodes;

// only unselects the nodes, doesnt change the index set - 
// Dont call this to unselect nodes - set the index set to 0
- (void) setSelectedOfAllChildSHNodesToNO;
- (void) setSelectedOfAllChildInterConnectorsToNO;

#pragma mark accessor methods

- (NSMutableIndexSet *) selectedInterConnectorIndexes;
- (void) setSelectedInterConnectorIndexes:(NSMutableIndexSet*) allSelectionIndexes;
@end
