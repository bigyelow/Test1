//
//  PresentingViewController.m
//  Test1
//
//  Created by bigyelow on 14/06/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import "PresentingViewController.h"

@interface PresentingViewController ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation PresentingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = UIColor.whiteColor;
  self.title = self.customTitle ?: @"PresentingVC";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(_te_pushVC)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(_te_cancel)];

  [self.view addSubview:self.textLabel];
  [self.view addSubview:self.closeButton];
}

- (void)dealloc
{
  NSLog(@"Dealloc");
}

- (UILabel *)textLabel
{
  if (!_textLabel) {
    _textLabel = [UILabel new];
    _textLabel.text = @"PresentingVC";
  }
  return _textLabel;
}

- (UIButton *)closeButton
{
  if (!_closeButton) {
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(_te_close) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeButton;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  if (self.presentingViewController) {
    NSLog(@"presenting");
  }
  else if (self.navigationController) {
    NSLog(@"navi");
  }
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.textLabel sizeToFit];
  self.textLabel.center = self.view.center;

  CGSize size = [self.closeButton sizeThatFits:CGSizeZero];
  self.closeButton.frame = CGRectMake(10, 20, size.width, size.height);
}

- (void)_te_close
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_te_cancel
{
  UINavigationController *nav = (UINavigationController *)self.presentingViewController;
  [self dismissViewControllerAnimated:YES completion:^{
    [nav presentViewController:[PresentingViewController new] animated:YES completion:nil];
  }];
}

- (void)_te_pushVC
{
  PresentingViewController *controller = [PresentingViewController new];
  controller.customTitle = @"Presenting2";
  [self.navigationController pushViewController:controller animated:YES];
}

@end
