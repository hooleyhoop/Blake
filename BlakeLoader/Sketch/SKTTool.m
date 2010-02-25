//
//  SKTTool.m
//  BlakeLoader
//
//  Created by steve hooley on 19/05/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "SKTTool.h"
#import "SKTGraphicView.h"
#import "SKTToolPaletteController.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"


@implementation SKTTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super init];
	if(self){
		_toolBarControl = value;
	}
	return self;
}

- (void)dealloc {

	[super dealloc];
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {

	[item setLabel:_labelString];
	[item setPaletteLabel:_labelString];

	NSImage *iconImg = [[NSImage alloc] initWithContentsOfFile: _iconPath];
	[item setImage: iconImg];
	
	[item setTarget:self];
	[item setAction:@selector(selectToolAction:)];
	
	// [item setMinSize:fRect.size];
	// [item setMaxSize:fRect.size];
}


//JOOST    }
//JOOST    if (!theCursor) {
//JOOST        theCursor = [NSCursor arrowCursor];
//JOOST    }

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view  {
	
	logWarning(@"/* Abstract - Overide me */");
}

/* This is the toolbar-item's action */
- (IBAction)selectToolAction:(id)sender {

	[_toolBarControl.activeTool willBecomeUnActive];
	[_toolBarControl setActiveTool: self];
	
	[[self defaultCursor] set];
}

- (void)willBecomeUnActive {
	
}

- (NSString *)identifier {

	NSAssert(_identifier!=nil, @"never");
	return _identifier;
}

- (BOOL)identifierMatches:(NSString *)value {

	return [[self identifier] isEqualToString: value];
}

- (void)drawToolInSketchView:(SKTGraphicView *)view {
}

- (NSRect)toolDisplaybounds {
	return NSZeroRect;
}

//- (enum SKTGraphicDrawingMode)preferredDrawingStyleForGraphic:(SKTGraphic *)graphic {
//    return SKTGraphicNormalFill;
//}

/* For the sketch circle, sq, etc */
- (void)createGraphicOfClass:(Class)graphicClass withEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {
    
    // Clear the selection.
    [view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]];
	
    // Where is the mouse pointer as graphic creation is starting? Should the location be constrained to the grid?
    NSPoint graphicOrigin = [view convertPoint:[event locationInWindow] fromView:nil];
	
    // Create the new graphic and set what little we know of its location.
    _creatingGraphic = [[graphicClass alloc] init];
    [_creatingGraphic setBounds:NSMakeRect(graphicOrigin.x, graphicOrigin.y, 0.0f, 0.0f)];
	
    // Add it to the set of graphics right away so that it will show up in other views of the same array of graphics as the user sizes it.
	[view.sketchViewController addGraphic:_creatingGraphic atIndex:0];
	
    // Let the user size the new graphic until they let go of the mouse. Because different kinds of graphics have different kinds of handles, first ask the graphic class what handle the user is dragging during this initial sizing.
    [self resizeGraphic:_creatingGraphic usingHandle:[graphicClass creationSizingHandle] withEvent:event inSketchView:view];
	
    // Did we really create a graphic? Don't check with !NSIsEmptyRect(createdGraphicBounds) because the bounds of a perfectly horizontal or vertical line is "empty" but of course we want to let people create those.
    NSRect createdGraphicBounds = [_creatingGraphic bounds];
    if (NSWidth(createdGraphicBounds)!=0.0 || NSHeight(createdGraphicBounds)!=0.0)
	{
		// Select it.
		[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];
		
		// The graphic wasn't sized to nothing during mouse tracking. Present its editing interface it if it's that kind of graphic (like Sketch's SKTTexts). Invokers of the method we're in right now should have already cleared out _editingView.
//		[self startEditingGraphic:_creatingGraphic inSketchView:view];
		
    } else {
    }
	
    [_creatingGraphic release];
	_creatingGraphic = nil;
}

- (void)resizeGraphic:(SKTGraphic *)graphic usingHandle:(NSInteger)handle withEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {
	
	//    BOOL echoToRulers = [[self enclosingScrollView] rulersVisible];
	//    if (echoToRulers) {
	//        [self beginEchoingMoveToRulers:[graphic bounds]];
	//    }
	
    while ([event type]!=NSLeftMouseUp) 
	{
        event = [[view window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		[view autoscroll:event];
        NSPoint handleLocation = [view convertPoint:[event locationInWindow] fromView:nil];
		
        handle = [graphic resizeByMovingHandle:handle toPoint:handleLocation];
		//        if (echoToRulers) {
		//           [self continueEchoingMoveToRulers:[graphic bounds]];
		//        }
    }
	
	//    if (echoToRulers) {
	//        [self stopEchoingMoveToRulers];
	//    }
}






//- (SKTGraphic *)editingGraphic {
//	return _editingGraphic;
//}

- (NSCursor *)defaultCursor {
	return [NSCursor arrowCursor];
}

@end


