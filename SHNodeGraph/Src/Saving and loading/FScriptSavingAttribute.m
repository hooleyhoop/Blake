//
//  FScriptSavingAttribute.m
//  SHNodeGraph
//
//  Created by Steven Hooley on 10/09/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import "FScriptSavingAttribute.h"
#import "SavingSHAttribute.h"

/* Input values from feedback loops are not saved */

@implementation SHAttribute (FScriptSavingAttribute) 

//=========================================================== 
//  fScriptString_duplicate 
//=========================================================== 
- (NSString *)fScriptString_duplicate
{
	// save the data type and value
	NSString* outputString = [NSString string];
	NSString* saveName = [self saveName];

	outputString = [outputString stringByAppendingFormat:@"\"building attribute.. %@\"\n", [self name] ];
	
	// attribute = [[SHAttribute alloc] init]
	outputString = [outputString stringByAppendingFormat:@"%@ := %@ makeAttribute .\n", saveName, [self class]];
	// [[attribute setName:@"an attribute"]
	outputString = [outputString stringByAppendingFormat:@"%@ setName:'%@' .\n", saveName, [self name]];

	outputString = [outputString stringByAppendingFormat: [self fScriptString_duplicateContentsInto: saveName restoreState:YES] ];
	
	outputString = [outputString stringByAppendingFormat:@"%@ . \n", saveName];

	return outputString;
}


//=========================================================== 
// - fScriptString_duplicateContentsInto 
//=========================================================== 
- (NSString *)fScriptString_duplicateContentsInto:(NSString *)nodeIdentifier_fscript restoreState:(BOOL)restoreFlag
{
	// Obviously, nodeIdentifier_fscript MUST be the same type as self
	NSString* outputString = [NSString string];
	NSString* saveName = nodeIdentifier_fscript;

	// append the dataTypes displayString
	NSString* as=[(<SHValueProtocol>)_value fScriptSaveString];
	NSAssert(as!=nil, @"er, nil string");
	outputString = [outputString stringByAppendingString: as];	
	// [[attribute setDataType:@"SHString" withValue]
	if(restoreFlag)
		outputString = [outputString stringByAppendingFormat:@"%@ setDataType:'%@' withValue:%@ .\n", saveName, [self dataType], @"dataValue"];
	else 
		outputString = [outputString stringByAppendingFormat:@"%@ setDataType:'%@' .\n", saveName, [self dataType]];
	return outputString;
}



//=========================================================== 
//  fScriptString_duplicateWithoutValue 
//=========================================================== 
- (NSString *)fScriptString_duplicateWithoutValue
{			
	// save the data type and value
	NSString* outputString = [NSString string];
	NSString* saveName = [self saveName];

	outputString = [outputString stringByAppendingFormat:@"\"building attribute.. %@\"\n", [self name] ];
	
	// attribute = [[SHAttribute alloc] init]
	outputString = [outputString stringByAppendingFormat:@"%@ := %@ makeAttribute .\n", saveName, [self class]];
	// [[attribute setName:@"an attribute"]
	outputString = [outputString stringByAppendingFormat:@"%@ setName:'%@' .\n", saveName, [self name]];

	// append the dataTypes displayString
	// [[attribute setDataType:@"SHString"]
	outputString = [outputString stringByAppendingFormat:@"%@ setDataType:'%@' .\n", saveName, [self dataType]];

	outputString = [outputString stringByAppendingFormat:@"%@ . \n", saveName];

	return outputString;
}


@end
