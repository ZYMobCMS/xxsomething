//
//  OtherUserHomeViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserHomeViewController.h"
#import "OtherHomeHeadCell.h"
#import "OtherHomeButtonCell.h"
#import "OtherHomeMutilTextCell.h"
#import "OtherUserTeaseSelectViewController.h"
#import "OtherUserShareListViewController.h"
#import "OtherUserFansListViewController.h"
#import "XXChatViewController.h"

@interface OtherUserHomeViewController ()

@end

@implementation OtherUserHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithContentUser:(XXUserModel *)aUser
{
    if (self = [super init]) {
        
        _currentUser = aUser;
        self.title = aUser.nickName;
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    //
    guideVCArray = [[NSMutableArray alloc]init];
    
    //my share
    NSArray *headArray = @[_currentUser];
    [guideVCArray addObject:headArray];
    
    NSDictionary *myShare = @{@"icon":@"my_home_photo.png",@"count":@"333",@"title":@"相册",@"vcClass":@"OtherUserShareListViewController"};
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    
    NSDictionary *IDSource = @{@"tag":@"校校号",@"content":@"333",@"isMutil":@"0",@"vcClass":@""};
    NSDictionary *signSource = @{@"tag":@"个性签名",@"content":@"333",@"isMutil":@"1",@"vcClass":@""};
    NSDictionary *collegeSource = @{@"tag":@"学校",@"content":@"333",@"isMutil":@"0",@"vcClass":@""};
    NSDictionary *grageSource = @{@"tag":@"年级",@"content":@"333",@"isMutil":@"0",@"vcClass":@""};
    NSDictionary *moneySource = @{@"tag":@"财富",@"content":@"333",@"isMutil":@"0",@"vcClass":@""};
    NSDictionary *fansSource = @{@"tag":@"他的粉丝",@"content":@"333",@"isMutil":@"0",@"vcClass":@"OtherUserFansListViewController"};

    NSArray *userArray = @[IDSource,signSource,collegeSource,grageSource,moneySource,fansSource];
    
    [guideVCArray addObject:shareArray];
    [guideVCArray addObject:userArray];

    
    CGFloat totalHeight = XXNavContentHeight-44;
    CGFloat totalWidth = self.view.frame.size.width;
    
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,totalWidth,totalHeight) style:UITableViewStylePlain];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    guideTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    guideTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:guideTable];
    
    _careButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _careButton.frame = CGRectMake(0,totalHeight-49,160,49);
    [_careButton redStyle];
    [_careButton setTitle:@"关心" forState:UIControlStateNormal];
    [_careButton addTarget:self action:@selector(careAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_careButton];
    
    _leaveMsgButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _leaveMsgButton.frame = CGRectMake(160,totalHeight-49,160,49);
    [_leaveMsgButton blueStyle];
    [_leaveMsgButton setTitle:@"留声" forState:UIControlStateNormal];
    [_leaveMsgButton addTarget:self action:@selector(leaveMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leaveMsgButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
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
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        OtherHomeHeadCell *cell = (OtherHomeHeadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[OtherHomeHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setTeaseActionBlock:^{
                [self teaseAction];
            }];
        }
        [cell setContentUser:_currentUser];
        
        return cell;
        
    }else if(indexPath.section == 1){
        
        static NSString *CellIdentifier = @"IconTagCellIdentifier";
        XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:47.f];
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        [cell setContentDict:item];
        return cell;

    }else{
       
        static NSString *CellIdentifier = @"IconTagCellIdentifier";
        OtherHomeMutilTextCell *cell = (OtherHomeMutilTextCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[OtherHomeMutilTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(indexPath.section==2&&indexPath.row==0){
            [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
        }else if(indexPath.section==2&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
            [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
        }else{
            [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
        }
        [cell setContentDict:[[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        
        return cell;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 280;
    }
    if (indexPath.section==1) {
        return 47.f;
    }
    if (indexPath.section==2) {
        
        if (indexPath.row == 0) {
            return 46;
        }
        if (indexPath.row == guideVCArray.count-1) {
            return 46.5;
        }
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        return [OtherHomeMutilTextCell heightForContentDict:item forWidth:tableView.frame.size.width];
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.f;
    }else{
        return 30.f;
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
    if (indexPath.section==1) {
        OtherUserShareListViewController *shareVC = [[OtherUserShareListViewController alloc]init];
        shareVC.otherUserId = _currentUser.userId;
        [self.navigationController pushViewController:shareVC animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1) {
        OtherUserFansListViewController *fansVC = [[OtherUserFansListViewController alloc]init];
        [self.navigationController pushViewController:fansVC animated:YES];
    }
}

#pragma mark config select tease
- (void)teaseAction
{
    OtherUserTeaseSelectViewController *teaseVC = [[OtherUserTeaseSelectViewController alloc]init];
    teaseVC.title = @"表情选择";
    teaseVC.selectUser = _currentUser.userId;
    [self.navigationController pushViewController:teaseVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:teaseVC];

}

- (void)careAction
{
    
}

- (void)leaveMessageAction
{
    XXChatViewController *chatViewController = [[XXChatViewController alloc]initWithChatUser:_currentUser];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

@end
