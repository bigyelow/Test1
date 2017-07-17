//
//  TCommond.h
//  Test1
//
//  Created by bigyelow on 17/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TCommond : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name;

@end
NS_ASSUME_NONNULL_END
