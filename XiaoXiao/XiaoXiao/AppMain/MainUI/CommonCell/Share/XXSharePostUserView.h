//
//  XXSharePostUserView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "DTAttributedTextContentView.h"
#import "XXSharePostModel.h"
#import "XXTeaseModel.h"

@interface XXSharePostUserView : DTAttributedTextContentView
- (void)setContentModel:(XXSharePostModel*)contentModel;
+ (NSAttributedString*)useHeadAttributedStringWithModel:(XXSharePostModel*)contentModel;
+ (NSAttributedString*)useHeadAttributedStringWithTeaseModel:(XXTeaseModel*)contentModel;
@end
