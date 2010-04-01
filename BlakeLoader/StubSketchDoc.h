//
//  StubSketchDoc.h
//  BlakeLoader2
//
//  Created by steve hooley on 18/07/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//

@class SHooleyObject;
@class SHNodeGraphModel;

@interface StubSketchDoc : NSDocument {

    SHNodeGraphModel	*_nodeGraphModel;
}

@property(assign, readwrite, nonatomic) SHNodeGraphModel *nodeGraphModel;

- (BOOL)isDocumentEdited;

@end
