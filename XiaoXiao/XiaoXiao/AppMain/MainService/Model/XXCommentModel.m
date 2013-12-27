//
//  XXCommentModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommentModel.h"

@implementation XXCommentModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        //默认值
        self.commentId = @"";
        self.resourceType = @"";
        self.resourceId = @"";
        self.content = @"";
        self.userId = @"";
        self.pCommentId = @"";
        self.rootCommentId = @"";
        self.addTime = @"";

        self.commentId = [contentDict objectForKey:@"id"];
        self.resourceType = [contentDict objectForKey:@"res_type"];
        self.resourceId = [contentDict objectForKey:@"res_id"];
        self.content = [contentDict objectForKey:@"content"];
        self.userId = [contentDict objectForKey:@"user_id"];
        self.pCommentId = [contentDict objectForKey:@"p_id"];
        self.rootCommentId = [contentDict objectForKey:@"root_id"];
        self.addTime = [contentDict objectForKey:@"add_time"];
        
        //解析content字段
        NSData *contentData = [self.content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *customContentDict = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
        NSString *audioTime = [customContentDict objectForKey:XXSharePostJSONAudioTime];
        self.postAudioTime = audioTime;
        if ([audioTime isEqualToString:@"0"]) {
            self.postContent = [contentDict objectForKey:XXSharePostJSONContentKey];
        }else{
            self.postAudio = [contentDict objectForKey:XXSharePostJSONAudioKey];
        }
        
    }
    return self;
}

@end
