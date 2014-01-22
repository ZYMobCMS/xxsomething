//
//  SettingMyProfileGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "SettingMyProfileGuideViewController.h"
#import "XXBaseTagLabelCell.h"

@interface SettingMyProfileGuideViewController ()

@end

@implementation SettingMyProfileGuideViewController

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
    self.title = @"完善资料";
    
    _titleArray = [[NSMutableArray alloc]init];
    NSDictionary *item0 = @{@"title":@"名字"};
    NSDictionary *item1 = @{@"title":@"性别"};
    NSDictionary *item2 = @{@"title":@"星座"};
    NSDictionary *item3 = nil;
    XXUserModel *currentUser = [XXUserDataCenter currentLoginUser];
    if ([currentUser.type intValue]==XXUserHighSchool||[currentUser.type intValue]==XXUserMiddleSchool) {
        item3 =  @{@"title":@"学级"};
    }else{
        item3 = @{@"title":@"院系"};
    }
    NSDictionary *item4 = @{@"title":@"年级"};

    [_titleArray addObject:item0];
    [_titleArray addObject:item1];
    [_titleArray addObject:item2];
    [_titleArray addObject:item3];
    [_titleArray addObject:item4];
    
    CGFloat totalHeight = self.view.frame.size.height-44;
    CGFloat totalWidth =  self.view.frame.size.width;
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,0,totalWidth,totalHeight);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _updateModel = [[XXUserModel alloc]init];
    
    //更新操作
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        
        XXUserModel *currentUser = [XXUserDataCenter currentLoginUser];
        currentUser.nickName = _updateModel.nickName;
        currentUser.grade = _updateModel.grade;
        currentUser.college = _updateModel.college;
        currentUser.constellation = _updateModel.constellation;
        currentUser.sex = _updateModel.sex;
    
        [SVProgressHUD show];
        [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:currentUser withSuccess:^(NSString *successMsg) {
            [SVProgressHUD showSuccessWithStatus:successMsg];
            if (_finishBlock) {
                _finishBlock(YES);
            }
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
            if (_finishBlock) {
                _finishBlock(NO);
            }
        }];
        
    } withTitle:@"更新"];
    
}
- (void)setFinishBlock:(SettingMyProfileGuideViewControllerFinishBlock)finishBlock
{
    _finishBlock = [finishBlock copy];
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
    return _titleArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXBaseTagLabelCell *cell = (XXBaseTagLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXBaseTagLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryView.hidden = NO;
    }
    NSDictionary *item = [_titleArray objectAtIndex:indexPath.row];
    [cell setTagName:[item objectForKey:@"title"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXBaseTagLabelCell *selectCell = (XXBaseTagLabelCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *baseRadioConfigDict = @{@"normalBack":@"",@"selectBack":@"blue_right_selected.png",@"normalColor":[UIColor blackColor],@"selectColor":[XXCommonStyle xxThemeBlueColor]};
    switch (indexPath.row) {
        case 0:
        {
            XXEditInputViewController *nameEditVC = [[XXEditInputViewController alloc]initWithFinishAction:^(NSString *resultText) {
                _updateModel.nickName = resultText;
                [selectCell setContentText:resultText];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:nameEditVC withBackStepAction:^{
                _updateModel.nickName = [nameEditVC resultText];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:nameEditVC animated:YES];
            
        }
            break;
        case 1:
        {
            NSMutableDictionary *sexBoy = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
            [sexBoy setObject:@"男" forKey:@"title"];
            [sexBoy setObject:@"0" forKey:@"value"];
            NSMutableDictionary *sexGirl= [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
            [sexGirl setObject:@"女" forKey:@"title"];
            [sexGirl setObject:@"1" forKey:@"value"];
            NSArray *configArray = @[sexBoy,sexGirl];
            XXRadioChooseViewController *sexChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                _updateModel.sex = resultString;
                NSString *sexString = [_updateModel.sex boolValue]? @"女":@"男";
                [selectCell setContentText:sexString];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:sexChooseVC withBackStepAction:^{
                _updateModel.sex = [sexChooseVC finialChooseString];
                NSString *sexString = [_updateModel.sex boolValue]? @"女":@"男";
                [selectCell setContentText:sexString];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:sexChooseVC animated:YES];
        }
            break;
        case 2:
        {
            NSArray *starsArray = @[@"射手座",@"处女座",@"天秤",@"摩羯座",@"金牛座",@"水瓶座",@"天蝎座",@"狮子座",@"银座",@"金座",@"铂金座",@"尊贵座",@"抢座"];
            NSMutableArray *configArray = [NSMutableArray array];
            [starsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
                [item setObject:obj forKey:@"title"];
                [item setObject:obj forKey:@"value"];
                [configArray addObject:item];
            }];
            XXRadioChooseViewController *starChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumThree withFinishBlock:^(NSString *resultString) {
                _updateModel.constellation = resultString;
                [selectCell setContentText:_updateModel.constellation];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:starChooseVC withBackStepAction:^{
                _updateModel.constellation = [starChooseVC finialChooseString];
                [selectCell setContentText:_updateModel.constellation];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:starChooseVC animated:YES];
        }
            break;
        case 3:
        {
            XXUserModel *currentUser = [XXUserDataCenter currentLoginUser];
            if ([currentUser.type intValue]==XXUserHighSchool||[currentUser.type intValue]==XXUserMiddleSchool) {
                
                NSArray *gradesArray = @[@"高中",@"初中"];
                NSMutableArray *configArray = [NSMutableArray array];
                [gradesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
                    [item setObject:obj forKey:@"title"];
                    [item setObject:obj forKey:@"value"];
                    [configArray addObject:item];
                }];
                
                XXRadioChooseViewController *gradeChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                    _updateModel.schoolRoll = resultString;
                    [selectCell setContentText:_updateModel.schoolRoll];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:gradeChooseVC withBackStepAction:^{
                    _updateModel.schoolRoll = [gradeChooseVC finialChooseString];
                    [selectCell setContentText:_updateModel.schoolRoll];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self.navigationController pushViewController:gradeChooseVC animated:YES];
                
            }else{
                XXEditInputViewController *CollegeEditVC = [[XXEditInputViewController alloc]initWithFinishAction:^(NSString *resultText) {
                    _updateModel.college = resultText;
                    [selectCell setContentText:resultText];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:CollegeEditVC withBackStepAction:^{
                    _updateModel.college = [CollegeEditVC resultText];
                    [selectCell setContentText:_updateModel.college];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [self.navigationController pushViewController:CollegeEditVC animated:YES];
            }
        }
            break;
        case 4:
        {
            NSArray *gradesArray = @[@"一年级",@"二年级",@"三年级",@"四年级"];
            NSMutableArray *configArray = [NSMutableArray array];
            [gradesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:baseRadioConfigDict];
                [item setObject:obj forKey:@"title"];
                [item setObject:obj forKey:@"value"];
                [configArray addObject:item];
            }];
            XXRadioChooseViewController *gradeChooseVC = [[XXRadioChooseViewController alloc]initWithConfigArray:configArray withRadioChooseType:XXRadioChooseTypeClonumTwo withFinishBlock:^(NSString *resultString) {
                _updateModel.grade = resultString;
                [selectCell setContentText:_updateModel.grade];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [XXCommonUitil setCommonNavigationReturnItemForViewController:gradeChooseVC withBackStepAction:^{
                _updateModel.grade = [gradeChooseVC finialChooseString];
                [selectCell setContentText:_updateModel.grade];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:gradeChooseVC animated:YES];

        }
            break;
        default:
            break;
    }
}


@end
