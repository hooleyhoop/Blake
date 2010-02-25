//
//  main.m
//  TemplateApplication
//
//  Created by Jesse Grosjean on 12/17/04.
//  Copyright Hog Bay Software 2004. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>


int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[NSApplication sharedApplication];
    [[BKPluginRegistry sharedInstance] scanPlugins];
    [[BKPluginRegistry sharedInstance] loadMainExtension];
	[pool release];
    
    return NSApplicationMain(argc,  (const char **) argv);
}
