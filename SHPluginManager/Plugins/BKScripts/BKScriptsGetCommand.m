//
//  BKScriptsGetCommand.m
//  Blocks
//
//  Created by Jesse Grosjean on 10/4/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "BKScriptsGetCommand.h"


@implementation BKScriptsGetCommand

- (id)performDefaultImplementation {
	id result = [super performDefaultImplementation];
	
	if (!result) {
		result = [NSAppleEventDescriptor descriptorWithTypeCode:'msng'];
	}
	
	return result;
}

@end
