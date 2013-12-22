//
//  XXPhotoCropViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXPhotoCropViewController.h"

@interface XXPhotoCropViewController ()

@end

@implementation XXPhotoCropViewController

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
    contentScroller = [[BFImageScroller alloc]init];
    contentScroller.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    contentScroller.maximumZoomScale = 3.0f;
    contentScroller.minimumZoomScale = 1.0f;
    contentScroller.delegate = self;
    contentScroller.contentImageView.image = [UIImage imageNamed:@"xxx.jpg"];
    [self.view addSubview:contentScroller];
    
    topVisiableHeight = 50;
    bottomVisiableHeigh = 120;
    
    //visiable area
    UIColor *blackColor=[UIColor blackColor];
    CGFloat  boardAlpha = 0.4;
    UIImageView *topBoard = [[UIImageView alloc]init];
    topBoard.frame = CGRectMake(0,topVisiableHeight,self.view.frame.size.width,topVisiableHeight);
    topBoard.backgroundColor = blackColor;
    topBoard.alpha = boardAlpha;
    [self.view addSubview:topBoard];
    
    UIImageView *bottomBorad = [[UIImageView alloc]init];
    CGFloat visiableHeight = self.view.frame.size.height-topVisiableHeight-bottomVisiableHeigh;
    bottomBorad.frame = CGRectMake(0,topVisiableHeight+visiableHeight,self.view.frame.size.width,bottomVisiableHeigh);
    bottomBorad.backgroundColor = blackColor;
    bottomBorad.alpha = boardAlpha;
    [self.view addSubview:bottomBorad];
    
    //cancel button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelImage = [UIImage imageNamed:@"red_button.png"];
    CGSize cancelImageSize = cancelImage.size;
    UIImage *chooseImage = [UIImage imageNamed:@"blue_button.png"];
    CGSize chooseImageSize = chooseImage.size;
    
    CGFloat leftMagin = (self.view.frame.size.width-cancelImageSize.width-chooseImageSize.width)/3;
    CGFloat topMargin = (bottomVisiableHeigh-cancelImageSize.height)/2;
    cancelButton.frame = CGRectMake(leftMagin,topMargin,cancelImageSize.width,cancelImageSize.height);
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    //
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(cancelButton.frame.origin.x+cancelButton.frame.size.width+leftMagin,topMargin,chooseImage.size.width,chooseImageSize.height);
    [cancelButton setBackgroundImage:chooseImage forState:UIControlStateNormal];
    [cancelButton setTitle:@"确定" forState:UIControlStateNormal];
    [self .view addSubview:cancelButton];
    [self.view addSubview:chooseButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroller delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    BFImageScroller *scroller = (BFImageScroller*)scrollView;
    
    return scroller.contentImageView;
}

@end
