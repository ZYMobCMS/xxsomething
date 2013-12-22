//
//  XXPhotoChooseViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    XXPhotoChooseTypeSingle=0,
    XXPhotoChooseTypeMutil,
    
}XXPhotoChooseType;

typedef void (^XXPhotoChooseViewControllerFinishChooseBlock) (NSArray *resultImages);
/*
 *通用图库或者现场拍摄选择
 */
@interface XXPhotoChooseViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    XXPhotoChooseViewControllerFinishChooseBlock _chooseBlock;
    NSInteger _maxChooseNumber;
}
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, assign) XXPhotoChooseType chooseType;
@property (nonatomic, assign) CGFloat singleImageCropHeight;//单个图片剪辑的时候的高度
@property (nonatomic, assign) BOOL needCrop;
@property (nonatomic, assign) BOOL needFilter;
@property (nonatomic, assign) BOOL isSetHeadImage;

- (id)initWithSinglePhotoChooseFinishAction:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock;
- (id)initWithMutilPhotoChooseWithMaxChooseNumber:(NSInteger)maxNumber withFinishBlock:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock;

@end
