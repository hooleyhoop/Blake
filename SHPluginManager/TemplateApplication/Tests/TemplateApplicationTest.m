//
//  TemplateApplicationTest.m
//  TemplateApplication
//
//  Created by Jesse Grosjean on 12/8/04.
//  Copyright 2004 Hog Bay Software. All rights reserved.
//

#import "TemplateApplicationTest.h"


@implementation TemplateApplicationTest

- (void)setUp {
	static BOOL isPluginsLoaded = NO;
	if (!isPluginsLoaded) {
		[[BKPluginRegistry sharedInstance] scanPlugins];
		[[BKPluginRegistry sharedInstance] loadMainExtension];
		isPluginsLoaded = YES;
	}
}

- (void)tearDown {
}

- (void)testTrue {
	STAssertTrue(YES, @"");
}

- (void)testKimchBarkLoaded {
	STAssertNotNil([[BKPluginRegistry sharedInstance] pluginFor:@"uk.co.Hooley.kimchibark"], @"");
}

@end
