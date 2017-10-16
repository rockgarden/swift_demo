//
//  UIViewController+LoadingNavigationTitle.h
//  NavigationLadingTitleView
//


#import <UIKit/UIKit.h>
#import "LoadingNavigationTitleView.h"

@interface UIViewController (LoadingNavigationTitle)

@property (nonatomic, strong) LoadingNavigationTitleView *loadingNavigationTitleView;

- (void)startAnimationTitle;
- (void)stopAnimationTitle;

@end
