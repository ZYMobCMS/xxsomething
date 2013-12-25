//
//  UITestViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "UITestViewController.h"
#import "XXShareBaseCell.h"
#import "XXPhotoFilterViewController.h"
#import "XXPhotoChooseViewController.h"
#import "XXPhotoCropViewController.h"

@interface UITestViewController ()

@end

@implementation UITestViewController

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
    self.sourceArray = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [XXSimpleAudio playRefreshEffect];
    });
    
    NSString *commonContent =@"美女,一般解释为容貌美丽的女子。营养专家提出的营养学上的美女定义，是从脸蛋比例、体质指数、健康指标和发育程度等方面进行要求，更倾重于一种健康的标准。古代关于美女的形容词和诗词歌赋众多[亲亲]，形成了丰富的美学资料［可怜］。";
    NSString *audio = @"http://pan.baidu.com/share/link?shareid=434720&uk=3157602687";
    NSString *image0 = @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=15e98ef2a586c91708035539fd0571cf/0824ab18972bd407b5d9b9f779899e510fb30999.jpg";
    NSString *image1 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=9f85cd29b27eca8012053ee7a51b96dd/91ef76c6a7efce1bb082a3c0ad51f3deb48f650a.jpg";
    NSString *image2 = @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=79cf7b17d62a283443a6310b6f8dc8ea/adaf2edda3cc7cd994865fd33b01213fb80e9114.jpg";
    NSString *image3 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=44c95f085e6034a829e2bf81ff2b4854/71cf3bc79f3df8dc0cec5998cf11728b461028e2.jpg";

    CGFloat styleContent = [XXSharePostStyle sharePostContentWidth];
    
    //image audio
//    XXSharePostModel *modelOneImage0 = [[XXSharePostModel alloc]init];
//    modelOneImage0.postType = XXSharePostTypeImageAudio0;
//    modelOneImage0.postImages = @"";
//    modelOneImage0.postContent = @"";
//    modelOneImage0.postAudio = audio;
//    modelOneImage0.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage0 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelOneImage0];
////    DDLogVerbose(@"post model attributed content :%@",modelOneImage0.attributedContent);
//    
//
//    
//    XXSharePostModel *modelOneImage = [[XXSharePostModel alloc]init];
//    modelOneImage.postType = XXSharePostTypeImageAudio1;
//    modelOneImage.postImages = image0;
//    modelOneImage.postContent = @"";
//    modelOneImage.postAudio = audio;
//    modelOneImage.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage forContentWidth:styleContent];
//    [self.sourceArray addObject:modelOneImage];
//    
//    XXSharePostModel *modelOneImage2 = [[XXSharePostModel alloc]init];
//    modelOneImage2.postType = XXSharePostTypeImageAudio2;
//    modelOneImage2.postImages = [NSString stringWithFormat:@"%@|%@",image0,image1];
//    modelOneImage2.postContent = @"";
//    modelOneImage2.postAudio = audio;
//    modelOneImage2.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage2 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelOneImage2];
//    
//    XXSharePostModel *modelOneImage3 = [[XXSharePostModel alloc]init];
//    modelOneImage3.postType = XXSharePostTypeImageAudio3;
//    modelOneImage3.postImages = [NSString stringWithFormat:@"%@|%@|%@",image0,image1,image2];
//    modelOneImage3.postContent = @"";
//    modelOneImage3.postAudio = audio;
//    modelOneImage3.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage3 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelOneImage3];
//    
//    XXSharePostModel *modelOneImage4 = [[XXSharePostModel alloc]init];
//    modelOneImage4.postType = XXSharePostTypeImageAudio4;
//    modelOneImage4.postImages = [NSString stringWithFormat:@"%@|%@|%@|%@",image0,image1,image2,image3];
//    modelOneImage4.postContent = @"";
//    modelOneImage4.postAudio = audio;
//    modelOneImage4.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage4 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelOneImage4];
//    
//    
//    //image text
//    XXSharePostModel *modelTwoImage0 = [[XXSharePostModel alloc]init];
//    modelTwoImage0.postType = XXSharePostTypeImageText0;
//    modelTwoImage0.postImages = @"";
//    modelTwoImage0.postContent = commonContent;
//    modelTwoImage0.postAudio = @"";
//    modelTwoImage0.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage0 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelTwoImage0];
//    
//    XXSharePostModel *modelTwoImage1 = [[XXSharePostModel alloc]init];
//    modelTwoImage1.postType = XXSharePostTypeImageText1;
//    modelTwoImage1.postImages = [NSString stringWithFormat:@"%@",image0];
//    modelTwoImage1.postContent = commonContent;
//    modelTwoImage1.postAudio = @"";
//    modelTwoImage1.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage1 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelTwoImage1];
//    
//    XXSharePostModel *modelTwoImage2 = [[XXSharePostModel alloc]init];
//    modelTwoImage2.postType = XXSharePostTypeImageText2;
//    modelTwoImage2.postImages = [NSString stringWithFormat:@"%@|%@",image0,image1];
//    modelTwoImage2.postContent = commonContent;
//    modelTwoImage2.postAudio = @"";
//    modelTwoImage2.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage2 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelTwoImage2];
//    
//    XXSharePostModel *modelTwoImage3 = [[XXSharePostModel alloc]init];
//    modelTwoImage3.postType = XXSharePostTypeImageText3;
//    modelTwoImage3.postImages = [NSString stringWithFormat:@"%@|%@|%@",image0,image1,image2];
//    modelTwoImage3.postContent = commonContent;
//    modelTwoImage3.postAudio = @"";
//    modelTwoImage3.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage3 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelTwoImage3];
//    
//    XXSharePostModel *modelTwoImage4 = [[XXSharePostModel alloc]init];
//    modelTwoImage4.postType = XXSharePostTypeImageText4;
//    modelTwoImage4.postImages = [NSString stringWithFormat:@"%@|%@|%@|%@",image0,image1,image2,image3];
//    modelTwoImage4.postContent = commonContent;
//    modelTwoImage4.postAudio = @"";
//    modelTwoImage4.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage4 forContentWidth:styleContent];
//    [self.sourceArray addObject:modelTwoImage4];
    
    //=============== user test ==============
    //userlist
//    [self.sourceArray removeAllObjects];
//    XXUserModel *newUser0 = [[XXUserModel alloc]init];
//    newUser0.schoolName = @"北京理工大学";
//    newUser0.score = @"78%";
//    newUser0.nickName = @"秋风落叶";
//    newUser0.signature = @"没有过不去得坎";
//    newUser0.constellation = [NSString stringWithFormat:@"天蝎座 | 校内知名度"];
//    [self.sourceArray addObject:newUser0];
//    
//    XXUserModel *newUser1 = [[XXUserModel alloc]init];
//    newUser1.schoolName = @"北京大学";
//    newUser1.score = @"48%";
//    newUser1.nickName = @"秋风";
//    newUser1.signature = @"没有得坎[亲亲],一日之际,一日之际,一日之际,一日之际";
//    newUser1.constellation = [NSString stringWithFormat:@"天蝎座 | 校内知名度:"];
//    [self.sourceArray addObject:newUser1];
//    
//    XXUserModel *newUser2 = [[XXUserModel alloc]init];
//    newUser2.schoolName = @"北京航天航空大学";
//    newUser2.score = @"28%";
//    newUser2.nickName = @"秋";
//    newUser2.signature = @"顺利进取一日之际,一日之际,一日之际,一日之际,一日之际";
//    newUser2.constellation = [NSString stringWithFormat:@"天蝎座 | 校内知名度:"];
//    [self.sourceArray addObject:newUser2];
//    
//    XXUserModel *newUser3 = [[XXUserModel alloc]init];
//    newUser3.schoolName = @"清华大学";
//    newUser3.score = @"98%";
//    newUser3.nickName = @"冬天";
//    newUser3.signature = @"一日之际,没有过不去得坎没有过不去得坎没有过不去得坎,没有过不去得坎";
//    newUser3.constellation = [NSString stringWithFormat:@"天蝎座 | 校内知名度:"];
//    [self.sourceArray addObject:newUser3];
//    
//    XXUserModel *newUser4 = [[XXUserModel alloc]init];
//    newUser4.schoolName = @"北京语言大学";
//    newUser4.score = @"58%";
//    newUser4.nickName = @"铭铭";
//    newUser4.signature = @"创意无限,你爱得一切,你爱得一切";
//    newUser4.constellation = [NSString stringWithFormat:@"天蝎座 | 校内知名度:"];
//    [self.sourceArray addObject:newUser4];
//    
//    XXUserModel *newUser5 = [[XXUserModel alloc]init];
//    newUser5.schoolName = @"北京外国语大学";
//    newUser5.score = @"68%";
//    newUser5.nickName = @"春天";
//    newUser5.signature = @"你爱得一切,你爱得一切";
//    newUser5.constellation = [NSString stringWithFormat:@"天蝎座 | 校内知名度:"];
//    [self.sourceArray addObject:newUser5];
    //=============== user test ==============
    
    
    self.testTable = [[UITableView alloc]init];
//    self.testTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.testTable.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-44);
    self.testTable.delegate = self;
    self.testTable.dataSource = self;
//    [self.view addSubview:self.testTable];
    
    DDLogVerbose(@"self.sourceArray --->%@",self.sourceArray);
    
    //=================== image filter ==================
    //test image Filter
//    UIImageView *testImgView = [[UIImageView alloc]init];
//    testImgView.frame = CGRectMake(0, 60, 320, 240);
//    [self.view addSubview:testImgView];
    
//    UIImage *orignImg = [UIImage imageNamed:@"xxx.jpg"];
    
    //亮度调整(-255,255)
//    UIImage *brightImg = [orignImg brightenWithValue:-255];
//    testImgView.image = brightImg;
    
    //对比调整 (-255,255)
//    UIImage *constraitImg = [orignImg contrastAdjustmentWithValue:-100];
//    testImgView.image = constraitImg;
    
    //边缘检测
//    UIImage *edgeDetectionImg = [orignImg edgeDetectionWithBias:255];
//    testImgView.image = edgeDetectionImg;
    
    //拷花
//    UIImage *embossImg = [orignImg embossWithBias:50];
//    testImgView.image = embossImg;
    
    //gammaCorrection
//    UIImage *gammaCorrection = [orignImg gammaCorrectionWithValue:1];
//    testImgView.image = gammaCorrection;
    
    //灰度
//    UIImage *grayscaleImg = [orignImg grayscale];
//    testImgView.image = grayscaleImg;
    
    //invert,反透
//    UIImage *invert = [orignImg invert];
//    testImgView.image = invert;
    
    //sepia,怀旧
//    UIImage *sepia = [orignImg sepia];
//    testImgView.image = sepia;
    
    //sharpenWithBias,磨皮
//    UIImage *sharpe = [orignImg sharpenWithBias:100];
//    testImgView.image = sharpe;
    
    //unsharpe
//    UIImage *unsharpe = [orignImg unsharpenWithBias:1];
//    testImgView.image = unsharpe;
    //==========================================================
    
    //======new image filter
//    ImageFilterProcessViewController *filterProcessViewController = [[ImageFilterProcessViewController alloc]init];
//    [filterProcessViewController setCurrentImage:[UIImage imageNamed:@"xxx.jpg"]];
//    filterProcessViewController.delegate = self;
//    [self.view addSubview:filterProcessViewController.view];
//    XXPhotoFilterViewController *filterVC = [[XXPhotoFilterViewController alloc]initWithCurrentImage:[UIImage imageNamed:@"xxx.jpg"] withChooseBlock:^(UIImage *resultImage) {
//        
//    }];
//    [self.view addSubview:filterVC.view];
    
    //test photo
//    UIImageView *resultImageView = [[UIImageView alloc]init];
//    resultImageView.frame = CGRectMake(70, 150,150,150);
//    [self.view addSubview:resultImageView];
//    XXPhotoCropViewController *cropVC = [[XXPhotoCropViewController alloc]initWithOriginImage:[UIImage imageNamed:@"love.jpg"] withFinishCropBlock:^(UIImage *resultImage) {
//        resultImageView.image = resultImage;
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    XXPhotoChooseViewController *chooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:6 withFinishBlock:^(NSArray *resultImages) {
//        
//    }];
//    chooseVC.needCrop = YES;
//    chooseVC.needFilter = YES;
//    chooseVC.singleImageCropHeight = 230;
//    chooseVC.isSetHeadImage = NO;
//    [self.navigationController pushViewController:chooseVC animated:YES];
    
    
    //test base text view
    /*
    XXBaseTextView *baseTextView = [[XXBaseTextView alloc]init];
    baseTextView.frame = CGRectMake(10,30,300,300);
    [self.view addSubview:baseTextView];
    [baseTextView setText:commonContent];*/

    //test login
//    XXUserModel *newUser = [[XXUserModel alloc]init];
//    newUser.account = @"22222";
//    newUser.password = @"11111";
//    [[XXMainDataCenter shareCenter]requestLoginWithNewUser:newUser withSuccessLogin:^(XXUserModel *detailUser) {
//        
//    } withFaildLogin:^(NSString *faildMsg) {
//        
//    }];
    
        
    //test upload
    UIBarButtonItem *uploadItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(loginAction)];
    self.navigationItem.leftBarButtonItem = uploadItem;
    
    //test login
    UIBarButtonItem *loginTest = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(testNetworkAPI)];
    self.navigationItem.rightBarButtonItem = loginTest;
    
    UIButton *sendTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendTest setTitle:@"send" forState:UIControlStateNormal];
    sendTest.frame = CGRectMake(80, 150,80,40);
    [sendTest addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendTest];
}
//
- (void)sendMessage
{
    ZYXMPPUser *newUser = [[ZYXMPPUser alloc]init];
    newUser.jID = @"36";
    ZYXMPPMessage *message = [[ZYXMPPMessage alloc]init];
    message.content = @"test send content !!!";
    message.user = @"vincent";
    message.audioTime = @"";
    message.userId = @"36";
    message.messageType = [NSString stringWithFormat:@"%d",ZYXMPPMessageTypeText];
    [xmppClient sendMessageToUser:newUser withContent:message];
}
//================================ API Test ==================//
- (void)testNetworkAPI
{
    //需要先登录
    //潜伏学校
//    XXSchoolModel *destSchool = [[XXSchoolModel alloc]init];
//    destSchool.schoolId = @"10778";
//    [[XXMainDataCenter shareCenter]requestStrollSchoolWithConditionSchool:destSchool withSuccess:^(NSString *successMsg) {
//        [SVProgressHUD showSuccessWithStatus:successMsg];
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //更新资料
//    XXUserModel *updateInfo = [XXUserDataCenter currentLoginUser];
//    DDLogVerbose(@"update user current :%@",updateInfo);
//    updateInfo.grade = @"三年级";
//    updateInfo.signature = @"内心强大才是真的强大";
//    updateInfo.constellation = @"射手座";
//    updateInfo.sex = @"0";
//    [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:updateInfo withSuccess:^(NSString *successMsg) {
//        [SVProgressHUD showSuccessWithStatus:successMsg];
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //附件详情
//    XXAttachmentModel *attachment = [[XXAttachmentModel alloc]init];
//    attachment.attachementId = @"50";
//    [[XXMainDataCenter shareCenter]requestAttachmentDetailWithConditionAttachment:attachment withSuccess:^(XXAttachmentModel *resultModel) {
//        
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //我的关心列表
//    XXUserModel *condtionUser = [[XXUserModel alloc]init];
//    condtionUser.keyword = @"";
//    //空的给提示个空吧
//    [[XXMainDataCenter shareCenter]requestMyCareFriendWithConditionFriend:condtionUser withSuccess:^(NSArray *resultList) {
//        
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //发布分享
//    XXSharePostModel *conditionPost = [[XXSharePostModel alloc]init];
//    conditionPost.postContent = @"我的第一条分享测试，来自iPhone5s土豪金";
//    conditionPost.postType = XXSharePostTypeImageText0;
//    [[XXMainDataCenter shareCenter]requestPostShareWithConditionSharePost:conditionPost withSuccess:^(NSString *successMsg) {
//        [SVProgressHUD showSuccessWithStatus:successMsg];
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //校园搬家
//    XXSchoolModel *conditionSchool = [[XXSchoolModel alloc]init];
//    conditionSchool.schoolId = @"10778";
//    [[XXMainDataCenter shareCenter]requestMoveHomeWithDestinationSchool:conditionSchool withSuccess:^(NSString *successMsg) {
//        [SVProgressHUD showSuccessWithStatus:successMsg];
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //用户详情
//    XXUserModel *conditionUser = [[XXUserModel alloc]init];
//    conditionUser.userId = @"30";
//    [[XXMainDataCenter shareCenter]requestUserDetailWithDetinationUser:conditionUser withSuccess:^(XXUserModel *detailUser) {
//        
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //射孤独
//    [[XXMainDataCenter shareCenter]requestLonelyShootWithSuccess:^(NSArray *resultList) {
//        
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    //挑逗别人
//    XXTeaseModel *destUser = [[XXTeaseModel alloc]init];
//    destUser.userId = @"36";
//    destUser.postEmoji = @"[小样]";
//    [[XXMainDataCenter shareCenter]requestTeaseUserWithCondtionTease:destUser withSuccess:^(NSString *successMsg) {
//        [SVProgressHUD showSuccessWithStatus:successMsg];
//    } withFaild:^(NSString *faildMsg) {
//        [SVProgressHUD showErrorWithStatus:faildMsg];
//    }];
    
    //测试Xmpp
    xmppClient = [[ZYXMPPClient alloc]init];
    [xmppClient setNeedAutoJIDWithCustomHostName:YES];
    [xmppClient setNeedUseCustomHostAddress:YES];
    [xmppClient setJabbredServerAddress:@"112.124.37.183"];
    [xmppClient setConnectToServerErrorAction:^(NSString *errMsg) {
        [SVProgressHUD showErrorWithStatus:errMsg];
    }];
    [xmppClient setDidRecievedMessage:^(ZYXMPPMessage *newMessage) {
        
        //程序运行在前台，消息正常显示
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
        {
            NSString *combineContent = [NSString stringWithFormat:@"from:%@\nsend time:%@ \n content:%@",newMessage.user,newMessage.addTime,newMessage.content];
            [SVProgressHUD showSuccessWithStatus:combineContent];
            
        }else{//如果程序在后台运行，收到消息以通知类型来显示
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertAction = @"Ok";
            localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",newMessage.user,newMessage.content];//通知主体
            localNotification.soundName = @"crunch.wav";//通知声音
            localNotification.applicationIconBadgeNumber = 1;//标记数
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];//发送通知
        }
        
    }];
    
    [xmppClient setSendMessageFaildAction:^(ZYXMPPMessage *message, ZYXMPPUser *toUser) {
        
    }];
    [xmppClient setSendMessageSuccessAction:^(ZYXMPPMessage *message, ZYXMPPUser *toUser) {
        
    }];
    [xmppClient startClientWithJID:@"36" withPassword:@"123456"];
    
    //分享列表
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        XXConditionModel *condition = [[XXConditionModel alloc]init];
        condition.pageIndex = @"1";
        condition.pageSize = @"10";
        [[XXMainDataCenter shareCenter]requestSharePostListWithCondition:condition withSuccess:^(NSArray *resultList) {
            DDLogVerbose(@"share modle list:%@",resultList);
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
    });
}
//============================================================//
- (void)loginAction
{
    XXUserModel *registUser = [[XXUserModel alloc]init];
    registUser.account = @"testuser33";
    registUser.password = @"123456";
    [[XXMainDataCenter shareCenter]requestLoginWithNewUser:registUser withSuccessLogin:^(XXUserModel *detailUser) {
        DDLogVerbose(@"login user -->%@",detailUser);
    } withFaildLogin:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)uploadTest
{
//    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"love" ofType:@"mp3"]];
    NSData *fileData = UIImageJPEGRepresentation([UIImage imageNamed:@"af.jpeg"],0.5);
    
    DDLogVerbose(@"file data length -->%d",fileData.length);
    [[XXMainDataCenter shareCenter]uploadFileWithData:fileData withFileName:@"head.jpeg" withUploadProgressBlock:^(CGFloat progressValue) {
        
        [SVProgressHUD showProgress:progressValue status:@"正在上传"];
        
    } withSuccessBlock:^(XXAttachmentModel *resultModel) {
        
        DDLogVerbose(@"resultModel:%@",resultModel.link);
                
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        
        //search school
        XXSchoolModel *conditionSchool = [[XXSchoolModel alloc]init];
        conditionSchool.searchKeyword = @"理工";
        conditionSchool.type = @"1";
        conditionSchool.city = @"北京";
        
        XXDataCenterRequestSuccessListBlock searchSchoolSccess = ^ (NSArray *resultList){
            
            XXSchoolModel *destSchool = [resultList objectAtIndex:0];
            DDLogVerbose(@"destSchool id -->%@",destSchool.schoolId);
            
            //测试注册
            XXUserModel *newUser = [[XXUserModel alloc]init];
            newUser.account = @"testuser35";
            newUser.password = @"123456";
            newUser.grade = @"一年级";
            newUser.headUrl = resultModel.link;
            newUser.schoolId = destSchool.schoolId;
            
            [[XXMainDataCenter shareCenter]requestRegistWithNewUser:newUser withSuccessRegist:^(XXUserModel *detailUser) {
                DDLogVerbose(@"regist user -->%@",detailUser.userId);
            } withFaildRegist:^(NSString *faildMsg) {
                [self alertMessage:faildMsg];
            }];
            
        };
        
        [[XXMainDataCenter shareCenter]requestSearchSchoolListWithDescription:conditionSchool WithSuccessSearch:^(NSArray *resultList) {
            
            //注册
            if (searchSchoolSccess) {
                searchSchoolSccess(resultList);
            }
            
        } withFaildSearch:^(NSString *faildMsg) {
            
            DDLogVerbose(@"search school faild -->%@",faildMsg);
            [self alertMessage:faildMsg];
            
        }];

        
    } withFaildBlock:^(NSString *faildMsg) {
                
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}

- (void)alertMessage:(NSString*)alertMsg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:alertMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"check", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    /*
    XXShareBaseCell *cell = (XXShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSharePostModel:[self.sourceArray objectAtIndex:indexPath.row]];*/
    
    XXUserInfoBaseCell *cell = (XXUserInfoBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXUserInfoBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setContentModel:[self.sourceArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    return [XXShareBaseCell heightWithSharePostModel:[self.sourceArray objectAtIndex:indexPath.row] forContentWidth:[XXSharePostStyle sharePostContentWidth]];*/
    return [XXUserInfoBaseCell heightWithContentModel:[self.sourceArray objectAtIndex:indexPath.row]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
