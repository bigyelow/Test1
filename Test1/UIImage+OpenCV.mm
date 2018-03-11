//
//  UIImage+OpenCV.m
//  Test1
//
//  Created by bigyelow on 07/03/2018.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#ifdef __cplusplus
#undef NO
#undef YES
#include <opencv2/opencv.hpp>
#include <opencv2/features2d/features2d.hpp>
#endif

#import "UIImage+OpenCV.h"
#import "StitchingConstants.h"

using namespace std;
using namespace cv;

static const int TopBottomOverlapThreshold = 0.05;

@implementation UIImage (OpenCV)

- (UIImage *)te_processImageThroughMat
{
  Mat mat = [self _te_cvMat];
  return [[self class] _te_UIImageFromCVMat:mat];
}

#pragma mark - Stitching

+ (UIImage *)te_imageByNoOverlapStitchingImage:(UIImage *)image1 withImage:(UIImage *)image2 error:(NSError **)error
{
  Mat mat1 = [image1 _te_cvMat];
  Mat mat2 = [image2 _te_cvMat];

  // Detect if dimensions are equal
  if (compareMatDimension(mat1, mat2) == false) {
    *error = [NSError errorWithDomain:teErrorDomainStitching code:teErrorCodeStitchingMatNotEqual userInfo:nil];
    return nil;
  }

  Mat greyMat1, greyMat2;
  cvtColor(mat1, greyMat1, CV_BGR2GRAY);
  cvtColor(mat2, greyMat2, CV_BGR2GRAY);

  // Detect top overlapping region
  cout << "Detect top overlapping region\n";
  int top;
  for (top = 0; top < greyMat1.rows; ++top) {
    Mat result = greyMat1.row(top) == greyMat2.row(top);
    int notMatch = greyMat1.cols - countNonZero(result);

    cout << "notMatch = " << notMatch << "\n";

    if (notMatch > greyMat1.cols * 0.05) {
      break;
    }
  }

  // From bottom to top
  cout << "begin bottom\n";
  int bottom;
  for (bottom = greyMat1.rows - 1; bottom >= 0; --bottom) {
    Mat result = greyMat1.row(bottom) == greyMat2.row(bottom);
    int notMatch = greyMat1.cols - countNonZero(result);

    cout << "notMatch = " << notMatch << "\n";

    if (notMatch > greyMat1.cols * 0.05) {
      break;
    }
  }

  // Middle
  int bottom1;
  int maxRowsThreshold = 20;
  Mat temp = greyMat2.rowRange(top, top + maxRowsThreshold);

  float limitationArray[] = {0.01, 0.03, 0.05, 0.07, 0.1};
  for (int i = 0; i < 5; ++i) {
    float limitation = limitationArray[i];
    BOOL limited = NO;

    for (bottom1 = bottom - maxRowsThreshold; bottom1 >= top; --bottom1) {
      Mat result = greyMat1.rowRange(bottom1, bottom1 + maxRowsThreshold) == temp;
      int total = greyMat1.cols * maxRowsThreshold;
      int zeroCount = total - countNonZero(result);
      if (zeroCount <= total * limitation) {
        limited = YES;
        break;
      }
    }

    if (limited) {
      break;
    }
  }

  int resultRows = bottom1 + mat2.rows - top ;
  Mat result = Mat(resultRows, mat1.cols, mat1.type());
  mat1.rowRange(0, bottom1).copyTo(result.rowRange(0, bottom1));
  mat2.rowRange(top, mat2.rows).copyTo(result.rowRange(bottom1, result.rows));

  return [self _te_UIImageFromCVMat:result];

  // Middle
//  Mat clippedMat1 = greyMat1.rowRange(top, bottom + 1);
//  Mat clippedMat2 = greyMat2.rowRange(top, bottom + 1);
//
//  Mat temp = clippedMat2.rowRange(0, 20);
//  Mat res;
//  matchTemplate(clippedMat1, temp, res, CV_TM_CCOEFF_NORMED);
//
//  threshold(res, res, 0.8, 1, CV_THRESH_TOZERO);
//  double minVal, maxVal, threshold = 0.8;
//
//  cv::Point minLoc, maxLoc;
//  minMaxLoc(res, &minVal, &maxVal, &minLoc, &maxLoc);
//
//  // 拼接
//  Mat temp1, result;
//  if (maxVal >= threshold)//只有度量值大于阈值才认为是匹配
//  {
//    //result:拼接后的图像
//    //temp1:原图1的非模板部分
//    result = Mat::zeros(cvSize(maxLoc.x + clippedMat2.cols, clippedMat1.rows), clippedMat1.type());
//    temp1 = clippedMat1(cv::Rect(0, 0, maxLoc.x, clippedMat1.rows));
//    /*将图1的非模板部分和图2拷贝到result*/
//    temp1.copyTo(Mat(result, cv::Rect(0, 0, maxLoc.x, clippedMat1.rows)));
//    clippedMat2.copyTo(Mat(result, cv::Rect(maxLoc.x - 1, 0, clippedMat2.cols, clippedMat2.rows)));
//  }
//
//  return [self _te_UIImageFromCVMat:result];
}

+ (UIImage *)te_imageByRawStitchingImage:(UIImage *)image1 withImage:(UIImage *)image2
{
  Mat mat1 = [image1 _te_cvMat];
  Mat mat2 = [image2 _te_cvMat];

  Mat result = Mat(mat1.rows + mat2.rows, mat1.cols, mat1.type());
  mat1.rowRange(0, mat1.rows).copyTo(result.rowRange(0, mat1.rows));
  mat2.rowRange(0, mat2.rows).copyTo(result.rowRange(mat1.rows, result.rows));

  return [self _te_UIImageFromCVMat:result];
}

+ (UIImage *)te_imageByStitchingImage:(UIImage *)image1 withImage:(UIImage *)image2
{
  image1 = [self _te_compressedToRatio:image1 ratio:0.8];
  image2 = [self _te_compressedToRatio:image2 ratio:0.8];

  Mat mat1 = [image1 _te_cvMat3];
  Mat mat2 = [image2 _te_cvMat3];

  vector<Mat> imgs;
  imgs.push_back(mat1);
  imgs.push_back(mat2);

  Mat pano;
  Stitcher stitcher = Stitcher::createDefault(false);
  Stitcher::Status status = stitcher.stitch(imgs, pano);

  if (status != Stitcher::OK) {
    NSLog(@"Wrong");

    return nil;
  }

  return [self _te_UIImageFromCVMat:pano];
}

#pragma mark - Compress
+ (UIImage *)_te_compressedToRatio:(UIImage *)img ratio:(float)ratio
{
  CGSize compressedSize;
  compressedSize.width=img.size.width*ratio;
  compressedSize.height=img.size.height*ratio;
  UIGraphicsBeginImageContext(compressedSize);
  [img drawInRect:CGRectMake(0, 0, compressedSize.width, compressedSize.height)];
  UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return compressedImage;
}

#pragma mark - Conversion

- (Mat)_te_cvMat3
{
  Mat result=[self _te_cvMat];
  cvtColor(result, result, CV_RGBA2RGB);
  return result;
}

- (Mat)_te_cvMat
{
  UIImage *image = self;

  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;

  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags

  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);

  return cvMat;
}

+ (UIImage *)_te_UIImageFromCVMat:(Mat)cvMat
{
  NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
  CGColorSpaceRef colorSpace;

  if (cvMat.elemSize() == 1) {//可以根据这个决定使用哪种
    colorSpace = CGColorSpaceCreateDeviceGray();
  } else {
    colorSpace = CGColorSpaceCreateDeviceRGB();
  }

  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

  // Creating CGImage from Mat
  CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                      cvMat.rows,                                 //height
                                      8,                                          //bits per component
                                      8 * cvMat.elemSize(),                       //bits per pixel
                                      cvMat.step[0],                            //bytesPerRow
                                      colorSpace,                                 //colorspace
                                      kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                      provider,                                   //CGDataProviderRef
                                      NULL,                                       //decode
                                      false,                                      //should interpolate
                                      kCGRenderingIntentDefault                   //intent
                                      );


  // Getting UIImage from CGImage
  UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);

  return finalImage;
}

#pragma mark - Helper
bool compareMatDimension(const cv::Mat mat1, const cv::Mat mat2){
  if (mat1.empty() && mat2.empty()) {
    return true;
  }

  if (mat1.cols != mat2.cols || mat1.rows != mat2.rows || mat1.dims != mat2.dims) {
    return false;
  }
  else {
    return true;
  }
}

@end
