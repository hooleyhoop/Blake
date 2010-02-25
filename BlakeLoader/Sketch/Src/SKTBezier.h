//
//  SKTBezier.h
//  BlakeLoader2
//
//  Created by steve hooley on 19/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import <SketchGraph/SKTGraphic.h>


@interface SKTBezier : SKTGraphic {

	NSBezierPath	*_path;
}

@property (retain, readwrite, nonatomic) NSBezierPath *path;

- (void)moveToPoint:(NSPoint)value;
- (void)lineToPoint:(NSPoint)value;
- (void)closePath;

- (NSPoint)startPoint;
- (NSArray *)controlPts;
- (int)countOfPoints;

@end
