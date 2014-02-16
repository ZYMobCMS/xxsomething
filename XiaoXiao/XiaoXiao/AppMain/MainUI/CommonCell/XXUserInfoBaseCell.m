//
//  XXUserInfoBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserInfoBaseCell.h"

@implementation XXUserInfoBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        headView = [[XXHeadView alloc]initWithFrame:CGRectMake(10,7,86,86)];
        headView.contentImageView.image = [UIImage imageNamed:@"xxx.jpg"];
        headView.contentImageView.borderWidth = 3.0f;
        [self.contentView addSubview:headView];
        
        contentTextView = [[XXBaseTextView alloc]init];
        contentTextView.frame = CGRectMake(107,18,[XXUserInfoCellStyle contentWidth],64);
        [self.contentView addSubview:contentTextView];
        
        
        UIView *normalBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        normalBack.backgroundColor = rgb(245,246,248,1);
        self.selectedBackgroundView = normalBack;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSAttributedString*)buildAttributedStringWithUserModel:(XXUserModel *)userModel
{
    userModel.signature = [XXBaseTextView switchEmojiTextWithSourceText:userModel.signature];
    NSString *css = [XXShareTemplateBuilder buildUserCellCSSTemplateWithBundleFormatteFile:XXUserCellTemplateCSS withShareStyle:[XXUserCellStyle userCellStyle]];
    NSString *htmlString = [XXShareTemplateBuilder buildUserCellContentWithCSSTemplate:css withUserModel:userModel];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}

- (void)setContentModel:(XXUserModel *)userModel
{
    [contentTextView setAttributedString:userModel.attributedContent];
    CGFloat contentHeight = [XXUserInfoBaseCell heightWithContentModel:userModel];
    [contentTextView setFrame:CGRectMake(contentTextView.frame.origin.x,contentTextView.frame.origin.y,contentTextView.frame.size.width,contentHeight-30)];
    [headView setHeadWithUserId:userModel.userId];
    
    _cellLineImageView.frame = CGRectMake(0,contentHeight-1,self.frame.size.width,1);//重设分割线
}

+ (CGFloat)heightWithContentModel:(XXUserModel *)userModel
{
    return 100;
}

@end
