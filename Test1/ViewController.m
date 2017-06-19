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
#import "PresentingViewController.h"

@interface ViewController () <NSURLSessionDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL tag;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Home";

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(_te_testHTTP2)];
  _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:_webView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  _webView.frame = self.view.bounds;
}

- (void)_te_testHTTP2
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  configuration.HTTPAdditionalHeaders = @{@"User-Agent": @"api-client/0.1.3 com.douban.frodo/4.9.0 iOS/10.2 x86_64"};
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

  NSString *string1 = @"https://211.147.4.40/api/v2/group/yinxiangbiji?apikey=0dad551ec0f84ed02907ff5c42e8ec70&alt=json&douban_udid=e42a26fba5a1b560a4e6a465bb033e7ea402e4ff&event_loc_id=108288&latitude=0&loc_id=108288&longitude=0&udid=77cbb9dd272e97162d19281f92978a0049768e11&version=4.9.0";
  NSString *string2 = @"https://frodo.douban.com/api/v2/movie/26873826?alt=json&apikey=0b8257e8bcbc63f4228707ba36352bdc&douban_udid=e42a26fba5a1b560a4e6a465bb033e7ea402e4ff&event_loc_id=108288&latitude=0&loc_id=108288&longitude=0&udid=77cbb9dd272e97162d19281f92978a0049768e11&version=4.9.0";
  NSURL *url = [NSURL URLWithString:string1];
  NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                        if (error) {
                                          NSLog(@"error");
                                        }
                                        else {
                                          NSLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                        }
                                      }];
  [task resume];
}

- (void)_te_presentVC
{
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[PresentingViewController new]]
                     animated:YES
                   completion:nil];
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

#pragma mark - URLSession delegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
  completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

@end
