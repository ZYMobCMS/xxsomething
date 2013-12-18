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


@end
