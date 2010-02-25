//
//  RotateToolTests.m
//  DebugDrawing
//
//  Created by Steven Hooley on 1/11/09.
//  Copyright 2009 Bestbefore. All rights reserved.
//

#import "RotateTool.h"
#import "StarScene.h"
#import "TestUtilities.h"
#import "Star.h"

@interface RotateToolTests : SenTestCase {
	
	RotateTool *rotateTool;
	
	SHNodeGraphModel	*model;
	StarScene			*scene;
}

@end


@implementation RotateToolTests

- (void)setUp {
	
	model = [[SHNodeGraphModel makeEmptyModel] retain];
	scene = [StarScene new];
	scene.model = model;

	rotateTool = [[RotateTool alloc] init];
}

- (void)tearDown {

	scene.model = nil;
	[scene release];
	[model release];
	
	[rotateTool release];
}


//-- rotate an an object - has a representation in a view
//-- interprets a mouse move to a rotation
//
//-- if conditions are correct we enter a loop converting points to new rotations - update is then called and we calculate our matrix
//-- if selection changes then we need to retest consitions
//
//-- Model
//----------
//-- target object
//-- input mouse action
//
//-- View
//----------
//
//- (id)initWithToolBarController:(ToolBarController *)value
//- (void)updateSelection {
//- (void)updateSelectedObjectBounds {
//- (void)updateOrigin {
//- (void)updateXform {

//- (NSInteger)handleUnderPoint:(NSPoint)apoint {
//- (void)trackMouseDragWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
//- (void)rotateSelectedGraphicWithEvent:(NSEvent *)event inStarView:(CALayerStarView *)view {
//- (IBAction)selectToolAction:(id)sender {
//- (void)toolWillBecomeUnActive {
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
//- (void)drawAnchorInContext:(CGContextRef)ctx {
//- (void)drawZAxisCircleInContext:(CGContextRef)ctx {
//- (void)drawZAxisHandleInContext:(CGContextRef)ctx {
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

@end
