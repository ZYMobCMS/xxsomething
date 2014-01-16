//
//  OtherTeaseCell.m
//  NavigationTest
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "OtherTeaseCell.h"
#import "UIImage+animatedGIF.h"
#import "XXFileUitil.h"

@implementation OtherTeaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat margin = 15.f;
        CGFloat eachItemWidth = (self.frame.size.width- 4*margin)/3;
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTease:)];
        _teaseLeftImgView = [[UIImageView alloc]init];
        _teaseLeftImgView.frame = CGRectMake(margin,5,eachItemWidth,eachItemWidth);
        [_teaseLeftImgView addGestureRecognizer:tapR];
        [self.contentView addSubview:_teaseLeftImgView];
        
        _teaseMiddelImgView = [[UIImageView alloc]init];
        _teaseMiddelImgView.frame = CGRectMake(2*margin+eachItemWidth,5,eachItemWidth,eachItemWidth);
        [_teaseMiddelImgView addGestureRecognizer:tapR];
        [self.contentView addSubview:_teaseMiddelImgView];
        
        _teaseRightImgView = [[UIImageView alloc]init];
        _teaseRightImgView.frame = CGRectMake(3*margin+2*eachItemWidth,5,eachItemWidth,eachItemWidth);
        [_teaseRightImgView addGestureRecognizer:tapR];
        [self.contentView addSubview:_teaseRightImgView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tapTease:(UITapGestureRecognizer*)tapR
{
    NSInteger selectIndex = 0;
    if (tapR.view==_teaseLeftImgView) {
        selectIndex = 0;
    }
    if (tapR.view==_teaseMiddelImgView) {
        selectIndex = 1;
    }
    if (tapR.view==_teaseRightImgView) {
        selectIndex = 2;
    }
    if (_selectBlock) {
        _selectBlock (self,selectIndex);
    }
}

- (void)setTeaseImages:(NSArray *)teaseImages
{
    NSString *tease0 = [teaseImages objectAtIndex:0];
    NSString *tease1 = [teaseImages objectAtIndex:1];
    NSString *tease2 = [teaseImages objectAtIndex:2];
    
    _teaseLeftImgView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:tease0]];
    _teaseMiddelImgView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:tease1]];
    _teaseRightImgView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:tease2]];
    
}
- (void)setTeaseSelectBlock:(OtherTeaseCellDidSelectBlock)selectBlock
{
    _selectBlock = [selectBlock copy];
}

@end