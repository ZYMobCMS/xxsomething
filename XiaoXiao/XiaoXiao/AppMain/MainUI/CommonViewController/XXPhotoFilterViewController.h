//
//  XXPhotoFilterViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *通用照片滤镜视图
 */
typedef void (^XXPhotoFilterViewControllerFinishChooseEffectBlock) (UIImage *resultImage);

@interface XXPhotoFilterViewController : UIViewController
{
    UIImageView *effectImgView;
    
    XXPhotoFilterViewControllerFinishChooseEffectBlock _chooseBlock;
    XXCommonNavigationNextStepBlock _nextStepBlock;
}
@property (nonatomic,strong)UIImage *currentImage;
@property (nonatomic,assign)CGFloat effectImgViewHeight;
@property (nonatomic,assign)BOOL isSettingHeadImage;

- (id)initWithCurrentImage:(UIImage*)aImage withChooseBlock:(XXPhotoFilterViewControllerFinishChooseEffectBlock)chooseBlock;
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock;
@end
