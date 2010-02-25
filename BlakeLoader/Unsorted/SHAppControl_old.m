//
//  SHAppControl.m
//  InterfaceTest
//
//  Created by Steve Hool on Fri Dec 26 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//
#import "SHAppControl.h"
#import "SHAuxWindow.h"
//#import "PropertyInspectorControl.h"
#import "SHAuxWindow.h"
//#import "SHCustomViewController.h"
#import "SHAppModel.h"
#import "SHAppView.h"
#import "SHMainWindow.h"
//#import "SHObjPaletteControl.h"

static SHAppControl	*_appControl;

/*
 *
*/
@implementation SHAppControl


#pragma mark -
#pragma mark class methods

+ (SHAppControl*)appControl {
	return _appControl;
}

#pragma mark init methods

- (id)init
{
    if ((self = [super init]) != nil)
    {
		// init code
		logInfo(@"SHAppControl.m: initing SHAppControl");
		// NSBundle *aBundle = [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/ProKit.framework"]retain];
//		NSBundle *aBundle = [[NSBundle bundleWithPath:@"Shared.framework"]retain];	
//		if(aBundle!=nil){
//			BOOL loadResult = [aBundle load];
//			logInfo(@"SHAppControl.m: Bundle is not nil! But, has it loaded? %i", loadResult );
//			Class aProWindow = [[aBundle classNamed: @"SHPlusOperator"]retain];
//			logInfo(@"pro window superclass is %@", [aProWindow superclass] );
//			NSRect a = NSMakeRect(50, 50, 200, 200);
//			id anInstanceNSProWindow = [[aProWindow alloc]initWithContentRect:a  styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:YES ];
//			[anInstanceNSProWindow orderFront:nil];
//			[anInstanceNSProWindow setTitle:@"A Pro Window"];
//		[[anInstanceNSProWindow class] poseAsClass: [NSWindow class]];
			
//		}
		_appControl = self;
		_auxWindows	= [[NSMutableArray alloc] initWithCapacity:4];
	}
    return self;
}


- (void)dealloc
{
    [_theSHAppModel release];
    [_theSHAppView release];
    [_auxWindows release];

    _auxWindows = nil;
	_theSHAppModel = nil;
    _theSHAppView = nil;
    [super dealloc];
}


- (void)awakeFromNib
{
	// logInfo(@"SHAppControl.m: Awaking SHAppControl From Nib" );
	
	// moved to interface builder
	// theSHAppModel		= [[SHAppModel alloc] initWithController:self];
	// theSHAppView		= [[SHAppView alloc] initWithController:self];
		
//sh	[SHViewportBL setTheSHSwapableView: anSHObjPaletteView ];
//a	[SHViewportBL setTheViewController: [theSHAppModel mySHObjPaletteControl]];
	
//sh	[SHViewportTR setTheSHSwapableView: anScriptView ];
//sh	[SHViewportTR setTheViewController: [theSHAppModel theScriptControl]];
	
	//[anSHObjPaletteView setBounds:[SHViewportBL bounds]];
	//[anSHObjPaletteView setFrame:[SHViewportBL frame]];
	// [anSHObjPaletteView setFrameOrigin:NSMakePoint(0,0)];
	//[anSHObjPaletteView setBoundsOrigin:NSMakePoint(0,0)];
	// [anSHObjPaletteView setBoundsSize:NSMakeSize(200,200)];
	//[anSHObjPaletteView setFrameSize:NSMakeSize(200,200)];
	
//sh	NSRect temp = [(NSView*)anSHObjPaletteView frame];
//sh	temp.origin.x = 0;
//sh	temp.origin.y = 0;
//sh	temp.size.height = [SHViewportBL frame].size.height;
//sh	temp.size.width = [SHViewportBL frame].size.width;
//sh	[(NSView*)anSHObjPaletteView setFrame: temp];
	
//sh	temp = [(NSView*)anScriptView frame];
//sh	temp.origin.x = 0;
//sh	temp.origin.y = 0;
//sh	temp.size.height = [SHViewportTR frame].size.height;
//sh	temp.size.width = [SHViewportTR frame].size.width;
//sh	[(NSView*)anScriptView setFrame: temp];
	
	//aaa    [theSHAppView setFourView];
	

}

#pragma mark NSApplication delegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	logInfo(@"SHAppControl.m: applicationDidFinishLaunching notification ");
	// logInfo(@"SHAppControl.m: appmodel is %@", _theSHAppModel);
	
	
	[_theSHAppModel setUpApp];
}

#pragma mark action methods


- (void)launchInOwnWindow:(SHCustomViewController*)aViewController
{
	NSAssert(aViewController != nil, @"aViewController has not been instantiated in SHAppModel");

	// keep track of which windows we are launching. If a view is in a window we cant
	// Add it to a viewport, and if a view is in a viewport we cant add it to a window
	if(![aViewController isInViewPort] && ![aViewController isInWindow])
	{
		[self spawnWindow];
		//logInfo(@"SHAppControl.m: launchInOwnWindow %@", [aViewController description] );
				
		//
			[[_newestWindow viewport] setTheViewController:aViewController];
		//
		[aViewController hasBeenLaunchedInWindow];

		//logInfo(@"SHAppControl.m: launchInOwnWindow");
		[self windowAdded:_newestWindow];
		[_newestWindow setTitle:[[aViewController class] windowTitle]];
		[_newestWindow makeKeyAndOrderFront:self];
	}
}


- (void)syncAllViewsWithModel
{
	// go through all open views and call update
	// get instance of view controller from globals		
	NSDictionary* openViews = (NSDictionary*)[[SHGlobalVars globals] objectForKey:@"openViews"];
	NSEnumerator* en = [openViews objectEnumerator];
	id view;
	while ((view = [en nextObject]) != nil)
	{
		// logInfo(@"SHAppControl.m: syncAllViewsWithModel %@", view);
		[view syncWithNodeGraphModel];
	}	
}


- (void)updateAllViewPorts{
	
	[_theSHAppView updateAllViewPorts];
	//	logInfo(@"SHAppControl.m: updating all viewports");
	
	// update all windows as well
	NSEnumerator	*en;
	SHAuxWindow		*window;
	SHViewport*		viewport;
	en = [_auxWindows objectEnumerator];
	while ((window = [en nextObject]) != nil){
		viewport = [window viewport];
		[viewport reDrawContents];
	}
}

- (void)disableOpenViews
{
	NSDictionary* openViews = (NSDictionary*)[[SHGlobalVars globals] objectForKey:@"openViews"];
	NSEnumerator* en = [openViews objectEnumerator];
	id view;
	while ((view = [en nextObject]) != nil){
		[view disable];
	}	
}

- (void)enableOpenViews
{	
	NSDictionary* openViews = (NSDictionary*)[[SHGlobalVars globals] objectForKey:@"openViews"];
	NSEnumerator* en = [openViews objectEnumerator];
	id view;
	while ((view = [en nextObject]) != nil){
		[view enable];
	}	
}

- (void)spawnWindow{
	[NSBundle loadNibNamed:@"AuxWindow" owner:self];
}


@end
