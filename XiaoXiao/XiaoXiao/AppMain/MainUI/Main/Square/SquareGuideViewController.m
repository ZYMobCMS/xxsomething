//
//  SquareGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SquareGuideViewController.h"
#import "XXBaseIconLabelCell.h"
#import "InSchoolSearchUserListViewController.h"
#import "NearByUserListViewController.h"
#import "SquareShareListViewController.h"

@interface SquareGuideViewController ()

@end

@implementation SquareGuideViewController

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
    self.view.backgroundColor=[XXCommonStyle xxThemeBackgroundColor];
    
    _guideTitleArray = [[NSMutableArray alloc]init];
    //configArray
    NSMutableArray *firstSecction = [NSMutableArray array];
    NSDictionary *item0 = @{@"icon":@"cell_stroll.png",@"title":@"校内人",@"count":@"",@"class":@"InSchoolSearchUserListViewController"};
    NSDictionary *item1 = @{@"icon":@"cell_square.png",@"title":@"校说吧",@"count":@"",@"class":@"SquareShareListViewController"};
    [firstSecction addObject:item0];
    [firstSecction addObject:item1];
    
    //section 1
    NSMutableArray *secondSecction = [NSMutableArray array];
    NSDictionary *item2 = @{@"icon":@"cell_shoot.png",@"title":@"射孤独",@"count":@"",@"class":@""};
    NSDictionary *item3 = @{@"icon":@"cell_nearby.png",@"title":@"附近得同学",@"count":@"",@"class":@"NearByUserListViewController"};
    [secondSecction addObject:item2];
    [secondSecction addObject:item3];
    
    //
    [_guideTitleArray addObject:firstSecction];
    [_guideTitleArray addObject:secondSecction];
    
    //
    CGFloat totalHeight = self.view.frame.size.height-44;
    _guideTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight) style:UITableViewStylePlain];
    _guideTableView.delegate = self;
    _guideTableView.dataSource = self;
    _guideTableView.backgroundColor = [UIColor clearColor];
    _guideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_guideTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _guideTitleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_guideTitleArray objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        if (indexPath.section==1) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryView.hidden = NO;
        }else{
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryView.hidden = NO;
        }
        UIView *normalBackView = [[UIView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
        normalBackView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = normalBackView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==1) {
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:10.f withCellHeight:55.f withCornerRadius:21.0f];
    }else if(indexPath.section==0&&indexPath.row==0){
        [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
    }else if(indexPath.section==0&&indexPath.row==[[_guideTitleArray objectAtIndex:indexPath.section]count]-1){
        [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
    }else{
        [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:44.f withCornerRadius:5.0f];
    }
    
    NSDictionary *item = [[_guideTitleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell setContentDict:item];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44.f;
    }else{
        return 55.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [[_guideTitleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *className = [item objectForKey:@"class"];
    UIViewController *selectVC = [[NSClassFromString(className) alloc]init];
    [self.navigationController pushViewController:selectVC animated:YES];
}

@end
