//
//  TestBlockObject.m
//  Test1
//
//  Created by bigyelow on 28/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import "TestBlockObject.h"

@implementation TestBlockObject

- (void)doBlock
{
  if (_block) {
    _block();
  }
}

@end
