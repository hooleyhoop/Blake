//
//  ObjectBrowserViewController.m
//  BlakeLoader2
//
//  Created by steve hooley on 27/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "ObjectBrowserViewController.h"
#import "FSNodeInfo.h"
#import "FSBrowserCell.h"
#import "SHNodeRegister.h"


@implementation ObjectBrowserViewController

@synthesize objectBrowser = _objectBrowser;

#pragma mark -
#pragma mark setup methods
- (void)setupViews {
	
	// Make the browser user our custom browser cell.
	[_objectBrowser setCellClass: [FSBrowserCell class]];
	[_objectBrowser setTarget: self];
	[_objectBrowser setAction: @selector(browserSingleClick:)];
	[_objectBrowser setDoubleAction: @selector(browserDoubleClick:)];
	[_objectBrowser setDelegate:self]; // set in nib
	// Prime the browser with an initial load of data.
	[self reloadData: nil];
	
	/* for the filtering array controller */
	// [displayedNodesArrayController setPropertyToMatch:@"name"];
//	SHNodeGraphModel* graphModel = [[docWindowController document] nodeGraphModel];
//	NSAssert(graphModel != nil, @"ERROR: There is no GraphModel To Connect to.");
//	
//	[graphModel registerContentFilter:[NodeClassFilter class] andUser:self options:nil ];
//	NSAssert(_filter!=nil, @"filter setup failed!");
//	_rootNodeProxy = [_filter rootNodeProxy];
	
	//	self.currentNodeGroup = rootNode;
	
	/* Initially we will be operating on Nodes */
	//	self.filterType = @"All";
	
	//	[displayedNodesTableView setTarget:self];
	//	[displayedNodesTableView setDoubleAction:@selector(doubleClick:)];
	
	// Not sure whether to use the notification (on the main thread, queud) or just observe it directly
	//	[graphModel addObserver:self forKeyPath:@"currentNodeGroup" options:NSKeyValueObservingOptionNew context:NULL];	
}

- (void)tearDownViews {
	/* This unhooks the arraycontroller */
	//	[self setFilterType:nil];
	
//	SHNodeGraphModel* graphModel = [[docWindowController document] nodeGraphModel];
//	NSAssert(graphModel != nil, @"ERROR: There is no GraphModel To Connect to.");
//	[graphModel unregisterContentFilter:[NodeClassFilter class] andUser:self options:nil];
	
	/* Not sure if delegate and datasource methods are causing tableView to retain us.. hence retain cycle.. so - this wont hurt either way */
//	[outlineView setDataSource:nil];
//	[outlineView setDelegate:nil];
	
	//	[graphModel removeObserver:self forKeyPath:@"currentNodeGroup"];
	
	//	if(_selectionIsBound==YES){
	//		[self removeSelectionBinding];
	//	}
	
	// observe notifications from the model
	//	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	//	[nc removeObserver:self]; // this will stop us receiveing tableview notifications which cant be put back - ie this is final
	
	//	self.displayedNodesArrayController = nil;
	//	self.displayedNodesTableView = nil;
	//	self.infoText = nil;
	//	self.docWindowController = nil;
	//	self.currentNodeGroup = nil;
	//	self.contentView = nil;
	//	self.selectionKeyPath = nil;
	
}

- (IBAction)reloadData:(id)sender {
    [_objectBrowser loadColumnZero];
}

- (IBAction)browserSingleClick:(id)browser 
{
    // Determine the selection and display it's icon and inspector information on the right side of the UI.
	//	NSImage            *inspectorImage = nil;
	NSAttributedString *attributedString = nil;
	// NSLog(@"SHObjPaletteControl.m: did single click");
	
	if ([[browser selectedCells] count]==1) 
	{
		NSString *nodePath = [browser path]; // current path in browser
		
		struct ObjectAndKey anObjandKey;
		[self objectFromPath:nodePath intoStruct: &anObjandKey ];
		
		id therepresentedObject = anObjandKey.theObject;
		NSString *theKey = anObjandKey.theKey;
		
		// NSLog(@"ABOUT TO MAKE A NODE:browserSingleClick:%@", theKey );
		FSNodeInfo *fsNode = [FSNodeInfo nodeWithParent: nil atRelativePath: theKey representedObject:therepresentedObject ];
		
		if([therepresentedObject respondsToSelector:@selector(keyEnumerator)]==YES)
			[fsNode setIsDirectory:YES];
		else
			[fsNode setIsDirectory:NO];
		
//		attributedString = [self attributedInspectorStringForFSNode: fsNode];	// autoreleased
		// inspectorImage = [fsNode iconImageOfSize: NSMakeSize(128,128)];
	} else if ([[browser selectedCells] count]>1) {
//		attributedString = [[[NSAttributedString alloc] initWithString: @"Multiple Selection"]autorelease];
	} else {
//		attributedString = [[[NSAttributedString alloc] initWithString: @"No Selection"]autorelease];
	}
	
	// set the info text
	//NSTextStorage *ts = [[(SHObjPaletteView*)_swapableView theTextField] textStorage];
	//[ts setAttributedString:attributedString];
	
	// [nodeIconWell setImage: inspectorImage];
	//[(SHObjPaletteView*)_swapableView setNeedsDisplay:YES];
}

- (IBAction)browserDoubleClick:(id)browser
{
    // Open the file and display it information by calling the single click routine.
	NSString *nodePath = [browser path];
	NSArray *components = [nodePath pathComponents];
	//	ScriptModel *currentScript = [[theAppControl theSHAppView] myScriptControl];
	
	[self browserSingleClick: browser];
	// [[NSWorkspace sharedWorkspace] openFile: nodePath];
	// NSLog(@"did double click %@", components );
	
	// first component is a forward slash
	int pathComponents = [components count];
	
	struct ObjectAndKey anObjandKey;
	[self objectFromPath:nodePath intoStruct:&anObjandKey ];
	
	id therepresentedObject = anObjandKey.theObject;
	
	if([therepresentedObject respondsToSelector:@selector(keyEnumerator)]==NO) // test to see if it is a group
	{
		switch(pathComponents)
		{
			case 1: break;
			case 2: break;
			case 3:
				[self addNodeToCurrentNodeGroup:[components objectAtIndex:pathComponents-1 ] fromGroup: [components objectAtIndex:pathComponents-2 ] ];
				break;
			case 4:
				[self addNodeToCurrentNodeGroup: [components objectAtIndex:pathComponents-1 ] fromGroup: [components objectAtIndex:pathComponents-2 ] fromGroup: [components objectAtIndex:pathComponents-3 ] ];
				break;
			case 5: break;
		}
	}
}

- (void)addNodeToCurrentNodeGroup:(NSString *)aNodeType fromGroup:(NSString *)aNodeGroup0
{   
	// look up nodeType in the Dictionary and make a new instance of the class 'aNodeType' if it exists
	SHNodeRegister *theSHNodeRegister = [SHNodeRegister sharedNodeRegister];
	Class classObject = [theSHNodeRegister lookupNode:aNodeType inGroup:aNodeGroup0];
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
	BlakeDocument *doc = (BlakeDocument *)[dc frontDocument];

	if(classObject!=nil && doc)
	{
		SHNode *aNode = [classObject makeChildWithName:@"newNode"];
		[doc addChildrenToCurrentNode:[NSArray arrayWithObject:aNode]];
	} else {
		logWarning(@"SHObjPaletteModel.m: ERROR: Cant find that node");
	}
}


- (void)addNodeToCurrentNodeGroup:(NSString *)aNodeType fromGroup:(NSString *)aNodeGroup0 fromGroup:(NSString *)aNodeGroup1
{  	
	// look up nodeType in the Dictionary and make a new instance of the class 'aNodeType' if it exists
	SHNodeRegister *theSHNodeRegister = [SHNodeRegister sharedNodeRegister];
	Class classObject = [theSHNodeRegister lookupNode:aNodeType inGroup:aNodeGroup0 inGroup:aNodeGroup1];
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
	BlakeDocument *doc = (BlakeDocument *)[dc frontDocument];

	if(classObject!=nil && doc)
	{		
		SHNode* aNode = [classObject makeChildWithName:@"newNode"];
		[doc addChildrenToCurrentNode:[NSArray arrayWithObject:aNode]];
	} else {
		NSLog(@"SHObjPaletteModel.m: ERROR: Cant find that node");
	}
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(int)row column:(int)column 
{
	// NSLog(@" !! will display cell %@ at column %i, at row %i!!", cell, column, row);
	
    NSString   *containingDirPath = nil;
    FSNodeInfo *containingDirNode = nil;
    FSNodeInfo *displayedCellNode = nil;
    NSArray    *directoryContents = nil;
	
    // Get the absolute path represented by the browser selection, and create a fsnode for the path.
    // Since (row,column) represents the cell being displayed, containingDirPath is the path to it's containing directory.
	containingDirPath = [self fsPathToColumn: column];
	// NSLog(@"XXXXXXXXXXXX containing dir path is %@", containingDirPath );
	struct ObjectAndKey anObjandKey;
	[self objectFromPath:containingDirPath intoStruct: &anObjandKey ];
	
	id therepresentedObject = anObjandKey.theObject;
	NSString *theKey = anObjandKey.theKey;
	
	// NSLog(@"ABOUT TO MAKE A NODE:willDisplayCell:%@", theKey );
	
	containingDirNode = [FSNodeInfo nodeWithParent: nil atRelativePath: theKey representedObject:therepresentedObject ];
	[containingDirNode setIsDirectory:YES];
	
    // Ask the parent for a list of visible nodes so we can get at a FSNodeInfo for the cell being displayed.
    // Then give the FSNodeInfo to the cell so it can determine how to display itself.
    // directoryContents = [containingDirNode visibleSubNodes];
	directoryContents = [self subNodesOfNode:containingDirNode];
	displayedCellNode = [directoryContents objectAtIndex: row];
    
    [cell setAttributedStringValueFromFSNodeInfo: displayedCellNode];
}

- (NSString *)fsPathToColumn:(int)column {
	
    NSString *path = nil;
    if(column==0) {
		path = @"/";
    } else {
		path = [_objectBrowser pathToColumn: column];
	}
	return path;
}

- (int)browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column
{	
	// NSLog(@"SHObjPaletteControl.m: ZZZZZZZZZZZZZZZZZZ initing browser with column %i", column );
    NSString   *fsNodePath = nil;
    FSNodeInfo *fsNodeInfo = nil;
    
    // Get the absolute path represented by the browser selection, and create a fsnode for the path.
    // Since column represents the column being (lazily) loaded fsNodePath is the path for the last selected cell.
    fsNodePath = [self fsPathToColumn: column];
	
	struct ObjectAndKey anObjandKey;
	[self objectFromPath:fsNodePath intoStruct: &anObjandKey ];
	
	id therepresentedObject = anObjandKey.theObject;
	NSString *theKey = anObjandKey.theKey;
	
	// NSLog(@"!!ABOUT TO MAKE A NODE:numberOfRowsInColumn:%@", therepresentedObject );
	
    fsNodeInfo = [FSNodeInfo nodeWithParent: nil atRelativePath: theKey representedObject:therepresentedObject ];
    [fsNodeInfo setIsDirectory:YES];
	
	// return [[fsNodeInfo visibleSubNodes] count];
	// NSLog(@"number of rows in this column is %i", [[self subNodesOfNode:fsNodeInfo ]count] );
	return [[self subNodesOfNode:fsNodeInfo] count];
}

- (void)objectFromPath:(NSString *)path intoStruct:(struct ObjectAndKey *)struct_ptr {

	NSArray *components = [path pathComponents];
	SHNodeRegister *theSHNodeRegister = [SHNodeRegister sharedNodeRegister];
	NSMutableDictionary *parentObject = [theSHNodeRegister allNodeGroups];

	NSString *theKey = nil;
	for( theKey in components ){
		parentObject = [parentObject objectForKey: theKey];
	}
	struct_ptr->theObject = parentObject;
	struct_ptr->theKey = theKey;
}

- (NSArray *)subNodesOfNode:(FSNodeInfo *)aNode
{
	NSString *nextKey = nil;
	id nextObject;
    NSMutableArray *subNodes = [NSMutableArray array];
	
	// see if it is a directory
	if([aNode isDirectory]==YES)
	{
		id representedObject = [aNode representedObject];
		NSEnumerator *keysInDictionary = [representedObject keyEnumerator];
		
		while ((nextKey=[keysInDictionary nextObject])) 
		{
			nextObject = [representedObject objectForKey:nextKey];
			FSNodeInfo *node = [FSNodeInfo nodeWithParent:aNode atRelativePath: nextKey representedObject:nextObject];
			if([nextObject respondsToSelector:@selector(keyEnumerator)]==YES)
				[node setIsDirectory:YES];
			else
				[node setIsDirectory:NO];
			[subNodes addObject: node];
		}
	} else {
		return nil;
	}
    return subNodes;
}

- (NSAttributedString *)attributedInspectorStringForFSNode:(FSNodeInfo *)fsnode 
{
    NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:[self boldFontAttributes]] autorelease];
	
	if( [[fsnode representedObject] respondsToSelector:@selector(descriptions)] )
	{
		SHNode *theNode = [fsnode representedObject];
		NSMutableArray *representedObjectDescriptions = [[theNode class] descriptions];
		NSEnumerator *keysInDictionary = [representedObjectDescriptions objectEnumerator];
		
		// iterate through our 'descriptions' dictionary building a string
		NSString *nextObject;
		while ((nextObject=(NSString *)[keysInDictionary nextObject])) 
		{
			[attrString appendAttributedString: [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@\n", nextObject ] attributes:[self normalFontAttributes]] autorelease]];
		}
		
		[attrString appendAttributedString: [[[NSAttributedString alloc] initWithString:@"an example link" attributes:[self linkAttributes:[NSURL URLWithString:@"http://www.apple.com"]]] autorelease]];
		//    [attrString appendAttributedString: [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@\n", [fsnode fsType]] attributes:[self normalFontAttributes]] autorelease]];
	}
	return attrString;
}

@end
