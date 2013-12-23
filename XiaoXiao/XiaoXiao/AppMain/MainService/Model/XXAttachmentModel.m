//
//  XXAttachmentModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXAttachmentModel.h"

@implementation XXAttachmentModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        self.attachementId = [contentDict objectForKey:@"id"];
        self.createUserId = [contentDict objectForKey:@"user_id"];
        self.description = [contentDict objectForKey:@"description"];
        self.link = [contentDict objectForKey:@"link"];
        self.fileName = [contentDict objectForKey:@"filename"];
        self.addTime = [contentDict objectForKey:@"add_time"];
    }
    return self;
}
@end
