#import <SketchGraph/SHContentProviderUserProtocol.h>

@class BlakeNodeListWindowController, SHNode, NodeClassFilter, NodeProxy;


@interface OutlineView1Controller : NSViewController <SHViewControllerProtocol, SHContentProviderUserProtocol>
{
	NodeClassFilter							*_filter;

	IBOutlet BlakeNodeListWindowController	*docWindowController;
	IBOutlet NSOutlineView					*outlineView;
	
	NodeProxy*								_rootNodeProxy;
}

@property (assign, readwrite, nonatomic) NodeClassFilter *filter;
@property (assign, readwrite, nonatomic) BlakeNodeListWindowController	*docWindowController;

- (void)setupOutlineView1;
- (void)tearDownOutlineView1;

#pragma mark DIY notifications
- (void)temp_proxy:(NodeProxy *)value changedContent:(id)notUsed;
- (void)temp_proxy:(NodeProxy *)value insertedContent:(id)notUsed;
- (void)temp_proxy:(NodeProxy *)value removedContent:(id)notUsed;

- (void)temp_proxy:(NodeProxy *)value changedSelection:(id)notUsed;

#pragma mark accessors
- (NSArray *)readablePasteboardTypes;

@end
