//
//  SKTCircleTool.m
//  BlakeLoader2
//
//  Created by steve hooley on 03/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTCircleTool.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTCircle.h"


@implementation SKTCircleTool


- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTCircleTool";
		_labelString = @"Circle";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"CircleToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {

	[item setToolTip:@"Circle"];
	[super setUpToolbarItem:item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {

	// Create a new graphic and then track to size it.
	Class graphicClassToInstantiate = [SKTCircle class];
	[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inSketchView:view];
}

@end
