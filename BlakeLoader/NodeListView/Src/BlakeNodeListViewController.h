//
//  BlakeNodeListViewController.h
//  BlakeLoader
//
//  Created by steve hooley on 05/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <SHShared/SHViewControllerProtocol.h>

@class SHRootNodeListTableView, SHNode, FilteringArrayController, BlakeNodeListWindowController;


@interface BlakeNodeListViewController : NSResponder <SHViewControllerProtocol, SHContentProviderUserProtocol> {

	IBOutlet BlakeNodeListWindowController	*docWindowController;
	IBOutlet NSView							*contentView;

	IBOutlet SHRootNodeListTableView		*displayedNodesTableView; // the tableViews are in scroll views
	IBOutlet FilteringArrayController		*displayedNodesArrayController;	
	IBOutlet NSTextField					*infoText;
	SHNode									*currentNodeGroup;
	NSString								*filterType;
	NSString								*selectionKeyPath; // changes when you select a filter type
	
	BOOL									_selectionIsBound;
	
	AbtractModelFilter						*_filter; // set when we register with the model

	BOOL _tableViewSelectionIsDisabled;
}

@property (assign, readwrite, nonatomic) AbtractModelFilter *filter;

+ (NSArray *)icons;

- (void)setup;
- (void)tearDown;

- (IBAction)doubleClick:(id)tableView;

/* are we working on nodes, outputs, inputs or connections? */
- (void)setFilterType:(NSString *)value;

#pragma mark accessor methods
@property(assign, readwrite, nonatomic) BlakeNodeListWindowController	*docWindowController;
@property(retain, readwrite, nonatomic) NSView							*contentView;

@property(assign, readwrite, nonatomic) FilteringArrayController		*displayedNodesArrayController;
@property(assign, readwrite, nonatomic) SHRootNodeListTableView			*displayedNodesTableView;
@property(assign, readwrite, nonatomic) NSTextField						*infoText;
@property(assign, readwrite, nonatomic) NSString						*filterType;
@property(retain, readwrite, nonatomic) SHNode							*currentNodeGroup;
@property(retain, readwrite, nonatomic) NSString						*selectionKeyPath;

/* stubs to update kvc */
- (SHNode *)currentNodeGroup;
- (void)setCurrentNodeGroup:(SHNode *)value;

// - (NSMutableIndexSet *)selection;

// davejJones what i will need..

// davejJones - nodes				- selected node indexes
// davejJones - inputs			- selected input indexes
// davejJones - connectors		- selected connector indexes


// davejJones - we can bind to nodes and attribtes to create our own inputs selected index

// davejJones - (NSMutableIndexSet *)selectedNodeAndAttributeIndexes
// davejJones - (void)setSelectedNodeAndAttributeIndexes:(NSMutableIndexSet *)value

// davejJones - (NSMutableIndexSet *)selectedInterConnectorIndexes
// davejJones - (void)setSelectedInterConnectorIndexes:(NSMutableIndexSet *)value

// davejJones - (NSMutableIndexSet *)selectedInputIndexes
// davejJones - (void)setSelectedInputIndexes:(NSMutableIndexSet *)value

// davejJones - (NSMutableIndexSet *)selectedOutputIndexes
// davejJones - (void)setSelectedOutputIndexes:(NSMutableIndexSet *)value
- (int)kindOfObjectAtIndex:(int)ind;
- (void)copyCurrentObjects;

- (BOOL)canCopy;
- (BOOL)canPaste;
- (BOOL)canDelete;

- (void)myPaste;

/*	These methods and others are deliberatly named not to clash with standard methods as this would fuck up our responder chain search
	for a method to call. ie we would end up returning a textfield or something if we searched the responder chain for an object that respondsto selectAll: 
*/
//jan10- (void)selectAllChildren;
- (void)myDelete;

- (IBAction)butonPressed:(id)sender;

/* Any responder that accepts paste actions must implement this */
- (NSArray *)readablePasteboardTypes;

#pragma mark tableView delegate methods
// - (int)tableView:(NSTableView *)tv colorIndexForRow:(int)rowIndex;

- (NSDragOperation)_validateFileDrop:(id <NSDraggingInfo>)info;
- (NSDragOperation)_validateSameTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op;
- (NSDragOperation)_validateDifferentTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op;

- (BOOL)_acceptFileDrop:(id <NSDraggingInfo>)info row:(int)row;
- (BOOL)_acceptSameTableDrop:(id <NSDraggingInfo>)info row:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
- (BOOL)_acceptDifferentTableDrop:(id <NSDraggingInfo>)info row:(int)row proposedDropOperation:(NSTableViewDropOperation)op;

- (NSMutableIndexSet *)selectionInModel;
- (void)setSelectionInModel:(NSIndexSet *)value;

- (void)beginListenForSelectionChangeInModel;
- (void)stopListenForSelectionChangeInModel;

- (void)disableTableUpdates;
- (void)enableTableUpdates;

@end
