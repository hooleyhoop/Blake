#import "OutlineView1Controller.h"
#import <SketchGraph/NodeClassFilter.h>
#import <SketchGraph/NodeProxy.h>


@implementation OutlineView1Controller

@synthesize docWindowController;
@synthesize filter = _filter;

#pragma mark -
#pragma mark setup methods
/* called when the window finishes loading */
- (void)setupOutlineView1 {
	
	/* for the filtering array controller */
	// [displayedNodesArrayController setPropertyToMatch:@"name"];
	SHNodeGraphModel* graphModel = [[docWindowController document] nodeGraphModel];
	NSAssert(graphModel != nil, @"ERROR: There is no GraphModel To Connect to.");

	[graphModel registerContentFilter:[NodeClassFilter class] andUser:self options:nil ];
	NSAssert(_filter!=nil, @"filter setup failed!");
	_rootNodeProxy = [_filter rootNodeProxy];
	
//	self.currentNodeGroup = rootNode;
	
	/* Initially we will be operating on Nodes */
//	self.filterType = @"All";
	
//	[displayedNodesTableView setTarget:self];
//	[displayedNodesTableView setDoubleAction:@selector(doubleClick:)];
	
	// Not sure whether to use the notification (on the main thread, queud) or just observe it directly
//	[graphModel addObserver:self forKeyPath:@"currentNodeGroup" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)tearDownOutlineView1 {
	
	/* This unhooks the arraycontroller */
//	[self setFilterType:nil];

	SHNodeGraphModel* graphModel = [[docWindowController document] nodeGraphModel];
	NSAssert(graphModel != nil, @"ERROR: There is no GraphModel To Connect to.");
	[graphModel unregisterContentFilter:[NodeClassFilter class] andUser:self options:nil];

	/* Not sure if delegate and datasource methods are causing tableView to retain us.. hence retain cycle.. so - this wont hurt either way */
	[outlineView setDataSource:nil];
	[outlineView setDelegate:nil];
	
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

#pragma mark DIY notification methods
#warning - need to test whjether we need to redraw the children
- (void)temp_proxy:(NodeProxy *)value changedContent:(id)notUsed {
	[outlineView reloadItem:value reloadChildren:YES];
}
- (void)temp_proxy:(NodeProxy *)value insertedContent:(id)notUsed {
	[outlineView reloadItem:value reloadChildren:YES];
}
- (void)temp_proxy:(NodeProxy *)value removedContent:(id)notUsed {
	[outlineView reloadItem:value reloadChildren:YES];
}
- (void)temp_proxy:(NodeProxy *)value changedSelection:(id)notUsed {
	[outlineView reloadItem:value reloadChildren:YES];
}

#pragma mark OutlineView Data Source methods

/* Dont include interconnectors */
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	
	int numberOfChildren = 0;
	if(item == nil)
		numberOfChildren = 1;
	else {
		NodeProxy *node = (NodeProxy *)item;
		numberOfChildren = [node countOfFilteredContent];
	}
    return numberOfChildren;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	
	BOOL isExpandable = NO;
	NodeProxy *node = (NodeProxy *)item;

	if(node == nil)
		isExpandable = YES;
	else if([node.originalNode isKindOfClass:[SHNode class]] && [node.originalNode allowsSubpatches]){
		if([node countOfFilteredContent])
			isExpandable = YES;
	}
	return isExpandable;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	
	NodeProxy *node = (NodeProxy *)item;
    return (node == nil) ? _rootNodeProxy : [(NodeProxy *)node objectInFilteredContentAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	NodeProxy *node = (NodeProxy *)item;
   return (node == nil) ? @"/" : (id)[node.originalNode name];
}

// 
#pragma mark OutlineView Delegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    return NO;
}

#pragma mark accessor methods

- (NSArray *)readablePasteboardTypes {
	return nil;
}


@end
