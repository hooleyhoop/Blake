#import "LogEmailController.h"
#import "BBLogFile.h"
#import "BBLogger.h"
#import <AddressBook/AddressBook.h>
#import <Message/NSMailDelivery.h>
#import <unistd.h>

@implementation LogEmailController

- (void)dealloc {
	[super dealloc];
}

-(void)awakeFromNib {
	ABPerson* me = [[ABAddressBook sharedAddressBook] me];
	ABMultiValue* emails = [me valueForProperty:kABEmailProperty];
	if ([emails count]>0) {
		[replyTo setStringValue:[emails valueAtIndex:0]];
	}	
}

- (IBAction)cancel:(id )sender {
    [NSApp endSheet:[sender window] returnCode:1];
}
- (IBAction)sendEmail:(id )sender {
    [NSApp endSheet:[sender window] returnCode:0];
}

-(void)launchForWindow:(NSWindow*)parentWindow {
	[NSApp beginSheet:window modalForWindow:parentWindow modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}


- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
	if (returnCode != 0)	// User hit cancel, nothing more to do
		return;
	
	[NSThread detachNewThreadSelector:@selector(sendMail) toTarget:self withObject:nil];  //Sending mail is slow, do it on a new thread
}

-(void)sendMail
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// We're using the (deprecated and a bit rubbish) Message framework to send emails.  This relies on the user having a properly configured Mail.app
	// Alternatively, we could HTTP Post the 'email' to our CMS...
	
	// Find a temporary file to drop the zip file in :
	NSString* tempFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bbLogXXXXX.zip"];
	char cTempFilePath[512];
	if (![tempFilePath getFileSystemRepresentation:cTempFilePath maxLength:512]) {
		logError(@"Couldn't get file system rep for %@", tempFilePath);
        [pool release];
		return;
	}
	mkstemps(cTempFilePath, 4);	
	NSString* targetPath = (id)CFStringCreateWithFileSystemRepresentation(NULL, cTempFilePath);		// Cocoa seems to lack any way of going from file-system-encoded cstrings to an NSString.  Go via Carbon.
	
	// zip all our log files via NSTask
	NSTask * zipTask = [[NSTask alloc] init];
	[zipTask setLaunchPath:@"/usr/bin/zip"];
	NSArray* arguments = [NSArray arrayWithObjects:@"-qF", @"-j", targetPath, nil];		// -qF persuades zip to reconstruct the zip header in the target file (which is currently empty).  -j to not record the directory path
	arguments = [arguments arrayByAddingObjectsFromArray:[[BBLogFile applicationLogFile] archivedPaths]];
	arguments = [arguments arrayByAddingObjectsFromArray:[BBLogFile crashLogFilePaths]];
	[zipTask setArguments:arguments];
	[zipTask launch];
	[zipTask waitUntilExit];
	if ([zipTask terminationStatus] != 0)
		logError(@"Couldn't zip log files");
	[zipTask release];
	
	// OK, we now have a zip of our log files.  Add them as an attachment to an NSAttributedString:
	NSMutableAttributedString* body = [[NSMutableAttributedString alloc] initWithString:[[problemDescription string] stringByAppendingString:@"\n\n"]];
	NSFileWrapper* fileWrapper = [[NSFileWrapper alloc] initWithPath:targetPath];
	NSTextAttachment* attachment = [[NSTextAttachment alloc] initWithFileWrapper:fileWrapper];
	[body appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
	
	
	/*
	Email stuff is out of date
	 NSString* subject = [NSString stringWithFormat:@"%@ log report", [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey]];
	 NSDictionary* headers = [NSDictionary dictionaryWithObjectsAndKeys:@"jon.delStrother@bestbefore.tv", @"To", [replyTo stringValue], @"From", subject, @"subject", nil];
	if (![NSMailDelivery deliverMessage:body headers:headers format:NSMIMEMailFormat protocol:nil])
		logError(@"Mail delivery failed");
	*/
	[body release];
	[fileWrapper release];
	[attachment release];
	[[NSFileManager defaultManager] removeFileAtPath:targetPath handler:nil];
	CFRelease((CFStringRef)targetPath);
	
	NSString* soundPath = [[[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:@"com.apple.mail"] stringByAppendingPathComponent:@"Contents/Resources/Mail Sent.aiff"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
		NSSound* sound = [[[NSSound alloc] initWithContentsOfFile:@"/Applications/Mail.app/Contents/Resources/Mail Sent.aiff" byReference:YES] autorelease];
		[sound play];
	}

	[pool release];
}

@end
