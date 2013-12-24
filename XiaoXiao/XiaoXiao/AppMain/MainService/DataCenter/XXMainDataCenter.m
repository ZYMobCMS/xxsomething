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
        
        //解析对错
        int status = [[resultDict objectForKey:@"ret"]intValue];
        if (status==0) {
            
            if (success) {
                success(resultDict);
            }
        }
        if (status==1) {
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
//    NSMutableURLRequest *uploadRequest = [[XXHTTPClient shareClient]multipartFormRequestWithMethod:@"POST" path:[XXDataCenterConst switchRequestTypeToInterfaceUrl:XXRequestTypeUploadFile] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:fileData name:@"upload" fileName:fileName mimeType:[self mediaFileTypeForFileName:fileName]];
//    }];
//    uploadRequest.timeoutInterval = 30;
    NSString *uploadUrl = @"http://api.quan-oo.com/api/attachment/upload";
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadUrl]];
    [uploadRequest setHTTPMethod:@"POST"];
    
    NSString *stringBoundary = @"0xAbCdEfGbOuNdArY";
    NSInteger dataLength = fileData.length + 800;
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [uploadRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"upload\"; filename=\"test.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Length:%d",dataLength+500] dataUsingEncoding:NSUTF8StringEncoding]];
    //*******************load locally store audio file********************//
    // add it to body
    [postBody appendData:fileData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    DDLogVerbose(@"fileData --->%@",fileData);
    DDLogVerbose(@"postData ---->%@",[[NSString alloc]initWithData:postBody encoding:NSUTF8StringEncoding]);
    [uploadRequest setHTTPBody:postBody];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    DDLogVerbose(@"upload request header:%@",uploadRequest.allHTTPHeaderFields);
    DDLogVerbose(@"upload request body:%@",[[NSString alloc]initWithData:uploadRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:uploadRequest returningResponse:&response error:&error];
    
    //convert data into string
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response String %@",responseString);
    
}

- (void)uploadFileWithData:(NSData *)fileData withFileName:(NSString *)fileName
{
    
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
       
        
    } withFaild:^(NSString *faildMsg) {
        
        
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
        
    } withFaild:^(NSString *faildMsg) {
        
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
        
        NSLog(@"resultDict -->%@",resultDict);
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
