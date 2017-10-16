//
//  UIViewController+LoadingNavigationTitle.m
//  NavigationLadingTitleView
//

// 调用
// [self startAnimationTitle];
// [self stopAnimationTitle];


#import "UIViewController+LoadingNavigationTitle.h"
#import <objc/runtime.h>

static NSString * const loadingNavigationTitleViewKey = @"loadingNavigationTitleViewKey";

@implementation UIViewController (LoadingNavigationTitle)


- (void)setLoadingNavigationTitleView:(LoadingNavigationTitleView *)loadingNavigationTitleView {
    objc_setAssociatedObject(self, &loadingNavigationTitleViewKey, loadingNavigationTitleView, OBJC_ASSOCIATION_RETAIN);
}

- (LoadingNavigationTitleView *)loadingNavigationTitleView {
    return objc_getAssociatedObject(self, &loadingNavigationTitleViewKey);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(setTitle:);
        SEL swizzledSelector = @selector(setAnimatedTitle:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)startAnimationTitle {
    [self.loadingNavigationTitleView startAnimating];
}

- (void)stopAnimationTitle {
    [self.loadingNavigationTitleView stopAnimating];
}

- (void)setAnimatedTitle:(NSString *)title {
    [self setAnimatedTitle:title];
    LoadingNavigationTitleView *loadingNavigationTitleView = [LoadingNavigationTitleView initNavigationTitleView];
    [loadingNavigationTitleView setTitle:title];
    loadingNavigationTitleView.titleColor = [UIColor blackColor];
    self.navigationItem.titleView = loadingNavigationTitleView;
    
    self.loadingNavigationTitleView = loadingNavigationTitleView;
}

@end
