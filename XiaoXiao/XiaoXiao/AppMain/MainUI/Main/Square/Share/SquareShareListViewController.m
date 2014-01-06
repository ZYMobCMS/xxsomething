//
//  SquareShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SquareShareListViewController.h"
#import "SharePostGuideViewController.h"

@interface SquareShareListViewController ()

@end

@implementation SquareShareListViewController

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
    self.title = @"校说吧";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    _textShareButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(0,0,106.6,40)];
    _textShareButton.customTitleLabel.text = @"文字说说";
    [_textShareButton addTarget:self action:@selector(tapOnPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textShareButton];
    
    _aduioShareBtton = [[XXCustomButton alloc]initWithFrame:CGRectMake(107,0,106.6,40)];
    _aduioShareBtton.customTitleLabel.text = @"语音说说";
    [_aduioShareBtton addTarget:self action:@selector(tapOnPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aduioShareBtton];
    
    _imageShareButton = [[XXCustomButton alloc]initWithFrame:CGRectMake(214,0,106.6,40)];
    _imageShareButton.customTitleLabel.text = @"相册说说";
    [_imageShareButton addTarget:self action:@selector(tapOnPostButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imageShareButton];
    
    CGRect tableViewOldFrame = _shareListTable.frame;
    _shareListTable.frame = CGRectMake(tableViewOldFrame.origin.x,tableViewOldFrame.origin.y+40,tableViewOldFrame.size.width,tableViewOldFrame.size.height-40);
    //start loading
    [_refreshControl beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnPostButton:(UIButton*)sender
{
    SharePostType postTye;
    if (sender == _textShareButton) {
        postTye = SharePostTypeText;
    }
    if (sender == _aduioShareBtton) {
        postTye = SharePostTypeAudio;
    }
    if (sender == _imageShareButton) {
        postTye = SharePostTypeImage;
    }
    
    SharePostGuideViewController *postGuideVC = [[SharePostGuideViewController alloc]initWithSharePostType:postTye];
    [self.navigationController pushViewController:postGuideVC animated:YES];
}

- (void)requestShareListNow
{
    XXConditionModel *condtion = [[XXConditionModel alloc]init];
    condtion.pageIndex = [NSString stringWithFormat:@"%d",_currentPageIndex];
    condtion.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    condtion.schoolId = [XXUserDataCenter currentLoginUser].schoolId;
    
    [[XXMainDataCenter shareCenter]requestSharePostListWithCondition:condtion withSuccess:^(NSArray *resultList) {
        
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
        }
        if (_isRefresh) {
            [self.sharePostModelArray removeAllObjects];
            [self.sharePostRowHeightArray removeAllObjects];
            _isRefresh = NO;
        }
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            XXSharePostModel *postModel = (XXSharePostModel*)obj;
            CGFloat heightForModel = [XXShareBaseCell heightForAttributedText:postModel.attributedContent forWidth:_shareListTable.frame.size.width];
            [self.sharePostRowHeightArray addObject:[NSNumber numberWithFloat:heightForModel]];
            
        }];
        [self.sharePostModelArray addObjectsFromArray:resultList];
        [_refreshControl endRefreshing];
        [_shareListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _isRefresh = YES;
    _hiddenLoadMore = NO;
    [self requestShareListNow];
}
- (void)loadMoreResult
{
    _currentPageIndex ++;
    [self requestShareListNow];
}

@end
