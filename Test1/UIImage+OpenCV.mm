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
#endif

#import "UIImage+OpenCV.h"

using namespace std;
using namespace cv;

@implementation UIImage (OpenCV)

- (UIImage *)te_processImageThroughMat
{
  Mat mat = [self _te_cvMat];
  return [[self class] _te_UIImageFromCVMat:mat];
}

#pragma mark - Stitching

+ (UIImage *)te_imageByRawStitchingImage:(UIImage *)image1 withImage:(UIImage *)image2
{
  Mat mat1 = [image1 _te_cvMat];
  Mat mat2 = [image2 _te_cvMat];

  Mat result = Mat(mat1.rows + mat2.rows, mat1.cols, mat1.type());
  mat1.rowRange(0, mat1.rows).copyTo(result.rowRange(0, mat1.rows));
  mat2.rowRange(0, mat2.rows).copyTo(result.rowRange(mat1.rows, result.rows));

//  Mat singleMat1, singleMat2;
//  cvtColor(mat1, singleMat1, CV_RGB2BGR);
//  cvtColor(mat2, singleMat2, CV_RGB2BGR);

//  return [self _te_UIImageFromCVMat:singleMat1];
//  if (matIsEqual(singleMat1, singleMat2)) {
//    NSLog(@"equal");
//  }
//
//  Mat diff;
//  compare(mat1, mat2, diff, CMP_EQ);
  return [self _te_UIImageFromCVMat:result];
}

bool matIsEqual(const cv::Mat mat1, const cv::Mat mat2){
  // treat two empty mat as identical as well
  if (mat1.empty() && mat2.empty()) {
    return true;
  }
  // if dimensionality of two mat is not identical, these two mat is not identical
  if (mat1.cols != mat2.cols || mat1.rows != mat2.rows || mat1.dims != mat2.dims) {
    return false;
  }
  cv::Mat diff;
  cv::compare(mat1, mat2, diff, cv::CMP_NE);
  int nz = cv::countNonZero(diff);
  return nz==0;
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

@end
