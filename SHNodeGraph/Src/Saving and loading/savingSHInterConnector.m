//
//  savingSHInterConnector.m
//  SHNodeGraph
//
//  Created by Steve Hooley on 20/01/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "savingSHInterConnector.h"


/*
 *
*/
@implementation SHInterConnector (savingSHInterConnector) 


//=========================================================== 
//  saveString 
//=========================================================== 
//- (NSString*) saveStringWithParent:(NSString*)parentString
//{
//	// NSLog(@"SHInterConnector.m: writing save string");
//	SHConnectlet*			inSHConnectlet = _outSHConnectlet;		// a Connectlet for each end
//	SHConnectlet*			outSHConnectlet = _inSHConnectlet;
//	
//	SHNode* outputHostNode		= [outSHConnectlet hostNode];
//	SHNode* inputHostNode		= [inSHConnectlet hostNode];
//	SHAttribute* outAttr		= [outSHConnectlet parentAttribute];
//	SHAttribute* inAttr			= [inSHConnectlet parentAttribute];
//	
//	NSString* out_name			= [outAttr name];
//	NSString* in_name			= [inAttr name];
//
//	NSString* outputString	= [NSString string];	// autoreleased string		
//	outputString			= [outputString stringByAppendingFormat:@"%@ connectOutputAttributeNamed:'%@' ofNodeNamed:'%@' toInputAtttributeNamed:'%@' ofNodeNamed:'%@' .\n", parentString, out_name, [outputHostNode name], in_name, [inputHostNode name] ];
//	
//	// outputString			= [outputString stringByAppendingString:@"\n"];
//	return outputString;
//}


@end
