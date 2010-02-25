//
//  BKInspectorsProtocols.h
//  Blocks
//
//  Created by Jesse Grosjean on 7/22/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol BKInspectorPaletteContributerProtocol <NSObject>

- (NSView *)inspectorPaletteView;
- (void)willDisplayInspectorPalette;
- (NSString *)inspectorPaletteIdentifier;
- (NSImage *)inspectorPaletteIcon;
- (NSString *)inspectorPaletteTitle;
- (float)inspectorPaletteOrderWeight;

@end

@protocol BKInspectorPalettesControllerProtocol <NSObject>

- (IBAction)toggleShowInspectorPalettes:(id)sender;
- (IBAction)resetInspectorPaletteLocations:(id)sender;

@end
