
#import "SHArrayController.h"

@interface FilteringArrayController : SHArrayController
{
    NSString	*_searchString;
	NSString	*_propertyToMatch;
//eh?	id			newObject;
}

@property (readwrite, retain, nonatomic) NSString *propertyToMatch;
@property (readwrite, retain, nonatomic) NSString *searchString;

- (void)search:(id)sender;

@end