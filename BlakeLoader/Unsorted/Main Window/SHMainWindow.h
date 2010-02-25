/* SHMainWindow */

@class SHMainWindowDelegate, SHAppControl;



@interface SHMainWindow : NSWindow
{

	IBOutlet SHAppControl *_theSHAppControl;
}



- (void) layOutAtNewSize;



@end
