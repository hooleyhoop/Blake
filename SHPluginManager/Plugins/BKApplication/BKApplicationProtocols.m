//
//  BKApplicationProtocols.m
//  Blocks
//
//  Created by Jesse Grosjean on 4/1/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import "BKApplicationProtocols.h"

@implementation NSWindow (BKApplicationAdditions)

- (void)commitFieldEditor {
    [self commitFieldEditorIfOwnedBy:nil];
}

- (void)commitFieldEditorIfOwnedBy:(NSView *)view {
    id firstResponder = [self firstResponder];
    if ([firstResponder isKindOfClass:[NSText class]]) {
		if ([firstResponder isFieldEditor]) {
			BOOL reallyCommit = view == nil ? YES : NO;
			
			NSView *superview = [(NSView *)firstResponder superview];
			
			while (superview != nil && ![superview isKindOfClass:[NSTableView class]]) {
				if (superview == view) reallyCommit = YES;
				superview = [superview superview];
			}
			
			if (superview == view) reallyCommit = YES;
			
			if (reallyCommit) {
				[self makeFirstResponder:self];
				[self makeFirstResponder:superview];
			}
		}
    }
}

@end

@implementation NSView (BKApplicationAdditions)

- (BOOL)isInActiveResponderChain {
    id window = [self window];
    
    if (![window isMainWindow]) return NO;
    if (![window isKeyWindow]) return NO;
    
    if ([window firstResponder] == self) {
		return YES;
    } else {
		NSResponder *each = [window firstResponder];
		while (each != nil && each != window) { 
			// each != window shouldn't be neccessary, but very occasionally Forest seems to suffer a problem where an
			// BKOutlineView is asked to draw as it's view adapter is removed, and in this case [window nextResponder] seems to
			// be returning garbage.
			if (each == self) {
				return YES;
			}
			each = [each nextResponder];
		}
    }
    
    return NO;
}

@end

@implementation NSImage (BKApplicationAdditions)

+ (NSImage *)imageNamed:(NSString *)name class:(Class)aClass {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    NSImage *result = [[[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:name]] autorelease];
    if (!result) {
		result = [NSImage imageNamed:name];
    }
    return result;
}

- (NSImage *)imageWithBadge:(NSImage *)badge {
	static NSMutableDictionary *imageCache = nil;
	
	if (!imageCache) {
		imageCache = [[NSMutableDictionary alloc] init];	
	}
	
	NSValue *imageKey = [NSValue valueWithPointer:self];
	NSValue *badgeKey = [NSValue valueWithPointer:badge];
	
	NSMutableDictionary *badgeCache = [imageCache objectForKey:imageKey];
	
	if (!badgeCache) {
		badgeCache = [[NSMutableDictionary alloc] init];
		[imageCache setObject:badgeCache forKey:imageKey];
	}
	
	NSImage *badgedImage = [badgeCache objectForKey:badgeKey];
	
	if (!badgedImage) {
		badgedImage = [[self copy] autorelease];
		[badgedImage lockFocus];
		[badge compositeToPoint:NSMakePoint(0,0) operation:NSCompositeSourceOver];
		[badgedImage unlockFocus];
		
		[badgeCache setObject:badgedImage forKey:badgeKey];
	}
	
    return badgedImage;
}

@end

NSPoint centerOfRect(NSRect rect) { return NSMakePoint(NSMidX(rect), NSMidY(rect)); }
NSPoint topCenterOfRect(NSRect rect) { return NSMakePoint(NSMidX(rect), NSMaxY(rect)); }
NSPoint topLeftOfRect(NSRect rect) { return NSMakePoint(NSMaxX(rect), NSMaxY(rect)); }
NSPoint topRightOfRect(NSRect rect) { return NSMakePoint(NSMinX(rect), NSMaxY(rect)); }
NSPoint leftCenterOfRect(NSRect rect) { return NSMakePoint(NSMinX(rect), NSMidY(rect)); }
NSPoint bottomCenterOfRect(NSRect rect) { return NSMakePoint(NSMidX(rect), NSMinY(rect)); }
NSPoint bottomLeftOfRect(NSRect rect) { return rect.origin; }
NSPoint bottomRightOfRect(NSRect rect) { return NSMakePoint(NSMidX(rect), NSMinY(rect)); }
NSPoint rightCenterOfRect(NSRect rect)  { return NSMakePoint(NSMidX(rect), NSMidY(rect)); }

@implementation NSBezierPath (BKApplicationAdditions)

+ (NSBezierPath *)bezierPathWithRoundRectInRect:(NSRect)rect radius:(float)radius {
	NSBezierPath *path;
	//	float radius = 9.0;    // looks good
	NSPoint topLeft, topRight, bottomRight, bottomLeft, startPoint;
	
	topLeft = NSMakePoint( rect.origin.x, rect.origin.y );
	topRight = NSMakePoint( topLeft.x + rect.size.width, topLeft.y );
	bottomRight = NSMakePoint( topRight.x, topRight.y + rect.size.height 
							   );
	bottomLeft = NSMakePoint( topLeft.x, bottomRight.y );
	startPoint = NSMakePoint( topLeft.x, topLeft.y + radius );
	
	path = [NSBezierPath bezierPath];
	[path moveToPoint:startPoint];
	
	[path appendBezierPathWithArcFromPoint:topLeft toPoint:topRight radius:radius];
	[path appendBezierPathWithArcFromPoint:topRight toPoint:bottomRight radius:radius];
	[path appendBezierPathWithArcFromPoint:bottomRight toPoint:bottomLeft radius:radius];
	[path appendBezierPathWithArcFromPoint:bottomLeft toPoint:topLeft radius:radius];
	[path closePath];
	
	return path;
}

@end

@implementation NSPopUpButton (BKApplicationAdditions)

- (void)selectItemWithRepresentedObject:(id)representedObject {
	NSEnumerator *enumerator = [[self itemArray] objectEnumerator];
	NSMenuItem *each;
	
	while (each = [enumerator nextObject]) {
		if ([each representedObject] == representedObject) {
			[self selectItem:each];
			return;
		}
	}
}

@end

@implementation NSMenu (BKApplicationAdditions)

- (void)addItems:(NSArray *)menuItems {
    NSEnumerator *enumerator = [menuItems objectEnumerator];
    id each;
    
    while (each = [enumerator nextObject]) {
		[self addItem:each];
    }
}

- (void)removeItems:(NSArray *)menuItems {
    NSEnumerator *enumerator = [menuItems objectEnumerator];
    id each;
    
    while (each = [enumerator nextObject]) {
		[self removeItem:each];
    }
}

- (void)sortMenuItemsUsingDescriptors:(NSArray *)sortDescriptors {
	NSArray *menuItems = [[[self itemArray] copy] autorelease];
	[self removeItems:menuItems];
	[self addItems:[menuItems sortedArrayUsingDescriptors:sortDescriptors]];
}

- (id <NSMenuItem>)itemWithRepresentedObject:(id)representedObject {
	NSEnumerator *enumerator = [[self itemArray] objectEnumerator];
	NSMenuItem *each;
	
	
	while (each = [enumerator nextObject]) {
		if ([[each representedObject] isEqualTo:representedObject]) return each;
	}
	
	return nil;
}

- (int)indexOfFirstSeparator {
	NSEnumerator *enumerator = [[self itemArray] objectEnumerator];
	NSMenuItem *each;
	int index = 0;
	
	while (each = [enumerator nextObject]) {
		if ([each isSeparatorItem]) return index;
		index++;
	}
	
	return -1;
}

- (NSRange)rangeOfNamedGroup:(NSString *)namedGroup {
	return [self rangeOfNamedGroup:namedGroup useAdditionsGroupIfNoNamedGroup:NO createAdditionsGroupIfNeeded:NO];
}

- (NSRange)rangeOfNamedGroup:(NSString *)namedGroup useAdditionsGroupIfNoNamedGroup:(BOOL)useAdditionsGroup createAdditionsGroupIfNeeded:(BOOL)createAdditionsGroup {
    NSRange rangeOfTopGroup = NSMakeRange(0, NSNotFound);
    NSRange rangeOfNamedGroup = NSMakeRange(NSNotFound, NSNotFound);
    NSRange rangeOfAdditionsGroup = NSMakeRange(NSNotFound, NSNotFound);
    int count = [self numberOfItems];
    int i;
	
    BOOL lookingForEndOfAdditionsGroup = NO;
    BOOL lookingForEndOfNamedGroup = NO;
    BOOL lookingForEndOfTopGroup = [namedGroup isEqual:@"TopGroup"] ? YES : NO;
    
    for (i = 0; i < count; i++) {
		NSMenuItem *eachItem = [self itemAtIndex:i];
		if ([eachItem isSeparatorItem]) {
			if (rangeOfTopGroup.length == NSNotFound) {
				rangeOfTopGroup.length = i;
				
				if (lookingForEndOfTopGroup) {
					return rangeOfTopGroup; // found full range of named group, return
				}
			}
			
			if (lookingForEndOfAdditionsGroup) {
				rangeOfAdditionsGroup.length = i - rangeOfAdditionsGroup.location;
				lookingForEndOfAdditionsGroup = NO;
			}
			
			if (lookingForEndOfNamedGroup) {
				rangeOfNamedGroup.length = i - rangeOfNamedGroup.location;
				lookingForEndOfNamedGroup = NO;
				return rangeOfNamedGroup; // found full range of named group, return
			}
			
			NSString *groupName = [eachItem representedObject];
			
			if (!groupName) {
				logWarn(([NSString stringWithFormat:@"found unamed separator in %@", self]));
			} else if ([groupName isEqual:@"AdditionsGroup"]) {
				rangeOfAdditionsGroup.location = i + 1;
				lookingForEndOfAdditionsGroup = YES;
			} else if ([groupName isEqual:namedGroup]) {
				rangeOfNamedGroup.location = i + 1;
				lookingForEndOfNamedGroup = YES;
			}
		}
    }
    
    if (lookingForEndOfTopGroup) {
		rangeOfTopGroup.length = count;
		return rangeOfTopGroup;
    }
	
    if (useAdditionsGroup && rangeOfNamedGroup.location == NSNotFound) {
		if (![namedGroup isEqual:@"AdditionsGroup"]) {
			logWarn(([NSString stringWithFormat:@"didn't find named group %@, trying to add to additions group", namedGroup]));
		}
		
		if (rangeOfAdditionsGroup.location == NSNotFound) {
			if (!createAdditionsGroup) {
				return NSMakeRange(NSNotFound, NSNotFound);
			}
			
			logInfo(([NSString stringWithFormat:@"didn't find additions group in menu %@, adding to end of menu", self]));
			NSMenuItem *additionsGroup = [NSMenuItem separatorItem];
			[additionsGroup setRepresentedObject:@"AdditionsGroup"];
			[self addItem:additionsGroup];
			rangeOfAdditionsGroup.location = count + 1;
			rangeOfAdditionsGroup.length = 0;
			return rangeOfAdditionsGroup; // return addtions range after creating it
		} else if (rangeOfAdditionsGroup.length == NSNotFound) {
			rangeOfAdditionsGroup.length = count - rangeOfAdditionsGroup.location;
			return rangeOfAdditionsGroup; // return additions range after finding end
		} else {
			return rangeOfAdditionsGroup; // return addtions range.
		}
	} else {
		if (rangeOfNamedGroup.location != NSNotFound) rangeOfNamedGroup.length = count - rangeOfNamedGroup.location;
		return rangeOfNamedGroup; // found end of named group, return
    }
}

- (void)removeAllItemsInNamedGroup:(NSString *)namedGroup {
	NSRange range = [self rangeOfNamedGroup:namedGroup];
	if (range.location != NSNotFound) {
		int i = NSMaxRange(range);
		while (i > range.location) {
			[self removeItemAtIndex:--i];
		}
	}
}

@end

@implementation NSTextView (BKApplicationAdditions)

- (NSRange)visibleRange {
    NSRect visibleRect = [self visibleRect];
    NSLayoutManager *lm = [self layoutManager];
    NSTextContainer *tc = [self textContainer];
    
    NSRange glyphVisibleRange = [lm glyphRangeForBoundingRect:visibleRect inTextContainer:tc];;
    NSRange visibleRange = [lm characterRangeForGlyphRange:glyphVisibleRange  actualGlyphRange:nil];
    return visibleRange;
}

- (void)insertString:(NSString *)string {
    if ([self shouldChangeTextInRange:[self selectedRange] replacementString:string]) {
		[[self textStorage] replaceCharactersInRange:[self selectedRange] withString:string];
		[self didChangeText];
    }    
}

- (void)insertAttributedString:(NSAttributedString *)attributedString {
    if ([self shouldChangeTextInRange:[self selectedRange] replacementString:[attributedString string]]) {
		[[self textStorage] replaceCharactersInRange:[self selectedRange] withAttributedString:attributedString];
		[self didChangeText];
	}
}

- (IBAction)insertDate:(id)sender {
    NSString *dateFormat = [[NSUserDefaults standardUserDefaults] stringForKey:NSDateFormatString];
    NSString *dateString = [[NSCalendarDate calendarDate] descriptionWithCalendarFormat:dateFormat];
    NSUndoManager *undoManager = [self undoManager];
    [undoManager beginUndoGrouping];
    [self insertString:dateString];
    [undoManager endUndoGrouping];
    [undoManager setActionName:BKLocalizedString(@"Insert Date", nil)];
}

- (IBAction)insertTime:(id)sender {
    NSString *timeFormat = [[NSUserDefaults standardUserDefaults] stringForKey:NSTimeFormatString];
    NSString *timeString = [[NSCalendarDate calendarDate] descriptionWithCalendarFormat:timeFormat];
    NSUndoManager *undoManager = [self undoManager];
    [undoManager beginUndoGrouping];
    [self insertString:timeString];
    [undoManager endUndoGrouping];
    [undoManager setActionName:BKLocalizedString(@"Insert Time", nil)];
}

- (IBAction)insertDateAndTime:(id)sender {
    NSString *timeDateFormat = [[NSUserDefaults standardUserDefaults] stringForKey:NSTimeDateFormatString];
    NSString *timeDateString = [[NSCalendarDate calendarDate] descriptionWithCalendarFormat:timeDateFormat];
    NSUndoManager *undoManager = [self undoManager];
    [undoManager beginUndoGrouping];
    [self insertString:timeDateString];
    [undoManager endUndoGrouping];
    [undoManager setActionName:BKLocalizedString(@"Insert Date & Time", nil)];
}

@end

@implementation NSDocumentController (BKApplicationAdditions)

- (id)openNewDocumentAndSaveAs:(NSURL *)absoluteURL display:(BOOL)display error:(NSError **)outError {
	id document = [self makeUntitledDocumentOfType:[self defaultType] error:outError];
	
	if (document) {
		NSString *path = [absoluteURL path];
		NSString *directory = [path stringByDeletingLastPathComponent];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		BOOL isDirectory;
		
		if (![fileManager fileExistsAtPath:directory isDirectory:&isDirectory] || !isDirectory) {
			if (![fileManager createDirectoryAtPath:directory attributes:nil]) {
				return nil;
			}
		}
		
		[self addDocument:document];
		
		if (![document saveToURL:absoluteURL ofType:[self defaultType] forSaveOperation:NSSaveOperation error:outError]) {
			[self removeDocument:document];
			return nil;
		}
		
		if (display) {
			[document makeWindowControllers];
			[document showWindows];
		}
	}
	
	return document;
}

- (id)frontmostDocument {
	id result = [self currentDocument];
	
	if (result) {
		return result;
	}
	
	NSArray *orderedWindows = [NSApp orderedWindows];
	NSEnumerator *documentEnumerator = [[self documents] objectEnumerator];
	NSDocument *eachDocument;
	int resultIndex = 0;
	
	while (eachDocument = [documentEnumerator nextObject]) {
		NSWindowController *windowController = [eachDocument frontmostWindowController];
		if (!result || [orderedWindows indexOfObject:[windowController window]] < resultIndex) {
			result = eachDocument;
			resultIndex = [orderedWindows indexOfObject:[windowController window]];
		}
	}
	
	return result;
}

@end

@implementation NSDocument (BKApplicationAdditions)

- (id)frontmostWindowController {
	NSArray *orderedWindows = [NSApp orderedWindows];
	NSEnumerator *enumerator = [[self windowControllers] objectEnumerator];
	id windowController = nil;
	int resultIndex = 0;
	id result = nil;
	
	while (windowController = [enumerator nextObject]) {
		if (!result || [orderedWindows indexOfObject:[windowController window]] < resultIndex) {
			result = windowController;
			resultIndex = [orderedWindows indexOfObject:[result window]];
		}
	}
	
	return result;
}

@end