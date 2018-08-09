//
//  TestScrollableViewController.m
//  Test1
//
//  Created by bigyelow on 2018/8/9.
//  Copyright © 2018 huangduyu. All rights reserved.
//

@import WebKit;

#import "TestScrollableViewController.h"
#import "ScrollableDataSource.h"

static const NSInteger RowHeight = 44;
static void *TestScollableContext = &TestScollableContext;
static NSString *contentSizeKey = @"contentSize";

@interface TestScrollableViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *topWebView;
@property (nonatomic, assign) CGFloat lastContentHeight;

@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) ScrollableDataSource *topDataSource;

@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) ScrollableDataSource *bottomDataSource;

@end

@implementation TestScrollableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.view addSubview:self.bottomTableView];
  [self.bottomTableView addSubview:self.topWebView];

  [self.topWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.zhihu.com/question/24075060/answer/252505809"]]];

  self.edgesForExtendedLayout = UIRectEdgeNone;

//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Switch"
//                                                                            style:UIBarButtonItemStylePlain
//                                                                           target:self
//                                                                           action:@selector(_te_switch)];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  self.topTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
  self.topWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
  self.bottomTableView.frame = self.view.bounds;
}

- (void)dealloc
{
  @try {
    [self.topTableView removeObserver:self forKeyPath:contentSizeKey];
  }
  @catch (NSException *e) {
    NSLog(@"exception");
  }
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

- (WKWebView *)topWebView
{
  if (!_topWebView) {
    _topWebView = [[WKWebView alloc] init];
    _topWebView.navigationDelegate = self;
  }
  return _topWebView;
}

- (UITableView *)bottomTableView
{
  if (!_bottomTableView) {
    _bottomTableView = [self _te_createTableView];
    _bottomTableView.dataSource = self.bottomDataSource;
    _bottomTableView.delegate = self.bottomDataSource;
    _bottomTableView.backgroundColor = UIColor.blueColor;
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
  if (context == TestScollableContext && [keyPath isEqualToString:contentSizeKey] && object == self.topTableView) {
    // BottomTableView
    CGFloat contentSizeHeight = [change[NSKeyValueChangeNewKey] CGSizeValue].height;
    self.bottomTableView.contentInset = UIEdgeInsetsMake(contentSizeHeight, 0, 0, 0);
    self.bottomTableView.contentOffset = CGPointMake(0, -contentSizeHeight);

    // TopTableView
    CGRect frame = self.topTableView.frame;
    frame = CGRectMake(0, -contentSizeHeight, frame.size.width, contentSizeHeight);
    self.topTableView.frame = frame;
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

#pragma mark - WebView Delegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
  if (webView.isLoading) {
    return;
  }

  [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable height, NSError * _Nullable error) {
    if ([height isKindOfClass:NSNumber.class]) {
      CGFloat contentSizeHeight = [height floatValue] + 40;
      self.bottomTableView.contentInset = UIEdgeInsetsMake(contentSizeHeight, 0, 0, 0);
      self.bottomTableView.contentOffset = CGPointMake(0, -contentSizeHeight);

      // TopTableView
      CGRect frame = self.topWebView.frame;
      frame = CGRectMake(0, -contentSizeHeight, frame.size.width, contentSizeHeight);
      self.topWebView.frame = frame;
    }
  }];
}

#pragma mark - Action

- (void)_te_switch
{
  // Top TableView
  if (self.topWebView.superview) {
    [self.topWebView removeFromSuperview];
    [self.bottomTableView addSubview:self.topTableView];

    [self.topTableView addObserver:self
                        forKeyPath:contentSizeKey
                           options:NSKeyValueObservingOptionNew
                           context:TestScollableContext];
    [self.topTableView reloadData];
  }

  // Top WebView
  else if (self.topTableView.superview) {
    [self.topTableView removeFromSuperview];
    [self.bottomTableView addSubview:self.topWebView];

    [self.topTableView removeObserver:self forKeyPath:contentSizeKey];
    [self.topWebView reload];
  }
}

#pragma mark - Helper

- (CGFloat)_te_viewHeight
{
  return UIScreen.mainScreen.bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height
  - self.navigationController.navigationBar.bounds.size.height;
}

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
