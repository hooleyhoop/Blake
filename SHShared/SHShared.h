//
//  Shared.h
//  Shared
//
//  Created by Steve Hooley on 22/10/2005.
//  Copyright 2005 HooleyHoop. All rights reserved.
//

// Surprised that the order of these is impotant?
#ifdef DEBUG
	#import <SHShared/SHooleyObject.h>
	#import <SHShared/SHInstanceCounter.h>
	#import "SHSwizzler.h"
#else
	#warning - Release Build?
#endif

#import <SHShared/SHOrderedDictionary.h>
#import <SHShared/BBLogger.h>
#import <SHShared/LogController.h>
#import <SHShared/SHDocumentController.h>
#import <SHShared/SHDocument.h>
#import <SHShared/SHWindowController.h>
#import <SHShared/SHBundleLoader.h>
#import <SHShared/FilteringArrayController.h>
#import <SHShared/MathUtilities.h>
#import <SHShared/MiscUtilities.h>
#import <SHShared/BBNibManager.h>
#import <SHShared/SHGlobalVars.h>

/* Protocols */
#import <SHShared/SHAppProtocol.h>
#import <SHShared/SHSingletonViewExtensionProtocol.h>
#import <SHShared/SHDocumentViewExtensionProtocol.h>
#import <SHShared/SHViewControllerProtocol.h>
#import <SHShared/SHOperatorProtocol.h>
#import <SHShared/SHAttributeProtocol.h>

/* Extensions */
#import <SHShared/NSObject_Extras.h>
#import <SHShared/NSSet_Extras.h>
#import <SHShared/NSString_Extras.h>
#import <SHShared/NSCharacterSet_Extensions.h>
#import <SHShared/NSIndexSet_Extras.h>
#import <SHShared/NSArray_Extensions.h>
#import <SHShared/NSResponder_Extras.h>
#import <SHShared/NSDocumentController_Extensions.h>
#import <SHShared/NSApplication_Extensions.h>

/* Util */
#import <SHShared/NSInvocation(ForwardedConstruction).h>

//#import <SHShared/SHCustomViewController.h>
//#import <SHShared/SHSwapableView.h>
//#import <SHShared/SHCustomViewProtocol.h>
//#import <SHShared/ResourceManager.h>
//#import <SHShared/SHSplitView.h>
//#import <SHShared/SHClipView.h>
//#import <SHShared/SHScrollView.h>
//#import <SHShared/SHValueProtocol.h>
//#import <SHShared/SHMutableValueProtocol.h>
//#import <SHShared/SHAppProtocol.h>
//#import <SHShared/SHNodeLikeProtocol.h>
//#import <SHShared/SHExternalTimeSourceProtocol.h>
//#import <SHShared/SHAuxWindow.h>
//#import <SHShared/SHAuxWindowDelegate.h>
//#import <SHShared/SHViewport.h>
//#import <SHShared/SHUndoManager.h>
//#import <SHShared/NSWindowController_Extras.h>
//#import <SHShared/DebugNSMutableIndexSet.h>
//#import <SHShared/SHToolbar.h>
//#import <SHShared/SHTableView.h>
//#import <SHShared/SHPanel.h>

OBJC_EXPORT void addDestructorCallback( Class classValue, SEL callback ) __attribute__((weak_import));

#ifndef INT
	#define INT(x) [NSNumber numberWithInt:x]
#endif