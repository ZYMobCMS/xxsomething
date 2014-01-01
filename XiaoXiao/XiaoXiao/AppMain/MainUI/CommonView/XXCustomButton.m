//
//  XXCustomButton.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-1.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXCustomButton.h"

@implementation XXCustomButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.frame = CGRectMake(5,5,15,15);
        [self addSubview:self.iconImageView];
        self.iconImageView.userInteractionEnabled = NO;
        
        self.customTitleLabel = [[UILabel alloc]init];
        self.customTitleLabel.frame = CGRectMake(5,5,40,15);
        self.customTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.customTitleLabel];
        self.customTitleLabel.userInteractionEnabled = NO;
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

@end
