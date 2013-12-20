//
//  XXUserCellStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareStyle.h"

@interface XXUserCellStyle : XXShareStyle
@property (nonatomic,strong)NSMutableArray *attributesArray;

+ (XXUserCellStyle*)userCellStyle;

@end
