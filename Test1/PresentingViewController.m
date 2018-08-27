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
