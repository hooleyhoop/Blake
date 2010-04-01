/*
	SKTWindowController.h
	Part of the Sketch Sample Code
*/

@class SKTGraphicView, SKTZoomingScrollView;
@class SKTToolPaletteController;
@class SKTGraphicViewController;

@interface SKTWindowController : SHWindowController {

	SKTToolPaletteController			*_sketchToolPaletteConroller;

    CGFloat								_zoomFactor;

    // Other objects we expect to find in the nib.
	IBOutlet SKTGraphicViewController	*_viewController;
    IBOutlet SKTGraphicView				*_graphicView;
    IBOutlet SKTZoomingScrollView		*_zoomingScrollView;
}

@property (assign, readonly, nonatomic) SKTToolPaletteController *sketchToolPaletteConroller;
@property (assign, nonatomic) SKTGraphicView *graphicView;										// be aware that this has custom accessors
@property (assign, nonatomic) SKTZoomingScrollView *zoomingScrollView;
@property (assign, nonatomic) SKTGraphicViewController *viewController;

/* This class is KVC and KVO compliant for this key:

"zoomFactor" (a floating point NSNumber; read-write) - The zoom factor for the graphic view, following the meaning established by SKTZoomingScrollView's bindable "factor" property.

In Sketch:

Each SKTGraphicView's graphics and selection indexes properties are bound to the arranged objects and selection indexes properties of the containing SKTWindowController's graphics controller.

Each SKTZoomingScrollView's factor property is bound to the zoom factor property of the SKTWindowController that contains it.

Various properties of the controls of the graphics inspector are bound to properties of the selection of the graphics controller of the main window's SKTWindowController.

Grids and zoom factors are owned by window controllers instead of the views that use them; in the future we may want to make the same grid and zoom factor apply to multiple views, 
 or make the grid parameters and zoom factor into stored per-document preferences.

*/


@end
