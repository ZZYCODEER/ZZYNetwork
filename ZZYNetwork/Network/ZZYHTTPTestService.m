//
//  ZZYHTTPTestService.m
//  LearningDemo
//
//  Created by ZHANGZHONGYANG on 2017/7/2.
//  Copyright © 2017年 ZHANGZHONGYANG. All rights reserved.
//

#import "ZZYHTTPTestService.h"


@implementation ZZYHTTPTestService

+ (instancetype)service
{
    static ZZYHTTPTestService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    
    return service;
}

- (NSString *)httpDomain
{
    return @"http://erp-dev2.sqaproxy.souche.com";
}

- (NSURLSessionConfiguration *)configuration
{
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

#pragma mark - Handle Response
- (void)handleSuccessResponseObject:(id)responseObject callback:(ZZYCompletionBlock)callback
{
    NSInteger success = [[responseObject objectForKey:@"success"] integerValue];
    NSDictionary *data = [responseObject objectForKey:@"data"];
    
    if (success == 1) {
        callback(data);
    }else
    {
        [self handdleErroresponseObject:responseObject callback:callback error:nil];
    }
}
//请求异常或者错误，统一处理
- (void)handdleErroresponseObject:(id)responseObject callback:(ZZYCompletionBlock)callback error:(NSError *)error
{
    
}

@end
