//
//  StarView.h
//  DebugDrawing
//
//  Created by steve hooley on 23/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "DrawDestination_protocol.h"
#import "Widget_protocol.h"

@class SHNode;
@class StarScene, NodeProxy;

@protocol iManageDrawableNodes <NSObject>

- (SHNode *)currentNodeGroup;

@end


@interface StarView : NSView <DrawDestination_protocol> {
	
	NSObject <iManageDrawableNodes>* _starScene;	
}

//- (void)setNeedsDisplayInRects:(NSArray *)rects;
//- (void)graphic:(id)obj drewAt:(NSRect)dst;

@end
