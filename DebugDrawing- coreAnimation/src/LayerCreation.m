//
//  LayerCreation.m
//  DebugDrawing
//
//  Created by Steven Hooley on 7/2/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "LayerCreation.h"
#import "AbstractLayer.h"
#import "StarLayer.h"
#import "ColourUtilities.h"
#import "Graphic.h"
#import "ToolLayer.h"
#import "iAmTransformableProtocol.h"
#import "RootSelectedLayer.h"
#import "CALayerStarView.h"


@implementation LayerCreation

- (AbstractLayer *)makeRootSelectedLayerForNode:(SHNode *)node inView:(CALayerStarView *)starView {
	
	RootSelectedLayer *newLayer=[RootSelectedLayer layer];
    // What this means is "is this custom layer observing properties such as transform" in the original node?
    // we will need to modify this when we have more custom layers
	if([node isKindOfClass:[Graphic class]]) {
		CGColorRef bCol = [ColourUtilities newColorRef:0.0f :1.0f :1.0f :1.0f];
		newLayer.borderColor = bCol;
		CGColorRelease(bCol);
		newLayer.borderWidth = 2.0f;
        [newLayer setBounds: ((Graphic *)node).geometryRect];
	}
	[newLayer setAnchorPoint:CGPointMake(0.f, 0.f)];
	newLayer.name = [[node name] value];
	// never set this to yes
    newLayer.masksToBounds = NO;
	[newLayer setDelegate:node];
	[newLayer setContainerView:starView];
	return newLayer;
}


//- (AbstractLayer *)makeSelectedLayerForNode:(SHNode *)node {
//
//	SelectedLayer *newLayer=[SelectedLayer layer];
//    // What this means is "is this custom layer observing properties such as transform" in the original node?
//    // we will need to modify this when we have more custom layers
//	if([node isKindOfClass:[Graphic class]]) {
//		CGColorRef bCol = [ColourUtilities newColorRef:0.0 :1.0 :1.0 :1.0];
//		newLayer.borderColor = bCol;
//		CGColorRelease(bCol);
//		newLayer.borderWidth = 2.0;
//        [newLayer setBounds: ((Graphic *)node).geometryRect];
//	}
//	[newLayer setAnchorPoint:CGPointMake(0,0)];
//	newLayer.name = [[node name] value];
//	// never set this to yes
//    newLayer.masksToBounds = NO;
//	[newLayer setDelegate:node];
//
//	return newLayer;
//}

- (AbstractLayer *)makeChildLayerForNode:(SHNode *)node {

	AbstractLayer *newLayer;

	// What this means is "is this custom layer observing properties such as transform" in the original node? If it's a group layer it doesnt need an xform
	// we will need to modify this when we have more custom layers
	if([node isKindOfClass:[Graphic class]])
	{
		newLayer = [StarLayer layer];
		newLayer.backgroundColor = [ColourUtilities white];
		[newLayer setBounds:((Graphic *)node).geometryRect];
		[newLayer setAnchorPoint:CGPointMake(0,0)];
	} else {
		newLayer = [AbstractLayer layer];
	}
	newLayer.name = [[node name] value];
	// never set this to yes
	newLayer.masksToBounds = NO;
	[newLayer setDelegate:node];

	return newLayer;
}

- (AbstractLayer *)makeWidgetLayerForTool:(NSObject<Widget_protocol> *)tool {
	
	ToolLayer *widgetLayer = [ToolLayer layer];
	[widgetLayer setAnchorPoint:CGPointMake(0,0)];

	/* hmm, make the layer a little larger: is this needed? Maybe for selection marquee? */
//june09	widgetLayer.boundsBorder = 0.5;

	//	CGColorRef color = [ColourUtilities newColorRef:0.0f :0.0f :0.0f :1.0f];
	//CGColorRef borderColor = [ColourUtilities newColorRef:0.0 :1.0 :1.0 :1.0];
	//	    widgetLayer.shadowOpacity = 0.5;
	//	    widgetLayer.shadowOffset = CGSizeMake(4.0, 4.0);
	//	    widgetLayer.shadowRadius = 2.0;
	//	    widgetLayer.shadowColor = [ColourUtilities newColorRef:0.0 :0.0 :1.0 :1.0];
	//widgetLayer.borderColor = borderColor;
	//	widgetLayer.borderWidth = 1.0;
	
	//	CGColorRelease(color);
//	CGColorRelease(borderColor);
	
	//	[widgetLayer setBackgroundColor:[ColourUtilities white]];

	
	/* some things that may need setting */
	// [widgetLayer setBounds:CGRectMake(0, 0, 300, 300)];
	
	// [[_contentLayerManager containerLayer_temporary] setNeedsDisplay];
	// widgetLayer.needsDisplayOnBoundsChange = YES;
	
	[widgetLayer setDelegate:tool];
	return widgetLayer;
}

@end
