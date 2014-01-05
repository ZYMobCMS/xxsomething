//
//  SharePostPhotoBox.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-4.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "SharePostPhotoBox.h"

#define XXSharePhotoBoxImageViewBaseTag 2233440
#define XXSharePhotoBoxMargin 5
#define XXSharePhotoBoxImageWidth 50
#define XXSharePhotoBoxMaxNumber 6

@implementation SharePostPhotoBox
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        _backgroundImageView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
        _backgroundImageView.layer.cornerRadius = 7.0f;
        _backgroundImageView.layer.borderWidth = 2.0f;
        [self addSubview:_backgroundImageView];
        
        _addNewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addNewButton.frame = CGRectMake(XXSharePhotoBoxMargin,XXSharePhotoBoxMargin,XXSharePhotoBoxImageWidth,XXSharePhotoBoxImageWidth);
        _addNewButton.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
        _addNewButton.layer.cornerRadius = 5.0f;
        _addNewButton.layer.borderWidth = 1.0f;
        _addNewButton.titleLabel.numberOfLines = 0;
        [_addNewButton addTarget:self action:@selector(tapOnAddNewButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addNewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addNewButton setTitle:@"添加图片" forState:UIControlStateNormal];
        [self addSubview:_addNewButton];
        
        //tap on sub image or box
        _currentImagesNumber = 1;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setImagesArray:(NSArray *)imagesArray
{
    _currentImagesNumber = 1;
    _addNewButton.hidden = NO;
    _addNewButton.frame = CGRectMake(XXSharePhotoBoxMargin,XXSharePhotoBoxMargin,XXSharePhotoBoxImageWidth,XXSharePhotoBoxImageWidth);
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != _addNewButton&&obj!=_backgroundImageView) {
            [obj removeFromSuperview];
        }
    }];
    [imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *aImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [aImageView setImage:obj forState:UIControlStateNormal];
        aImageView.tag = XXSharePhotoBoxImageViewBaseTag+idx;
        [aImageView addTarget:self action:@selector(imageButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self replaceAddNewButtonForNewImageView:aImageView];
        
    }];
}
- (void)replaceAddNewButtonForNewImageView:(UIButton*)aNewImageView
{
    CGRect _addButtonFrame = _addNewButton.frame;
    if (_currentImagesNumber==6) {
        _addButtonFrame = CGRectMake(XXSharePhotoBoxMargin,XXSharePhotoBoxMargin+XXSharePhotoBoxImageWidth+XXSharePhotoBoxMargin,XXSharePhotoBoxImageWidth,XXSharePhotoBoxImageWidth);
        CGRect oldRect = self.frame;
        CGRect newRect = CGRectMake(oldRect.origin.x,oldRect.origin.y,oldRect.size.width,XXSharePhotoBoxMargin*3+XXSharePhotoBoxImageWidth*2);
        _backgroundImageView.frame = CGRectMake(0, 0, newRect.size.width,newRect.size.height);
        _addNewButton.hidden = YES;
        if (_changeBlock) {
            _changeBlock(newRect);
        }
    }
    CGRect _addButtonNewFrame = CGRectOffset(_addButtonFrame,XXSharePhotoBoxMargin+XXSharePhotoBoxImageWidth,0);
    _addNewButton.frame = _addButtonNewFrame;
    aNewImageView.frame = _addButtonFrame;
    [self addSubview:aNewImageView];
    _currentImagesNumber++;
}


- (void)tapOnAddNewButton:(UIButton*)sender
{
    if (_addNewBlock) {
        _addNewBlock();
    }
}

- (void)showBoxImages
{
    if (self.subviews.count<=1) {
        return;
    }
    if (_reviewBlock) {
        _reviewBlock(0);
    }
}

- (void)imageButtonDidTapped:(UIButton*)sender
{
    if (self.subviews.count<=1) {
        return;
    }
    NSInteger selectIndex = sender.tag-XXSharePhotoBoxImageViewBaseTag;
    if (_reviewBlock) {
        _reviewBlock(selectIndex);
    }
}

- (void)setSharePhotoBoxAddNewBlock:(SharePhotoBoxDidTapOnAddBlock)addBlock
{
    _addNewBlock = [addBlock copy];
}
- (void)setSharePhotoBoxReviewPhotoBlock:(SharePhotoBoxDidTapToReviewPhotoBlock)reviewBlock
{
    _reviewBlock = [reviewBlock copy];
}
- (void)setSharePhotoboxDidChangeFrameBlock:(SharePhotoBoxDidChangeFrameBlock)changeBlock
{
    _changeBlock = [changeBlock copy];
}

@end
