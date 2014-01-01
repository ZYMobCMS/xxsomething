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

typedef void (^XXImageFilterChooseViewFinishBlock) (UIImage *filterImage);
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

- (id)initWithFrame:(CGRect)frame withOriginImage:(UIImage *)originImage withFinishBlock:(XXImageFilterChooseViewFinishBlock)finishBlock
{
    if (self = [super initWithFrame:frame]) {
        
        _finishBlock = [finishBlock copy];
        self.currentImage = originImage;
        
        //
        NSArray *effectNames = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        
        for (int i=0; i<effectNames.count; i++) {
        
            CGRect itemRect = CGRectMake((i+1)*XXImageFilterChooseViewItemMargin+i*XXImageFilterChooseViewItemWidth,XXImageFilterChooseViewTopMargin,XXImageFilterChooseViewItemWidth,frame.size.height-2*XXImageFilterChooseViewTopMargin);
            
            XXImageEffectItem *item = [[XXImageEffectItem alloc]initWithFrame:itemRect withImage:self.currentImage withSelectBlock:^(XXImageEffectItem *selectItem) {
                
                if (_finishBlock) {
                    _finishBlock(selectItem.effectImgView.image);
                }
                
            }];
            item.effectImgView.image = [self changeImage:i];
            item.titleLabel.text = [effectNames objectAtIndex:i];
            [scrollView addSubview:item];
        }
        CGFloat totalContentWidth = (effectNames.count+1)*XXImageFilterChooseViewItemMargin+effectNames.count*XXImageFilterChooseViewItemWidth;
        scrollView.contentSize = CGSizeMake(totalContentWidth,frame.size.height);
        [self addSubview:scrollView];
    }
    return self;
}

-(UIImage *)changeImage:(int)index
{
    UIImage *image;
    switch (index) {
        case 0:
        {
            return self.currentImage;
        }
            break;
        case 1:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_landiao];
            
        }
            break;
        case 12:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_menghuan];
            
        }
            break;
        case 13:
        {
            image = [ImageUtil imageWithImage:self.currentImage withColorMatrix:colormatrix_yese];
            
        }
    }
    return image;
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
            NSDictionary *resultDict = @{@"result":effectImgView.image};
            _nextStepBlock(resultDict);
        }
    }];
    
    CGFloat scaleCount = 0.f;
    if (self.effectImgViewHeight > self.view.frame.size.height-115-40) {
        scaleCount = (self.view.frame.size.height-115-20)/self.effectImgViewHeight;
    }
    CGFloat scaleWidth = self.view.frame.size.width*scaleCount;
    scaleWidth = scaleWidth>0? scaleWidth:self.view.frame.size.width;
    
    //default
    if (self.effectImgViewHeight==0) {
        self.effectImgViewHeight = 250;
    }
    
    XXImageFilterChooseView *chooseView = [[XXImageFilterChooseView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-115,self.view.frame.size.width,75) withOriginImage:self.currentImage withFinishBlock:^(UIImage *filterImage) {
        effectImgView.image = filterImage;
        if (_chooseBlock) {
            _chooseBlock(filterImage);
        }
    }];
    [self.view addSubview:chooseView];
    
    if (self.isSettingHeadImage) {
        // displaying the image in a circle by using a shape layer
        // layer fill color controls the masking
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        UIBezierPath *layerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, 200, 200)];
        maskLayer.path = layerPath.CGPath;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        
        // use another view for clipping so that when the image size changes, the masking layer does not need to be repositioned
        UIView *clippingViewForLayerMask = [[UIView alloc] initWithFrame:CGRectMake(60, 50, 200, 200)];
        clippingViewForLayerMask.layer.mask = maskLayer;
        clippingViewForLayerMask.clipsToBounds = YES;
        [self.view addSubview:clippingViewForLayerMask];
        
        effectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,20,scaleWidth,self.effectImgViewHeight)];
        effectImgView.backgroundColor = [UIColor lightGrayColor];
        [clippingViewForLayerMask addSubview:effectImgView];
        effectImgView.image = self.currentImage;
        UIImage *resizeImage = [self.currentImage resizedImage:CGSizeMake(200,200) interpolationQuality:kCGInterpolationDefault];
        effectImgView.frame = CGRectMake(0, 0, resizeImage.size.width, resizeImage.size.height);
        effectImgView.center = CGPointMake(effectImgView.superview.frame.size.width/2, effectImgView.superview.frame.size.height/2);
    }else{
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
