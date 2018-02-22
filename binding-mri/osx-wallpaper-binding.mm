#import <AppKit/AppKit.h>
#include <string.h>

#define MAX_PATH 1000

static BOOL isCached = NO;

static int scaling = NSImageScaleNone;
static BOOL clipping = NO;
static char origPath[MAX_PATH] = {};

void OSX_setWallpaper(const char *imgname) {
  @autoreleasepool {
    NSWorkspace *sw = [NSWorkspace sharedWorkspace];
    NSScreen *screen = [NSScreen screens].firstObject;
    NSString *imgpath = [NSString stringWithUTF8String:imgname];
    NSMutableDictionary *so = [[sw desktopImageOptionsForScreen:screen] mutableCopy];

    // save originals
    if (isCached == NO) {
      scaling = [[so objectForKey:NSWorkspaceDesktopImageScalingKey] intValue];
      clipping = [[so objectForKey:NSWorkspaceDesktopImageAllowClippingKey] intValue];
      NSString *origPathString = [sw desktopImageURLForScreen:screen].path;
      strncpy(origPath, [origPathString UTF8String], MAX_PATH);
      isCached = YES;
    }

    // center image
    [so setObject:[NSNumber numberWithInt:NSImageScaleNone] forKey:NSWorkspaceDesktopImageScalingKey];
    [so setObject:[NSNumber numberWithBool:NO] forKey:NSWorkspaceDesktopImageAllowClippingKey];

    // set wallpaper
    NSError *err;
    [sw
      setDesktopImageURL:[NSURL fileURLWithPath:imgpath]
               forScreen:screen
                 options:so
                   error:&err];
  }
}

void OSX_resetWallpaper() {
  if (isCached == NO) return;
  @autoreleasepool {
    NSWorkspace *sw = [NSWorkspace sharedWorkspace];
    NSScreen *screen = [NSScreen screens].firstObject;
    NSString *imgpath = [NSString stringWithUTF8String:origPath];
    NSMutableDictionary *so = [[sw desktopImageOptionsForScreen:screen] mutableCopy];

    // reset position
    [so setObject:[NSNumber numberWithInt:scaling] forKey:NSWorkspaceDesktopImageScalingKey];
    [so setObject:[NSNumber numberWithBool:clipping] forKey:NSWorkspaceDesktopImageAllowClippingKey];

    // reset wallpaper
    NSError *err;
    [sw
      setDesktopImageURL:[NSURL fileURLWithPath:imgpath]
               forScreen:screen
                 options:so
                   error:&err];
  }
}

