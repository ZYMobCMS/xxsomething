//
//  SharePostGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharePostPhotoBox.h"

typedef enum {
   
    SharePostTypeText = 0,
    SharePostTypeAudio,
    SharePostTypeImage,
    
}SharePostType;

@interface SharePostGuideViewController : UIViewController
{
    SharePostPhotoBox *_photoBox;
    SharePostType      _currentPostType;

    UIButton          *_recordButton;
    UIImageView       *_recordBackImageView;
    UIButton          *_playRecordButton;
    UIButton          *_reRecordButton;
    UILabel           *_recordTimeLabel;

    XXCustomButton    *_useRecordButton;
    XXCustomButton    *_useTextButton;
    UITextView        *_textInputView;
    
    NSInteger          _currentSelectPhotoCount;
    NSMutableArray    *_postImagesArray;
    XXSharePostModel  *_currentPostModel;
    NSString          *_recordWavPath;
    NSString          *_recordAmrPath;
    BOOL               _hasRecordNow;
    
}

- (id)initWithSharePostType:(SharePostType)aType;

@end
