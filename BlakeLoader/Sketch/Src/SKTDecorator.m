//
//  SKTDecorator.m
//  BlakeLoader2
//
//  Created by steve hooley on 18/09/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "SKTDecorator.h"


@implementation SKTDecorator

@synthesize originalGraphic = _originalGraphic;

+ (id)decoratorForGraphic:(SKTGraphic *)aGraphic {
	
	SKTDecorator *decorator = [[[[self class] alloc] init] autorelease];
	if([aGraphic isKindOfClass:[SKTDecorator class]])
	   aGraphic = [(SKTDecorator *)aGraphic originalGraphic];
	decorator.originalGraphic = aGraphic;
	return decorator;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	
	if ([_originalGraphic respondsToSelector: aSelector])
	{
		// yes, return the delegate's method signature
		return [_originalGraphic methodSignatureForSelector: aSelector];
	} else {
		// no, return whatever NSObject would return
		return [super methodSignatureForSelector: aSelector];
	}	
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	
	// NSLog(@"Forwarding invocation from %@ to %@", self, _originalGraphic);	
	[anInvocation invokeWithTarget:_originalGraphic];
}

- (void)dealloc {
	
	self.originalGraphic = nil;
	[super dealloc];
}

- (void)drawHandleInView:(NSView *)view atPoint:(NSPoint)point {
	
    // Figure out a rectangle that's centered on the point but lined up with device pixels.
    NSRect handleBounds;
    handleBounds.origin.x = point.x - 3.0;
    handleBounds.origin.y = point.y - 3.0;
    handleBounds.size.width = 6.0;
    handleBounds.size.height = 6.0;
    handleBounds = [view centerScanRect:handleBounds];
    
    // Draw the shadow of the handle.
	//    NSRect handleShadowBounds = NSOffsetRect(handleBounds, 1.0f, 1.0f);
	//    [[NSColor controlDarkShadowColor] set];
	//    NSRectFill(handleShadowBounds);
	
    // Draw the handle itself.
    [[NSColor knobColor] set];
    NSRectFill(handleBounds);
}

@end
