#import "ColorView.h"


@implementation ColorView

@synthesize backgroundColor = mBackgroundColor;

- (id)initWithFrame:(NSRect)theFrame
{
	if(![super initWithFrame:theFrame])
		return nil;
		
	[self setBackgroundColor:[NSColor colorWithDeviceWhite:.8 alpha:1]];
	
	return self;
}

- (void)dealloc
{
	[mBackgroundColor release];
	[super dealloc];
}

- (void)drawRect:(NSRect)TheRect 
{
    [[self backgroundColor] set];
	[NSBezierPath fillRect:[self bounds]];
}

-(BOOL)acceptsFirstResponder
{
	return YES;
}

@end
