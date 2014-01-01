//
//  GuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginGuideFinishLoginBlock) (BOOL loginResult);

@interface GuideViewController : UIViewController
{
    LoginGuideFinishLoginBlock _finishBlock;
}
- (void)setLoginGuideFinish:(LoginGuideFinishLoginBlock)finishBlock;

@end
