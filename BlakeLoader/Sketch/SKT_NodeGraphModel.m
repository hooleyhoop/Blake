//
//  SKT_NodeGraphModel.m
//  BlakeLoader2
//
//  Created by steve hooley on 02/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKT_NodeGraphModel.h"
#import "SKTGroup.h"

@implementation SHNodeGraphModel (SKT_NodeGraphModel)

#warning - consider using an NSSet for inclusion testing - try using removeObjectIdenticalTo for removeObject, indexOfObjectIdenticalTo for indexOfObject - lets not use 'containsObject'

- (void)skt_groupSelection {
	
	//-- get selected items
	NSArray *selectedObjects = [[[self selectedObjects] copy] autorelease];
	if([selectedObjects count]>1)
	{
		NSMutableIndexSet *selectedIndexes = [[[self selectionIndexes] copy] autorelease];
		// -- remove them
		[self changeSelectionTo:[NSIndexSet indexSet]];
		[self removeGraphicsAtIndexes:selectedIndexes];
		// -- add sktgroup
		SKTGroup *newGroup = [[[SKTGroup alloc] init] autorelease];
		//-- add items to group
		[newGroup addSceneItems: selectedObjects];
		[self insertGraphic:newGroup atIndex:0];
	}
}

- (void)skt_ungroupSelection {
	
	// -- is the selecte item a gtoup?
	NSArray *selectedObjects = [self selectedObjects];
	if([selectedObjects count]==1 && [[selectedObjects lastObject] isKindOfClass:NSClassFromString(@"SKTGroup")])
	{
		SKTGroup *groupToDelete = [selectedObjects lastObject];
		//-- if it is copy out its children
		NSArray *groupedGraphics = [groupToDelete groupedSceneItems];
		//--remove the group
		[self changeSelectionTo:[NSIndexSet indexSet]];
		[self removeGraphicAtIndex: [[self graphics] indexOfObjectIdenticalTo: groupToDelete]];
		
		//-- paste back the children
#warning - we will need to sort children into inputs, outputs, etc..
		[self insertGraphics:groupedGraphics atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [selectedObjects count])]];
	}
}

@end
