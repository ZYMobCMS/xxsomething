//
//  XXUserModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXUserModel : NSObject
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *account;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *score;
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *strollSchoolId;
@property (nonatomic,strong)NSString *headUrl;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *grade;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *birthDay;
@property (nonatomic,strong)NSString *signature;
@property (nonatomic,strong)NSString *bgImage;
@property (nonatomic,strong)NSString *constellation;
@property (nonatomic,strong)NSString *postCount;
@property (nonatomic,strong)NSString *registTime;
@property (nonatomic,strong)NSAttributedString *attributedContent;
@property (nonatomic,strong)NSString *schoolName;
@property (nonatomic,strong)NSString *wellknow;
@property (nonatomic,strong)NSString *praiseCount;
@property (nonatomic,strong)NSString *tooken;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *latitude;
@property (nonatomic,strong)NSString *longtitude;

@property (nonatomic,strong)NSString *keyword;//搜索关心列表时用来传值用,可以不编码保存


- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
