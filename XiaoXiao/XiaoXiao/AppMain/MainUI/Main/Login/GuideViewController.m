//
//  GuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "XXSchoolSearchViewController.h"
#import "SettingMyProfileGuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    
    CGFloat totalHeight = XXNavContentHeight;
    
    UIImageView *logoImgView = [[UIImageView alloc]init];
    logoImgView.frame = CGRectMake(130,100,55,55);
    logoImgView.image = [UIImage imageNamed:@"login_logo.png"];
    [self.view addSubview:logoImgView];
    
    UIImageView *logoNameImageView = [[UIImageView alloc]init];
    logoNameImageView.frame = CGRectMake(130,170,55,55);
    logoNameImageView.image = [UIImage imageNamed:@"login_logo_name.png"];
    [self.view addSubview:logoNameImageView];
    
    UIImageView *loginIntroduceImageView = [[UIImageView alloc]init];
    loginIntroduceImageView.frame = CGRectMake(70,235,150,20);
    loginIntroduceImageView.image = [UIImage imageNamed:@"login_introduce.png"];
    [self.view addSubview:loginIntroduceImageView];
    
    //
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(6,totalHeight-80-20,148,40);
    [loginBtn setTitle:@"登陆校校" forState:UIControlStateNormal];
    [loginBtn defaultStyle];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(164,totalHeight-80-20,148,40);
    [registBtn setTitle:@"注册校校" forState:UIControlStateNormal];
    [registBtn defaultStyle];
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    //qq login
    XXCustomButton *qqloginBtn = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    qqloginBtn.frame = CGRectMake(6,totalHeight-40-10,148,40);
    [qqloginBtn defaultStyle];
    [qqloginBtn setNormalIconImage:@"login_QQ.png" withSelectedImage:@"login_QQ.png" withFrame:CGRectMake(30,10,20,20)];
    [qqloginBtn setTitle:@"QQ登陆" withFrame:CGRectMake(65,5,80,30)];
    qqloginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [qqloginBtn addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqloginBtn];
    
    //weibo login
    XXCustomButton *weibologinBtn = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    weibologinBtn.frame = CGRectMake(164,totalHeight-40-10,148,40);
    [weibologinBtn defaultStyle];
    [weibologinBtn setNormalIconImage:@"login_WeiBo.png" withSelectedImage:@"login_WeiBo.png" withFrame:CGRectMake(30,10,20,20)];
    [weibologinBtn setTitle:@"微博登陆" withFrame:CGRectMake(65,5,80,30)];
    weibologinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [weibologinBtn addTarget:self action:@selector(weiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weibologinBtn];
}

- (void)setLoginGuideFinish:(LoginGuideFinishLoginBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)loginAction
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [loginVC setLoginResultBlock:^(BOOL resultState) {
        if (resultState) {
            
            //检查是否完善资料了
//            BOOL isUserInfoWellDone = [XXUserDataCenter checkLoginUserInfoIsWellDone];
//            if (!isUserInfoWellDone) {
//                SettingMyProfileGuideViewController *updateVC = [[SettingMyProfileGuideViewController alloc]init];
//                [updateVC setFinishBlock:^(BOOL resultState) {
//                    if (_finishBlock) {
//                        _finishBlock(resultState);
//                    }
//                }];
//                [self.navigationController pushViewController:updateVC animated:YES];
//            }else{
                if (_finishBlock) {
                    _finishBlock(resultState);
                }
//            }
        }
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}
- (void)registAction
{
    XXUserModel *newUser = [[XXUserModel alloc]init];
    
    //school choose
    XXSchoolSearchViewController *chooseSchoolVC = [[XXSchoolSearchViewController alloc]init];
    [self.navigationController pushViewController:chooseSchoolVC animated:YES];
        
    //can registAction
    XXDataCenterUploadFileSuccessBlock successUpload = ^ (XXAttachmentModel *resultModel){
        
        RegistViewController *registVC = [[RegistViewController alloc]init];
        [XXCommonUitil setCommonNavigationNextStepItemForViewController:registVC withNextStepAction:^{
            newUser.account = registVC.formView.accountTextField.text;
            newUser.password = registVC.formView.passwordTextField.text;
            newUser.nickName = @"vincent";
            newUser.constellation = @"射手座";
            newUser.signature = @"胜利闭幕";
            [[XXMainDataCenter shareCenter]requestRegistWithNewUser:newUser withSuccessRegist:^(XXUserModel *detailUser) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } withFaildRegist:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
        } withTitle:@"完成"];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:registVC withBackStepAction:^{
            [self.navigationController popToViewController:chooseSchoolVC animated:YES];
        }];
        [self.navigationController pushViewController:registVC animated:YES];
        
    };
    
    //upload head image
    void (^UploadChooseImageBlock) (UIImage *aImage) = ^ (UIImage *aImage){
        NSData *imageData = UIImageJPEGRepresentation(aImage,1.0);
        [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"head.png" withUploadProgressBlock:^(CGFloat progressValue) {
            [SVProgressHUD showProgress:progressValue status:@"正在上传头像..."];
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            newUser.headUrl = resultModel.link;
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            //push regist
            successUpload(resultModel);
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
        }];
    };
    
    //finish chooseImage
    XXCommonNavigationNextStepBlock finishChooseImage = ^ (NSDictionary *resultDict){
        UIImage *resultImage = [resultDict objectForKey:@"result"];
        UploadChooseImageBlock(resultImage);
    };
    
    //photo choose
    XXPhotoChooseViewController *chooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:1 withFinishBlock:^(NSArray *resultImages) {
    }];
    chooseVC.needCrop = YES;
    chooseVC.needFilter = YES;
    chooseVC.singleImageCropHeight = 230;
    chooseVC.isSetHeadImage = YES;
    [chooseVC setNextStepAction:^(NSDictionary *resultDict) {
        finishChooseImage(resultDict);
    }];
    
    //grade choose
    XXGradeChooseViewController *gradeChooseVC = [[XXGradeChooseViewController alloc]init];
    [gradeChooseVC setNextStepAction:^(NSDictionary *resultDict) {
        DDLogVerbose(@"grade choose will push photo choose :%@!",chooseVC);
        [self.navigationController pushViewController:chooseVC animated:YES];
    }];
    [gradeChooseVC setFinishBlock:^(NSString *resultString) {
        newUser.grade = resultString;
    }];
    [chooseSchoolVC setNextStepAction:^(NSDictionary *resultDict) {
        [self.navigationController pushViewController:gradeChooseVC animated:YES];
    }];
    [chooseSchoolVC setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        newUser.schoolId = chooseSchool.schoolId;
    }];
    
}
- (void)qqLoginAction
{
    
}
- (void)weiboLoginAction
{
    
}

@end

