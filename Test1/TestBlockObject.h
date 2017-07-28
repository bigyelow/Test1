//
//  TestBlockObject.h
//  Test1
//
//  Created by bigyelow on 28/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestBlockObject : NSObject

@property (nonatomic, copy) void(^block)();
- (void)doBlock;
@end
