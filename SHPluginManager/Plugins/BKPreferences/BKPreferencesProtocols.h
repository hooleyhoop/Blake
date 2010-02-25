/*
 *  BKPreferencesProtocols.h
 *  Blocks
 *
 *  Created by Jesse Grosjean on 2/2/05.
 *  Copyright 2006 Hog Bay Software Hog Bay Software. All rights reserved.
 *
 */

@protocol BKPreferencePaneProtocol <NSObject>

- (NSView *)preferencePaneView;
- (void)willDisplayPreferencePane;
- (NSString *)preferencePaneTooltip;
- (NSImage *)preferencePaneImage;
- (NSString *)preferencePaneIdentifier;
- (NSString *)preferencePaneTitle;
- (NSString *)preferencePaneLabel;
- (float)preferencePaneOrderWeight;

@end

@protocol BKPreferencePaneControllerProtocol <NSObject>

- (NSString *)selectedPaneIdentifier;
- (void)setSelectedPaneIdentifier:(NSString *)paneIdentifier;
- (NSArray *)paneIdentifiers;

@end

@interface NSApplication (BKPreferencePaneControllerAccess)
- (id <BKPreferencePaneControllerProtocol>)BKPreferencesProtocols_preferencesController; // exposed this way for applescript support
@end

