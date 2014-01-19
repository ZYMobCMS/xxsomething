//
//  XXRecordButton.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXRecordButton.h"

@implementation XXRecordButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:_recordButton];
        
        _playStateImageView = [[UIImageView alloc]init];
        _playStateImageView.frame = CGRectMake((frame.size.width-20)/2,(frame.size.height-20)/2,20,20);
        [self addSubview:_playStateImageView];
        
        _recordTimeLabel = [[UILabel alloc]init];
        _recordTimeLabel.frame = CGRectMake(frame.size.width - 30,10,30,15);
        [self addSubview:_recordTimeLabel];
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

- (void)addTarget:(id)target withTapEnventSelector:(SEL)tapSelector
{
    [_recordButton addTarget:target action:tapSelector forControlEvents:UIControlEventTouchUpInside];
}

@end
