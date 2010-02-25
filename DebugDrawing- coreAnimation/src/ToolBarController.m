//
//  ToolBarController.m
//  DebugDrawing
//
//  Created by steve hooley on 21/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "ToolBarController.h"
#import "SelectionWandIcon.h"
#import "EditingViewController.h"
#import "EditingToolProtocol.h"
//#import "TranslateTool.h"
//#import "TextTool.h"
//#import "EdgeMoveTool.h"
//#import "AnchorTool.h"
//#import "ScaleTool.h"
//#import "BezierPenTool.h"
//#import "RotateTool.h"
//june09#import "StarTool.h"
#import "StarScene.h"
#import "HitTester.h"
#import "StarScene.h"
#import "WidgetDisplay.h"

@interface ToolBarController ()

@property (readwrite, assign) EditingViewController *targetViewController;

- (void)_doSetup:(id)viewControllerArg;
- (void)swapOutTemporaryTool;
- (void)swapInTemporaryTool:(NSString *)value;
- (void)excxhangeCurrentTemporayToolFor:(NSString *)value;

@end

@implementation ToolBarController

//september09 @dynamic defaultTool;
@synthesize activeToolRepresentation = _activeToolRepresentation;

//september09@property (readonly) NSObject<EditingToolIconProtocol> *defaultToolRepresentation;
//september09@property (readwrite, assign) NSObject<EditingToolIconProtocol> *activeToolRepresentation;

@synthesize targetViewController = _targetViewController;

#pragma mark -
#pragma mark init methods
- (id)initWithWindow:(NSWindow *)win targetViewController:(id)viewController {

	self=[super init];
    if( self )
	{
		_window = win;

		// retain the keys and not the objects?
		_toolsAndToolRepresentations = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableZeroingWeakMemory capacity:10];
		_toolRepsAndKeys = [[NSMutableDictionary alloc] initWithCapacity:10];
		_orderedTools = [[NSMutableArray alloc] initWithCapacity:10];

//june09		StarTool *starTool = [[[StarTool alloc] initWithToolBarController:self] autorelease];
//june09		TranslateTool *translateT = [[[TranslateTool alloc] initWithToolBarController:self] autorelease];
	//	AnchorTool *tool3 = [[[AnchorTool alloc] initWithToolBarController:self] autorelease];
    //    ScaleTool  *tool4 = [[[ScaleTool alloc] initWithToolBarController:self] autorelease];
	//	EdgeMoveTool *tool5 = [[[EdgeMoveTool alloc] initWithToolBarController:self] autorelease];
	//	TextTool *tool6 = [[[TextTool alloc] initWithToolBarController:self] autorelease];
	//	BezierPenTool *tool7 = [[[BezierPenTool alloc] initWithToolBarController:self] autorelease];
//september09		RotateTool *rotatetool = [[[RotateTool alloc] initWithToolBarController:self] autorelease];



		[self _doSetup:viewController];
	}
    return self;
}

- (void)dealloc {

	NSAssert( _activeToolRepresentation==nil, @"Have we cleaned up toolbarcontroller?");

	[_toolsAndToolRepresentations release];
	[_toolRepsAndKeys release];
	[_orderedTools release];
    [super dealloc];
}

- (void)addTools:(NSArray *)tools {
	
	for( _ROOT_OBJECT_<EditingToolProtocol, Widget_protocol> *each in tools )
	{
		NSString *toolClassString = [each classAsString];
		NSString *toolIconClassString = [toolClassString stringByAppendingString:@"Icon"];
		Class toolIconClass = NSClassFromString(toolIconClassString);
		if( toolIconClass ){
			// -- make a button
			NSObject<EditingToolIconProtocol> *toolIconRep = [[[toolIconClass alloc] initWithToolBarController:self domainTool:each] autorelease];
			[_toolRepsAndKeys setObject:toolIconRep forKey:[each identifier]];
			[_toolsAndToolRepresentations setObject:each forKey:toolIconRep];
			[_orderedTools addObject:each];
		}
	}
}

- (void)_doSetup:(id)viewControllerArg {
	
    NSParameterAssert(viewControllerArg);
    self.targetViewController = viewControllerArg;
    
	NSToolbar *newToolBar = [[[NSToolbar alloc] initWithIdentifier:@"sketchDraw"] autorelease];
	_toolBar = newToolBar;
	[_toolBar setDelegate: self]; 
	
	[_toolBar setSizeMode: NSToolbarSizeModeSmall];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowBecameKey:) name:NSWindowDidBecomeKeyNotification object:_window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowResignedKey:) name:NSWindowDidResignKeyNotification object:_window];
}

- (void)addToolbarToWindow {
	
	[_window setToolbar:_toolBar];
	[self swapInTool:@"SKTSelectTool"];
}

- (void)cleanUp {

	[_activeToolRepresentation toolWillBecomeUnActive];
	[self setActiveToolRepresentation:nil]; 	
}

// we have to know if we are holding hot keys when we move to another window
- (void)windowBecameKey:(NSNotification *)an {

	[self applyKeysDown];
}

- (void)windowResignedKey:(NSNotification *)an {

	[self unApplyKeysDown];
}

- (void)applyKeysDown {
	
	BOOL shiftKeyDown = ([[NSApp currentEvent] modifierFlags] & (NSShiftKeyMask | NSAlphaShiftKeyMask)) !=0;
	BOOL altKeyDown = ([[NSApp currentEvent] modifierFlags] & (NSAlternateKeyMask)) !=0;
	if(shiftKeyDown && !_shiftDown)
		[self shift:YES];
	if(altKeyDown && !_altDown)
		[self alt:YES];
}

- (void)unApplyKeysDown {

	BOOL shiftKeyDown = ([[NSApp currentEvent] modifierFlags] & (NSShiftKeyMask | NSAlphaShiftKeyMask)) !=0;
	BOOL altKeyDown = ([[NSApp currentEvent] modifierFlags] & (NSAlternateKeyMask)) !=0;
	
	if(shiftKeyDown && _shiftDown)
		[self shift:NO];
	if(altKeyDown && _altDown)
		[self alt:NO];
}

/* This is called indirectly when a Tool is selected by the toolbar */
/* This will not receive the initial tool setting */
- (void)setActiveToolRepresentation:(_ROOT_OBJECT_<EditingToolIconProtocol> *)value {

	// -- the view needs a mouseadaptor 
	NSAssert(_targetViewController!=nil, @"not ready");

	NSObject<EditingToolProtocol> *newTool = [_toolsAndToolRepresentations objectForKey:value];
	
	if( _hijackedToolRep && _isAboutToSwapIn==NO ){
		NSLog( @"we are holding down ALT keys but have clicked on an item");
		_hijackedToolRep = [newTool identifier];
	
	} else {
		[_activeToolRepresentation toolWillBecomeUnActive];
		_activeToolRepresentation = value;
		[_activeToolRepresentation toolWillBecomeActive];
	}
}

- (NSArray *)toolKeys {

	NSMutableArray *sortedKeys = [_orderedTools collectResultsOfSelector:@selector(identifier)];
	// return [_toolRepsAndKeys allKeys];
	return sortedKeys;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    
	NSObject<EditingToolIconProtocol> *rep = [_toolRepsAndKeys objectForKey:itemIdentifier];
	NSObject<EditingToolProtocol> *tool = [_toolsAndToolRepresentations objectForKey:rep];
	NSAssert( rep, @"we must have a rep for this tool" );
	NSAssert( tool, @"we must have a tool for this rep" );

	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
	
	NSObject<EditingToolIconProtocol> *correspondingToolRepresentation = [_toolRepsAndKeys objectForKey:itemIdentifier];
	NSAssert( correspondingToolRepresentation!=nil, @"what the fuck>?" );
	[correspondingToolRepresentation setUpToolbarItem: item];
	return item;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    
	NSMutableArray *toolIdentifiers = [NSMutableArray array];
	NSArray *defaultItems = [NSArray arrayWithObjects: NSToolbarSeparatorItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier, nil];
	NSAssert([[toolIdentifiers objectAtIndex:0] isKindOfClass:[NSString class]], @"what the fuck>?");
	[toolIdentifiers addObjectsFromArray: [self toolKeys]];
	[toolIdentifiers addObjectsFromArray: defaultItems];
	return toolIdentifiers;
}

// get the names of the domain tools
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {

	NSMutableArray *toolIdentifiers = [NSMutableArray array];
	[toolIdentifiers addObjectsFromArray: [self toolKeys]];
	NSArray *defaultItems = [NSArray arrayWithObjects: NSToolbarFlexibleSpaceItemIdentifier, nil];
	[toolIdentifiers addObjectsFromArray: defaultItems];
	return toolIdentifiers;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {

	return [self toolKeys];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem {

    return YES;
}

- (void)toolbarWillAddItem:(NSNotification *)notification {
}

- (void)toolbarDidRemoveItem: (NSNotification *)notification {
	/* After an item is removed from a toolbar the notification is sent.  This allows the chance to tear down information related to the item that may have been cached.  The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.  */
}

#pragma mark Action Methods
- (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
	[_activeToolRepresentation _mouseDownEvent:event inStarView:view];
}

#pragma mark Helper Methods

//september09- (void)hitTestTool:(Tool *)aTool atPoint:(NSPoint)apoint pixelColours:(unsigned char *)pixelColours {
//september09	[_hitTestHelper hitTestTool:aTool atPoint:apoint pixelColours:pixelColours];
//september09}

// This should be the same scene that we are hit-testing so this probably needs rethinking
//september09- (StarScene *)sceneUndermanipulation {
//september09	return _scene;
//september09}

- (void)addWidgetToView:(NSObject<Widget_protocol> *)value {
	
	[_targetViewController addWidget:value];
}

- (void)removeWidgetFromView:(NSObject<Widget_protocol> *)value {
	
	[_targetViewController removeWidget:value];
}

//- (NSObject<EditingToolIconProtocol> *)defaultToolRepresentation {
//	
//	NSObject<EditingToolIconProtocol> *defaultTool = [_toolRepsAndKeys objectForKey:@"SKTSelectTool"];
//	NSAssert( defaultTool, @"we need a default tool!");
//	return defaultTool;
//}

#pragma mark Hot Key stuff
- (void)shift:(BOOL)value {
	
	if(value){
		_shiftDown = YES;
		if(_altDown){
			[self excxhangeCurrentTemporayToolFor:@"SKTZoomTool"];
		}
	} else {
		_shiftDown = NO;
		if(_altDown){
			[self excxhangeCurrentTemporayToolFor:@"SKTPanTool"];
		}
	}
}

// swap in a pan tool - sketchy at the moment
- (void)alt:(BOOL)value {

	if(value)
	{
		_altDown = YES;
		if(_shiftDown){
			[self swapInTemporaryTool:@"SKTZoomTool"];
		} else {
			[self swapInTemporaryTool:@"SKTPanTool"];
		}
	} else {
		_altDown = NO;
		[self swapOutTemporaryTool];
	}
}

- (void)swapInTool:(NSString *)value {
	
	NSParameterAssert(value);

	_isAboutToSwapIn = YES;
	[_toolBar setSelectedItemIdentifier: value];
	id ob = [_toolRepsAndKeys objectForKey:value];
	NSAssert(ob, @"tool not found;");
	[ob selectToolAction:self];
	_isAboutToSwapIn = NO;
}

- (void)excxhangeCurrentTemporayToolFor:(NSString *)value {
	
	NSParameterAssert(value);
	NSAssert(_hijackedToolRep, @"what");
	_isAboutToSwapIn = YES;
	_temporarySwappedInTool = value;
	id ob = [_toolRepsAndKeys objectForKey:value];
	NSAssert(ob, @"tool not found;");
	[ob selectToolAction:self];
	_isAboutToSwapIn = NO;
	
}

//TODO: -- look at quartz composer for this behavoir
//TODO: -- when press alt dont actually swap in the tool in the toolbar
//TODO: -- you can still click on the toolbar but the actual tool is still overidden
//TODO: -- if we click on the desktop or something we need to know when the window bacomes active again and test if the keys are still down
- (void)swapInTemporaryTool:(NSString *)value {
	
	NSParameterAssert(value);
	NSAssert(_hijackedToolRep==nil, @"what");
	
	NSString *currentSelectedID = [_toolBar selectedItemIdentifier];
	
	if( [currentSelectedID isEqualToString:value]==NO ) {
		_hijackedToolRep = currentSelectedID;
		_temporarySwappedInTool = value;
		_isAboutToSwapIn = YES;
		id ob = [_toolRepsAndKeys objectForKey:value];
		NSAssert(ob, @"tool not found");
		[ob selectToolAction:self];
		_isAboutToSwapIn = NO;
	}
}

- (void)swapOutTemporaryTool {

	NSAssert(_hijackedToolRep, @"what");

	_isAboutToSwapIn = YES;
	[[_toolRepsAndKeys objectForKey:_hijackedToolRep] selectToolAction:self];
	_hijackedToolRep = nil;
	_temporarySwappedInTool = nil;
	_isAboutToSwapIn = NO;
}

- (NSPoint)eventPtToViewPoint:(NSPoint)pt {
	
	NSAssert(_targetViewController, @"hmm");
	return [_targetViewController eventPtToViewPoint:pt];
}

- (CGPoint)eventPointToContentPoint:(NSPoint)pt {
	
	NSAssert(_targetViewController, @"hmm");
	return [_targetViewController eventPointToContentPoint:pt];
}

- (CGPoint)viewPointToScenePoint:(NSPoint)pt {

	NSAssert(_targetViewController, @"hmm");
	return [_targetViewController viewPointToScenePoint:pt];
}

@end
