//
//  MyShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MyShareListViewController.h"
#import "XXMyShareBaseCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MyShareListViewController ()

@end

@implementation MyShareListViewController

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
    [_refreshControl beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXMyShareBaseCell  *cell = (XXMyShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXMyShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDeleteShareBlock:^(XXMyShareBaseCell *tapOnCell) {
            NSIndexPath *deletePath = [tableView indexPathForCell:tapOnCell];
            [self deleteActionAtIndexPath:deletePath];
        }];
        [cell setTapOnThumbImageBlock:^(NSURL *imageUrl, UIImageView *originImageView, NSArray *allImages, NSInteger currentIndex) {
            int count = allImages.count;
            // 1.封装图片数据
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
            for (int i = 0; i<count; i++) {
                // 替换为中等尺寸图片
                NSString *url = [allImages objectAtIndex:i];
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:url]; // 图片路径
                originImageView.frame = [self.view convertRect:originImageView.frame fromView:self.view];
                photo.srcImageView = originImageView; // 来源于哪个UIImageView
                [photos addObject:photo];
            }
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = currentIndex; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
        }];
    }
    [cell setSharePostModel:[self.sharePostModelArray objectAtIndex:indexPath.row]];
    
    return cell;

}

#pragma mark - deleteAction
- (void)deleteActionAtIndexPath:(NSIndexPath*)indexPath
{
    XXSharePostModel *deletePost = [self.sharePostModelArray objectAtIndex:indexPath.row];
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.postId = deletePost.postId;
    DDLogVerbose(@"deletePostId :%@",deletePost.postId);
    _hud.labelText = @"正在删除...";
    [_hud show:YES];
    [[XXMainDataCenter shareCenter]requestDeletePostWithCondition:condition withSuccess:^(NSString *successMsg) {
       
        [_hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        
        [self.sharePostModelArray removeObjectAtIndex:indexPath.row];
        [self.sharePostRowHeightArray removeObjectAtIndex:indexPath.row];
        
        [_shareListTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
    } withFaild:^(NSString *faildMsg) {
        [_hud hide:YES];
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}

- (void)requestShareListNow
{
    XXConditionModel *condtion = [[XXConditionModel alloc]init];
    condtion.pageIndex = [NSString stringWithFormat:@"%d",_currentPageIndex];
    condtion.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    condtion.userId = [XXUserDataCenter currentLoginUser].userId;
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
            CGFloat heightForModel = [XXShareBaseCell heightWithSharePostModel:postModel forContentWidth:[XXSharePostStyle sharePostContentWidth]];
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
