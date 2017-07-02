//
//  ZZYHTTPService.m
//  LearningDemo
//
//  Created by ZHANGZHONGYANG on 2017/7/2.
//  Copyright © 2017年 ZHANGZHONGYANG. All rights reserved.
//

#import "ZZYHTTPService.h"
#import "AFNetworking.h"
#import "ZZYUserInfoConfig.h"

#if DEBUG

NSString * const ZZYNetworkDomain = @"https://erp.souche.com";

#elif ADHOC

NSString * const ZZYNetworkDomain = @"";

#elif TESTPREPUB

NSString * const ZZYNetworkDomain = @"";

#elif RELEASE

NSString * const ZZYNetworkDomain = @"https://erp.souche.com";


#endif


@interface ZZYHTTPService ()
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, copy) NSString *httpDomain;
@end

@implementation ZZYHTTPService

+ (ZZYHTTPService *)service
{
    static ZZYHTTPService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[self alloc] init];
    });
    return service;
}

#pragma mark - Request
- (NSURLSessionDataTask *)requestWithUrl:(NSString *)urlString
                           requestMethod:(ZZYRequestMethod)requestMethod
                              parameters:(NSDictionary *)parameters
                              completion:(ZZYCompletionBlock)completion
{
    return [self dataWithUrl:urlString requestMethod:requestMethod requestSerializerType:ZZYRequestSerializerTypeHTTP parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)dataWithUrl:(NSString *)urlString
                        requestMethod:(ZZYRequestMethod)requestMethod
                requestSerializerType:(ZZYRequestSerializerType)requestSerializerType
                           parameters:(NSDictionary *)parameters
                           completion:(ZZYCompletionBlock)completion
{
    NSURLSessionConfiguration *configuration = [self combineConfiguration];
    
    NSString *url = [self combineRequestUrlString:urlString];
    
    [self formatUrlAndParameters:parameters path:url type:requestMethod];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    if (requestSerializerType == ZZYRequestSerializerTypeJSON) {
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    NSURLSessionDataTask *dataTask;
    switch (requestMethod) {
        case ZZYRequestMethodGet:{
            dataTask = [sessionManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleSuccessResponseObject:responseObject callback:completion];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handdleErroresponseObject:nil callback:completion error:error];
                
            }];
        }
            break;
            
        case ZZYRequestMethodPost:{
            dataTask = [sessionManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self handleSuccessResponseObject:responseObject callback:completion];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self handdleErroresponseObject:nil callback:completion error:error];
                
            }];
        }
            break;
    }
    return dataTask;
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

#pragma mark - Combine
//拼接请求URL
- (NSString *)combineRequestUrlString:(NSString *)urlString
{
    if ([urlString hasPrefix:@"http"]) {
        return urlString;
    }
    NSString *reqeustUrlString = [self.httpDomain stringByAppendingString:[self checkUrlString:urlString]];
    
    return reqeustUrlString;
}
//配置请求header
- (NSURLSessionConfiguration *)combineConfiguration
{
    return self.configuration;
}

//格式化输出url和参数
- (void)formatUrlAndParameters:(NSDictionary *)parameters path:(NSString *)path type:(ZZYRequestMethod)requestMethod
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSDictionary *headerDic = self.configuration.HTTPAdditionalHeaders;
    
    if (requestMethod == ZZYRequestMethodGet) {
        
        __block NSString *paraString = @"";
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            paraString = [NSString stringWithFormat:@"%@%@=%@&", paraString, key, obj];
        }];
        
        paraString = [paraString substringToIndex:paraString.length - 1];
        NSString *requestUrl = [NSString stringWithFormat:@"%@?%@", path, paraString];
        
        NSLog(@"requestUrl = %@, header = %@", requestUrl, headerDic);
    }else{
        NSLog(@"requestUrl = %@, parameters = %@, header = %@", path, parameters, headerDic);
        
    }
}

- (NSString *)checkUrlString:(NSString *)urlString
{
    if (![urlString hasPrefix:@"/"]) {
        urlString = [NSString stringWithFormat:@"/%@", urlString];
    }
    return urlString;
}

#pragma mark - Setter && Getter
- (NSString *)httpDomain
{
    if (!_httpDomain) {
        _httpDomain = ZZYNetworkDomain;
    }
    return _httpDomain;
}

- (NSURLSessionConfiguration *)configuration
{
    if (!_configuration) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *token = [[ZZYUserInfoConfig config] token];
        _configuration.HTTPAdditionalHeaders = @{
                                                 @"TT":token,
                                                 @"_security_token":token
                                                 };
        if (!token || token.length == 0) {
            NSLog(@"%s:%d:\n未设置token 部分接口可能请求出错", __FILE__,__LINE__);
        }
    }
    return _configuration;
}

@end
