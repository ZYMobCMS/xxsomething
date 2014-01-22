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
    NSMutableArray *userList = [XXUserDataCenter unarchiveArray:[[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]];
    DDLogVerbose(@"userList :%@",userList);
    __block NSUInteger findUserIndex=9999;
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.status boolValue]) {
            findUserIndex = idx;
            *stop = YES;
        }
    }];
    if (findUserIndex==9999) {
        DDLogVerbose(@"didn't find login user");
        return nil;
    }
    DDLogVerbose(@"find currentUser:%@",[userList objectAtIndex:findUserIndex]);
    return [userList objectAtIndex:findUserIndex];
}
+ (void)currentUserLoginOut
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        return;
    }
    NSArray *userList = [XXUserDataCenter unarchiveArray:[[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]];
    
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.status boolValue]) {
            existUser.status = @"0";
            *stop = YES;
        }
    }];
    NSData *userData = [XXUserDataCenter archiveArray:[NSMutableArray arrayWithArray:userList]];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:XXUserDataCenterSaveUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (void)loginThisUser:(XXUserModel *)aUser
{
    NSMutableArray *userList = nil;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        userList = [NSMutableArray array];
    }else{
        userList = [XXUserDataCenter unarchiveArray:[[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]];
    }
    
    __block BOOL findExistUser = NO;
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.userId isEqualToString:aUser.userId]) {
            DDLogVerbose(@"login exist user!");
            existUser.tooken = aUser.tooken;
            existUser.status = @"1";
            findExistUser = YES;
        }else{
            existUser.status = @"0";
        }
    }];
    if (!findExistUser) {
        DDLogVerbose(@"add new user!");
        aUser.status=@"1";
        [userList addObject:aUser];
    }
    DDLogVerbose(@"login user after:%@",userList);
    NSData *userData = [XXUserDataCenter archiveArray:userList];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:XXUserDataCenterSaveUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
+ (NSData*)archiveArray:(NSMutableArray*)tempArray
{
   return [NSKeyedArchiver archivedDataWithRootObject:tempArray];
}
+ (NSMutableArray*)unarchiveArray:(NSData*)arrayData
{
   return  (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
}
+ (BOOL)checkLoginUserInfoIsWellDone
{
    XXUserModel *currentUser = [XXUserDataCenter currentLoginUser];
    if ([currentUser.nickName isEqualToString:@""]) {
        return NO;
    }
//    if ([currentUser.signature isEqualToString:@""]) {
//        return NO;
//    }
    if ([currentUser.constellation isEqualToString:@""]) {
        return NO;
    }
    if ([currentUser.sex isEqualToString:@""]) {
        return NO;
    }
    if ([currentUser.grade isEqualToString:@""]) {
        return NO;
    }
//    if ([currentUser.birthDay isEqualToString:@""]) {
//        return NO;
//    }
    if ([currentUser.type intValue]==XXUserMiddleSchool||[currentUser.type intValue]==XXUserHighSchool ) {
        if ([currentUser.schoolRoll isEqualToString:@""]) {
            return NO;
        }
    }else{
        if ([currentUser.college isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}
@end
