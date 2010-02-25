//
//  BKInspectorPalettesController.h
//  Blocks
//
//  Created by Jesse Grosjean on 12/2/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKInspectorsProtocols.h"


@class KBPalettePanel;

@interface BKInspectorPalettesController : NSObject <BKInspectorPalettesControllerProtocol> {
	NSArray *inspectorPaletteExtensions;
	NSMutableDictionary *contributerForIdentifier;
	NSMutableDictionary *contributerForPalette;
	NSMutableDictionary *paletteForContributer;
	NSMutableSet *temporaryHiddenPalettes;
	NSDictionary *visibleConfigurationDictionary;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark pane visibility

- (IBAction)toggleShowInspectorPalettes:(id)sender;
- (IBAction)resetInspectorPaletteLocations:(id)sender;
- (NSArray *)visiblePalettes;

#pragma mark configuration

- (NSDictionary *)configurationDictionary;
- (void)setConfigurationFromDictionary:(NSDictionary *)configurationDictionary;

#pragma mark extensions

- (KBPalettePanel *)paletteForContributer:(id <BKInspectorPaletteContributerProtocol>)contributer;
- (id <BKInspectorPaletteContributerProtocol>)contributerForPalette:(KBPalettePanel *)palette;
- (id <BKInspectorPaletteContributerProtocol>)contributerForIdentifier:(NSString *)identifier;
- (NSArray *)inspectorPaletteExtensions;

@end
