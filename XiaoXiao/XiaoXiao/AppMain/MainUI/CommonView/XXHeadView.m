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
        
        self.contentImageView = [[AGMedallionView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        self.contentImageView.borderColor = [UIColor whiteColor];
        self.contentImageView.borderWidth = 2.0f;
        [self addSubview:self.contentImageView];
        
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
- (void)setHeadWithUserId:(NSString*)userId;
{
    if (!userId) {
        return;
    }
    _userId = userId;

    NSString *imageSizeNeedUrl = [NSString stringWithFormat:@"%@%@/%d/%d/%@",XXBase_Host_Url,XX_Head_Url_Base_Url,(int)self.frame.size.width,(int)self.frame.size.height,userId];
    NSURL *combineUrl = [NSURL URLWithString:imageSizeNeedUrl];
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:combineUrl options:SDWebImageDownloaderAllowInvalidSSLCertificates progress:^(NSUInteger receivedSize, long long expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        self.contentImageView.image = image;
    }];
}
@end
