//
//  BKPluginPreferencePaneExtension.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKPluginPreferencePaneExtension.h"


@implementation BKPluginPreferencePaneExtension

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark init

- (id)init {
	if (self = [super init]) {
		fCatagoriesCatches = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark dealloc

- (void)dealloc {
	[fCatagoriesCatches release];
	[super dealloc];
}

#pragma mark awakeFromNib-like methods

- (void)awakeFromNib {
	NSString *processName = [[NSProcessInfo processInfo] processName];
	NSString *customMessage = [NSString stringWithFormat:[messageTextField stringValue], processName, processName, processName];
	[messageTextField setStringValue:customMessage];
}

#pragma mark accessors

- (NSView *)view {
    if (!view) {
		if (![NSBundle loadNibNamed:@"BKPluginPreferencePane" owner:self]) {
			logError((@"failed to load view"));
		} else {
			logInfo((@"loaded view"));
		}
		logAssert(view != nil, @"view != nil assert failed");
    }
    return view;
}

- (BKPlugin *)selectedPlugin {
	id item = [outlineView itemAtRow:[outlineView selectedRow]];
	
	if (item) {
		if ([item isKindOfClass:[BKPlugin class]]) {
			return item;
		} else if ([item isKindOfClass:[NSDictionary class]]) {
			return [item objectForKey:@"plugin"];
		} else if ([item isKindOfClass:[BKRequirement class]]) {
			return nil;
		} else if ([item isKindOfClass:[BKExtension class]]) {
			return [item plugin];
		} else if ([item isKindOfClass:[BKExtensionPoint class]]) {
			return [item plugin];
		}
	}
	
	return nil;
}

#pragma mark actions

- (NSString *)thisApplicationSupportFolderName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
}

- (NSString *)thisPluginsFolderName {
    return @"PlugIns";
}

- (IBAction)openPluginsFolder:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *library = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString *applicationSupport = [library stringByAppendingPathComponent:@"Application Support"];
    NSString *thisApplicationSupport = [applicationSupport stringByAppendingPathComponent:[self thisApplicationSupportFolderName]];
    NSString *thisApplicationPlugins = [thisApplicationSupport stringByAppendingPathComponent:[self thisPluginsFolderName]];
    
    logAssert([fileManager fileExistsAtPath:library], @"no library folder");
    
    if (![fileManager fileExistsAtPath:applicationSupport]) {
		logAssert([fileManager createDirectoryAtPath:applicationSupport attributes:nil], @"failed to create application support folder");
		logInfo((@"created application support folder"));
    }
    
    if (![fileManager fileExistsAtPath:thisApplicationSupport]) {
		logAssert([fileManager createDirectoryAtPath:thisApplicationSupport attributes:nil], @"failed to create this application's application support folder");
		logInfo((@"created this application's application support folder"));
    }
	
    if (![fileManager fileExistsAtPath:thisApplicationPlugins]) {
		logAssert([fileManager createDirectoryAtPath:thisApplicationPlugins attributes:nil], @"failed to create this plugins folder");
		logInfo((@"created applications plugin folder"));
    }
	
    [[NSWorkspace sharedWorkspace] openFile:thisApplicationPlugins];
}

- (IBAction)findScriptsAndPlugins:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[[NSApp delegate] applicationPluginsAndScriptsURLString]]];	
}

- (IBAction)viewXML:(id)sender {
	NSString *xmlPath = [[self selectedPlugin] xmlPath];
	
	if (!xmlPath) {
		logError((@"failed to find xml file"));
	} else {
		[[NSWorkspace sharedWorkspace] openFile:xmlPath withApplication:@"TextEdit"];
	}
}

- (IBAction)viewProtocols:(id)sender {
	BKPlugin *plugin = [self selectedPlugin];
	NSString *protocolsPath = [plugin protocolsPath];
	
	if (!protocolsPath) {
		NSString *prtocolsFileName = [[[[plugin bundle] executablePath] lastPathComponent] stringByAppendingString:@"Protocols.h"];
		NSString *localizedTitle = BKLocalizedString(@"Could not find resource %@", nil);
		NSRunInformationalAlertPanel([NSString stringWithFormat:localizedTitle, prtocolsFileName],
									 BKLocalizedString(@"This plugin has not declared a public protocols file that can be used by other plugins.", nil),
									 BKLocalizedString(@"OK", nil), nil, nil);
	} else {
		[[NSWorkspace sharedWorkspace] openFile:protocolsPath];
	}
}

- (IBAction)revealInFinder:(id)sender {
	NSString *pluginPath = [[[self selectedPlugin] bundle] bundlePath];
	[[NSWorkspace sharedWorkspace] selectFile:pluginPath inFileViewerRootedAtPath:nil];
}

- (IBAction)extend:(id)sender {
	id item = [outlineView itemAtRow:[outlineView selectedRow]];
	
	if ([item isKindOfClass:[BKExtensionPoint class]]) {
		NSRunInformationalAlertPanel(BKLocalizedString(@"Not implemented", nil),
									 BKLocalizedString(@"This feature is not yet implemented.", nil),
									 BKLocalizedString(@"OK", nil), nil, nil);
	} else {
		NSRunInformationalAlertPanel(BKLocalizedString(@"Must select extension point", nil),
									 BKLocalizedString(@"You must first select the extension point that you wish to extend.", nil),
									 BKLocalizedString(@"OK", nil), nil, nil);
	}
}

- (IBAction)showMenuConfiguration:(id)sender {
	id <BKMenuControllerProtocol> mainMenuController = [[NSApp BKUserInterfaceProtocols_userInterfaceController] mainMenuController];
	[mainMenuController printMenuPathsToConsole:[mainMenuController menu] indent:@""];
	
	id <BKMenuControllerProtocol> dockMenuController = [[NSApp BKUserInterfaceProtocols_userInterfaceController] dockMenuController];
	[dockMenuController printMenuPathsToConsole:[dockMenuController menu] indent:@""];
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {
    SEL action = [menuItem action];
    if (@selector(viewXML:) == action ||
		@selector(viewProtocols:) == action ||
		@selector(revealInFinder:) == action ||
		@selector(extend:) == action) {
		
		return [self selectedPlugin] != nil;
    }
    return YES;
}

#pragma mark preference pane data source

- (NSString *)preferencePaneIdentifier {
	return @"BKPluginPreferencePane";
}

- (NSString *)preferencePaneTitle {
    return BKLocalizedString(@"Plugin Configuration", nil);    
}

- (NSString *)preferencePaneLabel {
    return BKLocalizedString(@"Plugin Config", nil);
}

- (NSView *)preferencePaneView {
	return [self view];
}

- (void)willDisplayPreferencePane {
	[outlineView reloadData];
}

- (NSString *)preferencePaneTooltip {
    NSString *tooltipFormat = BKLocalizedString(@"Open %@ Preference Pane", nil);
    return [NSString stringWithFormat:tooltipFormat, [self preferencePaneTitle]];
}

- (NSImage *)preferencePaneImage {
    NSImage *preferencePaneImage = [NSImage imageNamed:[self preferencePaneIdentifier] class:[self class]];
    logAssert(preferencePaneImage != nil, @"nil preference pane image");
    return preferencePaneImage;
}

- (float)preferencePaneOrderWeight {
	return 100;
}

#pragma mark outlineview delegate

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
}

#pragma mark outlineview data source

- (NSArray *)catagoriesFor:(BKPlugin *)plugin {
	NSArray *catagories = [fCatagoriesCatches objectForKey:[plugin identifier]];

	if (!catagories) {
		catagories = [NSArray arrayWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:@"Requirements", @"name", plugin, @"plugin", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Extends", @"name", plugin, @"plugin", nil],
			[NSDictionary dictionaryWithObjectsAndKeys:@"Extension Points", @"name", plugin, @"plugin", nil], nil];
		[fCatagoriesCatches setObject:catagories forKey:[plugin identifier]];
	}
	
	return catagories;
}

- (NSArray *)childrenForCatagory:(NSDictionary *)catagory {
	NSString *name = [catagory objectForKey:@"name"];
	BKPlugin *plugin = [catagory objectForKey:@"plugin"];
	
	if ([name isEqualToString:@"Requirements"]) {
		return [plugin requirements];
	} else if ([name isEqualToString:@"Extends"]) {
		return [plugin extensions];
	} else {
		return [plugin extensionPoints];
	}
	
	return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item {
    if (!item) return [[[BKPluginRegistry sharedInstance] plugins] objectAtIndex:index];
	
	if ([item isKindOfClass:[BKPlugin class]]) {
		return [[self catagoriesFor:item] objectAtIndex:index];
	} else if ([item isKindOfClass:[NSDictionary class]]) {
		return [[self childrenForCatagory:item] objectAtIndex:index];
	} else if ([item isKindOfClass:[BKExtensionPoint class]]) {
		return [[item extensions] objectAtIndex:index];
	}
	
	return nil;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (!item) return [[[BKPluginRegistry sharedInstance] plugins] count];
	
	if ([item isKindOfClass:[BKPlugin class]]) {
		return [[self catagoriesFor:item] count];
	} else if ([item isKindOfClass:[NSDictionary class]]) {
		return [[self childrenForCatagory:item] count];
	} else if ([item isKindOfClass:[BKRequirement class]]) {
		return 0;
	} else if ([item isKindOfClass:[BKExtension class]]) {
		return 0;
	} else if ([item isKindOfClass:[BKExtensionPoint class]]) {
		return [[item extensions] count];
	}
	
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)anOutlineView isItemExpandable:(id)item {
	return [self outlineView:anOutlineView numberOfChildrenOfItem:item] > 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([item isKindOfClass:[BKPlugin class]]) {
		return [NSString stringWithFormat:@"%@%@", [item name], [item isLoaded] ? @"" : @" (not loaded)"];
	} else if ([item isKindOfClass:[NSDictionary class]]) {
		return [item objectForKey:@"name"];
	} else if ([item isKindOfClass:[BKRequirement class]]) {
		return [item bundleIdentifier];
	} else if ([item isKindOfClass:[BKExtension class]]) {
		return [item extensionClassName];
	} else if ([item isKindOfClass:[BKExtensionPoint class]]) {
		return [item identifier];
	}
	
	return nil;
}

@end
