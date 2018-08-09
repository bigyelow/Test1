//
//  TestScrollableViewController.m
//  Test1
//
//  Created by bigyelow on 2018/8/9.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "TestScrollableViewController.h"
#import "ScrollableDataSource.h"

static const NSInteger RowHeight = 44;
static void *BottomTableViewContentSizeContext = &BottomTableViewContentSizeContext;
static NSString *observedKey = @"contentSize";

@interface TestScrollableViewController ()

@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) ScrollableDataSource *topDataSource;

@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) ScrollableDataSource *bottomDataSource;

@property (nonatomic, strong) UIView *topHeader;

@end

@implementation TestScrollableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.view addSubview:self.bottomTableView];
//  [self.bottomTableView addSubview:self.topHeader];
  [self.bottomTableView addSubview:self.topTableView];

  self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  self.topHeader.frame = CGRectMake(0, -5 * RowHeight, self.view.bounds.size.width, 5 * RowHeight);
  self.topTableView.frame = CGRectMake(0, -5 * RowHeight, self.view.bounds.size.width, 5 * RowHeight);
  self.bottomTableView.frame = self.view.bounds;
}

- (void)dealloc
{
  [self.bottomTableView removeObserver:self forKeyPath:observedKey];
}

#pragma mark - Properties

- (UITableView *)topTableView
{
  if (!_topTableView) {
    _topTableView = [self _te_createTableView];
    _topTableView.dataSource = self.topDataSource;
    _topTableView.delegate = self.topDataSource;
  }
  return _topTableView;
}

- (UITableView *)bottomTableView
{
  if (!_bottomTableView) {
    _bottomTableView = [self _te_createTableView];
    _bottomTableView.dataSource = self.bottomDataSource;
    _bottomTableView.delegate = self.bottomDataSource;
    _bottomTableView.contentInset = UIEdgeInsetsMake(RowHeight * 5, 0, 0, 0);
    _bottomTableView.backgroundColor = UIColor.blueColor;

    [_bottomTableView addObserver:self forKeyPath:observedKey options:NSKeyValueObservingOptionNew context:BottomTableViewContentSizeContext];
  }
  return _bottomTableView;
}

- (ScrollableDataSource *)topDataSource
{
  if (!_topDataSource) {
    _topDataSource = [self _te_createDataSourceWithTitle:@"Top" count:60];
  }
  return _topDataSource;
}

- (ScrollableDataSource *)bottomDataSource
{
  if (!_bottomDataSource) {
    _bottomDataSource = [self _te_createDataSourceWithTitle:@"Bottom" count:60];
  }
  return _bottomDataSource;
}

- (UIView *)topHeader
{
  if (!_topHeader) {
    _topHeader = [[UIView alloc] init];
    _topHeader.backgroundColor = UIColor.redColor;
  }
  return _topHeader;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
  if (context == BottomTableViewContentSizeContext && [object isKindOfClass:UITableView.class]) {
    [((UITableView *)object) scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                   atScrollPosition:UITableViewScrollPositionBottom
                                           animated:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - Helper

- (UITableView *)_te_createTableView
{
  UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero];
  view.rowHeight = RowHeight;
  [view registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
  return view;
}

- (ScrollableDataSource *)_te_createDataSourceWithTitle:(NSString *)title count:(NSUInteger)count
{
  ScrollableDataSource *dataSource = [[ScrollableDataSource alloc] init];
  NSMutableArray<NSString *> *data = [[NSMutableArray alloc] initWithCapacity:count];
  for (NSUInteger i = 0; i < count; ++i) {
    [data addObject:[NSString stringWithFormat:@"%@ %@", @(i), title]];
  }
  dataSource.data = data;
  return dataSource;
}

@end
