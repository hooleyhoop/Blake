//
//  BlakeDocumentMenuActions.h
//  BlakeLoader2
//
//  Created by steve hooley on 06/01/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import "BlakeDocument.h"

/* 
 * These are the default actions for the menu items
 * A specific view or window may want to overide these
*/
@interface BlakeDocument (BlakeDocumentMenuActions)

// MENU ACTIONS
// Implemented in NSDocument
//- (IBAction)saveDocument:(id)sender;
//- (IBAction)saveDocumentAs:(id)sender;
//- (IBAction)revertDocumentToSaved:(id)sender;

- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)selectAllChildren:(id)sender;
- (IBAction)deSelectAllChildren:(id)sender;
- (IBAction)duplicate:(id)sender;
- (IBAction)addNewEmptyGroup:(id)sender;
- (IBAction)addNewInput:(id)sender;
- (IBAction)addNewOutput:(id)sender;
- (IBAction)moveUpToParent:(id)sender;
- (IBAction)moveDownToChild:(id)sender;
- (IBAction)group:(id)sender;
- (IBAction)unGroup:(id)sender;

// MENU ACTION VALIDATION
- (BOOL)canSaveDocument;
- (BOOL)canSaveDocumentAs;
- (BOOL)canRevertDocumentToSaved;

- (BOOL)canCut;
- (BOOL)canCopy;
- (BOOL)canPaste; 
- (BOOL)canDelete;
- (BOOL)canSelectAllChildren;
- (BOOL)canDeSelectAllChildren;
- (BOOL)canDuplicate;
- (BOOL)canAddNewEmptyGroup;
- (BOOL)canAddNewOutput;
- (BOOL)canAddNewInput;
- (BOOL)canMoveUpToParent;
- (BOOL)canMoveDownToChild;
- (BOOL)canGroup;
- (BOOL)canUnGroup;

@end
