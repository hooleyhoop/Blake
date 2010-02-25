// SKTToolPaletteController.m
// Sketch Example
//

#import "SKTToolPaletteController.h"
#import "SKTWindowController.h"

#import "SKTSelectTool.h"
#import "SKTTransformTool.h"
#import "SKTCircleTool.h"
#import "SKTRectangleTool.h"
#import "SKTImageTool.h"
#import "SKTLineTool.h"
#import "SKTTextTool.h"
#import "SKTCircle.h"
#import "SKTLine.h"
#import "SKTRectangle.h"
#import "SKTText.h"
#import "SKTTool.h"
#import "SKTBezierTool.h"


enum {
    SKTSelectToolRow = 0,
    SKTRectToolRow,
    SKTCircleToolRow,
    SKTLineToolRow,
    SKTTextToolRow,
};


@implementation SKTToolPaletteController

@synthesize activeTool = _activeTool;

#pragma mark -
#pragma mark class methods

#pragma mark init methods
- (id)initWithWindowController:(SKTWindowController *)winControl {

    if( (self=[super init])!=nil )
	{
		_sketchWindowController = winControl;

		SKTSelectTool		*tool1 = [[[SKTSelectTool alloc] initWithController:self] autorelease];
		SKTTransformTool	*tool2 = [[[SKTTransformTool alloc] initWithController:self] autorelease];
		SKTCircleTool		*tool3 = [[[SKTCircleTool alloc] initWithController:self] autorelease];
		SKTRectangleTool	*tool4 = [[[SKTRectangleTool alloc] initWithController:self] autorelease];
		SKTImageTool		*tool5 = [[[SKTImageTool alloc] initWithController:self] autorelease];
		SKTLineTool			*tool6 = [[[SKTLineTool alloc] initWithController:self] autorelease];
		SKTTextTool			*tool7 = [[[SKTTextTool alloc] initWithController:self] autorelease];
		SKTBezierTool		*tool8 = [[[SKTBezierTool alloc] initWithController:self] autorelease];
		_tools = [[NSArray arrayWithObjects: tool1, tool2, tool3, tool4, tool5, tool6, tool7, tool8, nil] retain];
	}
    return self;
}

- (void)dealloc {
   
	self.activeTool = nil;
	
	/* not sure if this is a good place to do this… */
	[self removeObserver:self forKeyPath:@"activeTool"];

	[_tools release];
    [super dealloc];
}

#pragma mark notification methods



//- (Class)currentGraphicClass {
//
//	NSString *row = [self currentTool];
//    Class theClass = nil;
//	if ([row isEqualToString: @"SKTRectTool"] ) {
//		theClass = [SKTRectangle class];
//	} else if ([row isEqualToString: @"SKTCircleTool"] ) {
//		theClass = [SKTCircle class];
//	} else if ([row isEqualToString: @"SKTLineTool"] ) {
//		theClass = [SKTLine class];
//	} else if ([row isEqualToString: @"SKTTextTool"] ) {
//		theClass = [SKTText class];
//	}
//    return theClass;
//}

//- (void)selectArrowTool {
//	
//	[_toolBar setSelectedItemIdentifier: @"SKTSelectTool"];
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"SKTSelectedToolDidChange" object:self];
//}

//- (NSString *)currentTool {
//
//	return [_toolBar selectedItemIdentifier];
//}


- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    
	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
	SKTTool *correspondingTool = [_tools firstItemThatResultOfSelectorIsTrue:@selector(identifierMatches:) withObject: itemIdentifier];
	NSAssert(correspondingTool!=nil, @"what the fuck>?");
	[correspondingTool setUpToolbarItem: item];
    return item;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
    
	NSMutableArray *toolIdentifiers = [_tools collectResultsOfSelector:@selector(identifier)];
    NSArray *defaultItems = [NSArray arrayWithObjects: NSToolbarSeparatorItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier, nil];
	NSAssert([[toolIdentifiers objectAtIndex:0] isKindOfClass:[NSString class]], @"what the fuck>?");
	[toolIdentifiers addObjectsFromArray: defaultItems];
	return toolIdentifiers;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
    
	NSMutableArray *toolIdentifiers = [_tools collectResultsOfSelector:@selector(identifier)];
	NSAssert([[toolIdentifiers objectAtIndex:0] isKindOfClass:[NSString class]], @"what the fuck>?");
	NSArray *defaultItems = [NSArray arrayWithObjects: NSToolbarFlexibleSpaceItemIdentifier, nil];
	[toolIdentifiers addObjectsFromArray: defaultItems];
	return toolIdentifiers;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	
	NSMutableArray *toolIdentifiers = [_tools collectResultsOfSelector:@selector(identifier)];
	NSAssert([[toolIdentifiers objectAtIndex:0] isKindOfClass:[NSString class]], @"what the fuck>?");
    return toolIdentifiers;
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
    //    if ( [theItem action] == @selector(deleteRecord:) )
    //       return [tableView numberOfSelectedRows] > 0;
    return YES;
}

- (void)toolbarWillAddItem: (NSNotification *)notification {

}

- (void)toolbarDidRemoveItem: (NSNotification *)notification {
/* After an item is removed from a toolbar the notification is sent.  This allows the chance to tear down information related to the item that may have been cached.  The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.  */
}

- (void)setToolBar:(SHToolbar *)tb {
	
	_toolBar = tb;
	[_toolBar setDelegate: self];
	[_toolBar setSizeMode: NSToolbarSizeModeSmall];
	[_toolBar setSelectedItemIdentifier: @"SKTSelectTool"];
	
	[self addObserver:self forKeyPath:@"activeTool" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"SKTToolPaletteController"];
	
	[[_tools objectAtIndex:0] selectToolAction:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	NSString *context = (NSString *)vcontext;
	if(context==nil)
		[NSException raise:@"MUST SUPPLY A CONTEXT" format:@"MUST SUPPLY A CONTEXT"];
//	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//	BOOL oldValueNullOrNil = [oldValue isEqual:[NSNull null]] || oldValue==nil;
//	id newValue = [change objectForKey:NSKeyValueChangeNewKey];
//	BOOL newValueNullOrNil = [newValue isEqual:[NSNull null]] || newValue==nil;	
	// id changeKind = [change objectForKey:NSKeyValueChangeKindKey];
	
    if( [context isEqualToString:@"SKTToolPaletteController"] )
	{
        if ([keyPath isEqualToString:@"activeTool"])
        {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"SKTSelectedToolDidChange" object:self];
		}
	}
}


@end

