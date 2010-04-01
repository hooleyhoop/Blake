
@class OutlineView1Controller;
@class DetailViewController;

@interface TreeViewMainWindowController : SHWindowController 
{
	IBOutlet NSSplitView		*oMainSplitView;
	
	OutlineView1Controller		*_outlineView1ViewController;
	DetailViewController		*mDetailViewController;
}

+ (NSString *)nibName;

@end
