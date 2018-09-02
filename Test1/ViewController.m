//
//  ViewController.m
//  Test1
//
//  Created by bigyelow on 02/06/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

@import WebKit;
@import Polymorph;
@import libextobjc;
@import SafariServices;
@import DOUFoundation;

#import "ViewController.h"
#import "SubTestExtension.h"
#import "PresentingViewController.h"
#import "TCommond.h"
#import "Test1-Swift.h"
#import "TestBlockObject.h"
#import "TestOpenCVViewController.h"
#import "TestScollableListViewController.h"
#import "TestTransitionDelegate.h"

static NSString * const WKWebViewStr = @"WKWebView";
static NSString * const ImageStr = @"Image";
static NSString * const VideoStr = @"Video";
static NSString * const NSURLSessionStr = @"NSURLSession";
static NSString * const URLEncodingStr = @"NSURLEncoding";
static NSString * const PresentingStr = @"Presenting";
static NSString * const Nullability = @"Nullability";
static NSString * const OpenURL = @"OpenURL";
static NSString * const Block = @"Block";
static NSString * const Macro = @"Macro";
static NSString * const AuthenticationSession = @"AuthenticationSession";
static NSString * const OpenCV = @"OpenCV";
static NSString * const CommonTest = @"CommonTest";
static NSString * const GCD = @"GCD";
static NSString * const Scrollable = @"Scrollable";
static NSString * const Transition = @"Transition";
static NSString * const MTURLProtocol = @"MTURLProtocol";
static NSString * const SimpleAlgorithmTest = @"SimpleAlgorithmTest";
static NSInteger OpenURLCount = 0;

@interface ViewController () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (nonatomic, copy) NSArray *demos;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL tag;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger resignCount;
@property (nonatomic, assign) NSInteger becomeActiveCount;
@property (nonatomic, assign) NSInteger enterBackgroundCount;
@property (nonatomic, assign) NSInteger enterForegroundCount;
@property (nonatomic, strong) TestBlockObject *blockObject;
@property (nonatomic, copy) NSArray<NSString *>* appURLs;
@property (nonatomic, strong) SFAuthenticationSession *session;
@property (nonatomic, strong) id<UIViewControllerTransitioningDelegate> transitionDelegate;

@end

@implementation ViewController

- (instancetype)init
{
  if (self = [super init]) {
    _demos = @[SimpleAlgorithmTest,
               Transition,
               Scrollable,
               WKWebViewStr,
               ImageStr,
               VideoStr,
               NSURLSessionStr,
               URLEncodingStr,
               PresentingStr,
               Nullability,
               OpenURL,
               Block,
               Macro,
               AuthenticationSession,
               OpenCV,
               CommonTest,
               GCD];
    _appURLs = @[@"weixin://weixin.com/",
                 @"letvclient://letvclient.com/xxx",
                 @"pptv://pptv.com/ddd", @"sohuvideo://xxx.com/",
                 @"iqiyi://iqiyi.com/", @"pptv://page/player/halfscreen?type=vod&vid=17083193&sid=17083193",
                 @"http://link-jump.youku.com/a/b/?spm=a2hmv.20009921.m_86987.5~5~5~5~5~5~5~A&action=play&vid=755070962&source=yksmartbanner_player_1&ua=Mozilla%2F5.0%20(iPhone%3B%20CPU%20iPhone%20OS%2010_0%20like%20Mac%20OS%20X)%20AppleWebKit%2F602.1.38%20(KHTML%2C%20like%20Gecko)%20Version%2F10.0%20Mobile%2F14A300%20Safari%2F602.1&ccts=1505447052960&cookieid=1505446352536Um0qvK%7Cwve5hf&fua=safari&special=1&ts=1505447052962&position=yksmartbanner_player_1"];
    _appURLs = @[@"douban://douban.com/webview?url=https://www.douban.com/doubanapp/dispatch?uri=/skynet/playlist/46283721%26fallback%3dhttps%3a%2f%2fm.douban.com%2fpage%2fouy7i2r+"];
    OpenURLCount = _appURLs.count - 1;
    _becomeActiveCount = -1;
    _blockObject = [TestBlockObject new];
    _blockObject.block = ^{
      NSMutableArray *array = [@[@"1", @"2"] mutableCopy];
      [array addObject:@"3"];
      [array addObject:@"4"];

      NSLog(@"Begin\n");

      for (NSString *obj in array) {
        NSLog(@"%@", obj);
      }
    };
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.title = @"Home";

  // TableView
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [self.view addSubview:_tableView];

  // WebView
  _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
  _webView.hidden = YES;
  _webView.navigationDelegate = self;
  [self.view addSubview:_webView];

  // Navigation bar
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_te_UIApplicationWillResignActiveNotification)
                                               name:UIApplicationWillResignActiveNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_te_UIApplicationDidBecomeActiveNotification)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_te_UIApplicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_te_UIApplicationWillEnterForegroundNotification)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  _tableView.frame = self.view.bounds;
  _webView.frame = self.view.bounds;
}

#pragma mark - TableView delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _demos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])
                                                          forIndexPath:indexPath];
  cell.textLabel.text = _demos[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  if ([_demos[indexPath.row] isEqualToString:WKWebViewStr]) {
    [self _te_startToLoad];
  }
//  else if ([_demos[indexPath.row] isEqualToString:ImageStr]) {
//    [self.navigationController pushViewController:[ImageProcessorViewController new] animated:YES];
//  }
  else if ([_demos[indexPath.row] isEqualToString:VideoStr]) {

  }
  else if ([_demos[indexPath.row] isEqualToString:NSURLSessionStr]) {
    [self _te_testHTTP2];
  }
  else if ([_demos[indexPath.row] isEqualToString:URLEncodingStr]) {
    [self _te_testURLEncoding];
  }
  else if ([_demos[indexPath.row] isEqualToString:PresentingStr]) {
    [self _te_presentVC];
  }
  else if ([_demos[indexPath.row] isEqualToString:Nullability]) {
    TCommond *commond = [[TCommond alloc] initWithID:@"123" name:nil];
    TestNullabilityViewController *ctr = [[TestNullabilityViewController alloc] initWithCommond:commond];
    [self.navigationController pushViewController:ctr animated:YES];
  }
  else if ([_demos[indexPath.row] isEqualToString:OpenURL]) {
    NSUInteger index = OpenURLCount++ % _appURLs.count;
    NSURL *url = [NSURL URLWithString:_appURLs[index]];
    if ([UIApplication.sharedApplication canOpenURL:url]) {
      [UIApplication.sharedApplication openURL:url
                                       options:@{}
                             completionHandler:^(BOOL success) {
                               NSLog(success ? @"success" : @"failure");
                             }];
    }
  }
  else if ([_demos[indexPath.row] isEqualToString:Block]) {
    [_blockObject doBlock];
  }
  else if ([_demos[indexPath.row] isEqualToString:Macro]) {
    [self _te_testMacro];
  }
  else if ([_demos[indexPath.row] isEqualToString:AuthenticationSession]) {
    [self _te_testAuthenticationSession];
  }
  else if ([_demos[indexPath.row] isEqualToString:CommonTest]) {
    [self _te_commonTest];
  }
  else if ([_demos[indexPath.row] isEqualToString:OpenCV]) {
    [self.navigationController pushViewController:[[TestOpenCVViewController alloc] init] animated:YES];
  }
  else if ([_demos[indexPath.row] isEqualToString:GCD]) {
    [self _te_testGCD];
  }
  else if ([_demos[indexPath.row] isEqualToString:Scrollable]) {
    TestScollableListViewController *vc = [TestScollableListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else if ([_demos[indexPath.row] isEqualToString:MTURLProtocol]) {

  }
  else if ([_demos[indexPath.row] isEqualToString:Transition]) {
    PresentingViewController *vc = [PresentingViewController new];
    vc.transitioningDelegate = self.transitionDelegate;
    [self presentViewController:vc animated:YES completion:nil];
  }
  else if ([_demos[indexPath.row] isEqualToString:SimpleAlgorithmTest]) {
    // Test Distance
    BOOL result =  [TestSwift testDistanceWithNums:@[@1, @2, @3, @1] k:3];
    NSLog(result ? @"YES" : @"NO");

    result = [TestSwift testDistanceWithNums:@[@1, @0, @1, @1] k:1];
    NSLog(result ? @"YES" : @"NO");

    result = [TestSwift testDistanceWithNums:@[@1, @2, @3, @1, @2, @3] k:2];
    NSLog(result ? @"YES" : @"NO");

    // Test arrayPairSum
    NSInteger sum = [TestSwift arrayPairSum:@[@1, @4, @3, @2]];
    NSLog(@"sum = %@", @(sum));
  }
}

#pragma mark - Properties

- (id<UIViewControllerTransitioningDelegate>)transitionDelegate
{
  if (!_transitionDelegate) {
    _transitionDelegate = [TestTransitionDelegate new];
  }
  return _transitionDelegate;
}

#pragma mark - Test

- (void)_te_startToLoad
{
  _webView.hidden = NO;

  UIBarButtonItem *hiddenWebViewItem = [[UIBarButtonItem alloc] initWithTitle:@"Hidden"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(_te_hiddenWebView)];
  UIBarButtonItem *startLoadItem = [[UIBarButtonItem alloc] initWithTitle:@"Start"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(_te_startToLoad)];
  self.navigationItem.rightBarButtonItems = @[startLoadItem, hiddenWebViewItem];

  NSURLRequest *request;
  if (_tag) {
    NSURL *url = [NSURL URLWithString:@"https://nextidea.qq.com/cp/a20180702music/?qz_gdt=tytvqwyraaafoiga3rsq&_wv=1&dt_dapp=1"];
    request = [NSURLRequest requestWithURL:url];

    self.tag = NO;
  }
  else {
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];

    self.tag = YES;
  }

  NSMutableURLRequest *mRequest = [request mutableCopy];
  [mRequest setValue:@"dafecad" forHTTPHeaderField:@"User-Agent"];

  [_webView loadRequest:mRequest];
}

- (void)_te_presentVC
{
  [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[PresentingViewController new]]
                     animated:YES
                   completion:nil];
}

- (void)_te_testURLEncoding
{
  [TestSwift test];
}

- (void)_te_testHTTP2
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  configuration.HTTPAdditionalHeaders = @{@"User-Agent": @"api-client/0.1.3 com.douban.frodo/4.9.0 iOS/10.2 x86_64"};
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

  NSString *urlStr = @"https://frodo.douban.com/api/v2/movie/26873826?alt=json&apikey=0b8257e8bcbc63f4228707ba36352bdc&douban_udid=e42a26fba5a1b560a4e6a465bb033e7ea402e4ff&event_loc_id=108288&latitude=0&loc_id=108288&longitude=0&udid=77cbb9dd272e97162d19281f92978a0049768e11&version=4.9.0";
  NSURL *url = [NSURL URLWithString:urlStr];
  NSURLSessionDataTask *task = [session dataTaskWithURL:url];
//  NSURLSessionDataTask *task = [session dataTaskWithURL:url
//                                      completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                        if (error) {
//                                          NSLog(@"error");
//                                        }
//                                        else {
//                                          NSLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                                        }
//                                      }];
  [task resume];
}

- (void)_te_hiddenWebView
{
  _webView.hidden = YES;

  self.navigationItem.rightBarButtonItems = nil;
}

- (void)_te_testMacro
{

}

- (void)_te_testAuthenticationSession
{
  NSURL *url = [NSURL URLWithString:@"http://192.168.1.103:8000?redirect"];
  _session = [[SFAuthenticationSession alloc] initWithURL:url
                                        callbackURLScheme:@"douban"
                                        completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
                                          if (!error && callbackURL.path) {
                                            if (callbackURL.path) {
                                              UIAlertController *controller = [UIAlertController alertControllerWithTitle:[callbackURL.path substringFromIndex:1] message:nil preferredStyle:UIAlertControllerStyleAlert];

                                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                              [controller addAction:action];
                                              [self presentViewController:controller animated:YES completion:nil];
                                            }
                                          }
                                        }];

  [_session start];
}

- (void)_te_commonTest
{
  NSURLComponents *comp = [NSURLComponents componentsWithString:@"douban://douban.com/alert_dialog"];
  NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:@"data" value:@"{\"title\":\"隐私政策更新\",\"message\":\"我们更新了《豆瓣隐私政策》，在这里你可以了解我们如何收集、使用、保护你的个人信息以及你享有的权利等内容。2018年8月30日起，如果你继续使用豆瓣，即表示你同意接受更新的隐私政策。\",\"buttons\":[{\"text\":\"查看详情\",\"action\":\"https://accounts.douban.com/passport/agreement\"},{\"text\":\"我知道了\",\"action\":\"\"}]}"];
  comp.queryItems = @[item];
  NSLog(comp.URL.absoluteString);
}

- (void)_te_testGCD
{
  dispatch_queue_t q = dispatch_queue_create("com.bigyelow.test", DISPATCH_QUEUE_CONCURRENT);

  // 2. 同步执行
  for (int i = 0; i < 10; ++i) {
    dispatch_async(q, ^{
      for (int j = 0; j < 100; ++j) {
        NSLog(@"task %@: %@th job", @(i), @(j));
      }
    });
  }

  NSLog(@"come here - %@",[NSThread currentThread]);
}

#pragma mark - Notifications
- (void)_te_UIApplicationWillResignActiveNotification
{
  NSLog(@"resign active: %@", @(++_resignCount));
  NSLog(@"UIApplicationWillResignActiveNotification");
}

- (void)_te_UIApplicationDidEnterBackgroundNotification
{
  NSLog(@"enter background: %@", @(++_enterBackgroundCount));
  NSLog(@"UIApplicationDidEnterBackgroundNotification");
}

- (void)_te_UIApplicationWillEnterForegroundNotification
{
  NSLog(@"enter foreground: %@", @(++_enterForegroundCount));
  NSLog(@"UIApplicationWillEnterForegroundNotification");
}

- (void)_te_UIApplicationDidBecomeActiveNotification
{
  NSLog(@"become active: %@", @(++_becomeActiveCount));
  NSLog(@"UIApplicationDidBecomeActiveNotification");
}

#pragma mark - URLSession delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  NSLog(@"data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  if (!error) {
    NSLog(@"no error");
  }
}

//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
// completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
//{
//  completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
//}

#pragma mark - WKWebView delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  decisionHandler(WKNavigationActionPolicyAllow);
}
@end
