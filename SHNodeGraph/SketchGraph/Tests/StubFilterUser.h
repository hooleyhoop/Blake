//
//  StubFilterUser.h
//  BlakeLoader
//
//  Created by steve hooley on 02/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <SHNodeGraph/SHContentProvidorProtocol.h>

@interface StubFilterUser : _ROOT_OBJECT_ <SHContentProviderUserProtocol> {

	@public
    BOOL filteredContentChanged;
    BOOL filteredContentSelectionIndexesChanged;
	int _filteredContentCount;
	int _selectionChangeCount;
	
	id _filt;
}

- (void)resetChangeCounts;

- (AbtractModelFilter *)filter;
- (void)setFilter:(AbtractModelFilter *)value;

@end
