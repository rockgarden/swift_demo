//
//  LoadingNavigationTitleView.h
//  LoadingNavigationTitleView
//


#import <UIKit/UIKit.h>

@interface LoadingNavigationTitleView : UIView

@property (nonatomic, strong) UIColor *titleColor; // default is [UIColor whiteColor]
@property (nonatomic, strong) UIFont *titleFont; // default is


@property (nonatomic, assign, readonly) BOOL animating; // default is NO

+ (LoadingNavigationTitleView *)initNavigationTitleView;

- (void)setIndicatorView:(UIView *)indicatorView;

- (void)setTitle:(NSString *)title;

- (void)startAnimating;
- (void)stopAnimating;

@end
