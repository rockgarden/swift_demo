//
//  BaseTableViewController.h
//  Navi
//
//  Created by campus on 16/5/13.
//  Copyright © 2016年 黄婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewScrollingProtocol <NSObject>

@required
// 返回tableView在Y轴上的偏移量
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY;

@optional
- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY;

@end


@interface BaseTableViewController : UITableViewController
@property (nonatomic, weak) id<TableViewScrollingProtocol> delegate;
@end
