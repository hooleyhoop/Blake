//
//  SKTFilteringArrayControllerProvider.h
//  BlakeLoader experimental
//
//  Created by steve hooley on 20/06/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SHContentProvidorProtocol.h"
#import "AbtractModelFilter.h"

@class BlakeDocument, SKTGraphicView, SKTGraphic;

@interface SKTFilteringArrayControllerProvider : AbtractModelFilter <SHContentProvidorProtocol> {

	@public
	NSArrayController	*_arrayController;
	Class				_filterType;

}

- (void)setClassFilter:(NSString *)value;

@end
