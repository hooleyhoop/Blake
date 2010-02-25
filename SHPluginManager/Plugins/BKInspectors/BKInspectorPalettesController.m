//
//  BKInspectorPalettesController.m
//  Blocks
//
//  Created by Jesse Grosjean on 12/2/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKInspectorPalettesController.h"
#import "KBPalettePanel.h"


@implementation BKInspectorPalettesController

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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
		contributerForIdentifier = [[NSMutableDictionary alloc] init];
		contributerForPalette = [[NSMutableDictionary alloc] init];
		paletteForContributer = [[NSMutableDictionary alloc] init];
		temporaryHiddenPalettes = [[NSMutableSet alloc] init];
	}
	return self;
}

#pragma mark dealloc

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[inspectorPaletteExtensions release];
	[contributerForIdentifier release];
	[paletteForContributer release];
	[contributerForPalette release];
	[temporaryHiddenPalettes release];
	[visibleConfigurationDictionary release];
	[super dealloc];
}

#pragma mark notifications

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[[NSUserDefaults standardUserDefaults] setObject:[self configurationDictionary] forKey:@"BKInspectorsConfiguration"];
}

#pragma mark pane visibility

- (IBAction)toggleShowInspectorPalettes:(id)sender {
	NSArray *visiblePalettes = [self visiblePalettes];

	if ([visiblePalettes count] > 0) {
		[visibleConfigurationDictionary release];
		visibleConfigurationDictionary = [[self configurationDictionary] copy];
		
		NSEnumerator *visiblePaletteEnumerator = [visiblePalettes objectEnumerator];
		KBPalettePanel *eachVisiblePalette;
		
		while (eachVisiblePalette = [visiblePaletteEnumerator nextObject]) {
			//if ([eachVisiblePalette firstPaletteInGroup] == eachVisiblePalette) {
			//	[temporaryHiddenPalettes addObject:eachVisiblePalette];
				[eachVisiblePalette orderOut:nil];
			//}
		}
	} else if (visibleConfigurationDictionary) {
//		NSEnumerator *temmporaryHiddenPaletteEnumerator = [temporaryHiddenPalettes objectEnumerator];
//		KBPalettePanel *eachTemporaryHiddenPalette;
		
//		while (eachTemporaryHiddenPalette = [temmporaryHiddenPaletteEnumerator nextObject]) {
			//[eachTemporaryHiddenPalette orderFront:nil];
//			[eachTemporaryHiddenPalette setGroupVisible:YES];
//		}
		
//		[temporaryHiddenPalettes removeAllObjects];
		[self setConfigurationFromDictionary:visibleConfigurationDictionary];
		[visibleConfigurationDictionary release];
		visibleConfigurationDictionary = nil;
	} else {		
		NSDictionary *configurationDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"BKInspectorsConfiguration"];
		[self setConfigurationFromDictionary:configurationDictionary];
		
		NSEnumerator *inspectorPaletteExtensionEnumerator = [[self inspectorPaletteExtensions] objectEnumerator];
		BKExtension *eachExpectorContributerExtension;
		
		while (eachExpectorContributerExtension = [inspectorPaletteExtensionEnumerator nextObject]) {
			KBPalettePanel *palette = [self paletteForContributer:[eachExpectorContributerExtension extensionInstance]];
			[palette orderFront:nil];
		}
	}
}

- (IBAction)resetInspectorPaletteLocations:(id)sender {
	NSEnumerator *enumerator = [[self inspectorPaletteExtensions] objectEnumerator];
	BKExtension *eachExpectorContributerExtension;
	
	while (eachExpectorContributerExtension = [enumerator nextObject]) {
		KBPalettePanel *palette = [self paletteForContributer:[eachExpectorContributerExtension extensionInstance]];
		[palette orderFront:nil];
	}
}

- (NSArray *)visiblePalettes {
	NSMutableArray *visiblePalettes = [NSMutableArray array];
	NSEnumerator *loadedPaletteEnumerator = [paletteForContributer objectEnumerator];
	KBPalettePanel *eachPalette;
	
	while (eachPalette = [loadedPaletteEnumerator nextObject]) {
		if ([eachPalette isVisible]) {
			[visiblePalettes addObject:eachPalette];
		}
	}
	
	return visiblePalettes;
}

#pragma mark configuration

- (NSDictionary *)configurationDictionary {
	NSMutableDictionary *paletteGroups = [NSMutableDictionary dictionary];
	NSMutableDictionary *paletteConfigurations = [NSMutableDictionary dictionary];
	NSEnumerator *paletteEnumerator = [paletteForContributer objectEnumerator];
	KBPalettePanel *eachPalette;
	
	while (eachPalette = [paletteEnumerator nextObject]) {
		[paletteConfigurations setObject:[eachPalette configurationDictionary] forKey:[[self contributerForPalette:eachPalette] inspectorPaletteIdentifier]];
		
		NSMutableArray *palettesInGroup = [NSMutableArray array];
		KBPalettePanel *firstPaletteInGroup = [eachPalette firstPaletteInGroup];
		
		if (eachPalette == firstPaletteInGroup) {
			NSEnumerator *paletteGroupEnumerator = [[firstPaletteInGroup attachedPalettes] objectEnumerator];
			KBPalettePanel *eachPaletteInGroup;
			
			while (eachPaletteInGroup = [paletteGroupEnumerator nextObject]) {
				[palettesInGroup addObject:[[self contributerForPalette:eachPaletteInGroup] inspectorPaletteIdentifier]];
			}
			
			[paletteGroups setObject:palettesInGroup forKey:[[self contributerForPalette:firstPaletteInGroup] inspectorPaletteIdentifier]];
		}
	}
	
	NSMutableDictionary *inspectorsControllerConfiguration = [NSMutableDictionary dictionary];
	[inspectorsControllerConfiguration setObject:paletteGroups forKey:@"paletteGroups"];
	[inspectorsControllerConfiguration setObject:paletteConfigurations forKey:@"paletteConfigurations"];
	return inspectorsControllerConfiguration;
}

- (void)setConfigurationFromDictionary:(NSDictionary *)configurationDictionary {
	NSDictionary *paletteGroups = [configurationDictionary objectForKey:@"paletteGroups"];
	NSDictionary *paletteConfigurations = [configurationDictionary objectForKey:@"paletteConfigurations"];
	NSEnumerator *paletteGroupsEnumerator = [paletteGroups keyEnumerator];
	id eachGroupIdentifier;
	
	while (eachGroupIdentifier = [paletteGroupsEnumerator nextObject]) {
		NSArray *eachGroupIdentifiers = [paletteGroups objectForKey:eachGroupIdentifier];
		
		KBPalettePanel *lastPaletteInGroup = [self paletteForContributer:[self contributerForIdentifier:eachGroupIdentifier]];
		[lastPaletteInGroup setConfigurationFromDictionary:[paletteConfigurations objectForKey:eachGroupIdentifier]];
		[lastPaletteInGroup orderFront:nil];

		NSEnumerator *groupEnumerator = [eachGroupIdentifiers objectEnumerator];
		id eachIdentifier;
		
		while (eachIdentifier = [groupEnumerator nextObject]) {
			KBPalettePanel *eachPaletteInGroup = [self paletteForContributer:[self contributerForIdentifier:eachIdentifier]];
			[eachPaletteInGroup setConfigurationFromDictionary:[paletteConfigurations objectForKey:eachIdentifier]];
			[eachPaletteInGroup orderFront:nil];
			[eachPaletteInGroup attachToPalette:lastPaletteInGroup];
			lastPaletteInGroup = eachPaletteInGroup;
		}		
	}
}

#pragma mark extensions

- (id <BKInspectorPaletteContributerProtocol>)contributerForPalette:(KBPalettePanel *)palette {
	NSValue *key = [NSValue valueWithPointer:palette];
	id <BKInspectorPaletteContributerProtocol> contributer = [contributerForPalette objectForKey:key];
	
	if (!contributer) {
		NSEnumerator *enumerator = [[self inspectorPaletteExtensions] objectEnumerator];
		id each;
		
		while (each = [[enumerator nextObject] extensionInstance]) {
			KBPalettePanel *eachPalette = [self paletteForContributer:each];
			
			if (eachPalette == palette) {
				[contributerForPalette setObject:each forKey:key];
				return each;
			}
		}
	}
	
	return contributer;
}

- (KBPalettePanel *)paletteForContributer:(id <BKInspectorPaletteContributerProtocol>)contributer {
	NSValue *key = [NSValue valueWithPointer:contributer];
	KBPalettePanel *palettePanel = [paletteForContributer objectForKey:key];
	
	if (!palettePanel) {
		NSView *inspectorPaletteView = [contributer inspectorPaletteView];
		palettePanel = [[[KBPalettePanel alloc] initWithContentRect:[inspectorPaletteView frame] styleMask:NSUtilityWindowMask backing:NSBackingStoreBuffered defer:YES] autorelease];
		[palettePanel setContentView:inspectorPaletteView];
		[palettePanel awakeFromNib];
		[palettePanel setIcon:[contributer inspectorPaletteIcon]];
		[palettePanel setTitle:[contributer inspectorPaletteTitle]];
//		[palettePanel setConfigurationFromDictionary:[[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"BKInspectorsConfiguration.paletteConfigurations"] objectForKey:[contributer inspectorPaletteIdentifier]]];
		[contributerForIdentifier setObject:contributer forKey:[contributer inspectorPaletteIdentifier]];
		[paletteForContributer setObject:palettePanel forKey:key];
	}
	
	return palettePanel;
}

- (id <BKInspectorPaletteContributerProtocol>)contributerForIdentifier:(NSString *)identfier {
	id <BKInspectorPaletteContributerProtocol> contributer = [contributerForIdentifier objectForKey:identfier];
	
	if (!contributer) {
		NSEnumerator *enumerator = [[self inspectorPaletteExtensions] objectEnumerator];
		BKExtension *eachInspectorContributerExtension;
		
		while (eachInspectorContributerExtension = [enumerator nextObject]) {
			id <BKInspectorPaletteContributerProtocol> eachInspectorPaletteContributer = [eachInspectorContributerExtension extensionInstance];
			
			if ([[eachInspectorPaletteContributer inspectorPaletteIdentifier] isEqualToString:identfier]) {
				[contributerForIdentifier setObject:eachInspectorPaletteContributer forKey:identfier];
				return eachInspectorPaletteContributer;
			}
		}
	}
	
	return contributer;
}

- (NSArray *)inspectorPaletteExtensions {
	if (inspectorPaletteExtensions == nil) {
		BKPluginRegistry *pluginRegistery = [BKPluginRegistry sharedInstance];
		NSArray *sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"extensionInstance.inspectorPaletteOrderWeight" ascending:YES] autorelease]];
		NSArray *sortedInspectorPaletteExtensions = nil;
		
		inspectorPaletteExtensions = [pluginRegistery loadedValidOrderedExtensionsFor:@"uk.co.stevehooley.BKInspectors.inspectorpalette" protocol:@protocol(BKInspectorPaletteContributerProtocol)];
		
		@try {
			sortedInspectorPaletteExtensions = [inspectorPaletteExtensions sortedArrayUsingDescriptors:sortDescriptors];
		} @catch (NSException *exception) {
			sortedInspectorPaletteExtensions = inspectorPaletteExtensions;
		}

		inspectorPaletteExtensions = [sortedInspectorPaletteExtensions retain];
	}
	
	return inspectorPaletteExtensions;
}

@end
