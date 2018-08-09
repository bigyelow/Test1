//
//  ScrollableDataSource.m
//  Test1
//
//  Created by bigyelow on 2018/8/9.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "ScrollableDataSource.h"

@implementation ScrollableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
  cell.textLabel.text = _data[indexPath.row];
  return cell;
}

@end
