//
//  SHNode.m
//  newInterface
//
//  Created by Steve Hooley on 15/02/2005.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

//#import "SHNode.h"
//#import "SHAttribute.h"
//#import "SHInputAttribute.h"
//#import "SHOutputAttribute.h"
////#import "SHNodeGroup.h"
//// #import "SH_Path.h"
//#import "SHProto_Node.h"

@implementation SHProto_Node (SHNodeOLD) 


#pragma mark -
#pragma mark init methods
#pragma mark action methods



#pragma mark accessor methods


// ===========================================================
// - inputAttributeNamed:
// ===========================================================
//- (id<SHAttributeProtocol>)inputAttributeNamed:(NSString*)aName
//{
	// autorelease this?
	// error mesg is nil?
//	return [_inputs objectForKey:aName];	
//}


// ===========================================================
// - outputAttributeNamed:
// ===========================================================
//- (id<SHAttributeProtocol>)outputAttributeNamed:(NSString*)aName
//{
//	return [_outputs objectForKey:aName];
//}


// ===========================================================
// - inputAttribute:
// ===========================================================
// This is a bit of a hack but if you ask an attribute node for its
// attribute it needs to return itself
- (id) inputAttribute:(int)uID
{
	// Branch NSString* UIDasARString = [NSString stringWithFormat:@"%i", uID ];
	id inAttr = [_inputs objectForKey: UIDasARString];
	if(inAttr==nil){
		// NSLog(@"SHNode.m: ERROR. Cant find that input Attribute");
		if(uID==_temporaryID){
			// are we the outputAttribute we are looking for?
			if([self respondsToSelector:@selector(theConnectlet)]){
				//NSLog(@"SHNode.m: Hold on a minute, Im an input attrwibute");
				if ([self isKindOfClass: [SHOutputAttribute class]]){
					//NSLog(@"SHNode.m: That will do for me");
					return self;
				} else {
					NSLog(@"SHNode.m: FATAL ERROR: Cant get inputAttribute");
					[NSApp terminate:self];
				}
			}
		}
	}
	return inAttr;
}

// ===========================================================
// - inputAttributeWithName:
// ===========================================================
- (id) inputAttributeWithName:(NSString*)name
{
	id inAttr = [self nodeWithKey:name];
	if(inAttr==nil){
		if([name isEqualToString:_name]){
			if([self respondsToSelector:@selector(theConnectlet)]){
				if ([self isKindOfClass: [SHOutputAttribute class]]){
					return self;
				}else {
					NSLog(@"SHNode.m: FATAL ERROR: Cant get inputAttributeWithName %@", name);
					[NSApp terminate:self];
				}
			}
		}	
	} else if([[_inputs allValues] containsObject:inAttr]==nil) {
		NSLog(@"SHNode.m: FATAL ERROR: found attribute called %@ from node %@ but it isnt in the inputs array! You have em wrong way round", name, _name);
	}
	return inAttr;
}


// ===========================================================
// - outputAttribute:
// ===========================================================
// This is a bit of a hack but if you ask an attribute node for its
// attribute it needs to return itself
- (id) outputAttribute:(int)uID
{
	// Branch NSString* UIDasARString = [NSString stringWithFormat:@"%i", uID ];
	id outAttr = [_outputs objectForKey: UIDasARString];
	if(outAttr==nil){
		// NSLog(@"SHNode.m: ERROR. Cant find that output Attribute");
		if(uID==_temporaryID){
			// are we the outputAttribute we are looking for?
			if([self respondsToSelector:@selector(theConnectlet)]){
				if ([self isKindOfClass: [SHInputAttribute class]])
					return self;
			} else {
				NSLog(@"SHNode.m: FATAL ERROR: Cant get outputAttribute");
				[NSApp terminate:self];
			}
		}
	}
	return outAttr;
}

// ===========================================================
// - outputAttributeWithName:
// ===========================================================
- (id) outputAttributeWithName:(NSString*)name
{
	id outAttr = [self nodeWithKey:name];
	if(outAttr==nil){
		if([name isEqualToString:_name]){
			if([self respondsToSelector:@selector(theConnectlet)]){
				if ([self isKindOfClass: [SHInputAttribute class]]){
					return self;
				}else {
					NSLog(@"SHNode.m: FATAL ERROR: Cant get outputAttributeWithName %@", name);
					[NSApp terminate:self];
				}
			}
		}
	}
	return outAttr;
}



// ===========================================================
// - nodeFromTheNodesInside:
// ===========================================================
- (id) nodeFromTheNodesInside:(int)uID
{
	// Branch NSString* UIDasARString = [NSString stringWithFormat:@"%i", uID ];
	return [_nodesInside_Dict objectForKey: UIDasARString];
}

// ===========================================================
// - nodeFromNodesAndAttributesInside:
// ===========================================================
-(SHProto_Node*) nodeFromNodesAndAttributesInside:(int)uID
{
	// Branch NSString* UIDasARString = [NSString stringWithFormat:@"%i", uID ];
	SHProto_Node* foundNode
	foundNode = [_inputs objectForKey: UIDasARString];
	if(foundNode!=nil)
		return foundNode;
	foundNode = [_outputs objectForKey: UIDasARString];
	if(foundNode!=nil)
		return foundNode;
	foundNode = [_nodesInside_Dict objectForKey: UIDasARString];
	return foundNode;
}





@end

