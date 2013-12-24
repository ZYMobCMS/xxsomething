//
//  XXSharePostModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXSharePostTypeConfig.h"

@interface XXSharePostModel : NSObject
@property (nonatomic,strong)NSAttributedString *attributedContent;
@property (nonatomic,assign)XXSharePostType postType;
@property (nonatomic,strong)NSString *postContent;
@property (nonatomic,strong)NSString *postAudio;
@property (nonatomic,strong)NSString *postImages;
@property (nonatomic,strong)NSString *postAudioTime;

@property (nonatomic,strong)NSString *postId;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *tag;
@property (nonatomic,strong)NSString *commentCount;
@property (nonatomic,strong)NSString *praiseCount;
@property (nonatomic,strong)NSString *forwordCount;
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *addTime;

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
