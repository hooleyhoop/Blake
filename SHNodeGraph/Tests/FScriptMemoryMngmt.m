//
//  FScriptMemoryMngmt.m
//  SHNodeGraph
//
//  Created by steve hooley on 04/07/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import "FScriptMemoryMngmt.h"
#import <FScript/FScript.h>


@interface FScriptMemoryMngmt : SenTestCase {
	
}

@end


@implementation FScriptMemoryMngmt

- (void)testAutoReleased {

	NSString *saveString1 = [NSString stringWithFormat:@"dataValue := (%@ alloc init) autorelease.\n", [NSObject class]];
	FSInterpreterResult* execResult = [[FSInterpreter interpreter] execute: saveString1];

	id result = nil;
	if([execResult isOK]){
		result = [execResult result];
	}
	if(!result){
		STFail(@"Failed to execute save string");
	}
	STAssertNotNil(result, @"eh");
	
	NSString *saveString2 = [NSString stringWithFormat:@"attribute := (SHInputAttribute alloc init) autorelease. \n"];
	saveString2 = [saveString2 stringByAppendingFormat:@"dataValue := mockDataType alloc initWithObject:'<<NSNull>>'. \n"];
	saveString2 = [saveString2 stringByAppendingFormat:@"dataValue autorelease. \n"];
	saveString2 = [saveString2 stringByAppendingFormat:@"attribute"];

	execResult = [[FSInterpreter interpreter] execute: saveString2];
}

- (void)testFileLeak {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString *saveString3 = [NSString stringWithFormat:@"'building node.. root'. \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 := SHNode newNode . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 setName:'root' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node1_126 := SHNode newNode . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node1_126 setName:'level2_node1' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node1_126 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 addChild:level2_node1_126 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node2_127 := SHNode newNode . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node2_127 setName:'level2_node2' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level3_node3_128 := SHNode newNode . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level3_node3_128 setName:'level3_node3' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level3_node3_128 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node2_127 addChild:level3_node3_128 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"level2_node2_127 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 addChild:level2_node2_127 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input_129 := SHInputAttribute makeAttribute . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input_129 setName:'input' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"name1 := NSString stringWithFormat:'chicken1' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"dataValue := (mockDataType alloc initWithObject: name1 ) autorelease. \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"dataValue . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input_129 setDataType:'mockDataType' withValue:dataValue . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input_129 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 addChild:input_129 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input1_131 := SHInputAttribute makeAttribute . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input1_131 setName:'input1' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"dataValue := (mockDataType alloc initWithObject:'<<NSNull>>') autorelease. \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"dataValue . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input1_131 setDataType:'mockDataType' withValue:dataValue . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"input1_131 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 addChild:input1_131 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output_130 := SHOutputAttribute makeAttribute . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output_130 setName:'output' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output_130 setDataType:'mockDataType' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output_130 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 addChild:output_130 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output1_132 := SHOutputAttribute makeAttribute . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output1_132 setName:'output1' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output1_132 setDataType:'mockDataType' . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"output1_132 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 addChild:output1_132 autoRename:NO . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"ic := root_125 connectOutletOfAttribute:input_129 toInletOfAttribute:output_130 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"root_125 . \n"];
	saveString3 = [saveString3 stringByAppendingFormat:@"'finito' \n"];
	
	FSInterpreterResult* execResult = [[FSInterpreter interpreter] execute: saveString3];
	[pool release];
//	sleep(500);
}

@end
