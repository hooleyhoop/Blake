//
//  EditingToolProtocol.h
//  DebugDrawing
//
//  Created by shooley on 12/09/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

@class CALayerStarView, SHNode;
@protocol MouseInputAdaptorProtocol;

/*
 *
*/
@protocol EditingToolProtocol

- (NSString *)identifier;

//- (IBAction)selectToolAction:(id)sender;
//- (void)toolWillBecomeUnActive;

//- (SHNode *)nodeUnderPoint:(NSPoint)pt;

@end

/*
 *
 */
@protocol EditingToolIconProtocol <MouseInputAdaptorProtocol>

- (void)setUpToolbarItem:(NSToolbarItem *)item;

- (IBAction)selectToolAction:(id)sender;

- (void)toolWillBecomeActive;
- (void)toolWillBecomeUnActive;

@end