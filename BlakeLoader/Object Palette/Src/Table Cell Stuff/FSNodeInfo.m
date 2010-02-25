/*
	FSNodeInfo.m
	Copyright (c) 2001-2002, Apple Computer, Inc., all rights reserved.
	Author: Chuck Pisula

	Milestones:
	Initially created 3/1/01

	Encapsulates information about a file or directory.
*/

/*
 IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in
 consideration of your agreement to the following terms, and your use, installation, 
 modification or redistribution of this Apple software constitutes acceptance of these 
 terms.  If you do not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject to these 
 terms, Apple grants you a personal, non-exclusive license, under Apple’s copyrights in 
 this original Apple software (the "Apple Software"), to use, reproduce, modify and 
 redistribute the Apple Software, with or without modifications, in source and/or binary 
 forms; provided that if you redistribute the Apple Software in its entirety and without 
 modifications, you must retain this notice and the following text and disclaimers in all 
 such redistributions of the Apple Software.  Neither the name, trademarks, service marks 
 or logos of Apple Computer, Inc. may be used to endorse or promote products derived from 
 the Apple Software without specific prior written permission from Apple. Except as expressly
 stated in this notice, no other rights or licenses, express or implied, are granted by Apple
 herein, including but not limited to any patent rights that may be infringed by your 
 derivative works or by other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, 
 EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, 
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS 
 USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
 REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND 
 WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR 
 OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "FSNodeInfo.h"
//#import "SHNode.h"

@implementation FSNodeInfo 

+ (FSNodeInfo*)nodeWithParent:(FSNodeInfo*)parent atRelativePath:(NSString *)path representedObject:(id)theRepresentedObject
{
    return [[[FSNodeInfo alloc] initWithParent:parent atRelativePath:path representedObject:theRepresentedObject] autorelease];
}

- (id)initWithParent:(FSNodeInfo*)parent atRelativePath:(NSString*)path representedObject:(id)theRepresentedObject;
{    
    if ((self = [super init]) != nil)
    {
		parentNode = parent;
		[self setRelativePath:path];
		// NSLog(@"FSNodeInfo.m: initWithParent: making a nodeInfo with relative path %@", path);
		[self setRepresentedObject:theRepresentedObject];
    }
    return self;
}


// ===========================================================
// - representedObject:
// ===========================================================
- (SHNode *)representedObject { return representedObject; }


// ===========================================================
// - setRepresentedObject:
// ===========================================================
- (void)setRepresentedObject:(id)aRepresentedObject
{
    if (representedObject != aRepresentedObject) {
        [aRepresentedObject retain];
        [representedObject release];
        representedObject = aRepresentedObject;
    }
}


- (void)dealloc 
{
    // parentNode is not released since we never retained it.
    [relativePath release];
    [representedObject release];
    
	relativePath = nil;
    representedObject = nil;
    parentNode = nil;
    [super dealloc];
}


//- (BOOL)isLink {
//    NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:[self absolutePath] traverseLink:NO];
//    return [[fileAttributes objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink];
//}

//- (BOOL)isDirectory {
//    BOOL isDir = NO;
//    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[self absolutePath] isDirectory:&isDir];
//    return (exists && isDir);
//}

//- (BOOL)isReadable {
//    return [[NSFileManager defaultManager] isReadableFileAtPath: [self absolutePath]];
//}

//- (BOOL)isVisible {
//    // Make this as sophisticated for example to hide more files you don't think the user should see!
//    NSString *lastPathComponent = [self lastPathComponent];
//    return ([lastPathComponent length] ? ([lastPathComponent characterAtIndex:0]!='.') : NO);
//}

//- (NSString*)fsType {
//    if ([self isDirectory]) return @"Directory";
//    else return @"Non-Directory";
//}

// ===========================================================
// - isDirectory:
// ===========================================================
- (BOOL)isDirectory { return isDirectory; }

// ===========================================================
// - setIsDirectory:
// ===========================================================
- (void)setIsDirectory:(BOOL)flag
{
	isDirectory = flag;
}


// ===========================================================
// - lastPathComponent:
// ===========================================================
//- (NSString*)lastPathComponent {
//    return [relativePath lastPathComponent];
//}


// ===========================================================
// - relativePath:
// ===========================================================
- (NSString *)relativePath { return relativePath; }


// ===========================================================
// - setRelativePath:
// ===========================================================
- (void)setRelativePath:(NSString *)aRelativePath
{
    if (relativePath != aRelativePath) {
        [aRelativePath retain];
        [relativePath release];
        relativePath = aRelativePath;
    }
}

//- (NSString*)absolutePath {
//    NSString *result = relativePath;
//    if(parentNode!=nil) {
//        NSString *parentAbsPath = [parentNode absolutePath];
//        if ([parentAbsPath isEqualToString: @"/"]) parentAbsPath = @"";
//        result = [NSString stringWithFormat: @"%@/%@", parentAbsPath, relativePath];
//    }
//    return result;
//}

- (NSImage*)iconImageOfSize:(NSSize)size 
{
    NSString *path = [self relativePath];
    NSImage *nodeImage = nil;
    
    nodeImage = [[NSWorkspace sharedWorkspace] iconForFile:path];
    if (!nodeImage) {
        // No icon for actual file, try the extension.
        nodeImage = [[NSWorkspace sharedWorkspace] iconForFileType:[path pathExtension]];
    }
    [nodeImage setSize: size];
    
//    if ([self isLink]) 
//	{
//		NSImage *arrowImage = [NSImage imageNamed: @"FSIconImage-LinkArrow"];
//		NSImage *nodeImageWithArrow = [[[NSImage alloc] initWithSize: size] autorelease];
//
//		[arrowImage setScalesWhenResized: YES];
//		[arrowImage setSize: size];
//
//		[nodeImageWithArrow lockFocus];
//		[nodeImage compositeToPoint:NSZeroPoint operation:NSCompositeCopy];
//		[arrowImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
//		[nodeImageWithArrow unlockFocus];
//
//		nodeImage = nodeImageWithArrow;
  //  }
    
    if (nodeImage==nil) {
        nodeImage = [NSImage imageNamed:@"FSIconImage-Default"];
    }
    
    return nodeImage;
}

@end
