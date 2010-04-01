//
//  BKScriptsSetCommand.m
//  Blocks
//
//  Created by Jesse Grosjean on 10/4/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "BKScriptsSetCommand.h"


@implementation BKScriptsSetCommand

- (id)performDefaultImplementation {
	NSDictionary *args = [self evaluatedArguments];
	OSType typeCodeValue = [args count] == 1 ? [[args objectForKey:@"Value"]typeCodeValue] : 0;
	
	if(typeCodeValue == 'null' || typeCodeValue == 'msng') {
		id receivers = [self evaluatedReceivers];
		if(receivers) {
			NSString *key = [[self directParameter]key];
			if([key length]) {
				[receivers setValue:nil forKey:key];
				return nil;
			}
		}
	}
	return [super performDefaultImplementation];
}

@end
