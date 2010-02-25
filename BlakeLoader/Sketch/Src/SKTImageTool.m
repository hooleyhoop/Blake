//
//  SKTImageTool.m
//  BlakeLoader2
//
//  Created by steve hooley on 03/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTImageTool.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTImage.h"


@implementation SKTImageTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTImageTool";
		_labelString = @"Image";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"ImageToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {

	[item setToolTip:@"Image"];
	[super setUpToolbarItem: item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {

	// Create a new graphic and then track to size it.
	Class graphicClassToInstantiate = [SKTImage class];
	[self createGraphicOfClass:graphicClassToInstantiate withEvent:event inSketchView:view];
}

@end
