//
//  RegisterViewController.m
//  IMDemo
//
//  Created by 田耀琦 on 16/11/10.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import "RegisterViewController.h"
#import <Masonry/Masonry.h>
@interface RegisterViewController ()
@property (nonatomic, strong)UITextField *unameTF;
@property (nonatomic, strong)UITextField *passwdTF;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}
- (void)initialUI {
    // 用户名
    UILabel *unameL = [[UILabel alloc] init];
    unameL.text = @"";
    [self.view addSubview:unameL];
    self.unameTF = [[UITextField alloc] init];
    self.unameTF.borderStyle = UITextBorderStyleRoundedRect;
    
    // 密码
    UILabel *passwdL = [[UILabel alloc] init];
    passwdL.text = @"";
    [self.view addSubview:passwdL];
    self.passwdTF = [[UITextField alloc] init];
    self.passwdTF.borderStyle = UITextBorderStyleRoundedRect;
    
    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    
    // frame 布局
    [unameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.top.mas_equalTo(self.view).offset(100);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
    }];
    [self.unameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(unameL.mas_right).offset(5);
        make.centerY.equalTo(unameL.mas_centerY);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(44);
    }];
    [passwdL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unameL.mas_bottom).offset(50);
        make.height.and.width.mas_equalTo(unameL);
    }];
    [self.passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.unameTF.mas_centerY);
        make.height.and.width.mas_equalTo(self.unameTF);
    }];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwdTF.mas_bottom).offset(60);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
