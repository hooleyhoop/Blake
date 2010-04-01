//
//  ObjectPalettePlugin.h
//  BlakeLoader2
//
//  Created by steve hooley on 26/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//


@class ObjectPaletteWindowController;
@interface ObjectPalettePlugin : _ROOT_OBJECT_ <SHSingletonViewExtensionProtocol> {

	ObjectPaletteWindowController *_winController;
}

@property (retain, nonatomic) ObjectPaletteWindowController *winController;

+ (NSMenuItem *)menuItem;

@end
