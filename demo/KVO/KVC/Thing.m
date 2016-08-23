

#import "Thing.h"
#import "KVO-Swift.h"

@implementation Thing

- (void) test {
    KVC_VC* vc = [KVC_VC new];
    [vc setColor:[UIColor redColor]]; // "someone called the setter"
    UIColor* c __attribute__((unused)) = [vc color]; // "someone called the getter"
}

- (void) test2 {
    KVC_VC* vc = [KVC_VC new];
    [vc setHue:[UIColor redColor]]; // "someone called the setter"
    UIColor* c __attribute__((unused)) = [vc hue]; // "someone called the getter"
}

- (void) test3 {
    KVC_VC* vc = [KVC_VC new];
    [vc setCouleur:[UIColor redColor]];
    UIColor* c __attribute__((unused)) = [vc couleur];
}


@end
