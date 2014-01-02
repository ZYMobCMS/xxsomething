//
//  CreateRoomViewController.h
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CreateRoomFinishBlock) (ZYXMPPRoomConfig *newRoomConfig);
@interface CreateRoomViewController : UIViewController
{
    CreateRoomFinishBlock _finishBlock;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
- (IBAction)createAction:(id)sender;
- (void)setFinishBlock:(CreateRoomFinishBlock)finishBlock;
@end
