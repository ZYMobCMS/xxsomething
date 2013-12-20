//
//  XXMainDataCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXMainDataCenter.h"
#import "AFJSONRequestOperation.h"
#import "XXHTTPClient.h"

#define XXLoginErrorInvalidateParam @"用户名或密码缺失"
#define XXNetWorkDisConnected @"网络无法链接"

@implementation XXMainDataCenter

+ (XXMainDataCenter*)shareCenter
{
    static XXMainDataCenter *_sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCenter = [[XXMainDataCenter alloc]init];
    });
    
    return _sharedCenter;
}


- (void)requestXXRequest:(XXRequestType)requestType withParams:(NSDictionary *)params withHttpMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *resultDict))success withFaild:(void (^)(NSString *faildMsg))faild
{
    
    //是否存在网络
    if ([[XXHTTPClient shareClient]networkReachabilityStatus]==AFNetworkReachabilityStatusNotReachable) {
        if (faild) {
            faild(XXNetWorkDisConnected);
            
        }
    }
    
    NSString *requestMethod = method;
    if (!requestMethod){
        requestMethod = @"POST";
    }
    
    [[XXHTTPClient shareClient]postPath:[XXDataCenterConst switchRequestTypeToInterfaceUrl:requestType] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        NSLog(@"resutl dict --->%@",resultDict);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[resultDict objectForKey:@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

- (void)requestLoginWithNewUser:(XXUserModel *)newUser withSuccessLogin:(void (^)(XXUserModel *))success withFaildLogin:(void (^)(NSString *))faild
{
    if (!newUser.account||!newUser.password) {
        if (faild) {
            faild (XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"account":newUser.account,@"password":newUser.password};
    
    [self requestXXRequest:XXRequestTypeLogin withParams:params withHttpMethod:nil withSuccess:^(NSDictionary *resultDict) {
       
        
    } withFaild:^(NSString *faildMsg) {
        
        
    }];
}

- (void)requestRegistWithNewUser:(XXUserModel *)newUser withSuccessRegist:(void (^)(NSString *))success withFaildRegist:(void (^)(NSString *))faild
{
    
}

@end
