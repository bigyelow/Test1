//
//  TestScollableListViewController.m
//  Test1
//
//  Created by bigyelow on 2018/8/10.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "TestScollableListViewController.h"
#import "TestScrollableViewController.h"

@interface TestScollableListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *data;

@end

@implementation TestScollableListViewController

- (void)viewDidLoad 
{
  [super viewDidLoad];
  [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  self.tableView.frame = self.view.bounds;
}

- (NSArray *)data
{
  if (!_data) {
    _data = @[@"Top TableView + Bottom TableView",
              @"Top TableView + Bottom WebView",
              @"Top WebView + Bottom TableView"];
  }
  return _data;
}

- (UITableView *)tableView
{
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
  }

  return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
  cell.textLabel.text = self.data[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  TestScrollableViewController *vc = [[TestScrollableViewController alloc] initWithType:indexPath.row];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
