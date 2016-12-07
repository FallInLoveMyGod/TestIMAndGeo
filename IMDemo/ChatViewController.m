//
//  ChatViewController.m
//  IMDemo
//
//  Created by 田耀琦 on 16/11/15.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import "ChatViewController.h"
#import "EMSDK.h"
#define AppWidth [UIScreen mainScreen].bounds.size.width
#define AppHeight [UIScreen mainScreen].bounds.size.height
@interface ChatViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>
{
    NSMutableArray *chatArr;
    UITextField *textV;
    UITableView *_tableV;
    NSInteger _count;
}
@end

@implementation ChatViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    
   // self.tabBarController.tabBar.hidden = YES;
    [textV becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    // 取消接收信息代理
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AppWidth, AppHeight - 108) style:UITableViewStylePlain];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    [self.view addSubview:_tableV];
    if (chatArr.count >= 1) {
        [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.chatter;
    [self initialTextV];
    [self getAllConversationFromChatter:self.chatter];
    
    
    
}
#pragma mark ----- 获取会话 ---------
/*
 *  chatter :   对方聊天单位
 */

- (void)getAllConversationFromChatter:(NSString *)chatter {
   // EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:chatter type:EMConversationTypeChat createIfNotExist:YES];
    // 会话
    chatArr = [NSMutableArray array];
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    //EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:friendID type:EMConversationTypeChat createIfNotExist:YES];
    //_count  =  conversation.unreadMessagesCount;
    NSMutableArray *sortAr = [NSMutableArray array];
    for (EMConversation *conversation in conversations) {
        NSArray *array = [conversation loadMoreMessagesFromId:nil limit:100 direction:EMMessageSearchDirectionUp];
        [sortAr addObjectsFromArray:array];
        
        
    }
    NSArray *arr = [self paixu:sortAr];
    for (EMMessage *message in arr) {
        NSLog(@"message: %@",((EMTextMessageBody *)message.body).text);
        NSString *str = ((EMTextMessageBody *)message.body).text;
        NSLog(@"%@",message.ext);
        [chatArr addObject:str];
        
    }

//    for (EMConversation *conver in conversations) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@",conver];
//        [chatArr addObject:str];
//    }
    
    [_tableV reloadData];
    if (chatArr.count >= 1) {
        [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}
- (NSArray *)paixu:(NSArray *)arr {
    //根据客户端发送/收到此消息的时间按时间进行排序
    NSArray *sortArray = [arr sortedArrayUsingComparator:^NSComparisonResult(EMMessage * obj1, EMMessage * obj2) {
        if(obj1.localTime < obj2.localTime){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedDescending;
        }
    }];
    return sortArray;
}
#pragma mark ------ 创建发送消息框 -------
- (void)initialTextV {

    
    textV=[[UITextField alloc]initWithFrame:CGRectMake(0,AppHeight - 44, AppWidth, 44)];

    [textV setTextColor:[UIColor redColor]];
    [textV.layer setBorderColor:[[UIColor blackColor] CGColor]];
//    [textV setFont:[UIFont systemFontOfSize:15]];
    [textV.layer setBorderWidth:1.0f];
    [textV setDelegate:self];
    [self.view addSubview:textV];
   
    
    
    
    // 当键盘弹出时
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}
// 触发通知
- (void)keyBoardShow:(NSNotification *)notification {
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat moveD = frame.size.height;
    // 获取键盘弹出的时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    [UIView animateWithDuration:animationDuration animations:^{
        textV.frame = CGRectMake(0, AppHeight - 44 - moveD , AppWidth, 44);
        _tableV.frame = CGRectMake(0, 0, AppWidth, AppHeight - 44 - moveD - 64);
        if (chatArr.count >= 1) {
            [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

    }];
}
- (void)keyBoardHide:(NSNotification *)notification {

    
    // 获取键盘弹出的时间
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        textV.frame = CGRectMake(0, AppHeight - 44, AppWidth, 44);
        _tableV.frame = CGRectMake(0, 0, AppWidth, AppHeight - 44 - 64);
    }];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableV) {
        
    }
}
- (void)setUpResignKeyBoradActionView {
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        //在这里做控制
        NSLog(@"return ======== ");
        [self sendMessage];
        return NO;
      
    }
    return YES;
}
- (void)sendMessage {
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textV.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:currentID from:from to:_chatter body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    
    if (textV.text.length != 0) {
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"    fuck   ---- " );
    }];
    [chatArr addObject:textV.text];
        
    [_tableV reloadData];
        
    [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
       
        
        
    }
    textV.text = @"";
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
}
#pragma mark ---- UITableViewDataSource -------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chatArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cee"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cee"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",chatArr[indexPath.row]];
    return cell;
}
#pragma mark ---- EMChatManagerDelegate -----
- (void)didReceiveMessages:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
        NSString *txt = textBody.text;
        NSLog(@"收到的文字是 txt -- %@",txt);
        [chatArr addObject:txt];
        [_tableV reloadData];
         [_tableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    

}
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages {
    NSLog(@ "======");
}
//- (void)conversationListDidUpdate:(NSArray *)aConversationList {
//    [chatArr removeAllObjects];
//    for (EMConversation *cover in aConversationList) {
//        NSString *str = [NSString stringWithFormat:@"%@",cover];
//        [chatArr addObject:str];
//    }
//    [_tableV reloadData];
//}
@end
