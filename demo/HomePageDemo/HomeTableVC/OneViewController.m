//
//  OneViewController.m
//  Navi
//
//  Created by campus on 16/5/13.
//  Copyright © 2016年 黄婷. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID=@"CELLID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.textLabel.text=@"fdsf";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



@end
