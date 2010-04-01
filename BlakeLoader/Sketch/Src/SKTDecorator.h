//
//  SKTDecorator.h
//  BlakeLoader2
//
//  Created by steve hooley on 18/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class SKTGraphic;

@interface SKTDecorator : SHooleyObject {

	SKTGraphic		*_originalGraphic;
}

@property (retain, readwrite, nonatomic) SKTGraphic *originalGraphic;

+ (id)decoratorForGraphic:(SKTGraphic *)aGraphic;

- (void)drawHandleInView:(NSView *)view atPoint:(NSPoint)point;

@end
