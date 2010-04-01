//
//  ToolViewController.h
//  DebugDrawing
//
//  Created by steve hooley on 15/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "MouseInputAdaptorProtocol.h"
#import "EditingToolProtocol.h"
#import "iAmTransformableProtocol.h"
#import "Widget_protocol.h"

@class ToolBarController, SHNode, LayerFamiliar;
@protocol EditingToolProtocol, EditingToolIconProtocol, Widget_protocol;

@interface ToolViewController : _ROOT_OBJECT_ <Widget_protocol, EditingToolIconProtocol, MouseInputAdaptorProtocol> {

	NSString							*_labelString;
	NSString							*_iconPath;
	ToolBarController					*_toolBarControl;

	CGPoint								_mouseDownPtInSceneSpace;
	NSPoint								_mouseDownPtInViewSpace;
	
	LayerFamiliar						*_layerFamiliar;

	NSObject<EditingToolProtocol>		*_tool;
}

@property (readonly) LayerFamiliar *layerFamiliar;
//@property (readonly) SHNode *mouseDownObject;

- (id)initWithToolBarController:(ToolBarController *)controller domainTool:(NSObject<EditingToolProtocol> *)tool;

- (NSCursor *)defaultToolCursor;

- (CGRect)didDrawAt:(CGContextRef)cntx;
- (void)_setupDrawing:(CGContextRef)cntx;
- (void)_tearDownDrawing:(CGContextRef)cntx;

- (void)setWidgetBounds:(CGRect)value;
- (void)setWidgetOrigin:(CGPoint)value;

- (CGRect)geometryRect;
- (CGAffineTransform)transformMatrix;

@end
