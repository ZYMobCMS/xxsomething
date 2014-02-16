//
//  LatenceGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LatenceGuideViewController.h"
#import "XXLeftNavItem.h"
#import "XXSchoolSearchViewController.h"

@interface LatenceGuideViewController ()

@end

@implementation LatenceGuideViewController

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
    self.title = @"潜伏";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    
    CGFloat originY  = 20.f;
    
    XXLeftNavItem *currentSchool = [[XXLeftNavItem alloc]initWithFrame:CGRectMake(10,originY,300,44)];
    [self.view addSubview:currentSchool];
    [currentSchool setIconName:@"nav_location.png"];
    NSString *latenceSchool = [XXUserDataCenter currentLoginUser].schoolName;
    NSString *latenceSchoolString = [NSString stringWithFormat:@"当前校园:%@",latenceSchool];
    [currentSchool setTitle:latenceSchoolString];
    originY = currentSchool.frame.origin.y+currentSchool.frame.size.height+10;
    
    UIImage *normalBack = [[UIImage imageNamed:@"single_round_cell_normal.png"]makeStretchForSingleCornerCell];
    UIImage *selectBack = [[UIImage imageNamed:@"single_round_cell_selected.png"]makeStretchForSingleCornerCell];
    //
    UIButton *bestLatenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bestLatenceBtn.frame = CGRectMake(10,originY,300,44);
    [bestLatenceBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [bestLatenceBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
    [self.view addSubview:bestLatenceBtn];
    [bestLatenceBtn addTarget:self action:@selector(bestLatenceAction) forControlEvents:UIControlEventTouchUpInside];
    [bestLatenceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bestLatenceBtn setTitle:@"精准潜伏" forState:UIControlStateNormal];
    
    //
    originY = bestLatenceBtn.frame.origin.y+bestLatenceBtn.frame.size.height+5;
    UIButton *sameSchoollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sameSchoollBtn.frame = CGRectMake(10,originY,300,44);
    [sameSchoollBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [sameSchoollBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
    [self.view addSubview:sameSchoollBtn];
    [sameSchoollBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sameSchoollBtn setTitle:@"同城的校园" forState:UIControlStateNormal];
    
    //
    originY  = sameSchoollBtn.frame.origin.y+sameSchoollBtn.frame.size.height+5;
    UIButton *historySchoollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historySchoollBtn.frame = CGRectMake(10,originY,300,44);
    [historySchoollBtn setBackgroundImage:normalBack forState:UIControlStateNormal];
    [historySchoollBtn setBackgroundImage:selectBack forState:UIControlStateHighlighted];
    [self.view addSubview:historySchoollBtn];
    [historySchoollBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [historySchoollBtn setTitle:@"去过的校园" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bestLatenceAction
{
    XXSchoolSearchViewController *schoolChooseVC = [[XXSchoolSearchViewController alloc]init];
    schoolChooseVC.title = @"精准潜伏";
    [schoolChooseVC setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        
    }];
    [schoolChooseVC setNextStepAction:^(NSDictionary *resultDict) {
       
        XXSchoolModel *chooseSchool = [resultDict objectForKey:@"result"];
        
        [[XXMainDataCenter shareCenter]requestStrollSchoolWithConditionSchool:chooseSchool withSuccess:^(NSString *successMsg) {
            [SVProgressHUD showSuccessWithStatus:@"潜伏成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:@"潜伏失败"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } withNextStepTitle:@"潜伏"];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:schoolChooseVC];
    [self.navigationController pushViewController:schoolChooseVC animated:YES];
}

@end
