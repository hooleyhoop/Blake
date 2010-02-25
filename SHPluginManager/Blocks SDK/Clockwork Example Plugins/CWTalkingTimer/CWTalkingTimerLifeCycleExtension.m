//
//  CWTalkingTimerLifeCycleExtension.m
//  Blocks SDK
//
//  Created by Jesse Grosjean on 5/27/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import "CWTalkingTimerLifeCycleExtension.h"


@implementation CWTalkingTimerLifeCycleExtension

- (id)init {
	if (self = [super init]) {
		speechSynthesizer = [[NSSpeechSynthesizer alloc] init];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[speechSynthesizer release];
	[super dealloc];
}

- (void)applicationLaunching {
}

- (void)applicationWillFinishLaunching {
}

- (void)applicationDidFinishLaunching {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationIconUpdated:) name:CWUserInterfaceApplicationIconDidChangeNotification object:nil];
}

- (void)applicationWillTerminate {
}

- (void)applicationIconUpdated:(NSNotification *)notification {
	if ([[NSApp selectedTimer] running]) {
		int time = [[NSApp userInterfaceController] applicationIconTimeNumber];
		[speechSynthesizer startSpeakingString:[NSString stringWithFormat:@"%i", time]];
	}
}

@end