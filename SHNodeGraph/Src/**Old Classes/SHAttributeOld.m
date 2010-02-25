//
//  SHAttribute.m
//  newInterface
//
//  Created by Steve Hooley on 03/03/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "SHAttribute.h"
#import "SHInlet.h"
#import "SHOutlet.h"
#import "SHAttribute.h"
#import "SHInputAttribute.h"
#import "SHOutputAttribute.h"
#import "SHInterConnector.h"
#import "SHNodeGroup.h"
#import "SHooleyObject.h"

@implementation SHAttribute


// ===========================================================
// - attributeName:
// ===========================================================
//- (NSString *) attributeName { return _attributeName; }

// ===========================================================
// - setAttributeName:
// ===========================================================
//- (void) setAttributeName: (NSString *) anAttributeName {
//    if (_attributeName != anAttributeName) {
//        [anAttributeName retain];
//        [_attributeName release];
//        _attributeName = anAttributeName;
//    }
//}


#pragma mark action methods

//=========================================================== 
// - forwardInvocation:
//=========================================================== 
//15/02/2006 - (void)forwardInvocation:(NSInvocation *)anInvocation
//15/02/2006 {
//15/02/2006    if ([someOtherObject respondsToSelector:
//15/02/2006            [anInvocation selector]])
//15/02/2006        [anInvocation invokeWithTarget:someOtherObject];
//15/02/2006    else
//15/02/2006        [super forwardInvocation:anInvocation];
//15/02/2006 }

#pragma mark accessor methods


//=========================================================== 
// - displayObject:
//=========================================================== 
- (id) displayObject
{
	if([_value respondsToSelector:@selector(displayObject)])
		// return [(id)[self value] stringValue];	// NB! Have to use the accessor here to make sure the value is updated
		return [(id)_value displayObject];	// trying this way which wont cause the value to update
	return @"<Not Applicable>";
}

//=========================================================== 
// - setDisplayObject:
//=========================================================== 
- (void) setDisplayObject:(id)val
{
//09/05/2006	NSLog(@"SHAttribute.m: setDisplayObject for %@. Is this ever called?", _name );

	if([[_value class] respondsToSelector:@selector(dataTypeFromDisplayObject:)])
	{
		id newVal = [[_value class] dataTypeFromDisplayObject:val];
		if(newVal!=nil)
			[self setValue:newVal];
	} else {
//09/05/2006		NSLog(@"SHAttribute.m: ERROR! trying to set attribute %@ value from display object for a datatype that doesnt support this behavoir.", _name );
	}
}




@end
