//
//  ViewController.m
//  ZZYNetwork
//
//  Created by ZHANGZHONGYANG on 2017/7/2.
//  Copyright © 2017年 ZHANGZHONGYANG. All rights reserved.
//

#import "ViewController.h"
#import "ZZYHTTPService.h"
#import "ZZYUserInfoConfig.h"
#import "ZZYHTTPTestService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[ZZYUserInfoConfig config] saveUserToken:@"1yPL1_HPcdVVlSxP"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"请求" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickAction
{
    NSString *url = @"app/car/appcarsearchaction/getCarStat.json";
    NSDictionary *param = @{
                            @"store":@"000161",
                            @"version":@"6.0.3",
                            @"jpushid":@"101d855909745f5f5a1",
                            @"platformType":@"AppStore",
                            };
    [[ZZYHTTPService service] dataWithUrl:url
                            requestMethod:ZZYRequestMethodPost
                    requestSerializerType:ZZYRequestSerializerTypeHTTP
                               parameters:param
                               completion:^(id data) {
                                   
                                   NSLog(@"data = %@", data);
                                   
                               }];
    
    
}


@end
