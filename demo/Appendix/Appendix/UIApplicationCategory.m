

#import "UIApplicationCategory.h"

@implementation UIApplication (MyCategory)

+ (BOOL) safeToUseSettingsString {
    return true; // &UIApplicationOpenSettingsURLString always true
}

@end
