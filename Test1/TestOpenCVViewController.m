//
//  TestOpenCVViewController.m
//  Test1
//
//  Created by bigyelow on 07/03/2018.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "TestOpenCVViewController.h"

@interface TestOpenCVViewController ()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation TestOpenCVViewController

- (instancetype)init
{
  if (self = [super init]) {
    self.title = @"Test OpenCV";

    _imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LongImage1"]];
    _imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LongImage2"]];

    [self _te_configImageView:_imageView1];
    [self _te_configImageView:_imageView2];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_imageView1];
  [self.view addSubview:_imageView2];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  CGFloat imageWidth = self.view.bounds.size.width / 2;
  CGFloat imageHeight = 400;
  CGFloat imageY = 64;
  _imageView1.frame = CGRectMake(0, imageY, imageWidth, imageHeight);
  _imageView2.frame = CGRectMake(CGRectGetMaxX(_imageView1.frame), imageY, imageWidth, imageHeight);
}

- (void)_te_configImageView:(UIImageView *)imageView
{
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor redColor];
}

@end
