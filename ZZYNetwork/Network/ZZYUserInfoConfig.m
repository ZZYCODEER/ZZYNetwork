//
//  ZZYUserInfoConfig.m
//  LearningDemo
//
//  Created by ZHANGZHONGYANG on 2017/7/2.
//  Copyright © 2017年 ZHANGZHONGYANG. All rights reserved.
//

#import "ZZYUserInfoConfig.h"


@interface ZZYUserInfoConfig ()
@property (nonatomic, copy) NSString *token;
@end

@implementation ZZYUserInfoConfig

+ (ZZYUserInfoConfig *)config
{
    static ZZYUserInfoConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

- (void)saveUserToken:(NSString *)token
{
    self.token = token;
}


- (NSString *)token
{
    if (!_token) {
        _token = [NSString string];
    }
    return _token;
}

@end
