//
//  XXPhotoFilterViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXPhotoFilterViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "GBPathImageView.h"

@class XXImageEffectItem;
typedef void (^XXImageEffectItemSelectBlock) (XXImageEffectItem *selectItem);
@interface XXImageEffectItem : UIControl
{
    XXImageEffectItemSelectBlock _selectBlock;
    
}
@property (nonatomic,strong)UIImageView *effectImgView;
@property (nonatomic,strong)UILabel *titleLabel;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)aImage withSelectBlock:(XXImageEffectItemSelectBlock)selectBlock;
@end

@implementation XXImageEffectItem
#define XXImageEffectItemTitleFontSize 10
- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)aImage withSelectBlock:(XXImageEffectItemSelectBlock)selectBlock
{
    if (self = [super initWithFrame:frame]) {
        
        self.effectImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height*4/5)];
        self.effectImgView.layer.borderWidth = 1.0f;
        self.effectImgView.layer.borderColor = XXThemeColor.CGColor;
        self.effectImgView.image = aImage;
        [self addSubview:self.effectImgView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.frame = CGRectMake(0,frame.size.height*4/5+5,frame.size.width,frame.size.height*1/5-5);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:XXImageEffectItemTitleFontSize];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textColor  = [UIColor whiteColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        _selectBlock = [selectBlock copy];
        
        //
        [self addTarget:self action:@selector(tapOnSelfAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)tapOnSelfAction
{
    if (_selectBlock) {
        _selectBlock(self);
    }
}
@end

typedef void (^XXImageFilterChooseViewFinishBlock) (IFFilterType filterType);
@interface XXImageFilterChooseView : UIView
{
    XXImageFilterChooseViewFinishBlock _finishBlock;
}
@property (nonatomic,strong)UIImage *currentImage;
- (id)initWithFrame:(CGRect)frame withOriginImage:(UIImage*)originImage withFinishBlock:(XXImageFilterChooseViewFinishBlock)finishBlock;

@end

@implementation XXImageFilterChooseView
#define XXImageFilterChooseViewItemMargin 20
#define XXImageFilterChooseViewTopMargin 5
#define XXImageFilterChooseViewItemWidth 50
#define XXImageFilterItemBaseTag 3333990

- (id)initWithFrame:(CGRect)frame withOriginImage:(UIImage *)originImage withFinishBlock:(XXImageFilterChooseViewFinishBlock)finishBlock
{
    if (self = [super initWithFrame:frame]) {
        
        _finishBlock = [finishBlock copy];
        self.currentImage = originImage;
        
        //
        NSArray *effectNames = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色",@"唯美",@"清新",@"阳光",@"怀旧",@"复古",nil];
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        
        for (int i=0; i<effectNames.count; i++) {
        
            CGRect itemRect = CGRectMake((i+1)*XXImageFilterChooseViewItemMargin+i*XXImageFilterChooseViewItemWidth,XXImageFilterChooseViewTopMargin,XXImageFilterChooseViewItemWidth,frame.size.height-2*XXImageFilterChooseViewTopMargin);
            
            XXImageEffectItem *item = [[XXImageEffectItem alloc]initWithFrame:itemRect withImage:self.currentImage withSelectBlock:^(XXImageEffectItem *selectItem) {
                
                NSInteger selectIndex = selectItem.tag-XXImageFilterItemBaseTag;
                if (_finishBlock) {
                    _finishBlock([self filterTypeAtIndex:selectIndex]);
                }
                
            }];
            item.titleLabel.text = [effectNames objectAtIndex:i];
            item.tag = XXImageFilterItemBaseTag+i;
            [scrollView addSubview:item];
        }
        CGFloat totalContentWidth = (effectNames.count+1)*XXImageFilterChooseViewItemMargin+effectNames.count*XXImageFilterChooseViewItemWidth;
        scrollView.contentSize = CGSizeMake(totalContentWidth,frame.size.height);
        [self addSubview:scrollView];
    }
    return self;
}

-(IFFilterType)filterTypeAtIndex:(int)index
{
    IFFilterType filterType;
    switch (index) {
        case 0:
        {
            filterType = IF_NORMAL_FILTER;
        }
            break;
        case 1:
        {
            filterType = IF_1977_FILTER;
        }
            break;
        case 2:
        {
            filterType = IF_AMARO_FILTER;
        }
            break;
        case 3:
        {
            filterType = IF_BRANNAN_FILTER;
        }
            break;
        case 4:
        {
            filterType = IF_FILTER_TOTAL_NUMBER;
        }
            break;
        case 5:
        {
            filterType = IF_HEFE_FILTER;
        }
            break;
        case 6:
        {
            filterType = IF_HUDSON_FILTER;
        }
            break;
        case 7:
        {
            filterType = IF_INKWELL_FILTER;
        }
            break;
        case 8:
        {
            filterType = IF_LOMOFI_FILTER;
        }
            break;
        case 9:
        {
            filterType = IF_LORDKELVIN_FILTER;
        }
            break;
        case 10:
        {
            filterType = IF_NASHVILLE_FILTER;
            
        }
            break;
        case 11:
        {
            filterType = IF_RISE_FILTER;
            
        }
            break;
        case 12:
        {
            filterType = IF_SIERRA_FILTER;
            
        }
            break;
        case 13 :
        {
            filterType = IF_SUTRO_FILTER;
        }
            break;
        case 14:
        {
            filterType = IF_TOASTER_FILTER;
        }
            break;
        case 15:
        {
            filterType = IF_VALENCIA_FILTER;
        }
            break;
        case 16:
        {
            filterType = IF_WALDEN_FILTER;
        }
            break;
        case 17:
        {
            filterType = IF_XPROII_FILTER;
        }
            break;
    }
    return filterType;
}

@end

@interface XXPhotoFilterViewController ()

@end

@implementation XXPhotoFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"滤镜效果";
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        if (_nextStepBlock) {
            if (self.isSettingHeadImage) {
                NSDictionary *resultDict = @{@"result":effectHeadImgView.image};
                _nextStepBlock(resultDict);
            }else{
                NSDictionary *resultDict = @{@"result":effectImgView.image};
                _nextStepBlock(resultDict);
            }
        }
    }];
    
    //default
    if (self.effectImgViewHeight==0) {
        self.effectImgViewHeight = 250;
    }
    
    //image filter
    CGFloat scaleCount = 0.f;
    if (self.effectImgViewHeight > self.view.frame.size.height-115-40) {
        scaleCount = (self.view.frame.size.height-115-20)/self.effectImgViewHeight;
    }
    CGFloat scaleWidth = self.view.frame.size.width*scaleCount;
    scaleWidth = scaleWidth>0? scaleWidth:self.view.frame.size.width;
    
    if (self.isSettingHeadImage) {
        CGFloat orignx = (self.view.frame.size.width-77)/2;
        CGFloat origny = (self.view.frame.size.height-44-75-77)/2;
        _imageFilter = [[ZYImageFilter alloc]initWithSaveQuality:YES withShowEffectImageViewFrame:CGRectMake(orignx,origny,77,77)];
    }else{
        _imageFilter = [[ZYImageFilter alloc]initWithSaveQuality:YES withShowEffectImageViewFrame:CGRectMake(0,0,scaleWidth,self.effectImgViewHeight)];
    }
    _imageFilter.rawImage = self.currentImage;
    [self.view addSubview:_imageFilter.gpuImageView];
    [_imageFilter switchFilter:IF_NORMAL_FILTER];
    _imageFilter.gpuImageView.hidden = YES;

    XXImageFilterChooseView *chooseView = [[XXImageFilterChooseView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-115,self.view.frame.size.width,75) withOriginImage:self.currentImage withFinishBlock:^(IFFilterType filterType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageFilter switchFilter:filterType];
            UIImage *currentEffectImage = [_imageFilter currentEffectImage];
            if (self.isSettingHeadImage) {
                effectHeadImgView.image = currentEffectImage;
                [effectHeadImgView setNeedsDisplay];
            }else{
                effectImgView.image = currentEffectImage;
            }
        });
    }];
    [self.view addSubview:chooseView];
    
    if (self.isSettingHeadImage) {
        effectHeadImgView.hidden = NO;
        effectImgView.hidden = YES;
        
        CGFloat originx = (self.view.frame.size.width-self.effectImgViewHeight)/2;
        effectHeadImgView = [[AGMedallionView alloc] initWithFrame:CGRectMake(originx,80,self.effectImgViewHeight,self.effectImgViewHeight)];
        effectHeadImgView.image = self.currentImage;
        [self.view addSubview:effectHeadImgView];
        
    }else{
        effectHeadImgView.hidden = YES;
        effectImgView.hidden = NO;
        effectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20,scaleWidth,self.effectImgViewHeight)];
        effectImgView.image = self.currentImage;
        [self.view addSubview:effectImgView];
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCurrentImage:(UIImage *)aImage withChooseBlock:(XXPhotoFilterViewControllerFinishChooseEffectBlock)chooseBlock
{
    if (self = [super init]) {
        
        self.currentImage = aImage;
        
        _chooseBlock = [chooseBlock copy];
    }
    return self;
}
#pragma mark next step
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock
{
    _nextStepBlock = [nextStepBlock copy];
}

@end
