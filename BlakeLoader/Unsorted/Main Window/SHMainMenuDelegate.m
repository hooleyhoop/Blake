//
//  SHMainMenuDelegate.m
//  Pharm
//
//  Created by Steve Hooley on 20/02/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHMainMenuDelegate.h"
#import "SHAppModel.h"

/*
 *
*/
@interface SHMainMenuDelegate (PrivateMethods)

- (void) updateNodeGraphMenu;

@end


/*
 * shit, we need to observe changes to the model in order for the keyboard shortcuts to work
 * It is no good just updating the menu when we track the menu 
*/
@implementation SHMainMenuDelegate

#pragma mark init methods

- (void) initBindings
{
	// this can easily get called multiple times
	if(!_isBound)
	{	
		SHNodeGraphModel* graphModel	= [SHNodeGraphModel graphModel];
		NSAssert(graphModel != nil, @"SHMainMenuDelegate.m: ERROR: There is no GraphModel To Connect to.");
		NSAssert([[SHNodeGraphModel graphModel] theCurrentNodeGroup] != nil, @"SHMainMenuDelegate.m: ERROR: There is no Current NodeGroup.");
		
		[graphModel addObserver:self forKeyPath:@"theCurrentNodeGroup" options:NSKeyValueObservingOptionNew context:NULL];
//		[graphModel addObserver:self forKeyPath:@"theCurrentNodeGroup.lastSelectedChildSHNode" options:NSKeyValueObservingOptionNew context:NULL];

		_isBound = YES;
	} 
}

- (void) unBind
{
	if(_isBound)
	{
		SHNodeGraphModel* graphModel	= [SHNodeGraphModel graphModel];
		[graphModel removeObserver:self forKeyPath:@"theCurrentNodeGroup"];
//		[graphModel removeObserver:self forKeyPath:@"theCurrentNodeGroup.lastSelectedChildSHNode"];

		// observe notifications from the model
		//NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
		//[nc removeObserver:self];
//		_isBound = NO;
	}
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// NSLog(@"SHMainMenuDelegate.m: OBSERVED KEYPATH CHANGE %@ YIPPPPPPPPPPPPPPPPPPPPPPPEE", keyPath);
	if ([keyPath isEqual:@"theCurrentNodeGroup"])
	{
		[self menuNeedsUpdate:_nodeGraphMenu];
//	} else if ([keyPath isEqual:@"theCurrentNodeGroup.lastSelectedChildSHNode"])
//	{
//		[self menuNeedsUpdate:_nodeGraphMenu];
	}
}


#pragma mark action methods

- (int)numberOfItemsInMenu:(NSMenu *)menu
{
	//NSLog(@"SHMainMenuDelegate.m: numberOfItemsInMenu %i", [menu numberOfItems] );
	return [menu numberOfItems];
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel
{
	// NSLog(@"SHMainMenuDelegate.m: menuNeedsUpdate.. menu updateItem %@ atIndex %i shouldCancel %i", item, index, shouldCancel );
	return YES;
}

- (void) menuNeedsUpdate:(NSMenu*)menu
{
	// NSLog(@"SHMainMenuDelegate.m: menuNeedsUpdate delegate is ..%@", [[NSApp mainMenu] delegate] );
    // NodeGraph menu
	if ([[menu title] isEqualToString:@"NodeGraph"]) 
	{
		[self updateNodeGraphMenu];
	}
}

// Take care of the menu shortcuts
- (BOOL)menuHasKeyEquivalent:(NSMenu *)menu forEvent:(NSEvent *)event target:(id *)target action:(SEL *)action {
	
//	NSLog(@"SHMainMenuDelegate.m: menuHasKeyEquivalent" );
	@try {
    // Get key window and its window controller
	//a    NSWindow*   keyWindow;
	//a    id          windowController;
	//a    keyWindow = [NSApp keyWindow];
	//a    windowController = [keyWindow windowController];

	// Get attributes
	unsigned int    modifierFlags;
	BOOL            optFlag, shiftFlag, commandFlag;
	NSString*       characters;
	modifierFlags	= [event modifierFlags];
	optFlag			= modifierFlags & NSAlternateKeyMask;
	shiftFlag		= modifierFlags & NSShiftKeyMask;
	commandFlag		= modifierFlags & NSCommandKeyMask;
	characters		= [event charactersIgnoringModifiers];
    // For NodeGraph menu
	if ([[menu title] isEqualToString:@"NodeGraph"])
	{
		// For cmd + 'U'
		if (!optFlag && !shiftFlag && [characters isEqualToString:@"u"]) {
			[self updateNodeGraphMenu];	// update the status of this menu item
			NSMenuItem* up = [menu itemWithTitle:@"Up"];
			if([up isEnabled]){
				return YES;
			} else { return NO; }
		}
		// For cmd + 'D'
		if (!optFlag && !shiftFlag && [characters isEqualToString:@"d"]) {
			[self updateNodeGraphMenu];	// update the status of this menu item
			NSMenuItem* down = [menu itemWithTitle:@"Down"];
			if([down isEnabled]) return YES;
			else return NO;
		}
		// For cmd + 'Delete'
		if (!optFlag && !shiftFlag && [characters isEqualToString:@""]) {
			[self updateNodeGraphMenu];	// update the status of this menu item
			NSMenuItem* deleteNode = [menu itemWithTitle:@"Delete Node"];
			if([deleteNode isEnabled]) return YES;
			else return NO;
		}

		// For cmd + 'G'
		// For cmd + shift + 'G'
		// For cmd + 'E'
		// For cmd + 'RETURN'
		// For cmd + '.'

		// For cmd + 'w'
//a        if (!optFlag && !shiftFlag && [characters isEqualToString:@"w"]) {
            // For main window controller
//a            if (windowController && [windowController isKindOfClass:[SRMainWindowController class]]) {
//a                return [windowController menuHasKeyEquivalent:menu forEvent:event target:target action:action];
//a            }
            
            // Use close window action
//a            *target = nil;
//a            *action = @selector(closeWindowAction:);
 //a           return YES;
 //a       }
        
        // For cmd + opt + 'w'
 //a       if (optFlag && !shiftFlag && [characters isEqualToString:@"w"]) {
            // Use close all windows action
 //a           *target = nil;
//a            *action = @selector(closeAllWindowsAction:);
 //a           return YES;
//a        }
	}
			} @catch (NSException *exception) {
				NSLog(@"SHMainMenuDelegate.m: ERROR Caught %@: %@", [exception name], [exception reason]);
		} @finally {
			return NO;
		}
	return NO;
}

// tedius, tedius fucking menu code
- (void) updateNodeGraphMenu
{
	@try {
	
	
	[_nodeGraphMenu setAutoenablesItems:NO];
	SHNodeGraphModel* graphmodel	= [[SHAppModel appModel] objectGraphModel];
	SHNode* currentnode = [graphmodel theCurrentNodeGroup];
	
	int no_selectedChildNodes		= [[currentnode selectedNodeIndexes] count];
	int no_selectedinterconnectors	= [[currentnode selectedInterconnectorIndexes] count];

	// can we go up
	NSMenuItem* up = [_nodeGraphMenu itemWithTitle:@"Up"];
	if([currentnode parentSHNode])
	{
		//NSLog(@"SHMainMenuDelegate.m: SETTING UP ENABLED" );
		[up setEnabled:YES];
	} else{
		//NSLog(@"SHMainMenuDelegate.m: SETTING UP DISABLED" );
		[up setEnabled:NO];
	}
	// can we go down
	NSMenuItem* down = [_nodeGraphMenu itemWithTitle:@"Down"];
	if([currentnode lastSelectedChildSHNode]!=currentnode && [[(SHNode*)[currentnode lastSelectedChildSHNode] class] allowsSubpatches]==YES)

[[childNodeGroup class] allowsSubpatches]		
		[down setEnabled:YES];
	else
		[down setEnabled:NO];
	
	// can we group
	NSMenuItem* group = [_nodeGraphMenu itemWithTitle:@"Group"];
	if(no_selectedChildNodes>0)
		[group setEnabled:YES];
	else
		[group setEnabled:NO];

	// can we ungroup
	NSMenuItem* ungroup = [_nodeGraphMenu itemWithTitle:@"Ungroup"];
	if([currentnode lastSelectedChildSHNode]!=currentnode && [(SHNode*)[currentnode lastSelectedChildSHNode] isLeaf]==NO)
		[ungroup setEnabled:YES];
	else
		[ungroup setEnabled:NO];
	
	// can we delete selected Nodes?
	NSMenuItem* deleteNode = [_nodeGraphMenu itemWithTitle:@"Delete Node"];
	NSLog(@"SHMainMenuDelegate.m: can we delete? number of interconnectors is %i", no_selectedinterconnectors);
	if([currentnode lastSelectedChildSHNode]!=currentnode && no_selectedChildNodes>0)
		[deleteNode setEnabled:YES];
	else if( no_selectedinterconnectors>0) // lastSelectedChildSHNode doesnt include interconnectors
		[deleteNode setEnabled:YES];
	else
		[deleteNode setEnabled:NO];
				
	// can we execute?
	BOOL isPlaying = [graphmodel evaluationInProgress];
	NSMenuItem* execute = [_nodeGraphMenu itemWithTitle:@"Execute currentNode"];
	if(currentnode && !isPlaying)
		[execute setEnabled:YES];
	else
		[execute setEnabled:NO];

	// can we Play?
	NSMenuItem* play	= [_nodeGraphMenu itemWithTitle:@"Play"];
	if(currentnode && !isPlaying)
		[play setEnabled:YES];
	else
		[play setEnabled:NO];
		
	// can we Stop?
	NSMenuItem* stop	= [_nodeGraphMenu itemWithTitle:@"Stop"];
	if(currentnode && isPlaying)
		[stop setEnabled:YES];
	else
		[stop setEnabled:NO];
		
			} @catch (NSException *exception) {
				NSLog(@"SHMainMenuDelegate.m: ERROR Caught %@: %@", [exception name], [exception reason]);
		} @finally {
		}
}

- (IBAction) moveUp:(id)sender
{
	//NSLog(@"SHMainMenuDelegate.m: moveUp" );
	SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	[graphmodel moveUpAlevelToParentNodeGroup];
}

- (IBAction) moveDown:(id)sender
{
	// NSLog(@"SHMainMenuDelegate.m: moveDown" );
	SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	[graphmodel moveDownAlevelIntoSelectedNodeGroup];
}

- (IBAction) groupSelected:(id)sender
{
	NSLog(@"SHMainMenuDelegate.m: groupSelected" );
	//SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	//[graphmodel moveDownAlevelIntoSelectedNodeGroup];
}

- (IBAction) unGroupSelected:(id)sender
{
	NSLog(@"SHMainMenuDelegate.m: unGroupSelected" );
	// SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	// [graphmodel moveDownAlevelIntoSelectedNodeGroup];
}

- (IBAction) deleteNode:(id)sender
{
	//NSLog(@"SHMainMenuDelegate.m: delete selected Nodes" );
	SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	[graphmodel deleteAllSelectedFromCurrentNodeGroup];
}

- (IBAction) execute:(id)sender
{
	// NSLog(@"SHMainMenuDelegate.m: execute" );
	SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	[graphmodel initEvaluationOfCurrentNodeGroup];
}

- (IBAction) play:(id)sender
{
	// NSLog(@"SHMainMenuDelegate.m: play" );
	SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	[graphmodel play];
}

- (IBAction) stop:(id)sender
{
	// NSLog(@"SHMainMenuDelegate.m: stop" );
	SHNodeGraphModel* graphmodel = [[SHAppModel appModel] objectGraphModel];
	[graphmodel stop];
}


@end
