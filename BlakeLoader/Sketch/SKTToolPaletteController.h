// SKTToolPaletteController.h
// Sketch Example
//

@class SHToolbar, SKTTool, SKTWindowController;


@interface SKTToolPaletteController : SHooleyObject {

	SKTWindowController		*_sketchWindowController;
	SHToolbar				*_toolBar;
	NSArray					*_tools;
	SKTTool					*_activeTool;
}

@property (assign, nonatomic) SKTTool *activeTool;

- (id)initWithWindowController:(SKTWindowController *)winControl;

//- (IBAction)selectToolAction:(id)sender;
// - (Class)currentGraphicClass;

// - (void)selectArrowTool;
// - (NSString *)currentTool;

- (void)setToolBar:(SHToolbar *)tb;

@end