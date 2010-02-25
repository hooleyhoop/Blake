//  BigBrowserView.h Copyright (c) 2001-2004 Philippe Mougin.
//  This software is open source. See the license.

//#import "build_config.h"

#ifdef BUILD_WITH_APPKIT

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class FSInterpreter;


@interface BigBrowserView : NSView 
{
  id              rootObject;
  FSInterpreter * interpreter;
  NSBrowser *     browser;
  NSTextField *   statusBar;
  BOOL            isBrowsingWorkspace;
  NSView *        selectedView;
  NSString *      methodFilterString;
  NSMutableSet *  matrixes;
}

+ (NSArray *)customButtons;
+ (void)saveCustomButtonsSettings;

-(void) browseWorkspace;
-(void) filterAction:(id)sender;
-(id) initWithFrame:(NSRect)frameRect;
-(id) selectedObject;
-(void) setInterpreter:(FSInterpreter *)theInterpreter;
-(void) setRootObject:(id)theRootObject;
@end

#endif
