//
//  UIImageView+WebImageCache.m
//  Test1
//
//  Created by bigyelow on 2018/8/27.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "UIImageView+WebImageCache.h"

NS_ASSUME_NONNULL_BEGIN
@interface _ImageCache: NSObject

@property (nonatomic, assign) NSUInteger capacity; // Default = 10;
@property (nonatomic, strong) NSMutableDictionary *innerCache;
@property (nonatomic, strong) NSMutableArray *usingArray; // Maintain update time

+ (instancetype)sharedCache;
- (void)cacheImage:(nullable UIImage *)image WithURL:(nullable NSURL *)url;
- (nullable UIImage *)imageForURL:(NSURL *)url;

@end
NS_ASSUME_NONNULL_END

@implementation _ImageCache

+ (instancetype)sharedCache
{
  static dispatch_once_t onceToken;
  static _ImageCache *cache = nil;
  dispatch_once(&onceToken, ^{
    cache = [_ImageCache new];
  });

  return cache;
}

- (instancetype)init
{
  if (self = [super init]) {
    _capacity = 10;
    _innerCache = [NSMutableDictionary dictionary];
    _usingArray = [NSMutableArray array];
  }
  return self;
}

- (void)cacheImage:(UIImage *)image WithURL:(NSURL *)url
{
  if (!url || !image) {
    return;
  }

  if ((_usingArray.count <= _capacity - 1) || [_innerCache.allKeys containsObject:url]) {
    [_innerCache setObject:image forKey:url];
  }
  else {
    NSURL *deletingURL = _usingArray.lastObject;
    [_innerCache removeObjectForKey:deletingURL];
    [_innerCache setObject:image forKey:url];
  }
  [self updateUsingArrayWithURL:url];
}

- (UIImage *)imageForURL:(NSURL *)url
{
  if ([_innerCache.allKeys containsObject:url]) {
    [self updateUsingArrayWithURL:url];
    return [_innerCache objectForKey:url];
  }
  return nil;
}

- (void)updateUsingArrayWithURL:(NSURL *)url
{
  if (!url) {
    return;
  }

  if ([_usingArray containsObject:url]) {
    [_usingArray removeObject:url];
    [_usingArray insertObject:url atIndex:0];
  }
  else if (_capacity > 0 && _usingArray.count > _capacity - 1) {
    NSAssert(NO, @"Should not be here");
    return;
  }
  else {
    [_usingArray insertObject:url atIndex:0];
  }
}

@end


@implementation UIImageView (WebImageCache)

- (void)setImageWithURL:(NSURL *)url
{
  UIImage *cachedImage = [[_ImageCache sharedCache] imageForURL:url];
  if (cachedImage) {
    [self setImage:cachedImage];
    return;
  }

  __block UIImage *image;
  void (^download)(void) = ^() {
    NSURLSessionDownloadTask *task =
    [[NSURLSession sharedSession] downloadTaskWithURL:url
                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                      if (!error) {
                                        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                      }

                                      if (image) {
                                        [[_ImageCache sharedCache] cacheImage:image WithURL:url];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                          [self setImage:image];
                                        });
                                      }
                                    }];
    [task resume];
  };

  if ([NSThread isMainThread]) {
    download();
  }
  else {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      download();
    });
  }
}

@end



