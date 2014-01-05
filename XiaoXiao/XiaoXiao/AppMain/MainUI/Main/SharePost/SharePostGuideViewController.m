//
//  SharePostGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SharePostGuideViewController.h"
#import "XXPhotoChooseViewController.h"

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
    
    CGFloat totalHeight = XXNavContentHeight-44;
    _postImagesArray = [[NSMutableArray alloc]init];
    _currentPostModel = [[XXSharePostModel alloc]init];
    
    //
    _photoBox = [[SharePostPhotoBox alloc]initWithFrame:CGRectMake(10,30,300,60)];
    [self.view addSubview:_photoBox];
    
    //
    _useRecordButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(15,totalHeight-50-49,290,50)];
    _useRecordButton.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    _useRecordButton.layer.borderWidth = 1.0f;
    _useRecordButton.layer.cornerRadius = 6.0f;
    _useRecordButton.customTitleLabel.text  = @"用录音描述";
    [self.view addSubview:_useRecordButton];
    _useRecordButton.hidden = YES;
    
    //
    _useTextButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(15,totalHeight-50-49,290,50)];
    _useTextButton.customTitleLabel.text = @"用文字描述";
    _useTextButton.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    _useTextButton.layer.borderWidth = 1.0f;
    _useTextButton.layer.cornerRadius = 6.0f;
    [self.view addSubview:_useTextButton];
    _useTextButton.hidden = !_useRecordButton.hidden;
    
    //
    _textInputView = [[UITextView alloc]init];
    _textInputView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    _textInputView.layer.borderWidth = 1.0f;
    _textInputView.layer.cornerRadius = 5.0f;
    _textInputView.frame = CGRectMake(10,105,300,60);
    [self.view addSubview:_textInputView];
    _textInputView.hidden = _useRecordButton.hidden;
    
    //record button
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake(90,_photoBox.frame.origin.y+_photoBox.frame.size.height+30, 65, 65);
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_normal.png"] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"record_audio_selected.png"] forState:UIControlStateHighlighted];
    [_recordButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
    
    //record play
    _recordBackImageView = [[UIImageView alloc]init];
    _recordBackImageView.frame = CGRectMake(85,_photoBox.frame.origin.y+_photoBox.frame.size.height+30,152,104);
    _recordBackImageView.image = [UIImage imageNamed:@"audio_finish_back.png"];
    _recordBackImageView.userInteractionEnabled = YES;
    [self.view addSubview:_recordBackImageView];
    _recordBackImageView.hidden = !_recordButton.hidden;
    
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
    _reRecordButton.frame = CGRectMake(120,35,35,35);
    _reRecordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_recordBackImageView addSubview:_reRecordButton];
    
    //time Label
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.frame = CGRectMake(55,65,20,20);
    _recordTimeLabel.backgroundColor = [UIColor clearColor];
    [_recordBackImageView addSubview:_recordTimeLabel];
    
    //
    [self configPhotoBoxAction];
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
    [_photoBox setSharePhotoBoxReviewPhotoBlock:^(NSInteger currentPhotoIndex) {
        
    }];
}

- (void)startRecord
{
    [[XXAudioManager shareManager]audioManagerStartRecordWithFinishRecordAction:^(NSString *audioSavePath, NSString *wavSavePath) {
        _recordAmrPath = audioSavePath;
        _recordWavPath = wavSavePath;
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

@end
