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
        
        self.commentId = [contentDict objectForKey:@"id"];
        self.resourceType = [contentDict objectForKey:@"res_type"];
        self.resourceId = [contentDict objectForKey:@"res_id"];
        self.content = [contentDict objectForKey:@"content"];
        self.userId = [contentDict objectForKey:@"user_id"];
        self.pCommentId = [contentDict objectForKey:@"p_id"];
        self.rootCommentId = [contentDict objectForKey:@"root_id"];
        self.addTime = [contentDict objectForKey:@"add_time"];

    }
    return self;
}

@end
