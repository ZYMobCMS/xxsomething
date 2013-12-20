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
        
        contentTextView = [[XXBaseTextView alloc]init];
        contentTextView.frame = CGRectMake(50,30,[XXUserInfoCellStyle contentWidth],100);
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
    NSString *css = [XXShareTemplateBuilder buildUserCellCSSTemplateWithBundleFormatteFile:XXUserCellTemplateCSS withShareStyle:[XXUserCellStyle userCellStyle]];
    NSString *htmlString = [XXShareTemplateBuilder buildUserCellContentWithCSSTemplate:css withUserModel:userModel];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithHTMLData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    
    return attributedString;
}

- (void)setContentModel:(XXUserModel *)userModel
{
    NSAttributedString *attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:userModel];
    [contentTextView setAttributedString:attributedContent];
    CGFloat contentHeight = [XXUserInfoBaseCell heightWithContentModel:userModel];
    [contentTextView setFrame:CGRectMake(contentTextView.frame.origin.x,contentTextView.frame.origin.y,contentTextView.frame.size.width,contentHeight)];
}

+ (CGFloat)heightWithContentModel:(XXUserModel *)userModel
{
    NSAttributedString *attributedText = [XXUserInfoBaseCell buildAttributedStringWithUserModel:userModel];
    DTAttributedTextContentView *testView = [[DTAttributedTextContentView alloc]init];
    [testView setAttributedString:attributedText];
    
    CGSize contentSize = [testView suggestedFrameSizeToFitEntireStringConstraintedToWidth:[XXUserInfoCellStyle contentWidth]];
    
    return contentSize.height+60;
}

@end
