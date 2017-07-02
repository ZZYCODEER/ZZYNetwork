//
//  ZZYUserInfoConfig.h
//  LearningDemo
//
//  Created by ZHANGZHONGYANG on 2017/7/2.
//  Copyright © 2017年 ZHANGZHONGYANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZYUserInfoConfig : NSObject

+ (ZZYUserInfoConfig *)config;

- (void)saveUserToken:(NSString *)token;

- (NSString *)token;

@end
