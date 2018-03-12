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

static const float tempMatchingThresholdForTop = 0.92;
static const float tempMatchingThresholdForMiddle = 0.97;

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

  // Begin to match
  int tempHeight = 88;
  Mat temp = greyMat2.rowRange(0, tempHeight);
  Mat source = greyMat1;
  double minVal, maxVal;
  cv::Point minLoc, maxLoc;
  float thresh = tempMatchingThresholdForTop;
  bool matched = findMatchingMat(source, temp, thresh, &minVal, &maxVal, &minLoc, &maxLoc);

  if (!matched) {
    NSLog(@"no overlap");
    return nil;
  }

  if (maxLoc.y > 0) { // 匹配到第一张图的中部
    int resultRows = maxLoc.y + mat2.rows;
    Mat result = Mat(resultRows, mat1.cols, mat1.type());
    mat1.rowRange(0, maxLoc.y).copyTo(result.rowRange(0, maxLoc.y));
    mat2.rowRange(0, mat2.rows).copyTo(result.rowRange(maxLoc.y, result.rows));

    return [self _te_UIImageFromCVMat:result];
  }

  // 匹配到头部，需要找出头部最大匹配范围
  int matchingTopRow = maxMatchingTopRow(tempHeight, greyMat1, greyMat2);

  // 开始匹配第二张图去掉头部的部分
  temp = greyMat2.rowRange(matchingTopRow, matchingTopRow + 80);
  source = greyMat1;
  thresh = tempMatchingThresholdForMiddle;
//      return [self _te_UIImageFromCVMat:temp];
  matched = findMatchingMat(source, temp, thresh, &minVal, &maxVal, &minLoc, &maxLoc);

  if (matched) {
    int resultRows = maxLoc.y + mat2.rows - matchingTopRow;
    Mat result = Mat(resultRows, mat1.cols, mat1.type());
    mat1.rowRange(0, maxLoc.y).copyTo(result.rowRange(0, maxLoc.y));
    mat2.rowRange(matchingTopRow, mat2.rows).copyTo(result.rowRange(maxLoc.y, result.rows));

    return [self _te_UIImageFromCVMat:result];
  }
  return nil;
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

#pragma mark - Helper C++ Functions

/**
 @param baseRow target's (0, baseRow) 是 match source 的头部的
 @return 返回 targets's 在 source 中的最大顶部匹配 (0, topRow)
 */
int maxMatchingTopRow(const int baseRow, const Mat source, const Mat target)
{
  int matchingTopRow = baseRow;

  // 先快速找出不匹配的 row
  int row = baseRow + 20;
  for (; row < target.rows; row += 20) {
    Mat temp = target.rowRange(0, row);
    float thresh = tempMatchingThresholdForTop;
    double minVal, maxVal;
    bool matched = findMatchingMat(source, temp, thresh, &minVal, &maxVal);

    if (matched) {
      matchingTopRow = row;
    }
    else {
      break;
    }
  }

#warning need test
  if (row >= target.rows) { // 整图都是匹配的
    return target.rows;
  }

  // 在 (matchingTopRow, row) 的开区间寻找最大匹配
  for (int row2 = matchingTopRow + 1; row2 < row; ++row2) {
    Mat temp = target.rowRange(0, row2);
    float thresh = tempMatchingThresholdForTop;
    double minVal, maxVal;
    bool matched = findMatchingMat(source, temp, thresh, &minVal, &maxVal);

    if (!matched) {
      matchingTopRow = row2 - 1;
      break;
    }
  }

  return matchingTopRow;
}

bool findMatchingMat(const Mat source, const Mat temp, const float thresh,
                  CV_OUT double* minVal, CV_OUT double* maxVal,  CV_OUT cv::Point* minLoc = 0, CV_OUT cv::Point* maxLoc = 0)
{
  Mat res = Mat(source.rows - temp.rows + 1, source.cols - temp.cols + 1, CV_32FC1);
  matchTemplate(source, temp, res, CV_TM_CCOEFF_NORMED);
  threshold(res, res, thresh, 1, CV_THRESH_TOZERO);
  minMaxLoc(res, minVal, maxVal, minLoc, maxLoc);

  return *maxVal >= thresh;
}

bool compareMatMatching(const Mat mat1, const Mat mat2, float notMatchingThreshold)
{
  Mat result = mat1 == mat2;
  int total = mat1.rows * mat1.cols;
  int zeroCount = total - countNonZero(result);

  if (zeroCount > total * notMatchingThreshold) {
    return false;
  }
  else {
    return true;
  }
}

bool compareMatHist(const Mat mat1, const Mat mat2)
{

  double errorL2 = norm(mat1, mat2, CV_L2);
  // Convert to a reasonable scale, since L2 error is summed across all pixels of the image.
  double similarity = errorL2 / (double)(mat1.rows * mat1.cols );
  cout << "similarity = " << similarity;
  cout << " row = " << mat1.rows << endl;
  return similarity;

  Mat srcHsvImage;
  Mat compareHsvImage;
  cvtColor(mat1, srcHsvImage, CV_BGR2HSV);
  cvtColor(mat2, compareHsvImage, CV_BGR2HSV);

  //采用H-S直方图进行处理
  //首先得配置直方图的参数
  MatND srcHist, compHist;

  //H、S通道
  int channels[] = { 0, 1 };
  int histSize[] = { 30, 32 };
  float HRanges[] = { 0, 180 };
  float SRanges[] = { 0, 256 };
  const float *ranges[] = { HRanges, SRanges };

  //进行原图直方图的计算
  calcHist(&srcHsvImage, 1, channels, Mat(), srcHist, 2, histSize, ranges, true, false);
  //对需要比较的图进行直方图的计算
  calcHist(&compareHsvImage, 1, channels, Mat(), compHist, 2, histSize, ranges, true, false);

  //注意：这里需要对两个直方图进行归一化操作
  normalize(srcHist, srcHist, 0, 1, NORM_MINMAX);
  normalize(compHist, compHist, 0, 1, NORM_MINMAX);

  double g_dCompareRecult = compareHist(srcHist, compHist, 0);
  cout << "方法一：两幅图像比较的结果为：" << g_dCompareRecult << endl;

  g_dCompareRecult = compareHist(srcHist, compHist, 1);
  cout << "方法二：两幅图像比较的结果为：" << g_dCompareRecult << endl;

  g_dCompareRecult = compareHist(srcHist, compHist, 2);
  cout << "方法三：两幅图像比较的结果为：" << g_dCompareRecult << endl;

  g_dCompareRecult = compareHist(srcHist, compHist, 3);
  cout << "方法四：两幅图像比较的结果为：" << g_dCompareRecult << endl;

  return false;
}

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
