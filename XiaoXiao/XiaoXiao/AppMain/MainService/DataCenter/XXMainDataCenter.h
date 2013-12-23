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
typedef void (^XXDataCenterUploadFileProgressBlock) (CGFloat progressValue);
typedef void (^XXDataCenterUploadFileSuccessBlock) (XXAttachmentModel *resultModel);

@interface XXMainDataCenter : NSObject
{
    
}

+ (XXMainDataCenter*)shareCenter;

- (void)uploadFileWithData:(NSData*)fileData withFileName:(NSString*)fileName withUploadProgressBlock:(XXDataCenterUploadFileProgressBlock)uploadProgressBlock withSuccessBlock:(XXDataCenterUploadFileSuccessBlock)success withFaildBlock:(XXDataCenterRequestFaildMsgBlock)faild;

- (void)requestLoginWithNewUser:(XXUserModel*)newUser withSuccessLogin:(XXDataCenterRequestDetailUserBlock)success withFaildLogin:(XXDataCenterRequestFaildMsgBlock)faild;

- (void)requestRegistWithNewUser:(XXUserModel*)newUser withSuccessRegist:(XXDataCenterRequestDetailUserBlock)success withFaildRegist:(XXDataCenterRequestFaildMsgBlock)faild;

- (void)requestSearchSchoolListWithDescription:(XXSchoolModel*)conditionSchool WithSuccessSearch:(XXDataCenterRequestSuccessListBlock)success withFaildSearch:(XXDataCenterRequestFaildMsgBlock)faild;

@end
