//
//  SKTBezierTool.m
//  BlakeLoader2
//
//  Created by steve hooley on 19/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTBezierTool.h"
#import "SKTGraphicView.h"
#import "SKTGraphicViewController.h"
#import "SKTGraphicViewModel.h"
#import "SKTBezier.h"
#import "SKTDecorator_Bezier.h"


@implementation SKTBezierTool

- (id)initWithController:(SKTToolPaletteController *)value {
	
	self = [super initWithController:value];
	if(self){
		_identifier = @"SKTBezierTool";
		_labelString = @"Bezier";
		_iconPath = [[NSBundle bundleForClass:[self class]] pathForImageResource:@"BezierToolIcn"];
	}
	return self;
}

- (void)setUpToolbarItem:(NSToolbarItem *)item {
	
	[item setToolTip:@"Bezier"];
	[super setUpToolbarItem:item];
}

- (void)mouseDownEvent:(NSEvent *)event atPoint:(NSPoint)pt inSketchView:(SKTGraphicView *)view {
	
	NSAssert( _creatingGraphic==nil, @"How could this be otherwise?");
	
	//-- if there isnt a bezier, create a new one, else use current
	if( !_creatingGraphic ) {
		// [self createGraphicOfClass:[SKTBezier class] withEvent:event inSketchView:view];
		[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSet]];
		SKTBezier *newBezier = [[[SKTBezier alloc] init] autorelease];
		_creatingGraphic = newBezier;
		[view.sketchViewController addGraphic:_creatingGraphic atIndex:0];
		
		// -- swap in a bezier decorator?
		SKTDecorator_Bezier *dec = [SKTDecorator_Bezier decoratorForGraphic: _creatingGraphic];
		NSMutableArray *sktSceneItems = view.sketchViewController.sketchViewModel.sktSceneItems;
		int indexOfCreatingGraphic = [sktSceneItems indexOfObjectIdenticalTo: _creatingGraphic];
		[sktSceneItems replaceObjectAtIndex:indexOfCreatingGraphic withObject:dec];
		
		_creatingGraphic = [dec retain];

		[((SKTBezier *)_creatingGraphic).path moveToPoint:pt];
		[view setNeedsDisplayInRect: [_creatingGraphic drawingBounds]];
		
		//-- go into an event loop adding points to curve until enter is pressed
		[self trackMouseWithEvent:event inSketchView:view];
		
		//-- swap out bezier decorator
		[sktSceneItems replaceObjectAtIndex:indexOfCreatingGraphic withObject:newBezier];
		
		// Select it.
		[view.sketchViewController.sketchViewModel changeSktSceneSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];
		
	} else {
		[NSException raise:@"How did we get here - cant have cleaned up creating graphic corre ctly" format:@"How did we get here - cant have cleaned up creating graphic corre ctly"];
	}
	

}

- (void)trackMouseWithEvent:(NSEvent *)event inSketchView:(SKTGraphicView *)view {

    NSPoint mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];

	while( NSPointInRect( mouseLocation, [view frame] ) )
	{
		// we may want to test for more conditions
		event = [[view window] nextEventMatchingMask:( NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSLeftMouseUpMask | NSKeyDownMask)];
		NSEventType type = [event type];
		// short subtype = [event subtype];

		if( type==NSLeftMouseDown )
		{
			mouseLocation = [view convertPoint:[event locationInWindow] fromView:nil];
			logInfo(@"In a crazy ass mouse loop %@ - type %i", NSStringFromPoint(mouseLocation), [event type]);
			
			// -- if mouseLocation_pt is within a small snapping rect centred around the start point we should close the path instead
			if( [((SKTBezier *)_creatingGraphic) countOfPoints]>2 ){
				
				NSPoint startPoint = [((SKTBezier *)_creatingGraphic) startPoint];
				NSRect snappingRect = NSMakeRect( startPoint.x-2, startPoint.y-2, 4.0, 4.0 );
				if( NSPointInRect( mouseLocation, snappingRect ) ){
					[((SKTBezier *)_creatingGraphic).path closePath];
					[view setNeedsDisplayInRect: [_creatingGraphic drawingBounds]];
					logInfo(@"SNAP!");
					break;
				}
			}
			
			[((SKTBezier *)_creatingGraphic).path lineToPoint:mouseLocation];
			[view setNeedsDisplayInRect: [_creatingGraphic drawingBounds]];

		} else if( type==NSLeftMouseDragged ) {
			
		} else if( type==NSLeftMouseUp ) {
			
		} else if( type==NSKeyDown ) {
			unsigned short theKeyCode = [event keyCode];
			//	escape = 53
			//	enter = 76
			if( theKeyCode==53 ||  theKeyCode==76 )
				break;
		}	
	}
	logInfo(@"leaving loop - point %@ not in rect %@", NSStringFromPoint(mouseLocation), NSStringFromRect([view frame]) );
    [_creatingGraphic release];
	_creatingGraphic = nil;
}

- (NSCursor *)defaultCursor {
	return [NSCursor crosshairCursor];
}

@end
