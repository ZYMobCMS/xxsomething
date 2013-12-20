//
//  UITestViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "UITestViewController.h"
#import "XXShareBaseCell.h"

@interface UITestViewController ()

@end

@implementation UITestViewController

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
    self.sourceArray = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [XXSimpleAudio playRefreshEffect];
    });
    
    NSString *commonContent =@"美女,一般解释为容貌美丽的女子。营养专家提出的营养学上的美女定义，是从脸蛋比例、体质指数、健康指标和发育程度等方面进行要求，更倾重于一种健康的标准。古代关于美女的形容词和诗词歌赋众多[亲亲]，形成了丰富的美学资料［可怜］。";
    NSString *audio = @"http://pan.baidu.com/share/link?shareid=434720&uk=3157602687";
    NSString *image0 = @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=15e98ef2a586c91708035539fd0571cf/0824ab18972bd407b5d9b9f779899e510fb30999.jpg";
    NSString *image1 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=9f85cd29b27eca8012053ee7a51b96dd/91ef76c6a7efce1bb082a3c0ad51f3deb48f650a.jpg";
    NSString *image2 = @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=79cf7b17d62a283443a6310b6f8dc8ea/adaf2edda3cc7cd994865fd33b01213fb80e9114.jpg";
    NSString *image3 = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=44c95f085e6034a829e2bf81ff2b4854/71cf3bc79f3df8dc0cec5998cf11728b461028e2.jpg";

    CGFloat styleContent = [XXSharePostStyle sharePostContentWidth];
    
    //image audio
    XXSharePostModel *modelOneImage0 = [[XXSharePostModel alloc]init];
    modelOneImage0.postType = XXSharePostTypeImageAudio0;
    modelOneImage0.postImages = @"";
    modelOneImage0.postContent = @"";
    modelOneImage0.postAudio = audio;
    modelOneImage0.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage0 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage0];
//    DDLogVerbose(@"post model attributed content :%@",modelOneImage0.attributedContent);
    

    
    XXSharePostModel *modelOneImage = [[XXSharePostModel alloc]init];
    modelOneImage.postType = XXSharePostTypeImageAudio1;
    modelOneImage.postImages = image0;
    modelOneImage.postContent = @"";
    modelOneImage.postAudio = audio;
    modelOneImage.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage];
    
    XXSharePostModel *modelOneImage2 = [[XXSharePostModel alloc]init];
    modelOneImage2.postType = XXSharePostTypeImageAudio2;
    modelOneImage2.postImages = [NSString stringWithFormat:@"%@|%@",image0,image1];
    modelOneImage2.postContent = @"";
    modelOneImage2.postAudio = audio;
    modelOneImage2.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage2 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage2];
    
    XXSharePostModel *modelOneImage3 = [[XXSharePostModel alloc]init];
    modelOneImage3.postType = XXSharePostTypeImageAudio3;
    modelOneImage3.postImages = [NSString stringWithFormat:@"%@|%@|%@",image0,image1,image2];
    modelOneImage3.postContent = @"";
    modelOneImage3.postAudio = audio;
    modelOneImage3.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage3 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage3];
    
    XXSharePostModel *modelOneImage4 = [[XXSharePostModel alloc]init];
    modelOneImage4.postType = XXSharePostTypeImageAudio4;
    modelOneImage4.postImages = [NSString stringWithFormat:@"%@|%@|%@|%@",image0,image1,image2,image3];
    modelOneImage4.postContent = @"";
    modelOneImage4.postAudio = audio;
    modelOneImage4.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelOneImage4 forContentWidth:styleContent];
    [self.sourceArray addObject:modelOneImage4];
    
    
    //image text
    XXSharePostModel *modelTwoImage0 = [[XXSharePostModel alloc]init];
    modelTwoImage0.postType = XXSharePostTypeImageText0;
    modelTwoImage0.postImages = @"";
    modelTwoImage0.postContent = commonContent;
    modelTwoImage0.postAudio = @"";
    modelTwoImage0.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage0 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage0];
    
    XXSharePostModel *modelTwoImage1 = [[XXSharePostModel alloc]init];
    modelTwoImage1.postType = XXSharePostTypeImageText1;
    modelTwoImage1.postImages = [NSString stringWithFormat:@"%@",image0];
    modelTwoImage1.postContent = commonContent;
    modelTwoImage1.postAudio = @"";
    modelTwoImage1.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage1 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage1];
    
    XXSharePostModel *modelTwoImage2 = [[XXSharePostModel alloc]init];
    modelTwoImage2.postType = XXSharePostTypeImageText2;
    modelTwoImage2.postImages = [NSString stringWithFormat:@"%@|%@",image0,image1];
    modelTwoImage2.postContent = commonContent;
    modelTwoImage2.postAudio = @"";
    modelTwoImage2.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage2 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage2];
    
    XXSharePostModel *modelTwoImage3 = [[XXSharePostModel alloc]init];
    modelTwoImage3.postType = XXSharePostTypeImageText3;
    modelTwoImage3.postImages = [NSString stringWithFormat:@"%@|%@|%@",image0,image1,image2];
    modelTwoImage3.postContent = commonContent;
    modelTwoImage3.postAudio = @"";
    modelTwoImage3.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage3 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage3];
    
    XXSharePostModel *modelTwoImage4 = [[XXSharePostModel alloc]init];
    modelTwoImage4.postType = XXSharePostTypeImageText4;
    modelTwoImage4.postImages = [NSString stringWithFormat:@"%@|%@|%@|%@",image0,image1,image2,image3];
    modelTwoImage4.postContent = commonContent;
    modelTwoImage4.postAudio = @"";
    modelTwoImage4.attributedContent = [XXShareBaseCell buildAttributedStringWithSharePost:modelTwoImage4 forContentWidth:styleContent];
    [self.sourceArray addObject:modelTwoImage4];
    
    self.testTable = [[UITableView alloc]init];
//    self.testTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.testTable.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    self.testTable.delegate = self;
    self.testTable.dataSource = self;
//    [self.view addSubview:self.testTable];
    
    DDLogVerbose(@"self.sourceArray --->%@",self.sourceArray);
    
    //test base text view
    XXBaseTextView *baseTextView = [[XXBaseTextView alloc]init];
    baseTextView.frame = CGRectMake(10,30,300,300);
    [self.view addSubview:baseTextView];
    [baseTextView setText:commonContent];

    //test login
    XXUserModel *newUser = [[XXUserModel alloc]init];
    newUser.account = @"22222";
    newUser.password = @"11111";
    [[XXMainDataCenter shareCenter]requestLoginWithNewUser:newUser withSuccessLogin:^(XXUserModel *detailUser) {
        
    } withFaildLogin:^(NSString *faildMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXShareBaseCell *cell = (XXShareBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[XXShareBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSharePostModel:[self.sourceArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XXShareBaseCell heightWithSharePostModel:[self.sourceArray objectAtIndex:indexPath.row] forContentWidth:[XXSharePostStyle sharePostContentWidth]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
