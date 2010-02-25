//
//  main.m
//  Blake
//
//  Created by Steve Hooley on 04/05/2005.
//  Copyright HooleyHoop 2005. All rights reserved.
//

#import "SHApplication.h"

// Enable these to be set from a plugin? Flat namespace doesn't work in snow leopard
__attribute__((visibility("default"))) NSString *_UNITTEST_BUNDLE_TOLOAD = nil;
__attribute__((visibility("default"))) NSString *_UNITTEST_MODE = nil;
__attribute__((visibility("default"))) NSString *_DOCUMENT_WINDOW_EXTENSIONCLASS = nil;
//__attribute__((visibility("default"))) BOOL _AUTOLOAD_MAIN_PLUGIN = YES;

BOOL setupInAppTests(void) {
		
	NSString *mainBundlePath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
	NSString *testBundlePath = [mainBundlePath stringByAppendingPathComponent:_UNITTEST_BUNDLE_TOLOAD];
	
	BOOL isDirectory;
	BOOL fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:testBundlePath isDirectory:&isDirectory];
	if(fileExists1){
		NSBundle *testBundle = [NSBundle bundleWithPath:testBundlePath];
		BOOL result = NO;
		[[NSUserDefaults standardUserDefaults] setObject:[testBundle bundlePath] forKey:@"SenTestedUnitPath"];
		result = [testBundle load];
		if(result) {
			// The bundle has been loaded, and it should be linked against SenTestingKit.
			// so SenTestProbe should be available
			// (but we do not want to link otest with SenTestingKit to be able to test the kit itself.)
			id testProbeClass = NSClassFromString(@"HooSenTestProbe");
			if (testProbeClass != nil) {
				[testProbeClass performSelector:@selector(runTestsInBundle:) withObject:testBundle afterDelay:1];
			}
		}
		return result;	
	} else {
		exit(0);
	}
}

int main(int argc, char *argv[]) {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

#ifdef DEBUG
	
	// just verifying our arguments
	// NSArray *args = [[NSProcessInfo processInfo] arguments];

	/* Have we set a test bundle as an argument? */
    for( NSInteger i=0; i<argc; i++ ){

        char *arg = argv[i];

		if(!_UNITTEST_BUNDLE_TOLOAD){
			char *found = strstr(arg, ".octest");
			if(found!=NULL && arg[0]=='-'){
				arg = arg+1; //-- ignore the first -char //
				_UNITTEST_BUNDLE_TOLOAD = [[NSString alloc] initWithCString:arg encoding:NSUTF8StringEncoding];
				continue;
			}
		}
		
		if(!_UNITTEST_MODE){
			char *found = strstr(arg, "-SenTest");
			if(found!=NULL && arg[0]=='-'){
				i++;
				char *nextArg = argv[i];
				_UNITTEST_MODE = [[NSString alloc] initWithCString:nextArg encoding:NSUTF8StringEncoding];
				continue;
			}
		}
		
		if(!_DOCUMENT_WINDOW_EXTENSIONCLASS){
			char *found = strstr(arg, "-MainWindowClass");
			if(found!=NULL && arg[0]=='-'){
				i++;
				char *nextArg = argv[i];
				_DOCUMENT_WINDOW_EXTENSIONCLASS = [[NSString alloc] initWithCString:nextArg encoding:NSUTF8StringEncoding];
				NSLog(@"DOCUMENT_WINDOW_EXTENSIONCLASS - %@", _DOCUMENT_WINDOW_EXTENSIONCLASS);
				
				[[SHGlobalVars globals] setObject:_DOCUMENT_WINDOW_EXTENSIONCLASS forKey:@"DOCUMENT_WINDOW_EXTENSIONCLASS"];
				continue;
			}
		}
    }
	
	// In App Tests
	if(_UNITTEST_BUNDLE_TOLOAD && _UNITTEST_MODE){
		setupInAppTests();
	}
	
#endif

	[SHApplication sharedApplication];
	
	/* er, try to wake up some classes in desired order */
	if(NSClassFromString(@"SwizzleList"))
		[NSClassFromString(@"SwizzleList") performSelector:@selector(setupSwizzles)];
	
	/* This essentially kicks things off (this will call [BBPluginRegistry +initialize]), if _AUTOLOAD_MAIN_PLUGIN==YES */
	if(NSClassFromString(@"BBPluginRegistry"))
		[NSClassFromString(@"BBPluginRegistry") respondsToSelector:@selector(sharedInstance)];
	
	[pool drain];
	
	// you can set the application class here, can't you?
    return NSApplicationMain(argc,  (const char **) argv);
}
