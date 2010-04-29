//
//  GuiTestProxy.h
//  InAppTests
//
//  Created by steve hooley on 08/02/2010.
//  Copyright 2010 BestBefore Ltd. All rights reserved.
//
#import "AsyncTestProxy.h"

@interface GUITestProxy : AsyncTestProxy {

}

+ (GUITestProxy *)lockTestRunner;
+ (GUITestProxy *)unlockTestRunner;

#pragma mark General
+ (GUITestProxy *)wait;
+ (GUITestProxy *)doTo:(id)object selector:(SEL)method;

+ (GUITestProxy *)documentCountIs:(NSUInteger)intValue;

@end
