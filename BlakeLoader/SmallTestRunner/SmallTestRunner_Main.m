#import <Foundation/Foundation.h>
#import "SKTGraphicsProvidorTests.h"
#import "SketchModelTests.h"
#import <SHShared/SHooleyObject.h>

void sortIntoLines( NSString *fileContents, NSMutableArray *allLines ) {

	NSString *aLine;
	unsigned numberOfLines, index, stringLength = [fileContents length], startOfNextLine;
	for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
	{
		startOfNextLine = NSMaxRange([fileContents lineRangeForRange:NSMakeRange(index, 0)]);
		aLine = [fileContents substringWithRange:NSMakeRange(index, (startOfNextLine-index))];
		[allLines addObject:aLine];
		index = startOfNextLine;
	}
}

// super_class
// name
// version
static NSString *previousLine_firstWord = nil;
static NSString *superClassName = nil;

void parseLine( NSString *aLineOfText, NSMutableArray *resultArray ) {
    
    aLineOfText = [aLineOfText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *lineComponants = [aLineOfText componentsSeparatedByString:@" "];
	NSString* firstWord = [lineComponants objectAtIndex:0];
    
    if( [firstWord isEqualToString: @"super_class"] ){
        if([lineComponants count]==3)
        {
            superClassName = [lineComponants objectAtIndex: 2];
        }
    } else if( [firstWord isEqualToString: @"name"] && [previousLine_firstWord isEqualToString: @"super_class"] )
    {
        if([lineComponants count]==3 && [superClassName isEqualToString:@"SenTestCase"])
        {
            NSString *className = [lineComponants objectAtIndex: 2];
            if([resultArray containsObject: className]==NO)
                [resultArray addObject: className];
        }
    }
    previousLine_firstWord = firstWord;
}

void parseOBJFileIntoClassNames( NSMutableArray *allLines, NSMutableArray *results  ) {
    
    NSString *aLine;
	for( aLine in allLines ) {        
		parseLine( aLine, results);
	}
}

int main (int argc, const char * argv[]) {

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    /* Read the test bundle path from the arguments */
    NSString *unitTestBundlePath = @"<empty>";
    for(int i=0;i<argc;i++){
        
        const char* arg = argv[i];
		char* searchString = ".octest";
		char *found = strstr(arg, searchString);
		if(found!=NULL && arg[0]=='-'){
			arg = arg+1; //-- ignore the first -char //
			unitTestBundlePath = [[[NSString alloc] initWithCString:arg encoding: NSUTF8StringEncoding] autorelease];
            NSBundle *theBundle = [NSBundle bundleWithPath: unitTestBundlePath];
            [theBundle load];
            unitTestBundlePath = [theBundle executablePath];
		}
    }
    NSLog(@"** Running unit tests from %@ **", unitTestBundlePath);
    /* Use otool to get ou class names */
    NSTask *otool=[[NSTask alloc] init];
    [otool setLaunchPath: @"/Developer/usr/bin/otool"];
    NSString *temporaryPath = @"/Users/shooley/Desktop/Programming/Cocoa/Blake/build/SketchTests.octest/Contents/MacOS/SketchTests";
    NSCAssert( [unitTestBundlePath isEqualToString: temporaryPath], @"argument seems to be wrong");

    
    NSArray *arguments = [NSArray arrayWithObjects: @"-o", @"-v", temporaryPath, nil];
    [otool setArguments: arguments];
    NSPipe *pipe=[NSPipe pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    NSString *fileContents;
    [otool setStandardOutput:pipe];
	[otool setStandardError: pipe];
    [otool launch];
    
    ///  -- enumerate thru the lines   
    fileContents=[[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding]; // convert NSData -> NSString  
    NSMutableArray *theSeparateLines = [NSMutableArray array];
	sortIntoLines( fileContents, theSeparateLines );
  //  NSLog(fileContents);
    NSMutableArray *allClassNamesFromBundle = [NSMutableArray array];
	parseOBJFileIntoClassNames( theSeparateLines, allClassNamesFromBundle );
    NSLog(@"%@", allClassNamesFromBundle);

    NSString *testClassName;
    for( testClassName in allClassNamesFromBundle ){
        
		NSLog(@"** Starting tests from %@ **", testClassName);
        Class testClass = NSClassFromString( testClassName );
        NSCAssert(testClass!=nil, @"dope");
        id test = [[testClass alloc] init];
        NSArray *testInvocations = [testClass testInvocations];
        NSInvocation *testInvocation;
        
        for( testInvocation in testInvocations ){
			
			NSAutoreleasePool * pool2 = [[NSAutoreleasePool alloc] init];

			NSString *thisSel = NSStringFromSelector( [testInvocation selector] );
			NSLog(@"	** testing %@: **", thisSel);

            [test setUp];
            [testInvocation invokeWithTarget: test];
            [test tearDown];
			
			[pool2 drain];
			
			//-- was there an error or a leak?
			NSLog(@"HooleyCount after test cleanup is %i", [SHooleyObject instanceCount]);
			if([SHooleyObject instanceCount]>0){
				NSLog(@"we have leaked a hooleyObject in class %@, selector %@", testClassName,  NSStringFromSelector( [testInvocation selector] ));
                [SHooleyObject printLeakingObjectInfo];
			}
        }        
        [test release];
        [testClass release];
    }


 
//	NSArray *allSelectors = [NSArray arrayWithObjects:
//	@"testRegisterContentFilter",
//	@"testInsertGraphicAtIndex",
//	@"testRemoveGraphicAtIndex",
//	@"testInsertGraphicsAtIndexes",
//	@"testRemoveGraphicsAtIndexes",
//	@"testChangeSelectionTo",
//	@"testIsSelected",
//	@"testSetSelectionIndexes",
//	@"testSetSelectedObjects",
//	@"testSetIndexOfChild",
//	nil];
	
//	NSString *selAsString;
//	for( selAsString in allSelectors){
//		[test1 setUp];
//			[test1 performSelector: NSSelectorFromString(selAsString)];
//		[test1 tearDown];
//	}

    
    [fileContents release];
    [otool release];
	NSLog(@"!!! Leaky !!!");

    [pool drain];

//	sleep(1000000);
    return 0;
}
