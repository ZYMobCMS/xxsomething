//
//  XXResponseButton.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-1.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXResponseButton.h"

@implementation XXResponseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(didTapOnSelf) forControlEvents:UIControlEventTouchUpInside];
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
- (void)didTapOnSelf
{
    if (_tapBlock) {
        _tapBlock();
    }
}
- (void)setResponseButtonTapped:(XXResponseButtonDidTapBlock)tapBlock
{
    _tapBlock = [tapBlock copy];
}
@end
