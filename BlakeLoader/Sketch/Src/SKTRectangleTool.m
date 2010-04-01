//
//  SKTRectangleTool.m
//  BlakeLoader2
//
//  Created by steve hooley on 03/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTRectangleTool.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTRectangle.h"


@implementation SKTRectangleTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTRectTool";
		_labelString = @"Rect";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"RectangleToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {

	[item setToolTip:@"Rectangle"];
	[super setUpToolbarItem:item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {

	// Create a new graphic and then track to size it.
	Class graphicClassToInstantiate = [SKTRectangle class];
	[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inSketchView:view];
}

@end
