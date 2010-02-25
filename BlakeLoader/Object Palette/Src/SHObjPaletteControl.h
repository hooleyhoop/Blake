//
//  SHObjPaletteControl.h
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

//#import "SHViewControllerProtocol.h"
//#import "SHCustomViewProtocol.h"
//#import "SHCustomViewController.h"

@class SHAppControl, SHObjPaletteModel, SHObjPaletteView,FSNodeInfo;

struct ObjectAndKey {			
	id theObject;
	NSString* theKey;
};

@interface SHObjPaletteControl : SHCustomViewController <SHViewControllerProtocol>
{
    IBOutlet SHObjPaletteModel		*_theSHObjPaletteModel;
}

#pragma mark -
#pragma mark init methods
- (id)initWithSHAppControl:(SHAppControl*)anAppControl;

#pragma mark action methods
- (void) willBeRemovedFromViewPort;
- (void) willBeAddedToViewPort;

- (void) enable;
- (void) disable;

#pragma mark accessor methods
- (SHObjPaletteModel *)theSHObjPaletteModel;


@end


@interface SHObjPaletteControl(PrivateMethods)

#pragma -
#pragma mark init methods
- (int)browser:(NSBrowser *)sender numberOfRowsInColumn:(int)column;
// - (void)browser:(NSBrowser *)sender createRowsForColumn:(int)column inMatrix:(NSMatrix *)matrix;

- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(int)row column:(int)column;

#pragma mark action methods
- (NSString*)fsPathToColumn:(int)column;
- (void)objectFromPath:(NSString *)path intoStruct:(struct ObjectAndKey *)struct_ptr;
- (NSArray *)subNodesOfNode:(FSNodeInfo*)aNode;
- (NSAttributedString*)attributedInspectorStringForFSNode:(FSNodeInfo*)fsnode;

#pragma mark mouse event methods
- (IBAction)browserSingleClick:(id)browser;
- (IBAction)browserDoubleClick:(id)browser;

#pragma mark accessor methods
- (NSDictionary*)normalFontAttributes;
- (NSDictionary*)boldFontAttributes;

@end