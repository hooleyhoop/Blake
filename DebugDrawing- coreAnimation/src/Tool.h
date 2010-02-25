//
//  Tool.h
//  DebugDrawing
//
//  Created by steve hooley on 21/10/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

#import "EditingToolProtocol.h"

@interface Tool : _ROOT_OBJECT_ <EditingToolProtocol> {
	
}

@property (readonly) NSString *identifier;


@end
