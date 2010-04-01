//
//  SHDocumentController.h
//  SHShared
//
//  Created by steve hooley on 13/06/2008.
//  Copyright 2008 HooleyHoop. All rights reserved.
//

#import <Appkit/NSDocumentController.h>

@interface SHDocumentController : NSDocumentController {

}

+ (void)cleanUpSharedDocumentController;
- (void)setDocClass:(Class)aClass forDocType:(NSString *)docType;

@end
