//
//  InviteOtherViewController.h
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InviteOtherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *toUserAcountTextField;
- (IBAction)sendInviteAction:(id)sender;

@end
