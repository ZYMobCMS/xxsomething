//
//  XXSharePostUserView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-9.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXSharePostUserView.h"

@implementation XXSharePostUserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setContentModel:(XXSharePostModel *)contentModel
{
    [self setAttributedString:contentModel.userHeadContent];
}
+ (NSAttributedString*)useHeadAttributedStringWithModel:(XXSharePostModel *)contentModel
{
    NSString *htmlContent = [XXShareTemplateBuilder buildSharePostHeadHtmlContentWithName:contentModel.nickName withGrade:contentModel.grade withCollege:contentModel.schoolName withSexTag:contentModel.sex withTimeString:contentModel.friendAddTime];
    NSData *htmlData = [htmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc]initWithHTMLData:htmlData documentAttributes:nil];
}
@end
