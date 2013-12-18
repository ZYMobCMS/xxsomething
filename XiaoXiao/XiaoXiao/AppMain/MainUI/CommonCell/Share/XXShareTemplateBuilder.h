//
//  XXShareTemplateBuilder.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXShareStyle.h"
#import "XXSharePostModel.h"

#define XXTextAlignLeft @"left"
#define XXTextAlignRight @"right"
#define XXTextAlignCenter @"center"
#define XXFontWeightNormal @"normal"
#define XXFontWeightBold   @"bold"


extern BOOL const XXLockShareCSSTemplateState;

@interface XXShareTemplateBuilder : NSObject

+ (NSString*)buildCSSTemplateWithBundleFormatteFile:(NSString*)fileName withShareStyle:(XXShareStyle*)aStyle;

+ (NSString *)buildCSSTemplateWithFormatte:(NSString*)cssFormatte withShareStyle:(XXShareStyle*)aStyle;

+ (NSString*)buildSharePostContentWithCSSTemplate:(NSString*)cssTemplate withSharePostModel:(XXSharePostModel*)aSharePost;

@end
