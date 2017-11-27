//
//  UIControl+runtime.h
//  UIControlDemo
//
//  Created by wangkan on 2017/11/24.
//  Copyright © 2017年 rockgarden. All rights reserved.
//


#import <UIKit/UIKit.h>
#define defaultInterval .5 //默认时间间隔

@interface UIControl (runtime)
@property(nonatomic,assign) NSTimeInterval timeInterval; //用这个给重复点击加间隔
@property(nonatomic,assign) BOOL isIgnoreEvent; //YES不允许点击NO允许点击
@end
