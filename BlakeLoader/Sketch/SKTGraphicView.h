/*
	SKTGraphicView.h
	Part of the Sketch Sample Code
*/

#import "TemporaryRealViewStuff.h"

@class SKTGraphic;


@interface SKTGraphicView : TemporaryRealViewStuff {

    // The bounds of moved objects that is echoed in the ruler, if objects are being moved right now.
 //   NSRect _rulerEchoedBounds;

  //  CGFloat _oldReservedThicknessForRulerAccessoryView;

    // Whether or not selection handles are being hidden while the user moves graphics.
  //  BOOL _isHidingHandles;

    // Sometimes we temporarily hide the selection handles when the user moves graphics using the keyboard. When we do that this is the timer to start showing them again.
   // NSTimer *_handleShowingTimer;
}

- (IBAction)delete:(id)sender;
- (IBAction)deselectAll:(id)sender;
//putbacklater- (IBAction)makeNaturalSize:(id)sender;
//putbacklater- (IBAction)makeSameHeight:(id)sender;
//putbacklater- (IBAction)makeSameWidth:(id)sender;

- (SKTGraphic *)graphicUnderPoint:(NSPoint)point index:(NSUInteger *)outIndex isSelected:(BOOL *)outIsSelected handle:(NSInteger *)outHandle;

- (void)startObservingGraphics:(NSArray *)graphics;
- (void)stopObservingGraphics:(NSArray *)graphics;

@end