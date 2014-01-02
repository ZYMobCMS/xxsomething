//
//  LoginRoomListViewController.m
//  ZYXMPPDemo
//
//  Created by ZYVincent on 13-12-31.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LoginRoomListViewController.h"
#import "CreateRoomViewController.h"
#import "GroupChatViewController.h"

@interface LoginRoomListViewController ()

@end

@implementation LoginRoomListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //
    roomIDArray = [[NSMutableArray alloc]init];
    UIBarButtonItem *create = [[UIBarButtonItem alloc]initWithTitle:@"create" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewRoom)];
    self.navigationItem.rightBarButtonItem = create;
    
    //
    [[ZYXMPPClient shareClient] setDidRecieveInviteActioon:^(BOOL resultState, NSString *msg) {
       
        if (resultState) {
            
            NSString *message = [NSString stringWithFormat:@"您收到群:[%@]的邀请",msg];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"邀请" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"接受", nil];
            [alert show];
        }
     
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NSRange leftTagRange = [alertView.message rangeOfString:@"["];
        NSRange rightTagRange = [alertView.message rangeOfString:@"]"];
        NSString *roomID = [alertView.message substringWithRange:NSMakeRange(leftTagRange.location+1,rightTagRange.location-leftTagRange.location-1)];
        DDLogVerbose(@"roomID will join >>>>:%@",roomID);
        [[ZYXMPPClient shareClient]joinGroupChatRoomWithRoomId:roomID withNickName:[[ZYXMPPClient shareClient]myNickName]];
        GroupChatViewController *newGroupVC = [[GroupChatViewController alloc]initWithNibName:@"GroupChatViewController" bundle:nil];
        [self.navigationController pushViewController:newGroupVC animated:YES];
        
    }
}
- (void)createNewRoom
{
    CreateRoomViewController *createVC = [[CreateRoomViewController alloc]initWithNibName:@"CreateRoomViewController" bundle:nil];
    createVC.title = @"Create New Room";
    [self.navigationController pushViewController:createVC animated:YES];
    [createVC setFinishBlock:^(ZYXMPPRoomConfig *newRoomConfig) {
        [[ZYXMPPClient shareClient]createGroupChatRoomWithRoomConfig:newRoomConfig];
        GroupChatViewController *newRoomChat = [[GroupChatViewController alloc]initWithNibName:@"GroupChatViewController" bundle:nil];
        newRoomChat.roomConifg = newRoomConfig;
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:newRoomChat animated:YES];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [roomIDArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [roomIDArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
