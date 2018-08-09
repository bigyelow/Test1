//
//  ScrollableDataSource.h
//  Test1
//
//  Created by bigyelow on 2018/8/9.
//  Copyright © 2018 huangduyu. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@interface ScrollableDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy, nullable) NSArray<NSString *> *data;

@end
NS_ASSUME_NONNULL_END
