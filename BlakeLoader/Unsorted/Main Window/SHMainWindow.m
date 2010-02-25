
#import "SHMainWindow.h"
#import "SHAppControl.h"
#import "SHAppView.h"

	
@implementation SHMainWindow


//=========================================================== 
// - awakeFromNib:
//=========================================================== 
- (void) awakeFromNib
{
	[self layOutAtNewSize];
}


// the window has been resized
- (void) layOutAtNewSize
{
	// NSLog(@"SHMainWindow.m: window has been resized");
	[[_theSHAppControl theSHAppView] layOutAtNewSize];

//	[self setOpaque:NO];
//	[self setAlphaValue:.999f];
	[self makeMainWindow];
	[self makeKeyWindow];
	[self makeFirstResponder:self];
//	NSLog(@"SHMainWindow.m: is key window? %i", 	[self isKeyWindow]);
}

- (BOOL)canBecomeKeyWindow
{
	/* do we want to accept key events ? */
	return YES;
}

- (BOOL)canBecomeMainWindow
{
//	NSLog(@"SHMainWindow.m: canBecomeMainWindow? ");

	return YES;
}

- (void)keyDown:(NSEvent *)theEvent {

	NSLog(@"keyDown.m: is keyDown theEvkeyDownent? ");
	
	/* Really we should let these go up the responder chain to our SHApplication which is at the top */
	/* All responder objects have a next responder, for a view it's default is the superview, then window, then application */
	[super keyDown:theEvent];
}



@end
