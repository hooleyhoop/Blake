//
//  SKTGroup.m
//  BlakeLoader2
//
//  Created by steve hooley on 02/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTGroup.h"


@implementation SKTGroup

- (void)dealloc {
	[_groupedSceneItems release];
	[super dealloc];
}

- (void)drawContentsInView:(NSView *)view withPreferredStyle:(int)preferredRepresentation {

	//-- apply transform
	
	for( SKTGraphic *eachGraphic in _groupedSceneItems ){
		[eachGraphic drawContentsInView:view withPreferredStyle:preferredRepresentation];
	}
	
	//-- pop transform
}

- (void)addSceneItems:(NSArray *)value {
	
	if(!_groupedSceneItems)
		_groupedSceneItems = [[NSMutableArray array] retain];
	[_groupedSceneItems addObjectsFromArray:value];
}

- (NSArray *)groupedSceneItems {
	return _groupedSceneItems;
}

#warning bounds will be used to move the group.. cock fuck
- (NSRect)bounds {
	return [SKTGraphic boundsOfGraphics:_groupedSceneItems]; 
}

//- (void)setBounds:(NSRect)bounds {
//	
//    // Simple.
//    _bounds = bounds;
//	
//}
- (NSRect)drawingBounds {
	return [SKTGraphic drawingBoundsOfGraphics:_groupedSceneItems]; 
}

- (CGFloat)xPosition {
    return [self bounds].origin.x;
}
- (CGFloat)yPosition {
    return [self bounds].origin.y;
}
- (CGFloat)width {
    return [self bounds].size.width;
}
- (CGFloat)height {
    return [self bounds].size.height;
}
//- (void)setXPosition:(CGFloat)xPosition {
//    NSRect bounds = [self bounds];
//    bounds.origin.x = xPosition;
//    [self setBounds:bounds];
//}
//- (void)setYPosition:(CGFloat)yPosition {
//    NSRect bounds = [self bounds];
//    bounds.origin.y = yPosition;
//    [self setBounds:bounds];
//}
//- (void)setWidth:(CGFloat)width {
//    NSRect bounds = [self bounds];
//    bounds.size.width = width;
//    [self setBounds:bounds];
//}
//- (void)setHeight:(CGFloat)height {
//    NSRect bounds = [self bounds];
//    bounds.size.height = height;
//    [self setBounds:bounds];
//}


- (BOOL)canSetDrawingFill {
	return NO;
}

- (BOOL)canSetDrawingStroke {
    return NO;
}

- (BOOL)canMakeNaturalSize {
    return NO;
}

@end
