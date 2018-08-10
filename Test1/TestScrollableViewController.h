//
//  TestScrollableViewController.h
//  Test1
//
//  Created by bigyelow on 2018/8/9.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TEViewCombinationType) {
  TEViewCombinationTypeTopTableBottomTable,
  TEViewCombinationTypeTopTableBottomWeb,
  TEViewCombinationTypeTopWebBottomTable,
};

@interface TestScrollableViewController : UIViewController

- (instancetype)initWithType:(TEViewCombinationType)type;

@end
