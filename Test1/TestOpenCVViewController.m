//
//  TestOpenCVViewController.m
//  Test1
//
//  Created by bigyelow on 07/03/2018.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "TestOpenCVViewController.h"
#import "UIImage+OpenCV.h"

@interface TestOpenCVViewController ()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

@end

@implementation TestOpenCVViewController

- (instancetype)init
{
  if (self = [super init]) {
    self.title = @"Test OpenCV";

    UIImage *img1 = [UIImage imageNamed:@"LongImage1"];
    UIImage *img2 = [UIImage imageNamed:@"LongImage2"];

//    img1 = [img1 te_processImageThroughMat];
//    img2 = [img2 te_processImageThroughMat];

    _imageView1 = [[UIImageView alloc] initWithImage:img1];
    _imageView2 = [[UIImageView alloc] initWithImage:img2];
    _imageView3 = [[UIImageView alloc] init];

    [self _te_configImageView:_imageView1];
    [self _te_configImageView:_imageView2];
    [self _te_configImageView:_imageView3];

    [self _te_reset];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *stitchItem = [[UIBarButtonItem alloc] initWithTitle:@"Stitch"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(_te_stitch)];
  UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(_te_reset)];

  self.navigationItem.rightBarButtonItems = @[stitchItem, resetItem];
  self.view.backgroundColor = [UIColor whiteColor];

  [self.view addSubview:_imageView1];
  [self.view addSubview:_imageView2];
  [self.view addSubview:_imageView3];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  CGFloat centerX = self.view.bounds.size.width / 2;
  CGFloat imageWidth = self.view.bounds.size.width / 2;
  CGFloat imageHeight = 400;
  CGFloat imageY = 64;
  _imageView1.frame = CGRectMake(0, imageY, imageWidth, imageHeight);
  _imageView2.frame = CGRectMake(CGRectGetMaxX(_imageView1.frame), imageY, imageWidth, imageHeight);
  _imageView3.frame = CGRectMake(centerX - (imageWidth / 2), imageY, imageWidth, imageHeight);
}

- (void)_te_configImageView:(UIImageView *)imageView
{
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  imageView.backgroundColor = [UIColor redColor];
}

#pragma mark - Private Methods

- (void)_te_stitch
{
  _imageView3.image = [UIImage te_imageByRawStitchingImage:_imageView1.image withImage:_imageView2.image];

  _imageView1.hidden = YES;
  _imageView2.hidden = YES;
  _imageView3.hidden = NO;
}

- (void)_te_reset
{
  _imageView1.hidden = NO;
  _imageView2.hidden = NO;
  _imageView3.hidden = YES;
}

@end
