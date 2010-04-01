#import "GreenViewController.h"
#import "ColorView.h"

@implementation GreenViewController

- (void)loadView {

	[super loadView];
	[(ColorView *)[self view] setBackgroundColor:[[NSColor greenColor] colorWithAlphaComponent:.5]];
}
@end
