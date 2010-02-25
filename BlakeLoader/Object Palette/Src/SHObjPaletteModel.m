//
//  SHObjPaletteModel.m
//  InterfaceTest
//
//  Created by Steve Hool on Mon Dec 29 2003.
//  Copyright (c) 2003 HooleyHoop. All rights reserved.
//

#import "SHObjPaletteModel.h"
#import "SHObjPaletteControl.h"
//#import "SHAppModel.h"
//#import "SHAppControl.h"
//#import "SHNode.h"
#import "SHNodeRegister.h"
//#import "SHNodeGroup.h"
//#import "SHObjectGraphModel.h"


SHObjPaletteModel*	objPaletteModel;

@implementation SHObjPaletteModel

#pragma mark --
#pragma mark class methods
+ (SHObjPaletteModel*) objPaletteModel {
	return objPaletteModel;
}


#pragma mark init methods

- (id)initWithController:(id<SHViewControllerProtocol>)aController
{
    if ((self = [super init]) != nil)
    {
		// init code
		theSHObjPaletteControl = (SHObjPaletteControl*)aController;
		objPaletteModel = self;
		
		// NSLog(@"SHObjPaletteModel.m: initing SHObjPaletteModel");
		theSHNodeRegister = [[SHNodeRegister alloc]init];

		[self awakeFromNib];
	}
    return self;
}

// ===========================================================
//  - dealloc:
// ===========================================================
- (void)dealloc
{
	//    [theSHAppView release];
    [theSHObjPaletteControl release];
    [theSHNodeRegister release];
	
	//   theSHAppView = nil;
    theSHObjPaletteControl = nil;
    theSHNodeRegister = nil;
	
    [super dealloc];
}

// ===========================================================
// - awakeFromNib:
// ===========================================================
- (void) awakeFromNib
{
	// add node type to our dictionary for later creation
	// NSLog(@"SHObjPaletteModel.m: !!!!adding nodes!!!!");
//	NSString *lowLevelNodes		= @"lowLevelNodes";
//	NSString *GUINodes			= @"GUINodes";
//	NSString *basicNodes		= @"basicNodes";
//	NSString *basicMathNodes	= @"basicMathNodes";
//	NSString *attributes		= @"attributes";
//	NSString *groups			= @"groups";

//	[theSHNodeRegister registerNodeType: @"SHProtoOperator" inGroup:groups inGroup:lowLevelNodes];
//	[theSHNodeRegister registerNodeType: @"SHPlusOperator" inGroup:basicMathNodes inGroup:lowLevelNodes];
//	[theSHNodeRegister registerNodeType: @"SHInputAttribute" inGroup:attributes inGroup:lowLevelNodes];
//	[theSHNodeRegister registerNodeType: @"SHOutputAttribute" inGroup:attributes inGroup:lowLevelNodes];

//	[theSHNodeRegister registerNodeType: @"NumberNode" inGroup:basicNodes ];
//	[theSHNodeRegister registerNodeType: @"AdditionNode" inGroup:basicMathNodes inGroup:basicNodes ];
//	[theSHNodeRegister registerNodeType: @"StdOutNode" inGroup:outputNodes ];
}


#pragma mark action methods
// ===========================================================
// - test_addNodes
// ===========================================================
- (void)test_addNodes
{
	[self addNodeToCurrentNodeGroup:@"SHPlusOperator" fromGroup: @"basicMathNodes" fromGroup:@"lowLevelNodes" ];
	[self addNodeToCurrentNodeGroup:@"SHPlusOperator" fromGroup: @"basicMathNodes" fromGroup:@"lowLevelNodes" ];
	[self addNodeToCurrentNodeGroup:@"SHPlusOperator" fromGroup: @"basicMathNodes" fromGroup:@"lowLevelNodes" ];
}


// ===========================================================
// - addNode: fromGroup: toScript:
// ===========================================================
- (int) addNodeToCurrentNodeGroup:(NSString*)aNodeType fromGroup:(NSString*)aNodeGroup0
{   
	// look up nodeType in the Dictionary and make a new instance of the class 'aNodeType' if it exists
	id classObject = [theSHNodeRegister lookupNode:aNodeType inGroup:aNodeGroup0];
	if(classObject!=nil)
	{
		SHObjectGraphModel* graphModel		= [SHObjectGraphModel graphModel];
		SHNodeGroup* currentScript			= [graphModel theCurrentNodeGroup];		
		SHNode* aNode						= [[[classObject alloc]initWithParentNodeGroup:currentScript]autorelease];
		
		// node gets a uid when it is added to a script
		// NSLog(@"SHObjPaletteModel.m: ADD that Node!");

		[graphModel addNodeToCurrentNodeGroup: aNode];
		return [aNode temporaryID];
	} else {
		NSLog(@"SHObjPaletteModel.m: ERROR: Cant find that node");
		return nil;
	}
	return 0;
}


// ===========================================================
// - addNode fromGroup fromGroup toScript:
// ===========================================================
- (int) addNodeToCurrentNodeGroup:(NSString*)aNodeType fromGroup:(NSString*)aNodeGroup0 fromGroup:(NSString*)aNodeGroup1
{   
	//NSLog(@"SHObjPaletteModel.m: ADD that Node 2!");

	// look up nodeType in the Dictionary and make a new instance of the class 'aNodeType' if it exists
	id classObject = [theSHNodeRegister lookupNode:aNodeType inGroup:aNodeGroup0 inGroup:aNodeGroup1 ];
	if(classObject!=nil)
	{
		//NSLog(@"SHObjPaletteModel.m: ADD that Node 3!");

		// NSLog(@"SHObjPaletteModel.m: object pallettee model. adding node blah blah");
		SHObjectGraphModel* graphModel		= [SHObjectGraphModel graphModel];
		SHNodeGroup* currentScript			= [graphModel theCurrentNodeGroup];
		
		// hm, 
		SHNode* aNode						= [[[classObject alloc]initWithParentNodeGroup:currentScript ]autorelease];
		
		//NSLog(@"SHObjPaletteModel.m: ADD that Node 4!");
		[graphModel addNodeToCurrentNodeGroup: aNode];
		return [aNode temporaryID];
	} else {
		NSLog(@"SHObjPaletteModel.m: ERROR: Cant find that node");
		return nil;
	}
	return 0; // ZERO is Error
}


#pragma mark accessor methods
// ===========================================================
// - theSHObjPaletteControl:
// ===========================================================
- (SHObjPaletteControl *)theSHObjPaletteControl { return theSHObjPaletteControl; }

// ===========================================================
// - setTheSHObjPaletteControl:
// ===========================================================
//- (void)setTheSHObjPaletteControl:(SHObjPaletteControl *)aTheSHObjPaletteControl
//{
//    if (theSHObjPaletteControl != aTheSHObjPaletteControl) {
//        [aTheSHObjPaletteControl retain];
//        [theSHObjPaletteControl release];
//        theSHObjPaletteControl = aTheSHObjPaletteControl;
//    }
//}


// ===========================================================
// - theSHNodeRegister:
// ===========================================================
- (SHNodeRegister *)theSHNodeRegister { return theSHNodeRegister; }


// ===========================================================
// - setTheSHNodeRegister:
// ===========================================================
//- (void)setTheSHNodeRegister:(SHNodeRegister *)aTheSHNodeRegister
//{
//    if (theSHNodeRegister != aTheSHNodeRegister) {
//        [aTheSHNodeRegister retain];
//        [theSHNodeRegister release];
//        theSHNodeRegister = aTheSHNodeRegister;
//    }
//}


// ===========================================================
// - setLoadedOperators:
// ===========================================================
- (void) setLoadedOperators:(NSMutableDictionary*)dynLoadedOperators 
{
	// NSLog(@"SHObjPaletteModel.m: setLoadedOperators %@", dynLoadedOperators );
	[theSHNodeRegister registerOperatorClasses: dynLoadedOperators];
}


@end
