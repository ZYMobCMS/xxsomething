//
//  XXMainDataCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XXDataCenterRequestSuccessListBlock) (NSArray *resultList);
typedef void (^XXDataCenterRequestFaildMsgBlock) (NSString *faildMsg);
typedef void (^XXDataCenterRequestSuccessMsgBlock) (NSString *successMsg);
typedef void (^XXDataCenterRequestDetailUserBlock) (XXUserModel *detailUser);

@interface XXMainDataCenter : NSObject
{
    
}

+ (XXMainDataCenter*)shareCenter;

- (void)requestLoginWithNewUser:(XXUserModel*)newUser withSuccessLogin:(XXDataCenterRequestDetailUserBlock)success withFaildLogin:(XXDataCenterRequestFaildMsgBlock)faild;

- (void)requestRegistWithNewUser:(XXUserModel*)newUser withSuccessRegist:(XXDataCenterRequestDetailUserBlock)success withFaildRegist:(XXDataCenterRequestFaildMsgBlock)faild;

- (void)requestSearchSchoolListWithDescription:(XXSchoolModel*)conditionSchool WithSuccessSearch:(XXDataCenterRequestSuccessListBlock)success withFaildSearch:(XXDataCenterRequestFaildMsgBlock)faild;

@end
