//
//  XXMainDataCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXMainDataCenter : NSObject
{
    
}

+ (XXMainDataCenter*)shareCenter;

- (void)requestLoginWithNewUser:(XXUserModel*)newUser withSuccessLogin:(void (^) (XXUserModel *detailUser))success withFaildLogin:(void (^)(NSString *faildMsg))faild;

- (void)requestRegistWithNewUser:(XXUserModel*)newUser withSuccessRegist:(void (^) (NSString *successMsg))success withFaildRegist:(void (^)(NSString *faildMsg))faild;


@end
