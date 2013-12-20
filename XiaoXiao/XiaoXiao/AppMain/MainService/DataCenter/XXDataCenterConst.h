//
//  XXDataCenterConst.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    XXRequestTypeLogin = 0,
    XXRequestTypeRegist,
    
}XXRequestType;

#define XXBase_Host_Url @"http://beat.quan-oo.com/"

#define XX_Login_Interface @"api/passport/login/"

#define XX_Regist_Interface @""



//多媒体
#define XX_Upload_Interface @""

@interface XXDataCenterConst : NSObject

+ (NSString*)switchRequestTypeToInterfaceUrl:(XXRequestType)requestType;

@end
