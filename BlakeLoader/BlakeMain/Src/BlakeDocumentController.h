//
//  BlakeDocumentController.h
//  Pharm
//
//  Created by Steve Hooley on 16/04/2007.
//  Copyright 2007 HooleyHoop. All rights reserved.
//

#import <SHShared/SHDocumentController.h>

/*
 * One of these per App
*/
@interface BlakeDocumentController : SHDocumentController {

	Class customDocClass;
	BOOL _isSetup;
}

@property (readwrite, assign, nonatomic) Class customDocClass; // needs setting each time you wish to open a doc with a custom class
@property (readwrite, assign, nonatomic) BOOL isSetup;

#pragma mark class methods
+ (id)sharedDocumentController;

- (void)setupObserving;

// #pragma mark loading plugins
// - (NSArray *)documentTypeExtensions;
// - (id)documentTypeExtensionSupportingType:(NSString *)typeName;
- (NSArray *)windowControllerClasses;

// Convienence
- (SHNodeGraphModel *)frontDoc_graph;
- (SHNode *)frontDoc_currentNode;

@end
