//
//  SHNodeAttributeMethods.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 09/11/2006.
//  Copyright 2006 HooleyHoop. All rights reserved.
//

#import "SHNodeAttributeMethods.h"
#import "SHAttribute.h"

/*
 *
*/
@implementation SHNode (SHNodeAttributeMethods) 

#pragma mark action methods
//- (void) setContentsOfInputWithKey:(NSString*)aKey with:(id)aValue
//{
//	id inAtt = [self inputAttributeWithKey:aKey];
//	[inAtt publicSetValue:aValue];
//}

	
#pragma mark accessor methods
- (int)numberOfInputs { return [_inputs count]; }
- (int)numberOfOutputs { return [_outputs count]; }

- (id<SHAttributeProtocol>)inputAttributeAtIndex:(int)ind {
	id inAttr = [_inputs objectAtIndex:ind];
	if(inAttr==nil)
		logError(@"SHNode.m: ERRROR: There is no inputAttribute at that index.");
	return inAttr;
}

- (id<SHAttributeProtocol>)outputAttributeAtIndex:(int)ind {
	id outAttr = [_outputs objectAtIndex:ind];
	if(outAttr==nil)
		logError(@"SHNode.m: ERRROR: There is no outputAttribute at that index.");
	return outAttr;
}

- (id<SHAttributeProtocol>)inputAttributeWithKey:(NSString *)key {
	id inAttr = [_inputs objectForKey:key];
	return inAttr;
}

- (id<SHAttributeProtocol>)outputAttributeWithKey:(NSString *)key {
	id outAttr = [_outputs objectForKey:key];
	return outAttr;
}

@end
