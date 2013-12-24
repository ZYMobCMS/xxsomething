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
#import "AFHTTPRequestOperation.h"

#define XXLoginErrorInvalidateParam @"请求参数不完整"
#define XXNetWorkDisConnected @"网络无法链接"
#define XXRegistDefaultHeadName @"head.jpg"
#define XXDefaultString @"xxdefault"

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
            return;
        }
    }
    
    NSString *requestMethod = method;
    if (!requestMethod){
        requestMethod = @"POST";
    }
    
    [[XXHTTPClient shareClient]postPath:[XXDataCenterConst switchRequestTypeToInterfaceUrl:requestType] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        DDLogVerbose(@"normal request resutlDict -->%@",resultDict);
        
        //解析对错
        int status = [[resultDict objectForKey:@"ret"]intValue];
        if (status==0) {
            
            if (success) {
                success(resultDict);
            }
            
        }else{
            if (faild) {
                faild([resultDict objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            faild([error description]);
        }
        
    }];
    
}

#pragma mark - common upload
- (NSString*)mediaFileTypeForFileName:(NSString*)fileName
{
    NSArray *nameArray = [fileName componentsSeparatedByString:@"."];
    NSString *fileExtension = [nameArray lastObject];
    
    NSString *fileType = nil;
    if ([fileExtension isEqualToString:@"jpg"]) {
        fileType = @"image/jpeg";
    }
    
    if ([fileExtension isEqualToString:@"png"]) {
        fileType = @"image/png";
    }
    
    if ([fileExtension isEqualToString:@"jpeg"]) {
        fileType = @"image/jpeg";
    }
    
    if ([fileExtension isEqualToString:@"amr"]) {
        fileType = @"audio/amr";
    }
    
    if ([fileExtension isEqualToString:@"mp3"]) {
        fileType = @"audio/mp3";
    }
    
    return fileType;
    
}
- (NSData*)imageDataWithImage:(UIImage *)image WithName:(NSString*)imageName
{
    NSData *imageData = nil;
    if ([imageName rangeOfString:@"png"].location!=NSNotFound) {
        imageData = UIImagePNGRepresentation(image);
    }
    if ([imageName rangeOfString:@"jpg"].location!=NSNotFound || [imageName rangeOfString:@"jpeg"].location!=NSNotFound) {
        imageData = UIImageJPEGRepresentation(image,0.5);
    }
    return imageData;
}

- (void)uploadFileWithData:(NSData *)fileData withFileName:(NSString *)fileName withUploadProgressBlock:(XXDataCenterUploadFileProgressBlock)uploadProgressBlock withSuccessBlock:(XXDataCenterUploadFileSuccessBlock)success withFaildBlock:(XXDataCenterRequestFaildMsgBlock)faild
{
    //是否存在网络
    if ([[XXHTTPClient shareClient]networkReachabilityStatus]==AFNetworkReachabilityStatusNotReachable) {
        if (faild) {
            faild(XXNetWorkDisConnected);
            return;
        }
    }
    NSMutableURLRequest *uploadRequest  = [[XXHTTPClient shareClient]multipartFormRequestWithMethod:@"POST" path:[XXDataCenterConst switchRequestTypeToInterfaceUrl:XXRequestTypeUploadFile] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"upload" fileName:fileName mimeType:[self mediaFileTypeForFileName:fileName]];
    }];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:uploadRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *resultDict = (NSDictionary*)JSON;
        
        DDLogVerbose(@"resultDict -->%@",resultDict);
        NSInteger statusCode = [[resultDict objectForKey:@"ret"]intValue];
        if (statusCode==0) {
            
            NSArray *usefulProperty = @[@"attachment_id",@"user_id",@"add_time",@"filename",@"link",@"description"];
            NSDictionary *mDict = @{@"attachment_id": @"",@"user_id":@"",@"add_time":@"",@"filename":@"",@"link":@"",@"description":@""};
            NSMutableDictionary *modelDict = [NSMutableDictionary dictionaryWithDictionary:mDict];
            [resultDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([usefulProperty containsObject:(NSString*)key]) {
                    [modelDict setObject:obj forKey:key];
                }
            }];
            DDLogVerbose(@"fileter dict -->%@",modelDict);
            XXAttachmentModel *attachModel = [[XXAttachmentModel alloc]initWithContentDict:modelDict];
            DDLogVerbose(@"attachModel --->%@",attachModel);
            if (success) {
                success(attachModel);
            }
            
        }else{
            if (faild) {
                faild([resultDict objectForKey:@"msg"]);
            }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (faild) {
            faild([error description]);
        }
    }];
    [jsonRequest setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat uploadKbSize = totalBytesWritten/1024.0f;
        CGFloat totoalSize = totalBytesExpectedToWrite/1024.0f;
        CGFloat uploadProgressValue = uploadKbSize/totoalSize;

        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgressValue);
        }
        
    }];
    [[XXHTTPClient shareClient]enqueueHTTPRequestOperation:jsonRequest];
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
       
        DDLogVerbose(@"login result dict --->%@",resultDict);
        NSDictionary *userData = [resultDict objectForKey:@"user"];
        NSMutableDictionary *userMutil = [NSMutableDictionary dictionaryWithDictionary:userData];
        [userMutil setObject:[resultDict objectForKey:@"token"] forKey:@"token"];
        [userMutil setObject:@"1" forKey:@"status"];
        XXUserModel *loginUser = [[XXUserModel alloc]initWithContentDict:userMutil];
        [XXUserDataCenter loginThisUser:loginUser];//保存当前登录用户
        if (success) {
            success(loginUser);
        }
        
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

- (void)requestRegistWithNewUser:(XXUserModel *)newUser withSuccessRegist:(XXDataCenterRequestDetailUserBlock)success withFaildRegist:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!newUser.account||!newUser.password||!newUser.schoolId||!newUser.grade||!newUser.headUrl) {
        if (faild) {
            faild (XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *normalParams = @{@"account":newUser.account,@"password":newUser.password,@"xuexiao_id":newUser.schoolId,@"grade":newUser.grade,@"picture":newUser.headUrl};
    
    [self requestXXRequest:XXRequestTypeRegist withParams:normalParams withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        
        DDLogVerbose(@"regist result -->%@",resultDict);
        XXUserModel *registUserModel = [[XXUserModel alloc]init];
        registUserModel.userId = [resultDict objectForKey:@"user_id"];
        if (success) {
            success(registUserModel);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
        DDLogVerbose(@"regist faild -->%@",faildMsg);
    }];
    
}

- (void)requestSearchSchoolListWithDescription:(XXSchoolModel*)conditionSchool WithSuccessSearch:(XXDataCenterRequestSuccessListBlock)success withFaildSearch:(XXDataCenterRequestFaildMsgBlock)faild
{
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (conditionSchool.searchKeyword) {
        [params setObject:conditionSchool.searchKeyword forKey:@"keyword"];
    }
    if (conditionSchool.type) {
        [params setObject:conditionSchool.type forKey:@"type"];
    }
    if (conditionSchool.area) {
        [params setObject:conditionSchool.area forKey:@"area"];
    }
    if (conditionSchool.city) {
        [params setObject:conditionSchool.city forKey:@"city"];
    }
    if (conditionSchool.province) {
        [params setObject:conditionSchool.province forKey:@"province"];
    }
    
    [self requestXXRequest:XXRequestTypeSearchSchool withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        
        DDLogVerbose(@"resultDict -->%@",resultDict);
        NSArray *schoolList = [resultDict objectForKey:@"data"];
        NSMutableArray *modelResultArray = [NSMutableArray array];
        for (NSDictionary *item in schoolList) {
            
            XXSchoolModel *schoolModel = [[XXSchoolModel alloc]initWithContentDict:item];
            [modelResultArray addObject:schoolModel];
        }
        if (success) {
            success(modelResultArray);
        }
        
    } withFaild:^(NSString *faildMsg) {
        
        if (faild) {
            faild(faildMsg);
        }
        
    }];
    
}

/////////////=====================    ===============================//////////////////
//潜伏学校
- (void)requestStrollSchoolWithConditionSchool:(XXSchoolModel*)conditionSchool withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionSchool.schoolId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *param = @{@"xuexiao_id":conditionSchool.schoolId};
    [self requestXXRequest:XXRequestTypeStrollSchool withParams:param withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"stroll schooll success --->%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//更新用户资料
- (void)requestUpdateUserInfoWithConditionUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (conditionUser.account) {
        [params setObject:conditionUser.account forKey:@"account"];
    }
    if (conditionUser.password) {
        [params setObject:conditionUser.password forKey:@"password"];
    }
    if (conditionUser.nickName) {
        [params setObject:conditionUser.nickName forKey:@"nickname"];
    }
    if (conditionUser.email){
        [params setObject:conditionUser.email forKey:@"email"];
    }
    if(conditionUser.grade){
        [params setObject:conditionUser.grade forKey:@"grade"];
    }
    if(conditionUser.sex){
        [params setObject:conditionUser.sex forKey:@"sex"];
    }
    if(conditionUser.birthDay){
        [params setObject:conditionUser.birthDay forKey:@"birthday"];
    }
    if(conditionUser.signature){
        [params setObject:conditionUser.signature forKey:@"signature"];
    }
    if(conditionUser.headUrl){
        [params setObject:conditionUser.headUrl forKey:@"picture"];
    }
    if(conditionUser.bgImage){
        [params setObject:conditionUser.bgImage forKey:@"bgimage"];
    }
    if(conditionUser.constellation){
        [params setObject:conditionUser.constellation forKey:@"constellation"];
    }
    if(conditionUser.schoolId){
        [params setObject:conditionUser.schoolId forKey:@"xuexiao_id"];
    }
    if(conditionUser.strollSchoolId){
        [params setObject:conditionUser.strollSchoolId forKey:@"stroll_xuexiao_id"];
    }
    DDLogVerbose(@"update user info-->%@",params);
    [self requestXXRequest:XXRequestTypeUpdateUserInfo withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];

}

//附件详情
- (void)requestAttachmentDetailWithConditionAttachment:(XXAttachmentModel*)conditionAttachment withSuccess:(XXDataCenterUploadFileSuccessBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionAttachment.attachementId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"attachment_id":conditionAttachment.attachementId};
    [self requestXXRequest:XXRequestTypeFileDetail withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"attchment detail:%@",resultDict);
        if (success) {
            XXAttachmentModel *newAttachment = [[XXAttachmentModel alloc]initWithContentDict:[resultDict objectForKey:@"attachment"]];
            success(newAttachment);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//添加好友关心
- (void)requestAddFriendCareWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionFriend.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"user_id":conditionFriend.userId};
    [self requestXXRequest:XXRequestTypeAddFriendCare withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"add friend care resutl:%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//取消好友关心
- (void)requestCancelFriendCareWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionFriend.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"user_id":conditionFriend.userId};
    [self requestXXRequest:XXRequestTypeCancelFriendCare withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"cancel friend care result:%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//我关心的列表搜索
- (void)requestMyCareFriendWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(conditionFriend.keyword){
        [params setObject:conditionFriend.keyword forKey:@"keyword"];
    }
    [self requestXXRequest:XXRequestTypeMyCareFriend withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"my care friend list:%@",resultDict);
        if (success) {
            NSArray *userList = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXUserModel *userItem = [[XXUserModel alloc]initWithContentDict:item];
                [modelArray addObject:userItem];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//关心我的列表搜索
- (void)requestCareMeFriendWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(conditionFriend.keyword){
        [params setObject:conditionFriend.keyword forKey:@"keyword"];
    }
    [self requestXXRequest:XXRequestTypeCareMe withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"my care friend list:%@",resultDict);
        if (success) {
            NSArray *userList = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXUserModel *userItem = [[XXUserModel alloc]initWithContentDict:item];
                [modelArray addObject:userItem];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//发表评论
- (void)requestPublishCommentWithConditionComment:(XXCommentModel*)conditionComment withSuccess:(XXDataCenterCommentDetailBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

//评论列表
- (void)requestCommentListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

//追捧
- (void)requestPraisePublishWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

//分享列表
- (void)requestSharePostListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

//发表分享
- (void)requestPostShareWithConditionSharePost:(XXSharePostModel*)conditionPost withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionPost.postContent&&!conditionPost.postType&&!conditionPost.postImages&&!conditionPost.postAudio) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if (![XXUserDataCenter currentLoginUser]) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    if (conditionPost.postContent) {
        [content setObject:conditionPost.postContent forKey:XXSharePostJSONContentKey];
    }
    if (conditionPost.postType) {
        [content setObject:[NSNumber numberWithInt:conditionPost.postType] forKey:XXSharePostJSONTypeKey];
    }
    if (conditionPost.postImages) {
        [content setObject:conditionPost.postImages forKey:XXSharePostJSONImageKey];
    }
    if (conditionPost.postAudio) {
        [content setObject:conditionPost.postAudio forKey:XXSharePostJSONAudioKey];
    }
    if (conditionPost.postAudioTime) {
        [content setObject:conditionPost.postAudioTime forKey:XXSharePostJSONAudioTime];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"content"];
    if (conditionPost.tag) {
        [params setObject:conditionPost.tag forKey:@"tag"];
    }
    [params setObject:[XXUserDataCenter currentLoginUser].schoolId forKey:@"xuexiao_id"];

    //request
    [self requestXXRequest:XXRequestTypePostShare withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"post share result:%@",resultDict);
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];
}

//发表相册
- (void)requestPostTalkWithCondistionSharePost:(XXSharePostModel*)conditionPost withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionPost.postContent&&!conditionPost.postType&&!conditionPost.postImages&&!conditionPost.postAudio) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if (![XXUserDataCenter currentLoginUser]) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    if (conditionPost.postContent) {
        [content setObject:conditionPost.postContent forKey:XXSharePostJSONContentKey];
    }
    if (conditionPost.postType) {
        [content setObject:[NSNumber numberWithInt:conditionPost.postType] forKey:XXSharePostJSONTypeKey];
    }
    if (conditionPost.postImages) {
        [content setObject:conditionPost.postImages forKey:XXSharePostJSONImageKey];
    }
    if (conditionPost.postAudio) {
        [content setObject:conditionPost.postAudio forKey:XXSharePostJSONAudioKey];
    }
    if (conditionPost.postAudioTime) {
        [content setObject:conditionPost.postAudioTime forKey:XXSharePostJSONAudioTime];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"content"];
    if (conditionPost.tag) {
        [params setObject:conditionPost.tag forKey:@"tag"];
    }
    [params setObject:[XXUserDataCenter currentLoginUser].schoolId forKey:@"xuexiao_id"];
    
    //request
    [self requestXXRequest:XXRequestTypePostTalk withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"post talk result:%@",resultDict);
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];

}

//校园搬家
- (void)requestMoveHomeWithDestinationSchool:(XXSchoolModel*)conditionSchool withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionSchool.schoolId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"xuexiao_id":conditionSchool.schoolId};
    [self requestXXRequest:XXRequestTypeMoveHome withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//用户详情
- (void)requestUserDetailWithDetinationUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestDetailUserBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionUser.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"user_id":conditionUser.userId};
    [[XXMainDataCenter shareCenter]requestXXRequest:XXRequestTypeUserDetail withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"user detail :%@",resultDict);
        if (success) {
            XXUserModel *resultUser = [[XXUserModel alloc]initWithContentDict:[resultDict objectForKey:@"user"]];
            success(resultUser);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//射孤独
- (void)requestLonelyShootWithSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    [self requestXXRequest:XXRequestTypeLonelyShoot withParams:nil withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"lonely shoot result:%@",resultDict);
        if (success) {
            NSArray *userList = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXUserModel *userItem = [[XXUserModel alloc]initWithContentDict:item];
                [modelArray addObject:userItem];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//校内人
- (void)requestSameSchoolUsersWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.schoolId) {
        
    }
}

//挑逗
- (void)requestTeaseUserWithCondtionTease:(XXTeaseModel *)conditionTease withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionTease.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if(!conditionTease.postEmoji){
        if(faild){
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //conent
    NSMutableDictionary *contentParam = [NSMutableDictionary dictionary];
    [contentParam setObject:conditionTease.postEmoji forKey:XXTeasePostJSONEmojiKey];
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:contentParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paramContentStrng = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
    [params setObject:paramContentStrng forKey:@"content"];

    [self requestXXRequest:XXRequestTypeTeaseUser withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if(success){
            
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];
}

//挑逗我的列表
- (void)requestTeaseMeListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

//附近的人
- (void)requestNearbyUserWithConditionUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

//建议反馈
- (void)requestAdvicePublishWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
}

@end
