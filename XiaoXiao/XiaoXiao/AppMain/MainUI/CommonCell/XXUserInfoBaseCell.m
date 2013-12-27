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
        
        headView = [[XXHeadView alloc]init];
        headView.frame = CGRectMake(10,15,80,80);
        headView.contentImageView.image = [UIImage imageNamed:@"xxx.jpg"];
        [self.contentView addSubview:headView];
        
        contentTextView = [[XXBaseTextView alloc]init];
        contentTextView.frame = CGRectMake(95,15,[XXUserInfoCellStyle contentWidth],100);
        [self.contentView addSubview:contentTextView];
        
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
}

+ (CGFloat)heightWithContentModel:(XXUserModel *)userModel
{
    NSAttributedString *attributedText = [XXUserInfoBaseCell buildAttributedStringWithUserModel:userModel];
    DTAttributedTextContentView *testView = [[DTAttributedTextContentView alloc]init];
    [testView setAttributedString:attributedText];
    
    CGSize contentSize = [testView suggestedFrameSizeToFitEntireStringConstraintedToWidth:[XXUserInfoCellStyle contentWidth]];
    
    return contentSize.height+30;
}

@end
