//
//  SquareGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SquareGuideViewController.h"
#import "XXBaseIconLabelCell.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _guideTitleArray = [[NSMutableArray alloc]init];
    //configArray
    NSMutableArray *firstSecction = [NSMutableArray array];
    NSDictionary *item0 = @{@"icon":@"cell_stroll.png",@"title",@"校内人"};
    NSDictionary *item1 = @{@"icon":@"cell_square.png",@"校广场"};
    
    //
    CGFloat totalHeight = self.view.frame.size.height-44;
    _guideTableView = [[UITableView alloc]init];
    _guideTableView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _guideTableView.delegate = self;
    _guideTableView.dataSource = self;
    [self.view addSubview:_guideTableView];
    
}


#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _guideTitleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        if (indexPath.section==1) {
           cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withBottomMargin:8]; 
        }else{
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withBottomMargin:0];
        }
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
