/*
	SKTRenderingView.h
	Part of the Sketch Sample Code
*/

@interface SKTRenderingView : NSView {
    @private

    // The graphics and print job title that were specified at initialization time.
    NSArray *_graphics;
    NSString *_printJobTitle;

}

// Return the array of graphics as a PDF image.
+ (NSData *)pdfDataWithGraphics:(NSArray *)graphics;

// Return the array of graphics as a TIFF image.
+ (NSData *)tiffDataWithGraphics:(NSArray *)graphics error:(NSError **)outError;

// This class' designated initializer. printJobTitle must be non-nil if the view is going to be used as the view of an NSPrintOperation.
- (id)initWithFrame:(NSRect)frame graphics:(NSArray *)graphics printJobTitle:(NSString *)printJobTitle;

@end

/* removed */