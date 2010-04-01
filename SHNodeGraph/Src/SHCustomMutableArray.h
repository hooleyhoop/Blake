//
//  SHCustomMutableArray.h
//  SHNodeGraph
//
//  Created by steve hooley on 25/03/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

@class SHNode;

/* just a wrapper around shnode that lets it appear to be an array */
@interface SHCustomMutableArray : NSMutableArray {

	SHNode *node;
}

// Order is:-
// Nodes
// Inputs
// Outputs
// Connectors
@property (assign, nonatomic) SHNode *node;

@end
