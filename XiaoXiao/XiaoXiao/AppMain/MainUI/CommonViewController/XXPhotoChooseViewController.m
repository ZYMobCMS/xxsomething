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
#import "XXMutilPhotoChooseViewController.h"

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
        self.chooseType = XXPhotoChooseTypeSingle;
        
        _maxChooseNumber = maxNumber;
        self.chooseType = XXPhotoChooseTypeMutil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *chooseCamerou = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseCamerou.frame = CGRectMake(50,50,220,40);
    chooseCamerou.tag = 238790;
    [chooseCamerou setBackgroundImage:[UIImage imageNamed:@"choose_camerou.png"] forState:UIControlStateNormal];
    [self.view addSubview:chooseCamerou];
    [chooseCamerou addTarget:self action:@selector(chooseTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chooseLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseLibrary.frame = CGRectMake(10,130,220,40);
    chooseLibrary.tag = 238791;
    [chooseLibrary setBackgroundImage:[UIImage imageNamed:@"choose_library.png"] forState:UIControlStateNormal];
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
            [self.navigationController presentModalViewController:self.imagePicker animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"此设备不支持拍照哦～"];
        }
    }
    if (type==1) {
        if (XXPhotoChooseTypeMutil) {
            XXMutilPhotoChooseViewController *mutilVC = [[XXMutilPhotoChooseViewController alloc]initWithMutilSelectMaxPhotoNumbers:_maxChooseNumber withFinishChooseBlock:^(NSArray *images) {
                if (_chooseBlock) {
                    _chooseBlock(images);
                }
            }];
            [self.navigationController pushViewController:mutilVC animated:YES];
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.navigationController presentModalViewController:self.imagePicker animated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
                [self.navigationController pushViewController:filterVC animated:YES];
            }else{
                if (_chooseBlock) {
                    NSArray *resultImages = @[resultImage];
                    _chooseBlock(resultImages);
                }
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }
        }];
        cropVC.visiableHeight = self.singleImageCropHeight;
        [self.navigationController pushViewController:cropVC animated:YES];
    }else{
        if (_chooseBlock) {
            NSArray *resultImages = @[image];
            _chooseBlock(resultImages);
        }
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end
