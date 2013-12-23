//
//  XXCommonUitil.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define XXThemeColor [UIColor colorWithRed:10/255.0 green:216/255.0 blue:204/255.0 alpha:1]

@interface XXCommonUitil : NSObject
+ (void)keywindowShowProgressHUDWithProgressValue:(CGFloat)progressValue withTitle:(NSString*)title;
+ (void)keywindowShowProgressHUDWithTitle:(NSString*)withTitle;
+ (void)keywindowShowProgressHUDHiddenNow;

@end
