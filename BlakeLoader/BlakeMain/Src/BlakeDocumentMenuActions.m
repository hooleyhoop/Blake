//
//  BlakeDocumentMenuActions.m
//  BlakeLoader2
//
//  Created by steve hooley on 06/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//

#import "BlakeDocumentMenuActions.h"

/* 
 * Given the name of a menu action (say @"DoStuff") return a Selector -canDoStuff
 */
SEL _getCanDoSelectorFromActionName( NSString *actionName ) {
	
	NSString *modifiedActionName = [actionName removeLastCharacter];
	modifiedActionName = [modifiedActionName makeFirstCharUppercase];
	modifiedActionName = [modifiedActionName prepend:@"can"];
	SEL foundSelector = NSSelectorFromString(modifiedActionName);
	NSCAssert(foundSelector, @"error manipulating action name");
	return foundSelector;
}

#pragma mark -
/*
 *
*/
@implementation BlakeDocument (BlakeDocumentMenuActions) 

const char *_menuActions[17] = {
	"saveDocument:",
	"saveDocumentAs:",
	"revertDocumentToSaved:",
	"cut:",
	"copy:",
	"paste:",
	"delete:",
	"selectAllChildren:",
	"deSelectAllChildren:",
	"duplicate:",
	"addNewEmptyGroup:",
	"addNewInput:",
	"addNewOutput:",
	"moveUpToParent:",
	"moveDownToChild:",
	"group:",
	"unGroup:" };

/* Default implementation handles Revert(only when we have a valid fileURL) and Save */
- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem {
	
	logInfo(@"DOCUMENT validateUserInterfaceItem %@", NSStringFromSelector([anItem action]));
	
	BOOL validItem = NO;
	BOOL foundCanDoSelector=NO;
	SEL userInterfaceItemActionSel = [anItem action];

	for( NSUInteger i=0; i<sizeof(_menuActions); i++)
	{
		char *menuActionName = (char *)_menuActions[i];
		NSString *menuActionNameNS = [NSString stringWithCString:menuActionName];
		
		if( userInterfaceItemActionSel==NSSelectorFromString(menuActionNameNS) )
		{
			SEL canDoSelector = _getCanDoSelectorFromActionName(menuActionNameNS);
			validItem = [self performInstanceSelectorReturningBool:canDoSelector];
			foundCanDoSelector=YES;
			break;
		}
	}
	
	/*	In the docs it explicitly states that if you overide validateUserInterfaceItem: you must call super for items you dont handle yourself.
	 Should we be overiding save and revert which are already handled for us?
	 validItem = [super validateUserInterfaceItem:anItem];
	*/
	
	NSAssert( foundCanDoSelector, @"Did not find a -canDo(x) selector for that Menu Action");	
	return validItem;
}

#pragma mark -
#pragma mark Menu Action Methods
#pragma mark -

// As window implements -undo we won't receive this automatically. Do we want to tho? That is the question…
//- (IBAction)undo:(id)sender {}
//- (IBAction)redo:(id)sender {}
//- (BOOL)canUndo {}
//- (BOOL)canRedo {}

- (IBAction)cut:(id)sender {
	
	[self copy:nil];
	[self delete:nil];
}

/*	You have to be very careful with this sendSelector: stuff that another object nearer the top of the responder chain
 doesn't implement your method.. eg. A textField might respond to copy before we get to the viewController. Hence silly names like copyCurrentObjects */
- (IBAction)copy:(id)sender {
	
//jan10	[_sharedApp sendSelector:@selector(copyCurrentObjects)];
}

- (IBAction)paste:(id)sender {
	
//jan10	[_sharedApp sendSelector:@selector(myPaste)];
}

- (IBAction)delete:(id)sender {
	
//jan10	[_sharedApp sendSelector:@selector(myDelete)];
}

- (IBAction)selectAllChildren:(id)sender {
	
//jan10	[_sharedApp sendSelector:@selector(selectAllChildren)];
	//put back	[displayedNodesTableView selectAll:self];

}

- (IBAction)deSelectAllChildren:(id)sender {
	
//jan10	[_sharedApp sendSelector:@selector(deSelectAllChildren)];
	//put back	[displayedNodesTableView deselectAll:self];

}

- (IBAction)duplicate:(id)sender {
	
//jan10	NSAssert(_documentController, @"need a _documentController");
	
//jan10	BlakeDocument *doc = (BlakeDocument *)[_documentController frontDocument];
//jan10	return [doc duplicate];
	
	[self copy:nil];
	[self paste:nil];
}

- (IBAction)addNewEmptyGroup:(id)sender {
	
//jan10	NSAssert(_documentController, @"need a _documentController");
//jan10	BlakeDocument* doc = (BlakeDocument *)[_documentController frontDocument];
//jan10	[doc makeEmptyGroupInCurrentNodeWithName:@"Untitled Group"];
}

- (IBAction)addNewInput:(id)sender {
	
//jan10	NSAssert(_documentController, @"need a _documentController");	
//jan10	BlakeDocument *doc = (BlakeDocument *)[_documentController frontDocument];
//jan10	[doc makeInputInCurrentNodeWithType:@"mockDataType"];
}

- (IBAction)addNewOutput:(id)sender {
	
//jan10	NSAssert(_documentController, @"need a _documentController");
//jan10	BlakeDocument *doc = (BlakeDocument *)[_documentController frontDocument];
//jan10	[doc makeOutputInCurrentNodeWithType:@"mockDataType"];
}

- (IBAction)moveUpToParent:(id)sender {
	
	[_nodeGraphModel moveUpAlevelToParentNodeGroup];
}

- (IBAction)moveDownToChild:(id)sender {
	
//jan10	[_nodeGraphModel moveDownALevelIntoNodeGroup: aNodeGroup];
}

- (IBAction)group:(id)sender {
	
//jan10	NSArray *allSelectedNodes = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
//jan10	[self groupChildren:allSelectedNodes];
}

- (IBAction)unGroup:(id)sender {
	
	NSArray *allSelectedNodes = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
	
	// TODO: allowsCustomization?
	for( id childToUngroup in allSelectedNodes ) {
		if( [childToUngroup isKindOfClass:[SHNode class]] && [childToUngroup allowsSubpatches] ) {
//jan10			[self unGroupNode: childToUngroup];
		}
	} 	
}

#pragma mark -
#pragma mark Menu Action Validation Methods
#pragma mark -
- (BOOL)canSaveDocument {

	if([self isDocumentEdited])
		return YES;
	return NO;
}

- (BOOL)canSaveDocumentAs {

	if([self isDocumentEdited])
		return YES;
	return NO;
}

// I think this is what the default implementation does
- (BOOL)canRevertDocumentToSaved {

	if([self isDocumentEdited] && [self fileURL]!=nil)
		return YES;
	return NO;
}

- (BOOL)canCut {
	
	//jan10	return [self canCopy];
	return NO;
}

- (BOOL)canCopy {
	
//jan10	BOOL canCopy = [_sharedApp sendSelectorReturningBool:@selector(canCopy)];
//jan10	return canCopy;
	return NO;
}

- (BOOL)canPaste {
	
//jan10	BOOL canPaste = [_sharedApp sendSelectorReturningBool:@selector(canPaste)];
//jan10	return canPaste;
	return NO;
}

- (BOOL)canDelete {
	
//jan10	BOOL canDelete = [_sharedApp sendSelectorReturningBool:@selector(canDelete)];
//jan10	return canDelete;
	return NO;
}

- (BOOL)canSelectAllChildren {
	return NO;
}

// Are some items in the table selected? Examine the tables arrayController 'selectionIndexes' binding to find out
- (BOOL)canDeSelectAllChildren {
//jan10	NSIndexSet *selectedIndexes = [self selectionInModel];
//jan10	return [selectedIndexes count] > 0;
	return NO;
}

- (BOOL)canDuplicate {
	
//jan10	NSIndexSet *selectedIndexes = [self selectionInModel];
//jan10	return [selectedIndexes count] > 0;
	return NO;
}

- (BOOL)canAddNewEmptyGroup {

//jan10	return [self _currentGroupCanBeCustomized];
	
	//	if([filterType isEqualToString:@"All"] || [filterType isEqualToString:@"Nodes"])
	//		return YES;
	return NO;
}

- (BOOL)canAddNewOutput {

//jan10	return [self _currentGroupCanBeCustomized];
	
	//	if([filterType isEqualToString:@"All"] || [filterType isEqualToString:@"Outputs"])
	//		return YES;
	return NO;
}

- (BOOL)canAddNewInput {

//jan10	return [self _currentGroupCanBeCustomized];
	//	if([filterType isEqualToString:@"All"] || [filterType isEqualToString:@"Inputs"])
	//		return YES;
	return NO;
}

- (BOOL)canMoveUpToParent {
	
//jan10	SHNode *currentNode = [_nodeGraphModel currentNodeGroup];
//jan10	if( currentNode.parentSHNode!=nil && [currentNode isKindOfClass:[SHNode class]] )
//jan10		return YES;
	return NO;
}

- (BOOL)canMoveDownToChild {
	
//jan10	NSArray *allSelectedNodes = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
//jan10	if([allSelectedNodes count]==1){
//jan10		id singleSelectedObject = [allSelectedNodes objectAtIndex:0];
//jan10		if(singleSelectedObject!=nil && [singleSelectedObject isKindOfClass:[SHNode class]] && [singleSelectedObject allowsSubpatches])
//jan10			return YES;
//jan10	} else {
//jan10		// logInfo(@"there are %i selected items", [allSelectedNodes count]);
//jan10	}
	return NO;
}

- (BOOL)canGroup {
	
//jan10	NSArray *allSelectedNodes = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
//jan10	if([allSelectedNodes count]>0){
//jan10		return YES;
//jan10	} 
	return NO;	
}

- (BOOL)canUnGroup {
	
//jan10	NSArray *allSelectedNodes = [_nodeGraphModel allSelectedChildrenFromCurrentNode];
//jan10	for(id child in allSelectedNodes){
//jan10		if([child isKindOfClass:[SHNode class]] && [child allowsSubpatches])
//jan10			return YES;
//jan10	} 
	return NO;	
}

@end
