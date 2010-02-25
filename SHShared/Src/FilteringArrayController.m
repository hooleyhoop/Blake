
#import "FilteringArrayController.h"
#import <Foundation/NSKeyValueObserving.h>


@implementation FilteringArrayController

@synthesize propertyToMatch = _propertyToMatch;
@synthesize searchString = _searchString;

- (void)search:(id)sender {

    self.searchString = [sender stringValue];
    [self rearrangeObjects];    
}

// Set default values, and keep reference to new object -- see arrangeObjects:
//- (id)newObject {
//
//    newObject = [super newObject];
//    [newObject setValue:@"First" forKey:@"firstName"];
//    [newObject setValue:@"Last" forKey:@"lastName"];
//    return newObject;
//}

- (NSArray *)arrangeObjects:(NSArray *)objects {
	
    if( (_searchString==nil) || ([_searchString isEqualToString:@""]) ) {
//eh?		newObject = nil;
		return [super arrangeObjects:objects];   
	}
	
	/*
	 Create array of objects that match search string.
	 Also add any newly-created object unconditionally:
	 (a) You'll get an error if a newly-added object isn't added to arrangedObjects.
	 (b) The user will see newly-added objects even if they don't match the search term.
	 */
    NSMutableArray *matchedObjects = [NSMutableArray arrayWithCapacity:[objects count]];
    // case-insensitive search
    NSString *lowerSearch = [_searchString lowercaseString];
    
    for( id item in objects )
	{
		// if the item has just been created, add it unconditionally
//eh?		if (item == newObject)
//eh?		{
//eh?            [matchedObjects addObject:item];
//eh?			newObject = nil;
//eh?		}
//eh?		else
//eh?		{
			//  Use of local autorelease pool here is probably overkill, but may be useful in a larger-scale application.
			NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
			NSString *lowerName = [[item valueForKeyPath:_propertyToMatch] lowercaseString];
			if ([lowerName rangeOfString:lowerSearch].location != NSNotFound)
			{
				[matchedObjects addObject:item];
			}
			else
			{
				lowerName = [[item valueForKeyPath:@"classAsString"] lowercaseString];
				if( [lowerName rangeOfString:lowerSearch].location != NSNotFound )
				{
					[matchedObjects addObject:item];
				}
			}
			[pool release];
//eh?		}
    }
    return [super arrangeObjects:matchedObjects];
}

- (void)dealloc {

	[_propertyToMatch release];
	[_searchString release];
    [super dealloc];
}


@end