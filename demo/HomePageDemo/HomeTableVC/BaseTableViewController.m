//
//  BaseTableViewController.m
//  Navi
//
//  Created by campus on 16/5/13.
//  Copyright © 2016年 黄婷. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsHorizontalScrollIndicator  = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 360)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    if (self.tableView.contentSize.height < [UIScreen mainScreen].bounds.size.height + 360 - 64 ) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.width + 360 - 64 - self.tableView.contentSize.height, 0);
    }
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
}



#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if ([self.delegate respondsToSelector:@selector(tableViewScroll:offsetY:)]) {
        [self.delegate tableViewScroll:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDragging:offsetY:)]) {
        [self.delegate tableViewWillBeginDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDecelerating:offsetY:)]) {
        [self.delegate tableViewWillBeginDecelerating:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDragging:offsetY:)]) {
        [self.delegate tableViewDidEndDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:offsetY:)]) {
        [self.delegate tableViewDidEndDecelerating:self.tableView offsetY:offsetY];
    }
}
@end