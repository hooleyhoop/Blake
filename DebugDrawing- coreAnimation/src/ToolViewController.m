//
//  ToolViewController.m
//  DebugDrawing
//
//  Created by steve hooley on 15/09/2009.
//  Copyright 2009 BestBefore Ltd. All rights reserved.
//

#import "ToolViewController.h"
#import "ToolBarController.h"
#import "Tool.h"
#import "EditingToolProtocol.h"
#import "Widget_protocol.h"
#import "CALayerStarView.h"
#import "EditingViewController.h"
#import "LayerFamiliar.h"
//#import "MiscUtilities.h"

@interface ToolViewController ()
- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view;
@end

@implementation ToolViewController

@synthesize layerFamiliar=_layerFamiliar;

- (id)initWithToolBarController:(ToolBarController *)controller domainTool:(NSObject<EditingToolProtocol> *)tool {
	
	self = [super init];
	if ( self ) {
		_toolBarControl = controller;
		_tool = tool;
		_layerFamiliar = [[LayerFamiliar alloc] init];
	}
	return self;
}

- (void)dealloc {

	[_layerFamiliar release];
	[super dealloc];
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {
	
	[item setToolTip:_labelString];
	[item setLabel:_labelString];
	[item setPaletteLabel:_labelString];
	
	NSImage *iconImg = [[[NSImage alloc] initWithContentsOfFile: _iconPath] autorelease];
	[item setImage: iconImg];
	
	[item setTarget:self];
	[item setAction:@selector(selectToolAction:)];
}

/* graphDidUpdate - Required by protocol */
- (void)enforceConsistentState {
	
	[_layerFamiliar enforceConsistentState];
}

/* This is the toolbar-item's action */
- (IBAction)selectToolAction:(id)sender {
	
	NSAssert( _layerFamiliar, @"doh" );

	[_toolBarControl setActiveToolRepresentation: self];	
	[[self defaultToolCursor] set];
}

- (void)toolWillBecomeActive {

//october2009	[_tool selectToolAction:nil];
	
	[_layerFamiliar enforceConsistentState];
	NSAssert1( CGRectEqualToRect( [self geometryRect], CGRectZero), @"failed to clean up geometry rect? %@", NSStringFromCGRect( [self geometryRect] ) );
}

- (void)toolWillBecomeUnActive {
	
//october2009		[_tool toolWillBecomeUnActive];
	NSAssert( CGRectEqualToRect([self geometryRect], CGRectZero), @"failed to clean up geometry rect?" );
}

// redirect observers
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

	if([keyPath isEqualToString:@"transformMatrix"] || [keyPath isEqualToString:@"geometryRect"])
			[_layerFamiliar addObserver:observer forKeyPath:keyPath options:options context:context];
	else
		[NSException raise:@"what else are we observing?" format:@"%@", keyPath];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {

	if([keyPath isEqualToString:@"transformMatrix"] || [keyPath isEqualToString:@"geometryRect"])
		[_layerFamiliar removeObserver:observer forKeyPath:keyPath];
	else
[NSException raise:@"what else are we observing?" format:@"%@", keyPath];
}

- (void)_mouseDownEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
	NSParameterAssert(event && view);
	
	_mouseDownPtInViewSpace = [_toolBarControl eventPtToViewPoint:[event locationInWindow]];	
	_mouseDownPtInSceneSpace = [_toolBarControl eventPointToContentPoint:[event locationInWindow]];
	
	[self trackMouseDragWithEvent:event inStarView:view];
}

- (void)mouseUpAtPoint:(NSPoint)pt {

	_mouseDownPtInViewSpace = NSZeroPoint;
	_mouseDownPtInSceneSpace = CGPointZero;
}

- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
	
}

//TODO: I'm certain we should be using tracking rects for cursors
- (NSCursor *)defaultToolCursor {
	
	return [NSCursor arrowCursor];
}

- (void)setWidgetBounds:(CGRect)value {
	
	[self setGeometryRect: value];
}

- (void)setWidgetOrigin:(CGPoint)value {
	
	[_layerFamiliar setPosition:value];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey :(NSString *)key {
	return (id<CAAction>)[NSNull null];
}

/* Return the geometry rect multiplied by the contexts affineXform */
- (CGRect)didDrawAt:(CGContextRef)cntx {
	return 	[_layerFamiliar didDrawAt:cntx];
}

- (void)_setupDrawing:(CGContextRef)cntx {
	[_layerFamiliar applyMatrixToContext:cntx];
}

- (void)_tearDownDrawing:(CGContextRef)cntx {
	[_layerFamiliar restoreContext:cntx];
}

- (CGRect)geometryRect {
	
	return [_layerFamiliar geometryRect];
}

- (void)setGeometryRect:(CGRect)value {
	
	[_layerFamiliar setGeometryRect:value];
}

- (CGAffineTransform)transformMatrix {
	
	return _layerFamiliar.transformMatrix;
}

@end
