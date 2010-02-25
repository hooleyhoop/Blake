//
//  ToolBarController.h
//  DebugDrawing
//
//  Created by steve hooley on 21/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//
@class Tool, EditingViewController, HitTester, SHNode, StarScene, WidgetDisplay, CALayerStarView;
@protocol EditingToolIconProtocol, Widget_protocol;

//september09 @protocol Widget_protocol;

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface ToolBarController : _ROOT_OBJECT_ {
#else
@interface ToolBarController : _ROOT_OBJECT_ <NSToolbarDelegate> {
#endif

	NSToolbar							*_toolBar;
    EditingViewController				*_targetViewController;
	NSWindow							*_window;
	
	// you can look up a rep from an identifier using _toolRepsAndKeys
	// you can then use this as a key in _toolsAndToolRepresentations to get the domainTool
	NSMutableDictionary					*_toolRepsAndKeys;
	NSMapTable							*_toolsAndToolRepresentations;
	NSMutableArray						*_orderedTools;
	
	_ROOT_OBJECT_<EditingToolIconProtocol>	*_activeToolRepresentation;
	
	// hacky zoom, pan overide stuff
	NSString							*_hijackedToolRep, *_temporarySwappedInTool;
	BOOL								_isAboutToSwapIn;
	BOOL								_altDown, _shiftDown;
	
//september09	StarScene *_scene;
//september09	WidgetDisplay *_renderer;
}

@property (readonly, assign) EditingViewController *targetViewController;
// @property (readonly) NSObject<EditingToolIconProtocol> *defaultToolRepresentation;
@property (readwrite, assign) _ROOT_OBJECT_<EditingToolIconProtocol> *activeToolRepresentation;

- (id)initWithWindow:(NSWindow *)win targetViewController:(id)viewController;
- (void)cleanUp;

//september09- (void)hitTestTool:(Tool *)aTool atPoint:(NSPoint)apoint pixelColours:(unsigned char *)pixelColours;	

//september09- (StarScene *)sceneUndermanipulation;
- (void)addTools:(NSArray *)tools;
- (NSArray *)toolKeys;
- (void)addToolbarToWindow;

- (void)addWidgetToView:(NSObject<Widget_protocol> *)value;
- (void)removeWidgetFromView:(NSObject<Widget_protocol> *)value;

- (void)applyKeysDown;
- (void)unApplyKeysDown;

- (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;

- (void)shift:(BOOL)value;
- (void)alt:(BOOL)value;

- (void)swapInTool:(NSString *)value;

- (NSPoint)eventPtToViewPoint:(NSPoint)pt;
- (CGPoint)eventPointToContentPoint:(NSPoint)pt;
- (CGPoint)viewPointToScenePoint:(NSPoint)pt;

@end
