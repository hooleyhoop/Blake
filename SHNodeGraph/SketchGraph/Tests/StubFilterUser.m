//
//  StubFilterUser.m
//  BlakeLoader
//
//  Created by steve hooley on 02/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "StubFilterUser.h"


@implementation StubFilterUser

- (id)init {
    self = [super init];
	[self resetChangeCounts];
    return self;
}

- (void)resetChangeCounts {
	
	filteredContentChanged = NO;
    filteredContentSelectionIndexesChanged = NO;
	_filteredContentCount = 0;
	_selectionChangeCount = 0;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)observedObject change:(NSDictionary *)change context:(void *)context {
//    
//    // NSLog(@"O B S E R V I N G  C H A N G E  I N  S T U B %@, %@", context, keyPath);
//	
//    if ([(NSString *)context isEqualToString:@"NodeClassFilter"])
//	{
//        if ([keyPath isEqualToString:@"filteredContent"])
//        {
//            filteredContentChanged=YES;
//			_filteredContentCount++;
//        } else if ([keyPath isEqualToString:@"filteredContentSelectionIndexes"]) {
//            filteredContentSelectionIndexesChanged=YES;
//			_selectionChangeCount++;
//        }
//    } else {
//       [super observeValueForKeyPath:keyPath ofObject:observedObject change:change context:context];
//    }
//}

/* content */
- (void)temp_proxy:(NodeProxy *)proxy willChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
}
- (void)temp_proxy:(NodeProxy *)proxy didChangeContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {	
}

- (void)temp_proxy:(NodeProxy *)proxy willInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {
}
- (void)temp_proxy:(NodeProxy *)proxy didInsertContent:(NSArray *)proxiesForsuccessFullObjects atIndexes:(NSIndexSet *)indexes {
}

- (void)temp_proxy:(NodeProxy *)proxy willRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
}
- (void)temp_proxy:(NodeProxy *)proxy didRemoveContent:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
}

/* selection */
- (void)temp_proxy:(NodeProxy *)proxy willChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {
}

// bear in mind that indexesOfSelectedObjectsThatPassFilter is actually an array and the changed indexes are actually the first item
- (void)temp_proxy:(NodeProxy *)proxy didChangeSelection:(NSMutableIndexSet *)indexesOfSelectedObjectsThatPassFilter {	
}

- (AbtractModelFilter *)filter { return _filt; }
- (void)setFilter:(AbtractModelFilter *)value {
	_filt = value;
}

@end
