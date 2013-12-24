//
//  XXUserDataCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserDataCenter.h"

#define XXUserDataCenterSaveUDF @"xxuser_save_udf"

@implementation XXUserDataCenter
+ (NSString*)currentLoginUserToken
{
    if ([XXUserDataCenter currentLoginUser]) {
        return [XXUserDataCenter currentLoginUser].tooken;
    }else{
        return @"";
    }
}
+ (XXUserModel*)currentLoginUser
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        return nil;
    }
    NSArray *userList = [[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF];
    __block XXUserModel *loginUser = nil;
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.status boolValue]) {
            loginUser = existUser;
            *stop = YES;
        }
    }];
    return loginUser;
}
+ (void)currentUserLoginOut
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        return;
    }
    NSArray *userList = [[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF];
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.status boolValue]) {
            existUser.status = @"0";
            *stop = YES;
        }
    }];
    [[NSUserDefaults standardUserDefaults]setObject:userList forKey:XXUserDataCenterSaveUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (void)loginThisUser:(XXUserModel *)aUser
{
    NSMutableArray *userList = nil;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        userList = [NSMutableArray array];
    }else{
        userList = [[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF];
    }
    aUser.status=@"1";
    [userList addObject:aUser];
    
    [[NSUserDefaults standardUserDefaults]setObject:userList forKey:XXUserDataCenterSaveUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
