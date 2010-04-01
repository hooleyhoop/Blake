//
//  SHRootNodeListTableView.m
//  Pharm
//
//  Created by Steve Hooley on 30/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "SHRootNodeListTableView.h"
#import "BlakeNodeListWindowController.h"

@interface SHRootNodeListTableView ()
- (void)typeAheadString:(NSString *)inString inTableView:(NSTableView *)inTableView;
@end

/*
 *
*/ 
@implementation SHRootNodeListTableView


#define MyTableViewDataType @"id<ObjectWrapperProtocol>" // this will need changing to node


#pragma mark -
#pragma mark class methods

#pragma mark init methods

@synthesize controller=_controller;
@synthesize lastClickTime=_lastClickTime;

- (void)dealloc {
	
//	[_controller release];
	[_lastClickTime release];
	[super dealloc];
}

- (void)awakeFromNib
{
	// This is needed for drag reordering to work !(?). We must implement the following methods
	// either numberOfRowsInTableView: 
	// tableView:objectValueForTableColumn:row:
	[self setBackgroundColor:[NSColor windowBackgroundColor]];	// NSDeviceWhiteColorSpace 0.909804

    [self registerForDraggedTypes: [NSArray arrayWithObjects:MyTableViewDataType, NSFilenamesPboardType, nil] ]; // make sure we accept files
	[self setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
	[self setVerticalMotionCanBeginDrag: YES];

	NSEnumerator *theEnum  = [[self tableColumns] objectEnumerator];
	NSTableColumn *theCol;
	while (nil != (theCol = [theEnum nextObject]) )
	{
		[[theCol dataCell] setWraps:YES];
		[[theCol dataCell] setFont: [NSFont systemFontOfSize: [NSFont smallSystemFontSize]]];
	}
} 

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
	[super addObserver:observer forKeyPath:keyPath options:options context:context];
}
#pragma mark action methods
/* Notification that a modifier key was pressed or released */
- (void)flagsChanged:(NSEvent *)theEvent {
	[super flagsChanged:theEvent];
}

/* NB - this can fuck up arrow key support if you copt it */
//- (void)keyDown:(NSEvent *)theEvent
//{
//	BOOL wasHandled;
//	unsigned int modFlags = [theEvent modifierFlags];
// //   int SHIFT_DOWN = (modFlags & NSShiftKeyMask) >> 17;
////	int ALT_DOWN = (modFlags & NSAlternateKeyMask) >> 19;
//	int CMD_DOWN = (modFlags & NSCommandKeyMask) >> 20;
//	
//	unsigned short theKeyCode = [theEvent keyCode];
////	NSString* keypress = [theEvent charactersIgnoringModifiers];
//	
//	/* TODO - move to SHApplication where possible */
//	
//	/* backspace */
//	if( theKeyCode==51 || theKeyCode==117) {
//		wasHandled = [self backSpacePressed];			
//	} else if(CMD_DOWN && (theKeyCode==125 || theKeyCode==126)){
//	/* up & down */
//		switch(theKeyCode){
//		case 125:
//			// down
////			[_controller moveDownToChild:self];
//			break;
//		case 126:
//			// up
////			[_controller moveUpToParent:self];
//			break;
//		}
//	} else {
//		NSCharacterSet* cs = [[NSCharacterSet nodeNameCharacterSet] invertedSet];
//		NSRange sr = [[theEvent characters] rangeOfCharacterFromSet:cs];
//		if(sr.location==NSNotFound)
//		{
//			[self interpretKeyEvents: [NSArray arrayWithObject:theEvent]];
//		}
//	}
//
//	/* Really we should let these go up the responder chain to our SHApplication which is at the top */
//	/* All responder objects have a next responder, for a view it's default is the superview, then window, then application */
//	
//	/* You can set the 'target' of things line menu-items to Nil and it will go to the first item in the responder chain that accepts that message */
//	if(!wasHandled)
//		[super keyDown:theEvent];
//}

- (void)clearAccumulatingTypeahead
{
	[mStringToFind setString:@""];   // clear out the queued string to find
}


- (void)typeAheadString:(NSString *)inString inTableView:(NSTableView *)inTableView {

	NSTableColumn *col = [inTableView highlightedTableColumn];
	if( nil != col)
	{
		NSString *key = [col identifier];
		NSUInteger i;
		NSArrayController *destinationArrayController = [self arrayController];
		NSArray* arrangedContent = [destinationArrayController arrangedObjects];
		for( NSDictionary *rowDict in arrangedContent )
		{
			NSString *compareTo = [rowDict objectForKey:key];
			NSComparisonResult order = [inString caseInsensitiveCompare:compareTo];
			if (order != NSOrderedDescending)
			{
				break;
			}
		}
		// Make sure we're not overflowing the row count.
		if (i >= [arrangedContent count])
		{
			i = [arrangedContent count] - 1;
		}
		// Now select row i -- either the one we found, or the last row if not found.
		[inTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];

		[inTableView scrollRowToVisible:i];
	}
}


- (void)insertText:(id)inString
{
	// Make sure delegate will handle type-ahead message
	if ([[self delegate] respondsToSelector: @selector(typeAheadString:inTableView:)])
	{
		// We clear it out after two times the key repeat rate "InitialKeyRepeat" user
		// default (converted from sixtieths of a second to seconds), but no more than two
		// seconds. This behavior is determined based on Inside Macintosh documentation
		// on the List Manager.
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		int keyThreshTicks = [defaults integerForKey:@"InitialKeyRepeat"];
		NSTimeInterval clearDelay = MIN(2.0/60.0*keyThreshTicks, 2.0);
		
		if ( nil == mStringToFind )
		{
			mStringToFind = [[NSMutableString alloc] init];
			// lazily allocate the mutable string if needed.
		}
		[mStringToFind appendString:inString];
		
		// Cancel any previously queued future invocations
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearAccumulatingTypeahead) object:nil];
		
		// queue an invocation of clearAccumulatingTypeahead for the near future.
		[self performSelector: @selector(clearAccumulatingTypeahead) withObject:nil afterDelay:clearDelay];
		
		// Let the table's delegate do something with the string.
		// We use stringWithString to make an autoreleased copy so for its use,
		// since we may clear out the original string below before it can be used.
		[[self delegate] typeAheadString: [NSString stringWithString:mStringToFind] inTableView:self];
	}
}

- (BOOL)backSpacePressed
{
	return NO;
}




//- (BOOL)textShouldBeginEditing:(NSText *)textObject
//{
//	NSLog(@"textShouldBeginEditing");
//}

//- (BOOL)textShouldEndEditing:(NSText *)textObject
//{
//	NSLog(@"textShouldEndEditing");
//}

//- (void)textDidBeginEditing:(NSNotification *)notification
//{
//	NSLog(@"textDidBeginEditing");
//}

//- (void)textDidEndEditing:(NSNotification *)notification
//{
//	NSLog(@"textDidEndEditing");
//}

//- (void)textDidChange:(NSNotification *)notification
//{
//	NSLog(@"textDidChange");
//}

//- (int)clickedRow
//{
//	NSLog(@"clickedRow");
//	[super clickedRow];
//}

//- (void)editColumn:(int)column row:(int)row withEvent:(NSEvent *)theEvent select:(BOOL)select
//{
//	NSLog(@"editColumn");
//	[super editColumn:column row:row withEvent:theEvent select:select];
//}


//- (void)mouseDown:(NSEvent *)event
//{
//	lastPos = [self convertPoint:[event locationInWindow] fromView:nil];
//	int col = [self columnAtPoint:lastPos];
//	int row = [self rowAtPoint:lastPos];
//
////s    mouseItem = [self getItemIndexAtPoint: lastPos];
//
//    [[self window] endEditingFor: prototype];
//    
//	if(col==-1 || row==-1)	// No item hit? Remove selection and start mouse tracking for selection rect.
//	{
////s		[self selectionSetNeedsDisplay];    // Possible threading deadlock here ... ?
////s		[selectionSet removeAllObjects];
////s		[[NSNotificationCenter defaultCenter] postNotificationName: UKDistributedViewSelectionDidChangeNotification object: self];
//	}
//	else    // An item was clicked?
//	{
//		if( [event clickCount] % 2 == 0 )   // Double click!
//		{
//			NSRect itemBox = [self rectForItemAtIndex: mouseItem];
//			itemBox = [self flipRectsYAxis: itemBox];
//			itemBox = [prototype titleRectForBounds: itemBox];
//			if( NSPointInRect( lastPos, itemBox ) ) // Title of editable item double-clicked? User wants to edit!
//			{
//				[self editItemIndex: mouseItem withEvent:event select:YES];
//				return;
//			}
//			
//			if( [delegate respondsToSelector: @selector(distributedView:cellDoubleClickedAtItemIndex:)] )
//				[delegate distributedView:self cellDoubleClickedAtItemIndex:mouseItem];
//			return;
//		}
//		
////		if( !flags.allowsMultipleSelection )
////			[self deselectAll: nil];
//		
//		if( ([event modifierFlags] & NSShiftKeyMask) == NSShiftKeyMask )    // Single click but shift key held down?
//		{
//			// If shift key is down, toggle this item's selection status
//			if( [selectionSet containsObject:[NSNumber numberWithInt: mouseItem]] )
//			{
//				[selectionSet removeObject:[NSNumber numberWithInt: mouseItem]];
//				[[NSNotificationCenter defaultCenter] postNotificationName: UKDistributedViewSelectionDidChangeNotification
//																	object: self];
//				[self itemNeedsDisplay: mouseItem];
//				return;	// Don't drag unselected item.
//			}
//			else
//			{
//				if( ![delegate respondsToSelector: @selector(distributedView:shouldSelectItemIndex:)]
//					|| [delegate distributedView:self shouldSelectItemIndex: mouseItem] )
//				{
//					[selectionSet addObject:[NSNumber numberWithInt: mouseItem]];
//					if( [delegate respondsToSelector: @selector(distributedView:didSelectItemIndex:)] )
//						[delegate distributedView:self didSelectItemIndex: mouseItem];
//					[self itemNeedsDisplay: mouseItem];
//					[[NSNotificationCenter defaultCenter] postNotificationName: UKDistributedViewSelectionDidChangeNotification
//																		object: self];
//				}
//				else
//					return; // Bail. Delegate told us not to select this item.
//			}
//		}
//		else	// If shift isn't down, make sure we're selected and drag:
//		{
//			if( ![delegate respondsToSelector: @selector(distributedView:shouldSelectItemIndex:)] || [delegate distributedView:self shouldSelectItemIndex: mouseItem] )
//			{
//				if( ![selectionSet containsObject:[NSNumber numberWithInt: mouseItem]] )
//				{	
//					[self selectionSetNeedsDisplay];
//					[selectionSet removeAllObjects];
//					[selectionSet addObject:[NSNumber numberWithInt: mouseItem]];
//					if( [delegate respondsToSelector: @selector(distributedView:didSelectItemIndex:)] )
//						[delegate distributedView:self didSelectItemIndex: mouseItem];
//					[[NSNotificationCenter defaultCenter] postNotificationName: UKDistributedViewSelectionDidChangeNotification object: self];
//					[self itemNeedsDisplay: mouseItem];
//				}
//			}
//			else
//				return; // Bail. Delegate told us not to select this item.
//		}
//	}
//	
//	if( [self useSelectionRect] || mouseItem != -1 )	// Don't start tracking if we're dealing with a selection rect and we're not allowed to do a selection rect.
//		[self initiateMove];
//}

//- (void)mouseDown:(NSEvent *)theEvent
//{	
//	NSDate* timeAtClick = [NSCalendarDate date];
//	NSTimeInterval timeSinceLast = [_lastClickTime timeIntervalSinceDate:timeAtClick] *-1.0;
//	BOOL isDoubleClick;
//	//	NSLog(@"interval is %f : double time is %f", timeSinceLast, (float)GetDblTime()/1000);
//	if([theEvent clickCount]>1 && (timeSinceLast<(float)GetDblTime()*2/1000.0 && timeSinceLast>0)) 
//	{
//		logInfo(@"double click - time since last is %f", (float)timeSinceLast);
//		isDoubleClick = YES;
//		[[self window] endEditingFor: [[[NSCell alloc] init] autorelease]];
////todo		[[[_controller document] nodeGraphModel] moveDownAlevelIntoSelectedNodeGroup];
//
//	} else
//	{
//		isDoubleClick = NO;
//	//	NSLog(@"single click");
//		[super mouseDown:theEvent];
//
////		NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
////		
////		int columnIndex = [self columnAtPoint:mouseLoc];
////		int rowIndex = [self rowAtPoint:mouseLoc];
////		
////		if ((rowIndex >= 0) && ([[[[self tableColumns] objectAtIndex:columnIndex] identifier] isEqualTo:[NSString stringWithString:@"theName"]]) && [self isRowSelected:rowIndex]) 
////		{
////			NSLog(@"wtf? - should edit");
////			//	 [self selectRow:rowIndex byExtendingSelection:NO];
////			[self editColumn:columnIndex row:rowIndex withEvent:theEvent select:YES];
////		} else
////		{
////			[super mouseDown:theEvent];
////		}	
//	}
//	[self setLastClickTime:timeAtClick];
//}

//-(void)singleClick:sender { ...your original code... } // not connected as 
//	the action
//-(IBAction)singleClickAction:sender { // THIS is connected to the single 
//	click action
//	[self performSelector:@selector(singleClick:) withObject:sender 
//			   afterDelay:A_BIT_MORE_THAN_DOUBLECLICK_DELAY];
//}
//-(IBAction)doubleClickAction:sender { // connected to the double click 
//	action
//	[NSObject cancelPreviousPerformRequestsWithTarget:self 
//											 selector:@selector(singleClick:) object:sender]y
//	... normal doubleclick code ...
//}

//- (void)drawRow:(NSInteger)rowIndex clipRect:(NSRect)clipRect {
//	
//	if(![self isRowSelected:rowIndex]){
//
//	NSColor *c1 = [NSColor colorWithCalibratedRed: 0.804 green: 0.863 blue: 0.953 alpha: 1.0];
//	NSColor *c2 = [NSColor colorWithCalibratedRed: 0.914 green: 0.937 blue: 0.98 alpha: 1.0];
//	NSColor *c3 = [NSColor colorWithCalibratedRed: 0.914 green: 0.937 blue: 0.98/2 alpha: 1.0];
//	NSColor *c4 = [NSColor colorWithCalibratedRed: 221/255 green: 232/255 blue: 224/255 alpha: 1.0];
//	
//	NSColor *colors[4];
//	colors[0] = c1;
//	colors[1] = c2;
//	colors[2] = c3;
//	colors[3] = c4;
//
//		int colorIndex = [[self delegate] tableView:self colorIndexForRow:rowIndex];
//		[colors[colorIndex] set];
//		NSRect bounds = [self rectOfRow:rowIndex];
////		bounds.size.width -= 4;
////		bounds.origin.x += 4;
////		bounds.size.height -= 1;
////e		NSRectFill(bounds);
//	}
//	[super drawRow:rowIndex clipRect:clipRect];
//}


//- (void)drawBackgroundInClipRect:(NSRect) aRect {
//
//	[super drawBackgroundInClipRect: aRect];
//  
////  if ([self numberOfRows] < 2)
////	return;
//
//	// ask the delegate??
////	NSRect
////	[delegate getBAackgroundRegions:&regions
//	NSColor *c1 = [NSColor colorWithCalibratedRed: 0.804 green: 0.863 blue: 0.953 alpha: 1.0];
//	NSColor *c2 = [NSColor colorWithCalibratedRed: 0.914 green: 0.937 blue: 0.98 alpha: 1.0];
//	NSColor *c3 = [NSColor colorWithCalibratedRed: 0.914 green: 0.937 blue: 0.98/2 alpha: 1.0];
//
//	int i;
//	int n = [self numberOfRows];
//	for(i = 1; i < n; i++)
//	{
//		NSRect rect = [self rectOfRow: i];
//		rect.size.width -= 4;
//		rect.origin.x += 4;
//		rect.size.height -= 1;
////		id item = [self itemAtRow: i];
////    if ([self isExpandable: item])
////    {
////      [c2 set];
////      NSRectFill(rect);
////      NSRect rect2 = rect;
////      float indent = [self indentationPerLevel] * [self levelForRow: i];
////      rect2.origin.x += indent + 1;
////      rect2.size.width -= indent + 1;
////      rect2.size.height -= 1;
////      [c1 set];
////      NSRectFill(rect2);
////    }
////    else {
//		[c2 set];
////		NSRectFill(rect);
////    }
//
// //   int j;
//  //  rect.size.width = [self indentationPerLevel] - 1;
// //   rect.origin.y -= 1;
// //   [c1 set];
// //   for(j = 0; j < [self levelForRow: i]; j++)
//  //  {
//    //  rect.origin.x = j * [self indentationPerLevel] + 5;
//  //    NSRectFill(rect);
////		}
//	}
//}

//-(id)_highlightColorForCell:(NSCell *)cell {
//
//}

#pragma mark accessor methods
- (NSArrayController *)arrayController {

	return (NSArrayController *)[[self controller] filteringArrayController];
//	NSDictionary *destinationContentBindingInfo = [self infoForBinding:NSContentBinding];
//	NSArrayController *destinationArrayController = [destinationContentBindingInfo objectForKey:NSObservedObjectKey];
//	return destinationArrayController;
}

//- (void)setController:(BlakeNodeListWindowController *)value {
//	_controller = [value retain];
//}


@end
