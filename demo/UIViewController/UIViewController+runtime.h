//
//  UIViewController+runtime.h
//
//  Created by wangkan on 17/10/13.
//

#import <UIKit/UIKit.h>

/**
 UIViewController Category 执行 swizzle 方法
 */
@interface UIViewController (runtime)

@property (nonatomic, assign) BOOL interactiveNavigationBarHidden;
@property (nonatomic, strong) NSDate *date; //viewDidAppear 的时间

@end
