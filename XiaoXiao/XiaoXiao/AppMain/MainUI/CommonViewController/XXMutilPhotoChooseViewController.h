//
//  XXMutilPhotoChooseViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"

/*
 *通用多选图片列表
 */
typedef void (^XXMutilPhotoChooseViewControllerFinishChooseBlock) (NSArray *images);

@interface XXMutilPhotoChooseViewController : UIViewController<QBImagePickerControllerDelegate>
{
    XXMutilPhotoChooseViewControllerFinishChooseBlock _chooseBlock;
    QBImagePickerController *_imagePickerController;
}
- (id)initWithMutilSelectMaxPhotoNumbers:(NSInteger)maxNumber withFinishChooseBlock:(XXMutilPhotoChooseViewControllerFinishChooseBlock)chooseBlock;

@end
