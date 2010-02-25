//
//  BlakeNodeListViewController.m
//  BlakeLoader
//
//  Created by steve hooley on 05/01/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "BlakeNodeListViewController.h"
#import "SHRootNodeListTableView.h"
#import "BlakeDocument.h"
#import "HighLevelBlakeDocumentActions.h"
#import "defs.h"

// static BlakeNodeListViewController *lastViewController;
static NSImage *smallNodeIcon, *smallInputIcon, *smallOutputIcon, *smallConnectorIcon;


/*
 * 
*/
@interface BlakeNodeListViewController (PrivateMethods)
	
	- (NSArray *)nodesInCurrentNodeGroup_Array;
	- (void)setNodesInCurrentNodeGroup_Array:(NSArray *)nodeArray;

@end


/*
 *
*/
@implementation BlakeNodeListViewController

@synthesize filter=_filter;

#pragma mark -
#pragma mark class methods
+ (void)initialize {

	static BOOL isInitialized = NO;
	if( !isInitialized )
	{
		isInitialized=YES;
		NSBundle* thisBundle = [NSBundle bundleForClass:NSClassFromString(@"BlakeNodeListViewController")];
		NSString *path1 = [thisBundle pathForImageResource:@"SmallNodeIcon"];
		NSString *path2 = [thisBundle pathForImageResource:@"SmallInputIcon"];
		NSString *path3 = [thisBundle pathForImageResource:@"SmallOutputIcon"];
		NSString *path4 = [thisBundle pathForImageResource:@"SmallConnectorIcon"];
		NSAssert((path1!=nil)&&(path2!=nil)&&(path3!=nil)&&(path4!=nil), @"where are our images?");
		
		smallNodeIcon = [[NSImage alloc] initWithContentsOfFile: path1];
		smallInputIcon = [[NSImage alloc] initWithContentsOfFile: path2];
		smallOutputIcon = [[NSImage alloc] initWithContentsOfFile: path3];
		smallConnectorIcon = [[NSImage alloc] initWithContentsOfFile: path4];
	}
}

+ (NSArray *)icons {
	return [NSArray arrayWithObjects:smallNodeIcon, smallInputIcon, smallOutputIcon, smallConnectorIcon, nil];
}

#pragma mark init methods
//- (id)init {
//	if( (self = [super init])!=nil )
//    {
//		lastViewController = self;
//	}
//    return self;
//}


- (void)dealloc {
    [super dealloc];
}


- (void)awakeFromNib {
	
	/* one for each setting of forLocal */
	[displayedNodesTableView setDraggingSourceOperationMask:NSDragOperationCopy|NSDragOperationMove forLocal:NO];
	[displayedNodesTableView setDraggingSourceOperationMask:NSDragOperationCopy|NSDragOperationMove forLocal:YES];
}

//	SHOrderedDictionary			*_inputs, *_outputs;			
//	SHOrderedDictionary*		_nodesInside;				// (SHNodes) All nodes BUT NOT attributes 
//	SHOrderedDictionary*		_shInterConnectorsInside;
#pragma mark action methods
/* called when the window finishes loading */
- (void)setup {

	// I think my way is better
	// see http://katidev.com/blog/ for good reason why we should patch responder chain above window - not between view and window. 
	// Also see TreeViewMainWindowController and get that working first (has both ways implemented) so we can test.
	[NSResponder insert:self intoResponderChainAbove:contentView];
	
	/* for the filtering array controller */
	[displayedNodesArrayController setPropertyToMatch:@"name.value"];
	SHNodeGraphModel* graphModel = [(BlakeDocument *)[docWindowController document] nodeGraphModel];
	NSAssert(graphModel != nil, @"BlakeNodeListViewController.m: ERROR: There is no GraphModel To Connect to.");

	SHNode *rootNode = [graphModel currentNodeGroup];
	self.currentNodeGroup = rootNode;

	/* Initially we will be operating on Nodes */
	self.filterType = @"All";

	[displayedNodesTableView setTarget:self];
	[displayedNodesTableView setDoubleAction:@selector(doubleClick:)];

	// Not sure whether to use the notification (on the main thread, queud) or just observe it directly
	[graphModel addObserver:self forKeyPath:@"currentNodeGroup" options:NSKeyValueObservingOptionNew context:NULL];
}

 - (void)tearDown {

	/* This unhooks the arraycontroller */
	[self setFilterType:nil];

	/* Not sure if delegate and datasource methods are causing tableView to retain us.. hence retain cycle.. so - this wont hurt either way */
	[displayedNodesTableView setDataSource:nil];
	[displayedNodesTableView setDelegate:nil];

	 /* I dont think i even explicitely bind these but unbinding Really Really Really does stop warning messages on clean up */
	[displayedNodesTableView unbind:@"content"];
	[displayedNodesTableView unbind:@"selectionIndexes"];
	 
//	 aw man, have i really got to unbind the table columns and shit?
	 [displayedNodesTableView reloadData];
	 
	SHNodeGraphModel *graphModel = [(BlakeDocument *)[docWindowController document] nodeGraphModel];
	NSAssert(graphModel != nil, @"BlakeNodeListViewController.m: ERROR: There is no GraphModel To Connect to.");
	[graphModel removeObserver:self forKeyPath:@"currentNodeGroup"];

	if(_selectionIsBound==YES){
		[self stopListenForSelectionChangeInModel];
	}

	// observe notifications from the model
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self]; // this will stop us receiveing tableview notifications which cant be put back - ie this is final
	
	self.displayedNodesArrayController = nil;
	self.displayedNodesTableView = nil;
	self.infoText = nil;
	self.docWindowController = nil;
	self.currentNodeGroup = nil;
	self.contentView = nil;
	self.selectionKeyPath = nil;
}

- (IBAction)doubleClick:(id)tableView
{
	int rowClicked = [tableView clickedRow];
	id clickedObject = [[displayedNodesArrayController arrangedObjects] objectAtIndex:rowClicked];
	if(rowClicked>-1)
	{
		BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
	//	[doc deSelectAllChildrenInCurrentNode];
	//	[doc addChildToSelectionInCurrentNode: clickedObject];
//jan10		[doc moveDownALevelIntoNodeGroup: clickedObject];
	}
}


#pragma mark main menu support methods
- (int)kindOfObjectAtIndex:(int)ind {

	int returnValue = 0;
	if([filterType isEqualToString:@"All"]){
		int nodeCount = [currentNodeGroup.nodesInside count];
		if(ind<nodeCount)
			return 0;
		int inputCount = [currentNodeGroup.inputs count];
		if(ind<nodeCount+inputCount)
			return 1;
		int outputCount = [currentNodeGroup.outputs count];
		if(ind<nodeCount+inputCount+outputCount)
			return 2;
		int connectorCount = [currentNodeGroup.shInterConnectorsInside count];
		if(ind<nodeCount+inputCount+outputCount+connectorCount)
			return 3;
	} else if([filterType isEqualToString:@"Nodes"]){
		return 0;
	} else if([filterType isEqualToString:@"Inputs"]){
		return 1;
	} else if([filterType isEqualToString:@"Outputs"]){
		return 2;
	} else if([filterType isEqualToString:@"Connectors"]){
		return 3;
	}

	return returnValue;
}

- (BOOL)canCopy {

	if([filterType isEqualToString:@"All"]){
		NSIndexSet *selectedIndexes = [self selectionInModel];
		int firstIndex = [selectedIndexes firstIndex];
		if([self kindOfObjectAtIndex:firstIndex]==3)
			return NO;
	} else if([filterType isEqualToString:@"Connectors"])
		return NO;

	NSIndexSet *selectedIndexes = [self selectionInModel];
	BOOL canCopy =  [selectedIndexes count] > 0;
	return canCopy;
}

- (void)copyCurrentObjects {

	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *types = [NSArray arrayWithObjects: fscriptPBoardType, NSStringPboardType, nil];
	[pb declareTypes:types owner:nil];	

	// content binding
	// selection binding
	
	NSDictionary *contentBinding = [displayedNodesArrayController infoForBinding:NSContentArrayBinding];
	id observedObject = [contentBinding objectForKey:@"NSObservedObject"]; // self
	NSString *keyPath = [contentBinding objectForKey:@"NSObservedKeyPath"];
	NSArray *dataSource = [observedObject valueForKeyPath: keyPath];
	NSIndexSet *selectedIndexes = [self selectionInModel];
	NSArray *nodesToCopy = [dataSource objectsAtIndexes:selectedIndexes];

//nov09	BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
//nov09	NSXMLElement* rootElement = [doc.nodeGraphModel fScriptWrapperFromChildren:nodesToCopy fromNode:currentNodeGroup];
	
	// logInfo(@"savestring is %@", [rootElement canonicalXMLStringPreservingComments:YES]);
//nov09	[pb setString:[rootElement canonicalXMLStringPreservingComments:YES] forType:fscriptPBoardType];
//nov09	[pb setString:[rootElement canonicalXMLStringPreservingComments:YES] forType:NSStringPboardType];
}

- (BOOL)canPaste {

	BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
	SHNodeGraphModel* nodeGraphModel = [doc nodeGraphModel];
	
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSString *xmlString = [pb stringForType:fscriptPBoardType];
	if(xmlString != nil)
		return YES;
				
	/* If we have a string see if it is fscript - could be copied from a text editor */
	NSString *resultString = [pb stringForType:NSStringPboardType];	
	if(resultString){
		NSError *error = nil;
		NSAssert(resultString!=nil, @"cant make NSXMLElement 3");
		NSXMLElement* rootElement = [[[NSXMLElement alloc] initWithXMLString:resultString error:&error] autorelease];
		if(!error)
		{
//nov09			BOOL result = [nodeGraphModel unArchiveChildrenFromFScriptWrapper:rootElement intoNode:currentNodeGroup];
//nov09			if(result)
//nov09				return YES;
		}
	}
	return NO;
}


- (void)myPaste {

	NSArray *pasteTypes = [NSArray arrayWithObjects: NSStringPboardType, nil];
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSString *bestType = [pb availableTypeFromArray:pasteTypes];
	if (bestType != nil) 
	{
		NSString *fScriptData = [pb stringForType:fscriptPBoardType];
		NSError *error = nil;
		NSAssert(fScriptData!=nil, @"cant make NSXMLElement 4");
		NSXMLElement* rootElement = [[[NSXMLElement alloc] initWithXMLString:fScriptData error:&error] autorelease];
		if(!error)
		{
//nov09			BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
//nov09			BOOL result = [doc.nodeGraphModel unArchiveChildrenFromFScriptWrapper:rootElement intoNode:currentNodeGroup];
//nov09			if(!result)
//nov09				NSBeep();
		}
	}
}


- (BOOL)canDelete {
	
//hmm	NSAssert(_documentController, @"need a _documentController");

//hmm	SHNodeGraphModel* nodeGraphModel = [_documentController frontDoc_graph];
//hmm	if(![nodeGraphModel currentNodeGroupIsValid])
	return NO;
//hmm	BOOL hasSelectedChildren = [nodeGraphModel weHaveSelectedNodesOrAttributesOrICs];
//hmm	return hasSelectedChildren;
}

- (void)myDelete {
	
	[self disableTableUpdates];
	BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
	[doc deleteSelectedChildrenFromCurrentNode];
	[self enableTableUpdates];
}

#pragma mark notification methods

// Delegate Method
// this only called when changes to selection originate in the table view. (click or -displayedNodesTableView deselectAll:)
/* A change has been made at the tableView end - 
	We will update the model accordingly but we don't
	want to observe this change (this would cause a loop)
*/
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	
	logInfo(@"selection did change");
	if (_tableViewSelectionIsDisabled) {
		return;
	}
	[self stopListenForSelectionChangeInModel];
	NSIndexSet *sr = [displayedNodesTableView selectedRowIndexes];
	[self setSelectionInModel:sr];
	[self beginListenForSelectionChangeInModel];
}


/*
	A change has originated at the model end.. we will update the table view accordingly - but we dont want to 
	observe this change (this would cause a loop)
*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	if ([keyPath isEqualToString:@"currentNodeGroup"])
	{
		SHNode *newCurrentNodeGroup = (SHNode *)[change objectForKey:NSKeyValueChangeNewKey];
		// logInfo(@"CurrentNodeGroup Changed %@", newCurrentNodeGroup);
		// just to update the bindings
		[self setCurrentNodeGroup: newCurrentNodeGroup];
	}
	
	else if ([keyPath isEqualToString:selectionKeyPath]) {
	
		//-- try to stop infinite observing cycle - bah! 
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTableViewSelectionDidChangeNotification object:displayedNodesTableView];
		NSIndexSet *newSelectionFromModel = [change objectForKey:NSKeyValueChangeNewKey];
		[displayedNodesTableView selectRowIndexes:newSelectionFromModel byExtendingSelection:NO];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewSelectionDidChange:) name:NSTableViewSelectionDidChangeNotification object:displayedNodesTableView];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark accessor methods
@synthesize displayedNodesTableView;
@synthesize displayedNodesArrayController;
@synthesize infoText;
@synthesize docWindowController;
@synthesize currentNodeGroup;
@synthesize filterType, selectionKeyPath;
@synthesize contentView;


- (void)beginListenForSelectionChangeInModel {

	[self addObserver:self forKeyPath:selectionKeyPath options:NSKeyValueObservingOptionNew context:NULL];
	_selectionIsBound = YES;
}

- (void)stopListenForSelectionChangeInModel {

	[self removeObserver:self forKeyPath:selectionKeyPath];
	_selectionIsBound = NO;
}

// oh! we must distinguish selections that originate in the model and table
// i thought -tableViewSelectionDidChange was only called for selections that originate in the tableview but now im not sure
// so now when we call -delete we make sure to disable -tableViewSelectionDidChange
- (void)disableTableUpdates {
	_tableViewSelectionIsDisabled = YES;
}

- (void)enableTableUpdates {
	_tableViewSelectionIsDisabled = NO;
}

/* manually reconfigure the tableview bindings */
- (void)setFilterType:(NSString *)newType {

	/* changing the array controller binding would trigger the selection in the model to change and we would receive a notification - make sure that we reset the selectioon first */
	[displayedNodesTableView deselectAll:self];
	
	// clean up last type
	if([filterType isEqualToString:@"All"])
	{
		[(AllChildrenFilter *)_filter postPendingNotificationsExcept:nil];
		SHNodeGraphModel *graphModel = [(BlakeDocument *)[docWindowController document] nodeGraphModel];
		[self stopListenForSelectionChangeInModel];
		[displayedNodesArrayController unbind:NSContentArrayBinding];
		[graphModel unregisterContentFilter:[AllChildrenFilter class] andUser:self options:nil];
		NSAssert(_filter==nil, @"this should be set in a callback when we unregister with a filter");			
	}
	
	// setup new type
	if( newType!=filterType )
	{
		/* Surely we need to observer changes to the selection ? */
		if(_selectionIsBound==YES){
			[self stopListenForSelectionChangeInModel];
		}
		/* Surely we need to observer changes to the selection ? */
	
		NSString *objectsKeyPath=nil;

		if([newType isEqualToString:@"All"])
		{
			SHNodeGraphModel *graphModel = [(BlakeDocument *)[docWindowController document] nodeGraphModel];
			[graphModel registerContentFilter:[AllChildrenFilter class] andUser:self options:nil];
			NSAssert(_filter, @"this should be set in a callback when we register with a filter");			
			objectsKeyPath = @"filter.currentNodeProxy.filteredContent";
			self.selectionKeyPath = @"filter.currentNodeProxy.filteredContentSelectionIndexes";
					
		} else if([newType isEqualToString:@"Nodes"]){
			objectsKeyPath = @"currentNodeGroup.nodesInside.array";
			self.selectionKeyPath = @"currentNodeGroup.nodesInside.selection";
			
		} else if([newType isEqualToString:@"Inputs"]){
			objectsKeyPath = @"currentNodeGroup.inputs.array";
			self.selectionKeyPath = @"currentNodeGroup.inputs.selection";
			
		} else if([newType isEqualToString:@"Outputs"]){
			objectsKeyPath = @"currentNodeGroup.outputs.array";
			self.selectionKeyPath = @"currentNodeGroup.outputs.selection";
			
		} else if([newType isEqualToString:@"Connectors"]){
			objectsKeyPath = @"currentNodeGroup.shInterConnectorsInside.array";
			self.selectionKeyPath = @"currentNodeGroup.shInterConnectorsInside.selection";
		} else if(newType==nil) {
			/* tear down */
			self.selectionKeyPath = nil;
		} else {
			[NSException raise:@"Like, what the fuck?" format:@"%@", newType];
		}
		
		if(newType!=nil){
		
			/* Bind the array Controller to the current filterType (Nodes, Inputs, Outputs, Conections) */
			NSAssert(objectsKeyPath!=nil, @"fuck up with table bnding");
			[displayedNodesArrayController bind:NSContentArrayBinding toObject:self withKeyPath:objectsKeyPath options:nil];
			
			/* Surely we need to observer changes to the selection ? */
			[self beginListenForSelectionChangeInModel];
			/* Surely we need to observer changes to the selection ? */

			BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
			/* Dont allow to undo back to a nil filterType - i think i need this so that you see results of undo's 
				eg, if you delete an input, then switch to output view, then undo, you have no way to see what happened
			 */
			if(filterType!=nil){
				NSUndoManager *um = [doc undoManager];
				[um beginUndoGrouping];
				if(![um isUndoing])
					[um setActionName:@"set filter type"];
					[[um prepareWithInvocationTarget:self] setFilterType: filterType ];
				[um endUndoGrouping];
			}
		} else {
		
			// unhook the arraycontroller here..
			[displayedNodesArrayController unbind:NSContentArrayBinding];
		}

		[filterType release];
		filterType = [newType retain];
	}
}

- (NSArray *)nodesInCurrentNodeGroup_Array {

//nov09	NSException* myException = [NSException exceptionWithName:@"DO we need this shit?" reason:@"DO we need this shit?" userInfo:nil];
//nov09 @throw myException;	
//nov09	return [self.currentNodeGroup nodesAndAttributesInside];
	
	[NSException raise:@"wshat is this for" format:@""];
	return nil;
	
}

- (void)setNodesInCurrentNodeGroup_Array:(NSArray *)nodeArray {

	/* These are just stubs to prompt the bindings to update */
	NSException* myException = [NSException exceptionWithName:@"DO we need this shit?" reason:@"DO we need this shit?" userInfo:nil];
	@throw myException;	
}

- (NSMutableIndexSet *)selectionInModel {
	
	NSMutableIndexSet *sel = [self valueForKeyPath: self.selectionKeyPath];
	return sel;
}

/*	we bind the table views selection to here rather than directly to the nodes ordered array selection
	so that we can insert the undo mechanisms. If we find that we are duplicating this selection undo /redo
	then it should be moved to HighLevelDocument Actions
*/
- (void)setSelectionInModel:(NSIndexSet *)value {

	#ifdef DEBUG
		[currentNodeGroup recordHit:_cmd];
	#endif
	
	// BlakeDocument* doc = (BlakeDocument *)[docWindowController document];
	// NSMutableIndexSet *undoIndexes = [[self selectionInModel] retain];
	if(_filter)
		[[_filter currentNodeProxy] changeSelectionIndexes:value];
	else
		[self setValue:value forKeyPath: self.selectionKeyPath];
	
	// NSUndoManager* um = [doc undoManager];
	// [[um prepareWithInvocationTarget:self] setSelection: undoIndexes ];
	
	// [undoIndexes release];
	// NB we dont update the document change count for a selection action
}

- (IBAction)butonPressed:(id)sender {
//	[displayedNodesTableView setNeedsDisplay];
//	[displayedNodesTableView reloadData];

//nov09	logInfo(@"bound array is %@", [currentNodeGroup allChildren]);
}

/* we need this to make paste work */
- (NSArray *)readablePasteboardTypes {
	return [NSArray arrayWithObjects:fscriptPBoardType, NSStringPboardType, nil];
}


#pragma mark TableView delegate merthods
/* The tableView will map the index to a color */
//- (int)tableView:(NSTableView *)tv colorIndexForRow:(int)rowIndex {
//	return [self kindOfObjectAtIndex:rowIndex];
//}


// tableView: methods indicates delegate method
- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	
	if([aCell isKindOfClass:[NSImageCell class]] && [[aTableColumn identifier] isEqualToString:@"icon column"]) {

		NSImage *theImage = nil;
		int rowKind = [self kindOfObjectAtIndex:rowIndex];
		if(rowKind==0){
			theImage = smallNodeIcon;
		} else if(rowKind==1){
			theImage = smallInputIcon;
		} else if(rowKind==2){
			theImage = smallOutputIcon;
		} else if(rowKind==3){
			theImage = smallConnectorIcon;
		}
		[aCell setImage: theImage];
	}
}


/*
 * Discussion:
 * Creates the files for the objects at indexes
 * Returns an array of filenames
*/
- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {

// create the files and return an array containing the filenames (without path information).
	NSMutableArray *fileNames = [NSMutableArray arrayWithCapacity:[indexSet count]];
	SHNodeGraphModel *graphModel = [(BlakeDocument *)[docWindowController document] nodeGraphModel];
//nov09	SHOrderedDictionary *nodesInside = currentNodeGroup.nodesInside;
	NSFileManager* fileManager = [NSFileManager defaultManager];

//	int nodeCount = [nodesInside count];
	int rowIndex = [indexSet firstIndex];
	while(rowIndex!=NSNotFound)
	{
	//	-- if the row is a node, create the files
		int rowKind = [self kindOfObjectAtIndex:rowIndex];
		if(rowKind==0)
		{
//nov09			SHNode *nodeToSave=[nodesInside objectAtIndex:rowIndex];
//		if([filterType isEqualToString:@"All"])
//		{
//			if(rowIndex<nodeCount){
//				nodeToSave = [nodesInside objectAtIndex:rowIndex];
//			}
//		} else if([filterType isEqualToString:@"Nodes"]){
//			nodeToSave = [nodesInside objectAtIndex:rowIndex];
//		}
//nov09			if(nodeToSave!=nil)
			{
				BOOL isDirectory;
				int uniqueFileSuffix = 0;
				NSString *uniqueAppendString = @""; // begin with the node name and increment if it exists (circle.fscript, circle_1.fscript, circle_2.fscript)
				NSString *newFileName, *destinationPath;
				BOOL fileExists;
				do {
//nov09					newFileName = [[[nodeToSave name] stringByAppendingString:uniqueAppendString] stringByAppendingPathExtension:@"fscript"]; /* DAMN! Hardcoding in the fscript extension */
//nov09					destinationPath = [[dropDestination path] stringByAppendingPathComponent:newFileName];
//nov09					fileExists = [fileManager fileExistsAtPath:destinationPath isDirectory:&isDirectory];
//nov09					if(fileExists){
//nov09						/* increment the extension for next time thru */
//nov09						uniqueFileSuffix++;
//nov09						uniqueAppendString = [NSString stringWithFormat:@"_%i", uniqueFileSuffix];
//nov09					}
				} while(fileExists==YES);

//nov09				BOOL writeSuccess = [graphModel saveNode:nodeToSave toFile:destinationPath];
//nov09				if(writeSuccess)
//nov09					[fileNames addObject:newFileName];
			}
		}
		rowIndex = [indexSet indexGreaterThanIndex: rowIndex];
	}
	return fileNames;
}

// tableView: methods indicates delegate method
/* If you are in 'All' mode we only support drags of one type at a time */
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {

	// Read mod flags
	BOOL alt_pressed = [NSApp altKeyDown];
	
	// logInfo(@"TableView writeRowsWithIndexes. clicked row is %i", [tv clickedRow]);
	// Copy the row numbers to the pasteboard.	
	/* Disable drag reordering in 'All' mode if we are trying to drag more than one row of different kinds. eg. an input and an output */
	int firstRowKind = -1, lastRowKind = -1;
//nov09	if([filterType isEqualToString:@"All"])
//nov09	{
//nov09		firstRowKind = [self kindOfObjectAtIndex:[rowIndexes firstIndex]];
//nov09		lastRowKind = [self kindOfObjectAtIndex:[rowIndexes lastIndex]];
//nov09		if(firstRowKind!=firstRowKind)
//nov09			return NO;
//nov09	} else if([filterType isEqualToString:@"Connectors"]){
//nov09		return NO;
//nov09	}
	
	// go ahead and write the row data to the pastboard
	
	/* what shall we copy to the pasteboard? */
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	// if we have a node we can also drag it to the desktop
	/* NSFilesPromisePboardType allows you to drag to the desktop. Finder will call //tableView:namesOfPromisedFilesDroppedAtDestination:forDraggedRowsWithIndexes: */
	NSArray* writeTypes;
	if([filterType isEqualToString:@"Nodes"] || ([filterType isEqualToString:@"All"] && (firstRowKind==0 && lastRowKind==0)))
	{
		if(alt_pressed) // set a flag on the pasteBoard (it has no associated data) to say that we were alt dragging when we did the copy
			writeTypes = [NSArray arrayWithObjects:@"ALTKEY_PRESSED", MyTableViewDataType, NSFilesPromisePboardType, nil];
		else
			writeTypes = [NSArray arrayWithObjects:MyTableViewDataType, NSFilesPromisePboardType, nil];
			
		[pboard declareTypes:writeTypes owner:self];
		[pboard setPropertyList: [NSArray arrayWithObject: documentExtension] forType: NSFilesPromisePboardType];
		
	} else {
	
		if(alt_pressed)
			writeTypes = [NSArray arrayWithObjects:@"ALTKEY_PRESSED", MyTableViewDataType, nil];
		else
			writeTypes = [NSArray arrayWithObjects:MyTableViewDataType, nil];
		[pboard declareTypes:writeTypes owner:self];
	}
    [pboard setData:data forType:MyTableViewDataType];
    return YES;
}

// tableView: methods indicates delegate method
- (NSDragOperation)tableView:(NSTableView*)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op 
{
	// logInfo(@"TableView validateDrop %i", op);
	int result = NSDragOperationNone;
	
	/* Limiting it to only accept drops 'between' rows */
	if (op == NSTableViewDropAbove) 
	{	
		NSPasteboard* pb = [info draggingPasteboard];
		id sourceTable = [info draggingSource];
	//	NSWindow *draggingDestinationWindow = [info draggingDestinationWindow];
	//	NSDragOperation draggingSourceOperationMask = [info draggingSourceOperationMask];
	//- (NSPoint)draggingLocation;
	//- (NSPoint)draggedImageLocation;
	//- (NSImage *)draggedImage;
	//- (id)draggingSource;
	//- (NSInteger)draggingSequenceNumber;
	//- (void)slideDraggedImageTo:(NSPoint)screenPoint;
	//- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination;

		NSString* firstType = [pb availableTypeFromArray:[NSArray arrayWithObjects:MyTableViewDataType, NSFilenamesPboardType, nil]];
		SHRootNodeListTableView* destTable = (SHRootNodeListTableView*)tableView;

		// Are we dragging between SHRootNodeListTableViews ?
		// if( [[info draggingSource] class]==[displayedNodesTableView class] )
		if([firstType isEqualToString: MyTableViewDataType])
		{		
			/* are we reordering the same table ? */
			if(sourceTable==destTable){
				result = [self _validateSameTableDrop:info proposedRow:proposedRow proposedDropOperation:op ];
			} else {
				result = [self _validateDifferentTableDrop:info proposedRow:proposedRow proposedDropOperation:op ];
			}
			// }
			//	return NSDragOperationCopy;
		} else if([firstType isEqualToString: NSFilenamesPboardType]){

			result = [self _validateFileDrop:info];
		}
	}
    return result;
}


/* if we are dragging to the same table (ie. reordering) each row must be of the same type, and if mode is 'All' you can only drop to the same destination type */
- (NSDragOperation)_validateSameTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op {

    int result = NSDragOperationNone;
	NSPasteboard* pb = [info draggingPasteboard];
	NSData* rowData = [pb dataForType:MyTableViewDataType];
	NSIndexSet* draggedRowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	if([filterType isEqualToString:@"Connectors"]){

	} else if([filterType isEqualToString:@"All"]){

		/*	We can only drag amongst the same type. ie - we cant reorder a node into the inputs section 
			That is, the drag destinaton row for each row must be in the same section it began the drag in
		*/
		int firstRowKind = [self kindOfObjectAtIndex:[draggedRowIndexes firstIndex]];
		int lastRowKind = [self kindOfObjectAtIndex:[draggedRowIndexes lastIndex]];
		if(firstRowKind==lastRowKind){
		
			int nodeCount = [currentNodeGroup.nodesInside count];
			int inputCount = [currentNodeGroup.inputs count];
			int outputCount = [currentNodeGroup.outputs count];
//			int connectorCount = [currentNodeGroup.shInterConnectorsInside count];

			// what kind is the dragged row?

			// It is ok to drop an item after the current row of that kind OR BEFORE THE FIRST row of that kind - This still counts as being in the same section
			if(firstRowKind==0){													// if dragging a node
				if(proposedRow<=nodeCount)
					result = NSDragOperationMove;

			} else if(firstRowKind==1){												// if dragging an input
				if( proposedRow>(nodeCount-1) && proposedRow<=(nodeCount+inputCount))
					result = NSDragOperationMove;

			} else if(firstRowKind==2){												// if dragging an output
				if( proposedRow>(nodeCount+inputCount-1) && proposedRow<=(nodeCount+inputCount+outputCount))						
					result = NSDragOperationMove;

			} else if(firstRowKind==3){												// if dragging a connector
				//if( proposedRow>(nodeCount+inputCount+outputCount-1) && proposedRow<=(nodeCount+inputCount+outputCount+connectorCount))
				//	result = NSDragOperationMove;
			}
		}
	} else {
		result = NSDragOperationMove;
	}
//	if(result!=NSDragOperationMove)
//		logInfo(@"NO! Not a valid move");
	return result;
}

- (NSDragOperation)_validateDifferentTableDrop:(id <NSDraggingInfo>)info proposedRow:(int)proposedRow proposedDropOperation:(NSTableViewDropOperation)op  {

    NSDragOperation result = NSDragOperationNone;
	NSPasteboard* pb = [info draggingPasteboard];
	NSData* rowData = [pb dataForType:MyTableViewDataType];
	NSIndexSet* draggedRowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	
	// logInfo(@"SHRootNodeListTableView: dragging to different table");
	id sourceTable = [info draggingSource];
	BlakeNodeListViewController *srcTableDelegate = [sourceTable delegate];

	/* The only valid cases are.. all other cases are definite fail */
	BOOL equalFilterTypes = [filterType isEqualToString:srcTableDelegate.filterType];
	BOOL thisTableIsAll = [filterType isEqualToString:@"All"];
	BOOL srcTableIsAll = [srcTableDelegate.filterType isEqualToString:@"All"];
	
	int srcRowKind1 = [srcTableDelegate kindOfObjectAtIndex:[draggedRowIndexes firstIndex]];
	int srcRowKind2 = [srcTableDelegate kindOfObjectAtIndex:[draggedRowIndexes lastIndex]];
	if(srcRowKind1!=srcRowKind2)
		return NSDragOperationNone;

	if(thisTableIsAll && srcTableIsAll){
		if(srcRowKind1!=3 || srcRowKind2!=3) // check we have something other than connectors
			result = NSDragOperationCopy;
			
	} else if(equalFilterTypes || thisTableIsAll || srcTableIsAll)
	{
		if([filterType isEqualToString:@"Connectors"]==NO && equalFilterTypes){
			//--if src kind is not equal connectors
			if(srcRowKind1==srcRowKind2)
				if(srcRowKind2!=3)
					result = NSDragOperationCopy;
		
		} else if([filterType isEqualToString:@"All"] && [srcTableDelegate.filterType isEqualToString:@"Connectors"]==NO) {
			
			if(srcRowKind1==srcRowKind2){
				if(srcRowKind2!=3){
					int nodeCount = [currentNodeGroup.nodesInside count];
					int inputCount = [currentNodeGroup.inputs count];
					int outputCount = [currentNodeGroup.outputs count];
					int connectorCount = [currentNodeGroup.shInterConnectorsInside count];

					// what kind is the dragged row?

					// It is ok to drop an item after the current row of that kind OR BEFORE THE FIRST row of that kind - This still counts as being in the same section
					if(srcRowKind1==0){													// if dragging a node
						if(proposedRow<=nodeCount)
							result = NSDragOperationCopy;

					} else if(srcRowKind1==1){												// if dragging an input
						if( proposedRow>(nodeCount-1) && proposedRow<=(nodeCount+inputCount))
							result = NSDragOperationCopy;

					} else if(srcRowKind1==2){												// if dragging an output
						if( proposedRow>(nodeCount+inputCount-1) && proposedRow<=(nodeCount+inputCount+outputCount))						
							result = NSDragOperationCopy;

					} else if(srcRowKind1==3){												// if dragging a connector
						if( proposedRow>(nodeCount+inputCount+outputCount-1) && proposedRow<=(nodeCount+inputCount+outputCount+connectorCount))
							result = NSDragOperationCopy;
					}
				}
			}
		} else if([srcTableDelegate.filterType isEqualToString:@"All"] && [filterType isEqualToString:@"Connectors"]==NO && [filterType isEqualToString:@"ALL"]==NO) {
			// -- if srcRowKind == dest Row kind
			int dstRowKind = [self kindOfObjectAtIndex:0]; // we know we not in 'All'

			if(srcRowKind1==srcRowKind2)
				if(srcRowKind2==dstRowKind)
					result = NSDragOperationCopy;
		}
	}
	return result;
}


/* We can only drop .fscript files when we are in All || Nodes mode */
- (NSDragOperation)_validateFileDrop:(id <NSDraggingInfo>)info {

    NSDragOperation result = NSDragOperationNone;
	NSPasteboard* pb = [info draggingPasteboard];

	if([filterType isEqualToString:@"All"] || [filterType isEqualToString:@"Nodes"])
	{
		/* Evidently not dragging from a tableview - are we trying to drop a file? */
		NSArray* droppedFilePaths = [pb propertyListForType: NSFilenamesPboardType];
		NSEnumerator* pathsEnum = [droppedFilePaths objectEnumerator];
		NSString *path;
		while( (path=[pathsEnum nextObject]) ) 
		{
			if([[path pathExtension] isEqualToString:@"fscript"]){
				result = NSDragOperationCopy;
				break;
			}
		}
	}
	return result;
}


- (BOOL)_acceptFileDrop:(id <NSDraggingInfo>)info row:(int)row {

	BOOL result = false;
	NSPasteboard* pboard = [info draggingPasteboard];
	NSArray* droppedFilePaths = [pboard propertyListForType: NSFilenamesPboardType];
	int numberOfFiles = [droppedFilePaths count];
	if(numberOfFiles==0)
		return NO;

	if([filterType isEqualToString:@"All"] || [filterType isEqualToString:@"Nodes"])
	{
		int nodeCount = [currentNodeGroup.nodesInside count];
				
		if([filterType isEqualToString:@"All"] && row>nodeCount ) // we can only drop 'within' the node section
			return NO;
		NSFileManager* fileManager = [NSFileManager defaultManager];
		NSEnumerator* pathsEnum = [droppedFilePaths objectEnumerator];
		NSString *path;
		BOOL isDirectory;
		while( (path = [pathsEnum nextObject]) ) 
		{
				/* verify that it is a fscript path */
				if([[path lastPathComponent] hasSuffix:@"fscript"] && [fileManager fileExistsAtPath:path isDirectory:&isDirectory]){
//nov09					[[docWindowController document] addContentsOfFile:path toNode:[[[docWindowController document] nodeGraphModel] currentNodeGroup] atIndex: row];
					result = YES;
				}
		}
	}
	return result;
}

- (BOOL)_acceptSameTableDrop:(id <NSDraggingInfo>)info row:(int)row proposedDropOperation:(NSTableViewDropOperation)op {

	NSLog(@"Drop on Row %i", row);
	BOOL result = false;

	if([filterType isEqualToString:@"Connectors"])
		return NO;

	NSPasteboard *pb = [info draggingPasteboard];
	NSData *rowData = [pb dataForType:MyTableViewDataType];
	NSIndexSet *draggedRowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	NSString* altPressed = [pb availableTypeFromArray:[NSArray arrayWithObject:@"ALTKEY_PRESSED"]];
	BOOL wasAltPressed = altPressed!=nil;
	
	if((NSInteger)[draggedRowIndexes lastIndex]>displayedNodesTableView.numberOfRows)
		return NO;
	int firstRowKind = [self kindOfObjectAtIndex:[draggedRowIndexes firstIndex]];
	int lastRowKind = [self kindOfObjectAtIndex:[draggedRowIndexes lastIndex]];
	if(firstRowKind!=lastRowKind)
		return NO;
	
	id obsToDrag = [[displayedNodesArrayController arrangedObjects] objectsAtIndexes:draggedRowIndexes];

	if([filterType isEqualToString:@"All"])
	{
		obsToDrag = [obsToDrag collectResultsOfSelector:@selector(originalNode)];
		
		/*	We can only drag amongst the same type. ie - we cant reorder a node into the inputs section 
			That is, the drag destinaton row for each row must be in the same section it began the drag in
		*/
		int nodeCount = [currentNodeGroup.nodesInside count];
		int inputCount = [currentNodeGroup.inputs count];
		int outputCount = [currentNodeGroup.outputs count];
		// what kind is the dragged row?
		// It is ok to drop an item after the current row of that kind OR BEFORE THE FIRST row of that kind - This still counts as being in the same section
		if(firstRowKind==0){													// if dragging a node
			if(row>nodeCount)
				return NO;

		} else if(firstRowKind==1){												// if dragging an input
			if( row<nodeCount || row>(nodeCount+inputCount))
				return NO;
			row = row - nodeCount;// compensate dest row
			
		} else if(firstRowKind==2){												// if dragging an output
			if( row<(nodeCount+inputCount) || row>(nodeCount+inputCount+outputCount))						
				return NO;
			row = row - (nodeCount+inputCount); // compensate dest row

		} else if(firstRowKind==3){												// if dragging a connector
			return NO;
		}
	}

	// new way
	[[docWindowController document]  moveChildren:obsToDrag toInsertionIndex:row shouldCopy:wasAltPressed];
	return YES;
	

//oldway_dec09	NSMutableArray *movedRows = [NSMutableArray arrayWithCapacity:[draggedRowIndexes count]];
//oldway_dec09	NSMutableArray *amountsToMove = [NSMutableArray array];
//oldway_dec09	NSMutableArray *duplicatedObjects = [NSMutableArray array];
//oldway_dec09	unsigned irow = [draggedRowIndexes firstIndex];

//oldway_dec09	int count=0;
//oldway_dec09	while (irow != NSNotFound)
//oldway_dec09	{
//oldway_dec09		id obToReplace = [[displayedNodesArrayController arrangedObjects] objectAtIndex:irow];
//oldway_dec09		if(wasAltPressed && [obToReplace isKindOfClass:[SHInterConnector class]]==NO ){
//oldway_dec09			NSAssert([obToReplace respondsToSelector:@selector(copy)], @"err");
//oldway_dec09			obToReplace = [[(id)obToReplace copy] autorelease];
//oldway_dec09			[duplicatedObjects addObject:obToReplace];
			// logInfo(@"Copying %@", obToReplace);
//oldway_dec09		}
		
//oldway_dec09		[movedRows addObject:obToReplace];
				
//oldway_dec09		int sourceIndex = irow;
//oldway_dec09		int targetIndex = row;
//oldway_dec09		if(targetIndex>sourceIndex)
//oldway_dec09			targetIndex--;

		/* Made something of a mess here - amountsToMove IS the amount to move if we aren't copying - if we are copying it is the target row */
//oldway_dec09		int amountToMove = targetIndex + count;
//oldway_dec09		if(!wasAltPressed)
//oldway_dec09			amountToMove = amountToMove-sourceIndex;
		
//oldway_dec09		[amountsToMove addObject:[NSNumber numberWithInt:amountToMove]];

//oldway_dec09		irow = [draggedRowIndexes indexGreaterThanIndex: irow];
//oldway_dec09		count++;
//oldway_dec09	}

	/* If alt was pressed we duplicate the objects not just reorder them */
//oldway_dec09	if([duplicatedObjects count]>0){
//oldway_dec09		BlakeDocument* destinationDoc = [docWindowController document];
//oldway_dec09		// This will append the duplicates to the end
//oldway_dec09		[destinationDoc addChildrenToCurrentNode: duplicatedObjects];
//oldway_dec09	}
	
	// Then insert these data rows into the array
//oldway_dec09	NSUInteger movedCount = [movedRows count];
//oldway_dec09	NSUInteger successfullyAddedCount=0;

//	-- unselect all objects?
//oldway_dec09	for( NSUInteger i=0; i<movedCount; i++)
//oldway_dec09	{
//oldway_dec09		int targetIndex=0, amountToMove=0;
//oldway_dec09		id objectToMove = [movedRows objectAtIndex:i];
//oldway_dec09		targetIndex = [[amountsToMove objectAtIndex:i] intValue];

		// if we have duplicated some objects amountsToMove is actually the target Index
//oldway_dec09		if([duplicatedObjects count]>0){
			// what was desired index?
//			int desiredIndex = row + [duplicatedObjects count];
//oldway_dec09			int actualIndex = [[displayedNodesArrayController arrangedObjects] indexOfObjectIdenticalTo: objectToMove];
//			amountToMove = desiredIndex - actualIndex;
//oldway_dec09			amountToMove = targetIndex+1-actualIndex;
//oldway_dec09			logInfo(@"Moving node:%i %@ by %i", actualIndex, [objectToMove name], amountToMove);
//oldway_dec09		} else {
			
//oldway_dec09			amountToMove = targetIndex;
//oldway_dec09		}
//oldway_dec09		if(amountToMove!=0){
//oldway_dec09			if([objectToMove isKindOfClass:[NodeProxy class]])
//oldway_dec09				objectToMove = [objectToMove originalNode];
//oldway_dec09			[[docWindowController document] add:amountToMove toIndexOfChild:objectToMove];
//oldway_dec09		}
//oldway_dec09		successfullyAddedCount++;
//oldway_dec09	}
//-- redo selection?
//oldway_dec09	if(successfullyAddedCount>0)
//oldway_dec09		result = YES;
//oldway_dec09	return result;
}

- (BOOL)_acceptDifferentTableDrop:(id <NSDraggingInfo>)info row:(int)row proposedDropOperation:(NSTableViewDropOperation)op {

	BOOL result = false;
	NSPasteboard* pboard = [info draggingPasteboard];
	NSData* rowData = [pboard dataForType:MyTableViewDataType];
	NSIndexSet* draggedRowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	SHRootNodeListTableView* sourceTable = [info draggingSource];
	BlakeNodeListViewController *srcTableDelegate = [sourceTable delegate];
	NSAssert(srcTableDelegate!=nil, @"what?");
	NSMutableArray *movedRows = [NSMutableArray arrayWithCapacity:[draggedRowIndexes count]];
	NSArrayController* srcArrayController = [sourceTable arrayController];
	NSMutableArray* sourceContentArray = [srcArrayController content];
//nov09	NSArrayController *dstArrayController = displayedNodesArrayController;
//nov09	NSMutableArray* destinationContentArray = [dstArrayController content];
//nov09	NSAssert(srcArrayController!=nil && dstArrayController!=nil, @"set up table view wrong");
//nov09	NSArray* sourceArray = [srcArrayController arrangedObjects];
//nov09	NSMutableArray *amountsToMove = [NSMutableArray array];
//nov09	NSAssert(sourceTable!=displayedNodesTableView, @"These aren't different?");

	/* The only valid cases are.. all other cases are definite fail */
	BOOL equalFilterTypes = [filterType isEqualToString:srcTableDelegate.filterType];
	BOOL thisTableIsAll = [filterType isEqualToString:@"All"];
	BOOL srcTableIsAll = [srcTableDelegate.filterType isEqualToString:@"All"];
	
	int srcRowKind1 = [srcTableDelegate kindOfObjectAtIndex:[draggedRowIndexes firstIndex]];
	int srcRowKind2 = [srcTableDelegate kindOfObjectAtIndex:[draggedRowIndexes lastIndex]];

	if(thisTableIsAll && srcTableIsAll){
		if(srcRowKind1!=3 || srcRowKind2!=3){ // check we have something other than connectors
			result = YES;
		}
	} else if(equalFilterTypes || thisTableIsAll || srcTableIsAll)
	{
		if([filterType isEqualToString:@"Connectors"]==NO && equalFilterTypes){
			//--if src kind is not equal connectors
			if(srcRowKind1==srcRowKind2)
				if(srcRowKind2!=3){
					result = YES;
				}
				
		} else if([filterType isEqualToString:@"All"] && [srcTableDelegate.filterType isEqualToString:@"Connectors"]==NO) {
		
//			#warning dont think we need this duplicate bit */
//			if(srcRowKind1==srcRowKind2){
//				if(srcRowKind2!=3){
//					int nodeCount = [currentNodeGroup.nodesInside count];
//					int inputCount = [currentNodeGroup.inputs count];
//					int outputCount = [currentNodeGroup.outputs count];
//					// int connectorCount = [currentNodeGroup.shInterConnectorsInside count];
//
//					// what kind is the dragged row?
//
//					// It is ok to drop an item after the current row of that kind OR BEFORE THE FIRST row of that kind - This still counts as being in the same section
//					if(srcRowKind1==0){													// if dragging a node
//						if(row<=nodeCount)
							result = YES;
//
//					} else if(srcRowKind1==1){												// if dragging an input
//						if( row>(nodeCount-1) && row<=(nodeCount+inputCount))
//							result = YES;
//
//					} else if(srcRowKind1==2){												// if dragging an output
//						if( row>(nodeCount+inputCount-1) && row<=(nodeCount+inputCount+outputCount))						
//							result = YES;
//
//					} else if(srcRowKind1==3){												// if dragging a connector
//					//	if( proposedRow>(nodeCount+inputCount+outputCount-1) && proposedRow<=(nodeCount+inputCount+outputCount+connectorCount))
//					//		result = NSDragOperationCopy;
//					}
//				}
//			}

		
		
		} else if([srcTableDelegate.filterType isEqualToString:@"All"] && [filterType isEqualToString:@"Connectors"]==NO && [filterType isEqualToString:@"ALL"]==NO) {
			// -- if srcRowKind == dest Row kind
			int dstRowKind = [self kindOfObjectAtIndex:0]; // we know we not in 'All'

			if(srcRowKind1==srcRowKind2)
				if(srcRowKind2==dstRowKind){
					result = YES;
				}
		}
	}									

	/* if ALL check that we are dropping to a valid place */
	if(result==YES && [filterType isEqualToString:@"All"]){
	
		int nodeCount = [currentNodeGroup.nodesInside count];
		int inputCount = [currentNodeGroup.inputs count];
		int outputCount = [currentNodeGroup.outputs count];
//			int connectorCount = [currentNodeGroup.shInterConnectorsInside count];
		if(srcRowKind1!=srcRowKind2)
			result=NO;

		// It is ok to drop an item after the current row of that kind OR BEFORE THE FIRST row of that kind - This still counts as being in the same section
		if(srcRowKind1==0){													// if dragging a node
			if(row>nodeCount)
				result=NO;

		} else if(srcRowKind1==1){												// if dragging an input
			if( row<nodeCount || row>(nodeCount+inputCount))
				result=NO;

		} else if(srcRowKind1==2){												// if dragging an output
			if( row<(nodeCount+inputCount) || row>(nodeCount+inputCount+outputCount))						
				result=NO;

		} else if(srcRowKind1==3){												// if dragging a connector
				result=NO;

		}
	}

	if(result==YES)
	{
		BlakeDocument* destinationDoc = [docWindowController document];
		unsigned irow = [draggedRowIndexes firstIndex];
		while (irow != NSNotFound)
		{
			// we cannot add the actual object we are dragging from the different document, we need to copy it..
//nov09			id<SHNodeLikeProtocol> draggedObject = [sourceArray objectAtIndex:irow];
//nov09			if([draggedObject isKindOfClass:[SHInterConnector class]]==NO)
			{
//nov09				NSAssert([draggedObject respondsToSelector:@selector(copy)], @"err");
//nov09				id<SHNodeLikeProtocol> duplicateOfDraggedObject = [[(id)draggedObject copy] autorelease];
//nov09				[movedRows addObject: duplicateOfDraggedObject];

				// formally add it to the model
//nov09				int safeIndex = [sourceContentArray indexOfObjectIdenticalTo: draggedObject];
//nov09				NSAssert(safeIndex!=NSNotFound, @"eek, messed up!");
//nov09				[amountsToMove addObject:[NSNumber numberWithInt:safeIndex]];
			}
			irow = [draggedRowIndexes indexGreaterThanIndex: irow];
		}
				
		[destinationDoc addChildrenToCurrentNode: movedRows];

	//		[destinationDoc addChildren:movedRows toNode:[[destinationDoc nodeGraphModel] currentNodeGroup] atIndexes:amountsToMove];
	
		// Then insert these data rows into the array

		NSUInteger movedCount = [movedRows count];
		NSUInteger successfullyAddedCount=0;
		for( NSUInteger i=0; i<movedCount; i++ ){

			// int amountToMove = [[amountsToMove objectAtIndex:i] intValue];
			id objectToMove = [movedRows objectAtIndex:i];
//nov09			int indexToCheckObjectWasAdded = [destinationContentArray indexOfObjectIdenticalTo: objectToMove];
				//[[docWindowController document] add: amountToMove toIndexOfChild: objectToMove];
				//[destinationContentArray replaceObjectsInRange:NSMakeRange(row, 0) withObjectsFromArray:movedRows];
//nov09			if(indexToCheckObjectWasAdded!=NSNotFound){
//nov09				[destinationDoc add: (row+i)-indexToCheckObjectWasAdded toIndexOfChild: objectToMove];
//nov09				successfullyAddedCount++;
//nov09			}
		}
		if(successfullyAddedCount==0)
			result = NO; // seems like we failed after all
	} else { NSBeep(); }
			
	return result;
}

// tableView: methods indicates delegate method
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation {

	BOOL result = false;
	
	if (operation == NSTableViewDropAbove) 
	{
		NSPasteboard* pboard = [info draggingPasteboard];
		NSString* firstType = [pboard availableTypeFromArray:[NSArray arrayWithObjects:MyTableViewDataType, NSFilenamesPboardType, nil]];
	   if (row < 0)
			row = 0;
		
		/* Are we dragging a file? */
		if(([firstType isEqualToString: NSFilenamesPboardType]))
		{
			result = [self _acceptFileDrop:info row:row];
			
		/* are we reordering the table ? */
		} else if([firstType isEqualToString: MyTableViewDataType])
		{

			SHRootNodeListTableView* sourceTable = [info draggingSource];
			SHRootNodeListTableView* destTable = (SHRootNodeListTableView*)aTableView;
			
			if(sourceTable==destTable)
			{
				[self disableTableUpdates];
				result = [self _acceptSameTableDrop:info row:row proposedDropOperation:operation];
				[self enableTableUpdates];
				
			} else if([[destTable delegate] isKindOfClass:[self class]]) {
				
				result = [self _acceptDifferentTableDrop:info row:row proposedDropOperation:operation];
			}
		}
		// And refresh the table.  (Ideally, we should turn off any column highlighting)
//dec09		[self deSelectAllChildren];
//dec0		[displayedNodesTableView reloadData];	
    }
	return result;
} 

#pragma mark SHContentProviderUserProtocol

/* content */
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
}

- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
}

- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {}

- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}
- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {}

/* selection */
// bear in mind that indexesOfSelectedObjectsThatPassFilter is actually an array and the changed indexes are actually the first item
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {}
- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {}

@end
