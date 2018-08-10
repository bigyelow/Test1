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
static void *TestScrollableContext = &TestScrollableContext;
static NSString *contentSizeKey = @"contentSize";

@interface TestScrollableViewController () <WKNavigationDelegate>

@property (nonatomic, assign) TEViewCombinationType type;

@property (nonatomic, strong) WKWebView *topWebView;
@property (nonatomic, strong) WKWebView *bottomWebView;

@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) ScrollableDataSource *topDataSource;

@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) ScrollableDataSource *bottomDataSource;

@end

@implementation TestScrollableViewController
@synthesize type = _type;

- (instancetype)initWithType:(TEViewCombinationType)type
{
  if (self = [super init]) {
    _type = type;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.type = _type;
  self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  self.topTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
  self.topWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
  self.bottomTableView.frame = self.view.bounds;
  self.bottomWebView.frame = self.view.bounds;
}

- (void)dealloc
{
  @try {
    if (self.type == TEViewCombinationTypeTopTableBottomWeb || self.type == TEViewCombinationTypeTopTableBottomTable) {
      [self.topTableView removeObserver:self forKeyPath:contentSizeKey];
    }
  }
  @catch (NSException *e) {
    NSLog(@"exception");
  }
}

#pragma mark - Properties

- (TEViewCombinationType)type
{
  return _type;
}

- (void)setType:(TEViewCombinationType)type
{
  _type = type;

  [self.bottomTableView removeFromSuperview];
  [self.bottomWebView removeFromSuperview];
  [self.topTableView removeFromSuperview];
  [self.topWebView removeFromSuperview];

  switch (_type) {
    case TEViewCombinationTypeTopTableBottomWeb:
      [self.view addSubview:self.bottomWebView];
      [self.bottomWebView.scrollView addSubview:self.topTableView];

      [self.topTableView addObserver:self
                          forKeyPath:contentSizeKey
                             options:NSKeyValueObservingOptionNew
                             context:TestScrollableContext];

      [self.bottomWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.zhihu.com/question/24075060/answer/252505809"]]];

      break;

    case TEViewCombinationTypeTopWebBottomTable:
      [self.view addSubview:self.bottomTableView];
      [self.bottomTableView addSubview:self.topWebView];

      [self.topWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.zhihu.com/question/24075060/answer/252505809"]]];

      break;

    case TEViewCombinationTypeTopTableBottomTable:
      [self.view addSubview:self.bottomTableView];
      [self.bottomTableView addSubview:self.topTableView];

      [self.topTableView addObserver:self
                          forKeyPath:contentSizeKey
                             options:NSKeyValueObservingOptionNew
                             context:TestScrollableContext];

      break;

    default:
      break;
  }
}

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

- (WKWebView *)bottomWebView
{
  if (!_bottomWebView) {
    _bottomWebView = [WKWebView new];
  }
  return _bottomWebView;
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
    _topDataSource = [self _te_createDataSourceWithTitle:@"Top" count:5];
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
  if (context == TestScrollableContext && [keyPath isEqualToString:contentSizeKey] && object == self.topTableView) {
    CGFloat contentSizeHeight = [change[NSKeyValueChangeNewKey] CGSizeValue].height;
    if (self.type == TEViewCombinationTypeTopTableBottomTable) {  // Bottom TableView
      self.bottomTableView.contentInset = UIEdgeInsetsMake(contentSizeHeight, 0, 0, 0);
      self.bottomTableView.contentOffset = CGPointMake(0, -contentSizeHeight);
    }
    else if (self.type == TEViewCombinationTypeTopTableBottomWeb) { // Bottom WebView
      self.bottomWebView.scrollView.contentInset = UIEdgeInsetsMake(contentSizeHeight, 0, 0, 0);
      self.bottomWebView.scrollView.contentOffset = CGPointMake(0, -contentSizeHeight);
    }

    // Top TableView
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
