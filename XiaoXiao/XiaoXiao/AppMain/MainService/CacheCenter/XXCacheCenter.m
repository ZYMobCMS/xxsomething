//
//  XXCacheCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCacheCenter.h"

#define XXCacheCenterSchoolDataBase @"xxschool"
#define XXCacheCenterSchoolDataBaseDirectory @"xxschool_database"
#define XXCacheCenterSchoolDataZip @"xxschool.zip"

static dispatch_queue_t XXCacheCenterQueue = nil;

@implementation XXCacheCenter
- (id)init
{
    if (self = [super init]) {
        XXCacheCenterQueue = dispatch_queue_create("com.zyprosoft.cacheCenterQueue",NULL);
        if (![[NSUserDefaults standardUserDefaults]objectForKey:XXCacheCenterSchoolVersionUDF]) {
            [[NSUserDefaults standardUserDefaults]setObject:XXCacheCenterSchoolDefaultVersion forKey:XXCacheCenterSchoolVersionUDF];
        }
        [self openDataBase];
    }
    return self;
}
+ (XXCacheCenter*)shareCenter
{
    static XXCacheCenter *cacheCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheCenter) {
            cacheCenter = [[XXCacheCenter alloc]init];
        }
    });
    return cacheCenter;
}
- (void)dealloc{
    [_innerDataBase close];
}
- (NSString*)schoolDataBaseDir
{
    NSArray *rootPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *rootPath = [rootPaths lastObject];
    NSString *databaseDir = [rootPath stringByAppendingPathComponent:XXCacheCenterSchoolDataBaseDirectory];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:databaseDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:databaseDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return databaseDir;
}
- (NSString*)schoolDataBasePath
{
    NSString *databaseDir = [self schoolDataBaseDir];
    NSString *databaseName = [XXCacheCenterSchoolDataBase stringByAppendingPathExtension:@"sqlite"];
    NSString *databasePath = [databaseDir stringByAppendingPathComponent:databaseName];
    return databasePath;
}
- (void)openDataBase
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:XXCacheCenterSchoolVersionUDF]isEqualToString:XXCacheCenterSchoolDefaultVersion]) {
        NSString *cacheDB = [[NSBundle mainBundle]pathForResource:XXCacheCenterSchoolDataBase ofType:@"sqlite"];
        if (![[NSFileManager defaultManager]fileExistsAtPath:cacheDB]) {
            return;
        }else{
            _innerDataBase = [[FMDatabase alloc]initWithPath:cacheDB];
            [_innerDataBase open];
        }
    }else{
        NSString *databasePath = [self schoolDataBasePath];
        _innerDataBase = [[FMDatabase alloc]initWithPath:databasePath];
        [_innerDataBase open];
    }
    
}
//现在更新学校数据库
- (void)updateSchoolDataBaseNow
{
    XXDataCenterRequestSchoolDataBaseUpdateSuccessBlock successUpdateResult = ^(NSString *newDataBaseUrl,NSString *newVersion){
        NSString *downloadZipFile = [[self schoolDataBaseDir]stringByAppendingPathComponent:XXCacheCenterSchoolDataZip];
        [[XXMainDataCenter shareCenter]downloadFileWithLinkPath:newDataBaseUrl WithDestSavePath:downloadZipFile withSuccess:^(NSString *successMsg) {
            //解压
            [SSZipArchive unzipFileAtPath:downloadZipFile toDestination:[self schoolDataBaseDir]];
            DDLogVerbose(@"download and zip new school database success!");
            DDLogVerbose(@"new school database path :%@",[self schoolDataBasePath]);
            [[NSUserDefaults standardUserDefaults]setObject:newVersion forKey:XXCacheCenterSchoolVersionUDF];
        } withFaild:^(NSString *faildMsg) {
            DDLogVerbose(@"download new school database faild!");
        }];
    };
    
    [[XXMainDataCenter shareCenter]updateSchoolDatabaseWithSuccess:^(NSString *newDataBaseUrl,NSString *newVersion) {
        if (successUpdateResult) {
            successUpdateResult(newDataBaseUrl,newVersion);
        }
    } withFaild:^(NSString *faildMsg) {
        
    }];
}

//模糊搜索
- (void)searchSchoolWithKeyword:(NSString *)keyword withResult:(void (^)(NSArray *))result
{
    NSString *searchSql = [NSString stringWithFormat:@"select * from school where name like '%@' ",keyword];
    NSMutableArray *resultModelArray = [NSMutableArray array];
    dispatch_async(XXCacheCenterQueue, ^{
        
        
        
    });
}
@end
