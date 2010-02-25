//
//  MockConsumer.h
//  SHNodeGraph
//
//  Created by Steve Hooley on 25/02/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SHNodeGraph/SHAbstractOperator.h>

@interface MockConsumer : SHAbstractOperator {

	BOOL _didRender;
}

- (BOOL)didRender;
- (void)resetDidRender;

@end
