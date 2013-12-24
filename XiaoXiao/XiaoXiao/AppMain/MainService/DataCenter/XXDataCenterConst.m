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
            resultInterface = XX_Regist_Interface;
            break;
        case XXRequestTypeSearchSchool:
            resultInterface = XX_Search_School_Interface;
            break;
        case XXRequestTypeUploadFile:
            resultInterface = XX_Upload_File_Interface;
            break;
        case XXRequestTypeAddFriendCare:
            resultInterface = XX_Add_Friend_Care_Interface;
            break;
        case XXRequestTypeCancelFriendCare:
            resultInterface = XX_Cancel_Friend_Care_Interface;
            break;
        case XXRequestTypeCareMe:
            resultInterface = XX_Search_Care_Me_Interface;
            break;
        case XXRequestTypeCommentList:
            resultInterface = XX_Comment_List_Interface;
            break;
        case XXRequestTypeCommentPublish:
            resultInterface = XX_Comment_Publish_Interface;
            break;
        case XXRequestTypeFileDetail:
            resultInterface = XX_File_Detail_Interface;
            break;
        case XXRequestTypeLonelyShoot:
            resultInterface = XX_Lonely_Shoot_Interface;
            break;
        case XXRequestTypeMoveHome:
            resultInterface = XX_Move_Home_Interface;
            break;
        case XXRequestTypeMyCareFriend:
            resultInterface = XX_My_Care_Friend_Search_Interface;
            break;
        case XXRequestTypePostShare:
            resultInterface = XX_Post_Share_Interface;
            break;
        case XXRequestTypePostTalk:
            resultInterface = XX_Post_Talk_Interface;
            break;
        case XXRequestTypePraisePublish:
            resultInterface = XX_Praise_Publish_Interface;
            break;
        case XXRequestTypeSharePostSearch:
            resultInterface = XX_Share_Post_Search_Interface;
            break;
        case XXRequestTypeStrollSchool:
            resultInterface = XX_Stroll_School_Interface;
            break;
        case XXRequestTypeUpdateUserInfo:
            resultInterface = XX_Update_User_Info_Interface;
            break;
        case XXRequestTypeUserDetail:
            resultInterface = XX_User_Detail_Interface;
            break;
        case XXRequestTypeAdvicePublish:
            resultInterface = XX_Advice_Interface;
            break;
        case XXRequestTypeNearbyUsers:
            resultInterface = XX_Nearby_User_Interface;
            break;
        case XXRequestTypeSameSchoolUsers:
            resultInterface = XX_Same_School_User_Interface;
            break;
        case XXRequestTypeTeaseMeList:
            resultInterface = XX_Tease_Me_List_Interface;
            break;
        case XXRequestTypeTeaseUser:
            resultInterface = XX_Tease_User_Interface;
            break;
            
        default:
            break;
    }
    return resultInterface;
}

@end
