//
//  XXPhotoChooseViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXPhotoChooseViewController.h"
#import "XXPhotoCropViewController.h"
#import "XXPhotoFilterViewController.h"

@interface XXPhotoChooseViewController ()

@end

@implementation XXPhotoChooseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhotoChooseFinishAction:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock
{
    if (self = [super init]) {
        
        _chooseBlock = [chooseBlock copy];
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.chooseType = XXPhotoChooseTypeSingle;
    }
    return self;
}
- (id)initWithMutilPhotoChooseWithMaxChooseNumber:(NSInteger)maxNumber withFinishBlock:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock
{
    if (self = [super init]) {
        
        _chooseBlock = [chooseBlock copy];
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;        
        _maxChooseNumber = maxNumber;
        if (maxNumber>1) {
            self.chooseType = XXPhotoChooseTypeMutil;
        }else{
            self.chooseType = XXPhotoChooseTypeSingle;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    DDLogVerbose(@"self.view :%@",NSStringFromCGRect(self.view.frame));
    
    XXCustomButton *chooseCamerou = [[XXCustomButton alloc]initWithFrame:CGRectMake(50,50,220,40)];
    chooseCamerou.tag = 238790;
    chooseCamerou.backgroundColor = [XXCommonStyle xxThemeBlueColor];
    chooseCamerou.layer.cornerRadius = 4.0f;
    chooseCamerou.iconImageView.image = [UIImage imageNamed:@"photo_choose_camerou.png"];
    chooseCamerou.iconImageView.frame = CGRectMake(76,3,34,34);
    chooseCamerou.customTitleLabel.text = @"现场拍照";
    chooseCamerou.customTitleLabel.frame = CGRectMake(115,3,80,34);
    [self.view addSubview:chooseCamerou];
    [chooseCamerou addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    XXCustomButton *chooseLibrary = [[XXCustomButton alloc]initWithFrame:CGRectMake(10,130,220,40)];
    chooseLibrary.tag = 238791;
    chooseLibrary.backgroundColor = [XXCommonStyle xxThemeBlueColor];
    chooseLibrary.layer.cornerRadius = 4.0f;
    chooseLibrary.iconImageView.image = [UIImage imageNamed:@"photo_choose_lib.png"];
    chooseLibrary.customTitleLabel.text = @"照片库选择";
    chooseLibrary.iconImageView.frame = CGRectMake(76,3,34,34);
    chooseLibrary.customTitleLabel.frame = CGRectMake(115,3,80,34);
    [self.view addSubview:chooseLibrary];
    [chooseLibrary addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tap
- (void)chooseTypeAction:(UIButton*)sender
{
    NSInteger type = sender.tag-238790;
    if (type==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"此设备不支持拍照哦～"];
        }
    }
    if (type==1) {
        if (self.chooseType==XXPhotoChooseTypeMutil) {
            CTAssetsPickerController *pickController=[[CTAssetsPickerController alloc]init];
            pickController.assetsFilter = [ALAssetsFilter allAssets];
            pickController.maximumNumberOfSelection = _maxChooseNumber;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:Nil];
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:Nil];
        }
    }
}
//CTAssetsPickerController delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    DDLogVerbose(@"mutil image select :%@",assets);
    NSMutableArray *imageArray = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        ALAsset *item = (ALAsset*)obj;
        UIImage *aImage = [UIImage imageWithCGImage:item.thumbnail];
        [imageArray addObject:aImage];
        
    }];
    if (_chooseBlock) {
        _chooseBlock(imageArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DDLogVerbose(@"need crop:%d",self.needCrop);
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.needCrop) {
        XXPhotoCropViewController *cropVC = [[XXPhotoCropViewController alloc]initWithOriginImage:image withFinishCropBlock:^(UIImage *resultImage) {
            if (self.needFilter) {
                XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:resultImage withChooseBlock:^(UIImage *resultImage) {
                    if (_chooseBlock) {
                        NSArray *chooseImages = @[resultImage];
                        if (_chooseBlock) {
                            _chooseBlock(chooseImages);
                        }
                    }
                }];
                filterVC.effectImgViewHeight = self.singleImageCropHeight;
                filterVC.isSettingHeadImage = self.isSetHeadImage;
                [filterVC setNextStepAction:^(NSDictionary *resultDict) {
                    if (_nextStepBlock) {
                        _nextStepBlock(resultDict);
                    }
                }];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC withBackStepAction:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self.navigationController pushViewController:filterVC animated:YES];
            }else{
                if (_chooseBlock) {
                    NSArray *resultImages = @[resultImage];
                    _chooseBlock(resultImages);
                }
            }
        }];
        cropVC.visiableHeight = self.singleImageCropHeight;
        [self.navigationController pushViewController:cropVC animated:YES];
    }else{
        if (self.needFilter) {
            XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:image withChooseBlock:^(UIImage *resultImage) {
                if (_chooseBlock) {
                    NSArray *chooseImages = @[resultImage];
                    if (_chooseBlock) {
                        _chooseBlock(chooseImages);
                    }
                }
            }];
            filterVC.effectImgViewHeight = self.singleImageCropHeight;
            filterVC.isSettingHeadImage = self.isSetHeadImage;
            [filterVC setNextStepAction:^(NSDictionary *resultDict) {
                if (_nextStepBlock) {
                    _nextStepBlock(resultDict);
                }
            }];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC withBackStepAction:^{
                if (_returnStepBlock) {
                    _returnStepBlock();
                }
            }];
            [self.navigationController pushViewController:filterVC animated:YES];
        }else{
            if (_chooseBlock) {
                NSArray *resultImages = @[image];
                _chooseBlock(resultImages);
            }
        }
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - next step
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock
{
    _nextStepBlock = [nextStepBlock copy];
}
- (void)setReturnStepBlock:(XXNavigationNextStepItemBlock)returnStepBlock
{
    _returnStepBlock = [returnStepBlock copy];
}
@end
