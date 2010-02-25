//
//  BKPreferencesController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKPreferencesController.h"


@interface BKPreferencesController (BKPrivate)
- (void)addPreferencePaneExtension:(id<BKPreferencePaneProtocol>)preferencePaneDataSource;
- (void)resizeWindowToSize:(NSSize)newSize;
- (void)loadPreferencePaneExtensionsIfNeeded;
@end

@implementation BKPreferencesController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark init methods

- (id)init {
    if (self = [super initWithWindowNibName:@"BKPreferencesController"]) {
		fAnimateResize = YES;
    }
    return self;
}

#pragma mark dealloc

- (void)dealloc {
    [fPreferencePaneIdentifiers release];
    [fPreferencePaneDataSources release];
    [super dealloc];
}

#pragma mark awakeFromNib-like methods

- (void)windowDidLoad {
    fToolbar = [[[NSToolbar alloc] initWithIdentifier:@"BKPreferenceManagerToolbarIdentifier"] autorelease];    
    [fToolbar setDelegate:self];
    [[self window] setToolbar:fToolbar];
    [[self window] center];
	[[self window] makeKeyAndOrderFront:self];

	[self loadPreferencePaneExtensionsIfNeeded];

    NSString *firstPaneIdentifier = [fPreferencePaneIdentifiers count] ? [fPreferencePaneIdentifiers objectAtIndex:0] : nil;
    if (firstPaneIdentifier && [self selectedPaneIdentifier] == nil) {
		[self setSelectedPaneIdentifier:firstPaneIdentifier];
    }
	
	[loadingTextField setHidden:YES];
}

#pragma accessors

- (NSString *)selectedPaneIdentifier {
    return [fSelectedPreferencePaneExtension preferencePaneIdentifier];
}

- (void)setSelectedPaneIdentifier:(NSString *)paneIdentifier {
	[[self window] makeKeyAndOrderFront:self];
	
    if ([[self selectedPaneIdentifier] isEqual:paneIdentifier]) {
		return;
    }
	
    id preferencePaneDataSource = [fPreferencePaneDataSources objectForKey:paneIdentifier];
    
    logAssert(preferencePaneDataSource != nil, @"invalid paneIdentifier");
    logDebug(([NSString stringWithFormat:@"showing pane %@", paneIdentifier]));
    
    fSelectedPreferencePaneExtension = preferencePaneDataSource;
    
    [fToolbar setSelectedItemIdentifier:paneIdentifier];
    
    [[self window] setContentView:loadingView];
    
    if ([[self window] isVisible]) {
		[self resizeWindowToSize:[[preferencePaneDataSource preferencePaneView] bounds].size];
    } else {
		BOOL temp = fAnimateResize;
		fAnimateResize = NO;
		[self resizeWindowToSize:[[preferencePaneDataSource preferencePaneView] bounds].size];
		fAnimateResize = temp;
    }
    
    [preferencePaneDataSource willDisplayPreferencePane];
    [[self window] setContentView:[preferencePaneDataSource preferencePaneView]];
}

- (NSArray *)paneIdentifiers {
	[self loadPreferencePaneExtensionsIfNeeded];
    return fPreferencePaneIdentifiers;
}

#pragma mark delegate/datasource methods

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted {
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
    id preferencePaneDataSource = [fPreferencePaneDataSources objectForKey:itemIdent];
    
    if (preferencePaneDataSource) {
        [toolbarItem setLabel:[preferencePaneDataSource preferencePaneLabel]];
        [toolbarItem setToolTip:[preferencePaneDataSource preferencePaneTooltip]];
        [toolbarItem setImage:[preferencePaneDataSource preferencePaneImage]];
        [toolbarItem setTarget:self];
        [toolbarItem setAction:@selector(toolbarItemClicked:)];
    } else {
        toolbarItem = nil;
    }
    
    return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *) toolbar {
    return [self paneIdentifiers];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *) toolbar {
    return [self paneIdentifiers];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return [self paneIdentifiers];
}

- (void)toolbarItemClicked:(id)sender {
    [self setSelectedPaneIdentifier:[sender itemIdentifier]];
}

#pragma mark private

- (void)addPreferencePaneExtension:(id<BKPreferencePaneProtocol>)preferencePaneDataSource {
    NSString *preferencePaneIdentifier = [preferencePaneDataSource preferencePaneIdentifier];
    [fPreferencePaneIdentifiers addObject:preferencePaneIdentifier];
    [fPreferencePaneDataSources setObject:preferencePaneDataSource forKey:preferencePaneIdentifier];
}

float ToolbarHeightForWindow(NSWindow *window) {
    NSToolbar *toolbar;
    float toolbarHeight = 0.0;
    NSRect windowFrame;
    toolbar = [window toolbar];
    
    if(toolbar && [toolbar isVisible]) {
        windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
        toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
    }
    
    return toolbarHeight;
}

- (void)resizeWindowToSize:(NSSize)newSize {
    NSRect aFrame;
    
	if (newSize.width != 550) {
		logWarn((@"preferences window resize width does not equal 550"));
	}
	
    float newHeight = newSize.height + ToolbarHeightForWindow([self window]);
    float newWidth = newSize.width;
    
    aFrame = [NSWindow contentRectForFrameRect:[[self window] frame] styleMask:[[self window] styleMask]];
    
    aFrame.origin.y += aFrame.size.height;
    aFrame.origin.y -= newHeight;
    aFrame.size.height = newHeight;
    aFrame.size.width = newWidth;
    
    aFrame = [NSWindow frameRectForContentRect:aFrame styleMask:[[self window] styleMask]];
    
    [[self window] setFrame:aFrame display:YES animate:fAnimateResize];
}

- (void)loadPreferencePaneExtensionsIfNeeded {
	if (fPreferencePaneIdentifiers != nil && fPreferencePaneDataSources != nil) return;
	
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
	NSArray *sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"extensionInstance.preferencePaneOrderWeight" ascending:YES] autorelease]];
	NSArray *preferencePaneExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKPreferences.preferencepane" protocol:@protocol(BKPreferencePaneProtocol)];
	NSArray *sortedPreferencePaneExtensions = nil;
	
	@try {
		sortedPreferencePaneExtensions = [preferencePaneExtensions sortedArrayUsingDescriptors:sortDescriptors];
	} @catch (NSException *exception) {
		sortedPreferencePaneExtensions = preferencePaneExtensions;
	}
	
    NSEnumerator *enumerator = [sortedPreferencePaneExtensions objectEnumerator];
    BKExtension *each;

	fPreferencePaneIdentifiers = [[NSMutableArray alloc] init];
	fPreferencePaneDataSources = [[NSMutableDictionary alloc] init];

    while (each = [enumerator nextObject]) {
		id <BKPreferencePaneProtocol> extension = [each extensionInstance];
		[self addPreferencePaneExtension:extension];
	}
}

@end
