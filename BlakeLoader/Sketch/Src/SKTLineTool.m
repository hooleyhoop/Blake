//
//  SKTLineTool.m
//  BlakeLoader2
//
//  Created by steve hooley on 03/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTLineTool.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTLine.h"


@implementation SKTLineTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTLineTool";
		_labelString = @"Line";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"LineToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {

	[item setToolTip:@"Line"];
	[super setUpToolbarItem: item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {

	// Create a new graphic and then track to size it.
	Class graphicClassToInstantiate = [SKTLine class];
	[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inSketchView:view];
}

@end
