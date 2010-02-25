//
//  SKTGroup.h
//  BlakeLoader2
//
//  Created by steve hooley on 02/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import <SketchGraph/SKTGraphic.h>


@interface SKTGroup : SKTGraphic {

	NSMutableArray	*_groupedSceneItems;
}

- (void)addSceneItems:(NSArray *)value;
- (NSArray *)groupedSceneItems;

@end