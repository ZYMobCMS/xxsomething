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
#define IS_IOS_7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0
#define CGRectX(x,y,w,h) CGRectMake(x,(y+(IS_IOS_7?20:0)),w,h)
#define StringInt(x) [NSString stringWithFormat:@"%d",x]
#define StringFloat(x) [NSString stringWithFormat:@"%f",x]
#define StringLong(x) [NSString stringWithFormat:@"%ld",x]

#define XXNavContentHeight [UIScreen mainScreen].bounds.size.height-20

typedef enum {
    XXSchoolTypeHighSchool = 0,
    XXSchoolTypeCollege,
}XXSchoolType;

typedef enum {
    
    XXBaseCellTypeTop = 0,
    XXBaseCellTypeMiddel,
    XXBaseCellTypeBottom,
    XXBaseCellTypeRoundSingle,
    XXBaseCellTypeCornerSingle,
    
    
}XXBaseCellType;

typedef void (^XXNavigationNextStepItemBlock) (void);
typedef void (^XXCommonNavigationNextStepBlock) (NSDictionary *resultDict);

@interface XXCommonUitil : NSObject
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController*)aViewController;
+ (void)setCommonNavigationReturnItemForViewController:(UIViewController*)aViewController withBackStepAction:(XXNavigationNextStepItemBlock)stepAction;
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction;
+ (void)setCommonNavigationNextStepItemForViewController:(UIViewController*)aViewController withNextStepAction:(XXNavigationNextStepItemBlock)nextAction withTitle:(NSString*)title;
+ (void)setCommonNavigationTitle:(NSString*)title forViewController:(UIViewController*)aViewController;

+ (void)keywindowShowProgressHUDWithProgressValue:(CGFloat)progressValue withTitle:(NSString*)title;
+ (void)keywindowShowProgressHUDWithTitle:(NSString*)withTitle;
+ (void)keywindowShowProgressHUDHiddenNow;

@end
