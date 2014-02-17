//
//  MyHomeGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MyHomeGuideViewController.h"
#import "XXPhotoChooseViewController.h"
#import "SettingGuideViewController.h"


@interface MyHomeGuideViewController ()

@end

@implementation MyHomeGuideViewController

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

    //
    guideVCArray = [[NSMutableArray alloc]init];
    
    //my info
    NSDictionary *myInfo = @{@"icon":@""};
    
    //my share
    NSDictionary *myShare = @{@"icon":@"my_home_photo.png",@"count":@"333",@"title":@"相册",@"vcClass":@"MyShareListViewController"};
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    NSDictionary *myCare = @{@"icon":@"my_home_care.png",@"count":@"333",@"title":@"关心",@"vcClass":@"MyCareUserListViewController"};
    NSDictionary *myFans = @{@"icon":@"my_home_fans.png",@"count":@"333",@"title":@"校粉",@"vcClass":@"MyFansUserListViewController"};
    NSDictionary *myPee = @{@"icon":@"my_home_peer.png",@"count":@"333",@"title":@"瞄客",@"vcClass":@"MyPeepUserListViewController"};
    NSArray *userArray = @[myCare,myFans,myPee];

    [guideVCArray addObject:myInfo];
    [guideVCArray addObject:shareArray];
    [guideVCArray addObject:userArray];
    
    CGFloat originY = IS_IOS_7? 20:0;
    CGFloat totalHeight = XXNavContentHeight;
    CGFloat totalWidth = self.view.frame.size.width;
    
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,originY,totalWidth,totalHeight) style:UITableViewStylePlain];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    guideTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    guideTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:guideTable];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return guideVCArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[guideVCArray objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        static NSString *CellIdentifier = @"InfoIdentifier";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //my home user head
            MyHomeUserHeadView *headView = [[MyHomeUserHeadView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width,309)];
            headView.layer.shadowOffset = CGSizeMake(0,0.3);
            headView.layer.shadowColor = [UIColor blackColor].CGColor;
            headView.layer.shadowOpacity = 0.1f;
            [cell.contentView addSubview:headView];
            headView.tag = 1122;
            
            //theme back change
            _hud.labelText = @"正在更新...";
            WeakObj(_hud) weakHud = _hud;
            WeakObj(headView) weakUserHeadView = headView;
            WeakObj(self) weakSelf = self;
            
            [headView setDidTapThemeBackBlock:^{
                
                XXPhotoChooseViewController *photoChooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:1 withFinishBlock:^(NSArray *resultImages) {
                    
                    [weakHud show:YES];
                    NSData *imageData = UIImageJPEGRepresentation([resultImages objectAtIndex:0],kCGInterpolationDefault);
                    [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"themeBack.png" withUploadProgressBlock:^(CGFloat progressValue) {
                        [SVProgressHUD showProgress:progressValue status:@"正在上传背景图片..."];
                    } withSuccessBlock:^(XXAttachmentModel *resultModel) {
                        
                        //更新壁纸
                        XXUserModel *updateUser = [[XXUserModel alloc]init];
                        updateUser.userId = [XXUserDataCenter currentLoginUser].userId;
                        updateUser.bgImage = resultModel.link;
                        
                        [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:updateUser withSuccess:^(NSString *successMsg) {
                            
                            [weakHud hide:YES];
                            [weakUserHeadView updateThemeBack:updateUser.bgImage];;
                            
                            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:weakSelf.navigationController.viewControllers.count-2] animated:YES];
                            [SVProgressHUD showSuccessWithStatus:successMsg];
                            
                        } withFaild:^(NSString *faildMsg) {
                            
                            [weakHud hide:YES];
                            [SVProgressHUD showErrorWithStatus:faildMsg];
                        }];
                        
                        
                    } withFaildBlock:^(NSString *faildMsg) {
                        [weakHud hide:YES];
                        [SVProgressHUD showErrorWithStatus:faildMsg];
                        
                    }];
                    
                }];
                photoChooseVC.needCrop = YES;
                [weakSelf.navigationController pushViewController:photoChooseVC animated:YES];
                
            }];
            [headView tapOnSettingAddTarget:self withSelector:@selector(tapOnSettingAction)];

        }
        MyHomeUserHeadView *headView = (MyHomeUserHeadView*)[cell.contentView viewWithTag:1122];
        [headView setContentUser:[XXUserDataCenter currentLoginUser]];
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"CellIdentifier";
        XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.section==1) {
            [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:47.f];
            
            CGRect iconFrame = cell.iconImageView.frame;
            cell.iconImageView.frame = CGRectMake(30,iconFrame.origin.y+2,iconFrame.size.width,iconFrame.size.height);
            
            cell.tagLabel.font = [UIFont systemFontOfSize:17.5];
            CGRect tagFrame = cell.tagLabel.frame;
            cell.tagLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+16,tagFrame.origin.y+2,tagFrame.size.width,tagFrame.size.height);
            
        }else if(indexPath.section==2){
            
            if (indexPath.row==0) {
                [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
                
            }else if(indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
                [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
                
            }else{
                [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
                
            }
            
            CGRect iconFrame = cell.iconImageView.frame;
            cell.iconImageView.frame = CGRectMake(30,iconFrame.origin.y,iconFrame.size.width,iconFrame.size.height);
            
            cell.tagLabel.font = [UIFont systemFontOfSize:17.5];
            CGRect tagFrame = cell.tagLabel.frame;
            cell.tagLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+16,tagFrame.origin.y,tagFrame.size.width,tagFrame.size.height);
            
        }
        
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        [cell setContentDict:item];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.f;
    }else if(section==1){
        return 15.f;
    }else if(section==2){
        return 15.f;
    }else{
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 309;
    }else if(indexPath.section==2){
        
        if (indexPath.row == [[guideVCArray objectAtIndex:indexPath.section]count]-1) {
            return 46.5;
        }else if(indexPath.row == 0){
            return 46;
        }else{
            return 45.5;
        }
    }else if(indexPath.section == 1){
        return 47.f;
    }else{
        return 44.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 20.f;
    }else{
        return 0.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0) {
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        NSString *VCName = [item objectForKey:@"vcClass"];
        Class newVC = NSClassFromString(VCName);
        
        UIViewController *pushVC = [[newVC alloc]init];
        pushVC.title = [item objectForKey:@"title"];
        [self.navigationController pushViewController:pushVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:pushVC];

    }
}

#pragma mark - setting 
- (void)tapOnSettingAction
{
    SettingGuideViewController *settingVC = [[SettingGuideViewController alloc]init];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:settingVC];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
