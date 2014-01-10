//
//  XXHeadView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

#define XXHeadViewWidth 80

@interface XXHeadView : UIControl
{
    NSString *_userId;
}
@property (nonatomic,strong)AGMedallionView  *contentImageView;
- (void)setHeadWithUserId:(NSString*)userId;
@end
