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
        [userMutil setObject:[resultDict objectForKey:@"tooken"] forKey:@"tooken"];
        [userMutil setObject:@"1" forKey:@"status"];
        XXUserModel *loginUser = [[XXUserModel alloc]initWithContentDict:userMutil];
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

@end
