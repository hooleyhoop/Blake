
@class BlakeNodeListWindowController;
@interface DetailViewController : NSViewController 
{
	IBOutlet BlakeNodeListWindowController	*docWindowController;

	IBOutlet NSView *				oContentView;	
	IBOutlet NSSegmentedControl	*	oViewSwitchControl;
	
	NSViewController *				mCurrentViewController;
}

@property (assign, readwrite, nonatomic) BlakeNodeListWindowController	*docWindowController;
@property (retain, nonatomic) NSViewController *currentViewController;

- (IBAction)switchViews:(id)theSender;

@end
