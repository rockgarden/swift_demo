//
//  LFTextField.m
//  DynamicHeight
//
//  Created by la0fu on 16/9/30.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import "LFTextField.h"

#define    kNumberOfLines     5

@interface LFTextField () <UITextViewDelegate>

@property (nonatomic, assign) NSInteger  numberOfLines;
@property (nonatomic, assign) CGFloat    minHeight;
@property (nonatomic, assign) CGRect     previousRect;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) CGFloat    bottomY;
@property (nonatomic, assign) CGFloat    originalY;
@property (nonatomic, copy)   NSString   *placeHolderStr;

@end

@implementation LFTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.textView = [[UITextView alloc] initWithFrame:self.bounds];
        _minHeight = frame.size.height;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.delegate = self;
        
        [self addSubview:_textView];
        
        self.originalY = frame.origin.y;
        self.bottomY = frame.origin.y + frame.size.height;
        self.previousRect = CGRectZero;
        self.numberOfLines = 0;
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _numberOfLines = 1;
        self.placeholder = _placeHolderStr;
        return;
    } else {
        self.placeholder = @"";
    }
    
    _maxNumberOfLines = _maxNumberOfLines == 0 ? kNumberOfLines : _maxNumberOfLines;
    
    UITextPosition* pos = _textView.endOfDocument;
    CGRect currentRect = [_textView caretRectForPosition:pos];
    
    if (currentRect.origin.y != _previousRect.origin.y){
        
        if (currentRect.origin.y > _previousRect.origin.y) {
            ++_numberOfLines;
            if (_numberOfLines >= _maxNumberOfLines + 1) {
                _numberOfLines = _maxNumberOfLines;
                return;
            }
        } else {
            --_numberOfLines;
            if (_numberOfLines <= 0) {
                _numberOfLines = 1;
            }
        }
        
        [self adjustViewHeight:currentRect];
        _textView.contentOffset = CGPointMake(0, -1);
        
    }
    _previousRect = currentRect;
}

- (void)adjustViewHeight:(CGRect)currentRect
{
    float height = currentRect.origin.y + currentRect.size.height;
    
    CGRect frame = self.frame;
    frame.size.height = MAX(_minHeight, height);
    if ( _expandDirection == ExpandToTop) {
        if (height > _minHeight) {
            frame.origin.y = _bottomY - height;
        } else {
            frame.origin.y = _originalY;
        }
    }

    self.frame = frame;
    
    _textView.frame = self.bounds;
}

- (void)setText:(NSString *)text
{
    _textView.text = text;
}

- (NSString *)text
{
    return _textView.text;
}

- (BOOL)becomeFirstResponder
{
    return [_textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_textView resignFirstResponder];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    
    if (![placeholder isEqualToString:@""]) {
        self.placeHolderStr = placeholder;
    }
}

@end
