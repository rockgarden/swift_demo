//
//  DotIndicatorView.h
//  DotIndicatorView
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DotIndicatorViewStyle)
{
    DotIndicatorViewStyleSquare,
    DotIndicatorViewStyleRound,
    DotIndicatorViewStyleCircle
};

@interface DotIndicatorView : UIView

@property (nonatomic, assign) BOOL hidesWhenStopped;

- (id)initWithFrame:(CGRect)frame
           dotStyle:(DotIndicatorViewStyle)style
           dotColor:(UIColor *)dotColor
            dotSize:(CGSize)dotSize;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;


@end
