//
//  TCommond.m
//  Test1
//
//  Created by bigyelow on 17/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import "TCommond.h"

@implementation TCommond

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name
{
  if (self = [super init]) {
    _identifier = [ID copy];
    _name = [name copy];
    _url = [NSURL new];
  }
  return self;
}

@end
