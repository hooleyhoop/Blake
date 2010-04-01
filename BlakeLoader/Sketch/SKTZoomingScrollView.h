/*
	SKTZoomingScrollView.h
	Part of the Sketch Sample Code
*/

@class SHooleyObject;

// The name of the binding supported by this class, in addition to the ones whose support is inherited from NSScrollView.
OBJC_EXPORT NSString *SKTZoomingScrollViewFactor;

@interface SKTZoomingScrollView : SHScrollView {
    @private

    // Every instance of this class creates a popup button with zoom factors in it and places it next to the horizontal scroll bar.
    NSPopUpButton               *_factorPopUpButton;

    // The current zoom factor. This instance variable isn't actually read by any SKTZoomingScrollView code and wouldn't be necessary if it weren't for an oddity in the default implementation of key-value binding (KVB): -[NSObject(NSKeyValueBindingCreation) bind:toObject:withKeyPath:options:] sends the receiver a -valueForKeyPath: message, even though the returned value is typically not interesting. With this here key-value coding (KVC) direct instance variable access makes -valueForKeyPath: happy.
    CGFloat                     _factor;

}
@end
