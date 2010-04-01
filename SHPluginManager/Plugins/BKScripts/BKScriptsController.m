//
//  BKScriptsController.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/9/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKScriptsController.h"


@implementation BKScriptsController

#pragma mark class methods

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark dealloc

- (void)dealloc {
    [fScriptMenu release];
    [super dealloc];
}

#pragma mark accessors

- (NSMenu *)scriptMenu {
	if (fScriptMenu == nil) {
		fScriptMenu = [[NSMenu alloc] init];

		NSMenuItem *openScriptsFolder = [[[NSMenuItem alloc] init] autorelease];
		[openScriptsFolder setTitle:BKLocalizedString(@"Open Scripts Folder", nil)];
		[openScriptsFolder setAction:@selector(openScriptsFolder:)];
		[openScriptsFolder setTarget:self];
		[fScriptMenu addItem:openScriptsFolder];
		
		NSMenuItem *updateScriptsMenu = [[[NSMenuItem alloc] init] autorelease];
		[updateScriptsMenu setTitle:BKLocalizedString(@"Update Scripts Menu", nil)];
		[updateScriptsMenu setAction:@selector(updateScriptsMenu:)];
		[updateScriptsMenu setTarget:self];
		[fScriptMenu addItem:updateScriptsMenu];
		
		NSMenuItem *separatorItem = [NSMenuItem separatorItem];
		[separatorItem setRepresentedObject:@"ScriptsGroup"];
		[fScriptMenu addItem:separatorItem];
	}
	
    return fScriptMenu;
}

#pragma mark actions

- (IBAction)openScriptsFolder:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *library = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString *scripts = [library stringByAppendingPathComponent:@"Scripts"];
    NSString *applicationScripts = [scripts stringByAppendingPathComponent:[self applicationScriptsFolderName]];

    logAssert([fileManager fileExistsAtPath:library], @"no library folder");
    
    if (![fileManager fileExistsAtPath:scripts]) {
		logAssert([fileManager createDirectoryAtPath:scripts attributes:nil], @"failed to create scripts folder");
		logInfo((@"created scripts folder"));
    }

    if (![fileManager fileExistsAtPath:applicationScripts]) {
		logAssert([fileManager createDirectoryAtPath:applicationScripts attributes:nil], @"failed to create applicationScripts folder");
		logInfo((@"created application scripts folder"));
    }
    
    [[NSWorkspace sharedWorkspace] openFile:applicationScripts];
}

- (IBAction)updateScriptsMenu:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:BKScriptsFilesWillRefresh object:self];
    [self menuNeedsUpdate:[self scriptMenu]];
	[[NSNotificationCenter defaultCenter] postNotificationName:BKScriptsFilesDidRefresh object:self];
}

- (IBAction)scriptMenuAction:(id)sender {
	NSString *scriptPath = nil;
	
	if ([sender respondsToSelector:@selector(representedObject)]) {
		scriptPath = [sender representedObject];
	} else {
		scriptPath = [sender itemIdentifier];
	}
	
	if ([self validateScriptAtPath:scriptPath]) {
		NSEvent *event = [NSApp currentEvent];
		<BKScriptsFileControllerProtocol> fileTypeExtension = [self fileControllerFor:scriptPath];
		
		// xxx need better test. shouldn't open when option is used in keyboard shortcut.
		if ([event modifierFlags] & NSAlternateKeyMask) {
			[fileTypeExtension editScriptFile:scriptPath];
		} else {
			[fileTypeExtension runScriptFile:scriptPath];
		}    
	}
}

#pragma mark behavior

- (NSMenuItem *)menuItemForMenu:(NSMenu *)menu {
    NSMenu *superMenu = [menu supermenu];
    if (!superMenu) {
		return nil;
    } else {
		return (NSMenuItem *) [superMenu itemAtIndex:[superMenu indexOfItemWithSubmenu:menu]];
    }
}

- (id <BKScriptsFileControllerProtocol>)fileControllerFor:(NSString *)filePath {
    BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
    NSEnumerator *enumerator = [[pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKScripts.fileType" protocol:@protocol(BKScriptsFileControllerProtocol)] objectEnumerator];
    BKExtension *each;
    
    while (each = [enumerator nextObject]) {
		id <BKScriptsFileControllerProtocol> extension = [each extensionInstance];
		if ([extension acceptsScriptFile:filePath]) {
			return extension;
		}
	}
	
	return nil;
}

- (BOOL)validateScriptAtPath:(NSString *)path {
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSRunAlertPanel(BKLocalizedString(@"Script File Missing!", nil),
						BKLocalizedString(@"No script file could be found at the given location, please update your scripts menu.", nil),
						BKLocalizedString(@"OK", nil),
						nil,
						nil, @"");
		return NO;
	}
	
	if (![self fileControllerFor:path]) {
		NSRunAlertPanel(BKLocalizedString(@"Script File Not Recognized!", nil),
						BKLocalizedString(@"Script file could be recognized at the given location, please update your scripts menu.", nil),
						BKLocalizedString(@"OK", nil),
						nil,
						nil, @"");
		return NO;
	}
	
	return YES;
}

#pragma mark locate script files

- (NSString *)applicationScriptsFolderName {
    return [[[NSProcessInfo processInfo] processName] stringByAppendingString:@" Scripts"];
}

- (NSArray *)scriptFilePaths {
    NSMutableArray *scriptFilePaths = [NSMutableArray array];
    [self validScriptSubpathsFor:nil folders:nil scriptFiles:scriptFilePaths recurse:YES];
    return scriptFilePaths;
}

- (NSArray *)validScriptSubpathsFor:(NSString *)filePath {
    return [self validScriptSubpathsFor:filePath folders:nil scriptFiles:nil recurse:NO];
}

- (NSArray *)validScriptSubpathsFor:(NSString *)filePath folders:(NSMutableArray *)folders scriptFiles:(NSMutableArray *)scriptFiles recurse:(BOOL)recurse {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *subpaths = nil;
    BOOL isDirectory;
    
    if (filePath != nil) {
		if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
			NSArray *contents = [fileManager directoryContentsAtPath:filePath];
			NSEnumerator *enumerator = [contents objectEnumerator];
			id each;
			
			subpaths = [NSMutableArray arrayWithCapacity:[contents count]];
			
			while (each = [enumerator nextObject]) {
				each = [filePath stringByAppendingPathComponent:each];
				BOOL isScript = [self fileControllerFor:each] != nil;
				
				if ([fileManager fileExistsAtPath:each isDirectory:&isDirectory]) {
					if (isScript) {
						[subpaths addObject:each];
						[scriptFiles addObject:each];
					} else if (isDirectory) {
						[subpaths addObject:each];
						[folders addObject:each];
						
						if (recurse) {
							[self validScriptSubpathsFor:each folders:folders scriptFiles:scriptFiles recurse:YES];
						}
					}
				}
			}
		}
    } else { // root script location paths.
		subpaths = [NSMutableArray array];
		
		// paths for application and plugins
		NSMutableArray *possibleSubpaths = [NSMutableArray array];
		NSEnumerator *bundleEnumerator = [[NSBundle allBundles] objectEnumerator];
		id each;
		
		while (each = [bundleEnumerator nextObject]) {
			[possibleSubpaths addObject:[[[each bundlePath] stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Scripts"]];
		}
		
		// paths for search directories
		NSEnumerator *searchDirectoriesEnumerator = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask, YES) objectEnumerator];
		NSString *applicationScriptsFolderName = [self applicationScriptsFolderName];
		
		while (each = [searchDirectoriesEnumerator nextObject]) {
			each = [each stringByAppendingPathComponent:@"Scripts"];
			each = [each stringByAppendingPathComponent:applicationScriptsFolderName];
			[possibleSubpaths addObject:each];
		}
		
		// find scripts
		NSEnumerator *possibleSubpathsEnumerator = [possibleSubpaths objectEnumerator];
		
		while (each = [possibleSubpathsEnumerator nextObject]) {
			if ([fileManager fileExistsAtPath:each isDirectory:&isDirectory] && isDirectory) {
				[subpaths addObjectsFromArray:[self validScriptSubpathsFor:each folders:folders scriptFiles:scriptFiles recurse:recurse]];
			}
		}	
    }
    
    return subpaths;
}

#pragma mark commands

- (NSArray *)scriptFilesRespondingToCommand:(NSString *)command {
	NSMutableArray *result = [NSMutableArray array];
	NSEnumerator *enumerator = [[self scriptFilePaths] objectEnumerator];
	NSString *eachScript;
	
	while (eachScript = [enumerator nextObject]) {
		<BKScriptsFileControllerProtocol> fileTypeExtension = [self fileControllerFor:eachScript];
		if ([fileTypeExtension scriptFile:eachScript respondsToCommand:(NSString *)command]) {
			[result addObject:eachScript];
		}
	}
	
	return result;
}

- (NSArray *)scriptFilesPerformCommand:(NSString *)command withArguments:(NSArray *)arguments {
	NSMutableArray *results = [NSMutableArray array];
	NSEnumerator *enumerator = [[self scriptFilesRespondingToCommand:command] objectEnumerator];
	NSString *eachScript;

	while (eachScript = [enumerator nextObject]) {
		<BKScriptsFileControllerProtocol> fileTypeExtension = [self fileControllerFor:eachScript];
		NSDictionary *errorInfo = nil;
		id result = nil;
		
		if (![fileTypeExtension scriptFile:eachScript performCommand:(NSString *)command withArguments:arguments result:&result error:&errorInfo]) {
			logWarn(([NSString stringWithFormat:@"errors: %@ when sending message: %@ to scrip: %@", errorInfo, command, eachScript]));
		}

		if (!result) 
			result = [NSNull null];
		
		[results addObject:result];
	}
	
	return results;
}

#pragma mark delegate/datasource methods

// Note. Currently we manually build the script menu instead of dynamically build it by setting ourselves
// as the menu delegate. But we manually build it using the delegate methods bellow. The reason for this
// is that I can't get shortcut keys to work when dynamically building the menu.

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [item representedObject];
    NSString *title = [[path lastPathComponent] stringByDeletingPathExtension];
    BOOL isDirectory;
    
    NSArray *titleComponents = [title componentsSeparatedByString:@"___"];
    
    if ([titleComponents count] > 1) {
		unsigned int keyEquivalentModifierMask = 0;
		NSString *shortcut = [titleComponents lastObject];
		
		title = [titleComponents objectAtIndex:0];

		logAssert([title length] > 0, @"title is empty");
		logAssert([shortcut length] > 0, @"shortcut is empty");

		if ([shortcut rangeOfString:@"ctrl" options:NSCaseInsensitiveSearch].location != NSNotFound) {
			keyEquivalentModifierMask |= NSControlKeyMask;
		}
		
		if ([shortcut rangeOfString:@"opt" options:NSCaseInsensitiveSearch].location != NSNotFound ||
			[shortcut rangeOfString:@"alt" options:NSCaseInsensitiveSearch].location != NSNotFound) {
			
			keyEquivalentModifierMask |= NSAlternateKeyMask;
		}
		
		if ([shortcut rangeOfString:@"cmd" options:NSCaseInsensitiveSearch].location != NSNotFound) {
			keyEquivalentModifierMask |= NSCommandKeyMask;
		}
		
		if ([shortcut rangeOfString:@"shift" options:NSCaseInsensitiveSearch].location != NSNotFound) {
			keyEquivalentModifierMask |= NSShiftKeyMask;
		}
		
		shortcut = [shortcut substringFromIndex:[shortcut length] - 1];
		
		[item setKeyEquivalent:shortcut];
		[item setKeyEquivalentModifierMask:keyEquivalentModifierMask];
    }
    	
    [item setTitle:title];
    [item setAction:@selector(scriptMenuAction:)];
    [item setTarget:self];
    
    if ([fileManager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
		NSMenu *submenu = [[[NSMenu alloc] init] autorelease];
		[item setSubmenu:submenu];
		[submenu setDelegate:self];
    }
    
    return YES;
}

- (void)menuNeedsUpdate:(NSMenu *)menu {
    int index = 0;

	if (menu == [self scriptMenu]) {
		[[self menuItemForMenu:menu] setImage:[NSImage imageNamed:@"ScriptMenu" class:[self class]]];
		[menu removeAllItemsInNamedGroup:@"ScriptsGroup"];
		index = [menu rangeOfNamedGroup:@"ScriptGroup"].location + 1;
    } else {
		int count = [menu numberOfItems];
		while (count--) {
			[menu removeItemAtIndex:count];
		}
	}
    
    NSEnumerator *enumerator = [[self validScriptSubpathsFor:[[self menuItemForMenu:menu] representedObject]] objectEnumerator];
    id eachPath;
    
    while (eachPath = [enumerator nextObject]) {
		NSMenuItem *eachMenuItem = [[NSMenuItem alloc] init];
		[eachMenuItem setRepresentedObject:eachPath];
		[menu addItem:eachMenuItem];
		[self menu:menu updateItem:eachMenuItem atIndex:index shouldCancel:NO];	
		[eachMenuItem release];
		index++;
    }
}

- (int)numberOfItemsInMenu:(NSMenu *)menu {
    NSString *path = [[self menuItemForMenu:menu] representedObject];
    if (path == nil) {
		return [[self validScriptSubpathsFor:path] count] + 2;
    } else {
		return [[self validScriptSubpathsFor:path] count];
    }
}

- (BOOL)menuHasKeyEquivalent:(NSMenu *)menu forEvent:(NSEvent *)event target:(id *)target action:(SEL *)action {
    NSEnumerator *enumerator = [[menu itemArray] objectEnumerator];
    NSMenuItem *each;
    
    while (each = [enumerator nextObject]) {
		NSLog(@"menu: %i event: %i", [each keyEquivalentModifierMask], [event modifierFlags]);
		if ([each keyEquivalentModifierMask] == [event modifierFlags] &&
			[[each keyEquivalent] compare:[event characters] options:NSCaseInsensitiveSearch]) {
			
			*target = [each target];
			*action = [each action];
			
			return YES;
		}
    }
    
    return NO;
}

@end