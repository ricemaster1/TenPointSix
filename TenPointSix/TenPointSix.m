#import <Cocoa/Cocoa.h>
#import "imagekit.h"

// ammonia injects this dylib into each spawned process; the constructor runs on load.
__attribute__((constructor))
static void tenpointsix_load(void) {
    @autoreleasepool {
        @try {
            // scope to Finder (ammonia injects broadly)
            if (![NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.apple.finder"]) return;
            // kill-switch: `touch ~/.tenpointsix.off && killall Finder` -> vanilla Finder
            NSString *off = [NSHomeDirectory() stringByAppendingPathComponent:@".tenpointsix.off"];
            if ([NSFileManager.defaultManager fileExistsAtPath:off]) return;

            imagekit_install();
        } @catch (__unused NSException *e) {}
    }
}
