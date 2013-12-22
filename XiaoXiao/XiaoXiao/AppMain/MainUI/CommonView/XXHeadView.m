//
//  XXHeadView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXHeadView.h"

@implementation XXHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // displaying the image in a circle by using a shape layer
        // layer fill color controls the masking
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        UIBezierPath *layerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1,77,77)];
        maskLayer.path = layerPath.CGPath;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        
        // use another view for clipping so that when the image size changes, the masking layer does not need to be repositioned
        UIView *clippingViewForLayerMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 77, 77)];
        clippingViewForLayerMask.layer.mask = maskLayer;
        clippingViewForLayerMask.clipsToBounds = YES;
        [self addSubview:clippingViewForLayerMask];
        
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,77,77)];
        self.contentImageView.backgroundColor = [UIColor lightGrayColor];
        [clippingViewForLayerMask addSubview:self.contentImageView];
        self.contentImageView.center = CGPointMake(self.contentImageView.superview.frame.size.width/2, self.contentImageView.superview.frame.size.height/2);
        
        //cover
        UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        coverImageView.image = [UIImage imageNamed:@"head.png"];
        [self addSubview:coverImageView];
        
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

@end
