//
//  WidgetDisplay.m
//  DebugDrawing
//
//  Created by steve hooley on 23/06/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "WidgetDisplay.h"
#import "ContentLayerManager.h"
#import "ToolLayer.h"
#import "ColourUtilities.h"
#import "LayerCreation.h"


@implementation WidgetDisplay

@synthesize targetView = _targetView;

- (id)initWithContentLayerManager:(ContentLayerManager *)value1 layerCreator:(LayerCreation *)iMakeLayers {
	
	self = [super init];
	if(self){
		
	    /* all widgets are drawn into contentLayer */
		_contentLayerManager = [value1 retain];
		_layerMaker = [iMakeLayers retain];
		_widgets = [[NSMutableArray array] retain];
	}
	return self;
}

- (void)dealloc {

	[_contentLayerManager release];
	[_widgets release];
	[_layerMaker release];
	[super dealloc];
}

- (void)addWidget:(NSObject<Widget_protocol> *)value {
	
	NSParameterAssert(value);
	NSAssert(_contentLayerManager, @"widget renderer not setup correctly");
	
	AbstractLayer *existingWidgetLayer = [_contentLayerManager lookupLayerForKey:value];
	NSAssert(existingWidgetLayer==nil, @"eh?");

	// this creates a new tool layer if it doesn't exist
	AbstractLayer *widgetLayer = [_layerMaker makeWidgetLayerForTool: value];
	[_contentLayerManager insertSublayer:widgetLayer atIndex:0 inParentLayer:[_contentLayerManager containerLayer_temporary]];

	[_widgets addObject:value];
}

- (void)removeWidget:(NSObject<Widget_protocol> *)value {
	
	AbstractLayer *existingWidgetLayer = [_contentLayerManager lookupLayerForKey:value];
	NSAssert(existingWidgetLayer!=nil, @"eh?");

	[_contentLayerManager removeSubLayerFromParent:existingWidgetLayer];
	existingWidgetLayer.delegate = nil;
	
	[_widgets removeObject:value];
}

- (void)graphDidUpdate {
	
	for(id<Widget_protocol> each in _widgets){
		NSAssert([each conformsToProtocol:@protocol(Widget_protocol)], @"yikes");
		[each enforceConsistentState];
	}
}

@end
