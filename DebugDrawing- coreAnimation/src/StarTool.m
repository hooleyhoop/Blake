//
//  StarTool.m
//  DebugDrawing
//
//  Created by steve hooley on 15/12/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StarTool.h"


@implementation StarTool

- (id)initWithToolBarController:(ToolBarController *)value
{
	self = [super initWithToolBarController:value];
	if ( self ) {
		_identifier = @"SKTStarTool";
		_labelString = @"Star";
		_iconPath = [[NSBundle bundleForClass:[self class ]] pathForImageResource:@"ArrowToolIcn"];
	}
	return self;
}


@end
