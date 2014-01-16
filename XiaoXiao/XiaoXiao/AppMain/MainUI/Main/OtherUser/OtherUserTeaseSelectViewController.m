//
//  OtherUserTeaseSelectViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserTeaseSelectViewController.h"
#import "OtherTeaseCell.h"

@interface OtherUserTeaseSelectViewController ()

@end

@implementation OtherUserTeaseSelectViewController

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
    
    _teaseImagesArray = [[NSMutableArray alloc]init];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i=1; i<52;i++) {
        
        [itemArray addObject:[NSString stringWithFormat:@"%d.gif",i]];
        if (itemArray.count==3) {
            NSMutableArray *rowData = [NSMutableArray array];
            [rowData addObjectsFromArray:itemArray];
            [_teaseImagesArray addObject:rowData];
            [itemArray removeAllObjects];
        }
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _teaseImagesArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    OtherTeaseCell *cell = (OtherTeaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[OtherTeaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell setTeaseSelectBlock:^(OtherTeaseCell *tapCell, NSInteger selectIndex) {
            NSIndexPath *selectPath = [tableView indexPathForCell:tapCell];
            [self teaseSelectDidSelectTease:selectPath.row withSelectIndex:selectIndex];
        }];
    }
    [cell setTeaseImages:[_teaseImagesArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

//config select tease
- (void)teaseSelectDidSelectTease:(NSInteger)rowIndex withSelectIndex:(NSInteger)selectIndex
{
    
}

@end
