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
    
    _guideTitleArray = [[NSMutableArray alloc]init];
    //configArray
    NSMutableArray *firstSecction = [NSMutableArray array];
    NSDictionary *item0 = @{@"icon":@"cell_stroll.png",@"title":@"校内人"};
    NSDictionary *item1 = @{@"icon":@"cell_square.png",@"title":@"校广场"};
    [firstSecction addObject:item0];
    [firstSecction addObject:item1];
    
    //section 1
    NSMutableArray *secondSecction = [NSMutableArray array];
    NSDictionary *item2 = @{@"icon":@"cell_shoot.png",@"title":@"射孤独"};
    NSDictionary *item3 = @{@"icon":@"cell_nearby.png",@"title":@"附近得同学"};
    [secondSecction addObject:item2];
    [secondSecction addObject:item3];
    
    //
    [_guideTitleArray addObject:firstSecction];
    [_guideTitleArray addObject:secondSecction];
    
    //
    CGFloat totalHeight = self.view.frame.size.height-44;
    _guideTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,totalHeight) style:UITableViewStyleGrouped];
    _guideTableView.delegate = self;
    _guideTableView.dataSource = self;
    _guideTableView.backgroundColor = [UIColor whiteColor];
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
           cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withBottomMargin:4];
        }else{
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withBottomMargin:0];
        }
        UIView *normalBackView = [[UIView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
        normalBackView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = normalBackView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *item = [[_guideTitleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    UIImage *icon = [UIImage imageNamed:[item objectForKey:@"icon"]];
    NSString *title = [item objectForKey:@"title"];
    [cell setIconImage:icon withTitle:title];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
