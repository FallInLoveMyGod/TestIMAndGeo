//
//  TabBarViewController.m
//  IMDemo
//
//  Created by 田耀琦 on 16/11/10.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import "TabBarViewController.h"
#import "FirstViewController.h"
#import "SecendViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    //[self addChildViewController:tabBarVC];
    FirstViewController *firstVC = [[FirstViewController alloc] init];
   // [self  addChildViewController:firstVC];
    UINavigationController *firstNaviVC = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    SecendViewController *secendVC = [[SecendViewController alloc] init];
    UINavigationController *secendNaviVC = [[UINavigationController alloc] initWithRootViewController:secendVC];
    firstNaviVC.title = @"聊天";
    secendNaviVC.title = @"地图";
    //设置标签栏字体大小,字体颜色
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:20],
                          NSForegroundColorAttributeName:[UIColor orangeColor],
                          };
    //[firstNaviVC.tabBarItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:dic forState:UIControlStateNormal];

    self.viewControllers = @[firstNaviVC,secendNaviVC];
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
