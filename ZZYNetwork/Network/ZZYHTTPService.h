//
//  ZZYHTTPService.h
//  LearningDemo
//
//  Created by ZHANGZHONGYANG on 2017/7/2.
//  Copyright © 2017年 ZHANGZHONGYANG. All rights reserved.
//
//ZZYHTTPService：基础服务，服务域名或者解析参数不同的，需要继承ZZYHTTPService，复写httpDomain等。参考ZZYHTTPTestService

#import <Foundation/Foundation.h>

//请求的域名host
extern NSString * const ZZYNetworkDomain;

typedef void(^ZZYCompletionBlock)(id data);

typedef NS_ENUM(NSUInteger, ZZYRequestMethod) {
    ZZYRequestMethodGet = 0,
    ZZYRequestMethodPost,
};

typedef NS_ENUM(NSUInteger, ZZYRequestSerializerType) {
    ZZYRequestSerializerTypeHTTP = 0,
    ZZYRequestSerializerTypeJSON,
};


@interface ZZYHTTPService : NSObject

+ (ZZYHTTPService *)service;

//不同的服务域名需要重写Domain
- (NSString *)httpDomain;

- (NSURLSessionConfiguration *)configuration;
/**
 网络请求
 
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestWithUrl:(NSString *)urlString
                           requestMethod:(ZZYRequestMethod)requestMethod
                              parameters:(NSDictionary *)parameters
                              completion:(ZZYCompletionBlock)completion;

- (NSURLSessionDataTask *)dataWithUrl:(NSString *)urlString
                        requestMethod:(ZZYRequestMethod)requestMethod
                requestSerializerType:(ZZYRequestSerializerType)requestSerializerType
                           parameters:(NSDictionary *)parameters
                           completion:(ZZYCompletionBlock)completion;

@end
