//
//  BKConfigurationMenuExtensions.m
//  Blocks
//
//  Created by Jesse Grosjean on 1/30/05.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKConfigurationMenuExtensions.h"
#import "BKConfigurationController.h"


@implementation BKConfigurationMenuExtensions

- (void)declareMenuItems:(id <BKMenuControllerProtocol>)menuController {
	NSMenuItem *userGuide = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"User Guide", nil) action:@selector(showUserGuide:) keyEquivalent:@"?"] autorelease];
	[userGuide setTarget:[BKConfigurationController sharedInstance]];
	[menuController insertMenuItem:userGuide insertPath:@"/Help/TopGroup"];
	[menuController declareMenuItem:userGuide menuItemPath:@"/Help/UserGuideItem"];
	
	NSMenuItem *visitGroup = [NSMenuItem separatorItem];
	[menuController insertMenuItem:visitGroup insertPath:@"/Help/TopGroup"];
	[menuController declareGroupItem:visitGroup groupPath:@"/Help/VisitGroup"];
		
	NSMenuItem *webPage = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"Web Page...", nil) action:@selector(visitWebPage:) keyEquivalent:@""] autorelease];
	[webPage setTarget:[BKConfigurationController sharedInstance]];
	[menuController insertMenuItem:webPage insertPath:@"/Help/VisitGroup"];
	[menuController declareMenuItem:webPage menuItemPath:@"/Help/WebPageItem"];
	
	NSMenuItem *userForums = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"User Forums...", nil) action:@selector(visitUserForums:) keyEquivalent:@""] autorelease];
	[userForums setTarget:[BKConfigurationController sharedInstance]];
	[menuController insertMenuItem:userForums insertPath:@"/Help/VisitGroup"];
	[menuController declareMenuItem:userForums menuItemPath:@"/Help/UserForumsItem"];

	NSMenuItem *releaseNotes = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"Release Notes...", nil) action:@selector(showReleaseNotes:) keyEquivalent:@""] autorelease];
	[releaseNotes setTarget:[BKConfigurationController sharedInstance]];
	[menuController insertMenuItem:releaseNotes insertPath:@"/Help/VisitGroup"];
	[menuController declareMenuItem:releaseNotes menuItemPath:@"/Help/ReleaseNotesItem"];
	
	NSMenuItem *pluginsAndScripts = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"Find Plugins & Scripts...", nil) action:@selector(pluginsAndScripts:) keyEquivalent:@""] autorelease];
	[pluginsAndScripts setTarget:[BKConfigurationController sharedInstance]];
	[menuController insertMenuItem:pluginsAndScripts insertPath:@"/Help/VisitGroup"];
	[menuController declareMenuItem:pluginsAndScripts menuItemPath:@"/Help/PluginsAndScriptsItem"];
	
	NSMenuItem *requestNewFeatureOrReportBug = [[[NSMenuItem alloc] initWithTitle:BKLocalizedString(@"Requests & Bugs...", nil) action:@selector(requestNewFeatureOrReportBug:) keyEquivalent:@""] autorelease];
	[requestNewFeatureOrReportBug setTarget:[BKConfigurationController sharedInstance]];
	[menuController insertMenuItem:requestNewFeatureOrReportBug insertPath:@"/Help/VisitGroup"];
	[menuController declareMenuItem:requestNewFeatureOrReportBug menuItemPath:@"/Help/RequestsAndBugsItem"];
}

- (void)menuController:(id <BKMenuControllerProtocol>)menuController addedItem:(NSMenuItem *)menuItem {
}


- (void)menuControllerFinishedLoadingMenu:(id <BKMenuControllerProtocol>)menuController {
}

@end