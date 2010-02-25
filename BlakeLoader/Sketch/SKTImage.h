/*
	SKTImage.h
	Part of the Sketch Sample Code
*/

#import <SketchGraph/SKTGraphic.h>

// The keys described down below.
OBJC_EXPORT NSString *SKTImageIsFlippedHorizontallyKey;
OBJC_EXPORT NSString *SKTImageIsFlippedVerticallyKey;
OBJC_EXPORT NSString *SKTImageFilePathKey;

@interface SKTImage : SKTGraphic {
    @private

    // The image that's being presented.
    NSImage *_contents;

    // The values underlying some of the key-value coding (KVC) and observing (KVO) compliance described below.
    BOOL _isFlippedHorizontally;
    BOOL _isFlippedVertically;

}

/* This class is KVC and KVO compliant for these keys:

"flippedHorizontally" and "flippedVertically" (boolean NSNumbers; read-only) - Whether or not the image is flipped relative to its natural orientation.

"filePath" (an NSString containing a path to an image file; write-only) - the scriptable property that can specified as an alias in the record passed as the "with properties" parameter of a "make" command, so you can create images via AppleScript.

In Sketch "flippedHorizontally" and "flippedVertically" are two more of the properties that SKTDocument observes so it can register undo actions when they change. Also, "imageFilePath" is scriptable.

*/

// Initialize, given the image to be presented and the location on which it should be centered.
- (id)initWithPosition:(NSPoint)position contents:(NSImage *)contents;

@end

/* removed */