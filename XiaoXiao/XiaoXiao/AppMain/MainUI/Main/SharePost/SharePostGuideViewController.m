//
//  SharePostGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SharePostGuideViewController.h"
#import "XXPhotoChooseViewController.h"
#import "XXPhotoReviewViewController.h"

@interface SharePostGuideViewController ()

@end

@implementation SharePostGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithSharePostType:(SharePostType)aType
{
    if (self = [super init]) {
        
        _currentPostType = aType;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"发说说";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    _postImagesArray = [[NSMutableArray alloc]init];
    _currentPostModel = [[XXSharePostModel alloc]init];
    _currentPostType = SharePostTypeText;
    _hasRecordNow = NO;
    
    //
    _photoBox = [[SharePostPhotoBox alloc]initWithFrame:CGRectMake(10,30,300,60)];
    [self.view addSubview:_photoBox];
    
    //
    _useRecordButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(15,totalHeight-50-49,290,50)];
    [_useRecordButton defaultStyle];
    [_useRecordButton setTitle:@"用录音描述" forState:UIControlStateNormal];
    [_useRecordButton addTarget:self action:@selector(changeSharePostType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_useRecordButton];
    _useRecordButton.hidden = NO;
    
    //
    _useTextButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(15,totalHeight-50-49,290,50)];
    [_useTextButton defaultStyle];
    [_useTextButton setTitle:@"用文字描述" forState:UIControlStateNormal];
    [_useTextButton addTarget:self action:@selector(changeSharePostType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_useTextButton];
    _useTextButton.hidden = !_useRecordButton.hidden;
    
    //
    _textInputView = [[UITextView alloc]init];
    _textInputView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    _textInputView.layer.borderWidth = 1.0f;
    _textInputView.layer.cornerRadius = 5.0f;
    _textInputView.frame = CGRectMake(10,105,300,60);
    [self.view addSubview:_textInputView];
    _textInputView.hidden = !_useTextButton.hidden;
    
    //record button
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake(90,_photoBox.frame.origin.y+_photoBox.frame.size.height+30, 65, 65);
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_normal.png"] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_selected.png"] forState:UIControlStateHighlighted];
    [_recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
    _recordButton.hidden = !_textInputView.hidden;
    
    //record play
    _recordBackImageView = [[UIImageView alloc]init];
    _recordBackImageView.frame = CGRectMake(85,_photoBox.frame.origin.y+_photoBox.frame.size.height+30,152,104);
    _recordBackImageView.image = [UIImage imageNamed:@"audio_finish_back.png"];
    _recordBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:_recordBackImageView];
    if (_hasRecordNow&&_currentPostType==SharePostTypeAudio) {
        _recordBackImageView.hidden = NO;
    }else{
        _recordBackImageView.hidden = YES;
    }
    
    //play button
    _playRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playRecordButton.frame = CGRectMake(55,35,20,20);
    [_playRecordButton setBackgroundImage:[UIImage imageNamed:@"audio_play_stop.png"] forState:UIControlStateNormal];
    [_playRecordButton setBackgroundImage:[UIImage imageNamed:@"audio_playing.png"] forState:UIControlStateSelected];
    [_playRecordButton addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    [_recordBackImageView addSubview:_playRecordButton];
    
    //re record
    _reRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reRecordButton setTitle:@"重录" forState:UIControlStateNormal];
    [_reRecordButton addTarget:self action:@selector(restartRecord) forControlEvents:UIControlEventTouchUpInside];
    [_reRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _reRecordButton.frame = CGRectMake(100,35,35,35);
    _reRecordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_recordBackImageView addSubview:_reRecordButton];
    
    //time Label
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.frame = CGRectMake(55,65,20,20);
    _recordTimeLabel.backgroundColor = [UIColor clearColor];
    [_recordBackImageView addSubview:_recordTimeLabel];
    
    //
    [self configPhotoBoxAction];
    
    //
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        [self sharePostNow];
    } withTitle:@"发表"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configPhotoBoxAction
{
    __block NSInteger needPhotoCount = 6-_currentSelectPhotoCount;
    XXPhotoChooseViewControllerFinishChooseBlock finishBlock = ^ (NSArray *resultImages){
        _currentSelectPhotoCount = _currentSelectPhotoCount+resultImages.count;
        needPhotoCount = 6-_currentSelectPhotoCount;
        [_postImagesArray addObjectsFromArray:resultImages];
        [_photoBox setImagesArray:_postImagesArray];
    };
    SharePhotoBoxDidTapOnAddBlock addBlock = ^{
        XXPhotoChooseViewController *chooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:needPhotoCount  withFinishBlock:^(NSArray *resultImages) {
            finishBlock(resultImages);
        }];
        [self.navigationController pushViewController:chooseVC animated:YES];
    };
    [_photoBox setSharePhotoBoxAddNewBlock:^{
        addBlock();
    }];
    SharePhotoBoxDidChangeFrameBlock changeBlock = ^(CGRect newFrame){
        _photoBox.frame = newFrame;
        _textInputView.frame = CGRectMake(_textInputView.frame.origin.x,_photoBox.frame.origin.y+_photoBox.frame.size.height+15,_textInputView.frame.size.width,_textInputView.frame.size.height);
    };
    [_photoBox setSharePhotoboxDidChangeFrameBlock:^(CGRect newFrame) {
        changeBlock(newFrame);
    }];
    SharePhotoBoxDidTapToReviewPhotoBlock reviewBlock = ^(NSInteger currentPhotoIndex){
        XXPhotoReviewViewController *reviewController = [[XXPhotoReviewViewController alloc]initWithImagesArray:_postImagesArray withStartIndex:currentPhotoIndex];
        [reviewController setFinishReview:^(NSArray *resultImages) {
            [_photoBox setImagesArray:resultImages];
        }];
        [self.navigationController pushViewController:reviewController animated:YES];
    };
    [_photoBox setSharePhotoBoxReviewPhotoBlock:^(NSInteger currentPhotoIndex) {
        reviewBlock(currentPhotoIndex);
    }];
}

- (void)restartRecord
{
    _recordButton.hidden = NO;
    _recordBackImageView.hidden = YES;
}

- (void)startRecord
{
    _hasRecordNow = NO;
    [[XXAudioManager shareManager]audioManagerStartRecordWithFinishRecordAction:^(NSString *audioSavePath, NSString *wavSavePath,NSString *timeLength) {
        _hasRecordNow = YES;
        _recordTimeLabel.text = timeLength;
        _recordAmrPath = audioSavePath;
        _recordWavPath = wavSavePath;
        _currentPostModel.postAudioTime = timeLength;
        _recordButton.hidden = YES;
        _recordBackImageView.hidden = !_recordButton;
    }];
}
- (void)endRecord
{
    [[XXAudioManager shareManager]audioManagerEndRecord];
}

- (void)playRecord
{
    DDLogVerbose(@"play record!");
    _playRecordButton.selected = YES;
    [[XXAudioManager shareManager]audioManagerPlayLocalWavWithPath:_recordWavPath];
}

- (void)changeSharePostType:(UIButton*)sender
{
    if (sender == _useTextButton) {
        
        _useTextButton.hidden = YES;
        _useRecordButton.hidden = NO;
        
        _currentPostType = SharePostTypeText;
        _textInputView.hidden = NO;
        _recordButton.hidden = !_textInputView.hidden;
        _recordBackImageView.hidden = !_textInputView.hidden;
    }
    
    if (sender == _useRecordButton) {
        
        _useRecordButton.hidden = YES;
        _useTextButton.hidden  = NO;
        
        _currentPostType = SharePostTypeAudio;
        if (_hasRecordNow) {
            _recordBackImageView.hidden = NO;
            _recordButton.hidden = YES;
            _textInputView.hidden = YES;
        }else{
            _recordButton.hidden = NO;
            _textInputView.hidden = YES;
        }
        
    }
    
}

// share post now
- (void)sharePostNow
{
    //upload image or audio
    __block NSMutableArray *resultImageLinks = [NSMutableArray array];
    [_postImagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSData *imageData = UIImageJPEGRepresentation(obj,kCGInterpolationHigh);
        [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"content.jpg" withUploadProgressBlock:^(CGFloat progressValue) {
            
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            
            //缩略图，根据图片个数确定图片的大小和宽度
            CGFloat imageWidth = 0.f;
            switch (_postImagesArray.count) {
                case 1:
                    imageWidth = 274.f;
                    break;
                case 2:
                    imageWidth = 135.f;
                    break;
                case 3:
                    imageWidth = 90.f;
                    break;
                case 4:
                    imageWidth = 90.f;
                    break;
                case 5:
                    imageWidth = 90.f;
                    break;
                case 6:
                    imageWidth = 90.f;
                    break;
                
                default:
                    break;
            }
            NSString *preViewImageLink = [NSString stringWithFormat:@"%@/%d/%d%@",XX_Image_Resize_Url,(int)imageWidth,(int)imageWidth,resultModel.link];
            [resultImageLinks addObject:preViewImageLink];
            
            NSMutableString *postAllImages = [NSMutableString string];
            [resultImageLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx!=resultImageLinks.count-1) {
                    [postAllImages appendFormat:@"%@|",obj];
                }else{
                    [postAllImages appendFormat:@"%@",obj];
                }
            }];
            DDLogVerbose(@"post all images:%@",postAllImages);
            _currentPostModel.postImages = postAllImages;

            //all image upload finish
            if (resultImageLinks.count == _postImagesArray.count) {
                
                //start upload audio if need or start post
                if (_currentPostType == SharePostTypeAudio) {
                    
                    _currentPostModel.postType = [XXSharePostTypeConfig postTypeWithImageCount:resultImageLinks.count withIsAudioContent:YES];
                    //
                    DDLogVerbose(@"record amr path:%@",_recordAmrPath);
                    NSData *audioData = [NSData dataWithContentsOfFile:_recordAmrPath];
                    DDLogVerbose(@"arm upload size :%d",audioData.length);
                    [[XXMainDataCenter shareCenter]uploadFileWithData:audioData withFileName:@"audio.amr" withUploadProgressBlock:^(CGFloat progressValue) {
                        [SVProgressHUD showProgress:progressValue status:@"上传语音"];
                    } withSuccessBlock:^(XXAttachmentModel *resultModel) {
                       
                        //upload audio success,begin share
                        _currentPostModel.postAudio = resultModel.link;
                        [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:_currentPostModel withSuccess:^(NSString *successMsg) {
                            [SVProgressHUD showSuccessWithStatus:successMsg];
                        } withFaild:^(NSString *faildMsg) {
                            [SVProgressHUD showErrorWithStatus:faildMsg];
                        }];
                        
                    } withFaildBlock:^(NSString *faildMsg) {
                        [SVProgressHUD showErrorWithStatus:faildMsg];
                    }];
                    
                }else{
                    _currentPostModel.postAudio = @"";
                    _currentPostModel.postContent = _textInputView.text;
                    _currentPostModel.postAudioTime = @"0";
                    _currentPostModel.postType = [XXSharePostTypeConfig postTypeWithImageCount:resultImageLinks.count withIsAudioContent:NO];
                    [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:_currentPostModel withSuccess:^(NSString *successMsg) {
                        [SVProgressHUD showSuccessWithStatus:successMsg];
                    } withFaild:^(NSString *faildMsg) {
                        [SVProgressHUD showErrorWithStatus:faildMsg];
                    }];
                }
            }
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
        
    }];
    
    
}


@end
