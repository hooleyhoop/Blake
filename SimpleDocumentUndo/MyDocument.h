//
//  MyDocument.h
//  SimpleDocumentUndo
//
//  Created by steve hooley on 10/12/2009.
//  Copyright BestBefore Ltd 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
}

// undoable actions that dont actually do anything
- (void)addAnObjectToTheModel;
- (void)removeAnObjectFromTheModel;

@end
