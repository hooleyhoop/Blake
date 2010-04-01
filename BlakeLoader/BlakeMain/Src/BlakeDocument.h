//
//  BlakeDocument.h
//  Pharm
//
//  Created by Steve Hooley on 25/03/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <SHShared/SHDocument.h>

@class SHNodeGraphModel, BlakeDocumentController;

/*
 *
*/
@interface BlakeDocument : SHDocument {

	SHNodeGraphModel			*_nodeGraphModel;
	BlakeDocumentController		*_shDocumentController;
}

@property (readwrite, assign, nonatomic) BlakeDocumentController *shDocumentController;
@property (readwrite, retain, nonatomic) SHNodeGraphModel *nodeGraphModel;

//#pragma mark -
//#pragma mark accessor methods
//- (NSString *)windowNibName;

@end

