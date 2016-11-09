//
//  BaseViewController.m
//  KJ
//
//  Created by iOSDeveloper on 16/4/14.
//  Copyright © 2016年 iOSDeveloper. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:pageBackgroundColor];
    // 导航栏设置成不透明的，兼容有导航控制器和没有导航控制器的显示问题
    if (self.navigationController) {
        _frameTopHeight = 64;   //  导航栏+状态栏 = 64
        _viewTop = 0;           //  导航栏设置不透明的所以top = 0
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:Colorblue]];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:Colorwhite],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName,nil]];
        
    } else {
        _frameTopHeight = 20;   //  状态栏 = 20
        _viewTop = 20;          //  没有导航控制器top 需要加上20高度的导航栏，要不然状态栏会被状态栏挡住
    }
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
