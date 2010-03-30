//
//  BBNibManager.m
//  BBNibManager
//
//  Created by Steven Hooley on 28/06/2007.
//  Copyright 2007 Best Before. All rights reserved.
//

#import "BBNibManager.h"
#import <Appkit/NSNib.h>
#import <SHShared/BBLogger.h>

static NSMutableDictionary *cachedNibs=nil;

/*
 *
*/
@implementation BBNibManager
#pragma mark -
#pragma mark class methods
+ (void)initialize  {
	
    static BOOL isInitialized = NO;
    if( !isInitialized ) {
        isInitialized = YES;	
		if(cachedNibs==nil)
			cachedNibs = [[NSMutableDictionary alloc] init];
	}
}

+ (id)instantiateNib:(NSString *)nibName withOwner:(id)owner {
	return [[[BBNibManager alloc] initWithNibName:nibName withOwner:owner] autorelease];
}

+ (id)instantiateNib:(NSString *)nibName fromBundle:(NSBundle *)bundle withOwner:(id)owner {
	return [[[BBNibManager alloc] initWithNibName:nibName fromBundle:bundle withOwner:owner] autorelease];
}

#pragma mark init methods
- (id)initWithNibName:(NSString *)nibName withOwner:(id)owner {

	NSBundle *ownerBundle = [NSBundle bundleForClass:[owner class]];
	if ((self = [self initWithNibName:nibName fromBundle:ownerBundle withOwner:owner ]) != nil) {

	}
	return self;
}

- (id)initWithNibName:(NSString *)nibName fromBundle:(NSBundle *)bundle withOwner:(id)owner {

	NSParameterAssert(nibName);

	self=[super init];
	if( self ) {
	
		NSMutableArray *tlo=nil;
		NSNib* nib = [cachedNibs objectForKey:nibName];

		/* cache nib loading */
		if(nib==nil){
			nib = [[[NSNib alloc] initWithNibNamed:nibName bundle:bundle] autorelease];
			if(!nib){
				for( NSBundle *each in [NSBundle allBundles] ){
					nib = [[[NSNib alloc] initWithNibNamed:nibName bundle:each] autorelease];
					if(nib)
						break;
				}
				if(!nib)
					[NSException raise:@"CANT FIND NIB in that Bundle" format:@""];
			}
			
			NSAssert(cachedNibs, @"need cachedNibs");
			NSAssert(nib, @"need nib");
			NSAssert(nibName, @"need name");

			[cachedNibs setObject:nib forKey:nibName];
		}
		
		[nib instantiateNibWithOwner:owner topLevelObjects:&tlo];

		if( [tlo count] == 0 )
		{
			logError(@"%@: Couldn't find NIB file \"%@.nib\".", NSStringFromClass([owner class]), nibName);
			[self autorelease];
			return nil;
		} else {
			[tlo makeObjectsPerformSelector: @selector(release)];
			[self setTopLevelObjects:tlo];
		}
	}
	return self;
}

- (void)dealloc
{
	[self setTopLevelObjects:nil];
	[super dealloc];
}	

#pragma mark accessor methods

- (NSMutableArray *)topLevelObjects
{ return _topLevelObjects; }

- (void)setTopLevelObjects:(NSMutableArray *)value
{
	if(value!=_topLevelObjects){
		[_topLevelObjects release];
		_topLevelObjects = [value retain];
	}
}



@end
