//
//  XXTeaseModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXTeaseModel : NSObject
@property (nonatomic,strong)NSString *postContent;
@property (nonatomic,strong)NSString *postEmoji;

@property (nonatomic,strong)NSString *teaseId;
@property (nonatomic,strong)NSString *teaseTime;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *toUserId;

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
