//
//  XXSharePostModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSharePostModel.h"

@implementation XXSharePostModel
@synthesize postAudio,postContent,postImages,postType,attributedContent;

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        self.postId = [contentDict objectForKey:@"id"];
        self.type = [contentDict objectForKey:@"type"];
        self.tag = [contentDict objectForKey:@"tag"];
        self.commentCount = [contentDict objectForKey:@"comment_count"];
        self.forwordCount = [contentDict objectForKey:@"forword_count"];
        self.praiseCount = [contentDict objectForKey:@"praise_count"];
        self.userId = [contentDict objectForKey:@"user_id"];
        self.addTime = [contentDict objectForKey:@"add_time"];
        self.schoolId = [contentDict objectForKey:@"xuexiao_id"];
        
        //自定义内容字段解析
        NSString *content = [contentDict objectForKey:@"content"];
        NSError *decodeContentJSonError = nil;
        NSDictionary *customContentDict = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&decodeContentJSonError];
        if (decodeContentJSonError) {
            DDLogVerbose(@"decode content json error -->%@",decodeContentJSonError.description);
        }
        self.postContent = [customContentDict objectForKey:XXSharePostJSONContentKey];
        self.postAudio = [customContentDict objectForKey:XXSharePostJSONAudioKey];
        self.postImages = [customContentDict objectForKey:XXSharePostJSONImageKey];
        self.postType = [[customContentDict objectForKey:XXSharePostJSONTypeKey]intValue];
        self.postAudioTime = [customContentDict objectForKey:XXSharePostJSONAudioTime];
        //确保每个属性都有，即使为空字符串
        if (!self.postContent) {
            self.postContent = @"";
        }
        if (!self.postAudio) {
            self.postAudio=@"";
        }
        if (!self.postImages) {
            self.postImages=@"";
        }
        self.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:self forContentWidth:[XXSharePostStyle sharePostContentWidth]];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.postAudio = [aDecoder decodeObjectForKey:@"postAudio"];
        self.postType = [aDecoder decodeIntegerForKey:@"postType"];
        self.postImages = [aDecoder decodeObjectForKey:@"postImages"];
        self.postContent = [aDecoder decodeObjectForKey:@"postContent"];
        self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
                
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.postAudio forKey:@"postAudio"];
    [aCoder encodeInteger:self.postType forKey:@"postType"];
    [aCoder encodeObject:self.postContent forKey:@"postContent"];
    [aCoder encodeObject:self.postImages forKey:@"postImages"];
    [aCoder encodeObject:self.attributedContent forKey:@"attributedContent"];
}

@end
