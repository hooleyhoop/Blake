#import "DetailViewController.h"
#import "BlueViewController.h"
#import "GreenViewController.h"

@interface DetailViewController (Private)
- (void)_switchToBlueViewController;
- (void)_switchToGreenViewController;
@end

@implementation DetailViewController

@synthesize docWindowController;

@synthesize currentViewController = mCurrentViewController;

- (void)dealloc
{
	[mCurrentViewController release];
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	
	// start with a blue view in our content view
	[self _switchToBlueViewController];
}

- (IBAction)switchViews:(id)theSender
{
	int aTag = 0;
	
	if([theSender isKindOfClass:[NSSegmentedControl class]])
		aTag = [theSender selectedSegment];
	else
	{
		// the action from the menu items should change the selection
		// of the segmented control
		aTag = [theSender tag];
		[oViewSwitchControl setSelectedSegment:aTag];
	}
	
	// remove current view from hierarchy
	[[[self currentViewController] view] removeFromSuperview];
	
	// release current view controller
	[self setCurrentViewController:nil];
		
	if(aTag == 0)
	{
		// Blue View
		[self _switchToBlueViewController];
	}
	else if(aTag == 1)
	{
		// Green View
		[self _switchToGreenViewController];
	}
}

-(void)_switchToBlueViewController
{
	// create ImageViewController
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	BlueViewController * anImageViewController = [[[BlueViewController alloc] initWithNibName:@"BlueView" bundle:thisBundle] autorelease];
	
	// lay out its view
	NSView * anImageView = [anImageViewController view];
	[anImageView setFrame:[oContentView bounds]];
	[anImageView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	// add view to hierarchy
	[oContentView addSubview:anImageView];
	
	// set current view controller
	[self setCurrentViewController:anImageViewController];
}

-(void)_switchToGreenViewController
{
	// create ImageViewController
	NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
	GreenViewController * aViewController = [[[GreenViewController alloc] initWithNibName:@"BlueView" bundle:thisBundle] autorelease];
	
	// lay out its view
	NSView * anImageView = [aViewController view];
	[anImageView setFrame:[oContentView bounds]];
	[anImageView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	// add view to hierarchy
	[oContentView addSubview:anImageView];
	
	// set current view controller
	[self setCurrentViewController:aViewController];
}
// use validateUserInterfaceItem
- (BOOL)validateMenuItem:(NSMenuItem*)theMenuItem
{
	BOOL aReturnValue = NO;
	
	if([theMenuItem action] == @selector(switchViews:))
	{
		// Our view is in the window
		// Make sure the menu items' states reflect the current view that is selected
		if([theMenuItem tag] == 0)
		{
			[theMenuItem setState:[[self currentViewController] isKindOfClass:[BlueViewController class]]];
			
		}
		else if([theMenuItem tag] == 1)
			[theMenuItem setState:[[self currentViewController] isKindOfClass:[GreenViewController class]]];
		
		aReturnValue = YES;

	}
	return aReturnValue;
}
@end
