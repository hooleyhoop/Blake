//
//  CWTalkingTimerLifeCycleExtension.h
//  Blocks SDK
//
//  Created by Jesse Grosjean on 5/27/05.
//  Copyright 2005 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BKLifecycleProtocols.h"
#import "CWTimersProtocols.h"
#import "CWUserInterfaceProtocols.h"


@interface CWTalkingTimerLifeCycleExtension : NSObject <BKLifecycleProtocol> {
	NSSpeechSynthesizer *speechSynthesizer;
}

@end
