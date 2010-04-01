//
//  SHFileManagerExtensions.m
//  Shared
//
//  Created by Steve Hooley on 16/08/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "SHFileManagerExtensions.h"


#import <Foundation/Foundation.h>
//#import <OmniBase/OmniBase.h>
//#import <OmniBase/system.h>
//#import "NSProcessInfo-OFExtensions.h"
//#import "NSArray-OFExtensions.h"
//#import "NSString-OFExtensions.h"
//#import "OFUtilities.h"

#import <sys/errno.h>
#import <sys/param.h>
#import <stdio.h>
#import <sys/mount.h>
#import <unistd.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <sys/attr.h>
#import <fcntl.h>


@implementation NSFileManager (SHFileManagerExtensions)

//static NSLock *tempFilenameLock;
//static NSString *scratchDirectoryPath;
//static NSLock *scratchDirectoryLock;
//static int permissionsMask = 0022;


//=========================================================== 
// - desktopDirectory 
//=========================================================== 
- (NSString *) desktopDirectory
{
    FSRef dirRef;
    OSErr err = FSFindFolder(kUserDomain, kDesktopFolderType, kCreateFolder, &dirRef);
    if (err != noErr) {
#ifdef DEBUG
        NSLog(@"FSFindFolder(kDesktopFolderType) -> %ld", err);
#endif
        [NSException raise:NSInvalidArgumentException format:@"Unable to find desktop directory"];
    }

    CFURLRef url;
    url = CFURLCreateFromFSRef(kCFAllocatorDefault, &dirRef);
    if (!url)
        [NSException raise:NSInvalidArgumentException format:@"Unable to create URL to desktop directory"];

    NSString *path = [[[(NSURL *)url path] copy] autorelease];
    [(id)url release];

    return path;
}


@end

//@implementation NSFileManager (OFPrivate)
//
//- (int)filesystemStats:(struct statfs *)stats forPath:(NSString *)path;
//{
//    if ([[[self fileAttributesAtPath:path traverseLink:NO] fileType] isEqualToString:NSFileTypeSymbolicLink])
//        // BUG: statfs() will return stats on the file we link to, not the link itself.  We want stats on the link itself, but there is no lstatfs().  As a mostly-correct hackaround, I get the stats on the link's parent directory. This will fail if you NFS-mount a link as the source from a remote machine -- it'll report that the link isn't network mounted, because its local parent dir isn't.  Hopefully, this isn't real common.
//        return statfs([self fileSystemRepresentationWithPath:[path stringByDeletingLastPathComponent]], stats);
//    else
//        return statfs([self fileSystemRepresentationWithPath:path], stats);
//}
//
//- (NSString *)lockFilePathForPath:(NSString *)path;
//{
//    return [[path stringByStandardizingPath] stringByAppendingString:@".lock"];
//    // This could be a problem if the resulting filename is too long for the filesystem. Alternatively, we could create a lock filename as a fixed-length hash of the real filename.
//}
//
//@end
