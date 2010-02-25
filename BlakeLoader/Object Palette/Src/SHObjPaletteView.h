//
//  SHObjPaletteView.h
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

// #import "SHSwapableView.h"
@class SHObjPaletteControl, C3DTColor, C3DTEntity, SHInfoTextView, SHScrollView, SHClipView;


@interface SHObjPaletteView : SHSwapableView
{
	SHScrollView			*_theOuterMostView;
	SHClipView				*_theContainingView;
	IBOutlet NSBrowser		*theObjectBrowser;
	SHInfoTextView			*theTextField;
	IBOutlet NSScrollView	*theTextFieldScrollView;

	float initialBrowserHeight, initialTextFieldHeight;

}


- (id)initWithController:(SHCustomViewController<SHViewControllerProtocol>*)aController;

// Force a reload of column zero and thus, all the data.
- (IBAction)reloadData:(id)sender;

- (void)reloadColumn:(int)col;

- (void) layOutAtNewSize;

@end

@interface SHObjPaletteView(PrivateMethods)

- (NSBrowser *)theObjectBrowser;
- (void)setTheObjectBrowser:(NSBrowser *)aTheObjectBrowser;

- (SHInfoTextView *)theTextField;
- (void)setTheTextField:(SHInfoTextView *)aTheTextField;

- (NSScrollView *)theTextFieldScrollView;
- (void)setTheTextFieldScrollView:(NSScrollView *)atheTextFieldScrollView;


@end