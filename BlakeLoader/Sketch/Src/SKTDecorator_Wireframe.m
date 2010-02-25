//
//  SKTDecorator_Wireframe.m
//  BlakeLoader2
//
//  Created by steve hooley on 18/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTDecorator_Wireframe.h"

@implementation SKTDecorator_Wireframe

- (void)drawContentsInView:(NSView *)view preferredRepresentation:(enum SKTGraphicDrawingMode)preferredRepresentation {
	
	[_originalGraphic drawContentsInView:view preferredRepresentation:SKTGraphicWireframe];
}

@end
