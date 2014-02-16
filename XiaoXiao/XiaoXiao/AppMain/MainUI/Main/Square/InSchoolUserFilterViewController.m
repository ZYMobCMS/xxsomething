//
//  InSchoolUserFilterViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "InSchoolUserFilterViewController.h"
#import "MBSegmentControl.h"
@interface InSchoolUserFilterViewController ()<UITableViewDataSource,UITableViewDelegate,MBSegmentControlDelegate>

@end

@implementation InSchoolUserFilterViewController

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
    
    [self loadViewAbout];
}
- (void)loadViewAbout
{
    
    
    //男女选择
    
    MBSegmentControl *segBoyOrGire = [[MBSegmentControl alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    [segBoyOrGire setItemNameArray:@[@"不限",@"男",@"女"]];
    segBoyOrGire.selectIndex =0;
    [segBoyOrGire setDelegate:self];
    [self.view addSubview:segBoyOrGire];
    
    
    MBSegmentControl *segKnow = [[MBSegmentControl alloc] initWithFrame:CGRectMake(10, 48, 300, 30)];
    [segKnow setItemNameArray:@[@"知名度排名",@"校财富排名"]];
    segKnow.selectIndex =0;
    [segKnow setDelegate:self];
    [self.view addSubview:segKnow];
    
    CGFloat originY = IS_IOS_7? 0:10;

    UITableView * tableView  =[[UITableView alloc]initWithFrame:CGRectMake(10, 100+originY, 300, 240) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator  = NO;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    [self.view addSubview:tableView];
    
    
    //知名度 选择
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, tableView.frame.origin.y+tableView.frame.size.height, 150, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn defaultStyle];
    [cancelBtn addTarget:self action:@selector(makeSureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(155, tableView.frame.origin.y+tableView.frame.size.height, 150, 40);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn defaultStyle];
    [sureBtn addTarget:self action:@selector(makeSureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}
//男女选择
- (void)makeSureBtnPressed:(UIButton *)btn
{
    
}


#pragma mark =======UITableView delegate and Datasoure Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellStr = @"tableViewcell";
    UITableViewCell * cell  =[tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UILabel *cellLabe =[[UILabel alloc]initWithFrame:cell.frame];
        cellLabe.backgroundColor = [UIColor clearColor];
        cellLabe.tag = 1000;
        cellLabe.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:cellLabe];
    }
    UILabel *cellLabel =(UILabel *)[cell.contentView viewWithTag:1000];
    switch (indexPath.row) {
        case 0:
        {
            cellLabel.text = @"不限";
        }
            break;
        case 1:
        {
            cellLabel.text = @"一年级";
            
        }
            break;
        case 2:
        {
            cellLabel.text = @"二年级";

        }
            break;
        case 3:
        {
            cellLabel.text = @"三年级";

        }
            break;
        case 4:
        {
            cellLabel.text = @"四年级";

        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)MBSegment:(MBSegmentControl *)segment selectAtIndex:(NSInteger)index
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
