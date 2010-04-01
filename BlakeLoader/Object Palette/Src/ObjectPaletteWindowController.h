//
//  ObjectPaletteWindowController.h
//  BlakeLoader2
//
//  Created by steve hooley on 26/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import <SHShared/SHWindowController.h>

@class ObjectBrowserViewController;

@interface ObjectPaletteWindowController : SHWindowController {

	ObjectBrowserViewController *_browserViewController;
	
	IBOutlet NSView *_contentView;
}

+ (NSString *)nibName;

- (void)initBindings;
- (void)unBind;

@end
