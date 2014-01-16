//
//  OtherUserHomeViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserHomeViewController.h"
#import "OtherHomeHeadCell.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //
    guideVCArray = [[NSMutableArray alloc]init];
    
    //my share
    NSDictionary *myShare = @{@"icon":@"my_home_photo.png",@"count":@"333",@"title":@"相册",@"vcClass":@"MyShareListViewController"};
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    NSDictionary *myCare = @{@"icon":@"my_home_care.png",@"count":@"333",@"title":@"关心",@"vcClass":@"MyCareUserListViewController"};
    NSDictionary *myFans = @{@"icon":@"my_home_fans.png",@"count":@"333",@"title":@"校粉",@"vcClass":@"MyFansUserListViewController"};
    NSDictionary *myPee = @{@"icon":@"my_home_peer.png",@"count":@"333",@"title":@"窥客",@"vcClass":@"MyPeepUserListViewController"};
    NSArray *userArray = @[myCare,myFans,myPee];
    
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
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section==0) {
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.f];
    }else if(indexPath.section==1&&indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
    }else if(indexPath.section==1&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
    }else{
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
    }
    NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell setContentDict:item];
    
    return cell;
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


@end
