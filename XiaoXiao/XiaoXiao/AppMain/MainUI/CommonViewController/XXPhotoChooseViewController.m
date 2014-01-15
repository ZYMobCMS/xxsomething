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
        _maxChooseNumber = 1;
    }
    return self;
}
- (id)initWithMutilPhotoChooseWithMaxChooseNumber:(NSInteger)maxNumber withFinishBlock:(XXPhotoChooseViewControllerFinishChooseBlock)chooseBlock
{
    if (self = [super init]) {
        
        _chooseBlock = [chooseBlock copy];     
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
    
    XXCustomButton *chooseCamerou = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    chooseCamerou.frame = CGRectMake(20,50,280,40);
    chooseCamerou.tag = 238790;
    [chooseCamerou blueStyle];
    chooseCamerou.iconImageView.image = [UIImage imageNamed:@"photo_choose_camerou.png"];
    chooseCamerou.iconImageView.frame = CGRectMake(76,10,20,20);
    [chooseCamerou setTitle:@"现场拍照" forState:UIControlStateNormal];
    chooseCamerou.titleLabel.frame = CGRectMake(115,3,80,34);
    [self.view addSubview:chooseCamerou];
    [chooseCamerou addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    XXCustomButton *chooseLibrary = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    chooseLibrary.frame = CGRectMake(20,130,280,40);
    chooseLibrary.tag = 238791;
    [chooseLibrary blueStyle];
    chooseLibrary.iconImageView.image = [UIImage imageNamed:@"photo_choose_lib.png"];
    [chooseLibrary setTitle:@"相册筛选" forState:UIControlStateNormal];
    chooseLibrary.titleLabel.frame = CGRectMake(115,3,80,34);
    chooseLibrary.iconImageView.frame = CGRectMake(76,10,20,20);
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
        
        CTAssetsPickerController *pickController=[[CTAssetsPickerController alloc]init];
        pickController.maximumNumberOfSelection = _maxChooseNumber;
        pickController.delegate = self;
        [self presentViewController:pickController animated:YES completion:Nil];
    }
}
//CTAssetsPickerController delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    DDLogVerbose(@"mutil image select :%@",assets);
    if (assets.count==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    NSMutableArray *imageArray = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        ALAsset *item = (ALAsset*)obj;
        ALAssetRepresentation *itemRepresention = [item defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[itemRepresention fullScreenImage]];
        [imageArray addObject:image];
        
    }];
    if (self.needCrop) {
        ALAssetRepresentation *imageRepresentaion = [[assets objectAtIndex:0]defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[imageRepresentaion fullResolutionImage]];
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
            ALAssetRepresentation *imageRepresentaion = [[assets objectAtIndex:0]defaultRepresentation];
            UIImage *image = [UIImage imageWithCGImage:[imageRepresentaion fullResolutionImage]];
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
                _chooseBlock(imageArray);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
