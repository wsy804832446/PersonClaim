//
//  TabBarViewController.m
//  PersonClaim
//
//  Created by 王晟宇 on 16/9/27.
//  Copyright © 2016年 jingyoutimes. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomePageViewController.h"
#import "ToolViewController.h"
#import "MineViewController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewController];
    // Do any additional setup after loading the view.
}
-(void)loadViewController{
    HomePageViewController *FirstVc = [[HomePageViewController alloc]init];
    FirstVc.title = @"追踪平台";
    FirstVc.tabBarItem.image =[UIImage imageNamed:@"1-我的切图_r6_c1"];
    FirstVc.tabBarItem.selectedImage =[UIImage imageNamed:@"1-我的切图_r2_c1"];
    UINavigationController *one = [[UINavigationController alloc]initWithRootViewController:FirstVc];
    one.navigationBar.translucent = NO;
    ToolViewController *SecondVc = [[ToolViewController alloc]init];
    SecondVc.title = @"工具";
    SecondVc.tabBarItem.image =[UIImage imageNamed:@"1-我的切图_r6_c4"];
    SecondVc.tabBarItem.selectedImage =[UIImage imageNamed:@"1-我的切图_r2_c4"];
    UINavigationController *two = [[UINavigationController alloc]initWithRootViewController:SecondVc];
    two.navigationBar.translucent = NO;
    MineViewController *ThirdVc = [[MineViewController alloc]init];
    ThirdVc.title = @"我的";
    ThirdVc.tabBarItem.image =[UIImage imageNamed:@"1-我的切图_r5_c6"];
    ThirdVc.tabBarItem.selectedImage =[UIImage imageNamed:@"1-我的切图_r1_c6"];
    UINavigationController *three = [[UINavigationController alloc]initWithRootViewController:ThirdVc];
    three.navigationBar.translucent = NO;
    self.viewControllers = @[one,two,three];
    self.selectedIndex = 0;
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
