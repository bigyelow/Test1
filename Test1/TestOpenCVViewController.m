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
@property (nonatomic, copy) NSArray *array1;
@property (nonatomic, copy) NSArray *array2;
@property (nonatomic, assign) NSInteger imageIndex;

@end

@implementation TestOpenCVViewController

- (instancetype)init
{
  if (self = [super init]) {
    self.title = @"Test OpenCV";

    _array1 = @[@"LongImage23", @"LongImage23", @"LongImage20", @"LongImage20", @"LongImage18", @"LongImage1", @"LongImage3", @"LongImage4", @"LongImage6", @"LongImage8", @"LongImage9", @"LongImage10", @"LongImage11", @"LongImage13", @"LongImage14", @"LongImage15"];
    _array2 = @[@"LongImage24", @"LongImage25", @"LongImage21", @"LongImage22", @"LongImage19", @"LongImage2", @"LongImage4", @"LongImage5", @"LongImage7", @"LongImage9", @"LongImage10", @"LongImage11", @"LongImage12", @"LongImage14", @"LongImage15", @"LongImage16"];

//    _array1 = @[@"LongImageA", @"LongImageB", @"LongImageC", @"LongImageD", @"LongImageE",
//                @"LongImageF", @"LongImageG", @"LongImageH", @"LongImageI", @"LongImageJ",
//                @"LongImageK", @"LongImageL", @"LongImageM", @"LongImageN"];
//    _array2 = @[@"LongImageB", @"LongImageC", @"LongImageD", @"LongImageE",
//                @"LongImageF", @"LongImageG", @"LongImageH", @"LongImageI", @"LongImageJ",
//                @"LongImageK", @"LongImageL", @"LongImageM", @"LongImageN", @"LongImageO"];
    _imageIndex = -1;

    _imageView1 = [[UIImageView alloc] init];
    _imageView2 = [[UIImageView alloc] init];
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

  CGFloat imageY = 64;
  CGFloat imageWidth = self.view.bounds.size.width / 2;
  CGFloat topImageHeight = (self.view.bounds.size.height - imageY) / 2 - 40;
  CGFloat bottomImageHeight = self.view.bounds.size.height - imageY - topImageHeight;

  _imageView1.frame = CGRectMake(0, imageY, imageWidth, topImageHeight);
  _imageView2.frame = CGRectMake(CGRectGetMaxX(_imageView1.frame), imageY, imageWidth, topImageHeight);
  _imageView3.frame = CGRectMake(0, CGRectGetMaxY(_imageView1.frame), imageWidth, bottomImageHeight);
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
  NSError *error;

//  UIImage *stitched;
//  for (NSInteger i = 4; i < _array1.count; ++i) {
//    UIImage *source;
//    if (stitched) {
//      source = stitched;
//    }
//    else {
//      source = [UIImage imageNamed:_array1[i - 1]];
//    }
//    UIImage *target = [UIImage imageNamed:_array1[i]];
//    stitched = [UIImage te_imageByNoOverlapStitchingImage:source withImage:target error:nil];
//    if (!stitched) {
//      break;
//    }
//  }
//
//  _imageView3.image = stitched;

  UIImage *source = [UIImage imageNamed:_array1[_imageIndex]];
  UIImage *target = [UIImage imageNamed:_array2[_imageIndex]];
  _imageView3.image = [UIImage te_imageByNoOverlapStitchingImage:source withImage:target error:nil];
}

- (void)_te_reset
{
  _imageIndex = (++_imageIndex % _array1.count);
  _imageView1.image = [UIImage imageNamed:_array1[_imageIndex]];
  _imageView2.image = [UIImage imageNamed:_array2[_imageIndex]];
}

@end
