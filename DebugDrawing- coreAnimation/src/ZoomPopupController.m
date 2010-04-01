//
//  ZoomPopupController.m
//  DebugDrawing
//
//  Created by shooley on 31/10/2009.
//  Copyright 2009 bestbefore. All rights reserved.
//

#import "ZoomPopupController.h"
#import "ZoomController.h"

@interface ZoomPopupController ()

- (void)deselectAllItems;
- (void)cachePresetPercents;
- (void)makeSurePresetWithTitleIsSelected:(NSString *)value;

@end

@implementation ZoomPopupController

@synthesize disabledObservations = _disabledObservations;

- (id)initWithButton:(NSPopUpButton *)value {
	
	NSParameterAssert(value);

	self = [super init];
	if(self){
		_zombieButton = value;
		[self deselectAllItems];
		[self cachePresetPercents];
		[self makeSurePresetWithTitleIsSelected:@"100%"];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popupWillShow:) name:NSPopUpButtonWillPopUpNotification object:_zombieButton];

	}
	return self;
}

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSPopUpButtonWillPopUpNotification object:_zombieButton];
	[_cachedPercents release];
	[super dealloc];
}

- (void)cachePresetPercents {
	
	_cachedPercents = [[NSMutableArray array] retain];

	for( NSMenuItem *each in [_zombieButton itemArray] ){
		NSString *itemTitle = [each title];
		if( [itemTitle hasSuffix:@"%"] ){
			NSString *valueWithoutPercent = [itemTitle substringToIndex:[itemTitle length]-1];
			if( [valueWithoutPercent rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location==0 )
				[_cachedPercents addObject:valueWithoutPercent];
		}
	}
}

- (void)deselectAllItems {
	
	for( NSMenuItem *each in [_zombieButton itemArray] ){
		[each setState:NSOffState];
	}
}

- (void)popupWillShow:(NSNotification *)value {

	// -- is the text of the first item some custom value?
	NSString *firstItemTitle = [[_zombieButton itemAtIndex:0] title];
	if( [firstItemTitle hasPrefix:@"("] ){

		NSMenuItem *customItem = [_zombieButton itemAtIndex:0];
		[customItem setTitle:@"Fit All"];		
		[_zombieButton selectItemWithTitle:@"-"];
	}
}

- (BOOL)isPresetValue:(NSString *)percentage {
	
	if([_cachedPercents containsObject:percentage])
		return YES;
	return NO;
}

- (CGFloat)valueForLabel:(NSString *)value {

	// -- if last char is a percent
	if( [value hasSuffix:@"%"] && [value rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location==0 ){
		
		NSString *valueWithoutPercent = [value substringToIndex:[value length]-1];
		CGFloat percentValue = [valueWithoutPercent floatValue];
		return percentValue/100.0f;
	}

	return 1.0f;
}

- (void)makeSurePresetWithTitleIsSelected:(NSString *)value {
	
	[_zombieButton selectItemWithTitle:value];
}

#pragma mark notifications
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)vcontext {
	
	if(_disabledObservations)
		return;

	NSString *context = (NSString *)vcontext;
    if( [context isEqualToString:@"ZoomPopupController"] )
	{
        if ([keyPath isEqualToString:@"zoomValue"])
        {
			CGFloat currentZoom = [(ZoomController *)observedObject zoomValue];
			CGFloat percentage =  currentZoom*100.0f;
			NSString *percentAsString = [NSString stringWithFormat:@"%.1f", percentage];

			// -- this never really works as trailing zeros, etc. - attempt to clean it
			if([percentAsString hasSuffix:@".0"])
			   percentAsString = [percentAsString substringToIndex:[percentAsString length]-2];

			BOOL isPresetvalue = [self isPresetValue:percentAsString];
			
			if(isPresetvalue){
				
				// -- remove first custom item
				NSString *firstItemTitle = [[_zombieButton itemAtIndex:0] title];
				if( [firstItemTitle hasPrefix:@"("] ){
					NSMenuItem *customItem = [_zombieButton itemAtIndex:0];
					[customItem setTitle:@"Fit All"];		
				}
				
				NSString *percentageWithSign = [NSString stringWithFormat:@"%@%%", percentAsString];
				[self makeSurePresetWithTitleIsSelected:percentageWithSign];
				return;

			} else {

				NSMenuItem *customItem = [_zombieButton itemAtIndex:0];
				NSString *percentageWithBrackets = [NSString stringWithFormat:@"(%@%%)", percentAsString];
				[customItem setTitle:percentageWithBrackets];
				[_zombieButton selectItemAtIndex:0];
				return;
			}
		}
	}
	[super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:vcontext];
}

@end
