//
//  SKTTextTool.m
//  BlakeLoader2
//
//  Created by steve hooley on 03/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTTextTool.h"
#import "SKTText.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"

@implementation SKTTextTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTTextTool";
		_labelString = @"Text";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"TextToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {
	
	[item setToolTip:@"Text"];
	[super setUpToolbarItem:item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {

	// Create a new graphic and then track to size it.
	Class graphicClassToInstantiate = [SKTText class];
	[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inSketchView:view];
}

@end
