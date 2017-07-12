//
//  PresentingViewController.m
//  Test1
//
//  Created by bigyelow on 14/06/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import "PresentingViewController.h"

@interface PresentingViewController ()

@end

@implementation PresentingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = self.customTitle ?: @"PresentingVC";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(_te_pushVC)];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(_te_cancel)];
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

- (void)_te_cancel
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_te_pushVC
{
  PresentingViewController *controller = [PresentingViewController new];
  controller.customTitle = @"Presenting2";
  [self.navigationController pushViewController:controller animated:YES];
}

@end
