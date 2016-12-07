//
//  FirstViewController.m
//  IMDemo
//
//  Created by 田耀琦 on 16/11/10.
//  Copyright © 2016年 田耀琦. All rights reserved.
//
/*
 * IM 即时通讯
 */
#import "FirstViewController.h"
#import "ChatViewController.h"

#define witdth self.view.frame.size.width
#define height self.view.frame.size.height
@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource,EMContactManagerDelegate>
{
    // 好友列表
    UITableView *contactTableView;
    NSMutableArray *listArr;
}
@end
/*
 *    测试帐号 1001   和   8001
 */



@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerAndLogin];
   // [self initialContactTableVeiw];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"加好友" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    

}
- (void)setbadge:(NSString *)contactID {
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:contactID type:EMConversationTypeChat createIfNotExist:YES];
    NSInteger num = conversation.unreadMessagesCount;
    
}
// 注册并登录 成功后获取好友列表
- (void)registerAndLogin {
    EMError *error = [[EMClient sharedClient] registerWithUsername:currentID password:@"111111"];
    if (error==nil) {
        NSLog(@"注册成功");
        EMError *error = [[EMClient sharedClient] loginWithUsername:currentID password:@"111111"];
        if (!error) {
            NSLog(@"登录成功");
            EMError *error = nil;
            NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
            listArr = [NSMutableArray arrayWithArray:userlist];
            if (!error) {
                NSLog(@"获取成功 -- %@",listArr);
                for (NSString *contactID in listArr) {
                     [self setbadge:contactID];
                }
                [self initialContactTableVeiw];

            }
        }
        
    } else if([error.errorDescription isEqualToString:@"User already exist"]) {
        EMError *error = [[EMClient sharedClient] loginWithUsername:currentID password:@"111111"];
        if (!error) {
            NSLog(@"登录成功");
            EMError *error = nil;
            NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
            listArr = [NSMutableArray arrayWithArray:userlist];
            if (!error) {
                NSLog(@"获取成功 -- %@",userlist);
                [self initialContactTableVeiw];
            }
        }

    }

}


// 重连
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState {
    
}
#pragma mark ------ contactTableView ---
- (void)initialContactTableVeiw {
    contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, witdth, height - 64) style:UITableViewStylePlain];
    contactTableView.delegate = self;
    contactTableView.dataSource = self;
    [self.view addSubview:contactTableView];
    
}
#pragma mark ---- UITableViewDataSource ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   {
    return listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aa"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aa"];
    }
    cell.textLabel.text = listArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击好友
    
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.chatter = listArr[indexPath.row];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

// 添加好友
- (void)rightBarButtonAction {
    for (NSString *userID in listArr) {
        if ([userID isEqualToString:addID]) {
            NSLog(@"添加联系人已经是您的好友");
            return;
        }
    }
    EMError *error = [[EMClient sharedClient].contactManager addContact:addID message:@"我想加您为好友"];
    
    if (!error) {
        NSLog(@"添加成功");
        EMError *error = nil;
        NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        listArr = [NSMutableArray arrayWithArray:userlist];
        if (!error) {
            NSLog(@"获取成功 -- %@",listArr);
            [contactTableView reloadData];
        }
        return;
    }
    NSLog(@"error == %@",error.description);
}
- (void)viewWillAppear:(BOOL)animated {
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
}

// 监听收到好友请求
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage {
    NSLog(@"userName == %@,message == %@",aUsername,aMessage);
    // 同意或者不同意
//    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:@"1001"];
//    if (!error) {
//        NSLog(@"发送同意成功");
//        [listArr addObject:aUsername];
//        [contactTableView reloadData];
//    }
    [self alertControllerWithTitle:@"好友请求" message:@"是否同意"];
    
}
- (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:addID];
        if (!error) {
            EMError *error = nil;
            NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
            listArr = [NSMutableArray arrayWithArray:userlist];
            if (!error) {
                NSLog(@"获取成功 -- %@",listArr);
                [contactTableView reloadData];
            }

            NSLog(@"发送同意成功");
            
            
            
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:addID];
        if (!error) {
            NSLog(@"拒绝🏠好友");
        }
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:NO completion:nil];
}

- (void)didReceiveAgreedFromUsername:(NSString *)aUsername {
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    listArr = [NSMutableArray arrayWithArray:userlist];
    if (!error) {
        NSLog(@"获取成功 -- %@",listArr);
        [contactTableView reloadData];
    }
    
    NSLog(@"发送同意成功");
}
@end
