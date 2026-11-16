#import <Cocoa/Cocoa.h>
#import "ZKSwizzle.h"

static NSString *const kPlaceholderID = @"TPS.imagekit.placeholder";

// Finder's Gallery view VC builds its subviews in -configureView. ZKSwizzle resolves the
// target by name (no Finder headers); NSObject base is fine since we never call ZKSuper.
ZKSwizzleInterface(TPS_TGalleryCollectionViewController, TGalleryCollectionViewController, NSObject)
@implementation TPS_TGalleryCollectionViewController

- (void)configureView {
    ZKOrig(void);                                   // let Finder build its real gallery first
    @try {                                          // never take Finder down
        NSView *host = [(NSViewController *)self view];
        if (!host) return;
        for (NSView *sub in host.subviews)          // don't stack on repeat calls
            if ([sub.identifier isEqualToString:kPlaceholderID]) return;
        // pink placeholder proves inject->swizzle->mount. TODO: swap for the carousel (pin w/ constraints)
        NSView *ph = [[NSView alloc] initWithFrame:host.bounds];
        ph.identifier = kPlaceholderID;
        ph.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        ph.wantsLayer = YES;
        ph.layer.backgroundColor = [NSColor systemPinkColor].CGColor;
        [host addSubview:ph positioned:NSWindowAbove relativeTo:nil];
    } @catch (__unused NSException *e) {}
}

@end

void imagekit_install(void) {
    if (!NSClassFromString(@"TGalleryCollectionViewController")) return;   // not Finder / class gone
    ZKSwizzleClass(TPS_TGalleryCollectionViewController);
}
