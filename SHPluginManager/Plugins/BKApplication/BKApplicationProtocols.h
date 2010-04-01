//
//  BKApplicationProtocols.h
//  Blocks
//
//  Created by Jesse Grosjean on 4/1/06.
//  Copyright 2006 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Blocks/Blocks.h>

@interface NSWindow (BKApplicationAdditions)

- (void)commitFieldEditor;
- (void)commitFieldEditorIfOwnedBy:(NSView *)view;

@end

@interface NSView (BKApplicationAdditions)

- (BOOL)isInActiveResponderChain;

@end

@interface NSImage (BKApplicationAdditions)

+ (NSImage *)imageNamed:(NSString *)name class:(Class)aClass;
- (NSImage *)imageWithBadge:(NSImage *)badge;

@end

@interface NSBezierPath (BKApplicationAdditions)

+ (NSBezierPath *)bezierPathWithRoundRectInRect:(NSRect)rect radius:(float)radius;

@end

@interface NSPopUpButton (BKApplicationAdditions)

- (void)selectItemWithRepresentedObject:(id)representedObject;

@end

@interface NSMenu (BKApplicationAdditions)

- (void)addItems:(NSArray *)menuItems;
- (void)removeItems:(NSArray *)menuItems;
- (void)sortMenuItemsUsingDescriptors:(NSArray *)sortDescriptors;
- (id <NSMenuItem>)itemWithRepresentedObject:(id)representedObject;
- (int)indexOfFirstSeparator;
- (NSRange)rangeOfNamedGroup:(NSString *)namedGroup;
- (NSRange)rangeOfNamedGroup:(NSString *)namedGroup useAdditionsGroupIfNoNamedGroup:(BOOL)useAdditionsGroup createAdditionsGroupIfNeeded:(BOOL)createAdditionsGroup;
- (void)removeAllItemsInNamedGroup:(NSString *)namedGroup;

@end

@interface NSTextView (BKApplicationAdditions)

- (NSRange)visibleRange;
- (void)insertString:(NSString *)string;
- (void)insertAttributedString:(NSAttributedString *)attributedString;
- (IBAction)insertDate:(id)sender;
- (IBAction)insertTime:(id)sender;
- (IBAction)insertDateAndTime:(id)sender;

@end

@interface NSDocumentController (BKApplicationAdditions)

- (id)openNewDocumentAndSaveAs:(NSURL *)absoluteURL display:(BOOL)display error:(NSError **)outError;
- (id)frontmostDocument;

@end

@interface NSDocument (BKApplicationAdditions)

- (id)frontmostWindowController;

@end
	