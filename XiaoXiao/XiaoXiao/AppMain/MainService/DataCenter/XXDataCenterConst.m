//
//  XXDataCenterConst.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXDataCenterConst.h"

@implementation XXDataCenterConst


+ (NSString*)switchRequestTypeToInterfaceUrl:(XXRequestType)requestType
{
    NSString *resultInterface = nil;
    switch (requestType) {
        case XXRequestTypeLogin:
            resultInterface = XX_Login_Interface;
            break;
        case XXRequestTypeRegist:
            break;
            
        default:
            break;
    }
    return resultInterface;
}

@end
