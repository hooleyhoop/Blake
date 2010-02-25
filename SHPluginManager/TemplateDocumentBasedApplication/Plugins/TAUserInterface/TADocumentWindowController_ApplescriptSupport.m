//
//  TADocumentWindowController_ApplescriptSupport.m
//  TemplateDocumentBasedApplication
//
//  Created by Jesse Grosjean on 11/17/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TADocumentWindowController_ApplescriptSupport.h"


@implementation TADocumentWindowController (ApplescriptSupport)

#pragma mark properties

- (NSNumber *)uniqueID {
    return [NSNumber numberWithInt:[[self window] windowNumber]];
}

- (NSString *)name {
    return [[self window] title];
}

- (NSArray *)selection {
	return [NSArray array];
}

#pragma mark object specifier

- (NSScriptObjectSpecifier *)objectSpecifier {
    NSDocument *document = [self document];
	NSScriptClassDescription *containerClassDescription = [[NSScriptSuiteRegistry sharedScriptSuiteRegistry] classDescriptionWithAppleEventCode:'docu'];
	NSScriptObjectSpecifier *containerSpecifier = [document objectSpecifier];
	return [[NSUniqueIDSpecifier alloc] initWithContainerClassDescription:containerClassDescription 
													   containerSpecifier:containerSpecifier
																	  key:@"documentViewers"
																 uniqueID:[self uniqueID]];
}

@end

@implementation NSApplication (TADocumentWindowControllerApplescriptSupport)

#pragma mark properties

- (NSArray *)selection {
	id currentDocument = [[NSDocumentController sharedDocumentController] currentDocument];
	if (!currentDocument) {
		currentDocument = [[[NSDocumentController sharedDocumentController] documents] lastObject];
	}
	return [currentDocument selection];
}

#pragma mark elements

- (NSArray *)documentViewers {
    NSMutableArray *result = [NSMutableArray array];
    NSEnumerator *enumerator = [[self orderedWindows] objectEnumerator];
    id each;
    
    while (each = [[enumerator nextObject] delegate]) {
		if ([each isKindOfClass:[TADocumentWindowController class]]) {
			[result addObject:each];
		}
    }
    
    return result;
}

@end


@implementation NSDocument (TADocumentWindowControllerApplescriptSupport)

#pragma mark properties

- (NSArray *)selection {
	return [[[self documentViewers] lastObject] selection];
}

#pragma mark document viewers

- (NSArray *)documentViewers {
    NSMutableArray *result = [NSMutableArray array];
    NSEnumerator *enumerator = [[self windowControllers] objectEnumerator];
    id each;
    
    while (each = [enumerator nextObject]) {
		if ([each isKindOfClass:[TADocumentWindowController class]]) {
			[result addObject:each];
		}
    }
    
    return result;
}

- (void)insertInDocumentViewers:(TADocumentWindowController *)object {
    [self addWindowController:object];
    [[object window] orderFront:self];
}

- (void)removeFromDocumentViewersAtIndex:(unsigned)index {
    TADocumentWindowController *windowController = [[self documentViewers] objectAtIndex:index];
    [self removeWindowController:windowController];
}

@end