#import "AppController.h"
#import "TreeViewMainWindowController.h"

@implementation AppController


/*	
	This app controller simply manages the window controller of the main window.
	It releases the controller when the window is closed and makes a new one when the 
	user opens the window with cmd-1 keyboard short cut or by selecting "Main Window" in the Window menu	
*/


- (void)dealloc
{
	[treeViewWindowController release];
	[super dealloc];
}

- (IBAction)toggleMainWindowOpen:(id)theSender
{
	if(treeViewWindowController!=nil)
	{
		NSWindow * aMainWindow = [treeViewWindowController window];
		[aMainWindow performClose:self];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:aMainWindow];
		[treeViewWindowController release];
		treeViewWindowController = nil;
	}
	else
	{
		treeViewWindowController = [[TreeViewMainWindowController alloc] initWithWindowNibName:@"TreeViewMainWindow"];
		[[treeViewWindowController window] makeMainWindow];
		[[treeViewWindowController window] makeKeyAndOrderFront:self];
		// the app controller wants to know if the user closes the main window by hitting cmd-w or with the close button on the window
		// it registers to get notified of this event
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMainWindowWillClose:) name:NSWindowWillCloseNotification object:[treeViewWindowController window]];

	}
}

- (void)handleMainWindowWillClose:(NSNotification*)theNotification
{
	// if the window is closed by the user using cmd-w or the close button on the window
	// release the window controller
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[treeViewWindowController window]];
	[treeViewWindowController release];
	treeViewWindowController = nil;
}
// use validateUserInterfaceItem
- (BOOL)validateMenuItem:(NSMenuItem*)theMenuItem
{
    logInfo(@"validateMenuItem %@", anItem);

	if([theMenuItem action] == @selector(toggleMainWindowOpen:))
	{
		// make sure the menu item's state
		// reflects whether the window is open or not
		if(treeViewWindowController!=nil)
			[theMenuItem setState:1];
		else
			[theMenuItem setState:0];
		return YES;
	}
	return NO;
}


@end
