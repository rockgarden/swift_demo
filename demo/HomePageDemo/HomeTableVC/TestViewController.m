//
//  TestViewController.m
//  Navi
//
//  Created by campus on 16/5/13.
//  Copyright © 2016年 黄婷. All rights reserved.
//

#import "TestViewController.h"
#import "Masonry.h"
#import "FXBlurView.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "BaseTableViewController.h"

#define offset_HeaderStop  64.0
#define offset_B_LabelHeader 80.0
#define distance_W_LabelHeader 44.0

@interface TestViewController ()<TableViewScrollingProtocol>
@property (strong, nonatomic) UIView *header;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIImageView *avatarImage;
@property (strong,nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic)UIImageView *headerBlurImageView;

@property (strong,nonatomic)UIView *topView;

@property (strong,nonatomic)UISegmentedControl *segment;


@property (nonatomic, weak) UIViewController *showingVC;
@property (nonatomic, strong) NSMutableDictionary *offsetYDict; // 存储每个tableview在Y轴上的偏移量

@property (nonatomic,strong)UIView *bgview;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatSubview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage  = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.subviews[0].alpha = 1;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage  = nil;
}

#pragma mark-创建视图
- (void)creatSubview{
    [self addController];
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:vc.view];
    
    self.header = [[UIView alloc] init];
    [self.view addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@145);
    }];
    
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.text = @"公司首页";
    _headerLabel.textColor = [UIColor whiteColor];
    [_header addSubview:_headerLabel];
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(144);
    }];
    
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@360);
    }];
    
    _bgview  = [[UIView alloc] init];
    _bgview.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_bgview];
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(_topView.mas_bottom);
        make.height.equalTo(@70);
    }];
    
    _headerImageView = [[UIImageView alloc]init];
    _headerImageView.image = [UIImage imageNamed:@"header_bg@2x.jpg"];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_header insertSubview:_headerImageView belowSubview:_headerLabel];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_top);
        make.left.equalTo(self.header);
        make.right.equalTo(self.header);
        make.bottom.equalTo(self.header);
    }];
    
    _headerBlurImageView = [[UIImageView alloc]init];
    _headerBlurImageView.image = [[UIImage imageNamed:@"header_bg@2x.jpg"]  blurredImageWithRadius:10 iterations:20 tintColor:[UIColor clearColor]];
    _headerBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerBlurImageView.alpha = 0;
    [_header insertSubview:_headerBlurImageView belowSubview:_headerLabel];
    _header.clipsToBounds = YES;
    
    [self.headerBlurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_top);
        make.left.equalTo(self.header);
        make.right.equalTo(self.header);
        make.bottom.equalTo(self.header);
    }];
    
    _avatarImage = [[UIImageView alloc] init];
    _avatarImage.backgroundColor = [UIColor whiteColor];
    [self.topView addSubview:_avatarImage];
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(_headerImageView.mas_bottom).with.offset(-36);
        make.width.equalTo(@72);
        make.height.equalTo(@72);
    }];
    _avatarImage.layer.cornerRadius = 10.0;
    _avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImage.layer.borderWidth = 3.0;
    _avatarImage.image = [UIImage imageNamed:@"profile@2x.jpg"];
    
    
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"未处理项",@"面试日程",@"简历分析"]];
    _segment.selected = YES;
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.topView addSubview:_segment];
    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.bottom.equalTo(@-12);
    }];
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = [UIColor grayColor];
    [_topView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];

}

- (void)addController{
    OneViewController *oneVC  = [[OneViewController alloc] init];
    oneVC.delegate = self;
    [self addChildViewController:oneVC];
    TwoViewController *twoVC= [[TwoViewController alloc] init];
    [self addChildViewController:twoVC];
    ThreeViewController *threeVC = [[ThreeViewController alloc] init];
    threeVC.delegate = self;
    [self addChildViewController:threeVC];
}

#pragma mark - 切换视图
- (void)segmentAction:(UISegmentedControl *)segment {
    BaseTableViewController *selectedVC = self.childViewControllers[segment.selectedSegmentIndex];
    if (!selectedVC.view.superview) {
        selectedVC.view.frame = self.view.bounds;
    }
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", selectedVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    selectedVC.tableView.contentOffset = CGPointMake(0, offsetY);
    [self.view insertSubview:selectedVC.view belowSubview:self.header];
    
}


#pragma mark - Getter/Setter
- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}

#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    
    CATransform3D avatarTransform = CATransform3DIdentity;
    CATransform3D headerTransform = CATransform3DIdentity;
    CATransform3D topViewTransform = CATransform3DIdentity;
    
    if (offsetY < 215) {
        [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(- offsetY); }];
    } else {
        [_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-215); }];
    }
    
    if (offsetY < 0) {
        CGFloat headerScaleFactor = -(offsetY) / _header.bounds.size.height;
        CGFloat headerSizevariation = ((_header.bounds.size.height * (1.0 + headerScaleFactor)) - _header.bounds.size.height)/2.0;
        
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        _header.layer.transform = headerTransform;
        
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, -offsetY, 0);
        topViewTransform = CATransform3DTranslate(topViewTransform, 0, -offsetY, 0);
    } else {
        // Header -----------
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offsetY), 0);
        
        //  ------------ Label
        
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offsetY), 0);
        _headerLabel.layer.transform = labelTransform;
        
        //  ------------ Blur
        
        _headerBlurImageView.alpha = MIN(1.0, (offsetY - offset_B_LabelHeader)/distance_W_LabelHeader);
        
        // Avatar -----------
        CGFloat avatarScaleFactor = (MIN(offset_HeaderStop, offsetY)) / _avatarImage.bounds.size.height / 3.0;
        
        CGFloat avatarSizeVariation = (-offsetY) / 2.0;
        
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
        
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        
        if (offsetY <= offset_HeaderStop) {
            if (_avatarImage.layer.zPosition < _header.layer.zPosition){
                _header.layer.zPosition = 0;
            }
        } else {
            if (_avatarImage.layer.zPosition >= _header.layer.zPosition){
                _header.layer.zPosition = 2;
            }
        }
    }
    
    // Apply Transformations
    _header.layer.transform = headerTransform;
    _avatarImage.layer.transform = avatarTransform;
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > 360 - 64) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= 360 - 64) {
                _offsetYDict[key] = @(360 - 64);
            }
        }];
    } else {
        if (offsetY <= 360 - 64) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > 360 - 64) {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                _offsetYDict[key] = @(offsetY);
            } else if ([_offsetYDict[key] floatValue] <= 360 - 64) {
                _offsetYDict[key] = @(360 - 64);
            }
        }];
    } else {
        if (offsetY <=360 - 64) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                _offsetYDict[key] = @(offsetY);
            }];
        }
    }
}

@end
