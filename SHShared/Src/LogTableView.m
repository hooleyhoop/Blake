//
//  LogTableView.m
//  BBUtilities
//
//  Created by Jonathan del Strother on 15/10/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

#import "LogTableView.h"

@implementation LogTableView

-(void)awakeFromNib
{
	// AFAICT, you can't set the NSTableView row height in interface builder.  Figure it out from the font being used:
	NSFont* font = [[[[self tableColumns] objectAtIndex:0] dataCell] font];
	[self setRowHeight:[font ascender]-[font descender]+[font leading]+1];
	
#ifdef BB_LEOPARD		// Right click menu to select what columns are visible.  Leopard only because we use -[NSTableColumn isHidden].
	NSMenu* headerMenu = [[NSMenu alloc] init];
	[headerMenu setAutoenablesItems:NO];
	int i=0;
	nsenumerat([self tableColumns], column) {
		NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:[[column headerCell] stringValue] action:@selector(toggleColumn:) keyEquivalent:@""];
		[item setTarget:self];
		[item setState:![column isHidden]];
		[item setTag:i++];
		[headerMenu addItem:item];
		[item release];
	}
	[[self headerView] setMenu:headerMenu];
	[headerMenu release];
#endif
}

-(void)toggleColumn:(NSMenuItem*)sender
{
#ifdef BB_LEOPARD		// Right click menu to select what columns are visible.  Leopard only because we use -[NSTableColumn isHidden].
	NSTableColumn* column = [[self tableColumns] objectAtIndex:[sender tag]];
	[column setHidden:[sender state]==NSOnState];
	[sender setState:[sender state]==NSOnState ? NSOffState : NSOnState];
#endif
}

- (void)copy:(id)sender
{
    if ([self numberOfSelectedRows]==0)
		return;
	
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSString *string = @"";
			
	NSArray* selection = [[[self infoForBinding:@"content"] objectForKey:NSObservedObjectKey] selectedObjects];

	for( id row in selection ) {
		string = [string stringByAppendingFormat:@"%@ -- %@ -- %@\n", [row valueForKey:@"timestamp"], [row valueForKey:@"location"], [row valueForKey:@"message"]];
	}
    
    [pb declareTypes: [NSArray arrayWithObject:NSStringPboardType] owner:nil];	
    [pb setString:string forType: NSStringPboardType];
}

-(void)reloadData
{
	[super reloadData];
	
	// New data has been added.  If we were at the bottom of the view before adding a new log message, carry on scrolling down so we stay at the bottom
	if ([[self window] isVisible]) {
		NSClipView* clipping = (id)[self superview];
		double docHeight = [clipping documentRect].size.height;
		double lowestVisiblePoint = [clipping visibleRect].origin.y + [[clipping superview] visibleRect].size.height;
		if (lowestVisiblePoint >= docHeight)
			[self scrollRowToVisible:([self numberOfRows]-1)];
	}
}

@end
