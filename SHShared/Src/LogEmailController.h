
// Handles emailing logs & crash reports to us, when the user clicks the 'Email Us' button in the log window
// Might be handy to check for new crash reports on startup, and offer to send them.


@interface LogEmailController : _ROOT_OBJECT_ {

    IBOutlet NSTextView *problemDescription;
    IBOutlet NSTextField *replyTo;
    IBOutlet NSPanel *window;
}
- (IBAction)cancel:(id )sender;
- (IBAction)sendEmail:(id )sender;

-(void)launchForWindow:(NSWindow*)parentWindow;	// Open the email window attached to a given parent window
@end
