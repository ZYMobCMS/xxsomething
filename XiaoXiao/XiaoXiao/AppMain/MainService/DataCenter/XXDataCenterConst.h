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
    XXRequestTypeSearchSchool,
    
}XXRequestType;

#define XXBase_Host_Url @"http://beat.quan-oo.com/"

//登陆
/*
 POST account:注册账号
 POST password:注册密码
 */
#define XX_Login_Interface @"api/passport/login/"

//注册
/*
 POST account:注册账号,如果账号是邮箱,就填邮箱
 POST password:注册密码
 POST xuexiao_id:选择学校ID
 POST grade:年级字符传
 FILE picture:照片上传资源,jpg 格式
 */
#define XX_Regist_Interface @"/api/passport/register/"

//学校搜索，最多30条
/*
 可选 POST keyword:关键词
 可选 POST type:0大学,1中学
 可选 POST province:省份名
 可选 POST city:城市名
 可选 POST area:区县名
 */
#define XX_Search_School_Interface @"/api/xuexiao/search/"

//编辑更新个人资料
/*
 可选 POST account:注册账号
 可选 POST password:注册密码
 可选 POST nickname:昵称
 可选 POST email:邮箱
 可选 POST grade:班级
 可选 POST sex:性别
 可选 POST birthday:生日
 可选 POST signature:签名
 可选 FILE picture:照片
 */
#define XX_Update_User_Info_Interface @"/api/users/upinfo/"

//潜伏学校
/*
 POST xuexiao_id:学校ID
 */
#define XX_Stroll_School_Interface @"/api/xuexiao/stroll/"

//上传附件
/*
 FILE upload:上传任意资源资源
 可选 POST description:附件描述
 */
#define XX_Upload_File_Interface @"/api/attachment/upload/"

//附件详情
/*
 POST attachment_id:附件ID
 */
#define XX_File_Detail_Interface @"/api/attachment/details/"

//发表分享
/*
 POST type:(广场,相册,群组,留声机)
 POST tag:标记例如:1,2,3也可以一次传多个"1,3" 自定义标记
 可选 POST xuexiao_id:学校ID,默认进入自己的生活校园
 POST content:自定义内容结构,最好是json 自己可以针对各种类型自定义结构体
 例如{
 Images:[url1,url2,url3...],
 Vido:[viod1,viod2,viod3],
 Text:xxxx.
 }
 */
#define XX_Share_Post_Interface @"/api/posts/create/"

//搜索分享
/*
 可选 GET page 默认 1
 可选 GET size 默认10
 POST type:(广场,群组,自定义)
 可选 POST user_id:用户ID
 可选 POST xuexiao_id:学校ID
 可选 POST tag:自定义标签可多选”,”隔开
 可选 POST keyword:匹配content内容
 */
#define XX_Share_Search_Interface @"/api/posts/search/"

//添加好友关心
/*
 POST user_id:用户ID
 */
#define XX_Add_Friend_Care_Interface @"/api/friends/add/"

//取消好友关心
/*
 POST user_id:用户ID
 */
#define XX_Cancel_Friend_Care_Interface @"/api/friends/del/"

//我关心的列表搜索
/*
 可选 POST keyword:好友的账号/昵称
 */
#define XX_My_Care_Friend_Search_Interface @"/api/friends/search/"

//关心我的列表搜索
#define XX_Search_Care_Me_Interface @"/api/friends/search2/"






@interface XXDataCenterConst : NSObject

+ (NSString*)switchRequestTypeToInterfaceUrl:(XXRequestType)requestType;

@end
