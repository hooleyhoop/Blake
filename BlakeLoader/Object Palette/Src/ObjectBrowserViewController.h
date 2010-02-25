//
//  ObjectBrowserViewController.h
//  BlakeLoader2
//
//  Created by steve hooley on 27/11/2008.
//  Copyright 2008 BestBefore Ltd. All rights reserved.
//


struct ObjectAndKey {			
	id theObject;
	NSString *theKey;
};

@class FSNodeInfo;

@interface ObjectBrowserViewController : NSViewController {

	IBOutlet NSBrowser *_objectBrowser;
}

@property (assign, nonatomic) NSBrowser *objectBrowser;

- (void)addNodeToCurrentNodeGroup:(NSString *)aNodeType fromGroup:(NSString *)aNodeGroup0;
- (void)addNodeToCurrentNodeGroup:(NSString *)aNodeType fromGroup:(NSString *)aNodeGroup0 fromGroup:(NSString *)aNodeGroup1;

- (void)objectFromPath:(NSString *)path intoStruct:(struct ObjectAndKey *)struct_ptr;
- (IBAction)reloadData:(id)sender;

- (NSString *)fsPathToColumn:(int)column;
- (NSArray *)subNodesOfNode:(FSNodeInfo *)aNode;

- (void)setupViews;
- (void)tearDownViews;


@end
