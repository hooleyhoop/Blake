//
//  BKPluginPreferencePaneExtension.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/27/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKApplicationProtocols.h"
#import "BKUserInterfaceProtocols.h"
#import "BKConfigurationProtocols.h"
#import "BKPreferencesProtocols.h"


@interface BKPluginPreferencePaneExtension : NSObject <BKPreferencePaneProtocol> {
    IBOutlet NSView *view;
	IBOutlet NSTextField *messageTextField;
	IBOutlet NSOutlineView *outlineView;
	
	NSMutableDictionary *fCatagoriesCatches;
}

- (NSView *)view;
- (BKPlugin *)selectedPlugin;

#pragma mark actions

- (IBAction)openPluginsFolder:(id)sender;
- (IBAction)findScriptsAndPlugins:(id)sender;
- (IBAction)viewXML:(id)sender;
- (IBAction)viewProtocols:(id)sender;
- (IBAction)revealInFinder:(id)sender;
- (IBAction)extend:(id)sender;
- (IBAction)showMenuConfiguration:(id)sender;

@end