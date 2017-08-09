//
//  LFTextField.h
//  DynamicHeight
//
//  Created by la0fu on 16/9/30.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ExpandDirection) {
    ExpandToTop,
    ExpandToBottom
};

@interface LFTextField : UITextField

@property (nonatomic, assign) NSInteger maxNumberOfLines;
@property (nonatomic, assign) ExpandDirection expandDirection;

@end