#import "BlueViewController.h"
#import "ColorView.h"

@implementation BlueViewController

- (void)loadView {

	[super loadView];
	[(ColorView*)[self view] setBackgroundColor:[[NSColor blueColor] colorWithAlphaComponent:.5]];
}

@end
