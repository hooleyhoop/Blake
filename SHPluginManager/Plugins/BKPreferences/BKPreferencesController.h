//
//  BKPreferencesController.h
//  Blocks
//
//  Created by Jesse Grosjean on 1/7/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>
#import "BKPreferencesProtocols.h"


@interface BKPreferencesController : NSWindowController <BKPreferencePaneControllerProtocol> {
    IBOutlet NSView *loadingView;
	IBOutlet NSTextField *loadingTextField;
    
    NSToolbar *fToolbar;
    NSMutableArray *fPreferencePaneIdentifiers;
    NSMutableDictionary *fPreferencePaneDataSources;
    id <BKPreferencePaneProtocol> fSelectedPreferencePaneExtension;
    BOOL fAnimateResize;
}

#pragma mark class methods

+ (id)sharedInstance;

#pragma mark accessors

- (NSString *)selectedPaneIdentifier;
- (void)setSelectedPaneIdentifier:(NSString *)paneIdentifier;
- (NSArray *)paneIdentifiers;

@end
