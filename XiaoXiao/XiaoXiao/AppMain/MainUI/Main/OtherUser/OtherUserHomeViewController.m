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
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        OtherHomeHeadCell *cell = (OtherHomeHeadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[OtherHomeHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setTeaseBlock:^{
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
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.f];
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
            [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
        }else if(indexPath.section==2&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
            [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
        }else{
            [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
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
        return 44;
    }
    if (indexPath.section==2) {
        
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
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

#pragma mark config select tease
- (void)teaseAction
{
    OtherUserTeaseSelectViewController *teaseVC = [[OtherUserTeaseSelectViewController alloc]init];
    teaseVC.title = @"表情选择";
    [self.navigationController pushViewController:teaseVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:teaseVC];

}

@end
