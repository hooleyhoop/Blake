//
//  DumbSketchDocument.h
//  BlakeLoader2
//
//  Created by steve hooley on 19/07/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//


@class SHooleyObject, SHNodeGraphModel;
@interface DumbSketchDocument : NSDocument {

	SHNodeGraphModel        *_nodeGraphModel;
}

@property(retain, readwrite, nonatomic) SHNodeGraphModel *nodeGraphModel;

@end
