//
//  SHObjPaletteControl.m
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

#import "SHObjPaletteControl.h"
#import "SHObjPaletteModel.h"
#import "SHObjPaletteView.h"
//#import "SHAppControl.h"
//#import "SHAppModel.h"
//#import "SHSwapableView.h"
#import "FSNodeInfo.h"
#import "FSBrowserCell.h"
#import "SHNodeRegister.h"
// #import "SHNode.h"
#import "SHInfoTextView.h"

#define NUMBER_OF_COLUMNS 		2	/* Sadly, all groups must go to the same depth. Bah! */

NSString* _windowTitle;

@implementation SHObjPaletteControl


#pragma mark -
#pragma mark init methods
+ (void)initialize {
	_windowTitle = @"Object Palette";
}


//=========================================================== 
// - initWithAppControl:
//=========================================================== 
- (id)initWithSHAppControl:(SHAppControl*)anAppControl
{
    if ((self = [super init]) != nil)
    {
		_theAppControl			= anAppControl;	// dont retain parent objects
		_theSHObjPaletteModel	= [[SHObjPaletteModel alloc]initWithController:self];
		_swapableView			= [[SHObjPaletteView alloc]initWithController:self];
		[self awakeFromNib];
	}
    return self;
}

// ===========================================================
//  - dealloc:
// ===========================================================
- (void)dealloc
{
    //[_theAppControl release];
    [_theSHObjPaletteModel release];
    [(id)_swapableView release];
    _theAppControl = nil;
    _theSHObjPaletteModel = nil;
    _swapableView = nil;
    [super dealloc];
}

// ===========================================================
// - awakeFromNib:
// ===========================================================
- (void) awakeFromNib
{
	NSMutableDictionary* allDynamicallyLoadedOperators = (NSMutableDictionary*)[[SHGlobalVars globals] objectForKey:@"theOperatorPlugins"];
	if(allDynamicallyLoadedOperators==nil){
		NSLog(@"SHObjPaletteControl.m: ERROR in awakeFromNib. There are NO dynamically loaded operators" );
		return;
	}

	[_theSHObjPaletteModel setLoadedOperators:allDynamicallyLoadedOperators];

	[(SHObjPaletteView*)_swapableView reloadColumn:0];
}

#pragma mark action methods
- (void) willBeRemovedFromViewPort{
	[super willBeRemovedFromViewPort];
}
- (void) willBeAddedToViewPort{
	[super willBeAddedToViewPort];
}

// ===========================================================
// - syncWithNodeGraphModel
// ===========================================================
- (void) syncWithNodeGraphModel
{
	[super syncWithNodeGraphModel];

	// when you load a script the model can get out of sync with the views
	if(_isInViewPort || _isInWindow)
	{
		// sync model
		//[_theSHObjectListModel syncWithNodeGraphModel];
		//NSLog(@"SHObjectListControl.m: syncWithNodeGraphModel");
	}
}

- (void) enable
{
	[super enable];
//	[_theSHObjPaletteModel initBindings];
}
- (void) disable
{
	[super disable];
//	[_theSHObjPaletteModel unBind];
}

#pragma mark accessor methods


// ===========================================================
// - theSHObjPaletteModel:
// ===========================================================
- (SHObjPaletteModel *)theSHObjPaletteModel { return _theSHObjPaletteModel; }


@end


@implementation SHObjPaletteControl(PrivateMethods)


// ===========================================================
//  - browser:createRowsForColumn:inMatrix
// ===========================================================
//- (void)browser:(NSBrowser *)sender createRowsForColumn:(int)column inMatrix:(NSMatrix *)matrix
//{
//	NSMutableArray *newRow		= [[[NSMutableArray alloc]initWithCapacity:1]retain];
//	NSActionCell *tempCell			= [[NSActionCell alloc] initTextCell:@"break"];
//	[newRow addObject:tempCell];
//	[matrix addRowWithCells:newRow ];
//}
	

// Use lazy initialization, since we don't want to touch the file system too much.
// ==========================================================
// browser: numberOfRowsInColumn:
// ==========================================================
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
	return [[self subNodesOfNode:fsNodeInfo ]count];
}


// ==========================================================
// browser: willDisplayCell: atRow: column:
// ==========================================================
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


// ===========================================================
//  - fsPathToColumn
// ===========================================================
- (NSString*)fsPathToColumn:(int)column {
    NSString *path = nil;
    if(column==0) {
		path = [NSString stringWithFormat: @"/"];
		// NSLog(@"fsPathToColumn forward slash");
    } else {
		// NSLog(@"fsPathToColumn proper path");
		path = [[(SHObjPaletteView*)_swapableView theObjectBrowser] pathToColumn: column];
	}
	return path;
}


- (void)objectFromPath:(NSString *)path intoStruct:(struct ObjectAndKey *)struct_ptr
{
	NSArray * components = [path pathComponents];
	SHNodeRegister * theSHNodeRegister = [_theSHObjPaletteModel theSHNodeRegister];
	NSMutableDictionary* parentObject = [theSHNodeRegister allNodeGroups];

	what?
	for( NSString *theKey in components ){
		parentObject = [parentObject objectForKey: theKey];
	}
	struct_ptr->theObject = parentObject;
	struct_ptr->theKey = theKey;
	// struct ObjectAndKey anObjectAndKey = {parentObject,theKey};
	// return anObjectAndKey;
}


// ==========================================================
// subNodes
// ==========================================================
- (NSArray *)subNodesOfNode:(FSNodeInfo*)aNode
{
	NSString		*nextKey = nil;
	id				nextObject;
    NSMutableArray	*subNodes = [NSMutableArray array];
	
	// see if it is a directory
	if([aNode isDirectory]==YES)
	{
		id representedObject = [aNode representedObject];
		// NSLog(@"node is a directory with %i elements", [representedObject count]);
		NSEnumerator   *keysInDictionary = [representedObject keyEnumerator];
		
		while ((nextKey=[keysInDictionary nextObject])) 
		{
			nextObject = [representedObject objectForKey:nextKey];
			// NSLog(@"ABOUT TO MAKE A NODE:subNodesOfNode:%@", nextKey );
			FSNodeInfo *node = [FSNodeInfo nodeWithParent:aNode atRelativePath: nextKey representedObject:nextObject ];
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



// ==========================================================
// Browser Target / Action Methods.
// ==========================================================


// ==========================================================
// browserSingleClick
// ==========================================================
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
		
		attributedString = [self attributedInspectorStringForFSNode: fsNode];	// autoreleased
		// inspectorImage = [fsNode iconImageOfSize: NSMakeSize(128,128)];
	} else if ([[browser selectedCells] count]>1) {
		attributedString = [[[NSAttributedString alloc] initWithString: @"Multiple Selection"]autorelease];
	} else {
		attributedString = [[[NSAttributedString alloc] initWithString: @"No Selection"]autorelease];
	}
	
	// set the info text
	NSTextStorage *ts = [[(SHObjPaletteView*)_swapableView theTextField] textStorage];
	[ts setAttributedString:attributedString];//
		
	// [nodeIconWell setImage: inspectorImage];
	[(SHObjPaletteView*)_swapableView setNeedsDisplay:YES];
}


// ==========================================================
// browserDoubleClick
// ==========================================================
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
				[_theSHObjPaletteModel addNodeToCurrentNodeGroup:[components objectAtIndex:pathComponents-1 ] fromGroup: [components objectAtIndex:pathComponents-2 ] ];
				break;
			case 4:
				[_theSHObjPaletteModel addNodeToCurrentNodeGroup: [components objectAtIndex:pathComponents-1 ] fromGroup: [components objectAtIndex:pathComponents-2 ] fromGroup: [components objectAtIndex:pathComponents-3 ] ];
				break;
			case 5: break;
		}
	}
	
}


- (NSDictionary*)normalFontAttributes {
    return [NSDictionary dictionaryWithObject: [NSFont systemFontOfSize:[NSFont systemFontSize]-3] forKey:NSFontAttributeName];
}

- (NSDictionary*)boldFontAttributes {
    return [NSDictionary dictionaryWithObject: [NSFont boldSystemFontOfSize:[NSFont systemFontSize]-3] forKey:NSFontAttributeName];
}

- (NSDictionary*)linkAttributes:(NSURL*)anURL
{
	NSMutableDictionary *atts = [NSMutableDictionary dictionaryWithObject: anURL forKey:NSLinkAttributeName];
	[atts setObject:[NSFont systemFontOfSize:[NSFont systemFontSize]-3] forKey:NSFontAttributeName];
	
	
	return atts;
}


// ==========================================================
// attributedInspectorStringForFSNode
// ==========================================================
- (NSAttributedString*)attributedInspectorStringForFSNode:(FSNodeInfo*)fsnode 
{
    NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:[self boldFontAttributes]] autorelease];
	
	if( [[fsnode representedObject]respondsToSelector:@selector(descriptions)] )
	{
		SHNode *theNode = [fsnode representedObject];
		NSMutableArray *representedObjectDescriptions = [[theNode class] descriptions];
		NSEnumerator   *keysInDictionary = [representedObjectDescriptions objectEnumerator];
		
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


// ===========================================================
// - windowTitle:
// ===========================================================
+ (NSString*) windowTitle
{
	return _windowTitle;
}

@end