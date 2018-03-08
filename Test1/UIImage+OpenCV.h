//
//  UIImage+OpenCV.h
//  Test1
//
//  Created by bigyelow on 07/03/2018.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OpenCV)

- (UIImage *)te_processImageThroughMat;
+ (UIImage *)te_imageByStitchingImage:(UIImage *)image1 withImage:(UIImage *)image2;

@end
