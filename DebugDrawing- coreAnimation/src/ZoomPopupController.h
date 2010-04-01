//
//  ZoomPopupController.h
//  DebugDrawing
//
//  Created by shooley on 31/10/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//


@interface ZoomPopupController : NSWindowController {

	NSPopUpButton	*_zombieButton;
	BOOL			_disabledObservations;
	NSMutableArray	*_cachedPercents;
}

@property (readwrite) BOOL disabledObservations;

- (id)initWithButton:(NSPopUpButton *)value;

- (CGFloat)valueForLabel:(NSString *)value;

@end
