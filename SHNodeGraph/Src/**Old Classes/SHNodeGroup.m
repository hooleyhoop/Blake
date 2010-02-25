//
//  SHNodeGroup.m
//  newInterface
//
//  Created by Steve Hooley on 08/02/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

//#import "SHNodeGroup.h"
//#import "SHConnectlet.h"
//#import "SHSelectableProto_Node.h"
//#import "SHProto_Node.h"
//#import "SHOutputAttribute.h"
//#import "SHInputAttribute.h"
//#import "SHNode.h"
//#import "SHInterConnector.h"
//#import "SHProtoOperator.h"
//#import "SHNodeGraphModel.h";
//// #import "SHExecutableNode.h";
//#import "SHConnectableNode.h";
//#import "SHSelectableProto_Node.h";


@implementation SHNodeGroup

#pragma mark -
#pragma mark init methods

+ (void)initialize {
	[self exposeBinding:@"selectionIndexes"];
	
	// for key value obseving. Even though 'fullName' isnt an instance variable we can 
	// notify observers that it has changed when we change instance variables firstname or lastname
    // [self setKeys:[NSArray arrayWithObjects:@"firstName", @"lastName", nil] triggerChangeNotificationsForDependentKey:@"fullName"];
    // [self setKeys:[NSArray arrayWithObjects:@"nodesInside_Dict", @"inputs", @"outputs", nil] triggerChangeNotificationsForDependentKey:@"nodesAndConnectletsInside_Array"];
}


// ===========================================================
// - initWithParentNodeGroup:
// ===========================================================
- (id)initWithParentNodeGroup:(SHNodeGroup*)pNG
{
//	NSLog(@"SHNodeGroup.m: initializing ok");		
	if(self=[super initWithParentNodeGroup:pNG])
	{ 
		// NSLog(@"SHNodeGroup.m: initWithParentNodeGroup ok");
//02/02/2006		[self setHasBeenChanged:YES];
		// ** observe a value
		// [self addObserver:self forKeyPath:@"nodesInside_Dict" options:NSKeyValueObservingOptionNew context:NULL];

	} else {
		NSLog(@"SHNodeGroup: ERROR i didnt think this ever happend");
	}
	return self;
}


//=========================================================== 
// - observeValueForKeyPath:  ofObject change context
//=========================================================== 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//	if ([keyPath isEqual:@"nodesInside_Dict"])
//	{
		// NSLog(@"SHNodeGroup.m: A value has been observed!");
		//		[self setNodesInCurrentNodeGroup_Array: (NSMutableArray*)[change objectForKey:NSKeyValueChangeNewKey]];
//	}
}


#pragma mark Private Action methods

// ===========================================================
// - initInputs:
// ===========================================================
- (void)initInputs {
	// VIRTUAL
}

// ===========================================================
// - initOutputs:
// ===========================================================
- (void)initOutputs {
	// VIRTUAL
}



#pragma mark accessor methods


// ===========================================================
// - hasBeenChanged:
// ===========================================================
// called when edited
//- (BOOL) hasBeenChanged {
//	return _hasBeenChanged;
//}


// ===========================================================
// - setHasBeenChanged:
// ===========================================================
//- (void) setHasBeenChanged: (BOOL) flag {
//	_hasBeenChanged = flag;
//}



// manual binding
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
//	BOOL automatic;
//    if ([theKey isEqualToString:@"selectionIndexes"]) {
//		NSLog(@"test test test test test test test test tetst tete");
//        automatic=NO;
//    } else {
//        automatic=[super automaticallyNotifiesObserversForKey:theKey];
//    }
//    return automatic;
//}



@end