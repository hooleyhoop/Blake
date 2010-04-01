//
//  SKTFilteringArrayControllerProvider.m
//  BlakeLoader experimental
//
//  Created by steve hooley on 20/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SKTFilteringArrayControllerProvider.h"
#import <SHShared/SHShared.h>
#import "SketchModel.h"


@implementation SKTFilteringArrayControllerProvider

#pragma mark -
#pragma mark init methods
- (id)init {
	
    if ((self = [super init]) != nil)
    {		
		[self setClassFilter:@"SKTCircle"];
		_arrayController = [[NSArrayController alloc] init];
    }
	return self;
}

- (void)dealloc {
	
	[_arrayController release];
    if(_model!=nil)
        logError(@"who did this?");
	NSAssert(_model==nil, @"you must explicitly clean up before releasing");
	
    [super dealloc];
}

- (void)cleanUpFilter {
	
	NSAssert(_model!=nil, @"unnessasary clean up");
	[self unBindGraphics];
	[self unBindSelection];
	_model = nil;
    [super cleanUpFilter];
}

- (void)registerAUser:(id)user {
    
    [super registerAUser:user];
	
 	[self addObserver:user forKeyPath:@"arrangedObjects" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial ) context:@"SKTGraphicsProvidor"];
 	[self addObserver:user forKeyPath:@"selectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial ) context:@"SKTGraphicsProvidor"];
}

- (void)unRegisterAUser:(id)user {
    
 	[self removeObserver:user forKeyPath:@"selectionIndexes"];
	[self removeObserver:user forKeyPath:@"arrangedObjects"];
	
    [super unRegisterAUser:user];
}

- (void)unBindGraphics {
	
//MOVE UP	[self stopObservingGraphics:[_model graphics]];
//old		[_model removeObserver:self forKeyPath:@"graphics"];
	[_arrayController unbind:@"graphics"];
}

- (void)unBindSelection {
	
//old	[_model removeObserver:self forKeyPath:@"selectionIndexes"];
	[_arrayController unbind:@"selectionIndexes"];
}

- (void)setModel:(SketchModel *)value {
	
	NSParameterAssert(value!=nil);
	NSAssert(_model==nil, @"Filter cannot be reused wioth a different model");
	
	_model = value;
	[_arrayController bind:@"contentArray" toObject:_model withKeyPath:@"graphics" options:nil];

//later	[_model addObserver:self forKeyPath:@"selectionIndexes" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial ) context:@"com.apple.SKTGraphicView.selectionIndexes"];
	
	// Start observing changes to the array of graphics to which we're bound, and also start observing properties of the graphics themselves that might require redrawing.

	//MOVE UP	[self startObservingGraphics:[_doc valueForKeyPath:@"sketchModel.graphics"]];
	
}

- (void)setClassFilter:(NSString *)value {
	
	NSParameterAssert(value!=nil);
	_filterType = NSClassFromString(value);
	NSAssert([NSStringFromClass(_filterType) isEqualToString:value], @"failed to set filter type");
	
	/* _arrayController set predicate */
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"class == %@", _filterType];
	[_arrayController setFilterPredicate: filterPredicate];
	[_arrayController setClearsFilterPredicateOnInsertion:NO];
}

@end

