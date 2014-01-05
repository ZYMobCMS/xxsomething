//
//  XXUserModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserModel.h"

@implementation XXUserModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        //给个默认值
        self.userId = @"";
        self.account = @"";
        self.password = @"";
        self.nickName = @"";
        self.score = @"";
        self.schoolId = @"";
        self.strollSchoolId = @"";
        self.headUrl = @"";
        self.email = @"";
        self.grade = @"";
        self.sex = @"";
        self.birthDay = @"";
        self.signature = @"";
        self.bgImage = @"";
        self.constellation = @"";
        self.postCount = @"";
        self.registTime = @"";
        self.wellknow = @"";
        self.praiseCount = @"";
        self.tooken = @"";
        self.status = @"";
        self.latitude = @"";
        self.longtitude = @"";
        self.distance = @"";
        self.schoolName = @"";

        //填充获取的值
        self.userId = [contentDict objectForKey:@"id"];
        self.account = [contentDict objectForKey:@"account"];
        self.password = [contentDict objectForKey:@"password"];
        self.nickName = [contentDict objectForKey:@"nickname"];
        self.score = [contentDict objectForKey:@"score"];
        self.schoolId = [contentDict objectForKey:@"xuexiao_id"];
        self.strollSchoolId = [contentDict objectForKey:@"stroll_xuexiao_id"];
        self.headUrl = [contentDict objectForKey:@"picture"];
        self.email = [contentDict objectForKey:@"email"];
        self.grade = [contentDict objectForKey:@"grade"];
        self.sex = [contentDict objectForKey:@"sex"];
        self.birthDay = [contentDict objectForKey:@"birthday"];
        self.signature = [contentDict objectForKey:@"signature"];
        self.bgImage = [contentDict objectForKey:@"bgimage"];
        self.constellation = [contentDict objectForKey:@"constellation"];
        self.postCount = [contentDict objectForKey:@"post_count"];
        self.registTime = [contentDict objectForKey:@"reg_time"];
        self.wellknow = [contentDict objectForKey:@"wellknow"];
        self.praiseCount = [contentDict objectForKey:@"praise_count"];
        self.tooken = [contentDict objectForKey:@"token"];
        self.status = [contentDict objectForKey:@"status"];
        self.latitude = [contentDict objectForKey:@"lat"];
        self.longtitude = [contentDict objectForKey:@"lng"];
        self.schoolName = [contentDict objectForKey:@"school_name"];
        self.distance = [contentDict objectForKey:@"MQ_DISTANCE"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.schoolId = [aDecoder decodeObjectForKey:@"schoolId"];
        self.strollSchoolId = [aDecoder decodeObjectForKey:@"strollSchoolId"];
        self.headUrl = [aDecoder decodeObjectForKey:@"headUrl"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthDay = [aDecoder decodeObjectForKey:@"birthDay"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.bgImage = [aDecoder decodeObjectForKey:@"bgImage"];
        self.constellation = [aDecoder decodeObjectForKey:@"constellation"];
        self.postCount = [aDecoder decodeObjectForKey:@"postCount"];
        self.registTime = [aDecoder decodeObjectForKey:@"registTime"];
        self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
        self.wellknow = [aDecoder decodeObjectForKey:@"wellknow"];
        self.praiseCount = [aDecoder decodeObjectForKey:@"praiseCount"];
        self.tooken = [aDecoder decodeObjectForKey:@"tooken"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longtitude = [aDecoder decodeObjectForKey:@"longtitude"];
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.isUserInfoWell = [aDecoder decodeObjectForKey:@"isUserInfoWell"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.strollSchoolId forKey:@"strollSchoolId"];
    [aCoder encodeObject:self.headUrl forKey:@"headUrl"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthDay forKey:@"birthDay"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.bgImage forKey:@"bgImage"];
    [aCoder encodeObject:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.postCount forKey:@"postCount"];
    [aCoder encodeObject:self.registTime forKey:@"registTime"];
    [aCoder encodeObject:self.attributedContent forKey:@"attributedContent"];
    [aCoder encodeObject:self.wellknow forKey:@"wellknow"];
    [aCoder encodeObject:self.praiseCount forKey:@"praiseCount"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.tooken forKey:@"tooken"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longtitude forKey:@"longtitude"];
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.isUserInfoWell forKey:@"isUserInfoWell"];

}

@end
