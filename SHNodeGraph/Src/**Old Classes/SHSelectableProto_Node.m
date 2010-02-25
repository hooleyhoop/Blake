//
//  SHSelectableProto_Node.m
//  Pharm
//
//  Created by Steve Hooley on 12/10/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SHSelectableProto_Node.h"
#import "SHNodeGroup.h"
#import "SHConnectableNode.h"

@implementation SHProto_Node (SHSelectableProto_Node) 

#pragma mark -
#pragma mark init methods


#pragma mark action methods

//=========================================================== 
// - removeIndexOfSelectedSHNode:
//=========================================================== 
- (void) removeIndexOfSelectedSHNode:(unsigned int)anIndex
{
	// NSLog(@"SHSelectableProto_Node.m: removeIndexOfSelectedSHNode: About to call set selectedNodeIndexes" );
	if( [_selectedNodeIndexes containsIndex:anIndex]) {
		[_selectedNodeIndexes removeIndex:anIndex];
		[self setValue:_selectedNodeIndexes forKeyPath:@"selectedNodeIndexes"]
	} else {
		NSLog(@"SHSelectableProto_Node.m: ERROR! anIndex isnt in the set %i", anIndex );
		if([_selectedNodeIndexes count]>0)
			NSLog(@"next available index is %i", [_selectedNodeIndexes firstIndex]);
		else
			NSLog(@"ERROR! The index set is empty");
	}
}

//=========================================================== 
// - addIndexOfSelectedSHInterConnector:
//=========================================================== 
- (void) addIndexOfSelectedSHInterConnector:(unsigned int)anIndex
{
	// NSLog(@"SHSelectableProto_Node.m: addIndexOfSelectedSHInterConnector: anIndex %i", anIndex);
	[_selectedInterConnectorIndexes addIndex:anIndex];
	[self setValue:_selectedInterConnectorIndexes forKeyPath:@"selectedInterConnectorIndexes"];
}

//=========================================================== 
// - removeIndexOfSelectedSHInterConnector:
//=========================================================== 
- (void) removeIndexOfSelectedSHInterConnector:(unsigned int)anIndex
{
	if( [_selectedInterConnectorIndexes containsIndex:anIndex]){
		[_selectedInterConnectorIndexes removeIndex:anIndex];
		[self setValue:_selectedInterConnectorIndexes forKeyPath:@"selectedInterConnectorIndexes"];
	}
}


#pragma mark Private action methods


// ===========================================================
// - setSelectedOfAllChildSHNodesToNO:
// ===========================================================
- (void) setSelectedOfAllChildSHNodesToNO
{
	// Unselect the nodes
	NSEnumerator *enumerator = [_selectedChildSHNodes objectEnumerator];
	SHNode* anode;
	while (anode = [enumerator nextObject]){
		if(anode!=nil && [anode isKindOfClass:[SHSelectableProto_Node class]]){
			[(SHSelectableProto_Node*)anode setSelectedFlag:NO];
		}
	}
	[_selectedChildSHNodes removeAllObjects];
}


// ===========================================================
// - setSelectedOfAllChildInterConnectorsToNO:
// ===========================================================
- (void) setSelectedOfAllChildInterConnectorsToNO
{
	// now the interconnectors
	NSEnumerator *enumerator = [_selectedChildSHInterConnectors objectEnumerator];
	SHNode* anode;
	while (anode = [enumerator nextObject]){
		if(anode!=nil && [anode isKindOfClass:[SHSelectableProto_Node class]]){
			[(SHSelectableProto_Node*)anode setSelectedFlag:NO];
		}
	}
	[_selectedChildSHInterConnectors removeAllObjects];
}

#pragma mark accessor methods


- (NSMutableIndexSet *) selectedInterconnectorIndexes
{
	return _selectedInterConnectorIndexes;
}

- (void) setSelectedInterconnectorIndexes:(NSMutableIndexSet*) allSelectionIndexes
{
	// to do
}

// ===========================================================
// - updateSelectionStatusOfChildSHInterConnectors
// ===========================================================
- (void) updateSelectionStatusOfChildSHInterConnectors
{
//09/05/2006 //	if([_selectedInterConnectorIndexes count]>0)
//09/05/2006 //	{
//09/05/2006 		NSMutableIndexSet *tempSet	= [_selectedInterConnectorIndexes mutableCopy];
//09/05/2006 		
//09/05/2006 		[self setSelectedOfAllChildInterConnectorsToNO];
//09/05/2006 		// NSLog(@"SHNodeGroup.m: Setting the selection indexes");
//09/05/2006 		// enumerate the index set
//09/05/2006 		unsigned currentIndex = [tempSet firstIndex];
//09/05/2006 		while (currentIndex != NSNotFound)
//09/05/2006 		{
//09/05/2006 			SHNode* aChildNode = [_sHInterConnectorsInside_Array objectAtIndex:currentIndex];
//09/05/2006 			if(aChildNode!=nil && [aChildNode isKindOfClass:[SHSelectableProto_Node class]])
//09/05/2006 			{
//09/05/2006 				[_selectedChildSHInterConnectors addObject:aChildNode];
//09/05/2006 				// _lastSelectedChild = aChildNode;	// No equivalent of this for interconnectors yet
//09/05/2006 				[(SHSelectableProto_Node*)aChildNode setSelectedFlag:YES];
//09/05/2006 			}
//09/05/2006 			currentIndex = [tempSet indexGreaterThanIndex:currentIndex];
//09/05/2006 		}
//09/05/2006 //	} else {
//09/05/2006 //		NSLog(@"SHNodeGroup.m: Not UPDATING FUCK ALL!!!");
//09/05/2006 //	}
}

//=========================================================== 
// - selectedInterConnectorIndexes:
//=========================================================== 
- (NSMutableIndexSet *) selectedInterConnectorIndexes { 
	// NSLog(@"SHSelectableProto_Node.m: something is asking for selection indexes %@", _selectedNodeIndexes);
	return _selectedInterConnectorIndexes;
}

//=========================================================== 
// - setSelectedInterConnectorIndexes:
//=========================================================== 
- (void) setSelectedInterConnectorIndexes:(NSMutableIndexSet *)a_selectionIndexes
{
	if( [a_selectionIndexes class]==[NSIndexSet class]){
		a_selectionIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:a_selectionIndexes];   // designated initializer
		if( [a_selectionIndexes class]==[NSIndexSet class]){
			NSLog(@"SHSelectableProto_Node.m: shit! it didnt make a mutable version");
		}
		
	}
    if (_selectedInterConnectorIndexes != a_selectionIndexes) {
        [a_selectionIndexes retain];
        [_selectedInterConnectorIndexes release];
        _selectedInterConnectorIndexes = a_selectionIndexes;
    }
	[self updateSelectionStatusOfChildSHInterConnectors];
	
	NSDictionary *d = [NSDictionary dictionaryWithObject:_selectedInterConnectorIndexes forKey:@"theIndexes"];
	NSNotification *n = [NSNotification notificationWithName:@"SHSelectedConnectorIndexesChanged" object:self userInfo:d];
	[[NSNotificationCenter defaultCenter] postNotification: n ];
	// NSLog(@"SHSelectableProto_Node.m: setting sel ind %@", [_selectedNodeIndexes description]);
}


@end
