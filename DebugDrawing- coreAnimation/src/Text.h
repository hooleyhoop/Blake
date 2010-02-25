//
//  Text.h
//  DebugDrawing
//
//  Created by steve hooley on 28/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "Graphic.h"

@interface Text : Graphic {

	NSTextStorage *_contents;
}

- (NSTextStorage *)contents;

@end
