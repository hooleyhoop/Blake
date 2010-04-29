/*
 *  SHTestUtilities.h
 *  SHShared
 *
 *  Created by steve hooley on 03/12/2009.
 *  Copyright 2009 BestBefore Ltd. All rights reserved.
 *
 */
#import <SHTestUtilities/OCMockRecorder_Extras.h>
#import <SHTestUtilities/TestingUtils.h>
#import <SHTestUtilities/SwappedInIvar.h>
#import <SHTestUtilities/HooSenTestProbe.h>
#import <SHTestUtilities/ApplescriptGUI.h>
#import <SHTestUtilities/NSInvocation_testHelpers.h>
#import <SHTestUtilities/ApplescriptUtils.h>
#import <SHTestUtilities/HooAsyncTestRunner.h>
#import <SHTestUtilities/AsyncTests.h>
#import <SHTestUtilities/AsyncTestProxy.h>
#import <SHTestUtilities/GUITestProxy.h>
#import <SHTestUtilities/GUI_ApplescriptTestProxy.h>
#import <SHTestUtilities/TestHelp.h>
#import <SHTestUtilities/FSBlockConviences.h>
#import <SHTestUtilities/NSInvocation_testFutures.h>
#import <SHTestUtilities/DelayedPerformer.h>

#ifndef _BLOCK
	#define _BLOCK(x) [x asBlock]
#endif
