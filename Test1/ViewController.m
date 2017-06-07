//
//  ViewController.m
//  Test1
//
//  Created by bigyelow on 02/06/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

@import WebKit;

#import "ViewController.h"
#import "SubTestExtension.h"

@interface ViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL tag;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(_te_startToLoad)];
  _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:_webView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  _webView.frame = self.view.bounds;
}

- (void)_te_startToLoad
{
  NSURLRequest *request;
  if (_tag) {
    NSURL *url = [NSURL URLWithString:@"https://erebor.douban.com/redirect/?ad=185609&uid=&bid=c13147858ac7e0c759bc194402c04bfaea7d2193&unit=dale_feed_today_fifth&crtr=&mark=&hn=dis4&sig=690a8833c1fc9b1a9cc91af982bce043b469fe6fa236c49bb88811f81ec3a9895c7421eec35ee5e645976080dabc83eb5e525bafcd013e33b498d1bc2e1332d7&pid=debug_bcc04c2100b7567cbfaf86c98443252a4db7751d&target=https%3A%2F%2Fclick.gridsumdissector.com%2Ftrack.ashx%3Fgsadid%3Dgad_158_vbn837cv"];
    request = [NSURLRequest requestWithURL:url];

    self.tag = NO;
  }
  else {
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];

    self.tag = YES;
  }

  [_webView loadRequest:request];
}


@end
