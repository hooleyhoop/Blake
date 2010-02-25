//
//  RootSelectedLayer.h
//  DebugDrawing
//
//  Created by steve hooley on 28/08/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "AbstractLayer.h"
#import "GraphicLayer.h"

@class CALayerStarView;


@interface RootSelectedLayer : AbstractLayer {

	CALayerStarView	*_containerView;
	BOOL			_needsRealculating;
}

@property (readwrite, assign) CALayerStarView *containerView;

- (void)enforceConsistentState;

@end
